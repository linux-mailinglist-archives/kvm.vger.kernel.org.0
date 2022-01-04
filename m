Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CD1484987
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 21:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbiADUzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 15:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbiADUzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 15:55:07 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F45C061761
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 12:55:07 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c2so33260527pfc.1
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 12:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OX8TnGGp+Sau0fCZ9YjFewph+wIKfyabwC9wDq4Uvyg=;
        b=Iz3EAtsohSdfNjculbq93U5enP/6Sfl+Te4d/bMffastpeSdA2tgElC8n2tB1xILcs
         XjpC3K9kBYtbTOoLs++Z1qdFM29DVsm1pcHoo9wmvmloeorZsn/4e7+5JRjaf1EfhorO
         g7voV4uLSpTahpdpewVy8bh0lj3m7XV+dNTzdzpWIczgKAi5wkXUxgk5JR1crlF+6YHM
         qhYVn0DLhXaxhraSzwtTs8Wp3VBjj6ubKM4fswr3BxZyNYHUVC0k3H/84GxntT9ngRVo
         fKHu9BqjrZYrl5xhSV4auovW1g4p10hl13y8PUBaE/f7gZaOfkXYDE7ix5Ar3Zm3YEie
         AY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OX8TnGGp+Sau0fCZ9YjFewph+wIKfyabwC9wDq4Uvyg=;
        b=hZrAgWmoAmpyYsrO0DsJ5SK99Syiu5HHvOfCC0C49ZAlrAxWeeVtLKrLjZi+fnV1zp
         OP5YgrzPq1QvQlnOPHMND/XH4UASSdpsMIsCcoil1RdrNMtgizKlXDKsDNcutNUXFHHL
         +tlgsTqDkuYARApXghJhtXa/4DfII5OEEHnxZDtCHggTVNXrxp/pTqlrAYl1nKPVsZR+
         tal+FH7TfY9TvxtWhoGTgO+ScdWG5Qlnfa0Ex5Q7y46CZO/V9DIG78t7CuZoXEY+hOeN
         1tz94c7mEJS1gJ0CLWQk6E12vBRABSFhlShNMyn8TOFo85me0kgYVSkb4blnjXssFimm
         hj2Q==
X-Gm-Message-State: AOAM533F9QGKSdVoFI2AwTdTlbwXjIaeaO1j8znsA9d9VgtsiGv/QDsZ
        84DtOg9YphBU3HbTCjMpGMZY4w==
X-Google-Smtp-Source: ABdhPJwlegmwapfHfVMD2Qt0rG5au5EwXr34rL2iOSS/REQFWPwiujRf96ZM3jUy1eBJ8gZjC1Pv6g==
X-Received: by 2002:a63:3718:: with SMTP id e24mr30213351pga.16.1641329707106;
        Tue, 04 Jan 2022 12:55:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b13sm40897834pfo.37.2022.01.04.12.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 12:55:06 -0800 (PST)
Date:   Tue, 4 Jan 2022 20:55:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 6/6] KVM: X86: Use level_promoted and pae_root shadow
 page for 32bit guests
Message-ID: <YdS0J1mmpYmD4KcL@google.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-7-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210092508.7185-7-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Lai Jiangshan wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 476b133544dd..822ff5d76b91 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -100,13 +100,8 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>  	if (WARN_ON(!VALID_PAGE(hpa)))
>  		return false;
>  
> -	/*
> -	 * A NULL shadow page is legal when shadowing a non-paging guest with
> -	 * PAE paging, as the MMU will be direct with root_hpa pointing at the
> -	 * pae_root page, not a shadow page.
> -	 */
>  	sp = to_shadow_page(hpa);
> -	return sp && is_tdp_mmu_page(sp) && sp->root_count;
> +	return is_tdp_mmu_page(sp) && sp->root_count;
>  }

is_page_fault_stale() can get similar treatment

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e8c69c2dfbd9..9ff8e228b55e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3855,19 +3855,7 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
 {
        struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root_hpa);

-       /* Special roots, e.g. pae_root, are not backed by shadow pages. */
-       if (sp && is_obsolete_sp(vcpu->kvm, sp))
-               return true;
-
-       /*
-        * Roots without an associated shadow page are considered invalid if
-        * there is a pending request to free obsolete roots.  The request is
-        * only a hint that the current root _may_ be obsolete and needs to be
-        * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
-        * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
-        * to reload even if no vCPU is actively using the root.
-        */
-       if (!sp && kvm_test_request(KVM_REQ_MMU_RELOAD, vcpu))
+       if (is_obsolete_sp(vcpu->kvm, sp))
                return true;

        return fault->slot &&

>  #else
>  static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
> -- 
> 2.19.1.6.gb485710b
> 
