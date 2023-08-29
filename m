Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DBC78C3D4
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 14:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbjH2MKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 08:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbjH2MJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 08:09:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B1698;
        Tue, 29 Aug 2023 05:09:33 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37TC8mFw025159;
        Tue, 29 Aug 2023 12:09:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=RCIDrItCQzAWqP9BQaLAEr1NSfrzuGjTCz4sb/p1pHs=;
 b=XE+0DBZp1SvfbrfxURRNgX/hr5r9Zdrwf1jG8Y14W6puAdl/hUqV7e/0e+gpQfWNEtfP
 AtZwb16AbhcfsW8Ywa4eKJSXp08NkAolTRSHnre1XvYOkUtSLbZj3xz8U52ypPr2z708
 FSHxyFuCEGdFawu7rGTo8+89EIPenE+3H8N2VMIlUNs1X1iMP7fZz+2aQqr0w4yNQpsE
 pKaB00/bFWdmRvjj932oycB99GD5CczhMfITBHzvdq1eX8IXQTGnF1eqVbV8lcaCZoEg
 gd3l9lAYPDiqyqOswj/7T6nT/6zBLMcbMW4oMr5vDvovZlovpB4+mKTuRDA13EM8URHy UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssfras1du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:32 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37TC9Hax029553;
        Tue, 29 Aug 2023 12:09:32 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ssfras1c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:32 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37TC9Pfo020504;
        Tue, 29 Aug 2023 12:09:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sqv3ybcqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Aug 2023 12:09:30 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37TC9Rl442992244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Aug 2023 12:09:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93C3B20040;
        Tue, 29 Aug 2023 12:09:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3CC020043;
        Tue, 29 Aug 2023 12:09:26 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.19.123])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Aug 2023 12:09:26 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, seanjc@google.com
Subject: [GIT PULL v2 10/10] KVM: s390: pv: Allow AP-instructions for pv-guests
Date:   Tue, 29 Aug 2023 14:04:05 +0200
Message-ID: <20230829120843.66637-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829120843.66637-1-frankja@linux.ibm.com>
References: <20230829120843.66637-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UyAO6kxSLfXtmVfbHJGD0iIHJvtWEN1D
X-Proofpoint-ORIG-GUID: pXNzZhFNzepQbTa0SClu2t5hDQVSgmca
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-29_09,2023-08-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=904 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308290105
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Steffen Eiden <seiden@linux.ibm.com>

Introduces new feature bits and enablement flags for AP and AP IRQ
support.

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Michael Mueller <mimu@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230815151415.379760-5-seiden@linux.ibm.com
Message-Id: <20230815151415.379760-5-seiden@linux.ibm.com>
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
index beeebc11b1a1..22fb482f042d 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -572,12 +572,14 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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

