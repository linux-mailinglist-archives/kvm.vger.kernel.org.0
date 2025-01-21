Return-Path: <kvm+bounces-36168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E04A182C3
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE2E83ABC8D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:20:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D860E1F5405;
	Tue, 21 Jan 2025 17:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z84S7hzi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D63143888
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737480035; cv=none; b=uyNnmpqMLkNthZUQaVUMpMUKn3fQAaPETaOv+q9UHc4sa1UzDXN7ANLBqkMt90x0HiKICvIHDLBcbXSm6cmOV7WOfcL9aDnnYlPzo8not8me90MTdsJ9fwgu626e5HH6v+qXt1XlG1YiuaeO5aiFHwFC9YBYstWaZWu6EF4O2kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737480035; c=relaxed/simple;
	bh=x5yMvkK517sWj3Rln5yfo0RN3XBjU/f6LgwdHrnqDiU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DOy8InX7LH0heKm50h58Ggly2i16/KDPghyioPp2E+3LRneTuQidP6lb1vKzgEef1/+XcXRx6qAIn5VOehJaGdlxJZeltbdAYYBC4MVT4kZ82S0fzMi++g3x9bByy/1+MvV8Zf89Nd1oZzZkkIGYwfQdbO6HCzhEwGOwH31J5KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z84S7hzi; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21632eacb31so78558585ad.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 09:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737480033; x=1738084833; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKBBRZAROa15rhH3QqEBLkWUC6taneZwpUedt33fLOg=;
        b=z84S7hzikDotpTEeEs34Guj40yVjV7Erv/zN8Ezfgcqc6ERqSg1FZys3a3ySsCccTf
         cakzWNlHDPfcpZXFq6UEFbQxfsRVaHR7Z50Y/vCaBaUrxJFnU95anFlfU3QLMIMZ/VLQ
         z6Ze8TYIqL202I3CMRfHhODN5Bt3U3B3IY/c3lAMLJSxuXQFiUB8D8H3vu+EZ2g3i+DS
         YdiJVLuXA2KiyygGQFsy3yUjsHB1K4vA2uOugYMHSPndNldrujNSstwLIDXNp6B4HrIV
         CPk2D466e7pC4aCx0xpakViC0LDUdplVLAq8ut0a5EfyU/KlJpToVo7Tqk8QE6xNhFCs
         OztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737480033; x=1738084833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKBBRZAROa15rhH3QqEBLkWUC6taneZwpUedt33fLOg=;
        b=aXwBghq7kStElWJqC/oixBk6VQFRAa0qMEHkQyQ0OvU7VxVLmd2ghzpTWZUfw9McKS
         BMzI5xTsf7XfQuDePtqPZoWbe9jbaOLehZXAFuKo5WdRTqZBw/l+YZSSRglTMQigksov
         BG9xVXrRKBHuNLaH9kOlsZj+6wXxEihnpmJSw1+vbde+ZjyR58Jgf3q1MF5CwXefPoQH
         IctlNCbQFB82CR/sHfA6t8OK4Y581YrDTFpjew9EIkN4rhEe58Ow944Xsfekw8HsLfhe
         IAYuxaArnnTjmEin6utwpZqnMuIyYJCGsg08PQtq59glj0JOZQ72KhUfCPUf7SAbxC3y
         G35Q==
X-Forwarded-Encrypted: i=1; AJvYcCXyKrpfAZ+0F56qp9NFNNvLjKn6qFC//xTzR9uRpNUxRMz+NhG4Y4AYp8yMlOiz3kVW5No=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8PEhaMtKS8FuRZyF9SS1aI9NZCvVIpmZ3MSU/kOM0KCVT302Q
	L8s245KnthJoEr3EDHG8K08T9YCyUNqnGYphV22MvaWErd8uOKRJkp+Bs2kEoADl4I7aoEVj5BS
	VMA==
X-Google-Smtp-Source: AGHT+IE+M+zQgh7U6I+YCMtLJ1fFjwIPWZjsg2dteoxP8P0yc55/E0Tsxz4Z3WK9Fr+onXhzhXKYNxYhNKc=
X-Received: from plgk6.prod.google.com ([2002:a17:902:ce06:b0:216:3eee:c9b7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea03:b0:215:b33b:e26d
 with SMTP id d9443c01a7336-21c3550c5d3mr298899905ad.21.1737480032730; Tue, 21
 Jan 2025 09:20:32 -0800 (PST)
Date: Tue, 21 Jan 2025 09:20:31 -0800
In-Reply-To: <D77OZ0KEG5FP.2BZQFEKQUQZ0P@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023124507.280382-1-pbonzini@redhat.com> <20241023124507.280382-6-pbonzini@redhat.com>
 <Z4rQIGxwUNr5UQX0@google.com> <D77OZ0KEG5FP.2BZQFEKQUQZ0P@amazon.com>
Message-ID: <Z4_XX--PvhC9PBNB@google.com>
Subject: Re: [PATCH 5/5] Documentation: kvm: introduce "VM plane" concept
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	roy.hopkins@suse.com, michael.roth@amd.com, ashish.kalra@amd.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, anelkz@amazon.de, 
	oliver.upton@linux.dev, isaku.yamahata@intel.com, maz@kernel.org, 
	steven.price@arm.com, kai.huang@intel.com, rick.p.edgecombe@intel.com, 
	James.Bottomley@hansenpartnership.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 21, 2025, Nicolas Saenz Julienne wrote:
> Hi Sean,
> 
> On Fri Jan 17, 2025 at 9:48 PM UTC, Sean Christopherson wrote:
> > On Wed, Oct 23, 2024, Paolo Bonzini wrote:
> >> @@ -6398,6 +6415,46 @@ the capability to be present.
> >>  `flags` must currently be zero.
> >>
> >>
> >> +.. _KVM_CREATE_PLANE:
> >> +
> >> +4.144 KVM_CREATE_PLANE
> >> +----------------------
> >> +
> >> +:Capability: KVM_CAP_PLANE
> >> +:Architectures: none
> >> +:Type: vm ioctl
> >> +:Parameters: plane id
> >> +:Returns: a VM fd that can be used to control the new plane.
> >> +
> >> +Creates a new *plane*, i.e. a separate privilege level for the
> >> +virtual machine.  Each plane has its own memory attributes,
> >> +which can be used to enable more restricted permissions than
> >> +what is allowed with ``KVM_SET_USER_MEMORY_REGION``.
> >> +
> >> +Each plane has a numeric id that is used when communicating
> >> +with KVM through the :ref:`kvm_run <kvm_run>` struct.  While
> >> +KVM is currently agnostic to whether low ids are more or less
> >> +privileged, it is expected that this will not always be the
> >> +case in the future.  For example KVM in the future may use
> >> +the plane id when planes are supported by hardware (as is the
> >> +case for VMPLs in AMD), or if KVM supports accelerated plane
> >> +switch operations (as might be the case for Hyper-V VTLs).
> >> +
> >> +4.145 KVM_CREATE_VCPU_PLANE
> >> +---------------------------
> >> +
> >> +:Capability: KVM_CAP_PLANE
> >> +:Architectures: none
> >> +:Type: vm ioctl (non default plane)
> >> +:Parameters: vcpu file descriptor for the default plane
> >> +:Returns: a vCPU fd that can be used to control the new plane
> >> +          for the vCPU.
> >> +
> >> +Adds a vCPU to a plane; the new vCPU's id comes from the vCPU
> >> +file descriptor that is passed in the argument.  Note that
> >> + because of how the API is defined, planes other than plane 0
> >> +can only have a subset of the ids that are available in plane 0.
> >
> > Hmm, was there a reason why we decided to add KVM_CREATE_VCPU_PLANE, as opposed
> > to having KVM_CREATE_PLANE create vCPUs?  IIRC, we talked about being able to
> > provide the new FD, but that would be easy enough to handle in KVM_CREATE_PLANE,
> > e.g. with an array of fds.
> 
> IIRC we mentioned that there is nothing in the VSM spec preventing
> higher VTLs from enabling a subset of vCPUs. That said, even the TLFS
> mentions that doing so is not such a great idea (15.4 VTL Enablement):
> 
> "Enable the target VTL on one or more virtual processors. [...] It is
>  recommended that all VPs have the same enabled VTLs. Having a VTL
>  enabled on some VPs (but not all) can lead to unexpected behavior."
> 
> One thing I've been meaning to research is moving device emulation into
> guest execution context by using VTLs. In that context, it might make
> sense to only enable VTLs on specific vCPUs. But I'm only speculating.

Creating vCPUs for a VTL in KVM doesn't need to _enable_ that VTL, and AIUI
shouldn't enable the VTL, because HvCallEnablePartitionVtl "only" enables the VTL
for the VM, HvCallEnableVpVtl is what fully enables the VTL for a given vCPU.

What I am proposing is to create the KVM vCPU object(s) at KVM_CREATE_PLANE,
purely to help avoid NULL pointer dereferences.  Actually, since KVM will likely
need uAPI to let userspace enable a VTL for a vCPU even if the vCPU object is
auto-created, we could have KVM auto-create the objects transparently, i.e. still
provide KVM_CREATE_VCPU_PLANE, but under the hood it would simply enable a flag
and install the vCPU's file descriptor.

> Otherwise, I cannot think of real world scenarios where this property is
> needed.
> 
> > k.g. is the expectation that userspace will create all planes before creating
> > any vCPUs?
> 
> The opposite really, VTLs can be initiated anytime during runtime.

Oh, right.

> > My concern with relying on userspace to create vCPUs is that it will mean KVM
> > will need to support, or at least not blow up on, VMs with multiple planes, but
> > only a subset of vCPUs at planes > 0.  Given the snafus with vcpus_array, it's
> > not at all hard to imagine scenarios where KVM tries to access a NULL vCPU in
> > a different plane.

