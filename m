Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33E4FE717
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346023AbiDLRfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358281AbiDLRfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:35:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1884580C5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:32:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A5B381F859;
        Tue, 12 Apr 2022 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649784746; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iZzCdYtvFcZR50a4J5LCpvyULpVwo2Z9H1VXfFAXa4E=;
        b=ayGfVnNhAmrTN2yX9qW1ZMuFvEVWyOVrEYUPEDh4CXlqz5s19MJwBbChB32wSTPUlMtJ5h
        SfhU/OOCqStBa6Ee2PEq+4o2H0zhxYC1xb83bv5k51MMwVa18yQ58jCD0/7rAMs10I5xLh
        BRHFaNIZH0+ARfYeWl/qLGz/64YLMIM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1BFF713780;
        Tue, 12 Apr 2022 17:32:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QASoBKq3VWJJewAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 12 Apr 2022 17:32:26 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [PATCH 05/10] x86: efi: Stop using UEFI-provided stack
Date:   Tue, 12 Apr 2022 19:32:16 +0200
Message-Id: <20220412173221.13315-5-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220412173221.13315-1-varad.gautam@suse.com>
References: <20220412173221.13315-1-varad.gautam@suse.com>
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

UEFI test builds currently use the stack pointer configured by the
UEFI implementation.

Reserve stack space in .data for EFI testcases and switch %rsp to
use this memory on early boot. This provides one 4K page per CPU
to store its stack / percpu data.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/efi/crt0-efi-x86_64.S | 3 +++
 x86/efi/efistart64.S      | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/x86/efi/crt0-efi-x86_64.S b/x86/efi/crt0-efi-x86_64.S
index eaf1656..1708ed5 100644
--- a/x86/efi/crt0-efi-x86_64.S
+++ b/x86/efi/crt0-efi-x86_64.S
@@ -58,6 +58,9 @@ _start:
 	popq %rdi
 	popq %rsi
 
+	/* Switch away from EFI stack. */
+	lea stacktop(%rip), %rsp
+
 	call efi_main
 	addq $8, %rsp
 
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
index 8eadca5..cb08230 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -6,6 +6,14 @@
 
 .data
 
+max_cpus = MAX_TEST_CPUS
+
+/* Reserve stack in .data */
+	. = . + 4096 * max_cpus
+	.align 16
+.globl stacktop
+stacktop:
+
 .align PAGE_SIZE
 .globl ptl2
 ptl2:
-- 
2.35.1

