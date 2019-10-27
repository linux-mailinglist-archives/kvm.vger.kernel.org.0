Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0170E6196
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 09:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfJ0IUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 04:20:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20930 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbfJ0IUL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 27 Oct 2019 04:20:11 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9R8CXsp096943;
        Sun, 27 Oct 2019 04:20:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vvgy24um5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Oct 2019 04:19:59 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x9R8Chbv097267;
        Sun, 27 Oct 2019 04:19:59 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vvgy24uky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Oct 2019 04:19:59 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9R8Gse5015131;
        Sun, 27 Oct 2019 08:19:58 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 2vvds6gxpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Oct 2019 08:19:58 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9R8JvEr24248630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Oct 2019 08:19:57 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A73706E050;
        Sun, 27 Oct 2019 08:19:57 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE2FB6E04E;
        Sun, 27 Oct 2019 08:19:55 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.36.74])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 27 Oct 2019 08:19:55 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] KVM: arm/arm64: show halt poll counters in debugfs
Date:   Sun, 27 Oct 2019 09:19:50 +0100
Message-Id: <1572164390-5851-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-27_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=567 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910270086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARM/ARM64 has counters halt_successful_poll, halt_attempted_poll,
halt_poll_invalid, and halt_wakeup but never exposed those in debugfs.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
This patch is untested
 arch/arm/kvm/guest.c   | 4 ++++
 arch/arm64/kvm/guest.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 684cf64..6696464 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -21,6 +21,10 @@
 #define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
+	VCPU_STAT(halt_successful_poll),
+	VCPU_STAT(halt_attempted_poll),
+	VCPU_STAT(halt_poll_invalid),
+	VCPU_STAT(halt_wakeup),
 	VCPU_STAT(hvc_exit_stat),
 	VCPU_STAT(wfe_exit_stat),
 	VCPU_STAT(wfi_exit_stat),
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dfd6264..260ea31 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -34,6 +34,10 @@
 #define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU }
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
+	VCPU_STAT(halt_successful_poll),
+	VCPU_STAT(halt_attempted_poll),
+	VCPU_STAT(halt_poll_invalid),
+	VCPU_STAT(halt_wakeup),
 	VCPU_STAT(hvc_exit_stat),
 	VCPU_STAT(wfe_exit_stat),
 	VCPU_STAT(wfi_exit_stat),
-- 
1.8.3.1

