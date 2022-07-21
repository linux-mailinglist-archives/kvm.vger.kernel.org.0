Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349AA57D119
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiGUQOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbiGUQN6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DE188E1B;
        Thu, 21 Jul 2022 09:13:51 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFx65n013127;
        Thu, 21 Jul 2022 16:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=U0aqesVDsD3VbmZcYW92tNUp0YFzr7xH3omgDmC5dNA=;
 b=b/NS3btqsg7RIczWq21yQRO49YCyGxY6OVeBN8c+NMuSp64s4/4xJSCVegmqmvIEWtPa
 Hhqb01L63S4Ew2LDnIvqZIFnGvGA6aP9YWm/5bxYUpp0Fkngj5OItLgubQV5W+aDnOJA
 RyDBrxVmhaFGnYHE4kRiYSRxBhTyktCmED5I6/xO83k6eCQrT5+VcKN0y8lKDBEox/Vs
 4YD3gwdrrFSrX3zi96r6fgvRXz2tKBKICT/6mUJNVv0+Gabw6uRGPy+xQnXqMvR9gRZl
 urteoruKMeDp8OgP70GIJnANESKqTuO8dn4QuupSDG6lE5czAzZjGdMdtbh9t2fIKmkE Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9x20fs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:33 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LG0ZhR024493;
        Thu, 21 Jul 2022 16:13:32 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9x20fqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:32 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG73g4029962;
        Thu, 21 Jul 2022 16:13:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj769t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDRwl20840840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8414BA4054;
        Thu, 21 Jul 2022 16:13:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09091A4060;
        Thu, 21 Jul 2022 16:13:27 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:26 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [GIT PULL 38/42] KVM: s390: pv: destroy the configuration before its memory
Date:   Thu, 21 Jul 2022 18:12:58 +0200
Message-Id: <20220721161302.156182-39-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: F78tenH2BNWUHRwnQJttqFtnW4UEX73h
X-Proofpoint-ORIG-GUID: HvFqRRR4pcNApzSrLhxl7pMWep7c9xdr
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the Destroy Secure Configuration UVC before the loop to destroy
the memory. If the protected VM has memory, it will be cleaned up and
made accessible by the Destroy Secure Configuration UVC. The struct
page for the relevant pages will still have the protected bit set, so
the loop is still needed to clean that up.

Switching the order of those two operations does not change the
outcome, but it is significantly faster.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220628135619.32410-13-imbrenda@linux.ibm.com
Message-Id: <20220628135619.32410-13-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 4b64bf5bc3b0..7cb7799a0acb 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -164,6 +164,9 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
+	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
+			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	/*
 	 * if the mm still has a mapping, make all its pages accessible
 	 * before destroying the guest
@@ -173,9 +176,6 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		mmput(kvm->mm);
 	}
 
-	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
-			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
-	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	if (!cc) {
 		atomic_dec(&kvm->mm->context.protected_count);
 		kvm_s390_pv_dealloc_vm(kvm);
-- 
2.36.1

