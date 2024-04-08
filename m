Return-Path: <kvm+bounces-13905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1574689C97D
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 18:21:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C85642882EA
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 16:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E35142629;
	Mon,  8 Apr 2024 16:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iA5ADMOh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3482F5B1E0
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712593255; cv=none; b=jt3bGElQp8tSxlVsFZSQ9avB+cONxQWLrlqsJcBAtyXuxZFmNTmZ8TZFq2lWl0DwoVQoaYV0hC8AGeJQzoOpfFn9/+3Eq769cgg9oQWzxZG2Yz7AzlJ1H2wLy0gyDtT2kvDZ5NI+6uDmTYy4M/G3UU+zccvWAXx+SPV3YS9iZQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712593255; c=relaxed/simple;
	bh=VSYbuCAqKf3R9TeMf7JHCuPQ+Xi5C3wzAuqUYJN3sj8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G96BSktpORkFEz3f/Cfu/iLw5cYMU6mBOnTNkA4d/9w7AmK35Tso6MApTGSbpCW8qQpXq9marzQszFkQPaI/HmGbAolfqiRmO8/xSVkLLhBYvm03alTzdO9ZA4FRSRlyRRbr7PzV/EgFedZGr0n1XRLWCrupOmcD62NUplVAgnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iA5ADMOh; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cdfd47de98so3986438a12.1
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 09:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712593253; x=1713198053; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IFKoX5LRArUwXbnBHpdfGpECLiMAwP3ZmSQZ47P/XxQ=;
        b=iA5ADMOhDTR3H/DKQX8nWYiYC44zGytZ8CDN55/HY3lxM5h69n2CUEa2WqCUlKb2AD
         tWcoreJPKuNSQTLPevoEzzHIwYlT5XSilAX0NXpeQe7J0khaqf8y5anav6JxH/2dBDf2
         f55RnNfxOqmeE6Cfw9XLOJVqhhDGViEN/SzxU1USnAm0mmKo72i37uhVfMqpBh8zFb2f
         L95HQt3LIdHsQNS5JfmlU4lbkvvxJl295Zh7H8IbdWqrAVKvQdusSPkFWwPD6oXDeh7w
         5exlf3P9+oPiIzyZKoqu2CV2c99Z+tgyRcqwjo7YmBLfreu/LMCmf1UFjbgBAIO1CA8o
         gZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712593253; x=1713198053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IFKoX5LRArUwXbnBHpdfGpECLiMAwP3ZmSQZ47P/XxQ=;
        b=Z2/t8hPYdBB9EwAZgqIKDqeO0xk1Kt4CJmYor+lGPFWlEsG24Rb7QtgBFirdhL1ybb
         0kZH2mBs3RMwHLSNvtnoi2uPC8PVeq4e6nR6PvsZLllQboQkiHrOjDTwqeGxLtMqEEP2
         DMAL8ljq0B1Gc0x0SgFwfDuLgtIu3uPW7mi6ScCzNUM+7Vc76C1M9XxZoCudRz0MvcU4
         SBzjZ4OLqeeaRSsilnuxUzcMS+ZVHYRPvt1SBshjhh/u3/zyvdaIATDiP7IXf4ilqVzy
         ELKbGwe2HHKumNfIYdZ0NT+y4gDpOFLS6y3enES8NItTWBxI9ImOYEPldnwBm9Ii9iSI
         bMsQ==
X-Gm-Message-State: AOJu0YyucTolS6Hwn+XqvS9I9V9v71VpViapY9p550c2hHckTAguA5hR
	LROPa1nyopnQBARYJUjbhtg0IJHLsI5feUMUDo3AN/sjnjWaPvDnBqNJ0+FzfleC15YHqXuvv43
	SYw==
X-Google-Smtp-Source: AGHT+IGtIssXRNZp39j/EtRn/fKzypd9u2A7Vc83yQVSj6H6aqmybuKMcmx9MTN0utnJgg8UKDKDn52HeOo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d80a:0:b0:5dc:11fe:525f with SMTP id
 b10-20020a63d80a000000b005dc11fe525fmr27590pgh.6.1712593253371; Mon, 08 Apr
 2024 09:20:53 -0700 (PDT)
Date: Mon, 8 Apr 2024 09:20:51 -0700
In-Reply-To: <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405165844.1018872-1-seanjc@google.com> <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
Message-ID: <ZhQZYzkDPMxXe2RN@google.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Wei W Wang <wei.w.wang@intel.com>, David Skidmore <davidskidmore@google.com>, 
	Steve Rutherford <srutherford@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Sun, Apr 07, 2024, Xiaoyao Li wrote:
> On 4/6/2024 12:58 AM, Sean Christopherson wrote:
> >   - For guest MAXPHYADDR vs. GPAW, rely on KVM_GET_SUPPORTED_CPUID to enumerate
> >     the usable MAXPHYADDR[2], and simply refuse to enable TDX if the TDX Module
> >     isn't compatible.  Specifically, if MAXPHYADDR=52, 5-level paging is enabled,
> >     but the TDX-Module only allows GPAW=0, i.e. only supports 4-level paging.
> 
> So userspace can get supported GPAW from usable MAXPHYADDR, i.e.,
> CPUID(0X8000_0008).eaxx[23:16] of KVM_GET_SUPPORTED_CPUID:
>  - if usable MAXPHYADDR == 52, supported GPAW is 0 and 1.
>  - if usable MAXPHYADDR <= 48, supported GPAW is only 0.
> 
> There is another thing needs to be discussed. How does userspace configure
> GPAW for TD guest?
> 
> Currently, KVM uses CPUID(0x8000_0008).EAX[7:0] in struct
> kvm_tdx_init_vm::cpuid.entries[] of IOCTL(KVM_TDX_INIT_VM) to deduce the
> GPAW:
> 
> 	int maxpa = 36;
> 	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
> 	if (entry)
> 		max_pa = entry->eax & 0xff;
> 
> 	...
> 	if (!cpu_has_vmx_ept_5levels() && max_pa > 48)
> 		return -EINVAL;
> 	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
> 		td_params->eptp_controls |= VMX_EPTP_PWL_5;
> 		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
> 	} else {
> 		td_params->eptp_controls |= VMX_EPTP_PWL_4;
> 	}
> 
> The code implies that KVM allows the provided CPUID(0x8000_0008).EAX[7:0] to
> be any value (when 5level ept is supported). when it > 48, configure GPAW of
> TD to 1, otherwise to 0.
> 
> However, the virtual value of CPUID(0x8000_0008).EAX[7:0] inside TD is
> always the native value of hardware (for current TDX).
> 
> So if we want to keep this behavior, we need to document it somewhere that
> CPUID(0x8000_0008).EAX[7:0] in struct kvm_tdx_init_vm::cpuid.entries[] of
> IOCTL(KVM_TDX_INIT_VM) is only for configuring GPAW, not for userspace to
> configure virtual CPUID value for TD VMs.
> 
> Another option is that, KVM doesn't allow userspace to configure
> CPUID(0x8000_0008).EAX[7:0]. Instead, it provides a gpaw field in struct
> kvm_tdx_init_vm for userspace to configure directly.
> 
> What do you prefer?

Hmm, neither.  I think the best approach is to build on Gerd's series to have KVM
select 4-level vs. 5-level based on the enumerated guest.MAXPHYADDR, not on
host.MAXPHYADDR.

With a moderate amount of refactoring, cache/compute guest_maxphyaddr as:

	static void kvm_vcpu_refresh_maxphyaddr(struct kvm_vcpu *vcpu)
	{
		struct kvm_cpuid_entry2 *best;

		best = kvm_find_cpuid_entry(vcpu, 0x80000000);
		if (!best || best->eax < 0x80000008)
			goto not_found;

		best = kvm_find_cpuid_entry(vcpu, 0x80000008);
		if (!best)
			goto not_found;

		vcpu->arch.maxphyaddr = best->eax & GENMASK(7, 0);

		if (best->eax & GENMASK(15, 8))
			vcpu->arch.guest_maxphyaddr = (best->eax & GENMASK(15, 8)) >> 8;
		else
			vcpu->arch.guest_maxphyaddr = vcpu->arch.maxphyaddr;

		return;

	not_found:
		vcpu->arch.maxphyaddr = KVM_X86_DEFAULT_MAXPHYADDR;
		vcpu->arch.guest_maxphyaddr = KVM_X86_DEFAULT_MAXPHYADDR;
	}

and then use vcpu->arch.guest_maxphyaddr instead of vcpu->arch.maxphyaddr when
selecting the TDP level.

	static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
	{
		/* tdp_root_level is architecture forced level, use it if nonzero */
		if (tdp_root_level)
			return tdp_root_level;

		/*
		* Use 5-level TDP if and only if it's useful/necessary.  Definitely a
		* more verbose comment here.
		*/
		if (max_tdp_level == 5 && vcpu->arch.guest_maxphyaddr <= 48)
			return 4;

		return max_tdp_level;
	}

The only question is whether or not the behavior needs to be opt-in via a new
capability, e.g. in case there is some weird usage where userspace enumerates
guest.MAXPHYADDR < host.MAXPHYADDR but still wants/needs 5-level paging.  I highly
doubt such a use case exists though.

I'll get Gerd's series applied, and will post a small series to implement the
above later this week.

