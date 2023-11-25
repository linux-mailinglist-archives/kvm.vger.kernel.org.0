Return-Path: <kvm+bounces-2455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 381297F8934
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 09:26:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7BDA2817E2
	for <lists+kvm@lfdr.de>; Sat, 25 Nov 2023 08:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5C009469;
	Sat, 25 Nov 2023 08:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YHzkIWq0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F624B7
	for <kvm@vger.kernel.org>; Sat, 25 Nov 2023 00:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700900790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cLt0kMstEnQMJTOsln80QC+cyRNJlJGmKrNPOs17POo=;
	b=YHzkIWq0wxzP9zDsvsGeGVPHSAG14VBv04f+R98w6PRnWSodFJW7Juuab6adqM6zyRWGs2
	VK9VtTttYT//qZjRCtfiZt26iCP9EphrvKrq+AaQAmGMrf1x0buxkxlHJuSmd2WlEW90WD
	OrXSK9GtuoAFhEl5ynku8Llj1iq87co=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-CgxO-fdNPBCKacT9AHIE5g-1; Sat, 25 Nov 2023 03:26:25 -0500
X-MC-Unique: CgxO-fdNPBCKacT9AHIE5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7951985A58C;
	Sat, 25 Nov 2023 08:26:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 61817C1596F;
	Sat, 25 Nov 2023 08:26:25 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] KVM: remove deprecated UAPIs
Date: Sat, 25 Nov 2023 03:26:24 -0500
Message-Id: <20231125082624.1397344-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

The deprecated interfaces were removed 15 years ago.  KVM's
device assignment was deprecated in 4.2 and removed 6.5 years
ago; the only interest might be in compiling ancient versions
of QEMU, but QEMU has been using its own imported copy of the
kernel headers since June 2011.  So again we go into archaeology
territory; just remove the cruft.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 12 -----
 include/uapi/linux/kvm.h       | 90 ----------------------------------
 virt/kvm/kvm_main.c            |  5 --
 3 files changed, 107 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7025b3751027..096d95a9d554 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -608,18 +608,6 @@ interrupt number dequeues the interrupt.
 This is an asynchronous vcpu ioctl and can be invoked from any thread.
 
 
-4.17 KVM_DEBUG_GUEST
---------------------
-
-:Capability: basic
-:Architectures: none
-:Type: vcpu ioctl
-:Parameters: none)
-:Returns: -1 on error
-
-Support for this has been removed.  Use KVM_SET_GUEST_DEBUG instead.
-
-
 4.18 KVM_GET_MSRS
 -----------------
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 211b86de35ac..ebffc193a8bf 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -16,76 +16,6 @@
 
 #define KVM_API_VERSION 12
 
-/* *** Deprecated interfaces *** */
-
-#define KVM_TRC_SHIFT           16
-
-#define KVM_TRC_ENTRYEXIT       (1 << KVM_TRC_SHIFT)
-#define KVM_TRC_HANDLER         (1 << (KVM_TRC_SHIFT + 1))
-
-#define KVM_TRC_VMENTRY         (KVM_TRC_ENTRYEXIT + 0x01)
-#define KVM_TRC_VMEXIT          (KVM_TRC_ENTRYEXIT + 0x02)
-#define KVM_TRC_PAGE_FAULT      (KVM_TRC_HANDLER + 0x01)
-
-#define KVM_TRC_HEAD_SIZE       12
-#define KVM_TRC_CYCLE_SIZE      8
-#define KVM_TRC_EXTRA_MAX       7
-
-#define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
-#define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
-#define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
-#define KVM_TRC_IO_READ          (KVM_TRC_HANDLER + 0x05)
-#define KVM_TRC_IO_WRITE         (KVM_TRC_HANDLER + 0x06)
-#define KVM_TRC_CR_READ          (KVM_TRC_HANDLER + 0x07)
-#define KVM_TRC_CR_WRITE         (KVM_TRC_HANDLER + 0x08)
-#define KVM_TRC_DR_READ          (KVM_TRC_HANDLER + 0x09)
-#define KVM_TRC_DR_WRITE         (KVM_TRC_HANDLER + 0x0A)
-#define KVM_TRC_MSR_READ         (KVM_TRC_HANDLER + 0x0B)
-#define KVM_TRC_MSR_WRITE        (KVM_TRC_HANDLER + 0x0C)
-#define KVM_TRC_CPUID            (KVM_TRC_HANDLER + 0x0D)
-#define KVM_TRC_INTR             (KVM_TRC_HANDLER + 0x0E)
-#define KVM_TRC_NMI              (KVM_TRC_HANDLER + 0x0F)
-#define KVM_TRC_VMMCALL          (KVM_TRC_HANDLER + 0x10)
-#define KVM_TRC_HLT              (KVM_TRC_HANDLER + 0x11)
-#define KVM_TRC_CLTS             (KVM_TRC_HANDLER + 0x12)
-#define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
-#define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
-#define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
-#define KVM_TRC_GTLB_WRITE       (KVM_TRC_HANDLER + 0x16)
-#define KVM_TRC_STLB_WRITE       (KVM_TRC_HANDLER + 0x17)
-#define KVM_TRC_STLB_INVAL       (KVM_TRC_HANDLER + 0x18)
-#define KVM_TRC_PPC_INSTR        (KVM_TRC_HANDLER + 0x19)
-
-struct kvm_user_trace_setup {
-	__u32 buf_size;
-	__u32 buf_nr;
-};
-
-#define __KVM_DEPRECATED_MAIN_W_0x06 \
-	_IOW(KVMIO, 0x06, struct kvm_user_trace_setup)
-#define __KVM_DEPRECATED_MAIN_0x07 _IO(KVMIO, 0x07)
-#define __KVM_DEPRECATED_MAIN_0x08 _IO(KVMIO, 0x08)
-
-#define __KVM_DEPRECATED_VM_R_0x70 _IOR(KVMIO, 0x70, struct kvm_assigned_irq)
-
-struct kvm_breakpoint {
-	__u32 enabled;
-	__u32 padding;
-	__u64 address;
-};
-
-struct kvm_debug_guest {
-	__u32 enabled;
-	__u32 pad;
-	struct kvm_breakpoint breakpoints[4];
-	__u32 singlestep;
-};
-
-#define __KVM_DEPRECATED_VCPU_W_0x87 _IOW(KVMIO, 0x87, struct kvm_debug_guest)
-
-/* *** End of deprecated interfaces *** */
-
-
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -945,9 +875,6 @@ struct kvm_ppc_resize_hpt {
  */
 #define KVM_GET_VCPU_MMAP_SIZE    _IO(KVMIO,   0x04) /* in bytes */
 #define KVM_GET_SUPPORTED_CPUID   _IOWR(KVMIO, 0x05, struct kvm_cpuid2)
-#define KVM_TRACE_ENABLE          __KVM_DEPRECATED_MAIN_W_0x06
-#define KVM_TRACE_PAUSE           __KVM_DEPRECATED_MAIN_0x07
-#define KVM_TRACE_DISABLE         __KVM_DEPRECATED_MAIN_0x08
 #define KVM_GET_EMULATED_CPUID	  _IOWR(KVMIO, 0x09, struct kvm_cpuid2)
 #define KVM_GET_MSR_FEATURE_INDEX_LIST    _IOWR(KVMIO, 0x0a, struct kvm_msr_list)
 
@@ -1507,20 +1434,8 @@ struct kvm_s390_ucas_mapping {
 			_IOW(KVMIO,  0x67, struct kvm_coalesced_mmio_zone)
 #define KVM_UNREGISTER_COALESCED_MMIO \
 			_IOW(KVMIO,  0x68, struct kvm_coalesced_mmio_zone)
-#define KVM_ASSIGN_PCI_DEVICE     _IOR(KVMIO,  0x69, \
-				       struct kvm_assigned_pci_dev)
 #define KVM_SET_GSI_ROUTING       _IOW(KVMIO,  0x6a, struct kvm_irq_routing)
-/* deprecated, replaced by KVM_ASSIGN_DEV_IRQ */
-#define KVM_ASSIGN_IRQ            __KVM_DEPRECATED_VM_R_0x70
-#define KVM_ASSIGN_DEV_IRQ        _IOW(KVMIO,  0x70, struct kvm_assigned_irq)
 #define KVM_REINJECT_CONTROL      _IO(KVMIO,   0x71)
-#define KVM_DEASSIGN_PCI_DEVICE   _IOW(KVMIO,  0x72, \
-				       struct kvm_assigned_pci_dev)
-#define KVM_ASSIGN_SET_MSIX_NR    _IOW(KVMIO,  0x73, \
-				       struct kvm_assigned_msix_nr)
-#define KVM_ASSIGN_SET_MSIX_ENTRY _IOW(KVMIO,  0x74, \
-				       struct kvm_assigned_msix_entry)
-#define KVM_DEASSIGN_DEV_IRQ      _IOW(KVMIO,  0x75, struct kvm_assigned_irq)
 #define KVM_IRQFD                 _IOW(KVMIO,  0x76, struct kvm_irqfd)
 #define KVM_CREATE_PIT2		  _IOW(KVMIO,  0x77, struct kvm_pit_config)
 #define KVM_SET_BOOT_CPU_ID       _IO(KVMIO,   0x78)
@@ -1537,9 +1452,6 @@ struct kvm_s390_ucas_mapping {
 *  KVM_CAP_VM_TSC_CONTROL to set defaults for a VM */
 #define KVM_SET_TSC_KHZ           _IO(KVMIO,  0xa2)
 #define KVM_GET_TSC_KHZ           _IO(KVMIO,  0xa3)
-/* Available with KVM_CAP_PCI_2_3 */
-#define KVM_ASSIGN_SET_INTX_MASK  _IOW(KVMIO,  0xa4, \
-				       struct kvm_assigned_pci_dev)
 /* Available with KVM_CAP_SIGNAL_MSI */
 #define KVM_SIGNAL_MSI            _IOW(KVMIO,  0xa5, struct kvm_msi)
 /* Available with KVM_CAP_PPC_GET_SMMU_INFO */
@@ -1592,8 +1504,6 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_SREGS             _IOW(KVMIO,  0x84, struct kvm_sregs)
 #define KVM_TRANSLATE             _IOWR(KVMIO, 0x85, struct kvm_translation)
 #define KVM_INTERRUPT             _IOW(KVMIO,  0x86, struct kvm_interrupt)
-/* KVM_DEBUG_GUEST is no longer supported, use KVM_SET_GUEST_DEBUG instead */
-#define KVM_DEBUG_GUEST           __KVM_DEPRECATED_VCPU_W_0x87
 #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
 #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
 #define KVM_SET_CPUID             _IOW(KVMIO,  0x8a, struct kvm_cpuid)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3bd98ff65945..7ecf064673ec 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5144,11 +5144,6 @@ static long kvm_dev_ioctl(struct file *filp,
 		r += PAGE_SIZE;    /* coalesced mmio ring page */
 #endif
 		break;
-	case KVM_TRACE_ENABLE:
-	case KVM_TRACE_PAUSE:
-	case KVM_TRACE_DISABLE:
-		r = -EOPNOTSUPP;
-		break;
 	default:
 		return kvm_arch_dev_ioctl(filp, ioctl, arg);
 	}
-- 
2.39.1


