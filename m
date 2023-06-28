Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C986A7411FE
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 15:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbjF1NKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 09:10:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230458AbjF1NKi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 09:10:38 -0400
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35SCxjGr005743;
        Wed, 28 Jun 2023 13:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=dqrHOtS23igrd6a15KgAzVG3EY30E0zNBaHr7o1S/Jo=;
 b=EH4bNd3Rf5uOpHXqTeH2FcfpSUajSvP/WZi2up0e5k0ffDgqhKkfSq7kKkjeIJ6sikAs
 okkfT6Y9JhTCsoTyJlcDR9/OHGKKIFbBL0MJuW90UuS6c8/ZLgTKb2izpaNR58ZtAbal
 LywpY4szPQ0GbmdBUpfwXvCTp8uE7+SSloTnte3DGec0uUsUMKrq0bHI3ffZ/eu0tJ27
 YcJCOnegNn6zzD3zpKjTRNRPFMLgZi/HcS4blVAIJRrJj5vG9PyxggTgrSWLaGEZlwro
 O1AJXAEG4mii7+zn8E92KkIfySGVPGEklss1tvObe1ZFWr/kb6yR6tDmqeopl5voDrTb 2g== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rgn5w8u8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jun 2023 13:10:37 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35SBktk6031198;
        Wed, 28 Jun 2023 13:10:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3rdr451y53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jun 2023 13:10:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35SDAToP59375886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jun 2023 13:10:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7ADE20043;
        Wed, 28 Jun 2023 13:10:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8843A20040;
        Wed, 28 Jun 2023 13:10:29 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jun 2023 13:10:29 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, mhartmay@linux.ibm.com, nsg@linux.ibm.com,
        borntraeger@de.ibm.com
Subject: [PATCH v1 1/1] KVM: s390: pv: simplify shutdown and fix race
Date:   Wed, 28 Jun 2023 15:10:29 +0200
Message-ID: <20230628131029.35145-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AD9XzmSmvwHs_EMjcbfnD80M6S02vQSl
X-Proofpoint-GUID: AD9XzmSmvwHs_EMjcbfnD80M6S02vQSl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-28_08,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=851 malwarescore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 adultscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306280116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify the shutdown of non-protected VMs. There is no need to do
complex manipulations of the counter if it was zero.

This also fixes a very rare race which caused pages to be torn down
from the address space with a non-zero counter even on older machines
that don't support the UVC instruction, causing a crash.

Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Fixes: fb491d5500a7 ("KVM: s390: pv: asynchronous destroy for reboot")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 3ce5f4351156..899f3b8ac011 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -411,8 +411,12 @@ int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc)
 	u16 _rc, _rrc;
 	int cc = 0;
 
-	/* Make sure the counter does not reach 0 before calling s390_uv_destroy_range */
-	atomic_inc(&kvm->mm->context.protected_count);
+	/*
+	 * Nothing to do if the counter was already 0. Otherwise make sure
+	 * the counter does not reach 0 before calling s390_uv_destroy_range.
+	 */
+	if (!atomic_inc_not_zero(&kvm->mm->context.protected_count))
+		return 0;
 
 	*rc = 1;
 	/* If the current VM is protected, destroy it */
-- 
2.41.0

