Return-Path: <kvm+bounces-29505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8279ACA84
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 14:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD88A1C2464F
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 12:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9146F1C8785;
	Wed, 23 Oct 2024 12:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fcs45zry"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477821AAE1E
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729687536; cv=none; b=R8crXWk75pNgE2mgfEN6+1MSpwapSnRrLlIVRiVZKwYCW3Tkbeyly2nhK/f4zuT0uuGqkoARJQnz6zjqWBP74wBIQzdujFpG1dPiKZjMyk+zjIMHHykO+dHYIOCRYWGzAcUgVCcX8+bPYrJOSDXAg2koNtZm8qaYIJKGW3I8sLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729687536; c=relaxed/simple;
	bh=K/Y7csYRI3/oxlx7xO3kDMrHXFp/AihAgtRQUEmCWm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXDngCPg+FQK7myKkL/WMUaEPSO+4uEXomOgojmwPc7iacl6FdjZd/w8vBVQz8Ok24GrOnrUOT3ewNxtllLwMWO3CAC6WCi6SLYYhSB7I6TzR36ZfsgildDErH2H56cqUO7B9jv5W5Qn5h1IYR3+z579g1Zjlfz19Ug3fPEGSPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fcs45zry; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729687533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SPxR7C/HaEIovhverKHKQ0rL+reVbPsHUmzV/lR/YoM=;
	b=fcs45zry9dGoVpjcSpMDfMyCfJtkPAOlLseNWAFhNIwDc+2kE+hnuD9f8IYq20bFMDiUrI
	FttGgp3M+EXoNoSZlqjMRlLHkDOUv/cUaT9/HRW7veOFxjKkUmbyZsCXD2l/bvJBPIOPUL
	QShUTa8Acs3DVdQb6sZBT+DHTvxxmF8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-ONYyAaZVMVO7BNzAWNBw7g-1; Wed, 23 Oct 2024 08:45:32 -0400
X-MC-Unique: ONYyAaZVMVO7BNzAWNBw7g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4314f023f55so54550265e9.2
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 05:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729687531; x=1730292331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SPxR7C/HaEIovhverKHKQ0rL+reVbPsHUmzV/lR/YoM=;
        b=lZ0i4GvVsT5MBSDEIELkDff3UPCZvoObHo8GhYkrbdx4umHmLsUariBs5k187XkppV
         ZtniHn9rlL16/GuV3bx/t+YmLzkZbTOj73+isycxxbr7kJXY2bPz/GJXE4uK+0ZEThsS
         T8H8VQ/JtDHdVdV9O+qLWERV/AQiuyhHHkJwzrxvYVAb+T2seTzFkTqUnObs+19a5Dpx
         dSKSON0BOpZkL20BELj83Zcu85+bzb/Y0saMwx8qYk4ZHG2uIgljyq5aDpja/OQynwDe
         PWvYvkX+dubZfyvj3vgGRnjEKc2nUKqjcu78YabatnUO1yfqHielsPkC1OtNk7cyCQ9S
         wSuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkid/7z/8tD8N6nV8WwXUk/fqIldD/jwlHUEw/NgWZOj2iDJXK6SDVIcNA7CF60HUvaiI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI6/waVPnJ0aqnL6w3gYbwrMuhKbRsZcGm0epUcbM3YY1tITd5
	Tuf3VFyba4SEB6AtdfB8SuKfoU0btoVcabUcEz7RIc5jAE2OiwphRV8hDTIp3EGpL7KMTl2K+4x
	CX1pzthAH9rOOMk7UEywRuhAHujTlf2zWN66mO/c3y3F/rJiAHg==
X-Received: by 2002:a05:600c:3d1b:b0:431:40ca:ce6e with SMTP id 5b1f17b1804b1-431841a2f84mr20455385e9.31.1729687530570;
        Wed, 23 Oct 2024 05:45:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTYFIm67sbi244UmXzIKKh5+7jpM4o3zWGaat+q+NnaNS4JnfgCwvMl4jpJLGZUJPet19/yQ==
X-Received: by 2002:a05:600c:3d1b:b0:431:40ca:ce6e with SMTP id 5b1f17b1804b1-431841a2f84mr20455035e9.31.1729687529884;
        Wed, 23 Oct 2024 05:45:29 -0700 (PDT)
Received: from avogadro.local ([151.95.144.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186bd693fsm15619655e9.2.2024.10.23.05.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 05:45:29 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	michael.roth@amd.com,
	ashish.kalra@amd.com,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	oliver.upton@linux.dev,
	isaku.yamahata@intel.com,
	maz@kernel.org,
	steven.price@arm.com,
	kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 5/5] Documentation: kvm: introduce "VM plane" concept
Date: Wed, 23 Oct 2024 14:45:07 +0200
Message-ID: <20241023124507.280382-6-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241023124507.280382-1-pbonzini@redhat.com>
References: <20241023124507.280382-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There have been multiple occurrences of processors introducing a virtual
privilege level concept for guests, where the hypervisor hosts multiple
copies of a vCPU's register state (or at least of most of it) and provides
hypercalls or instructions to switch between them.  These include AMD
VMPLs, Intel TDX partitions, Microsoft Hyper-V VTLs, and ARM CCA planes.
Include documentation on how the feature will be exposed to userspace,
based on a draft made between Plumbers and KVM Forum.

In the past, two main solutions that were attempted, mostly in the context
of Hyper-V VTLs and SEV-SNP VMPLs:

- use a single vCPU file descriptor, and store multiple copies of the state
  in a single struct kvm_vcpu.  This requires a lot of changes to
  provide multiple copies of affected fields, especially MMUs and APICs;
  and complex uAPI extensions to direct existing ioctls to a specific
  privilege level.  This solution looked marginally okay for SEV-SNP
  VMPLs, but only because the copies of the register state were hidden
  in the VMSA (KVM does not manage it); it showed all its problems when
  applied to Hyper-V VTLs.

- use multiple VM and vCPU file descriptors, and handle the switch entirely
  in userspace.  This got gnarly pretty fast for even more reasons than
  the previous case, for example because VMs could not share anymore
  memslots, including dirty bitmaps and private/shared attributes (a
  substantial problem for SEV-SNP since VMPLs share their ASID).  Another
  problem was the need to share _some_ register state across VTLs and
  to control that vCPUs did not run in parallel; there needed to be a
  lot of logic to be added in userspace to ensure that higher-privileged
  VTL properly interrupted a lower-privileged one.

  This solution also complicates in-kernel implementation of privilege
  level switch, or even makes it impossible, because there is no kernel
  knowledge of the relationship between vCPUs that have the same id but
  belong to different privilege levels.

Especially given the need to accelerate switches in kernel, it is clear
that KVM needs some level of knowledge of the relationship between vCPUs
that have the same id but belong to different privilege levels.  For this
reason, I proposed a design that only gives the initial set of VM and vCPU file
descriptors the full set of ioctls + struct kvm_run; other privilege
levels instead only support a small part of the KVM API.  In fact for
the vm file descriptor it is only three ioctls: KVM_CHECK_EXTENSION,
KVM_SIGNAL_MSI, KVM_SET_MEMORY_ATTRIBUTES.  For vCPUs it is basically
KVM_GET/SET_*.

This solves a lot of the problems in the multiple-file-descriptors solution,
namely it gets for free the ability to avoid parallel execution of the
same vCPUs in different privilege levels.  Changes to the userspace API
of course exist, but they are relatively small and more easily backwards
compatible, because they boil down to the introduction of new file
descriptor kinds instead of having to change the inputs to all affected
ioctls.

It does share some of the code churn issues in the single-file-descriptor
solution; on the other hand a prototype multi-fd VMPL implementation[1]
also needed large scale changes which therefore seem unavoidable when
privilege levels are provided by hardware, and not a software concept
only as is the case for VTLs.
hardware 

   [1] https://lore.kernel.org/lkml/cover.1726506534.git.roy.hopkins@suse.com/

Acknowledgements: thanks to everyone who participated in the discussions,
you are too many to mention in a small margin.  Thanks to Roy Hopkins,
Tom Lendacky, Anel Orazgaliyeva, Nicolas Saenz-Julienne for experimenting
with implementations of VTLs and VMPLs.

Ah, and because x86 has three names for it and Arm has one, choose the
Arm name for all architectures to avoid bikeshedding and to displease
everyone---including the KVM/arm64 folks, probably.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst           | 224 ++++++++++++++++++++---
 Documentation/virt/kvm/vcpu-requests.rst |   7 +
 2 files changed, 205 insertions(+), 26 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6619098a8054..6777c24dedde 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -56,6 +56,18 @@ be checked with :ref:`KVM_CHECK_EXTENSION <KVM_CHECK_EXTENSION>`.  Some
 capabilities also need to be enabled for VMs or VCPUs where their
 functionality is desired (see :ref:`cap_enable` and :ref:`cap_enable_vm`).
 
+On some architectures, a "virtual privilege level" concept may be present
+apart from the usual separation between user and supervisor mode, or
+between hypervisor and guest mode.  When this is the case, a single vCPU
+can have multiple copies of its register state (or at least most of it),
+and will switch between them through a special processor instruction,
+or through some kind of hypercall.
+
+KVM calls these privilege levels "planes".  Planes other than the
+initially-created one (called "plane 0") have a file descriptor each,
+and so do the planes of each vCPU.  Ioctls for vCPU planes should also
+be issued from a single thread, unless specially marked as asynchronous
+in the documentation.
 
 2. Restrictions
 ===============
@@ -119,6 +131,11 @@ description:
   Type:
       system, vm, or vcpu.
 
+      File descriptors for planes other than plane 0 provide a subset
+      of vm and vcpu ioctls.  Those that *are* supported in extra
+      planes are marked specially in the documentation (for example,
+      `vcpu (all planes)`).
+
   Parameters:
       what parameters are accepted by the ioctl.
 
@@ -281,7 +281,7 @@ otherwise.
 
 :Capability: basic, KVM_CAP_CHECK_EXTENSION_VM for vm ioctl
 :Architectures: all
-:Type: system ioctl, vm ioctl
+:Type: system ioctl, vm ioctl (all planes)
 :Parameters: extension identifier (KVM_CAP_*)
 :Returns: 0 if unsupported; 1 (or some other positive integer) if supported
 
@@ -421,7 +438,7 @@ kvm_run' (see below).
 
 :Capability: basic
 :Architectures: all except arm64
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_regs (out)
 :Returns: 0 on success, -1 on error
 
@@ -461,7 +478,7 @@ Reads the general purpose registers from the vcpu.
 
 :Capability: basic
 :Architectures: all except arm64
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_regs (in)
 :Returns: 0 on success, -1 on error
 
@@ -475,7 +492,7 @@ See KVM_GET_REGS for the data structure.
 
 :Capability: basic
 :Architectures: x86, ppc
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_sregs (out)
 :Returns: 0 on success, -1 on error
 
@@ -506,7 +523,7 @@ but not yet injected into the cpu core.
 
 :Capability: basic
 :Architectures: x86, ppc
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_sregs (in)
 :Returns: 0 on success, -1 on error
 
@@ -519,7 +536,7 @@ data structures.
 
 :Capability: basic
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_translation (in/out)
 :Returns: 0 on success, -1 on error
 
@@ -645,7 +662,7 @@ This is an asynchronous vcpu ioctl and can be invoked from any thread.
 
 :Capability: basic (vcpu), KVM_CAP_GET_MSR_FEATURES (system)
 :Architectures: x86
-:Type: system ioctl, vcpu ioctl
+:Type: system ioctl, vcpu ioctl (all planes)
 :Parameters: struct kvm_msrs (in/out)
 :Returns: number of msrs successfully returned;
           -1 on error
@@ -685,7 +702,7 @@ kvm will fill in the 'data' member.
 
 :Capability: basic
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_msrs (in)
 :Returns: number of msrs successfully set (see below), -1 on error
 
@@ -773,7 +790,7 @@ signal mask.
 
 :Capability: basic
 :Architectures: x86, loongarch
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_fpu (out)
 :Returns: 0 on success, -1 on error
 
@@ -811,7 +828,7 @@ Reads the floating point state from the vcpu.
 
 :Capability: basic
 :Architectures: x86, loongarch
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_fpu (in)
 :Returns: 0 on success, -1 on error
 
@@ -1122,7 +1139,7 @@ Other flags returned by ``KVM_GET_CLOCK`` are accepted but ignored.
 :Capability: KVM_CAP_VCPU_EVENTS
 :Extended by: KVM_CAP_INTR_SHADOW
 :Architectures: x86, arm64
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_vcpu_events (out)
 :Returns: 0 on success, -1 on error
 
@@ -1245,7 +1262,7 @@ directly to the virtual CPU).
 :Capability: KVM_CAP_VCPU_EVENTS
 :Extended by: KVM_CAP_INTR_SHADOW
 :Architectures: x86, arm64
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_vcpu_events (in)
 :Returns: 0 on success, -1 on error
 
@@ -1311,7 +1328,7 @@ See KVM_GET_VCPU_EVENTS for the data structure.
 
 :Capability: KVM_CAP_DEBUGREGS
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_debugregs (out)
 :Returns: 0 on success, -1 on error
 
@@ -1333,7 +1350,7 @@ Reads debug registers from the vcpu.
 
 :Capability: KVM_CAP_DEBUGREGS
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_debugregs (in)
 :Returns: 0 on success, -1 on error
 
@@ -1649,7 +1666,7 @@ otherwise it will return EBUSY error.
 
 :Capability: KVM_CAP_XSAVE
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xsave (out)
 :Returns: 0 on success, -1 on error
 
@@ -1669,7 +1686,7 @@ This ioctl would copy current vcpu's xsave struct to the userspace.
 
 :Capability: KVM_CAP_XSAVE and KVM_CAP_XSAVE2
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xsave (in)
 :Returns: 0 on success, -1 on error
 
@@ -1697,7 +1714,7 @@ contents of CPUID leaf 0xD on the host.
 
 :Capability: KVM_CAP_XCRS
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xcrs (out)
 :Returns: 0 on success, -1 on error
 
@@ -1724,7 +1741,7 @@ This ioctl would copy current vcpu's xcrs to the userspace.
 
 :Capability: KVM_CAP_XCRS
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xcrs (in)
 :Returns: 0 on success, -1 on error
 
@@ -2014,7 +2031,7 @@ error.
 
 :Capability: KVM_CAP_IRQCHIP
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_lapic_state (out)
 :Returns: 0 on success, -1 on error
 
@@ -2045,7 +2062,7 @@ always uses xAPIC format.
 
 :Capability: KVM_CAP_IRQCHIP
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_lapic_state (in)
 :Returns: 0 on success, -1 on error
 
@@ -2296,7 +2296,7 @@ prior to calling the KVM_RUN ioctl.
 
 :Capability: KVM_CAP_ONE_REG
 :Architectures: all
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_one_reg (in)
 :Returns: 0 on success, negative value on failure
 
@@ -2908,7 +2908,7 @@ such as set vcpu counter or reset vcpu, and they have the following id bit patte
 
 :Capability: KVM_CAP_ONE_REG
 :Architectures: all
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_one_reg (in and out)
 :Returns: 0 on success, negative value on failure
 
@@ -2962,7 +2962,7 @@ after pausing the vcpu, but before it is resumed.
 
 :Capability: KVM_CAP_SIGNAL_MSI
 :Architectures: x86 arm64
-:Type: vm ioctl
+:Type: vm ioctl (all planes)
 :Parameters: struct kvm_msi (in)
 :Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
 
@@ -3565,7 +3565,7 @@ VCPU matching underlying host.
 
 :Capability: basic
 :Architectures: arm64, mips, riscv
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_reg_list (in/out)
 :Returns: 0 on success; -1 on error
 
@@ -4807,7 +4824,7 @@ The acceptable values for the flags field are::
 
 :Capability: KVM_CAP_NESTED_STATE
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_nested_state (in/out)
 :Returns: 0 on success, -1 on error
 
@@ -4881,7 +4898,7 @@ to the KVM_CHECK_EXTENSION ioctl().
 
 :Capability: KVM_CAP_NESTED_STATE
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_nested_state (in)
 :Returns: 0 on success, -1 on error
 
@@ -5762,7 +5779,7 @@ then ``length`` is returned.
 
 :Capability: KVM_CAP_SREGS2
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_sregs2 (out)
 :Returns: 0 on success, -1 on error
 
@@ -5795,7 +5812,7 @@ flags values for ``kvm_sregs2``:
 
 :Capability: KVM_CAP_SREGS2
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_sregs2 (in)
 :Returns: 0 on success, -1 on error
 
@@ -6011,7 +6028,7 @@ as the descriptors in Descriptors block.
 
 :Capability: KVM_CAP_XSAVE2
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xsave (out)
 :Returns: 0 on success, -1 on error
 
@@ -6269,7 +6286,7 @@ Returns -EINVAL if called on a protected VM.
 
 :Capability: KVM_CAP_MEMORY_ATTRIBUTES
 :Architectures: x86
-:Type: vm ioctl
+:Type: vm ioctl (all planes)
 :Parameters: struct kvm_memory_attributes (in)
 :Returns: 0 on success, <0 on error
 
@@ -6398,6 +6415,46 @@ the capability to be present.
 `flags` must currently be zero.
 
 
+.. _KVM_CREATE_PLANE:
+
+4.144 KVM_CREATE_PLANE
+----------------------
+
+:Capability: KVM_CAP_PLANE
+:Architectures: none
+:Type: vm ioctl
+:Parameters: plane id
+:Returns: a VM fd that can be used to control the new plane.
+
+Creates a new *plane*, i.e. a separate privilege level for the
+virtual machine.  Each plane has its own memory attributes,
+which can be used to enable more restricted permissions than
+what is allowed with ``KVM_SET_USER_MEMORY_REGION``.
+
+Each plane has a numeric id that is used when communicating
+with KVM through the :ref:`kvm_run <kvm_run>` struct.  While
+KVM is currently agnostic to whether low ids are more or less
+privileged, it is expected that this will not always be the
+case in the future.  For example KVM in the future may use
+the plane id when planes are supported by hardware (as is the
+case for VMPLs in AMD), or if KVM supports accelerated plane
+switch operations (as might be the case for Hyper-V VTLs).
+
+4.145 KVM_CREATE_VCPU_PLANE
+---------------------------
+
+:Capability: KVM_CAP_PLANE
+:Architectures: none
+:Type: vm ioctl (non default plane)
+:Parameters: vcpu file descriptor for the default plane
+:Returns: a vCPU fd that can be used to control the new plane
+          for the vCPU.
+
+Adds a vCPU to a plane; the new vCPU's id comes from the vCPU
+file descriptor that is passed in the argument.  Note that
+ because of how the API is defined, planes other than plane 0
+can only have a subset of the ids that are available in plane 0.
+
 .. _kvm_run:
 
 5. The kvm_run structure
@@ -6433,7 +6490,50 @@ This field is ignored if KVM_CAP_IMMEDIATE_EXIT is not available.
 
 ::
 
-	__u8 padding1[6];
+	/* in/out */
+	__u8 plane;
+
+The plane that will be run (usually 0).
+
+While this is not yet supported, in the future KVM may handle plane
+switch in the kernel.  In this case, the output value of this field
+may differ from the input value.  However, automatic switch will
+have to be :ref:`explicitly enabled <KVM_ENABLE_CAP>`.
+
+For backwards compatibility, this field is ignored unless a plane
+other than plane 0 has been created.
+
+::
+
+        /* in/out */
+        __u16 suspended_planes;
+
+A bitmap of planes whose execution was suspended to run a
+higher-privileged plane, usually via a hypercall or due to
+an interrupt in the higher-privileged plane.
+
+KVM right now does not use this field; it may be used in the future
+once KVM implements in-kernel plane switch mechanisms.  Until that
+is the case, userspace can leave this to zero.
+
+::
+
+	/* in */
+	__u16 req_exit_planes;
+
+A bitmap of planes for which KVM should exit when they have a pending
+interrupt.  In general, userspace should set bits corresponding to
+planes that are more privileged than ``plane``; because KVM is agnostic
+to whether low ids are more or less privileged, these could be the bits
+*above* or *below* ``plane``.  In some cases it may make sense to request
+an exit for all planes---for example, if the higher-priority plane
+wants to be informed about interrupts pending in lower-priority planes,
+userspace may need to learn about those as well.
+
+The bit at position ``plane`` is ignored; interrupts for the current
+plane are never delivered to userspace.
+
+::
 
 	/* out */
 	__u32 exit_reason;
@@ -7086,6 +7186,44 @@ The valid value for 'flags' is:
   - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
     in VMCS. It would run into unknown result if resume the target VM.
 
+::
+
+    /* KVM_EXIT_PLANE_EVENT */
+    struct {
+  #define KVM_PLANE_EVENT_INTERRUPT	0
+      __u16 pending_event_planes;
+      __u8 cause;
+      __u8 target;
+      __u32 flags;
+      __u64 extra;
+    } plane;
+
+Inform userspace of an event that affects a different plane than the
+currently executing one.
+
+On a ``KVM_EXIT_PLANE_EVENT`` exit, ``pending_event_planes`` is always
+set to the set of planes that have a pending interrupt.
+
+``cause`` provides the event that caused the exit, and the meaning of
+``target`` depends on the cause of the exit too.
+
+Right now the only defined cause is ``KVM_PLANE_EVENT_INTERRUPT``, i.e.
+an interrupt was received by a plane whose id is set in the
+``req_exit_planes`` bitmap.  In this case, ``target`` is the id of the
+plane that received an interrupt, and its bit is always set in both
+``req_exit_planes`` and ``pending_event_planes``.
+
+``flags`` and ``extra`` are currently always 0.
+
+If userspace wants to switch to the target plane, it should move any
+shared state from the current plane to ``target``, and then invoke
+``KVM_RUN`` with ``kvm_run->plane`` set to ``target`` (and
+``req_exit_planes`` initialized accordingly).  Note that it's also
+valid to switch planes in response to other userspace exit codes, for
+example ``KVM_EXIT_X86_WRMSR`` or ``KVM_EXIT_HYPERCALL``.  Immediately
+after ``KVM_RUN`` is entered, KVM will check ``req_exit_planes`` and
+trigger a ``KVM_EXIT_PLANE_EVENT`` userspace exit if needed.
+
 ::
 
 		/* Fix the size of the union. */
@@ -8930,6 +9068,40 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
 production.  The behavior and effective ABI for software-protected VMs is
 unstable.
 
+8.42 KVM_CAP_PLANE
+------------------
+
+:Capability: KVM_CAP_PLANE
+:Architectures: x86
+:Type: system, vm
+
+The capability returns the maximum plane id that can be passed to
+:ref:`KVM_CREATE_PLANE <KVM_CREATE_PLANE>`.  Because the maximum
+id can vary according to the machine type, it is recommended to
+check for this capability on the VM file descriptor.
+
+When called on the system file descriptor, KVM returns the highest
+value supported on any machine type.
+
+
+8.42 KVM_CAP_PLANE_FPU
+----------------------
+
+:Capability: KVM_CAP_PLANE_FPU
+:Architectures: x86
+:Type: system, vm
+
+The capability returns 1 if the FPU is split for each vCPU plane.
+If the capability is absent, the FPU is shared by all vCPU planes.
+
+Note that ioctls such as KVM_SET_XSAVE or KVM_SET_FPU *are* available
+even if this capability is absent.  However, they will overwrite the
+registers presented to other planes.
+
+Also note that KVM_GET/SET_XSAVE also allows access to some registers
+that are *not* part of FPU state, notably PKRU.  Those are never shared.
+
+
 9. Known KVM API problems
 =========================
 
diff --git a/Documentation/virt/kvm/vcpu-requests.rst b/Documentation/virt/kvm/vcpu-requests.rst
index 06718b9bc959..86ac67b98a74 100644
--- a/Documentation/virt/kvm/vcpu-requests.rst
+++ b/Documentation/virt/kvm/vcpu-requests.rst
@@ -286,6 +286,13 @@ architecture dependent.  kvm_vcpu_block() calls kvm_arch_vcpu_runnable()
 to check if it should awaken.  One reason to do so is to provide
 architectures a function where requests may be checked if necessary.
 
+VM planes
+---------
+
+Each plane has its own set of requests.  Processing requests from
+another plane needs to go through a plane switch, for example via a
+`KVM_EXIT_PLANE_EVENT` userspace exit.
+
 References
 ==========
 
-- 
2.46.2


