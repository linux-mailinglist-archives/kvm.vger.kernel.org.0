Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928194F63D3
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 17:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbiDFPmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbiDFPll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:41:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243C43ED985
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 05:58:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7AB20210F4;
        Wed,  6 Apr 2022 12:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649248797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9mbjXaGNcUpVUJZqcZeqthHEqPAYzBSqmaYcs1QWZfo=;
        b=kNwYOu8uOCnpjySP4lqsXYUtDZSFFUekxCLDCXMsT1cb64QbzEK1k6UAE87N8qmN7x4C/z
        DAxymzXqaVRpaLTwN2/VBkjRlDE/xsZgl+ZkQp33lr9+SNftCfmsDAsQDeEr87a0T99qZa
        Sewerfh9vZFFpHqJB9F8OjLXGO02mTg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3738613A8E;
        Wed,  6 Apr 2022 12:39:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 90mGCx2KTWKgaAAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Wed, 06 Apr 2022 12:39:57 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, jroedel@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH] x86: cstart64: Serialize ap_start64 with a spin lock
Date:   Wed,  6 Apr 2022 14:40:02 +0200
Message-Id: <20220406124002.13741-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ap_start64 serves as the 64-bit entrypoint for APs during bringup.

Since apic.c:apic_ops is not guarded against concurrent accesses,
there exists a race between reset_apic(), enable_apic() and
enable_x2apic() which results in APs crashing or getting blocked
in various scenarios (eg, enabling x2apic while disabling xapic).

The bug is rare with vcpu count < 32, but becomes easier to
reproduce with vcpus > 64 and the following thunk:

lib/x86/apic.c:
 void enable_apic(void)
 {
-    printf("enabling apic\n");
     xapic_write(APIC_SPIV, 0x1ff);
 }

Serialize the bringup code in ap_start64 to fix this.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/cstart64.S | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 7272452..238cebf 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -45,6 +45,9 @@ mb_boot_info:	.quad 0
 
 pt_root:	.quad ptl4
 
+ap_lock:
+	.long 0
+
 .section .init
 
 .code32
@@ -188,12 +191,18 @@ save_id:
 	retq
 
 ap_start64:
+.retry:
+	xor %eax, %eax
+	lock btsl %eax, ap_lock
+	jc .retry
 	call reset_apic
 	load_tss
 	call enable_apic
 	call save_id
 	call enable_x2apic
 	sti
+	xor %eax, %eax
+	lock btr %eax, ap_lock
 	nop
 	lock incw cpu_online_count
 
-- 
2.35.1

