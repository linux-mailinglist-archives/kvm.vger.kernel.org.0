Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945F950FC29
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 13:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349627AbiDZLr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 07:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348851AbiDZLrY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 07:47:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02293C4A8
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 04:44:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B56151F388;
        Tue, 26 Apr 2022 11:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1650973454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PLzzE1pbfZ+l3OWHffWvEpX36LmDFWDMYpXuIaMDbok=;
        b=YTbQtrhudRaSuttJ2K+qzCKSEih72V6SKY50SDPDm0xcILQoIeqTYETQUDOhOe9RHzDti0
        77hGDgFO7vzAV11xfDp9jngHm+j3lCfvdC3hHQUVAd9TN1X6qTCb8A6jZV8GP+P4taKl5e
        sfjuk+g/apH9YdA35O9q6Scdpc2VXtg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1AFAF13223;
        Tue, 26 Apr 2022 11:44:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6MqsBA7bZ2K/egAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Tue, 26 Apr 2022 11:44:14 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 06/11] x86: efi: Provide a stack within testcase memory
Date:   Tue, 26 Apr 2022 13:43:47 +0200
Message-Id: <20220426114352.1262-7-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220426114352.1262-1-varad.gautam@suse.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UEFI test builds currently use the stack pointer configured by the
UEFI implementation.

Reserve stack space in .data for EFI testcases and switch %rsp to
use this memory on early boot. This provides one 4K page per CPU
to store its stack.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 x86/efi/crt0-efi-x86_64.S | 3 +++
 x86/efi/efistart64.S      | 6 ++++++
 2 files changed, 9 insertions(+)

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
index b94c5ab..3a4135e 100644
--- a/x86/efi/efistart64.S
+++ b/x86/efi/efistart64.S
@@ -4,7 +4,13 @@
 #include "asm-generic/page.h"
 #include "crt0-efi-x86_64.S"
 
+
+/* Reserve stack in .data */
 .data
+.align PAGE_SIZE
+	. = . + PAGE_SIZE * MAX_TEST_CPUS
+.globl stacktop
+stacktop:
 
 .align PAGE_SIZE
 .globl ptl2
-- 
2.32.0

