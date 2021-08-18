Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87F33F04A0
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbhHRN1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:27:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237053AbhHRN1F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 09:27:05 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ID2d5r068168;
        Wed, 18 Aug 2021 09:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MrpsBf7BpRYiZzx9rvfVKZqPfVD0PHTDmLG1CLZVnJs=;
 b=Gcih3XH9ZUHz6U0681VUs3c/+HHCDd8+OMED8mGs4gaqlzZ8DQ1a0Gak1FoI7CaJNIfQ
 L24uRnoiHhZjeMNTT/wfVkmkcfz9L4MuxmmcEku+c9JDUBtEKujrvkBHiLu0G8frHqql
 +PR0LlsGeUEQwu6iEdVDbF4d9GKoMgTvss1CptNAWbHW6xgmcjjvq/o0HR3FgdZKisth
 QNIRBvl86S3tHnKWcvwKS4BPARBbKtlDhGWjbzNOc980TUI+NuwRV+YrdqZRPCYdkWw4
 3owTIfQIigPNZ2VTV1FDP2UzqQv3ocROcSXLdzxke9AH7B3PIqyqaYsoV7WC5+FzBS8U mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agkvmqm8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:30 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17ID3Mqd070481;
        Wed, 18 Aug 2021 09:26:29 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agkvmqm7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:29 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IDCUsS020777;
        Wed, 18 Aug 2021 13:26:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3ae5f8dqwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 13:26:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IDQMOj43712906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 13:26:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 602D24C066;
        Wed, 18 Aug 2021 13:26:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D055F4C059;
        Wed, 18 Aug 2021 13:26:21 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.177])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 13:26:21 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v4 02/14] KVM: s390: pv: avoid double free of sida page
Date:   Wed, 18 Aug 2021 15:26:08 +0200
Message-Id: <20210818132620.46770-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818132620.46770-1-imbrenda@linux.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B4SWFjshTXa02XigsqcV9c4n4vip0o4j
X-Proofpoint-GUID: 1o4GGPeO2_wpou5VZLrtmLzSHCKEVog9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_04:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=587 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If kvm_s390_pv_destroy_cpu is called more than once, we risk calling
free_page on a random page, since the sidad field is aliased with the
gbea, which is not guaranteed to be zero.

The solution is to simply return successfully immediately if the vCPU
was already non secure.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 19e1227768863a1469797c13ef8fea1af7beac2c ("KVM: S390: protvirt: Introduce instruction data area bounce buffer")
---
 arch/s390/kvm/pv.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index c8841f476e91..0a854115100b 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -16,18 +16,17 @@
 
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
-	int cc = 0;
+	int cc;
 
-	if (kvm_s390_pv_cpu_get_handle(vcpu)) {
-		cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu),
-				   UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
+	if (!kvm_s390_pv_cpu_get_handle(vcpu))
+		return 0;
+
+	cc = uv_cmd_nodata(kvm_s390_pv_cpu_get_handle(vcpu), UVC_CMD_DESTROY_SEC_CPU, rc, rrc);
+
+	KVM_UV_EVENT(vcpu->kvm, 3, "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
+		     vcpu->vcpu_id, *rc, *rrc);
+	WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x", *rc, *rrc);
 
-		KVM_UV_EVENT(vcpu->kvm, 3,
-			     "PROTVIRT DESTROY VCPU %d: rc %x rrc %x",
-			     vcpu->vcpu_id, *rc, *rrc);
-		WARN_ONCE(cc, "protvirt destroy cpu failed rc %x rrc %x",
-			  *rc, *rrc);
-	}
 	/* Intended memory leak for something that should never happen. */
 	if (!cc)
 		free_pages(vcpu->arch.pv.stor_base,
-- 
2.31.1

