Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2CA6EA640
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 10:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjDUIvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 04:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjDUIu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 04:50:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7015A5EB;
        Fri, 21 Apr 2023 01:50:51 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L8GvDm015269;
        Fri, 21 Apr 2023 08:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=K4x88Gk6ByI/a+z/pQf3w7qOH+kK0c5Y7wY7i+6TMuA=;
 b=PyeK7bM1A9OvgZNgwYDSqeJEcDOS6XRoOnbaLGHH/c+b7wKGlpIebxy6L3JmwO3fDfhP
 YbvHKb6SBMXeQUS81U3xcO2uMgZ+OGz2zfdSGVYpmYdSQhJ0J5mIGyNkhoT5EO00ATVN
 Jk5Dcx67/EulVAVmaFlEYTr/qdpl/MvwarsZRX/rD3CQlMGBB+IAXccEuZr5rAdzLmW4
 oUyWTKvKDG10V5uPBQHoLwJaB3JNpRae8OmdcLYukKbX6lZoNVvgZimeGsX3JUKLO2Pl
 jaZowTCBCN7ylbWTiny+Q7Aa36bRSAyXpdM0e52u7cM2DJuhXYWTMvPNXZka0GXSwW9t bw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3pbbaj3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:50:51 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33KNnBHU024408;
        Fri, 21 Apr 2023 08:50:48 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6kx8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 08:50:48 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33L8og5m16319086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 08:50:42 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A890D20040;
        Fri, 21 Apr 2023 08:50:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2343F2004D;
        Fri, 21 Apr 2023 08:50:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.17.52])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Apr 2023 08:50:42 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, mhartmay@linux.ibm.com,
        kvm390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH v2 1/1] KVM: s390: pv: fix asynchronous teardown for small VMs
Date:   Fri, 21 Apr 2023 10:50:36 +0200
Message-Id: <20230421085036.52511-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421085036.52511-1-imbrenda@linux.ibm.com>
References: <20230421085036.52511-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PZKBB2RPileEZwwOTVz_8QFkbDx1lHtf
X-Proofpoint-GUID: PZKBB2RPileEZwwOTVz_8QFkbDx1lHtf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_02,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On machines without the Destroy Secure Configuration Fast UVC, the
topmost level of page tables is set aside and freed asynchronously
as last step of the asynchronous teardown.

Each gmap has a host_to_guest radix tree mapping host (userspace)
addresses (with 1M granularity) to gmap segment table entries (pmds).

If a guest is smaller than 2GB, the topmost level of page tables is the
segment table (i.e. there are only 2 levels). Replacing it means that
the pointers in the host_to_guest mapping would become stale and cause
all kinds of nasty issues.

This patch fixes the issue by disallowing asynchronous teardown for
guests with only 2 levels of page tables. Userspace should (and already
does) try using the normal destroy if the asynchronous one fails.

Update s390_replace_asce so it refuses to replace segment type ASCEs.
This is still needed in case the normal destroy VM fails.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
---
 arch/s390/kvm/pv.c  | 5 +++++
 arch/s390/mm/gmap.c | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index e032ebbf51b9..3ce5f4351156 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -314,6 +314,11 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 	 */
 	if (kvm->arch.pv.set_aside)
 		return -EINVAL;
+
+	/* Guest with segment type ASCE, refuse to destroy asynchronously */
+	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
+		return -EINVAL;
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 5a716bdcba05..2267cf9819b2 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2833,6 +2833,9 @@ EXPORT_SYMBOL_GPL(s390_unlist_old_asce);
  * s390_replace_asce - Try to replace the current ASCE of a gmap with a copy
  * @gmap: the gmap whose ASCE needs to be replaced
  *
+ * If the ASCE is a SEGMENT type then this function will return -EINVAL,
+ * otherwise the pointers in the host_to_guest radix tree will keep pointing
+ * to the wrong pages, causing use-after-free and memory corruption.
  * If the allocation of the new top level page table fails, the ASCE is not
  * replaced.
  * In any case, the old ASCE is always removed from the gmap CRST list.
@@ -2847,6 +2850,10 @@ int s390_replace_asce(struct gmap *gmap)
 
 	s390_unlist_old_asce(gmap);
 
+	/* Replacing segment type ASCEs would cause serious issues */
+	if ((gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
+		return -EINVAL;
+
 	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
-- 
2.40.0

