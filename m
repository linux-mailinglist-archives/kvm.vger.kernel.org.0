Return-Path: <kvm+bounces-42436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D732AA786A4
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DC9416C1E3
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E62913B5AE;
	Wed,  2 Apr 2025 02:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QBgpN72W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDF72E3380
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 02:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743562738; cv=none; b=XsSpJj+EOAIcBIUsGsoMqek3m61ziA4R53ZxoyqfQQt2+plcV0ie5XlqK80rM7V/TeZxNMsDZJfCVnKfJqgqgiq1amD2bHMSsXjshZCUleZbwn+avgou1vXXgo7SiXV7aAeHv6uZvtgF9X6RqHniks8YCf7Id3/L1wyu2OZDKLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743562738; c=relaxed/simple;
	bh=qSsSqNI+e8H1dkfIdplQvE/uFu9vkRLyjCAZfche5WY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nixczXIT79wuBiPdN18vLiBdYe+7DygEzDyYcOA15Ujg+RgTyhodaXpmuN3JrZkFPyU3GNXX387usAopStpbh6T8SZuaYJJ+R3UpmwR4oKiuoHrxgHyK3MUwRGJAH+TEowmGaA7AJYlGjWfGMGeDfIh4Pw6vT9Va9v3LiQNm31c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QBgpN72W; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-223fb0f619dso118230215ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 19:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743562736; x=1744167536; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T6wuYXanYjAeKP3cuq4YxBDu/PUjGGMnnNxD1TxjUJY=;
        b=QBgpN72WYHM13FCu1ef8e/3q6g3C4o2ZPsDNIPBb9H7xa7/dUqyM4iNPmc4ADw3keo
         grKT5Cj8H0DahVMdnpzKp1zyOqENwhLMDSt0s8iw2GCs5UQ1QlOksGvdVPGwEUivAkjN
         TLCyIphWS6TvS07EH2fUCCBIQvTei1Q1nm8MtJnSIVAjFt8lKdaq59rqpBBHTuB2NLa9
         q9XXVtcc2Ki+5nSGUiXYeuqoOK4SADLbQWYzlT237fdfbRBod5IR1svb8soMGLfz8JYF
         9h65my62V49AqPeKPMDdEXftD2hE3F7sikgAuajBOTbpettDP0RlZd8swt5+cKnJ6ZoH
         YkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743562736; x=1744167536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T6wuYXanYjAeKP3cuq4YxBDu/PUjGGMnnNxD1TxjUJY=;
        b=cVfVba2dZYHcF3cGDxBv26rHjhm4oouUxpkJDVhzZsj6+Sq72IpqceJO0eVWlzuUX3
         x8hdwMSgiN5I7AoN36YVb1YH3MTZonZoIXaHLY1tbHzwfM1PqNbDw3PNd/TZsUpePEDq
         cvpniKAzwgLEoS4PLlDTpW7YFrT/Ggm1U22M41++vao90hVVpt5+53RZsdydRF5vCay4
         1JdYqrJ1xXn2TYXLJBS7SNCJcaML+gC2534r0gzxrAKtvUFzy5tYIEfDbYPC2l5qHG0T
         igOpgsnVB2BK2CRhHQ/9K5iY470scQu/mtj1b8WpLsTRfXPB3or337Z1j1RJMkPbUouN
         pfTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUc4iECXWJ13qRnNSZoYMmwtB4lGNVr7tdrxGukfbCKnzQ1CMSO6X2D3twQOHCVNOvoJ5E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjf46G/lAf4b+XHWXgb9AGwCj+ZrMt2kGDbhxkdoCn34LeBXMs
	flcdQHOS7uhf+xHAuwVwqGh2OxlxDBjvQAEa11NqwtxjQtgHtyOp
X-Gm-Gg: ASbGncty6PP/Qve7DDJGV//gPsQ/xz9asrTra7aPzW+rcb96FEybNP1O31U/Hhr3BuB
	aUiAzfhIutHtsbVXMd5oGyqv9kmHDnv51w+fqmNVPYV5S8x3IwXYx+iTLn2j2XgD/4bunImrKer
	ErNVa4Dr+pgSv529O8LjRE0ZKb6WXPjUI+0OdSydSgIo7uDEGicfmTIPKmcJ8hA42nbYlGh0IA0
	gidZXPo5rup/j7kjZIORV/tHX5p0MilSV6c7KfSGPnoAsdMC2DStvoWK8TpncI6h75DV24m8nlr
	gF4i4KbMPQWtei/lfgXm4m6dfUitEjadLej9Lw==
X-Google-Smtp-Source: AGHT+IHFX1t+j4wZChxTIXjaH746s9fkrxGA5C6ltsvH8PRtH6x9yyt1Z6gB/nQ5xRbdSD25SBLMpA==
X-Received: by 2002:a05:6a21:4d8f:b0:1f5:882e:60f with SMTP id adf61e73a8af0-200d13a4633mr8293953637.17.1743562736139;
        Tue, 01 Apr 2025 19:58:56 -0700 (PDT)
Received: from raj ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739710ad970sm10081768b3a.148.2025.04.01.19.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 19:58:55 -0700 (PDT)
Date: Wed, 2 Apr 2025 08:28:48 +0530
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	jens.wiklander@linaro.org, sumit.garg@kernel.org,
	mark.rutland@arm.com, lpieralisi@kernel.org, sudeep.holla@arm.com,
	pbonzini@redhat.com, kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] KVM: optee: Introduce OP-TEE Mediator for
 exposing secure world to KVM guests
Message-ID: <Z-yn6BdPcuM_aDBX@raj>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
 <87ldsjzr5l.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldsjzr5l.wl-maz@kernel.org>

On Tue, Apr 01, 2025 at 07:13:26PM +0100, Marc Zyngier wrote:
> On Tue, 01 Apr 2025 18:05:20 +0100,
> Yuvraj Sakshith <yuvraj.kernel@gmail.com> wrote:
> > 
> > A KVM guest running on an arm64 machine will not be able to interact with a trusted execution environment
> > (which supports non-secure guests) like OP-TEE in the secure world. This is because, instructions provided
> > by the architecture (such as, SMC)  which switch control to the firmware, are trapped in EL2 when the guest
> > is executes them.
> > 
> > This series adds a feature into the kernel called the TEE mediator abstraction layer, which lets
> > a guest interact with the secure world. Additionally, a OP-TEE specific mediator is also implemented, which
> > hooks itself to the TEE mediator layer and intercepts guest SMCs targetted at OP-TEE.
> > 
> > Overview
> > =========
> > 
> > Essentially, if the kernel wants to interact with OP-TEE, it makes an "smc - secure monitor call instruction",
> > after loading in arguments into CPU registers. What these arguments consists of and how both these entities 
> > communicate can vary. If a guest wants to establish a connection with the secure world, its not possible. 
> > This is because of the fact that "smc" by the guest are trapped by the hypervisor in EL2. This is done by setting
> > the HCR_EL2.TSC bit before entering the guest.
> > 
> > Hence, this feature which I we may call TEE mediator, acts as an intermediary between the guest and OP-TEE.
> > Instead of denying the guest SMC and jumping back into the guest, the mediator forwards the request to
> > OP-TEE.
> > 
> > OP-TEE supports virtualization in the normal world and expects 6 things from the NS-hypervisor:
> > 
> > 1. Notify OP-TEE when a VM is created.
> > 2. Notify OP-TEE when a VM is destroyed.
> > 3. Any SMC to OP-TEE has to contain the VMID in x7. If its the hypervisor sending, then VMID is 0.
> > 4. Hypervisor has to perform IPA->PA translations of the memory addresses sent by guest.
> > 5. Memory shared by the VM to OP-TEE has to remain pinned.
> > 6. The hypervisor has to follow the OP-TEE protocol, so the guest thinks it is directly speaking to OP-TEE.
> > 
> > Its important to note that, if OP-TEE is built with NS-virtualization support, it can only function if there is 
> > a hypervisor with a mediator in normal world.
> > 
> > This implementation has been heavily inspired by Xen's OP-TEE
> > mediator.
> 
> [...]
> 
> And I think this inspiration is the source of most of the problems in
> this series.
> 
> Routing Secure Calls from the guest to whatever is on the secure side
> should not be the kernel's job at all. It should be the VMM's job. All
> you need to do is to route the SMCs from the guest to userspace, and
> we already have all the required infrastructure for that.
>
Yes, this was an argument at the time of designing this solution.

> It is the VMM that should:
> 
> - signal the TEE of VM creation/teardown
> 
> - translate between IPAs and host VAs without involving KVM
> 
> - let the host TEE driver translate between VAs and PAs and deal with
>   the pinning as required, just like it would do for any userspace
>   (without ever using the KVM memslot interface)
> 
> - proxy requests from the guest to the TEE
> 
> - in general, bear the complexity of anything related to the TEE
>

Major reason why I went with placing the implementation inside the kernel is,
	- OP-TEE userspace lib (client) does not support sending SMCs for VM events
	  and needs modification.
	- QEMU (or every other VMM)  will have to be modified.
	- OP-TEE driver is anyways in the kernel. A mediator will just be an addition
		and not a completely new entity.
	- (Potential) issues if we would want to mediate requests from VM which has
	  private mem.
	- Heavy VM exits if guest makes frequent TOS calls.

Hence, the thought of making changes to too many entities (libteec, VMM, etc.) was a
strong reason, although arguable.

> In short, the VMM is just another piece of userspace using the TEE to
> do whatever it wants. The TEE driver on the host must obviously know
> about VMs, but that's about it.
> 
> Crucially, KVM should:
> 
> - be completely TEE agnostic and never call into something that is
>   TEE-specific
> 
> - allow a TEE implementation entirely in userspace, specially for the
>   machines that do not have EL3
>

Yes, you're right. Although I believe there still are some changes that need to be made
to KVM for facilitating this. For example, kvm_smccc_get_action() would deny TOS call.

So, having an implementation completely in VMM without any change in KVM might be challenging,
any potential solutions are welcome.
 
> As it stands, your design looks completely upside-down. Most of this
> code should be userspace code and live in (or close to) the VMM, with
> the host kernel only providing the basic primitives, most of which
> should already be there.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.

