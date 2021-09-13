Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB491408889
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 11:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbhIMJvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 05:51:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238844AbhIMJvN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 05:51:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631526597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+1bv9QcK5HvBzLB3qEFqROC0U78MN+GMph+aN6BbYd0=;
        b=KX0qOhSNQTbplsAuiFiRehlFcm0sKB+4HUmMoCSmKOOUJcy1H3GPHwmpx6pzrvqfxNaQAl
        kjPFWihK0ekzEqmpdykUlkCZEYmOVLgT1Q2La5uSAaaNJD/DBug2XhUXWb+NMK6ZXqPKSB
        Ft2iQfEBe13PtfNC5VJXd+IGDGl3bOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-mweGgRW0NlWoOHscwxk0-Q-1; Mon, 13 Sep 2021 05:49:56 -0400
X-MC-Unique: mweGgRW0NlWoOHscwxk0-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F9B7824FA7;
        Mon, 13 Sep 2021 09:49:54 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 277F36D984;
        Mon, 13 Sep 2021 09:49:49 +0000 (UTC)
Message-ID: <8cac80a9aa0bcb2a636d9ee0ac633f6215843677.camel@redhat.com>
Subject: Re: [PATCH 4/7] KVM: X86: Remove FNAME(update_pte)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Date:   Mon, 13 Sep 2021 12:49:48 +0300
In-Reply-To: <20210824075524.3354-5-jiangshanlai@gmail.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
         <20210824075524.3354-5-jiangshanlai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-08-24 at 15:55 +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Its solo caller is changed to use FNAME(prefetch_gpte) directly.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/mmu/paging_tmpl.h | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 48c7fe1b2d50..6b2e248f2f4c 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -589,14 +589,6 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	return true;
>  }
>  
> -static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> -			      u64 *spte, const void *pte)
> -{
> -	pt_element_t gpte = *(const pt_element_t *)pte;
> -
> -	FNAME(prefetch_gpte)(vcpu, sp, spte, gpte, false);
> -}
> -
>  static bool FNAME(gpte_changed)(struct kvm_vcpu *vcpu,
>  				struct guest_walker *gw, int level)
>  {
> @@ -998,7 +990,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
>  						       sizeof(pt_element_t)))
>  				break;
>  
> -			FNAME(update_pte)(vcpu, sp, sptep, &gpte);
> +			FNAME(prefetch_gpte)(vcpu, sp, sptep, gpte, false);
>  		}
>  
>  		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

