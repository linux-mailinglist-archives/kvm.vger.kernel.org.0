Return-Path: <kvm+bounces-42335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B8F8A77FDF
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B4F01890B79
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0814A20E012;
	Tue,  1 Apr 2025 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KOWPsmQZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71B820D4EB
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523881; cv=none; b=c6id49W+w6OQ2NBgeu/Y+yOwWI9J19agVjAvS3lwpNnVc6/zZkG48BUXy0/qbeAH+O4muetiGpn+hCZXOZjC4svcFZEBey06i8QoDkckiAoQL4x+BsrPUZAlOSDCdlXOsAPEHA+T8lW+Pysdde0iXIOLACBjRt5j8/fZgED5bWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523881; c=relaxed/simple;
	bh=J8qPggLN660CJ/gny2eLwefa7cxow24DmQlH8cqCWPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHW0f52f5Nn4Nuu/bF4XEYgf/SmaOC0JKdcpeIZUJTE8GKV9Q6PG7leKTfWftMwXohnvyBHg/Mk0DrGe/vgk8LNQ115lLXPwLE/ITjBCWcC9gKhEtlI/qlhcngcaXQuc2gs6ZyoOWGAVvpvFz+/z76FsbJQhuoYL2fHJFO75t2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KOWPsmQZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Ne6WCLBR/XrZ0UzXGe9+IeJgjHUMAWkVyxrLTzy0KE=;
	b=KOWPsmQZDoAzQ0favkb7keKTp374dGP4ElwtNy1ODM80sgp7sAdS8bmpiXbWh91dxpseQw
	gczIQ7aOb4E8jklHNgLBXLjRRTda9PG6KKe9H3vUsAZ1OmU3SgQYM1s/jqCaLQoV9zuQOm
	ny29BZxABdpv52BGzyj95YFMkdOHr98=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-ZoKEJuk9N-68vXnRCkmqtA-1; Tue, 01 Apr 2025 12:11:14 -0400
X-MC-Unique: ZoKEJuk9N-68vXnRCkmqtA-1
X-Mimecast-MFC-AGG-ID: ZoKEJuk9N-68vXnRCkmqtA_1743523873
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39979ad285bso3221130f8f.2
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523873; x=1744128673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Ne6WCLBR/XrZ0UzXGe9+IeJgjHUMAWkVyxrLTzy0KE=;
        b=w57uELueiu35OyOUDGurCB63wOF3XTruBTLugyy8QALw+EtjSfYYI/S2hlxE0m2VPs
         ghF3ns7/92vgZCDF/9XimcMvvYsirKuzyoPnu2lRg19zHNYyR8U8BRQLNFGsHWd1pRT+
         V0l/t7lH90wM6zdtZ2lJwKP7vRNmhpiLYI1pk6b1Mh0yk71/7IvPNqPYfrSipvydkulM
         w1NahQ3W3WGhOHhhsZ3rVCFY7zWTPFlypsKWs+4VmPU9hezg6nFgAZ7VPff1J55cL4iW
         GmNNBD9AMzKSYDEU4gHlVYQ5ZQWVin+2vrBsE1siXJ+to1KdfcxIqAMCea/KAbUh4yGm
         M3sg==
X-Forwarded-Encrypted: i=1; AJvYcCVS/hpD1T8jJma7H9j8/n3Hqtt3fp2eDHCOg1pbYtL8SpOgNpprM46dDxjcK9CjyXGdas4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsMTQFTk8lDRAfFPj8iBiCpNURoFVIIv24iOlWkeUEiwbsWkl4
	HDDRzzBySuaJGl/gwEU6qlj0PknAcMUhO5wltx4MpTlgumtrjlI82RZEOn52+Q0JFkae3eYTBtU
	JB6olMSyj071X2aY5Pp5QwSd4puGJSTZ9JLwEGqJRxHpOV2zdSA==
X-Gm-Gg: ASbGncuwnKg9eLdlzUe7GN1PWVS8MZdTXddonfcbIhesg/KsFVUcO/PCkh3C4Y+Dqrf
	3BAwsLtDsSB8ZShBxFgRx7YaA1nUgZa5na1xsVb5BmasFhidO97T5wkiO/xuFJY4j2HDG0spFtu
	WFAkDPAu++DZDly8/ET2o6MlGxhV+rO8IMiXaQ2bw2avaYuAs843MicSQhPLwhHg9bICPJmpS6D
	m/ZvXstadyMNj7p9P7ZjHb1RYwQZQXfSHvGwVTEcG1BnraphYQ/48N/y9iuxAuQUsetfmObnlll
	5+eh/DF2njd9u7QRzF3J+A==
X-Received: by 2002:a05:6000:1acf:b0:390:f358:85db with SMTP id ffacd0b85a97d-39c120e0bafmr10933803f8f.30.1743523872456;
        Tue, 01 Apr 2025 09:11:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6K6N1iLNBiiCO+QMwKNhv1DNnVDzcZ/uBheUeMHVe4bav7TmYrqVRWee/NwpSbAcJtsirSw==
X-Received: by 2002:a05:6000:1acf:b0:390:f358:85db with SMTP id ffacd0b85a97d-39c120e0bafmr10933738f8f.30.1743523871765;
        Tue, 01 Apr 2025 09:11:11 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b663470sm14413217f8f.27.2025.04.01.09.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:10 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 01/29] Documentation: kvm: introduce "VM plane" concept
Date: Tue,  1 Apr 2025 18:10:38 +0200
Message-ID: <20250401161106.790710-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
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
 Documentation/virt/kvm/api.rst           | 235 ++++++++++++++++++++---
 Documentation/virt/kvm/vcpu-requests.rst |   7 +
 2 files changed, 211 insertions(+), 31 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2a63a244e87a..e1c67bc6df47 100644
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
 
@@ -264,7 +281,7 @@ otherwise.
 
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
 
@@ -1126,7 +1143,7 @@ Other flags returned by ``KVM_GET_CLOCK`` are accepted but ignored.
 :Capability: KVM_CAP_VCPU_EVENTS
 :Extended by: KVM_CAP_INTR_SHADOW
 :Architectures: x86, arm64
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_vcpu_events (out)
 :Returns: 0 on success, -1 on error
 
@@ -1249,7 +1266,7 @@ directly to the virtual CPU).
 :Capability: KVM_CAP_VCPU_EVENTS
 :Extended by: KVM_CAP_INTR_SHADOW
 :Architectures: x86, arm64
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_vcpu_events (in)
 :Returns: 0 on success, -1 on error
 
@@ -1315,7 +1332,7 @@ See KVM_GET_VCPU_EVENTS for the data structure.
 
 :Capability: KVM_CAP_DEBUGREGS
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_debugregs (out)
 :Returns: 0 on success, -1 on error
 
@@ -1337,7 +1354,7 @@ Reads debug registers from the vcpu.
 
 :Capability: KVM_CAP_DEBUGREGS
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_debugregs (in)
 :Returns: 0 on success, -1 on error
 
@@ -1656,7 +1673,7 @@ otherwise it will return EBUSY error.
 
 :Capability: KVM_CAP_XSAVE
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xsave (out)
 :Returns: 0 on success, -1 on error
 
@@ -1676,7 +1693,7 @@ This ioctl would copy current vcpu's xsave struct to the userspace.
 
 :Capability: KVM_CAP_XSAVE and KVM_CAP_XSAVE2
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xsave (in)
 :Returns: 0 on success, -1 on error
 
@@ -1704,7 +1721,7 @@ contents of CPUID leaf 0xD on the host.
 
 :Capability: KVM_CAP_XCRS
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xcrs (out)
 :Returns: 0 on success, -1 on error
 
@@ -1731,7 +1748,7 @@ This ioctl would copy current vcpu's xcrs to the userspace.
 
 :Capability: KVM_CAP_XCRS
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xcrs (in)
 :Returns: 0 on success, -1 on error
 
@@ -2027,7 +2044,7 @@ error.
 
 :Capability: KVM_CAP_IRQCHIP
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_lapic_state (out)
 :Returns: 0 on success, -1 on error
 
@@ -2058,7 +2075,7 @@ always uses xAPIC format.
 
 :Capability: KVM_CAP_IRQCHIP
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_lapic_state (in)
 :Returns: 0 on success, -1 on error
 
@@ -2292,7 +2309,7 @@ prior to calling the KVM_RUN ioctl.
 
 :Capability: KVM_CAP_ONE_REG
 :Architectures: all
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_one_reg (in)
 :Returns: 0 on success, negative value on failure
 
@@ -2907,7 +2924,7 @@ such as set vcpu counter or reset vcpu, and they have the following id bit patte
 
 :Capability: KVM_CAP_ONE_REG
 :Architectures: all
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_one_reg (in and out)
 :Returns: 0 on success, negative value on failure
 
@@ -2961,7 +2978,7 @@ after pausing the vcpu, but before it is resumed.
 
 :Capability: KVM_CAP_SIGNAL_MSI
 :Architectures: x86 arm64
-:Type: vm ioctl
+:Type: vm ioctl (all planes)
 :Parameters: struct kvm_msi (in)
 :Returns: >0 on delivery, 0 if guest blocked the MSI, and -1 on error
 
@@ -3564,7 +3581,7 @@ VCPU matching underlying host.
 
 :Capability: basic
 :Architectures: arm64, mips, riscv
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_reg_list (in/out)
 :Returns: 0 on success; -1 on error
 
@@ -4861,7 +4878,7 @@ The acceptable values for the flags field are::
 
 :Capability: KVM_CAP_NESTED_STATE
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_nested_state (in/out)
 :Returns: 0 on success, -1 on error
 
@@ -4935,7 +4952,7 @@ to the KVM_CHECK_EXTENSION ioctl().
 
 :Capability: KVM_CAP_NESTED_STATE
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_nested_state (in)
 :Returns: 0 on success, -1 on error
 
@@ -5816,7 +5833,7 @@ then ``length`` is returned.
 
 :Capability: KVM_CAP_SREGS2
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_sregs2 (out)
 :Returns: 0 on success, -1 on error
 
@@ -5849,7 +5866,7 @@ flags values for ``kvm_sregs2``:
 
 :Capability: KVM_CAP_SREGS2
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_sregs2 (in)
 :Returns: 0 on success, -1 on error
 
@@ -6065,7 +6082,7 @@ as the descriptors in Descriptors block.
 
 :Capability: KVM_CAP_XSAVE2
 :Architectures: x86
-:Type: vcpu ioctl
+:Type: vcpu ioctl (all planes)
 :Parameters: struct kvm_xsave (out)
 :Returns: 0 on success, -1 on error
 
@@ -6323,7 +6340,7 @@ Returns -EINVAL if called on a protected VM.
 
 :Capability: KVM_CAP_MEMORY_ATTRIBUTES
 :Architectures: x86
-:Type: vm ioctl
+:Type: vm ioctl (all planes)
 :Parameters: struct kvm_memory_attributes (in)
 :Returns: 0 on success, <0 on error
 
@@ -6458,6 +6475,46 @@ the capability to be present.
 `flags` must currently be zero.
 
 
+.. _KVM_CREATE_PLANE:
+
+4.144 KVM_CREATE_PLANE
+----------------------
+
+:Capability: KVM_CAP_PLANES
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
+:Capability: KVM_CAP_PLANES
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
@@ -6493,7 +6550,50 @@ This field is ignored if KVM_CAP_IMMEDIATE_EXIT is not available.
 
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
@@ -7162,6 +7262,44 @@ The valid value for 'flags' is:
   - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
     in VMCS. It would run into unknown result if resume the target VM.
 
+::
+
+    /* KVM_EXIT_PLANE_EVENT */
+    struct {
+  #define KVM_PLANE_EVENT_INTERRUPT	1
+      __u16 cause;
+      __u16 pending_event_planes;
+      __u16 target;
+      __u16 padding;
+      __u32 flags;
+      __u64 extra;
+    } plane_event;
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
+``req_exit_planes`` bitmap.  In this case, ``target`` is the AND of
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
@@ -8511,6 +8649,26 @@ ENOSYS for the others.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
+7.46 KVM_CAP_PLANES_FPU
+-----------------------
+
+:Architectures: x86
+:Parameters: arg[0] is 0 if each vCPU plane has a separate FPU,
+             1 if the FPU is shared
+:Type: vm
+
+When enabled, such as KVM_SET_XSAVE or KVM_SET_FPU *are* available for
+vCPU on all planes, but they will read and write the same data that is presented
+to other planes.  Note that KVM_GET/SET_XSAVE also allows access to some
+registers that are *not* part of FPU state; right now this is just PKRU.
+Those are never shared.
+
+KVM_CAP_PLANES_FPU is experimental; userspace must *not* assume that
+KVM_CAP_PLANES_FPU is present on x86 for *any* VM type and different
+VM types may or may not allow enabling KVM_CAP_PLANES_FPU.  Like for other
+capabilities, KVM_CAP_PLANES_FPU can be queried on the VM file descriptor;
+KVM_CHECK_EXTENSION returns 1 if it is possible to enable shared FPU mode.
+
 8. Other capabilities.
 ======================
 
@@ -9037,6 +9195,21 @@ KVM exits with the register state of either the L1 or L2 guest
 depending on which executed at the time of an exit. Userspace must
 take care to differentiate between these cases.
 
+8.46 KVM_CAP_PLANES
+-------------------
+
+:Capability: KVM_CAP_PLANES
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
2.49.0


