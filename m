Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281C4203248
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 10:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgFVIlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 04:41:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20250 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725616AbgFVIlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 04:41:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592815279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j6bchXI1H8Sc/WeAiFAFnYtwZMMI/VX2mWtLdaeL7OI=;
        b=Gf1U8OlYEI9vv42d7HtAt2Pr0wnHnyjVF6CQBWDXESX1CWCHeZBwq7a+UL7IXNf7RxrGeD
        NylRoZ2sRuGHsVamP0GJMcHqzSbD7acsuKSzNymdY1QREyFHxRxmwUfXC4Mf8OiYjhXroB
        xQeVJVedkSymgE5jrCwAiXyBXDSfhgw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-TpZpddCBM4-2Ep5sWjSxOw-1; Mon, 22 Jun 2020 04:41:15 -0400
X-MC-Unique: TpZpddCBM4-2Ep5sWjSxOw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DD6387305F;
        Mon, 22 Jun 2020 08:41:14 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E0B3A60BEC;
        Mon, 22 Jun 2020 08:41:12 +0000 (UTC)
Date:   Mon, 22 Jun 2020 10:41:10 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 2/4] arm64/x86: KVM: Introduce steal time cap
Message-ID: <20200622084110.uosiqx3oy22lremu@kamzik.brq.redhat.com>
References: <20200619184629.58653-1-drjones@redhat.com>
 <20200619184629.58653-3-drjones@redhat.com>
 <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b1e895dc0c80bef3c0653894e2358cf@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 09:20:02AM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On 2020-06-19 19:46, Andrew Jones wrote:
> > arm64 requires a vcpu fd (KVM_HAS_DEVICE_ATTR vcpu ioctl) to probe
> > support for steal time. However this is unnecessary and complicates
> > userspace (userspace may prefer delaying vcpu creation until after
> > feature probing). Since probing steal time only requires a KVM fd,
> > we introduce a cap that can be checked.
> 
> So this is purely an API convenience, right? You want a way to
> identify the presence of steal time accounting without having to
> create a vcpu? It would have been nice to have this requirement
> before we merged this code :-(.

Yes. I wish I had considered it more closely when I was reviewing the
patches. And, I believe we have yet another user interface issue that
I'm looking at now. Without the VCPU feature bit I'm not sure how easy
it will be for a migration to fail when attempting to migrate from a host
with steal-time enabled to one that does not support steal-time. So it's
starting to look like steal-time should have followed the pmu pattern
completely, not just the vcpu device ioctl part.

> 
> > Additionally, when probing
> > steal time we should check delayacct_on, because even though
> > CONFIG_KVM selects TASK_DELAY_ACCT, it's possible for the host
> > kernel to have delay accounting disabled with the 'nodelayacct'
> > command line option. x86 already determines support for steal time
> > by checking delayacct_on and can already probe steal time support
> > with a kvm fd (KVM_GET_SUPPORTED_CPUID), but we add the cap there
> > too for consistency.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  Documentation/virt/kvm/api.rst | 11 +++++++++++
> >  arch/arm64/kvm/arm.c           |  3 +++
> >  arch/x86/kvm/x86.c             |  3 +++
> >  include/uapi/linux/kvm.h       |  1 +
> >  4 files changed, 18 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst
> > b/Documentation/virt/kvm/api.rst
> > index 9a12ea498dbb..05b1fdb88383 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6151,3 +6151,14 @@ KVM can therefore start protected VMs.
> >  This capability governs the KVM_S390_PV_COMMAND ioctl and the
> >  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
> >  guests when the state change is invalid.
> > +
> > +8.24 KVM_CAP_STEAL_TIME
> > +-----------------------
> > +
> > +:Architectures: arm64, x86
> > +
> > +This capability indicates that KVM supports steal time accounting.
> > +When steal time accounting is supported it may be enabled with
> > +architecture-specific interfaces.  For x86 see
> > +Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".  For arm64 see
> > +Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL"
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 90cb90561446..f6dca6d09952 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -222,6 +222,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
> > long ext)
> >  		 */
> >  		r = 1;
> >  		break;
> > +	case KVM_CAP_STEAL_TIME:
> > +		r = sched_info_on();
> > +		break;
> >  	default:
> >  		r = kvm_arch_vm_ioctl_check_extension(kvm, ext);
> >  		break;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 00c88c2f34e4..ced6335e403e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3533,6 +3533,9 @@ int kvm_vm_ioctl_check_extension(struct kvm
> > *kvm, long ext)
> >  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
> >  		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
> >  		break;
> > +	case KVM_CAP_STEAL_TIME:
> > +		r = sched_info_on();
> > +		break;
> >  	default:
> >  		break;
> >  	}
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 4fdf30316582..121fb29ac004 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_PPC_SECURE_GUEST 181
> >  #define KVM_CAP_HALT_POLL 182
> >  #define KVM_CAP_ASYNC_PF_INT 183
> > +#define KVM_CAP_STEAL_TIME 184
> > 
> >  #ifdef KVM_CAP_IRQ_ROUTING
> 
> Shouldn't you also add the same check of sched_info_on() to
> the various pvtime attribute handling functions? It feels odd
> that the capability can say "no", and yet we'd accept userspace
> messing with the steal time parameters...

I considered that, but the 'has attr' interface is really only asking
if the interface exists, not if it should be used. I'm not sure what
we should do about it other than document that the cap needs to say
it's usable, rather than just the attr presence. But, since we've had
the attr merged quite a while without the cap, then maybe we can't
rely on a doc change alone?

Thanks,
drew

