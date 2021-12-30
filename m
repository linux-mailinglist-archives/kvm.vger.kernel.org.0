Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B55481FFB
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 20:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241856AbhL3TqB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 14:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240410AbhL3TqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 14:46:01 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C01C061574
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 11:46:01 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 200so22217985pgg.3
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 11:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SSv7+eW+5rb6ctufcvm45xC/oNc4xjIbljO0x/RtzOU=;
        b=gN3IhbGgjqJ1Z7FKEniA+ftsJK2fXR/ZfOh1xON8D8zybp6rVWmXnz4KpuggFQIG9y
         5Kmhl0UEGLQxEbS6yMCud6PJZR0VV9zsF/Exo+eo1Qjlk5tKIVn8eiw/wEcQ97pgCp/7
         uf1eSNUh4K2hQfNsa4CU5tS1RcaaG6U8j9K2cuD6QFyEa8IdtYRL7dtZ34C05+Q3PVfr
         DMLw7q4o6sVNmZbSCHE2TdyjTJC5QoF7KOfwYaOB5W7+iSbXVH5ANYfA8vDNTNSfKQkk
         Dozb7nN1VPjHFTsJV8LbT0PPrvUXHqrrMB7G1BK7KIFQaoZhDiWZvGDYbaOkcMrtg8+0
         5wQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SSv7+eW+5rb6ctufcvm45xC/oNc4xjIbljO0x/RtzOU=;
        b=rz+kSYk8aBW4SilctgoifqgKCqYI9CpXIQiMe+/hcj7O56yJqv769fszrJ46BvOdrI
         b+Z/50OGTkywGbmP/xbbQ1r1HX4PZdgRJihFe0+RzKX0jhLyXRRMr8OCcFuGBoytGREh
         /b15IcewMsJ9sVP0FXzuY6QsFuGju9WMSgmn9gejRWU9rWjFnnsHw1xuPcjvsyq2la10
         LuZinZOTfJeDfEvhNQ1GZHDzStZjXlC6jh3C3X1I28hShOfBme0wDVTDMe0Xf22v8JtA
         XuFJty9uyNZOy/mfbm2kwTko49XY494GYDrpb1191fM+Gf9WM1nEavKeC1pFJ0ke0G4M
         AbGg==
X-Gm-Message-State: AOAM530T+Zosxbz2c31jDfu14wLNM80dTjwZ28psqDHDLrN73azfXvlq
        BC30nKeUjP+dmT2/mbUHCzk1jg==
X-Google-Smtp-Source: ABdhPJzzclyRHQDfHvRvsZwsyUuzImkT7Z6KSZUcIcPdvMc0Stk+mbpQag6OFzQJCD9h2IBLQyVEEQ==
X-Received: by 2002:a63:8342:: with SMTP id h63mr29243410pge.443.1640893560420;
        Thu, 30 Dec 2021 11:46:00 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x25sm25440480pfu.113.2021.12.30.11.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 11:45:59 -0800 (PST)
Date:   Thu, 30 Dec 2021 19:45:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/4] KVM: arm64/mmu: use gfn_to_pfn_page
Message-ID: <Yc4MdFREYW98mzMs@google.com>
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-4-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129034317.2964790-4-stevensd@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021, David Stevens wrote:
> @@ -1142,14 +1146,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	/* Mark the page dirty only if the fault is handled successfully */
>  	if (writable && !ret) {
> -		kvm_set_pfn_dirty(pfn);
> +		if (page)
> +			kvm_set_pfn_dirty(pfn);

If kvm_set_page_dirty() is changed to be less dumb:

		if (page)
			kvm_set_page_dirty(page);

>  		mark_page_dirty_in_slot(kvm, memslot, gfn);
>  	}
>  
>  out_unlock:
>  	spin_unlock(&kvm->mmu_lock);
> -	kvm_set_pfn_accessed(pfn);
> -	kvm_release_pfn_clean(pfn);
> +	if (page) {
> +		kvm_set_pfn_accessed(pfn);
> +		put_page(page);

Oof, KVM's helpers are stupid.  Take a page, convert it to a pfn, then convert it
back to a page, just to mark it dirty or put a ref.  Can you fold the below 
(completely untested) patch in before the x86/arm64 patches?  That way this code
can be:

	if (page)
		kvm_release_page_accessed(page);

and x86 can do:

	if (fault->page)
		kvm_release_page_clean(page);

instead of open-coding put_page().


From a8af0c60d7f6e77bbc7310d898211c43ae075cf8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Dec 2021 11:40:58 -0800
Subject: [PATCH] KVM: Clean up and enhance helpers for releasing pages/pfns

Tweak kvm_release_page_clean() and kvm_release_page_dirty() to avoid
pointlessly converting to a pfn and back to a page, and add an "accessed"
variant that will be used in a future arm64 patch.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8eb0f762a82c..f75129f641e9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2876,29 +2876,37 @@ void kvm_release_page_clean(struct page *page)
 {
 	WARN_ON(is_error_page(page));

-	kvm_release_pfn_clean(page_to_pfn(page));
+	put_page(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_clean);

 void kvm_release_pfn_clean(kvm_pfn_t pfn)
 {
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn))
-		put_page(pfn_to_page(pfn));
+		kvm_release_page_clean(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);

+void kvm_release_page_accessed(struct page *page)
+{
+	mark_page_accessed(page);
+
+	kvm_release_page_clean(page);
+}
+EXPORT_SYMBOL_GPL(kvm_release_page_accessed);
+
 void kvm_release_page_dirty(struct page *page)
 {
-	WARN_ON(is_error_page(page));
+	SetPageDirty(page);

-	kvm_release_pfn_dirty(page_to_pfn(page));
+	kvm_release_page_clean(page);
 }
 EXPORT_SYMBOL_GPL(kvm_release_page_dirty);

 void kvm_release_pfn_dirty(kvm_pfn_t pfn)
 {
-	kvm_set_pfn_dirty(pfn);
-	kvm_release_pfn_clean(pfn);
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
+		kvm_release_page_dirty(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);

--
2.34.1.448.ga2b2bfdf31-goog
