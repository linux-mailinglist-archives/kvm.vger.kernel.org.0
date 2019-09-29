Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7205C15DA
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2019 16:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfI2OvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Sep 2019 10:51:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56222 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfI2OvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Sep 2019 10:51:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8TEdJNM101979;
        Sun, 29 Sep 2019 14:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=Fhg9wY0MN9NjJv1FypLcGMLYNfuFMXgxdxO/SBR7uKs=;
 b=dW0RJUVxZNqOKLVB4m+Vx0vKKB5xleGC1eSrsIzRYXflPuU8co3aQAYjsgAwIaPykxLw
 MHisdHofIvqwOw/K6ZeTCB/OOJlyy/jC56abWODA450ADBuO68g1Djg3Qjgk1EF64K8P
 hyvZbbDc1CUd3ShlTjJ4QEiOBc/VIM/fc32sb0hpoxBIbvMwKDnNFvLQT0D4TCpWBW52
 W/SunpLvEY9HjDem40ZIoKBWE6dItKTGonJ/AWp3W1ybNIIzad22vgS2Q9YfuMAfeieF
 xMh8cSBBN8GdHJUCSltImYbADvZDKsv6y3Mqd9EsWouvFZy4Ked/CjoV0Zpaz2Qt+9Rl iA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05raxmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Sep 2019 14:50:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8TEca9g074264;
        Sun, 29 Sep 2019 14:50:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vahp9k2kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Sep 2019 14:50:37 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8TEob4j023636;
        Sun, 29 Sep 2019 14:50:37 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 29 Sep 2019 07:50:36 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     tao3.xu@intel.com, sean.j.christopherson@intel.com,
        jmattson@google.com, vkuznets@redhat.com,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH] KVM: VMX: Remove proprietary handling of unexpected exit-reasons
Date:   Sun, 29 Sep 2019 17:50:18 +0300
Message-Id: <20190929145018.120753-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9394 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909290166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9394 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909290166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit
and handle WAITPKG vmexit") introduced proprietary handling of
specific exit-reasons that should not be raised by CPU because
KVM configures VMCS such that they should never be raised.

However, since commit 7396d337cfad ("KVM: x86: Return to userspace
with internal error on unexpected exit reason"), VMX & SVM
exit handlers were modified to generically handle all unexpected
exit-reasons by returning to userspace with internal error.

Therefore, there is no need for proprietary handling of specific
unexpected exit-reasons (This proprietary handling also introduced
inconsistency for these exit-reasons to silently skip guest instruction
instead of return to userspace on internal-error).

Fixes: bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit")

Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4575ffb3cec..e31317fc8c95 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5538,14 +5538,6 @@ static int handle_encls(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static int handle_unexpected_vmexit(struct kvm_vcpu *vcpu)
-{
-	kvm_skip_emulated_instruction(vcpu);
-	WARN_ONCE(1, "Unexpected VM-Exit Reason = 0x%x",
-		vmcs_read32(VM_EXIT_REASON));
-	return 1;
-}
-
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5597,15 +5589,11 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
 	[EXIT_REASON_RDRAND]                  = handle_invalid_op,
 	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
-	[EXIT_REASON_XSAVES]                  = handle_unexpected_vmexit,
-	[EXIT_REASON_XRSTORS]                 = handle_unexpected_vmexit,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
 	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
 	[EXIT_REASON_ENCLS]		      = handle_encls,
-	[EXIT_REASON_UMWAIT]                  = handle_unexpected_vmexit,
-	[EXIT_REASON_TPAUSE]                  = handle_unexpected_vmexit,
 };
 
 static const int kvm_vmx_max_exit_handlers =
-- 
2.20.1

