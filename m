Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B0C674EB5
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 08:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjATHyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 02:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjATHyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 02:54:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8B7442D8;
        Thu, 19 Jan 2023 23:54:14 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30K7pSLx015655;
        Fri, 20 Jan 2023 07:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=6JBvTRMQQwECIqjgF8Wa6qZrjb0V0Y89r+pdmrHbovI=;
 b=Byh8hHHCTNQIxsPuefHi9gIfEIizhMcDgAgJIrOTx0cIDGIHjfe1aInc7aqIuNbyxk9d
 xjqKiXNfa6n4t+rwhGAFnNisFZpr0q8O0bKlG4KtI4RIkG0fKgGY+nDkazmgFpki+mG1
 3LOpY4POKjtTtstziwjZchwqCPz9rq34W7zbX4ALDTxXuw/j95aB++rgoTyLXn/s08AR
 V/1CL9xE6UDmEaQKa2LIvQm2o2bLBhvewZIALvyGGQW5NhfftFe6IfxUdz+UFigWLTCJ
 ANqghso4OLndqz7/P9loA7hhBBeD69ytfrCiUzoTNxC3OMWNKEPVelJzODLxsn2CO+Oa 2g== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7kvx3q52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 07:54:14 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30K7IvV4007302;
        Fri, 20 Jan 2023 07:54:12 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3n3m16nk4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 07:54:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30K7s78A22020414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 07:54:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 127502004D;
        Fri, 20 Jan 2023 07:54:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0AF12004B;
        Fri, 20 Jan 2023 07:54:06 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Jan 2023 07:54:06 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1] KVM: s390: disable migration mode when dirty tracking is disabled
Date:   Fri, 20 Jan 2023 08:54:06 +0100
Message-Id: <20230120075406.101436-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jkOfQue9sTwFUsDyuyFs2eCdyp3CoZlr
X-Proofpoint-GUID: jkOfQue9sTwFUsDyuyFs2eCdyp3CoZlr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_04,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 clxscore=1011 phishscore=0 spamscore=0 mlxlogscore=731 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301200070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Migration mode is a VM attribute which enables tracking of changes in
storage attributes (PGSTE). It assumes dirty tracking is enabled on all
memslots to keep a dirty bitmap of pages with changed storage attributes.

When enabling migration mode, we currently check that dirty tracking is
enabled for all memslots. However, userspace can disable dirty tracking
without disabling migration mode.

Since migration mode is pointless with dirty tracking disabled, disable
migration mode whenever userspace disables dirty tracking on any slot.

Also update the documentation to clarify that dirty tracking must be
enabled when enabling migration mode, which is already enforced by the
code in kvm_s390_vm_start_migration().

To disable migration mode, slots_lock should be held, which is taken
in kvm_set_memory_region() and thus held in
kvm_arch_prepare_memory_region().

Restructure the prepare code a bit so all the sanity checking is done
before disabling migration mode. This ensures migration mode isn't
disabled when some sanity check fails.

Cc: stable@vger.kernel.org
Fixes: 190df4a212a7 ("KVM: s390: CMMA tracking, ESSA emulation, migration mode")
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 Documentation/virt/kvm/devices/vm.rst |  4 +++
 arch/s390/kvm/kvm-s390.c              | 41 ++++++++++++++++++---------
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 60acc39e0e93..147efec626e5 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -302,6 +302,10 @@ Allows userspace to start migration mode, needed for PGSTE migration.
 Setting this attribute when migration mode is already active will have
 no effects.
 
+Dirty tracking must be enabled on all memslots, else -EINVAL is returned. When
+dirty tracking is disabled on any memslot, migration mode is automatically
+stopped.
+
 :Parameters: none
 :Returns:   -ENOMEM if there is not enough free memory to start migration mode;
 	    -EINVAL if the state of the VM is invalid (e.g. no memory defined);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e4890e04b210..4785f002cd93 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5628,28 +5628,43 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   enum kvm_mr_change change)
 {
 	gpa_t size;
+	int rc;
 
 	/* When we are protected, we should not change the memory slots */
 	if (kvm_s390_pv_get_handle(kvm))
 		return -EINVAL;
 
-	if (change == KVM_MR_DELETE || change == KVM_MR_FLAGS_ONLY)
-		return 0;
+	if (change != KVM_MR_DELETE && change != KVM_MR_FLAGS_ONLY) {
+		/* A few sanity checks. We can have memory slots which have to be
+		 * located/ended at a segment boundary (1MB). The memory in userland is
+		 * ok to be fragmented into various different vmas. It is okay to mmap()
+		 * and munmap() stuff in this slot after doing this call at any time
+		 */
 
-	/* A few sanity checks. We can have memory slots which have to be
-	   located/ended at a segment boundary (1MB). The memory in userland is
-	   ok to be fragmented into various different vmas. It is okay to mmap()
-	   and munmap() stuff in this slot after doing this call at any time */
+		if (new->userspace_addr & 0xffffful)
+			return -EINVAL;
 
-	if (new->userspace_addr & 0xffffful)
-		return -EINVAL;
+		size = new->npages * PAGE_SIZE;
+		if (size & 0xffffful)
+			return -EINVAL;
 
-	size = new->npages * PAGE_SIZE;
-	if (size & 0xffffful)
-		return -EINVAL;
+		if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
+			return -EINVAL;
+	}
 
-	if ((new->base_gfn * PAGE_SIZE) + size > kvm->arch.mem_limit)
-		return -EINVAL;
+	/* Turn off migration mode when userspace disables dirty page logging.
+	 * Migration mode expects dirty page logging being enabled to store
+	 * its dirty bitmap.
+	 */
+	if (kvm->arch.migration_mode) {
+		if ((old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
+		    !(new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
+			rc = kvm_s390_vm_stop_migration(kvm);
+
+			if (rc)
+				pr_warn("Failed to stop migration mode\n");
+		}
+	}
 
 	return 0;
 }
-- 
2.39.0

