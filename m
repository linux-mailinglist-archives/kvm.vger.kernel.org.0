Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C333197BB6
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 14:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgC3MTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 08:19:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729981AbgC3MTp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 08:19:45 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02UC3gHl111450
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 08:19:44 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30233787vy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 08:19:43 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 30 Mar 2020 13:19:29 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Mar 2020 13:19:26 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02UCJaL850659582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 12:19:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E44805205A;
        Mon, 30 Mar 2020 12:19:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id CFD8B52051;
        Mon, 30 Mar 2020 12:19:35 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 97D7BE024B; Mon, 30 Mar 2020 14:19:35 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [GIT PULL 1/1] s390/gmap: return proper error code on ksm unsharing
Date:   Mon, 30 Mar 2020 14:19:34 +0200
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200330121934.28143-1-borntraeger@de.ibm.com>
References: <20200330121934.28143-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20033012-0016-0000-0000-000002FAF3C7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033012-0017-0000-0000-0000335EAD14
Message-Id: <20200330121934.28143-2-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0
 bulkscore=0 mlxlogscore=847 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a signal is pending we might return -ENOMEM instead of -EINTR.
We should propagate the proper error during KSM unsharing.
unmerge_ksm_pages returns -ERESTARTSYS on signal_pending. This gets
translated by entry.S to -EINTR. It is important to get this error
code so that userspace can retry.

To make this clearer we also add -EINTR to the documentation of the
PV_ENABLE call, which calls unmerge_ksm_pages.

Fixes: 3ac8e38015d4 ("s390/mm: disable KSM for storage key enabled pages")
Reviewed-by: Janosch Frank <frankja@linux.vnet.ibm.com>
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Tested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 Documentation/virt/kvm/api.rst | 6 ++++++
 arch/s390/mm/gmap.c            | 9 +++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bae90f3cd11d..2edb28bd07a9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4677,6 +4677,12 @@ KVM_PV_ENABLE
   command has succeeded, any CPU added via hotplug will become
   protected during its creation as well.
 
+  Errors:
+
+  =====      =============================
+  EINTR      an unmasked signal is pending
+  =====      =============================
+
 KVM_PV_DISABLE
 
   Deregister the VM from the Ultravisor and reclaim the memory that
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 03c899849c38..2fbece47ef6f 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2552,12 +2552,13 @@ int gmap_mark_unmergeable(void)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
+	int ret;
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
-				MADV_UNMERGEABLE, &vma->vm_flags)) {
-			return -ENOMEM;
-		}
+		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
+				  MADV_UNMERGEABLE, &vma->vm_flags);
+		if (ret)
+			return ret;
 	}
 	mm->def_flags &= ~VM_MERGEABLE;
 	return 0;
-- 
2.25.1

