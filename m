Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7004C188C
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbiBWQYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242776AbiBWQYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:24:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83BD5C6207
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 08:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645633416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9U9rkuO2bolwkHdw3nY/IEJQpPObMMMMNdsd4vCKfbY=;
        b=TpqlMV3mKwaVjB6q3tR9hkmj5rmIuvWRy89gofKgKFduBrv7m6IbWuV14C0FuX+37BT5eU
        pDjrXmzeafm40BmR1pcz3vF5gTVWFhz784pj6Mxd2jrmJccT2/Wknwgh9/sX7KNk7sVsXS
        83vmYTNrWPUCdls7oYhjPWW53jPctCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-L947scH0ObmjMJ8RvUwf9A-1; Wed, 23 Feb 2022 11:23:34 -0500
X-MC-Unique: L947scH0ObmjMJ8RvUwf9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECB89805741;
        Wed, 23 Feb 2022 16:23:33 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C8FC866F8;
        Wed, 23 Feb 2022 16:23:29 +0000 (UTC)
Message-ID: <9bab1e3528990ad6122d48bcc17648806cc1dd8b.camel@redhat.com>
Subject: Re: [PATCH v2 11/18] KVM: x86/mmu: Always use current mmu's role
 when loading new PGD
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 23 Feb 2022 18:23:28 +0200
In-Reply-To: <20220217210340.312449-12-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-12-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> Since the guest PGD is now loaded after the MMU has been set up
> completely, the desired role for a cache hit is simply the current
> mmu_role.  There is no need to compute it again, so __kvm_mmu_new_pgd
> can be folded in kvm_mmu_new_pgd.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 29 ++++-------------------------
>  1 file changed, 4 insertions(+), 25 deletions(-)

https://www.monkeyuser.com/2020/levels-of-satisfaction/ ;-)

> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 906a9244ad28..b01160716c6a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -190,8 +190,6 @@ struct kmem_cache *mmu_page_header_cache;
>  static struct percpu_counter kvm_total_used_mmu_pages;
>  
>  static void mmu_spte_set(u64 *sptep, u64 spte);
> -static union kvm_mmu_page_role
> -kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
>  
>  struct kvm_mmu_role_regs {
>  	const unsigned long cr0;
> @@ -4191,10 +4189,10 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
>  		return cached_root_find_without_current(kvm, mmu, new_pgd, new_role);
>  }
>  
> -static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
> -			      union kvm_mmu_page_role new_role)
> +void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +	union kvm_mmu_page_role new_role = mmu->mmu_role.base;
>  
>  	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
>  		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
> @@ -4230,11 +4228,6 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  		__clear_sp_write_flooding_count(
>  				to_shadow_page(vcpu->arch.mmu->root.hpa));
>  }
> -
> -void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
> -{
> -	__kvm_mmu_new_pgd(vcpu, new_pgd, kvm_mmu_calc_root_page_role(vcpu));
> -}
>  EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
>  
>  static unsigned long get_cr3(struct kvm_vcpu *vcpu)
> @@ -4904,7 +4897,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>  	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
>  
>  	shadow_mmu_init_context(vcpu, context, &regs, new_role);
> -	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
> +	kvm_mmu_new_pgd(vcpu, nested_cr3);
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
>  
> @@ -4960,7 +4953,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  		reset_ept_shadow_zero_bits_mask(context, execonly);
>  	}
>  
> -	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
> +	kvm_mmu_new_pgd(vcpu, new_eptp);
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
>  
> @@ -5045,20 +5038,6 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_init_mmu);
>  
> -static union kvm_mmu_page_role
> -kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
> -{
> -	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
> -	union kvm_mmu_role role;
> -
> -	if (tdp_enabled)
> -		role = kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, true);
> -	else
> -		role = kvm_calc_shadow_mmu_root_page_role(vcpu, &regs, true);
> -
> -	return role.base;
> -}
> -
>  void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	/*

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


