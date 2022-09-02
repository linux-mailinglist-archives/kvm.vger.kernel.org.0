Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261635AB700
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 18:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiIBQ6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 12:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236788AbiIBQ62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 12:58:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392CD10952A
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 09:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F24E5B82C73
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 16:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA65C433D7;
        Fri,  2 Sep 2022 16:58:22 +0000 (UTC)
Date:   Fri, 2 Sep 2022 17:58:19 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v3 4/7] arm64: mte: Lock a page for MTE tag initialisation
Message-ID: <YxI2KzTxnCP2vKDo@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-5-pcc@google.com>
 <e72fee25-5ece-76f5-db53-dafa1fef6054@arm.com>
 <YxIvP+a2P0DGIUrA@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxIvP+a2P0DGIUrA@arm.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 05:28:47PM +0100, Catalin Marinas wrote:
> On Fri, Sep 02, 2022 at 03:47:33PM +0100, Steven Price wrote:
> > On 10/08/2022 20:30, Peter Collingbourne wrote:
> > > diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
> > > index a78c1db23c68..cd5ad0936e16 100644
> > > --- a/arch/arm64/mm/mteswap.c
> > > +++ b/arch/arm64/mm/mteswap.c
> > > @@ -53,6 +53,9 @@ bool mte_restore_tags(swp_entry_t entry, struct page *page)
> > >  	if (!tags)
> > >  		return false;
> > >  
> > > +	/* racing tag restoring? */
> > > +	if (!try_page_mte_tagging(page))
> > > +		return false;
> > >  	mte_restore_page_tags(page_address(page), tags);
> > 
> > I feel like adding a "set_page_mte_tagged(page);" in here would avoid
> > the need for the comments about mte_restore_tags() taking the lock.
> 
> Good point. I think I blindly followed the set_bit() places but it makes
> sense to move the bit setting to mte_restore_tags().

Something like this (and I need to do some more testing):

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index b956899467f0..be6560e1ff2b 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -25,7 +25,7 @@ unsigned long mte_copy_tags_to_user(void __user *to, void *from,
 				    unsigned long n);
 int mte_save_tags(struct page *page);
 void mte_save_page_tags(const void *page_addr, void *tag_storage);
-bool mte_restore_tags(swp_entry_t entry, struct page *page);
+void mte_restore_tags(swp_entry_t entry, struct page *page);
 void mte_restore_page_tags(void *page_addr, const void *tag_storage);
 void mte_invalidate_tags(int type, pgoff_t offset);
 void mte_invalidate_tags_area(int type);
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e6b82ad1e9e6..7d91379382fd 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1049,9 +1049,8 @@ static inline void arch_swap_invalidate_area(int type)
 #define __HAVE_ARCH_SWAP_RESTORE
 static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
-	/* mte_restore_tags() takes the PG_mte_lock */
-	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
-		set_page_mte_tagged(&folio->page);
+	if (system_supports_mte())
+		mte_restore_tags(entry, &folio->page);
 }
 
 #endif /* CONFIG_ARM64_MTE */
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 634e089b5933..54ab6c4741db 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -41,11 +41,8 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	if (check_swap && is_swap_pte(old_pte)) {
 		swp_entry_t entry = pte_to_swp_entry(old_pte);
 
-		/* mte_restore_tags() takes the PG_mte_lock */
-		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
-			set_page_mte_tagged(page);
-			return;
-		}
+		if (!non_swap_entry(entry))
+			mte_restore_tags(entry, page);
 	}
 
 	if (!pte_is_tagged)
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index cd5ad0936e16..cd508ba80ab1 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -46,19 +46,17 @@ int mte_save_tags(struct page *page)
 	return 0;
 }
 
-bool mte_restore_tags(swp_entry_t entry, struct page *page)
+void mte_restore_tags(swp_entry_t entry, struct page *page)
 {
 	void *tags = xa_load(&mte_pages, entry.val);
 
 	if (!tags)
-		return false;
+		return;
 
-	/* racing tag restoring? */
-	if (!try_page_mte_tagging(page))
-		return false;
-	mte_restore_page_tags(page_address(page), tags);
-
-	return true;
+	if (try_page_mte_tagging(page)) {
+		mte_restore_page_tags(page_address(page), tags);
+		set_page_mte_tagged(page);
+	}
 }
 
 void mte_invalidate_tags(int type, pgoff_t offset)
