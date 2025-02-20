Return-Path: <kvm+bounces-38755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7511FA3E211
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A8FC1888CFB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B69DB22A4D5;
	Thu, 20 Feb 2025 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A6/WpAm6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B069922578E
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740071216; cv=none; b=KySuOK6uSydpWCruMmS1yvg1x3WjCJ2/ILDMrQm+3wcUyLExHilGPkUI2N4c3nfUZBAs09FvFVJjAcETn43tVcqxj38YRNDtl09GLPIBCtQDG4Kp8r/+uV2XoZ7G5dBBZm3jvp8qXrK0Fog9wZ6djUnWg0DC/3wo/+HgUxvNki8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740071216; c=relaxed/simple;
	bh=aMUphNUgwDKVfyLvoSO130Sb6SyuzmF+GoT1s4np2+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qT210YPNjdamipFd8N51LlA6dwPWntXl9Bs3thGWEpkb/AFyKlF3prSmcmqfMEXwZFuLOmN3ge4YuebeV+e+Jk1ezMPK24BEdiNtSsb5ECI39RLCDbqmfdcs7T+3Bq6vobD7uOX2Z7cnr87s7a1JFVImXL754uh0BEeJhCixYkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A6/WpAm6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740071213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KjWv5fSjEg41LoJNB4shPeDKoZz0HqWV9KX3dmsD1Xg=;
	b=A6/WpAm6iaN9jIyqOyzsqcUbQC0lg6ncfAo3yXfZgesm0bM9rG++v4aToiCVzpOMDx7ium
	PgHwtyftoXHnXnKvEphpPrW6yWq9DIClRfCIEDKQD2VMtLSPrKuow15mfXzwXiHIzm6mqJ
	b8zmwitqzfQKW/N1xbFJySe3LDyfG/0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-226-V_3Sx4BTPCKiY-Lx_FNbJw-1; Thu,
 20 Feb 2025 12:06:49 -0500
X-MC-Unique: V_3Sx4BTPCKiY-Lx_FNbJw-1
X-Mimecast-MFC-AGG-ID: V_3Sx4BTPCKiY-Lx_FNbJw_1740071207
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB00F1800874;
	Thu, 20 Feb 2025 17:06:47 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B302E19412A3;
	Thu, 20 Feb 2025 17:06:46 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>
Subject: [PATCH 28/30] KVM: x86: Introduce KVM_TDX_GET_CPUID
Date: Thu, 20 Feb 2025 12:06:02 -0500
Message-ID: <20250220170604.2279312-29-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-1-pbonzini@redhat.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Xiaoyao Li <xiaoyao.li@intel.com>

Implement an IOCTL to allow userspace to read the CPUID bit values for a
configured TD.

The TDX module doesn't provide the ability to set all CPUID bits. Instead
some are configured indirectly, or have fixed values. But it does allow
for the final resulting CPUID bits to be read. This information will be
useful for userspace to understand the configuration of the TD, and set
KVM's copy via KVM_SET_CPUID2.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 - Fix subleaf mask check (Binbin)
 - Search all possible sub-leafs (Francesco Lavra)
 - Reduce off-by-one error sensitve code (Francesco, Xiaoyao)
 - Handle buffers too small from userspace (Xiaoyao)
 - Read max CPUID from TD instead of using fixed values (Xiaoyao)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h |   1 +
 arch/x86/kvm/vmx/tdx.c          | 191 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_arch.h     |   5 +
 arch/x86/kvm/vmx/tdx_errno.h    |   1 +
 4 files changed, 198 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9316afbd4a88..cd55484e3f0c 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -932,6 +932,7 @@ enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
 	KVM_TDX_INIT_VCPU,
+	KVM_TDX_GET_CPUID,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7dfb0b486dd9..1c88f577ec2b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3,6 +3,7 @@
 #include <asm/cpufeature.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
+#include "mmu.h"
 #include "x86_ops.h"
 #include "lapic.h"
 #include "tdx.h"
@@ -858,6 +859,103 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	return ret;
 }
 
+static u64 tdx_td_metadata_field_read(struct kvm_tdx *tdx, u64 field_id,
+				      u64 *data)
+{
+	u64 err;
+
+	err = tdh_mng_rd(&tdx->td, field_id, data);
+
+	return err;
+}
+
+#define TDX_MD_UNREADABLE_LEAF_MASK	GENMASK(30, 7)
+#define TDX_MD_UNREADABLE_SUBLEAF_MASK	GENMASK(31, 7)
+
+static int tdx_read_cpuid(struct kvm_vcpu *vcpu, u32 leaf, u32 sub_leaf,
+			  bool sub_leaf_set, int *entry_index,
+			  struct kvm_cpuid_entry2 *out)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	u64 field_id = TD_MD_FIELD_ID_CPUID_VALUES;
+	u64 ebx_eax, edx_ecx;
+	u64 err = 0;
+
+	if (sub_leaf > 0b1111111)
+		return -EINVAL;
+
+	if (*entry_index >= KVM_MAX_CPUID_ENTRIES)
+		return -EINVAL;
+
+	if (leaf & TDX_MD_UNREADABLE_LEAF_MASK ||
+	    sub_leaf & TDX_MD_UNREADABLE_SUBLEAF_MASK)
+		return -EINVAL;
+
+	/*
+	 * bit 23:17, REVSERVED: reserved, must be 0;
+	 * bit 16,    LEAF_31: leaf number bit 31;
+	 * bit 15:9,  LEAF_6_0: leaf number bits 6:0, leaf bits 30:7 are
+	 *                      implicitly 0;
+	 * bit 8,     SUBLEAF_NA: sub-leaf not applicable flag;
+	 * bit 7:1,   SUBLEAF_6_0: sub-leaf number bits 6:0. If SUBLEAF_NA is 1,
+	 *                         the SUBLEAF_6_0 is all-1.
+	 *                         sub-leaf bits 31:7 are implicitly 0;
+	 * bit 0,     ELEMENT_I: Element index within field;
+	 */
+	field_id |= ((leaf & 0x80000000) ? 1 : 0) << 16;
+	field_id |= (leaf & 0x7f) << 9;
+	if (sub_leaf_set)
+		field_id |= (sub_leaf & 0x7f) << 1;
+	else
+		field_id |= 0x1fe;
+
+	err = tdx_td_metadata_field_read(kvm_tdx, field_id, &ebx_eax);
+	if (err) //TODO check for specific errors
+		goto err_out;
+
+	out->eax = (u32) ebx_eax;
+	out->ebx = (u32) (ebx_eax >> 32);
+
+	field_id++;
+	err = tdx_td_metadata_field_read(kvm_tdx, field_id, &edx_ecx);
+	/*
+	 * It's weird that reading edx_ecx fails while reading ebx_eax
+	 * succeeded.
+	 */
+	if (WARN_ON_ONCE(err))
+		goto err_out;
+
+	out->ecx = (u32) edx_ecx;
+	out->edx = (u32) (edx_ecx >> 32);
+
+	out->function = leaf;
+	out->index = sub_leaf;
+	out->flags |= sub_leaf_set ? KVM_CPUID_FLAG_SIGNIFCANT_INDEX : 0;
+
+	/*
+	 * Work around missing support on old TDX modules, fetch
+	 * guest maxpa from gfn_direct_bits.
+	 */
+	if (leaf == 0x80000008) {
+		gpa_t gpa_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
+		unsigned int g_maxpa = __ffs(gpa_bits) + 1;
+
+		out->eax = tdx_set_guest_phys_addr_bits(out->eax, g_maxpa);
+	}
+
+	(*entry_index)++;
+
+	return 0;
+
+err_out:
+	out->eax = 0;
+	out->ebx = 0;
+	out->ecx = 0;
+	out->edx = 0;
+
+	return -EIO;
+}
+
 static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1051,6 +1149,96 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	return ret;
 }
 
+/* Sometimes reads multipple subleafs. Return how many enties were written. */
+static int tdx_vcpu_get_cpuid_leaf(struct kvm_vcpu *vcpu, u32 leaf, int *entry_index,
+				   struct kvm_cpuid_entry2 *output_e)
+{
+	int sub_leaf = 0;
+	int ret;
+
+	/* First try without a subleaf */
+	ret = tdx_read_cpuid(vcpu, leaf, 0, false, entry_index, output_e);
+
+	/* If success, or invalid leaf, just give up */
+	if (ret != -EIO)
+		return ret;
+
+	/*
+	 * If the try without a subleaf failed, try reading subleafs until
+	 * failure. The TDX module only supports 6 bits of subleaf index.
+	 */
+	while (1) {
+		/* Keep reading subleafs until there is a failure. */
+		if (tdx_read_cpuid(vcpu, leaf, sub_leaf, true, entry_index, output_e))
+			return !sub_leaf;
+
+		sub_leaf++;
+		output_e++;
+	}
+
+	return 0;
+}
+
+static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_cpuid2 __user *output, *td_cpuid;
+	int r = 0, i = 0, leaf;
+	u32 level;
+
+	output = u64_to_user_ptr(cmd->data);
+	td_cpuid = kzalloc(sizeof(*td_cpuid) +
+			sizeof(output->entries[0]) * KVM_MAX_CPUID_ENTRIES,
+			GFP_KERNEL);
+	if (!td_cpuid)
+		return -ENOMEM;
+
+	if (copy_from_user(td_cpuid, output, sizeof(*output))) {
+		r = -EFAULT;
+		goto out;
+	}
+
+	/* Read max CPUID for normal range */
+	if (tdx_vcpu_get_cpuid_leaf(vcpu, 0, &i, &td_cpuid->entries[i])) {
+		r = -EIO;
+		goto out;
+	}
+	level = td_cpuid->entries[0].eax;
+
+	for (leaf = 1; leaf <= level; leaf++)
+		tdx_vcpu_get_cpuid_leaf(vcpu, leaf, &i, &td_cpuid->entries[i]);
+
+	/* Read max CPUID for extended range */
+	if (tdx_vcpu_get_cpuid_leaf(vcpu, 0x80000000, &i, &td_cpuid->entries[i])) {
+		r = -EIO;
+		goto out;
+	}
+	level = td_cpuid->entries[i - 1].eax;
+
+	for (leaf = 0x80000001; leaf <= level; leaf++)
+		tdx_vcpu_get_cpuid_leaf(vcpu, leaf, &i, &td_cpuid->entries[i]);
+
+	if (td_cpuid->nent < i)
+		r = -E2BIG;
+	td_cpuid->nent = i;
+
+	if (copy_to_user(output, td_cpuid, sizeof(*output))) {
+		r = -EFAULT;
+		goto out;
+	}
+
+	if (r == -E2BIG)
+		goto out;
+
+	if (copy_to_user(output->entries, td_cpuid->entries,
+			 td_cpuid->nent * sizeof(struct kvm_cpuid_entry2)))
+		r = -EFAULT;
+
+out:
+	kfree(td_cpuid);
+
+	return r;
+}
+
 static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 {
 	u64 apic_base;
@@ -1100,6 +1288,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	case KVM_TDX_INIT_VCPU:
 		ret = tdx_vcpu_init(vcpu, &cmd);
 		break;
+	case KVM_TDX_GET_CPUID:
+		ret = tdx_vcpu_get_cpuid(vcpu, &cmd);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index cb9a638fa398..b6fe458a4224 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -122,4 +122,9 @@ struct td_params {
 
 #define MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM	BIT_ULL(20)
 
+/*
+ * TD scope metadata field ID.
+ */
+#define TD_MD_FIELD_ID_CPUID_VALUES		0x9410000300000000ULL
+
 #endif /* __KVM_X86_TDX_ARCH_H */
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index dc3fa2a58c2c..f9dbb3a065cc 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -23,6 +23,7 @@
 #define TDX_FLUSHVP_NOT_DONE			0x8000082400000000ULL
 #define TDX_EPT_WALK_FAILED			0xC0000B0000000000ULL
 #define TDX_EPT_ENTRY_STATE_INCORRECT		0xC0000B0D00000000ULL
+#define TDX_METADATA_FIELD_NOT_READABLE		0xC0000C0200000000ULL
 
 /*
  * TDX module operand ID, appears in 31:0 part of error code as
-- 
2.43.5



