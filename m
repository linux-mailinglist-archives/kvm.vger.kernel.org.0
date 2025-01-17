Return-Path: <kvm+bounces-35878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDF0A15930
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 22:48:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA6BF7A12EC
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 21:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 711A81ACECE;
	Fri, 17 Jan 2025 21:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2ITqoPeV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390BF198851
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 21:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737150499; cv=none; b=MDVFFkZrT/WN2m3AUnzeclXdWBvEZCSJTb7/3RBenEtgBtzc0+PXFvfgiFGjyFWtuhX5xn4ZJ/zAvdQwiZwn0bG8u1Ni8h/CwZNv1EOvp+JY4roG4KPoUE+jXpELP/a8in5c/iOOrl3/cc0SYFie67VUzcUtywhhE1vHH3BJjEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737150499; c=relaxed/simple;
	bh=QAyGTbROtX+GJXlVt/QSxGBHQ3WNil4NttiEbCU86FM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bvvIAXNYevbZWGVnXyzghITL63NU6K/fV8vO2bJPm0BHRfWnqrblJw3K52d1qLh7EtHeG0+qXssrxnAwttGMsVwc0MfpUvlhjoraR74qvMA0iVRlrq1x2t84oNwEA/9JfWXQCv8KYDx8xLeOZ1NOu/H3tiAgCfwxPHnbV+zRwkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2ITqoPeV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef35de8901so4888682a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 13:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737150497; x=1737755297; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YS5KHWley/Y5MsIDr4TgcUoYkF+WgZ/BuzxuMCfoo6o=;
        b=2ITqoPeVJ9vBegl6QAKv+in86LHPgiDzbn8Q4DTKKPhxwCbUQNLeSOPUV+ZcuenPpO
         VVoVJeYHzGLgOKevdc6Y7mEePJpEdrm7U3fc51olj/4PdJPEbUW3iFmZNl0ykdW0A48S
         No83wKHmyg78WxaMNLo4fsv+3D8AWvm8Nh7jr4npGNC8/iZIKXE2RKcoJ5eh/+oIp+MC
         DhR+5Ge3c6CRMxtJeyc72CJPf98tRAsyNJ730GHohNN55fDAIRimGeO+qjkRvC+v/OuQ
         sWEK+MhSX6ZRBzVnguCEDdnsTrSGgNNahp86wIk+hL7Bet6cNr+TsYJHV7N4NzOOWBoo
         UbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737150497; x=1737755297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YS5KHWley/Y5MsIDr4TgcUoYkF+WgZ/BuzxuMCfoo6o=;
        b=oo/LLBbLCveuZYQTr1DL25F05VaBiODLnnvX8JRjFrx8JqVZ+JxOmEM/PogNKb87dK
         rWtk/v+yPIGa9CM67fn6UpZL7qlI3l54qYIWoVXl7K2+RXpCBHk4XMEyfvbAOKaQ4OQf
         VzYWhdYUKixTHcr/zkLOp3SgPPcttGtAR3aV/pGGW/aa1RIBeBwNnXsADTgRFxqRh4I9
         RBMq7/N/dlZwYxNfLdS+vRZF7luCuf0F6M43J8/Qhh5kDOA1240kuokvXZgzTCX4FFA6
         nqWV4Myr8aA38bbjXevIWt7vfIs9U53x/qY6+O5zE7t8hftiHk5mt2p4hDCbh4rb+zUB
         nKyg==
X-Forwarded-Encrypted: i=1; AJvYcCVMxsWA5R1/jZKY4aSrzUif40VjlFBqLFQmm3g5jFVCOELTaw6YstDHLQzc24m6CexeaLA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrM1bzr+HfsVmGOfhvs5ObUNiO3W1eJQWxY0x61QcxCV5iT5jr
	qEPtDVjtkNHK8cp/Wafwsx+kPiSKP7UULhuBgnTOLL6cxZEJ4Sp7rNMKYiFBSTs+Dof2vipYML8
	4KA==
X-Google-Smtp-Source: AGHT+IHp6XVoa9on6aOjDQiQX41+0HwCgq30SKhLkP28C3rGnYeO6e9dURzVmUeEpl+uezeXD8Ag94ymMZ8=
X-Received: from pjbdy4.prod.google.com ([2002:a17:90b:6c4:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c6:b0:2ee:fdf3:38dd
 with SMTP id 98e67ed59e1d1-2f782d38454mr5055939a91.23.1737150497569; Fri, 17
 Jan 2025 13:48:17 -0800 (PST)
Date: Fri, 17 Jan 2025 13:48:16 -0800
In-Reply-To: <20241023124507.280382-6-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023124507.280382-1-pbonzini@redhat.com> <20241023124507.280382-6-pbonzini@redhat.com>
Message-ID: <Z4rQIGxwUNr5UQX0@google.com>
Subject: Re: [PATCH 5/5] Documentation: kvm: introduce "VM plane" concept
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, roy.hopkins@suse.com, 
	michael.roth@amd.com, ashish.kalra@amd.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, nsaenz@amazon.com, anelkz@amazon.de, 
	oliver.upton@linux.dev, isaku.yamahata@intel.com, maz@kernel.org, 
	steven.price@arm.com, kai.huang@intel.com, rick.p.edgecombe@intel.com, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 23, 2024, Paolo Bonzini wrote:
> @@ -6398,6 +6415,46 @@ the capability to be present.
>  `flags` must currently be zero.
>  
>  
> +.. _KVM_CREATE_PLANE:
> +
> +4.144 KVM_CREATE_PLANE
> +----------------------
> +
> +:Capability: KVM_CAP_PLANE
> +:Architectures: none
> +:Type: vm ioctl
> +:Parameters: plane id
> +:Returns: a VM fd that can be used to control the new plane.
> +
> +Creates a new *plane*, i.e. a separate privilege level for the
> +virtual machine.  Each plane has its own memory attributes,
> +which can be used to enable more restricted permissions than
> +what is allowed with ``KVM_SET_USER_MEMORY_REGION``.
> +
> +Each plane has a numeric id that is used when communicating
> +with KVM through the :ref:`kvm_run <kvm_run>` struct.  While
> +KVM is currently agnostic to whether low ids are more or less
> +privileged, it is expected that this will not always be the
> +case in the future.  For example KVM in the future may use
> +the plane id when planes are supported by hardware (as is the
> +case for VMPLs in AMD), or if KVM supports accelerated plane
> +switch operations (as might be the case for Hyper-V VTLs).
> +
> +4.145 KVM_CREATE_VCPU_PLANE
> +---------------------------
> +
> +:Capability: KVM_CAP_PLANE
> +:Architectures: none
> +:Type: vm ioctl (non default plane)
> +:Parameters: vcpu file descriptor for the default plane
> +:Returns: a vCPU fd that can be used to control the new plane
> +          for the vCPU.
> +
> +Adds a vCPU to a plane; the new vCPU's id comes from the vCPU
> +file descriptor that is passed in the argument.  Note that
> + because of how the API is defined, planes other than plane 0
> +can only have a subset of the ids that are available in plane 0.

Hmm, was there a reason why we decided to add KVM_CREATE_VCPU_PLANE, as opposed
to having KVM_CREATE_PLANE create vCPUs?  IIRC, we talked about being able to
provide the new FD, but that would be easy enough to handle in KVM_CREATE_PLANE,
e.g. with an array of fds.

E.g. is the expectation that userspace will create all planes before creating
any vCPUs?

My concern with relying on userspace to create vCPUs is that it will mean KVM
will need to support, or at least not blow up on, VMs with multiple planes, but
only a subset of vCPUs at planes > 0.  Given the snafus with vcpus_array, it's
not at all hard to imagine scenarios where KVM tries to access a NULL vCPU in
a different plane.

