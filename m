Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60C73FA96B
	for <lists+kvm@lfdr.de>; Sun, 29 Aug 2021 08:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234699AbhH2GCZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Aug 2021 02:02:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232218AbhH2GCV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Aug 2021 02:02:21 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17T5sNcn029249;
        Sun, 29 Aug 2021 02:01:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=nTDLmqz+kkWXFz1KKYCKHYX0Wl9aRxadiVQlkqBIirE=;
 b=hWcv+9wnY1P91TI6ef51yzFUvA9ru2MXcoWqBvtEtzIvw2Bli8VWyWmh9KQnr91vFb1X
 9HS3xqJx0NrdNfpklfRrS77m/9xMnJFVyJO63PfNfbr/MZs3x2TQ3s1XfZmC1sKFtmBO
 h15Be6PqN3Y3M0IOFYnFM86hSev+Kk9X9XlnIG/LsMtYUXote8wzfyybBIvObLGUXMHM
 Usj/qO8cq/WkQqoizULmqzyy6C0yHvQIyASXg4Tpx24uhoGPKiHxmWD96BsoFl8XyPfq
 TvPFDhtIflZp7/79irOi4FpQwOu2jdZBaOYf83BTxe2zeNY2pxRyJMihZFyemYcqc6o4 wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ar27gadkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 02:01:29 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17T60Pti090919;
        Sun, 29 Aug 2021 02:01:29 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ar27gadjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 02:01:29 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17T5tEg9012400;
        Sun, 29 Aug 2021 06:01:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3aqcs896dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Aug 2021 06:01:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17T61NNu44564888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Aug 2021 06:01:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FE344204B;
        Sun, 29 Aug 2021 06:01:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 123204203F;
        Sun, 29 Aug 2021 06:01:23 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 29 Aug 2021 06:01:23 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A67B1E07E8; Sun, 29 Aug 2021 08:01:22 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 2/2] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Date:   Sun, 29 Aug 2021 08:01:21 +0200
Message-Id: <20210829060121.16702-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210829060121.16702-1-borntraeger@de.ibm.com>
References: <20210829060121.16702-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JBEk11SKK5olM17HiydLQohvcd2nMWml
X-Proofpoint-ORIG-GUID: SB45sXkAWPUQlX7mEY2-lVvF9OWW4N_b
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-29_01:2021-08-27,2021-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108290031
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true, it may
not always be, and we must not rely on this. Reason is that KVM decides
the vcpu_idx, userspace decides the vcpu_id, thus the two might not
match.

Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
that code like
for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
                vcpu = kvm_get_vcpu(kvm, vcpu_id);
		do_stuff(vcpu);
}
is not legit. Reason is that kvm_get_vcpu expects an vcpu_idx, not an
vcpu_id.  The trouble is, we do actually use kvm->arch.idle_mask like
this. To fix this problem we have two options. Either use
kvm_get_vcpu_by_id(vcpu_id), which would loop to find the right vcpu_id,
or switch to indexing via vcpu_idx. The latter is preferable for obvious
reasons.

Let us make switch from indexing kvm->arch.idle_mask by vcpu_id to
indexing it by vcpu_idx.  To keep gisa_int.kicked_mask indexed by the
same index as idle_mask lets make the same change for it as well.

Fixes: 1ee0bc559dc3 ("KVM: s390: get rid of local_int array")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Christian Bornträger <borntraeger@de.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 3.15+
Link: https://lore.kernel.org/r/20210827125429.1912577-1-pasic@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/interrupt.c        | 12 ++++++------
 arch/s390/kvm/kvm-s390.c         |  2 +-
 arch/s390/kvm/kvm-s390.h         |  2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 118d5450c523..611f18ecde91 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -963,6 +963,7 @@ struct kvm_arch{
 	atomic64_t cmma_dirty_pages;
 	/* subset of available cpu features enabled by user space */
 	DECLARE_BITMAP(cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS);
+	/* indexed by vcpu_idx */
 	DECLARE_BITMAP(idle_mask, KVM_MAX_VCPUS);
 	struct kvm_s390_gisa_interrupt gisa_int;
 	struct kvm_s390_pv pv;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index d548d60caed2..16256e17a544 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -419,13 +419,13 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
 static void __set_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_WAIT);
-	set_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	set_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
-	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
@@ -3050,18 +3050,18 @@ int kvm_s390_get_irq_state(struct kvm_vcpu *vcpu, __u8 __user *buf, int len)
 
 static void __airqs_kick_single_vcpu(struct kvm *kvm, u8 deliverable_mask)
 {
-	int vcpu_id, online_vcpus = atomic_read(&kvm->online_vcpus);
+	int vcpu_idx, online_vcpus = atomic_read(&kvm->online_vcpus);
 	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
 	struct kvm_vcpu *vcpu;
 
-	for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
-		vcpu = kvm_get_vcpu(kvm, vcpu_id);
+	for_each_set_bit(vcpu_idx, kvm->arch.idle_mask, online_vcpus) {
+		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
 		if (psw_ioint_disabled(vcpu))
 			continue;
 		deliverable_mask &= (u8)(vcpu->arch.sie_block->gcr[6] >> 24);
 		if (deliverable_mask) {
 			/* lately kicked but not yet running */
-			if (test_and_set_bit(vcpu_id, gi->kicked_mask))
+			if (test_and_set_bit(vcpu_idx, gi->kicked_mask))
 				return;
 			kvm_s390_vcpu_wakeup(vcpu);
 			return;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5b45c83ced21..e144c8046ceb 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4026,7 +4026,7 @@ static int vcpu_pre_run(struct kvm_vcpu *vcpu)
 		kvm_s390_patch_guest_per_regs(vcpu);
 	}
 
-	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.gisa_int.kicked_mask);
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.gisa_int.kicked_mask);
 
 	vcpu->arch.sie_block->icptcode = 0;
 	cpuflags = atomic_read(&vcpu->arch.sie_block->cpuflags);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 9fad25109b0d..ecd741ee3276 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -79,7 +79,7 @@ static inline int is_vcpu_stopped(struct kvm_vcpu *vcpu)
 
 static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 {
-	return test_bit(vcpu->vcpu_id, vcpu->kvm->arch.idle_mask);
+	return test_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.idle_mask);
 }
 
 static inline int kvm_is_ucontrol(struct kvm *kvm)
-- 
2.31.1

