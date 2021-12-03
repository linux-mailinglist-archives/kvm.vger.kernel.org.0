Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E172F467BF5
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382312AbhLCRB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:01:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24576 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382269AbhLCRBv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:51 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3FlWYm021967;
        Fri, 3 Dec 2021 16:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EcZBexmKpFRDPhdVsdKUAhAxPl3JBXoz0MTk6fKAMko=;
 b=DxTHN7uKkh7OqiyCTzb/xuEEjMM6bRE+HMzxR8ROoOOA7G9MemYROUdNd613KbWfMvzS
 +1m+g2VytVrFxWik9/XZ2oXYcJksEv27MV3AMOe2dFncCKooBSl5W/agOOYnFhpQkbnK
 WkiVUeRq4CYY+jHHVjeJfZkHE684bDmS7lI5v9L/HnWO2thgwmWd08bwdr+zpFKMX+Vf
 OFXBEL/0W+fSCUezcOwwL6f1EP5+b0u6uS+e+XuLSR+M0oal3p/+n0wVR6TGhQyWhFI+
 eUkAygtv1+/FEqD2ly2YHn1UqOHrBgLu50Nml2aSwT1pauvGo7fh7+rKrEoY7KQbdg8Y 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqp6mhebg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:26 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3Gde5E012113;
        Fri, 3 Dec 2021 16:58:26 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqp6mheax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:26 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3Gvkv4004803;
        Fri, 3 Dec 2021 16:58:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ckcaan3dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:23 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwKYG28705062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E6AD5204E;
        Fri,  3 Dec 2021 16:58:20 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9FD3A5204F;
        Fri,  3 Dec 2021 16:58:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 08/17] KVM: s390: pv: make kvm_s390_cpus_from_pv global
Date:   Fri,  3 Dec 2021 17:58:05 +0100
Message-Id: <20211203165814.73016-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lYwuIWLb6xIxyicy1Wtcrk15_sp8DLDL
X-Proofpoint-ORIG-GUID: 91OytFK1wHrbrFyi32bMTj40uRDYt45V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=925 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112030105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The functions kvm_s390_cpus_from_pv needs to be called from pv.c, so
make it global.

Take the opportunity to add documentation.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 26 +++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h |  1 +
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0c08066067e8..850d86995083 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2206,7 +2206,20 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
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
@@ -2233,6 +2246,17 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
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
 	int i, r = 0;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c07a050d757d..ef9429cb0307 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -351,6 +351,7 @@ int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
+int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp);
 
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
-- 
2.31.1

