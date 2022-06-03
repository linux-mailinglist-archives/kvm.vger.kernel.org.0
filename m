Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83CC53C57B
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242027AbiFCG62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241807AbiFCG5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:57:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F74210D3;
        Thu,  2 Jun 2022 23:56:58 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2535C1t8029505;
        Fri, 3 Jun 2022 06:56:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oXlWSVqsE3tT9VcEPgf1JzO7RQ9KXN2+H3A/PeO4GYg=;
 b=MPv3D21M7s9CMNzaDHbf+PZkkVB9W29Iza1xJ/LaxkNhjAUq85eUyr7CxX3ULGB6P/TU
 h9ILozxNaLbusJgHU13Irk5A4YW9nlr7vmz8S+tYnRVWnawy/xlfwFTS+jMa+ufQkTLy
 M4lppu8s494/poRj0ls4HffMfoS2x7Fg9akIStKQMpV3zmQQerOz+LdizmIPu31LAj1O
 VWurmoz30KhX4kzbayPqyK3/KBJRmJFrPvdm2WCFYn+W4/uts5SySD6K+3ge+LHZXIHu
 PgW7fgREGSgdW2Ns9q80nwC473pwT1ZyJbx7SDPoVZEU+VsljzVrFMrV4RB8TKm79m15 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfbxjhjt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:57 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2536iY6i003472;
        Fri, 3 Jun 2022 06:56:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfbxjhjsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2536pmJO007404;
        Fri, 3 Jun 2022 06:56:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h81x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2536upPu30933478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 06:56:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EFB44204B;
        Fri,  3 Jun 2022 06:56:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02C604203F;
        Fri,  3 Jun 2022 06:56:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 06:56:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v11 12/19] KVM: s390: pv: refactoring of kvm_s390_pv_deinit_vm
Date:   Fri,  3 Jun 2022 08:56:38 +0200
Message-Id: <20220603065645.10019-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603065645.10019-1-imbrenda@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zdoJUFa9QMm-j4ZZJVHMVsoe8C04CXMq
X-Proofpoint-ORIG-GUID: JCXMsJ1FSZZ0ryXB6H7swU-7j47HLyDy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_02,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030027
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_s390_pv_deinit_vm to improve readability and simplify the
improvements that are coming in subsequent patches.

No functional change intended.

[note: this can potentially be squashed into the next patch, I factored
it out to simplify the review process]

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index da1bae111fb1..a389555d62e7 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -175,17 +175,17 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
-	if (!cc)
-		atomic_dec(&kvm->mm->context.protected_count);
-	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
-	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
-	/* Intended memory leak on "impossible" error */
 	if (!cc) {
+		atomic_dec(&kvm->mm->context.protected_count);
 		kvm_s390_pv_dealloc_vm(kvm);
-		return 0;
+	} else {
+		/* Intended memory leak on "impossible" error */
+		s390_replace_asce(kvm->arch.gmap);
 	}
-	s390_replace_asce(kvm->arch.gmap);
-	return -EIO;
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
+	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
+
+	return cc ? -EIO : 0;
 }
 
 static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
-- 
2.36.1

