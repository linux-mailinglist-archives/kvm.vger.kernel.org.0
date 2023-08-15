Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1838F77CED7
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 17:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbjHOPOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 11:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237922AbjHOPOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 11:14:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A881BDC;
        Tue, 15 Aug 2023 08:14:24 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37FEwxet001469;
        Tue, 15 Aug 2023 15:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zl5/UEVLlsLC2yVAXWkapXObekJg1H6TUvZ2bbhSqeg=;
 b=oCR19rTkWxiSS0LDzyas0HbSQdMo+BFweZd2wacATphu6QMZ7g2bQar5ds4SvK1G9paD
 D+GjWaVYPCi1d0Tx4Ec/oh4fwN7v30k9EgAntbuAFk7uKQVYzpBoNXWZgcpNyczy5vUo
 TygH46uAFInZ9A91oH7J8mMmQP6zpDwsZioVW17+sghqgMF60SJPpEtuHN/LaE7d29o/
 OqzfTz2p4p70CTu9/F27O15NCa4a60pcwnP+PdFYL0DVdiLqIvOPU1AsL2iHpIL5eC83
 8VWzAWVgskk+4elkEGyQV4PXSbq4wcbp06epsVRF3k2Hw1+x7hfHIt6TMRZWeuiJJS5n 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgbkm8kbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:22 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37FF0MU0006222;
        Tue, 15 Aug 2023 15:14:22 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgbkm8kbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:22 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37FDYleX007871;
        Tue, 15 Aug 2023 15:14:21 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3senwk5ecr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 15:14:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37FFEH3E15401558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Aug 2023 15:14:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A42120040;
        Tue, 15 Aug 2023 15:14:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AC9E2004E;
        Tue, 15 Aug 2023 15:14:17 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 15 Aug 2023 15:14:17 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Michael Mueller <mimu@linux.vnet.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Subject: [PATCH v4 4/4] KVM: s390: pv:  Allow AP-instructions for pv-guests
Date:   Tue, 15 Aug 2023 17:14:15 +0200
Message-ID: <20230815151415.379760-5-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230815151415.379760-1-seiden@linux.ibm.com>
References: <20230815151415.379760-1-seiden@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c5e0YDsGHZ0mqVcfYuewtArnOzZL5cVl
X-Proofpoint-GUID: SM6JyOgy_3ThTZifKnzHrdCfW-3eQyVt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-15_14,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308150134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduces new feature bits and enablement flags for AP and AP IRQ
support.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 12 +++++++++++-
 arch/s390/kvm/pv.c         |  6 ++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 823adfff7315..0e7bd3873907 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -99,6 +99,8 @@ enum uv_cmds_inst {
 enum uv_feat_ind {
 	BIT_UV_FEAT_MISC = 0,
 	BIT_UV_FEAT_AIV = 1,
+	BIT_UV_FEAT_AP = 4,
+	BIT_UV_FEAT_AP_INTR = 5,
 };
 
 struct uv_cb_header {
@@ -159,7 +161,15 @@ struct uv_cb_cgc {
 	u64 guest_handle;
 	u64 conf_base_stor_origin;
 	u64 conf_virt_stor_origin;
-	u64 reserved30;
+	u8  reserved30[6];
+	union {
+		struct {
+			u16 : 14;
+			u16 ap_instr_intr : 1;
+			u16 ap_allow_instr : 1;
+		};
+		u16 raw;
+	} flags;
 	u64 guest_stor_origin;
 	u64 guest_stor_len;
 	u64 guest_sca;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 8570ee324607..75e81ba26d04 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -576,12 +576,14 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	uvcb.conf_base_stor_origin =
 		virt_to_phys((void *)kvm->arch.pv.stor_base);
 	uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
+	uvcb.flags.ap_allow_instr = kvm->arch.model.uv_feat_guest.ap;
+	uvcb.flags.ap_instr_intr = kvm->arch.model.uv_feat_guest.ap_intr;
 
 	cc = uv_call_sched(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
-	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
-		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x flags %04x",
+		     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc, uvcb.flags.raw);
 
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
-- 
2.41.0

