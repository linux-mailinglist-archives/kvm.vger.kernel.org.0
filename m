Return-Path: <kvm+bounces-42639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B86ECA7BAD1
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 12:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB77C3B9863
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551BE1E3DE0;
	Fri,  4 Apr 2025 10:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJcxDyBS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DD11DF721
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 10:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762579; cv=none; b=L+nv4BBVXZ5DaUQkPqSI6TUjZLeZiK33kShyV5jJ44RliXn1ZrF5COdNvSMc2aBZt+gJ7/m4rWzBwAFZDBmbSYtWAQCQqv0+V2Au7tBj9GtzI9YW2bQvgvYcK9iEAKupkrDbozz/mKMKJGzaWzzgAvs6J/GLlMPmVwCww7X0n94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762579; c=relaxed/simple;
	bh=CnGisSdUMgZmT1g+dRY1dxa5R+FZNycVlK/w/d90e7g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUBoK3OA32sJsFpbIsdA3BW1YfK0yaoK1j5LveSSu9tMjXG3E2lQZVNJKCUjupXZK0WKwaINnkJS2qcpX1P9RWEsy3+3MqT/yWg5idyJiXLKyCuiJQHd5/vyZqK5yROXVRqovMbWbgawSQ5gkz1diGMgNn+nMVzEvHDCPB1q/88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJcxDyBS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743762575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5MqRx8rKecmKEsI9m0q4clCM4JP8q1qj8d7wHp+XCA=;
	b=aJcxDyBSIUDpOaKVzDtd46Av61RSezBQpKwFjIcWtqdpbW3ZCL2DuWDw/Ctft90z4Px7hn
	RAO3vG2QFJ+gv/N+UJCip0rGPT06vSf24Beh9qG0sZGY2TIuI++hKh4ck5JYmTHnVeiepc
	gPxabANwJHOORQs5lWzryvOPxt15rMs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-FvhGBAyQO0CJwxGn-rQReQ-1; Fri, 04 Apr 2025 06:29:34 -0400
X-MC-Unique: FvhGBAyQO0CJwxGn-rQReQ-1
X-Mimecast-MFC-AGG-ID: FvhGBAyQO0CJwxGn-rQReQ_1743762573
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ac6ef2d1b7dso159894066b.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 03:29:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743762572; x=1744367372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j5MqRx8rKecmKEsI9m0q4clCM4JP8q1qj8d7wHp+XCA=;
        b=DdCOPfYUiH7sriE3Acrg2ND2iw9pG+EwrlcbJ2DGVslqt+KNz2AwtjOpAdl1wuD4Ip
         mF4BjNeUgIPnkvJ71hsf+7daQccYLQrJeW6FjQFZeVJ3GVTcTI/EQO5ibP1vLGD1EZ0e
         nKjNzX7DyJnPeXjFE434pRL1dnJ3KfnA17d0oFlC+l2rDftsKWcZd7aF0nHHVfdVnMK0
         LpWgLJtMI/joGwo63ildMZr/Ao4w/FbMRD0MgnskruG82kjmguwatXpS+OA9lhoUbos+
         p2Q4kQgCH1j6yrOzeP31aZHR/Hw1TYNJmoA2V75Xl4s+DkhU+jIP7XjsQRVPFEFbRBV2
         PDpA==
X-Forwarded-Encrypted: i=1; AJvYcCXEeCjkjx11WDeZ/YNg44v2EaKHAhIC9/rKpm+bCLuQcWXV5lN4Kx4z3Xhyb6uwmUhY+Mo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZc8/5mwkPmXqr5oxfqBktcZ+NKTgg3I8CQ3RvpjZeyuQQm2ml
	+2ook3UDgHd8CrQw4tt7JnCiw94oq9f0A5DhUGo9JWNFuSdUKbFfOpsvLzMb9RSPxnF16cwFLe6
	nI19VHD4t1sLKmn/WlciQp6TDGywX8oIVWK1WXC0jwmq9VznPkNwL1gsCQw==
X-Gm-Gg: ASbGncslaHdPBVl+L6D3Pbol44XrsKaovGGv3atg1GSRvix1IhMLYUnPB+ipxorjwWc
	Lw1aNqNV+vC6ClbgMYPwoGIoeO+iOsgA2csCSbb/iSSn3a1CEvf5sjXC143yjHM1Lax+NzHOLka
	dTF+n8zYk3WLkr+CAIFgjFIiLuheQqu8R/pC9EzNCxL4eZtTdtljYvSvmTT0A3evb3IYeDWlPiv
	nc7OllcM6kUtMKK/+aT92SZussxz7tILD/zi+fEg7sbshBRxPNgpGYGx1AjuCkIlJF7cNozUMje
	SdJ+M+mfdXPwp3HJzOfc
X-Received: by 2002:a17:907:97cd:b0:ac3:8537:904e with SMTP id a640c23a62f3a-ac7d6f1b6a3mr158988466b.49.1743762571827;
        Fri, 04 Apr 2025 03:29:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFoWybIi6xBVg/aMencX10xR0oUAn/mlt2+KoUr5i2dDQh9XWIAXEK2jiDUiRR6Mz1lhLOy/Q==
X-Received: by 2002:a17:907:97cd:b0:ac3:8537:904e with SMTP id a640c23a62f3a-ac7d6f1b6a3mr158985566b.49.1743762571089;
        Fri, 04 Apr 2025 03:29:31 -0700 (PDT)
Received: from [192.168.122.1] ([151.49.230.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c013ebe9sm233275866b.99.2025.04.04.03.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 03:29:30 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 4/5] Documentation: kvm: organize capabilities in the right section
Date: Fri,  4 Apr 2025 12:29:18 +0200
Message-ID: <20250404102919.171952-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404102919.171952-1-pbonzini@redhat.com>
References: <20250404102919.171952-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Categorize the capabilities correctly.  Section 6 is for enabled vCPU
capabilities; section 7 is for enabled VM capabilities; section 8 is
for informational ones.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 678 +++++++++++++++++----------------
 1 file changed, 340 insertions(+), 338 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e5e7fd42b47c..469b64d229a6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7458,6 +7458,75 @@ Unused bitfields in the bitarrays must be set to zero.
 
 This capability connects the vcpu to an in-kernel XIVE device.
 
+6.76 KVM_CAP_HYPERV_SYNIC
+-------------------------
+
+:Architectures: x86
+:Target: vcpu
+
+This capability, if KVM_CHECK_EXTENSION indicates that it is
+available, means that the kernel has an implementation of the
+Hyper-V Synthetic interrupt controller(SynIC). Hyper-V SynIC is
+used to support Windows Hyper-V based guest paravirt drivers(VMBus).
+
+In order to use SynIC, it has to be activated by setting this
+capability via KVM_ENABLE_CAP ioctl on the vcpu fd. Note that this
+will disable the use of APIC hardware virtualization even if supported
+by the CPU, as it's incompatible with SynIC auto-EOI behavior.
+
+6.77 KVM_CAP_HYPERV_SYNIC2
+--------------------------
+
+:Architectures: x86
+:Target: vcpu
+
+This capability enables a newer version of Hyper-V Synthetic interrupt
+controller (SynIC).  The only difference with KVM_CAP_HYPERV_SYNIC is that KVM
+doesn't clear SynIC message and event flags pages when they are enabled by
+writing to the respective MSRs.
+
+6.78 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
+-----------------------------------
+
+:Architectures: x86
+:Target: vcpu
+
+This capability indicates that KVM running on top of Hyper-V hypervisor
+enables Direct TLB flush for its guests meaning that TLB flush
+hypercalls are handled by Level 0 hypervisor (Hyper-V) bypassing KVM.
+Due to the different ABI for hypercall parameters between Hyper-V and
+KVM, enabling this capability effectively disables all hypercall
+handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
+flush hypercalls by Hyper-V) so userspace should disable KVM identification
+in CPUID and only exposes Hyper-V identification. In this case, guest
+thinks it's running on Hyper-V and only use Hyper-V hypercalls.
+
+6.79 KVM_CAP_HYPERV_ENFORCE_CPUID
+---------------------------------
+
+:Architectures: x86
+:Target: vcpu
+
+When enabled, KVM will disable emulated Hyper-V features provided to the
+guest according to the bits Hyper-V CPUID feature leaves. Otherwise, all
+currently implemented Hyper-V features are provided unconditionally when
+Hyper-V identification is set in the HYPERV_CPUID_INTERFACE (0x40000001)
+leaf.
+
+6.80 KVM_CAP_ENFORCE_PV_FEATURE_CPUID
+-------------------------------------
+
+:Architectures: x86
+:Target: vcpu
+
+When enabled, KVM will disable paravirtual features provided to the
+guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
+(0x40000001). Otherwise, a guest may use the paravirtual features
+regardless of what has actually been exposed through the CPUID leaf.
+
+.. _KVM_CAP_DIRTY_LOG_RING:
+
+
 .. _cap_enable_vm:
 
 7. Capabilities that can be enabled on VMs
@@ -7974,23 +8043,6 @@ default.
 
 See Documentation/arch/x86/sgx.rst for more details.
 
-7.26 KVM_CAP_PPC_RPT_INVALIDATE
--------------------------------
-
-:Architectures: ppc
-:Type: vm
-
-This capability indicates that the kernel is capable of handling
-H_RPT_INVALIDATE hcall.
-
-In order to enable the use of H_RPT_INVALIDATE in the guest,
-user space might have to advertise it for the guest. For example,
-IBM pSeries (sPAPR) guest starts using it if "hcall-rpt-invalidate" is
-present in the "ibm,hypertas-functions" device-tree property.
-
-This capability is enabled for hypervisors on platforms like POWER9
-that support radix MMU.
-
 7.27 KVM_CAP_EXIT_ON_EMULATION_FAILURE
 --------------------------------------
 
@@ -8048,19 +8100,6 @@ indicated by the fd to the VM this is called on.
 This is intended to support intra-host migration of VMs between userspace VMMs,
 upgrading the VMM process without interrupting the guest.
 
-7.30 KVM_CAP_PPC_AIL_MODE_3
--------------------------------
-
-:Architectures: ppc
-:Type: vm
-
-This capability indicates that the kernel supports the mode 3 setting for the
-"Address Translation Mode on Interrupt" aka "Alternate Interrupt Location"
-resource that is controlled with the H_SET_MODE hypercall.
-
-This capability allows a guest kernel to use a better-performance mode for
-handling interrupts and system calls.
-
 7.31 KVM_CAP_DISABLE_QUIRKS2
 ----------------------------
 
@@ -8240,27 +8279,6 @@ This capability is aimed to mitigate the threat that malicious VMs can
 cause CPU stuck (due to event windows don't open up) and make the CPU
 unavailable to host or other VMs.
 
-7.34 KVM_CAP_MEMORY_FAULT_INFO
-------------------------------
-
-:Architectures: x86
-:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
-
-The presence of this capability indicates that KVM_RUN will fill
-kvm_run.memory_fault if KVM cannot resolve a guest page fault VM-Exit, e.g. if
-there is a valid memslot but no backing VMA for the corresponding host virtual
-address.
-
-The information in kvm_run.memory_fault is valid if and only if KVM_RUN returns
-an error with errno=EFAULT or errno=EHWPOISON *and* kvm_run.exit_reason is set
-to KVM_EXIT_MEMORY_FAULT.
-
-Note: Userspaces which attempt to resolve memory faults so that they can retry
-KVM_RUN are encouraged to guard against repeatedly receiving the same
-error/annotated fault.
-
-See KVM_EXIT_MEMORY_FAULT for more information.
-
 7.35 KVM_CAP_X86_APIC_BUS_CYCLES_NS
 -----------------------------------
 
@@ -8278,19 +8296,220 @@ by KVM_CHECK_EXTENSION.
 Note: Userspace is responsible for correctly configuring CPUID 0x15, a.k.a. the
 core crystal clock frequency, if a non-zero CPUID 0x15 is exposed to the guest.
 
-7.36 KVM_CAP_X86_GUEST_MODE
-------------------------------
+7.36 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
+----------------------------------------------------------
+
+:Architectures: x86, arm64
+:Type: vm
+:Parameters: args[0] - size of the dirty log ring
+
+KVM is capable of tracking dirty memory using ring buffers that are
+mmapped into userspace; there is one dirty ring per vcpu.
+
+The dirty ring is available to userspace as an array of
+``struct kvm_dirty_gfn``.  Each dirty entry is defined as::
+
+  struct kvm_dirty_gfn {
+          __u32 flags;
+          __u32 slot; /* as_id | slot_id */
+          __u64 offset;
+  };
+
+The following values are defined for the flags field to define the
+current state of the entry::
+
+  #define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
+  #define KVM_DIRTY_GFN_F_RESET           BIT(1)
+  #define KVM_DIRTY_GFN_F_MASK            0x3
+
+Userspace should call KVM_ENABLE_CAP ioctl right after KVM_CREATE_VM
+ioctl to enable this capability for the new guest and set the size of
+the rings.  Enabling the capability is only allowed before creating any
+vCPU, and the size of the ring must be a power of two.  The larger the
+ring buffer, the less likely the ring is full and the VM is forced to
+exit to userspace. The optimal size depends on the workload, but it is
+recommended that it be at least 64 KiB (4096 entries).
+
+Just like for dirty page bitmaps, the buffer tracks writes to
+all user memory regions for which the KVM_MEM_LOG_DIRTY_PAGES flag was
+set in KVM_SET_USER_MEMORY_REGION.  Once a memory region is registered
+with the flag set, userspace can start harvesting dirty pages from the
+ring buffer.
+
+An entry in the ring buffer can be unused (flag bits ``00``),
+dirty (flag bits ``01``) or harvested (flag bits ``1X``).  The
+state machine for the entry is as follows::
+
+          dirtied         harvested        reset
+     00 -----------> 01 -------------> 1X -------+
+      ^                                          |
+      |                                          |
+      +------------------------------------------+
+
+To harvest the dirty pages, userspace accesses the mmapped ring buffer
+to read the dirty GFNs.  If the flags has the DIRTY bit set (at this stage
+the RESET bit must be cleared), then it means this GFN is a dirty GFN.
+The userspace should harvest this GFN and mark the flags from state
+``01b`` to ``1Xb`` (bit 0 will be ignored by KVM, but bit 1 must be set
+to show that this GFN is harvested and waiting for a reset), and move
+on to the next GFN.  The userspace should continue to do this until the
+flags of a GFN have the DIRTY bit cleared, meaning that it has harvested
+all the dirty GFNs that were available.
+
+Note that on weakly ordered architectures, userspace accesses to the
+ring buffer (and more specifically the 'flags' field) must be ordered,
+using load-acquire/store-release accessors when available, or any
+other memory barrier that will ensure this ordering.
+
+It's not necessary for userspace to harvest the all dirty GFNs at once.
+However it must collect the dirty GFNs in sequence, i.e., the userspace
+program cannot skip one dirty GFN to collect the one next to it.
+
+After processing one or more entries in the ring buffer, userspace
+calls the VM ioctl KVM_RESET_DIRTY_RINGS to notify the kernel about
+it, so that the kernel will reprotect those collected GFNs.
+Therefore, the ioctl must be called *before* reading the content of
+the dirty pages.
+
+The dirty ring can get full.  When it happens, the KVM_RUN of the
+vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
+
+The dirty ring interface has a major difference comparing to the
+KVM_GET_DIRTY_LOG interface in that, when reading the dirty ring from
+userspace, it's still possible that the kernel has not yet flushed the
+processor's dirty page buffers into the kernel buffer (with dirty bitmaps, the
+flushing is done by the KVM_GET_DIRTY_LOG ioctl).  To achieve that, one
+needs to kick the vcpu out of KVM_RUN using a signal.  The resulting
+vmexit ensures that all dirty GFNs are flushed to the dirty rings.
+
+NOTE: KVM_CAP_DIRTY_LOG_RING_ACQ_REL is the only capability that
+should be exposed by weakly ordered architecture, in order to indicate
+the additional memory ordering requirements imposed on userspace when
+reading the state of an entry and mutating it from DIRTY to HARVESTED.
+Architecture with TSO-like ordering (such as x86) are allowed to
+expose both KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL
+to userspace.
+
+After enabling the dirty rings, the userspace needs to detect the
+capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP to see whether the
+ring structures can be backed by per-slot bitmaps. With this capability
+advertised, it means the architecture can dirty guest pages without
+vcpu/ring context, so that some of the dirty information will still be
+maintained in the bitmap structure. KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
+can't be enabled if the capability of KVM_CAP_DIRTY_LOG_RING_ACQ_REL
+hasn't been enabled, or any memslot has been existing.
+
+Note that the bitmap here is only a backup of the ring structure. The
+use of the ring and bitmap combination is only beneficial if there is
+only a very small amount of memory that is dirtied out of vcpu/ring
+context. Otherwise, the stand-alone per-slot bitmap mechanism needs to
+be considered.
+
+To collect dirty bits in the backup bitmap, userspace can use the same
+KVM_GET_DIRTY_LOG ioctl. KVM_CLEAR_DIRTY_LOG isn't needed as long as all
+the generation of the dirty bits is done in a single pass. Collecting
+the dirty bitmap should be the very last thing that the VMM does before
+considering the state as complete. VMM needs to ensure that the dirty
+state is final and avoid missing dirty pages from another ioctl ordered
+after the bitmap collection.
+
+NOTE: Multiple examples of using the backup bitmap: (1) save vgic/its
+tables through command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} on
+KVM device "kvm-arm-vgic-its". (2) restore vgic/its tables through
+command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM device
+"kvm-arm-vgic-its". VGICv3 LPI pending status is restored. (3) save
+vgic3 pending table through KVM_DEV_ARM_VGIC_{GRP_CTRL, SAVE_PENDING_TABLES}
+command on KVM device "kvm-arm-vgic-v3".
+
+7.37 KVM_CAP_PMU_CAPABILITY
+---------------------------
 
 :Architectures: x86
-:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+:Type: vm
+:Parameters: arg[0] is bitmask of PMU virtualization capabilities.
+:Returns: 0 on success, -EINVAL when arg[0] contains invalid bits
 
-The presence of this capability indicates that KVM_RUN will update the
-KVM_RUN_X86_GUEST_MODE bit in kvm_run.flags to indicate whether the
-vCPU was executing nested guest code when it exited.
+This capability alters PMU virtualization in KVM.
 
-KVM exits with the register state of either the L1 or L2 guest
-depending on which executed at the time of an exit. Userspace must
-take care to differentiate between these cases.
+Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
+PMU virtualization capabilities that can be adjusted on a VM.
+
+The argument to KVM_ENABLE_CAP is also a bitmask and selects specific
+PMU virtualization capabilities to be applied to the VM.  This can
+only be invoked on a VM prior to the creation of VCPUs.
+
+At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
+this capability will disable PMU virtualization for that VM.  Usermode
+should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
+
+7.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
+-------------------------------------
+
+:Architectures: x86
+:Type: vm
+:Parameters: arg[0] must be 0.
+:Returns: 0 on success, -EPERM if the userspace process does not
+          have CAP_SYS_BOOT, -EINVAL if args[0] is not 0 or any vCPUs have been
+          created.
+
+This capability disables the NX huge pages mitigation for iTLB MULTIHIT.
+
+The capability has no effect if the nx_huge_pages module parameter is not set.
+
+This capability may only be set before any vCPUs are created.
+
+7.39 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
+---------------------------------------
+
+:Architectures: arm64
+:Type: vm
+:Parameters: arg[0] is the new split chunk size.
+:Returns: 0 on success, -EINVAL if any memslot was already created.
+
+This capability sets the chunk size used in Eager Page Splitting.
+
+Eager Page Splitting improves the performance of dirty-logging (used
+in live migrations) when guest memory is backed by huge-pages.  It
+avoids splitting huge-pages (into PAGE_SIZE pages) on fault, by doing
+it eagerly when enabling dirty logging (with the
+KVM_MEM_LOG_DIRTY_PAGES flag for a memory region), or when using
+KVM_CLEAR_DIRTY_LOG.
+
+The chunk size specifies how many pages to break at a time, using a
+single allocation for each chunk. Bigger the chunk size, more pages
+need to be allocated ahead of time.
+
+The chunk size needs to be a valid block size. The list of acceptable
+block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a
+64-bit bitmap (each bit describing a block size). The default value is
+0, to disable the eager page splitting.
+
+7.40 KVM_CAP_EXIT_HYPERCALL
+---------------------------
+
+:Architectures: x86
+:Type: vm
+
+This capability, if enabled, will cause KVM to exit to userspace
+with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
+
+Calling KVM_CHECK_EXTENSION for this capability will return a bitmask
+of hypercalls that can be configured to exit to userspace.
+Right now, the only such hypercall is KVM_HC_MAP_GPA_RANGE.
+
+The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
+of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
+the hypercalls whose corresponding bit is in the argument, and return
+ENOSYS for the others.
+
+7.41 KVM_CAP_ARM_SYSTEM_SUSPEND
+-------------------------------
+
+:Architectures: arm64
+:Type: vm
+
+When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
+type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
 8. Other capabilities.
 ======================
@@ -8309,21 +8528,6 @@ H_RANDOM hypercall backed by a hardware random-number generator.
 If present, the kernel H_RANDOM handler can be enabled for guest use
 with the KVM_CAP_PPC_ENABLE_HCALL capability.
 
-8.2 KVM_CAP_HYPERV_SYNIC
-------------------------
-
-:Architectures: x86
-
-This capability, if KVM_CHECK_EXTENSION indicates that it is
-available, means that the kernel has an implementation of the
-Hyper-V Synthetic interrupt controller(SynIC). Hyper-V SynIC is
-used to support Windows Hyper-V based guest paravirt drivers(VMBus).
-
-In order to use SynIC, it has to be activated by setting this
-capability via KVM_ENABLE_CAP ioctl on the vcpu fd. Note that this
-will disable the use of APIC hardware virtualization even if supported
-by the CPU, as it's incompatible with SynIC auto-EOI behavior.
-
 8.3 KVM_CAP_PPC_MMU_RADIX
 -------------------------
 
@@ -8469,16 +8673,6 @@ virtual SMT modes that can be set using KVM_CAP_PPC_SMT.  If bit N
 (counting from the right) is set, then a virtual SMT mode of 2^N is
 available.
 
-8.11 KVM_CAP_HYPERV_SYNIC2
---------------------------
-
-:Architectures: x86
-
-This capability enables a newer version of Hyper-V Synthetic interrupt
-controller (SynIC).  The only difference with KVM_CAP_HYPERV_SYNIC is that KVM
-doesn't clear SynIC message and event flags pages when they are enabled by
-writing to the respective MSRs.
-
 8.12 KVM_CAP_HYPERV_VP_INDEX
 ----------------------------
 
@@ -8493,7 +8687,6 @@ capability is absent, userspace can still query this msr's value.
 -------------------------------
 
 :Architectures: s390
-:Parameters: none
 
 This capability indicates if the flic device will be able to get/set the
 AIS states for migration via the KVM_DEV_FLIC_AISM_ALL attribute and allows
@@ -8567,21 +8760,6 @@ This capability indicates that KVM supports paravirtualized Hyper-V IPI send
 hypercalls:
 HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
 
-8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
------------------------------------
-
-:Architectures: x86
-
-This capability indicates that KVM running on top of Hyper-V hypervisor
-enables Direct TLB flush for its guests meaning that TLB flush
-hypercalls are handled by Level 0 hypervisor (Hyper-V) bypassing KVM.
-Due to the different ABI for hypercall parameters between Hyper-V and
-KVM, enabling this capability effectively disables all hypercall
-handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
-flush hypercalls by Hyper-V) so userspace should disable KVM identification
-in CPUID and only exposes Hyper-V identification. In this case, guest
-thinks it's running on Hyper-V and only use Hyper-V hypercalls.
-
 8.22 KVM_CAP_S390_VCPU_RESETS
 -----------------------------
 
@@ -8659,142 +8837,6 @@ In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space to
 trap and emulate MSRs that are outside of the scope of KVM as well as
 limit the attack surface on KVM's MSR emulation code.
 
-8.28 KVM_CAP_ENFORCE_PV_FEATURE_CPUID
--------------------------------------
-
-:Architectures: x86
-
-When enabled, KVM will disable paravirtual features provided to the
-guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
-(0x40000001). Otherwise, a guest may use the paravirtual features
-regardless of what has actually been exposed through the CPUID leaf.
-
-.. _KVM_CAP_DIRTY_LOG_RING:
-
-8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
-----------------------------------------------------------
-
-:Architectures: x86, arm64
-:Parameters: args[0] - size of the dirty log ring
-
-KVM is capable of tracking dirty memory using ring buffers that are
-mmapped into userspace; there is one dirty ring per vcpu.
-
-The dirty ring is available to userspace as an array of
-``struct kvm_dirty_gfn``.  Each dirty entry is defined as::
-
-  struct kvm_dirty_gfn {
-          __u32 flags;
-          __u32 slot; /* as_id | slot_id */
-          __u64 offset;
-  };
-
-The following values are defined for the flags field to define the
-current state of the entry::
-
-  #define KVM_DIRTY_GFN_F_DIRTY           BIT(0)
-  #define KVM_DIRTY_GFN_F_RESET           BIT(1)
-  #define KVM_DIRTY_GFN_F_MASK            0x3
-
-Userspace should call KVM_ENABLE_CAP ioctl right after KVM_CREATE_VM
-ioctl to enable this capability for the new guest and set the size of
-the rings.  Enabling the capability is only allowed before creating any
-vCPU, and the size of the ring must be a power of two.  The larger the
-ring buffer, the less likely the ring is full and the VM is forced to
-exit to userspace. The optimal size depends on the workload, but it is
-recommended that it be at least 64 KiB (4096 entries).
-
-Just like for dirty page bitmaps, the buffer tracks writes to
-all user memory regions for which the KVM_MEM_LOG_DIRTY_PAGES flag was
-set in KVM_SET_USER_MEMORY_REGION.  Once a memory region is registered
-with the flag set, userspace can start harvesting dirty pages from the
-ring buffer.
-
-An entry in the ring buffer can be unused (flag bits ``00``),
-dirty (flag bits ``01``) or harvested (flag bits ``1X``).  The
-state machine for the entry is as follows::
-
-          dirtied         harvested        reset
-     00 -----------> 01 -------------> 1X -------+
-      ^                                          |
-      |                                          |
-      +------------------------------------------+
-
-To harvest the dirty pages, userspace accesses the mmapped ring buffer
-to read the dirty GFNs.  If the flags has the DIRTY bit set (at this stage
-the RESET bit must be cleared), then it means this GFN is a dirty GFN.
-The userspace should harvest this GFN and mark the flags from state
-``01b`` to ``1Xb`` (bit 0 will be ignored by KVM, but bit 1 must be set
-to show that this GFN is harvested and waiting for a reset), and move
-on to the next GFN.  The userspace should continue to do this until the
-flags of a GFN have the DIRTY bit cleared, meaning that it has harvested
-all the dirty GFNs that were available.
-
-Note that on weakly ordered architectures, userspace accesses to the
-ring buffer (and more specifically the 'flags' field) must be ordered,
-using load-acquire/store-release accessors when available, or any
-other memory barrier that will ensure this ordering.
-
-It's not necessary for userspace to harvest the all dirty GFNs at once.
-However it must collect the dirty GFNs in sequence, i.e., the userspace
-program cannot skip one dirty GFN to collect the one next to it.
-
-After processing one or more entries in the ring buffer, userspace
-calls the VM ioctl KVM_RESET_DIRTY_RINGS to notify the kernel about
-it, so that the kernel will reprotect those collected GFNs.
-Therefore, the ioctl must be called *before* reading the content of
-the dirty pages.
-
-The dirty ring can get full.  When it happens, the KVM_RUN of the
-vcpu will return with exit reason KVM_EXIT_DIRTY_LOG_FULL.
-
-The dirty ring interface has a major difference comparing to the
-KVM_GET_DIRTY_LOG interface in that, when reading the dirty ring from
-userspace, it's still possible that the kernel has not yet flushed the
-processor's dirty page buffers into the kernel buffer (with dirty bitmaps, the
-flushing is done by the KVM_GET_DIRTY_LOG ioctl).  To achieve that, one
-needs to kick the vcpu out of KVM_RUN using a signal.  The resulting
-vmexit ensures that all dirty GFNs are flushed to the dirty rings.
-
-NOTE: KVM_CAP_DIRTY_LOG_RING_ACQ_REL is the only capability that
-should be exposed by weakly ordered architecture, in order to indicate
-the additional memory ordering requirements imposed on userspace when
-reading the state of an entry and mutating it from DIRTY to HARVESTED.
-Architecture with TSO-like ordering (such as x86) are allowed to
-expose both KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL
-to userspace.
-
-After enabling the dirty rings, the userspace needs to detect the
-capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP to see whether the
-ring structures can be backed by per-slot bitmaps. With this capability
-advertised, it means the architecture can dirty guest pages without
-vcpu/ring context, so that some of the dirty information will still be
-maintained in the bitmap structure. KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
-can't be enabled if the capability of KVM_CAP_DIRTY_LOG_RING_ACQ_REL
-hasn't been enabled, or any memslot has been existing.
-
-Note that the bitmap here is only a backup of the ring structure. The
-use of the ring and bitmap combination is only beneficial if there is
-only a very small amount of memory that is dirtied out of vcpu/ring
-context. Otherwise, the stand-alone per-slot bitmap mechanism needs to
-be considered.
-
-To collect dirty bits in the backup bitmap, userspace can use the same
-KVM_GET_DIRTY_LOG ioctl. KVM_CLEAR_DIRTY_LOG isn't needed as long as all
-the generation of the dirty bits is done in a single pass. Collecting
-the dirty bitmap should be the very last thing that the VMM does before
-considering the state as complete. VMM needs to ensure that the dirty
-state is final and avoid missing dirty pages from another ioctl ordered
-after the bitmap collection.
-
-NOTE: Multiple examples of using the backup bitmap: (1) save vgic/its
-tables through command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} on
-KVM device "kvm-arm-vgic-its". (2) restore vgic/its tables through
-command KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} on KVM device
-"kvm-arm-vgic-its". VGICv3 LPI pending status is restored. (3) save
-vgic3 pending table through KVM_DEV_ARM_VGIC_{GRP_CTRL, SAVE_PENDING_TABLES}
-command on KVM device "kvm-arm-vgic-v3".
-
 8.30 KVM_CAP_XEN_HVM
 --------------------
 
@@ -8893,65 +8935,6 @@ This capability indicates that the KVM virtual PTP service is
 supported in the host. A VMM can check whether the service is
 available to the guest on migration.
 
-8.33 KVM_CAP_HYPERV_ENFORCE_CPUID
----------------------------------
-
-:Architectures: x86
-
-When enabled, KVM will disable emulated Hyper-V features provided to the
-guest according to the bits Hyper-V CPUID feature leaves. Otherwise, all
-currently implemented Hyper-V features are provided unconditionally when
-Hyper-V identification is set in the HYPERV_CPUID_INTERFACE (0x40000001)
-leaf.
-
-8.34 KVM_CAP_EXIT_HYPERCALL
----------------------------
-
-:Architectures: x86
-:Type: vm
-
-This capability, if enabled, will cause KVM to exit to userspace
-with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
-
-Calling KVM_CHECK_EXTENSION for this capability will return a bitmask
-of hypercalls that can be configured to exit to userspace.
-Right now, the only such hypercall is KVM_HC_MAP_GPA_RANGE.
-
-The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
-of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
-the hypercalls whose corresponding bit is in the argument, and return
-ENOSYS for the others.
-
-8.35 KVM_CAP_PMU_CAPABILITY
----------------------------
-
-:Architectures: x86
-:Type: vm
-:Parameters: arg[0] is bitmask of PMU virtualization capabilities.
-:Returns: 0 on success, -EINVAL when arg[0] contains invalid bits
-
-This capability alters PMU virtualization in KVM.
-
-Calling KVM_CHECK_EXTENSION for this capability returns a bitmask of
-PMU virtualization capabilities that can be adjusted on a VM.
-
-The argument to KVM_ENABLE_CAP is also a bitmask and selects specific
-PMU virtualization capabilities to be applied to the VM.  This can
-only be invoked on a VM prior to the creation of VCPUs.
-
-At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
-this capability will disable PMU virtualization for that VM.  Usermode
-should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
-
-8.36 KVM_CAP_ARM_SYSTEM_SUSPEND
--------------------------------
-
-:Architectures: arm64
-:Type: vm
-
-When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
-type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
-
 8.37 KVM_CAP_S390_PROTECTED_DUMP
 --------------------------------
 
@@ -8964,22 +8947,6 @@ PV guests. The `KVM_PV_DUMP` command is available for the
 dump related UV data. Also the vcpu ioctl `KVM_S390_PV_CPU_COMMAND` is
 available and supports the `KVM_PV_DUMP_CPU` subcommand.
 
-8.38 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
--------------------------------------
-
-:Architectures: x86
-:Type: vm
-:Parameters: arg[0] must be 0.
-:Returns: 0 on success, -EPERM if the userspace process does not
-          have CAP_SYS_BOOT, -EINVAL if args[0] is not 0 or any vCPUs have been
-          created.
-
-This capability disables the NX huge pages mitigation for iTLB MULTIHIT.
-
-The capability has no effect if the nx_huge_pages module parameter is not set.
-
-This capability may only be set before any vCPUs are created.
-
 8.39 KVM_CAP_S390_CPU_TOPOLOGY
 ------------------------------
 
@@ -9004,32 +8971,6 @@ structure.
 When getting the Modified Change Topology Report value, the attr->addr
 must point to a byte where the value will be stored or retrieved from.
 
-8.40 KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
----------------------------------------
-
-:Architectures: arm64
-:Type: vm
-:Parameters: arg[0] is the new split chunk size.
-:Returns: 0 on success, -EINVAL if any memslot was already created.
-
-This capability sets the chunk size used in Eager Page Splitting.
-
-Eager Page Splitting improves the performance of dirty-logging (used
-in live migrations) when guest memory is backed by huge-pages.  It
-avoids splitting huge-pages (into PAGE_SIZE pages) on fault, by doing
-it eagerly when enabling dirty logging (with the
-KVM_MEM_LOG_DIRTY_PAGES flag for a memory region), or when using
-KVM_CLEAR_DIRTY_LOG.
-
-The chunk size specifies how many pages to break at a time, using a
-single allocation for each chunk. Bigger the chunk size, more pages
-need to be allocated ahead of time.
-
-The chunk size needs to be a valid block size. The list of acceptable
-block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a
-64-bit bitmap (each bit describing a block size). The default value is
-0, to disable the eager page splitting.
-
 8.41 KVM_CAP_VM_TYPES
 ---------------------
 
@@ -9049,6 +8990,67 @@ Do not use KVM_X86_SW_PROTECTED_VM for "real" VMs, and especially not in
 production.  The behavior and effective ABI for software-protected VMs is
 unstable.
 
+8.42 KVM_CAP_PPC_RPT_INVALIDATE
+-------------------------------
+
+:Architectures: ppc
+
+This capability indicates that the kernel is capable of handling
+H_RPT_INVALIDATE hcall.
+
+In order to enable the use of H_RPT_INVALIDATE in the guest,
+user space might have to advertise it for the guest. For example,
+IBM pSeries (sPAPR) guest starts using it if "hcall-rpt-invalidate" is
+present in the "ibm,hypertas-functions" device-tree property.
+
+This capability is enabled for hypervisors on platforms like POWER9
+that support radix MMU.
+
+8.43 KVM_CAP_PPC_AIL_MODE_3
+---------------------------
+
+:Architectures: ppc
+
+This capability indicates that the kernel supports the mode 3 setting for the
+"Address Translation Mode on Interrupt" aka "Alternate Interrupt Location"
+resource that is controlled with the H_SET_MODE hypercall.
+
+This capability allows a guest kernel to use a better-performance mode for
+handling interrupts and system calls.
+
+8.44 KVM_CAP_MEMORY_FAULT_INFO
+------------------------------
+
+:Architectures: x86
+
+The presence of this capability indicates that KVM_RUN will fill
+kvm_run.memory_fault if KVM cannot resolve a guest page fault VM-Exit, e.g. if
+there is a valid memslot but no backing VMA for the corresponding host virtual
+address.
+
+The information in kvm_run.memory_fault is valid if and only if KVM_RUN returns
+an error with errno=EFAULT or errno=EHWPOISON *and* kvm_run.exit_reason is set
+to KVM_EXIT_MEMORY_FAULT.
+
+Note: Userspaces which attempt to resolve memory faults so that they can retry
+KVM_RUN are encouraged to guard against repeatedly receiving the same
+error/annotated fault.
+
+See KVM_EXIT_MEMORY_FAULT for more information.
+
+8.45 KVM_CAP_X86_GUEST_MODE
+---------------------------
+
+:Architectures: x86
+
+The presence of this capability indicates that KVM_RUN will update the
+KVM_RUN_X86_GUEST_MODE bit in kvm_run.flags to indicate whether the
+vCPU was executing nested guest code when it exited.
+
+KVM exits with the register state of either the L1 or L2 guest
+depending on which executed at the time of an exit. Userspace must
+take care to differentiate between these cases.
+
 9. Known KVM API problems
 =========================
 
-- 
2.49.0


