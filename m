Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F7710DD49
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2019 10:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfK3J3u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 30 Nov 2019 04:29:50 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2470 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbfK3J3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Nov 2019 04:29:50 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 8AF326C3FE04F1522288;
        Sat, 30 Nov 2019 17:29:45 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 30 Nov 2019 17:29:44 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 30 Nov 2019 17:29:45 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 30 Nov 2019 17:29:44 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     "maz@kernel.org" <maz@kernel.org>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "will@kernel.org" <will@kernel.org>,
        "andre.przywara@arm.com" <andre.przywara@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: arm: fix missing free_percpu_irq in
 kvm_timer_hyp_init()
Thread-Topic: [PATCH] KVM: arm: fix missing free_percpu_irq in
 kvm_timer_hyp_init()
Thread-Index: AdWnUfxPfkqh2LUwSkWjIhnvKAeisg==
Date:   Sat, 30 Nov 2019 09:29:44 +0000
Message-ID: <c7c89488701c4340be6ec8de468c30ea@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

friendly ping ...
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> When host_ptimer_irq request irq resource failed, we forget to release the host_vtimer_irq resource already requested.
> Fix this missing irq release and other similar scenario.
>
> Fixes: 9e01dc76be6a ("KVM: arm/arm64: arch_timer: Assign the phys timer on VHE systems")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/arm/arch_timer.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c index f182b2380345..73867f97040c 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -935,7 +935,7 @@ int kvm_timer_hyp_init(bool has_gic)
>  					    kvm_get_running_vcpus());
>  		if (err) {
>  			kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
> -			goto out_free_irq;
> +			goto out_free_vtimer_irq;
>  		}
>  
>  		static_branch_enable(&has_gic_active_state);
> @@ -960,7 +960,7 @@ int kvm_timer_hyp_init(bool has_gic)
>  		if (err) {
>  			kvm_err("kvm_arch_timer: can't request ptimer interrupt %d (%d)\n",
>  				host_ptimer_irq, err);
> -			return err;
> +			goto out_disable_gic_state;
>  		}
>  
>  		if (has_gic) {
> @@ -968,7 +968,7 @@ int kvm_timer_hyp_init(bool has_gic)
>  						    kvm_get_running_vcpus());
>  			if (err) {
>  				kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
> -				goto out_free_irq;
> +				goto out_free_ptimer_irq;
>  			}
>  		}
>  
> @@ -977,15 +977,22 @@ int kvm_timer_hyp_init(bool has_gic)
>  		kvm_err("kvm_arch_timer: invalid physical timer IRQ: %d\n",
>  			info->physical_irq);
>  		err = -ENODEV;
> -		goto out_free_irq;
> +		goto out_disable_gic_state;
>  	}
>  
>  	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
>  			  "kvm/arm/timer:starting", kvm_timer_starting_cpu,
>  			  kvm_timer_dying_cpu);
>  	return 0;
> -out_free_irq:
> +
> +out_free_ptimer_irq:
> +	free_percpu_irq(host_ptimer_irq, kvm_get_running_vcpus());
> +out_disable_gic_state:
> +	if (has_gic)
> +		static_branch_disable(&has_gic_active_state);
> +out_free_vtimer_irq:
>  	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
> +
>  	return err;
>  }
>  
> --
> 2.19.1

