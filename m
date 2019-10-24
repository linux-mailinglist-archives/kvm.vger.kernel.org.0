Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618ACE30B8
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439127AbfJXLmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41430 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439117AbfJXLmA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:00 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBcLk1123478
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:41:59 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vu8m16afy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:41:59 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:41:56 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:41:54 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBfqeM61866176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:41:53 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9A8F5204F;
        Thu, 24 Oct 2019 11:41:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3E69A52051;
        Thu, 24 Oct 2019 11:41:51 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 05/37] s390: KVM: Export PV handle to gmap
Date:   Thu, 24 Oct 2019 07:40:27 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0012-0000-0000-0000035CCA88
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0013-0000-0000-00002197FCE4
Message-Id: <20191024114059.102802-6-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=523 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need it in the next patch, when doing memory management for the
guest in the kernel's fault handler, where otherwise we wouldn't have
access to the handle.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h | 1 +
 arch/s390/kvm/pv.c           | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 37f96b6f0e61..6efc0b501227 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -61,6 +61,7 @@ struct gmap {
 	spinlock_t shadow_lock;
 	struct gmap *parent;
 	unsigned long orig_asce;
+	unsigned long se_handle;
 	int edat_level;
 	bool removed;
 	bool initialized;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 94cf16f40f25..80aecd5bea9e 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -169,6 +169,7 @@ int kvm_s390_pv_create_vm(struct kvm *kvm)
 		kvm_s390_pv_dealloc_vm(kvm);
 		return -EINVAL;
 	}
+	kvm->arch.gmap->se_handle = uvcb.guest_handle;
 	return rc;
 }
 
-- 
2.20.1

