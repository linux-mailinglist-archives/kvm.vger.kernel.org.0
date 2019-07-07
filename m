Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1555661441
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 09:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfGGHjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 03:39:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfGGHjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 03:39:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677cXpq162814;
        Sun, 7 Jul 2019 07:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=a2GEwspnNjFpbwMjJDMOeYkvf5TA40JdGv93hXnmcGs=;
 b=SfZ5BvG9dXw3W7OqeJXybdW/UEGrsJgfTfyQhwXloDygUz6Q5GCC+1HwAQVMhh92GkP9
 eG1SQOahNox8opkqamxBuqNb+NQF+doM5EdCibcYGFQ6Tz6lPKIBESay//xCBC3qfclD
 thijsOIeMf4ytsEkRe1wRWBET4v6rsde1SUO+R7VE0irGtVYci0xAnBdJfSzdfSMgHjC
 G3hF7US8xNLr5KlS+BID+IPr36HfYDbXU9pI5susuOqXsjW9hXGWmO65bcJmKimLvi1J
 jy8f/d7UGxZ0lJv3c0f/ahqKC8LkBzhisqPe3e5PzSFbEQQrqt+z3EhVhKkhUT2beYsk qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tjk2taat7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677buaf180430;
        Sun, 7 Jul 2019 07:39:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tjhpc39ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x677dMoN026128;
        Sun, 7 Jul 2019 07:39:22 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jul 2019 07:39:21 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/5] KVM: nVMX: Skip VM-Exit Control vmentry checks that are necessary only if VMCS12 is dirty
Date:   Sun,  7 Jul 2019 03:11:44 -0400
Message-Id: <20190707071147.11651-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=545
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907070104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=592 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907070104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 ..so that every nested vmentry is not slowed down by those checks.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b0b59c78b3e8..056eba497730 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2505,6 +2505,15 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int nested_check_vm_exit_controls_full(struct kvm_vcpu *vcpu,
+					      struct vmcs12 *vmcs12)
+{
+	if (nested_vmx_check_exit_msr_switch_controls(vcpu, vmcs12))
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * Checks related to VM-Exit Control Fields
  */
@@ -2515,8 +2524,11 @@ static int nested_check_vm_exit_controls(struct kvm_vcpu *vcpu,
 
 	if (!vmx_control_verify(vmcs12->vm_exit_controls,
 				vmx->nested.msrs.exit_ctls_low,
-				vmx->nested.msrs.exit_ctls_high) ||
-	    nested_vmx_check_exit_msr_switch_controls(vcpu, vmcs12))
+				vmx->nested.msrs.exit_ctls_high))
+		return -EINVAL;
+
+	if ((vmx->nested.dirty_vmcs12) &&
+	    nested_check_vm_exit_controls_full(vcpu, vmcs12))
 		return -EINVAL;
 
 	return 0;
-- 
2.20.1

