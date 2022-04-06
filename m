Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488614F628C
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 17:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiDFPJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiDFPJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:09:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3533666ED7
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 05:34:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 721AF1F7AE;
        Wed,  6 Apr 2022 12:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649248401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=J7BDF7sGW2lP0vjiYMes2nAvm/vogbkKCy8WkLmxsjQ=;
        b=RTHdOlHqaRPO/rp7dNKXPAwIFtr4WsFpMpjHTExv/h1CxhRIYG2z0cgyhuoJxqk4MmTEBf
        eK+lFRujGPOnJnm4AueYln92vuwipDDu1DNgnoJJC/BukXx0ftHclvu7/NfakEMo6P548m
        mNNjHB8MNgDGAtMdC8NmUcDgLAHjGEc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 27EC913A8E;
        Wed,  6 Apr 2022 12:33:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Sz6QB5GITWKBZQAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Wed, 06 Apr 2022 12:33:21 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, jroedel@suse.de
Subject: [kvm-unit-tests PATCH] x86: efi: Fix pagetable creation
Date:   Wed,  6 Apr 2022 14:33:12 +0200
Message-Id: <20220406123312.12986-1-varad.gautam@suse.com>
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

setup_page_table() ends up filling invalid page table entries
at ptl2 due to improper typecasting. This sometimes leads to
unhandled pagefaults when writing to APIC registers. Fix it.

Fixes: e6f65fa464 ("x86 UEFI: Set up page tables")
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index bbd3468..7bc7c93 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -258,7 +258,7 @@ static void setup_page_table(void)
 	curr_pt = (pgd_t *)&ptl2;
 	flags |= PT_ACCESSED_MASK | PT_DIRTY_MASK | PT_PAGE_SIZE_MASK | PT_GLOBAL_MASK;
 	for (i = 0; i < 4 * 512; i++)	{
-		curr_pt[i] = ((phys_addr_t)(i << 21)) | flags;
+		curr_pt[i] = ((phys_addr_t) i << 21) | flags;
 	}
 
 	if (amd_sev_es_enabled()) {
-- 
2.32.0

