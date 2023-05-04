Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62FBB6F70A8
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 19:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjEDRQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 13:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjEDRQX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 13:16:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1B13AA7;
        Thu,  4 May 2023 10:16:19 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344HBt36021891;
        Thu, 4 May 2023 17:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pyxaYapYcZEivzBtGPXFRczFbtxpavtsVETyLuedCDo=;
 b=TZB/AXz2fmnW0tCHwt9d/rbHrxc0h9qBtBGUJbKp1GEhP4zNNoLzEuOiObiY/SG8ncwN
 fS7mnJRC+vHB1jBmCdtU9u2XJhoNzhdfRfNRmBPEE40WLReI9wU/m2kcYeQQA5llv4LA
 GrghALEo2KQSwVBSdbrfbxGG1njR4R28iVrbaKyzbfNwCv2ehMpeUDhPwY6Qu0GfmqsG
 D9dhQNwZENYe2npFDAg9eDnoSdSgBNiXhWteAtP9kL0NwUh4PJ1vrbIdnb5MXRLI/uVM
 pI/dvyuDy3ZZcFdjE2Gd5Bf+9qQkNgN3RDh089uGirS1N+IPqLQUVPSCyELPWmHBCS6G 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qcgw1g6ev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 17:16:18 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 344HC6RI023855;
        Thu, 4 May 2023 17:16:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qcgw1g6du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 17:16:17 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 344GdNd3008425;
        Thu, 4 May 2023 17:16:15 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6tfwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 17:16:15 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 344HGCG940305090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 May 2023 17:16:12 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0884020043;
        Thu,  4 May 2023 17:16:12 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D78F720040;
        Thu,  4 May 2023 17:16:11 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  4 May 2023 17:16:11 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, david@redhat.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [GIT PULL 1/2] KVM: s390: pv: fix asynchronous teardown for small VMs
Date:   Thu,  4 May 2023 19:16:10 +0200
Message-Id: <20230504171611.54844-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230504171611.54844-1-imbrenda@linux.ibm.com>
References: <20230504171611.54844-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A5vM-mnyYt9gfAvmjLGJ9CKCB_k8gx3D
X-Proofpoint-ORIG-GUID: ynYwaZhsT5OUQZ0N8iPzredNhrkzG6Wl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_10,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 phishscore=0 impostorscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305040139
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
Reviewed-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20230421085036.52511-2-imbrenda@linux.ibm.com>
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
2.40.1

