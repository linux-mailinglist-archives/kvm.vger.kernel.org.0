Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF0A72802A
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 14:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbjFHMhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 08:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbjFHMhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 08:37:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FC1E62;
        Thu,  8 Jun 2023 05:37:21 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 358CHOXA028165;
        Thu, 8 Jun 2023 12:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=fsd0e+83dm6G5og5UYRQp+4H7dINEmgeUwftwVBRy50=;
 b=QucOWYyUAQSdSJuKjqCHSQk6/W/mB29QWlABK9EnqjaV0ivUTX+LNmam86NXLADXRJ3b
 dYPXlO5NlAQRqx+WPzIdt0aH+dezTWAXcve+BJs3nDQYDgQfxvlSLoGzsEmV7SYlgm13
 2BGCBZaFj1wsdXGDZa5xK1DbJS/BeNp1MktTb9wdZfYV4ozT4ICWE66TMtR2604sncb6
 tsVFv4hCLcVKlZlY1kEmaNxvQEVnBReBrdF1UefFrD+SCTKV3Y7UkUDMKCAELotNUCP7
 sRCJEHDbj6hflA36b66jchVv3lrrEJzgB8MZVXjIv8PJDde7l5faDFrx876RMXwWlmKr TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r3ev20d1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jun 2023 12:37:12 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 358CJCWm000910;
        Thu, 8 Jun 2023 12:37:11 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r3ev20cym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jun 2023 12:37:11 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 358BKL4n005897;
        Thu, 8 Jun 2023 12:34:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3r2a790vp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jun 2023 12:34:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 358CYuQm8782508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Jun 2023 12:34:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E18E20043;
        Thu,  8 Jun 2023 12:34:56 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6194C20040;
        Thu,  8 Jun 2023 12:34:54 +0000 (GMT)
Received: from r223l.aus.stglabs.ibm.com (unknown [9.3.109.14])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  8 Jun 2023 12:34:54 +0000 (GMT)
From:   Kautuk Consul <kconsul@linux.vnet.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>, jpn@linux.vnet.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kautuk Consul <kconsul@linux.vnet.ibm.com>
Subject: [PATCH] KVM: ppc64: Enable ring-based dirty memory tracking
Date:   Thu,  8 Jun 2023 08:34:48 -0400
Message-Id: <20230608123448.71861-1-kconsul@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v8X-d65sqIc0h91LpFoHj7sGmGqn-Z7y
X-Proofpoint-ORIG-GUID: KMfzz0lN4-_Wt50y0eaFbQgynUHQz74N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_08,2023-06-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=901 priorityscore=1501
 clxscore=1011 suspectscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306080109
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

- Enable CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL as ppc64 is weakly
  ordered.
- Enable CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP because the
  kvmppc_xive_native_set_attr is called in the context of an ioctl
  syscall and will call kvmppc_xive_native_eq_sync for setting the
  KVM_DEV_XIVE_EQ_SYNC attribute which will call mark_dirty_page()
  when there isn't a running vcpu. Implemented the
  kvm_arch_allow_write_without_running_vcpu to always return true
  to allow mark_page_dirty_in_slot to mark the page dirty in the
  memslot->dirty_bitmap in this case.
- Set KVM_DIRTY_LOG_PAGE_OFFSET for the ring buffer's physical page
  offset.
- Implement the kvm_arch_mmu_enable_log_dirty_pt_masked function required
  for the generic KVM code to call.
- Add a check to kvmppc_vcpu_run_hv for checking whether the dirty
  ring is soft full.
- Implement the kvm_arch_flush_remote_tlbs_memslot function to support
  the CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT config option.

On testing with live migration it was found that there is around
150-180 ms improvment in overall migration time with this patch.

Signed-off-by: Kautuk Consul <kconsul@linux.vnet.ibm.com>
---
 Documentation/virt/kvm/api.rst      |  2 +-
 arch/powerpc/include/uapi/asm/kvm.h |  2 ++
 arch/powerpc/kvm/Kconfig            |  2 ++
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 42 +++++++++++++++++++++++++++++
 arch/powerpc/kvm/book3s_hv.c        |  3 +++
 include/linux/kvm_dirty_ring.h      |  5 ++++
 6 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index add067793b90..ce1ebc513bae 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8114,7 +8114,7 @@ regardless of what has actually been exposed through the CPUID leaf.
 8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
 ----------------------------------------------------------
 
-:Architectures: x86, arm64
+:Architectures: x86, arm64, ppc64
 :Parameters: args[0] - size of the dirty log ring
 
 KVM is capable of tracking dirty memory using ring buffers that are
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index 9f18fa090f1f..f722309ed7fb 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -33,6 +33,8 @@
 /* Not always available, but if it is, this is the correct offset.  */
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
+
 struct kvm_regs {
 	__u64 pc;
 	__u64 cr;
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 902611954200..c93354ec3bd5 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -26,6 +26,8 @@ config KVM
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select INTERVAL_TREE
+	select HAVE_KVM_DIRTY_RING_ACQ_REL
+	select NEED_KVM_DIRTY_RING_WITH_BITMAP
 
 config KVM_BOOK3S_HANDLER
 	bool
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 7f765d5ad436..c92e8022e017 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -2147,3 +2147,45 @@ void kvmppc_mmu_book3s_hv_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.hflags |= BOOK3S_HFLAG_SLB;
 }
+
+/*
+ * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
+ * dirty pages.
+ *
+ * It write protects selected pages to enable dirty logging for them.
+ */
+void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
+					     struct kvm_memory_slot *slot,
+					     gfn_t gfn_offset,
+					     unsigned long mask)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
+
+	while (start < end) {
+		pte_t *ptep;
+		unsigned int shift;
+
+		ptep = find_kvm_secondary_pte(kvm, start, &shift);
+
+		*ptep = __pte(pte_val(*ptep) & ~(_PAGE_WRITE));
+
+		start += PAGE_SIZE;
+	}
+}
+
+#ifdef CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP
+bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
+{
+	return true;
+}
+#endif
+
+#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
+void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
+					const struct kvm_memory_slot *memslot)
+{
+	kvm_flush_remote_tlbs(kvm);
+}
+#endif
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 130bafdb1430..1d1264ea72c4 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4804,6 +4804,9 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		return -EINTR;
 	}
 
+	if (kvm_dirty_ring_check_request(vcpu))
+		return 0;
+
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	/*
 	 * Don't allow entry with a suspended transaction, because
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 4862c98d80d3..a00301059da5 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -69,6 +69,11 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 {
 }
 
+static inline bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
 int kvm_cpu_dirty_log_size(void);
-- 
2.39.2

