Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEAF53C576
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242105AbiFCG6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241776AbiFCG5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:57:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D2E1096;
        Thu,  2 Jun 2022 23:56:56 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2535s28A031280;
        Fri, 3 Jun 2022 06:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MoQQR0OtGcdnAn2GT7SIpjNMWaWEqnLOY9lVnK+kD68=;
 b=Lq8cd1kkdGTGOp/4E4M5nTbd5fb5yvA5B0+q9JarKdBR8fNJ5ru9draNr+ZQeySmf+wJ
 7lr3VJLwnJIjoAJ9blNaBkDsu2aAJVFJdfJzit/V1GpsyPos2ykyh/2W3us/PSShNHzu
 ZM/ngD48BhiwvzRLbm8s3T3U2A3HIEGwldMEhm/TCyepIpbsUsOLcM/zT9WcUsNy5Sjp
 5v/zkHBwmh40ZCagmrRMHNZYEhdj9K3D7BwaF/TmL+PBjX83S/bLuwyfDs5pP8lxBRcN
 ZSJWzW5aedNiOkjoe2hhcR4LzYsM0VwNeb6yzMcvaWbYjmqhR+YAzvAM+FX1TCx04G2l gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfcj8rxf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:56 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2536R3RU011525;
        Fri, 3 Jun 2022 06:56:55 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfcj8rxeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:55 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2536pgUR023035;
        Fri, 3 Jun 2022 06:56:53 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3gbc8yp3p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2536uijT19857824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 06:56:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E06B42045;
        Fri,  3 Jun 2022 06:56:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA3E34203F;
        Fri,  3 Jun 2022 06:56:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 06:56:49 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v11 09/19] KVM: s390: pv: Add kvm_s390_cpus_from_pv to kvm-s390.h and add documentation
Date:   Fri,  3 Jun 2022 08:56:35 +0200
Message-Id: <20220603065645.10019-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603065645.10019-1-imbrenda@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1-tZGkFtJqf82VjSTmwZvo7w_lPbgxzU
X-Proofpoint-ORIG-GUID: iZ--SAk1l7rKF2kMb0aUzyLFnV-gHpG4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_01,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 spamscore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxlogscore=958 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206030027
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Future changes make it necessary to call this function from pv.c.

While we are at it, let's properly document kvm_s390_cpus_from_pv() and
kvm_s390_cpus_to_pv().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 26 +++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h |  1 +
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 49e27b5d7c3a..8973985593a9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2175,7 +2175,20 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 	return r;
 }
 
-static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
+/**
+ * kvm_s390_cpus_from_pv - Convert all protected vCPUs in a protected VM to
+ * non protected.
+ * @kvm the VM whose protected vCPUs are to be converted
+ * @rcp return value for the RC field of the UVC (in case of error)
+ * @rrcp return value for the RRC field of the UVC (in case of error)
+ *
+ * Does not stop in case of error, tries to convert as many
+ * CPUs as possible. In case of error, the RC and RRC of the last error are
+ * returned.
+ *
+ * Return: 0 in case of success, otherwise -EIO
+ */
+int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
 {
 	struct kvm_vcpu *vcpu;
 	u16 rc, rrc;
@@ -2205,6 +2218,17 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
 	return ret;
 }
 
+/**
+ * kvm_s390_cpus_to_pv - Convert all non-protected vCPUs in a protected VM
+ * to protected.
+ * @kvm the VM whose protected vCPUs are to be converted
+ * @rcp return value for the RC field of the UVC (in case of error)
+ * @rrcp return value for the RRC field of the UVC (in case of error)
+ *
+ * Tries to undo the conversion in case of error.
+ *
+ * Return: 0 in case of success, otherwise -EIO
+ */
 static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	unsigned long i;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 497d52a83c78..d3abedafa7a8 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -374,6 +374,7 @@ int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
+int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp);
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
-- 
2.36.1

