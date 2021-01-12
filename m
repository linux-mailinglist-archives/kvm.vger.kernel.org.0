Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016F82F335D
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 15:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbhALO4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 09:56:38 -0500
Received: from foss.arm.com ([217.140.110.172]:47732 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbhALO4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 09:56:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06BCA11B3;
        Tue, 12 Jan 2021 06:55:52 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6616C3F719;
        Tue, 12 Jan 2021 06:55:50 -0800 (PST)
Subject: Re: [PATCH 5/9] KVM: arm: move has_run_once after the map_resources
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-6-eric.auger@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <0c9976a3-12ae-29b2-1f26-06ee52aa2ffe@arm.com>
Date:   Tue, 12 Jan 2021 14:55:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201212185010.26579-6-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 12/12/20 6:50 PM, Eric Auger wrote:
> has_run_once is set to true at the beginning of
> kvm_vcpu_first_run_init(). This generally is not an issue
> except when exercising the code with KVM selftests. Indeed,
> if kvm_vgic_map_resources() fails due to erroneous user settings,
> has_run_once is set and this prevents from continuing
> executing the test. This patch moves the assignment after the
> kvm_vgic_map_resources().
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arch/arm64/kvm/arm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c0ffb019ca8b..331fae6bff31 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -540,8 +540,6 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  	if (!kvm_arm_vcpu_is_finalized(vcpu))
>  		return -EPERM;
>  
> -	vcpu->arch.has_run_once = true;
> -
>  	if (likely(irqchip_in_kernel(kvm))) {
>  		/*
>  		 * Map the VGIC hardware resources before running a vcpu the
> @@ -560,6 +558,8 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  		static_branch_inc(&userspace_irqchip_in_use);
>  	}
>  
> +	vcpu->arch.has_run_once = true;

I have a few concerns regarding this:

1. Moving has_run_once = true here seems very arbitrary to me - kvm_timer_enable()
and kvm_arm_pmu_v3_enable(), below it, can both fail because of erroneous user
values. If there's a reason why the assignment cannot be moved at the end of the
function, I think it should be clearly stated in a comment for the people who
might be tempted to write similar tests for the timer or pmu.

2. There are many ways that kvm_vgic_map_resources() can fail, other than
incorrect user settings. I started digging into how
kvm_vgic_map_resources()->vgic_v2_map_resources() can fail for a VGIC V2 and this
is what I managed to find before I gave up:

* vgic_init() can fail in:
    - kvm_vgic_dist_init()
    - vgic_v3_init()
    - kvm_vgic_setup_default_irq_routing()
* vgic_register_dist_iodev() can fail in:
    - vgic_v3_init_dist_iodev()
    - kvm_io_bus_register_dev()(*)
* kvm_phys_addr_ioremap() can fail in:
    - kvm_mmu_topup_memory_cache()
    - kvm_pgtable_stage2_map()

So if any of the functions below fail, are we 100% sure it is safe to allow the
user to execute kvm_vgic_map_resources() again?

(*) It looks to me like kvm_io_bus_register_dev() doesn't take into account a
caller that tries to register the same device address range and it will create
another identical range. Is this intentional? Is it a bug that should be fixed? Or
am I misunderstanding the function?

Thanks,
Alex
> +
>  	ret = kvm_timer_enable(vcpu);
>  	if (ret)
>  		return ret;
