Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3AFCC8F89
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 19:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfJBRPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 13:15:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:45698 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfJBRPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 13:15:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 10:15:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="scan'208";a="221471645"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 02 Oct 2019 10:15:51 -0700
Date:   Wed, 2 Oct 2019 10:15:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 2/4] x86/kvm: Change print code to use pr_*() format
Message-ID: <20191002171551.GC9615@linux.intel.com>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
 <1569847479-13201-3-git-send-email-zhenzhong.duan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569847479-13201-3-git-send-email-zhenzhong.duan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 08:44:37PM +0800, Zhenzhong Duan wrote:
> pr_*() is preferred than printk(KERN_* ...), after change all the print
> in arch/x86/kernel/kvm.c will have "KVM: xxx" style.
> 
> No functional change.
> 
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

This wasn't really suggested by Vitaly, he just requested it be done in a
separate patch.

> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krcmar <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/kernel/kvm.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a4f108d..ce4f578 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -7,6 +7,8 @@
>   *   Authors: Anthony Liguori <aliguori@us.ibm.com>
>   */
>  
> +#define pr_fmt(fmt) "KVM: " fmt

Not a fan of "KVM" as the prefix as it's easily confused with KVM the
hypervisor.  Maybe "kvm_guest"?

> +
>  #include <linux/context_tracking.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> @@ -286,8 +288,8 @@ static void kvm_register_steal_time(void)
>  		return;
>  
>  	wrmsrl(MSR_KVM_STEAL_TIME, (slow_virt_to_phys(st) | KVM_MSR_ENABLED));
> -	pr_info("kvm-stealtime: cpu %d, msr %llx\n",
> -		cpu, (unsigned long long) slow_virt_to_phys(st));
> +	pr_info("stealtime: cpu %d, msr %llx\n", cpu,
> +		(unsigned long long) slow_virt_to_phys(st));
>  }
>  
>  static DEFINE_PER_CPU_DECRYPTED(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
> @@ -321,8 +323,7 @@ static void kvm_guest_cpu_init(void)
>  
>  		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
>  		__this_cpu_write(apf_reason.enabled, 1);
> -		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
> -		       smp_processor_id());
> +		pr_info("setup async PF for cpu %d\n", smp_processor_id());
>  	}
>  
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
> @@ -347,8 +348,7 @@ static void kvm_pv_disable_apf(void)
>  	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
>  	__this_cpu_write(apf_reason.enabled, 0);
>  
> -	printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
> -	       smp_processor_id());
> +	pr_info("Unregister pv shared memory for cpu %d\n", smp_processor_id());
>  }
>  
>  static void kvm_pv_guest_cpu_reboot(void *unused)
> @@ -509,7 +509,7 @@ static void kvm_setup_pv_ipi(void)
>  {
>  	apic->send_IPI_mask = kvm_send_ipi_mask;
>  	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
> -	pr_info("KVM setup pv IPIs\n");
> +	pr_info("setup pv IPIs\n");
>  }
>  
>  static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
> @@ -639,11 +639,11 @@ static void __init kvm_guest_init(void)
>  	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
>  	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>  		smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
> -		pr_info("KVM setup pv sched yield\n");
> +		pr_info("setup pv sched yield\n");
>  	}
>  	if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/kvm:online",
>  				      kvm_cpu_online, kvm_cpu_down_prepare) < 0)
> -		pr_err("kvm_guest: Failed to install cpu hotplug callbacks\n");
> +		pr_err("failed to install cpu hotplug callbacks\n");
>  #else
>  	sev_map_percpu_data();
>  	kvm_guest_cpu_init();
> @@ -746,7 +746,7 @@ static __init int kvm_setup_pv_tlb_flush(void)
>  			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_tlb_mask, cpu),
>  				GFP_KERNEL, cpu_to_node(cpu));
>  		}
> -		pr_info("KVM setup pv remote TLB flush\n");
> +		pr_info("setup pv remote TLB flush\n");
>  	}
>  
>  	return 0;
> @@ -879,8 +879,8 @@ static void kvm_enable_host_haltpoll(void *i)
>  void arch_haltpoll_enable(unsigned int cpu)
>  {
>  	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
> -		pr_err_once("kvm: host does not support poll control\n");
> -		pr_err_once("kvm: host upgrade recommended\n");
> +		pr_err_once("host does not support poll control\n");
> +		pr_err_once("host upgrade recommended\n");
>  		return;
>  	}
>  
> -- 
> 1.8.3.1
> 
