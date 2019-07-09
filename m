Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4FB637DA
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 16:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfGIOXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 10:23:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:44877 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfGIOXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 10:23:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jul 2019 07:23:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,470,1557212400"; 
   d="scan'208";a="159463566"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga008.jf.intel.com with ESMTP; 09 Jul 2019 07:23:16 -0700
Date:   Tue, 9 Jul 2019 07:23:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: Re: [PATCH] kvm: x86: Fix -Wmissing-prototypes warnings
Message-ID: <20190709142316.GB25369@linux.intel.com>
References: <1562401790-49030-1-git-send-email-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1562401790-49030-1-git-send-email-wang.yi59@zte.com.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 06, 2019 at 04:29:50PM +0800, Yi Wang wrote:
> We get a warning when build kernel W=1:
> 
> arch/x86/kvm/../../../virt/kvm/eventfd.c:48:1: warning: no previous prototype for ‘kvm_arch_irqfd_allowed’ [-Wmissing-prototypes]
>  kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
>  ^
> 
> The reason is kvm_arch_irqfd_allowed is declared in arch/x86/kvm/irq.h,
> which is not included by eventfd.c. Remove the declaration to kvm_host.h
> can fix this.

It'd be nice to note in the changelog that kvm_arch_irqfd_allowed() is a
weakly defined function in eventfd.c.  Without that info, one might wonder
why it's ok to move a function declaration from x86 code to generic code.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> 
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
>  arch/x86/kvm/irq.h       | 1 -
>  include/linux/kvm_host.h | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> index d6519a3..7c6233d 100644
> --- a/arch/x86/kvm/irq.h
> +++ b/arch/x86/kvm/irq.h
> @@ -102,7 +102,6 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
>  	return mode != KVM_IRQCHIP_NONE;
>  }
>  
> -bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
>  void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
>  void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
>  void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d1ad38a..5f04005 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -990,6 +990,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>  				   struct kvm_irq_ack_notifier *kian);
>  int kvm_request_irq_source_id(struct kvm *kvm);
>  void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
> +bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
>  
>  /*
>   * search_memslots() and __gfn_to_memslot() are here because they are
> -- 
> 1.8.3.1
> 
