Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996ED1F9CB0
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgFOQKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 12:10:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21156 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730431AbgFOQKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 12:10:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592237453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gO0KIzYd49wn9s7qVa6jSasKGeMas6UA1ZI/tcFRyJ0=;
        b=dwu4BoZbKEeJlIN/Yse424GWqVHib3V0fXb07ayK0xKTmHf1mGfVCVZgrFw744tOOe/KGp
        7nBzG1GDQyA5bbBKWhnc7a7WEl9d5cZvgwXHtaJvB6poM4dHYca1EUXmGu1utnDYXpcgAW
        ZfeZJrl+j2SYCzfai16ImEcfwzoCrRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-imWPGdcsOC62zydqkXShdg-1; Mon, 15 Jun 2020 12:10:16 -0400
X-MC-Unique: imWPGdcsOC62zydqkXShdg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 457689D6DB4;
        Mon, 15 Jun 2020 16:02:25 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-2.rdu2.redhat.com [10.10.115.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE1405C1C3;
        Mon, 15 Jun 2020 16:02:24 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4D5FA220628; Mon, 15 Jun 2020 12:02:24 -0400 (EDT)
Date:   Mon, 15 Jun 2020 12:02:24 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: async_pf: change
 kvm_setup_async_pf()/kvm_arch_setup_async_pf() return type to bool
Message-ID: <20200615160224.GG351167@redhat.com>
References: <20200615121334.91300-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615121334.91300-1-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 02:13:34PM +0200, Vitaly Kuznetsov wrote:
> Unlike normal 'int' functions returning '0' on success, kvm_setup_async_pf()/
> kvm_arch_setup_async_pf() return '1' when a job to handle page fault
> asynchronously was scheduled and '0' otherwise. To avoid the confusion
> change return type to 'bool'.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Looks good to me. Nobody checks the error from kvm_arch_setup_async_pf().
Callers only seem to care about success or failure at this point of time,
and they fall back to synchorounous page fault upon failure. This 
could be changed back once somebody needs specific error code.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  arch/s390/kvm/kvm-s390.c | 20 +++++++++-----------
>  arch/x86/kvm/mmu/mmu.c   |  4 ++--
>  include/linux/kvm_host.h |  4 ++--
>  virt/kvm/async_pf.c      | 16 ++++++++++------
>  4 files changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index d47c19718615..7fd4fdb165fc 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3954,33 +3954,31 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu)
> +static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu)
>  {
>  	hva_t hva;
>  	struct kvm_arch_async_pf arch;
> -	int rc;
>  
>  	if (vcpu->arch.pfault_token == KVM_S390_PFAULT_TOKEN_INVALID)
> -		return 0;
> +		return false;
>  	if ((vcpu->arch.sie_block->gpsw.mask & vcpu->arch.pfault_select) !=
>  	    vcpu->arch.pfault_compare)
> -		return 0;
> +		return false;
>  	if (psw_extint_disabled(vcpu))
> -		return 0;
> +		return false;
>  	if (kvm_s390_vcpu_has_irq(vcpu, 0))
> -		return 0;
> +		return false;
>  	if (!(vcpu->arch.sie_block->gcr[0] & CR0_SERVICE_SIGNAL_SUBMASK))
> -		return 0;
> +		return false;
>  	if (!vcpu->arch.gmap->pfault_enabled)
> -		return 0;
> +		return false;
>  
>  	hva = gfn_to_hva(vcpu->kvm, gpa_to_gfn(current->thread.gmap_addr));
>  	hva += current->thread.gmap_addr & ~PAGE_MASK;
>  	if (read_guest_real(vcpu, vcpu->arch.pfault_token, &arch.pfault_token, 8))
> -		return 0;
> +		return false;
>  
> -	rc = kvm_setup_async_pf(vcpu, current->thread.gmap_addr, hva, &arch);
> -	return rc;
> +	return kvm_setup_async_pf(vcpu, current->thread.gmap_addr, hva, &arch);
>  }
>  
>  static int vcpu_pre_run(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 979a7e1c263d..3dd0af7e7515 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4045,8 +4045,8 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
>  	walk_shadow_page_lockless_end(vcpu);
>  }
>  
> -static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -				   gfn_t gfn)
> +static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> +				    gfn_t gfn)
>  {
>  	struct kvm_arch_async_pf arch;
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 62ec926c78a0..9edc6fc71a89 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -211,8 +211,8 @@ struct kvm_async_pf {
>  
>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
>  void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
> -int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -		       unsigned long hva, struct kvm_arch_async_pf *arch);
> +bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> +			unsigned long hva, struct kvm_arch_async_pf *arch);
>  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #endif
>  
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 45799606bb3e..390f758d5a27 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -156,17 +156,21 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -		       unsigned long hva, struct kvm_arch_async_pf *arch)
> +/*
> + * Try to schedule a job to handle page fault asynchronously. Returns 'true' on
> + * success, 'false' on failure (page fault has to be handled synchronously).
> + */
> +bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> +			unsigned long hva, struct kvm_arch_async_pf *arch)
>  {
>  	struct kvm_async_pf *work;
>  
>  	if (vcpu->async_pf.queued >= ASYNC_PF_PER_VCPU)
> -		return 0;
> +		return false;
>  
>  	/* Arch specific code should not do async PF in this case */
>  	if (unlikely(kvm_is_error_hva(hva)))
> -		return 0;
> +		return false;
>  
>  	/*
>  	 * do alloc nowait since if we are going to sleep anyway we
> @@ -174,7 +178,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	 */
>  	work = kmem_cache_zalloc(async_pf_cache, GFP_NOWAIT | __GFP_NOWARN);
>  	if (!work)
> -		return 0;
> +		return false;
>  
>  	work->wakeup_all = false;
>  	work->vcpu = vcpu;
> @@ -193,7 +197,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>  	schedule_work(&work->work);
>  
> -	return 1;
> +	return true;
>  }
>  
>  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
> -- 
> 2.25.4
> 

