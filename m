Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4114EC444
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345303AbiC3Mhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344281AbiC3Mh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:37:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FCB90CF0;
        Wed, 30 Mar 2022 05:26:20 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UBeKLi011452;
        Wed, 30 Mar 2022 12:26:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IW77Khv0cEJ9yDfdx69wuzOcUX/UpnRcKH+ZYt8Pi1k=;
 b=X0NfBa8H09qTjnjyDOny86SRAtahkvRNOf0mXqJjKyb0G0iTt4VuA0LuDgbN3ZvTrx9d
 NY33bm7HJgwQPvKJuw9BmJpHa3kX+HMam2Qlrj+RRfypgg5eVjU0HNoFbNSqBvQF7eB8
 kwgI2oxtahJeZRWYJrbeGMXFmMYV2u3meqg4MvMWh5G2rKFWUoYQ9FW4QRlJRF2SSZlo
 xoO55xTulAvVIK16KQXJOTKI6VqY/g4Qnom/w5NjbQRi8+zCByi7w36IpbkG3o2jKJs1
 pcHUpdwy++MC26b7dhb5w3qDRNigtsEi5C5KtFIuD/+9qrReGzEmUk95WPUiBR1QYVqc Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40c95bhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:19 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UCAAbA000466;
        Wed, 30 Mar 2022 12:26:19 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40c95bgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UCNbPB027068;
        Wed, 30 Mar 2022 12:26:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3f3rs3khp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCQJDx42336526
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:26:19 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C40011C050;
        Wed, 30 Mar 2022 12:26:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DECC11C04A;
        Wed, 30 Mar 2022 12:26:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:26:13 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v9 05/18] KVM: s390: pv: usage counter instead of flag
Date:   Wed, 30 Mar 2022 14:25:52 +0200
Message-Id: <20220330122605.247613-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330122605.247613-1-imbrenda@linux.ibm.com>
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5fO4YxpxRF9qn6weYwYf7IdXGfFX7NHL
X-Proofpoint-GUID: rPVHba6AJLgyz4a9O53HONhZP-kYjj45
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new protected_count field as a counter instead of the old
is_protected flag. This will be used in upcoming patches.

Increment the counter when a secure configuration is created, and
decrement it when it is destroyed. Previously the flag was set when the
set secure parameters UVC was performed.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/mmu.h         |  2 +-
 arch/s390/include/asm/mmu_context.h |  2 +-
 arch/s390/include/asm/pgtable.h     |  2 +-
 arch/s390/kvm/pv.c                  | 12 +++++++-----
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index e12ff0f29d1a..2c4cbc254604 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -17,7 +17,7 @@ typedef struct {
 	unsigned long asce_limit;
 	unsigned long vdso_base;
 	/* The mmu context belongs to a secure guest. */
-	atomic_t is_protected;
+	atomic_t protected_count;
 	/*
 	 * The following bitfields need a down_write on the mm
 	 * semaphore when they are written to. As they are only
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index c7937f369e62..2a38af5a00c2 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -26,7 +26,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	INIT_LIST_HEAD(&mm->context.gmap_list);
 	cpumask_clear(&mm->context.cpu_attach_mask);
 	atomic_set(&mm->context.flush_count, 0);
-	atomic_set(&mm->context.is_protected, 0);
+	atomic_set(&mm->context.protected_count, 0);
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
 #ifdef CONFIG_PGSTE
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 008a6c856fa4..23ca0d8e058a 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -523,7 +523,7 @@ static inline int mm_has_pgste(struct mm_struct *mm)
 static inline int mm_is_protected(struct mm_struct *mm)
 {
 #ifdef CONFIG_PGSTE
-	if (unlikely(atomic_read(&mm->context.is_protected)))
+	if (unlikely(atomic_read(&mm->context.protected_count)))
 		return 1;
 #endif
 	return 0;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 2ab22500e092..9e900ce7387d 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -171,7 +171,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
-	atomic_set(&kvm->mm->context.is_protected, 0);
+	if (!cc)
+		atomic_dec(&kvm->mm->context.protected_count);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
 	/* Intended memory leak on "impossible" error */
@@ -213,11 +214,14 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
 
+	atomic_inc(&kvm->mm->context.protected_count);
 	if (cc) {
-		if (uvcb.header.rc & UVC_RC_NEED_DESTROY)
+		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
 			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
-		else
+		} else {
+			atomic_dec(&kvm->mm->context.protected_count);
 			kvm_s390_pv_dealloc_vm(kvm);
+		}
 		return -EIO;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
@@ -240,8 +244,6 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
 		     *rc, *rrc);
-	if (!cc)
-		atomic_set(&kvm->mm->context.is_protected, 1);
 	return cc ? -EINVAL : 0;
 }
 
-- 
2.34.1

