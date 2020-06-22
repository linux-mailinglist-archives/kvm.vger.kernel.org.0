Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466DB203401
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 11:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgFVJvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 05:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbgFVJvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 05:51:50 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A3F3206F1;
        Mon, 22 Jun 2020 09:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592819509;
        bh=rVF+9gcAfBgoO5QMjVC82HmvyQAsTljKLIObnB7+V7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xlvC8uLW6kj3gouL5RXCKfImri7AfcHGBH7ugeHRWCyySAi2UdREYdkVLjAxs0ypt
         HS6RL0eqK9MgSN9uxYIrhhZnemfCoux7AjmUJfIc5VcObBCfJH7dVboV4RgUglNIw3
         /0g/M5fcpGdzIwV8PK2mFc/VIo2CF8OEjl/gwyXU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnJ7D-005H5Q-QD; Mon, 22 Jun 2020 10:51:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 22 Jun 2020 10:51:47 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 2/4] arm64/x86: KVM: Introduce steal time cap
In-Reply-To: <20200622084110.uosiqx3oy22lremu@kamzik.brq.redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
 <20200619184629.58653-3-drjones@redhat.com>
 <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
 <20200622084110.uosiqx3oy22lremu@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <5a52210e5f123d52459f15c594e77bad@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-06-22 09:41, Andrew Jones wrote:
> On Mon, Jun 22, 2020 at 09:20:02AM +0100, Marc Zyngier wrote:
>> Hi Andrew,
>> 
>> On 2020-06-19 19:46, Andrew Jones wrote:
>> > arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
>> > support for steal time. However this is unnecessary and complicates
>> > userspace (userspace may prefer delaying vcpu creation until after
>> > feature probing). Since probing steal time only requires a KVM fd,
>> > we introduce a cap that can be checked.
>> 
>> So this is purely an API convenience, right? You want a way to
>> identify the presence of steal time accounting without having to
>> create a vcpu? It would have been nice to have this requirement
>> before we merged this code :-(.
> 
> Yes. I wish I had considered it more closely when I was reviewing the
> patches. And, I believe we have yet another user interface issue that
> I'm looking at now. Without the VCPU feature bit I'm not sure how easy
> it will be for a migration to fail when attempting to migrate from a 
> host
> with steal-time enabled to one that does not support steal-time. So 
> it's
> starting to look like steal-time should have followed the pmu pattern
> completely, not just the vcpu device ioctl part.

Should we consider disabling steal time altogether until this is worked 
out?

>> 
>> > Additionally, when probing
>> > steal time we should check delayacct_on, because even though
>> > CONFIG_KVM selects TASK_DELAY_ACCT, it's possible for the host
>> > kernel to have delay accounting disabled with the 'nodelayacct'
>> > command line option. x86 already determines support for steal time
>> > by checking delayacct_on and can already probe steal time support
>> > with a kvm fd (KVM_GET_SUPPORTED_CPUID), but we add the cap there
>> > too for consistency.
>> >
>> > Signed-off-by: Andrew Jones <drjones@redhat.com>
>> > ---
>> >  Documentation/virt/kvm/api.rst | 11 +++++++++++
>> >  arch/arm64/kvm/arm.c           |  3 +++
>> >  arch/x86/kvm/x86.c             |  3 +++
>> >  include/uapi/linux/kvm.h       |  1 +
>> >  4 files changed, 18 insertions(+)
>> >
>> > diff --git a/Documentation/virt/kvm/api.rst
>> > b/Documentation/virt/kvm/api.rst
>> > index 9a12ea498dbb..05b1fdb88383 100644
>> > --- a/Documentation/virt/kvm/api.rst
>> > +++ b/Documentation/virt/kvm/api.rst
>> > @@ -6151,3 +6151,14 @@ KVM can therefore start protected VMs.
>> >  This capability governs the KVM_S390_PV_COMMAND ioctl and the
>> >  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
>> >  guests when the state change is invalid.
>> > +
>> > +8.24 KVM_CAP_STEAL_TIME
>> > +-----------------------
>> > +
>> > +:Architectures: arm64, x86
>> > +
>> > +This capability indicates that KVM supports steal time accounting.
>> > +When steal time accounting is supported it may be enabled with
>> > +architecture-specific interfaces.  For x86 see
>> > +Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".  For arm64 see
>> > +Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL"
>> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> > index 90cb90561446..f6dca6d09952 100644
>> > --- a/arch/arm64/kvm/arm.c
>> > +++ b/arch/arm64/kvm/arm.c
>> > @@ -222,6 +222,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>> > long ext)
>> >  		 */
>> >  		r = 1;
>> >  		break;
>> > +	case KVM_CAP_STEAL_TIME:
>> > +		r = sched_info_on();
>> > +		break;
>> >  	default:
>> >  		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
>> >  		break;
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index 00c88c2f34e4..ced6335e403e 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -3533,6 +3533,9 @@ int kvm_vm_ioctl_check_extension(struct kvm
>> > *kvm, long ext)
>> >  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>> >  		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
>> >  		break;
>> > +	case KVM_CAP_STEAL_TIME:
>> > +		r = sched_info_on();
>> > +		break;
>> >  	default:
>> >  		break;
>> >  	}
>> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> > index 4fdf30316582..121fb29ac004 100644
>> > --- a/include/uapi/linux/kvm.h
>> > +++ b/include/uapi/linux/kvm.h
>> > @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
>> >  #define KVM_CAP_PPC_SECURE_GUEST 181
>> >  #define KVM_CAP_HALT_POLL 182
>> >  #define KVM_CAP_ASYNC_PF_INT 183
>> > +#define KVM_CAP_STEAL_TIME 184
>> >
>> >  #ifdef KVM_CAP_IRQ_ROUTING
>> 
>> Shouldn't you also add the same check of sched_info_on() to
>> the various pvtime attribute handling functions? It feels odd
>> that the capability can say "no", and yet we'd accept userspace
>> messing with the steal time parameters...
> 
> I considered that, but the 'has attr' interface is really only asking
> if the interface exists, not if it should be used. I'm not sure what
> we should do about it other than document that the cap needs to say
> it's usable, rather than just the attr presence. But, since we've had
> the attr merged quite a while without the cap, then maybe we can't
> rely on a doc change alone?

Accepting the pvtime attributes (setting up the per-vcpu area) has two
effects: we promise both the guest and userspace that we will provide
the guest with steal time. By not checking sched_info_on(), we lie to
both, with potential consequences. It really feels like a bug.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
