Return-Path: <kvm+bounces-2282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4127B7F45CE
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 13:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA3FB2807AB
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 12:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD45D54BD9;
	Wed, 22 Nov 2023 12:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="2C++hItw"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6B9170A;
	Wed, 22 Nov 2023 04:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:To:From;
	bh=J64pqIPdnhp9I3yEVpAsBbI+UXw3J9T7bxbhXtfBHjE=; b=2C++hItwuf98Q76eujtkiJkVPY
	dHySOGSYzhaZV71fPetpnkOLokbseo3o6t7JeFyL4n3AsaUkyiB7jnt6B+J6lsvYkkWqsBKloVzbd
	eFeUfIMam3WFeT86mL2NqaFo4k8EpU1fn7ZzMwdVgceUE87u2xzQWqpA/N/UXBHrzQhU=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5mCe-0004zD-HT; Wed, 22 Nov 2023 12:19:36 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5mCe-0004y9-8j; Wed, 22 Nov 2023 12:19:36 +0000
From: Paul Durrant <paul@xen.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 09/15] KVM: xen: allow shared_info to be mapped by fixed HVA
Date: Wed, 22 Nov 2023 12:18:16 +0000
Message-Id: <20231122121822.1042-10-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231122121822.1042-1-paul@xen.org>
References: <20231122121822.1042-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

The shared_info page is not guest memory as such. It is a dedicated page
allocated by the VMM and overlaid onto guest memory in a GFN chosen by the
guest and specified in the XENMEM_add_to_physmap hypercall. The guest may
even request that shared_info be moved from one GFN to another by
re-issuing that hypercall, but the HVA is never going to change.

Because the shared_info page is an overlay the memory slots need to be
updated in response to the hypercall. However, memory slot adjustment is
not atomic and, whilst all vCPUs are paused, there is still the possibility
that events may be delivered (which requires the shared_info page to be
updated) whilst the shared_info GPA is absent. The HVA is never absent
though, so it makes much more sense to use that as the basis for the
kernel's mapping.

Hence add a new KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA attribute type for this
purpose and a KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA flag to advertize its
availability. Don't actually advertize it yet though. That will be done in
a subsequent patch, which will also add tests for the new attribute type.

Also update the KVM API documentation with the new attribute and also fix
it up to consistently refer to 'shared_info' (with the underscore).

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org

v8:
 - Re-base.

v2:
 - Define the new attribute and capability but don't advertize the
   capability yet.
 - Add API documentation.
---
 Documentation/virt/kvm/api.rst | 25 +++++++++++++++++++------
 arch/x86/kvm/xen.c             | 32 +++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h       |  6 +++++-
 3 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7025b3751027..25ac75b6d8c5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -353,7 +353,7 @@ The bits in the dirty bitmap are cleared before the ioctl returns, unless
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 is enabled.  For more information,
 see the description of the capability.
 
-Note that the Xen shared info page, if configured, shall always be assumed
+Note that the Xen shared_info page, if configured, shall always be assumed
 to be dirty. KVM will not explicitly mark it such.
 
 
@@ -5480,8 +5480,9 @@ KVM_PV_ASYNC_CLEANUP_PERFORM
 		__u8 long_mode;
 		__u8 vector;
 		__u8 runstate_update_flag;
-		struct {
+		union {
 			__u64 gfn;
+			__u64 hva;
 		} shared_info;
 		struct {
 			__u32 send_port;
@@ -5509,10 +5510,10 @@ type values:
 
 KVM_XEN_ATTR_TYPE_LONG_MODE
   Sets the ABI mode of the VM to 32-bit or 64-bit (long mode). This
-  determines the layout of the shared info pages exposed to the VM.
+  determines the layout of the shared_info page exposed to the VM.
 
 KVM_XEN_ATTR_TYPE_SHARED_INFO
-  Sets the guest physical frame number at which the Xen "shared info"
+  Sets the guest physical frame number at which the Xen shared_info
   page resides. Note that although Xen places vcpu_info for the first
   32 vCPUs in the shared_info page, KVM does not automatically do so
   and instead requires that KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO be used
@@ -5521,7 +5522,7 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO
   not be aware of the Xen CPU id which is used as the index into the
   vcpu_info[] array, so may know the correct default location.
 
-  Note that the shared info page may be constantly written to by KVM;
+  Note that the shared_info page may be constantly written to by KVM;
   it contains the event channel bitmap used to deliver interrupts to
   a Xen guest, amongst other things. It is exempt from dirty tracking
   mechanisms — KVM will not explicitly mark the page as dirty each
@@ -5530,9 +5531,21 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO
   any vCPU has been running or any event channel interrupts can be
   routed to the guest.
 
-  Setting the gfn to KVM_XEN_INVALID_GFN will disable the shared info
+  Setting the gfn to KVM_XEN_INVALID_GFN will disable the shared_info
   page.
 
+KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA
+  If the KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA flag is also set in the
+  Xen capabilities, then this attribute may be used to set the
+  userspace address at which the shared_info page resides, which
+  will always be fixed in the VMM regardless of where it is mapped
+  in guest physical address space. This attribute should be used in
+  preference to KVM_XEN_ATTR_TYPE_SHARED_INFO as it avoids
+  unnecessary invalidation of an internal cache when the page is
+  re-mapped in guest physcial address space.
+
+  Setting the hva to zero will disable the shared_info page.
+
 KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
   Sets the exception vector used to deliver Xen event channel upcalls.
   This is the HVM-wide vector injected directly by the hypervisor
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index e1967f970f54..618ae4c0e7f8 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -34,24 +34,27 @@ static bool kvm_xen_hcall_evtchn_send(struct kvm_vcpu *vcpu, u64 param, u64 *r);
 
 DEFINE_STATIC_KEY_DEFERRED_FALSE(kvm_xen_enabled, HZ);
 
-static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
+static int kvm_xen_shared_info_init(struct kvm *kvm, u64 addr, bool addr_is_gfn)
 {
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 	struct pvclock_wall_clock *wc;
-	gpa_t gpa = gfn_to_gpa(gfn);
 	u32 *wc_sec_hi;
 	u32 wc_version;
 	u64 wall_nsec;
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	if (gfn == KVM_XEN_INVALID_GFN) {
+	if ((addr_is_gfn && addr == KVM_XEN_INVALID_GFN) ||
+	    (!addr_is_gfn && addr == 0)) {
 		kvm_gpc_deactivate(gpc);
 		goto out;
 	}
 
 	do {
-		ret = kvm_gpc_activate(gpc, gpa, PAGE_SIZE);
+		if (addr_is_gfn)
+			ret = kvm_gpc_activate(gpc, gfn_to_gpa(addr), PAGE_SIZE);
+		else
+			ret = kvm_gpc_activate_hva(gpc, addr, PAGE_SIZE);
 		if (ret)
 			goto out;
 
@@ -626,7 +629,6 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 {
 	int r = -ENOENT;
 
-
 	switch (data->type) {
 	case KVM_XEN_ATTR_TYPE_LONG_MODE:
 		if (!IS_ENABLED(CONFIG_64BIT) && data->u.long_mode) {
@@ -641,7 +643,13 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
 		mutex_lock(&kvm->arch.xen.xen_lock);
-		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn);
+		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.gfn, true);
+		mutex_unlock(&kvm->arch.xen.xen_lock);
+		break;
+
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA:
+		mutex_lock(&kvm->arch.xen.xen_lock);
+		r = kvm_xen_shared_info_init(kvm, data->u.shared_info.hva, false);
 		mutex_unlock(&kvm->arch.xen.xen_lock);
 		break;
 
@@ -698,13 +706,23 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
 		break;
 
 	case KVM_XEN_ATTR_TYPE_SHARED_INFO:
-		if (kvm->arch.xen.shinfo_cache.active)
+		if (kvm->arch.xen.shinfo_cache.active &&
+		    kvm->arch.xen.shinfo_cache.gpa != KVM_XEN_INVALID_GPA)
 			data->u.shared_info.gfn = gpa_to_gfn(kvm->arch.xen.shinfo_cache.gpa);
 		else
 			data->u.shared_info.gfn = KVM_XEN_INVALID_GFN;
 		r = 0;
 		break;
 
+	case KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA:
+		if (kvm->arch.xen.shinfo_cache.active &&
+		    kvm->arch.xen.shinfo_cache.gpa == KVM_XEN_INVALID_GPA)
+			data->u.shared_info.hva = kvm->arch.xen.shinfo_cache.uhva;
+		else
+			data->u.shared_info.hva = 0;
+		r = 0;
+		break;
+
 	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
 		data->u.vector = kvm->arch.xen.upcall_vector;
 		r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 211b86de35ac..769361b91f95 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1291,6 +1291,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 7)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1804,9 +1805,10 @@ struct kvm_xen_hvm_attr {
 		__u8 long_mode;
 		__u8 vector;
 		__u8 runstate_update_flag;
-		struct {
+		union {
 			__u64 gfn;
 #define KVM_XEN_INVALID_GFN ((__u64)-1)
+			__u64 hva;
 		} shared_info;
 		struct {
 			__u32 send_port;
@@ -1848,6 +1850,8 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
 #define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA	0x6
 
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
-- 
2.39.2


