Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F618EB3C6
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 16:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbfJaPTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 11:19:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726642AbfJaPTa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 31 Oct 2019 11:19:30 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9VFGVYO134757
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 11:19:28 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w01ph1ak8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2019 11:19:28 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 31 Oct 2019 15:19:26 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 31 Oct 2019 15:19:23 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9VFJM8R32571626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Oct 2019 15:19:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 585A752052;
        Thu, 31 Oct 2019 15:19:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 3F07B5204E;
        Thu, 31 Oct 2019 15:19:22 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 0186EE0264; Thu, 31 Oct 2019 16:19:21 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH 1/1] KVM: s390:  Add memcg accounting to KVM allocations
Date:   Thu, 31 Oct 2019 16:19:21 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031151921.31871-1-borntraeger@de.ibm.com>
References: <20191031151921.31871-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19103115-0020-0000-0000-000003815CBC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103115-0021-0000-0000-000021D773CC
Message-Id: <20191031151921.31871-2-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-31_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=902 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910310155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While I propared my KVM Forum talk about whats new in KVM including
memcg, I realized that the s390 code does not take care of memcg.

As far as I can tell, almost all kvm allocations in the s390x KVM code
can be attributed to process that triggers the allocation (in other
words, no global allocation for other guests). This will help the memcg
controller to do the right decisions.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/guestdbg.c  |  8 ++++----
 arch/s390/kvm/intercept.c |  2 +-
 arch/s390/kvm/interrupt.c | 12 ++++++------
 arch/s390/kvm/kvm-s390.c  | 22 +++++++++++-----------
 arch/s390/kvm/priv.c      |  4 ++--
 arch/s390/kvm/vsie.c      |  4 ++--
 6 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/s390/kvm/guestdbg.c b/arch/s390/kvm/guestdbg.c
index 394a5f53805b..3765c4223bf9 100644
--- a/arch/s390/kvm/guestdbg.c
+++ b/arch/s390/kvm/guestdbg.c
@@ -184,7 +184,7 @@ static int __import_wp_info(struct kvm_vcpu *vcpu,
 	if (wp_info->len < 0 || wp_info->len > MAX_WP_SIZE)
 		return -EINVAL;
 
-	wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL);
+	wp_info->old_data = kmalloc(bp_data->len, GFP_KERNEL_ACCOUNT);
 	if (!wp_info->old_data)
 		return -ENOMEM;
 	/* try to backup the original value */
@@ -234,7 +234,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
 	if (nr_wp > 0) {
 		wp_info = kmalloc_array(nr_wp,
 					sizeof(*wp_info),
-					GFP_KERNEL);
+					GFP_KERNEL_ACCOUNT);
 		if (!wp_info) {
 			ret = -ENOMEM;
 			goto error;
@@ -243,7 +243,7 @@ int kvm_s390_import_bp_data(struct kvm_vcpu *vcpu,
 	if (nr_bp > 0) {
 		bp_info = kmalloc_array(nr_bp,
 					sizeof(*bp_info),
-					GFP_KERNEL);
+					GFP_KERNEL_ACCOUNT);
 		if (!bp_info) {
 			ret = -ENOMEM;
 			goto error;
@@ -349,7 +349,7 @@ static struct kvm_hw_wp_info_arch *any_wp_changed(struct kvm_vcpu *vcpu)
 		if (!wp_info || !wp_info->old_data || wp_info->len <= 0)
 			continue;
 
-		temp = kmalloc(wp_info->len, GFP_KERNEL);
+		temp = kmalloc(wp_info->len, GFP_KERNEL_ACCOUNT);
 		if (!temp)
 			continue;
 
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index a389fa85cca2..fb2daae88105 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -387,7 +387,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 	if (addr & ~PAGE_MASK)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
-	sctns = (void *)get_zeroed_page(GFP_KERNEL);
+	sctns = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sctns)
 		return -ENOMEM;
 
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 165dea4c7f19..7fe8896a82dd 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1668,7 +1668,7 @@ struct kvm_s390_interrupt_info *kvm_s390_get_io_int(struct kvm *kvm,
 		goto out;
 	}
 gisa_out:
-	tmp_inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	tmp_inti = kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
 	if (tmp_inti) {
 		tmp_inti->type = KVM_S390_INT_IO(1, 0, 0, 0);
 		tmp_inti->io.io_int_word = isc_to_int_word(isc);
@@ -1881,7 +1881,7 @@ int kvm_s390_inject_vm(struct kvm *kvm,
 	struct kvm_s390_interrupt_info *inti;
 	int rc;
 
-	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	inti = kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
 	if (!inti)
 		return -ENOMEM;
 
@@ -2275,7 +2275,7 @@ static int enqueue_floating_irq(struct kvm_device *dev,
 		return -EINVAL;
 
 	while (len >= sizeof(struct kvm_s390_irq)) {
-		inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+		inti = kzalloc(sizeof(*inti), GFP_KERNEL_ACCOUNT);
 		if (!inti)
 			return -ENOMEM;
 
@@ -2323,7 +2323,7 @@ static int register_io_adapter(struct kvm_device *dev,
 	if (dev->kvm->arch.adapters[adapter_info.id] != NULL)
 		return -EINVAL;
 
-	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
+	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL_ACCOUNT);
 	if (!adapter)
 		return -ENOMEM;
 
@@ -2363,7 +2363,7 @@ static int kvm_s390_adapter_map(struct kvm *kvm, unsigned int id, __u64 addr)
 	if (!adapter || !addr)
 		return -EINVAL;
 
-	map = kzalloc(sizeof(*map), GFP_KERNEL);
+	map = kzalloc(sizeof(*map), GFP_KERNEL_ACCOUNT);
 	if (!map) {
 		ret = -ENOMEM;
 		goto out;
@@ -3223,7 +3223,7 @@ int kvm_s390_gib_init(u8 nisc)
 		goto out;
 	}
 
-	gib = (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	gib = (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
 	if (!gib) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d9e6bf3d54f0..373e182fd8e8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1243,7 +1243,7 @@ static int kvm_s390_set_processor(struct kvm *kvm, struct kvm_device_attr *attr)
 		ret = -EBUSY;
 		goto out;
 	}
-	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
+	proc = kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
 	if (!proc) {
 		ret = -ENOMEM;
 		goto out;
@@ -1405,7 +1405,7 @@ static int kvm_s390_get_processor(struct kvm *kvm, struct kvm_device_attr *attr)
 	struct kvm_s390_vm_cpu_processor *proc;
 	int ret = 0;
 
-	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
+	proc = kzalloc(sizeof(*proc), GFP_KERNEL_ACCOUNT);
 	if (!proc) {
 		ret = -ENOMEM;
 		goto out;
@@ -1433,7 +1433,7 @@ static int kvm_s390_get_machine(struct kvm *kvm, struct kvm_device_attr *attr)
 	struct kvm_s390_vm_cpu_machine *mach;
 	int ret = 0;
 
-	mach = kzalloc(sizeof(*mach), GFP_KERNEL);
+	mach = kzalloc(sizeof(*mach), GFP_KERNEL_ACCOUNT);
 	if (!mach) {
 		ret = -ENOMEM;
 		goto out;
@@ -1801,7 +1801,7 @@ static long kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
+	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
 	if (!keys)
 		return -ENOMEM;
 
@@ -1846,7 +1846,7 @@ static long kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL);
+	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
 	if (!keys)
 		return -ENOMEM;
 
@@ -2393,7 +2393,7 @@ static void sca_dispose(struct kvm *kvm)
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
-	gfp_t alloc_flags = GFP_KERNEL;
+	gfp_t alloc_flags = GFP_KERNEL_ACCOUNT;
 	int i, rc;
 	char debug_name[16];
 	static unsigned long sca_offset;
@@ -2438,7 +2438,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	BUILD_BUG_ON(sizeof(struct sie_page2) != 4096);
 	kvm->arch.sie_page2 =
-	     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
 	if (!kvm->arch.sie_page2)
 		goto out_err;
 
@@ -2652,7 +2652,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
 	unsigned int vcpu_idx;
 	u32 scaol, scaoh;
 
-	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL|__GFP_ZERO);
+	new_sca = alloc_pages_exact(sizeof(*new_sca), GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!new_sca)
 		return -ENOMEM;
 
@@ -2947,7 +2947,7 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu)
 
 int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.sie_block->cbrlo = get_zeroed_page(GFP_KERNEL);
+	vcpu->arch.sie_block->cbrlo = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.sie_block->cbrlo)
 		return -ENOMEM;
 	return 0;
@@ -3047,12 +3047,12 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 
 	rc = -ENOMEM;
 
-	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
 	if (!vcpu)
 		goto out;
 
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
-	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
+	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sie_page)
 		goto out_free_cpu;
 
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index ed52ffa8d5d4..536fcd599665 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -878,7 +878,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	switch (fc) {
 	case 1: /* same handling for 1 and 2 */
 	case 2:
-		mem = get_zeroed_page(GFP_KERNEL);
+		mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 		if (!mem)
 			goto out_no_data;
 		if (stsi((void *) mem, fc, sel1, sel2))
@@ -887,7 +887,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	case 3:
 		if (sel1 != 2 || sel2 != 2)
 			goto out_no_data;
-		mem = get_zeroed_page(GFP_KERNEL);
+		mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 		if (!mem)
 			goto out_no_data;
 		handle_stsi_3_2_2(vcpu, (void *) mem);
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 076090f9e666..f55fca8f94f8 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1236,7 +1236,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 
 	mutex_lock(&kvm->arch.vsie.mutex);
 	if (kvm->arch.vsie.page_count < nr_vcpus) {
-		page = alloc_page(GFP_KERNEL | __GFP_ZERO | GFP_DMA);
+		page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
 		if (!page) {
 			mutex_unlock(&kvm->arch.vsie.mutex);
 			return ERR_PTR(-ENOMEM);
@@ -1338,7 +1338,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 void kvm_s390_vsie_init(struct kvm *kvm)
 {
 	mutex_init(&kvm->arch.vsie.mutex);
-	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL);
+	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL_ACCOUNT);
 }
 
 /* Destroy the vsie data structures. To be called when a vm is destroyed. */
-- 
2.21.0

