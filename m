Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA3344DC31
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 20:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhKKTj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 14:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhKKTj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 14:39:26 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AD2961252;
        Thu, 11 Nov 2021 19:36:37 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mlFsA-004t5h-VL; Thu, 11 Nov 2021 19:36:35 +0000
MIME-Version: 1.0
Date:   Thu, 11 Nov 2021 19:36:34 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
In-Reply-To: <20211111162746.100598-2-vkuznets@redhat.com>
References: <20211111162746.100598-1-vkuznets@redhat.com>
 <20211111162746.100598-2-vkuznets@redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <a5cdff6878b7157587e92ebe4d5af362@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: vkuznets@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com, jmattson@google.com, ehabkost@redhat.com, drjones@redhat.com, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, anup.patel@wdc.com, paulus@ozlabs.org, mpe@ellerman.id.au, kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 2021-11-11 16:27, Vitaly Kuznetsov wrote:
> It doesn't make sense to return the recommended maximum number of
> vCPUs which exceeds the maximum possible number of vCPUs.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/arm64/kvm/arm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 7838e9fb693e..391dc7a921d5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -223,7 +223,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
> long ext)
>  		r = 1;
>  		break;
>  	case KVM_CAP_NR_VCPUS:
> -		r = num_online_cpus();
> +		if (kvm)
> +			r = min_t(unsigned int, num_online_cpus(),
> +				  kvm->arch.max_vcpus);
> +		else
> +			r = min_t(unsigned int, num_online_cpus(),
> +				  kvm_arm_default_max_vcpus());
>  		break;
>  	case KVM_CAP_MAX_VCPUS:
>  	case KVM_CAP_MAX_VCPU_ID:

This looks odd. This means that depending on the phase userspace is
in while initialising the VM, KVM_CAP_NR_VCPUS can return one thing
or the other.

For example, I create a VM on a 32 CPU system, NR_VCPUS says 32.
I create a GICv2 interrupt controller, it now says 8.

That's a change in behaviour that is visible by userspace, which
I'm keen on avoiding. I'd rather have the kvm and !kvm cases
return the same thing.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
