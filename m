Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929F854D98
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 13:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfFYL1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 07:27:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56026 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbfFYL1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 07:27:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PBO9Hk106851;
        Tue, 25 Jun 2019 11:27:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2018-07-02; bh=9x9Tf+76t23B/OqWz0QJ+rympZhvstONi1BsrTWIikw=;
 b=wxk22rOqCouRwd5zGy+2BXDxy6kKxYbrv7KekmYxM+D1XBFaBEZmTSlfJ/9BZmCYNqGf
 y/IKtOUyigQ6BD0/k56WpenmrvVmpUZwL9oVuSd/UwIujumJ/5XFB5fnSwMshxk/XZla
 HjveeYxlLDJmSkeV2UQcL8ywwidqw965wsxZIFrrauyNlO/tWgG8FTI09mszFSGWCqMN
 fbVE70i68CE2lvmAL/ZncPIPYNvaSPzG9EldLMwT3WmijIy9pg+0Ld3vPQ/jBWu9eWww
 zsGP+Rmw/GrYglEqCXw4oS0S2P+7RZw60bepUNXN+rlfileB/UNP3xJjUjckJJEIbBnt qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t9c9pkqt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 11:27:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5PBQ0eG067489;
        Tue, 25 Jun 2019 11:27:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t99f3tnfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jun 2019 11:27:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5PBQxEI010397;
        Tue, 25 Jun 2019 11:27:00 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 04:26:59 -0700
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH] KVM: nVMX: Allow restore nested-state to enable eVMCS when vCPU in SMM
Date:   Tue, 25 Jun 2019 14:26:42 +0300
Message-Id: <20190625112642.113460-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=459
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=504 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As comment in code specifies, SMM temporarily disables VMX so we cannot
be in guest mode, nor can VMLAUNCH/VMRESUME be pending.

However, code currently assumes that these are the only flags that can be
set on kvm_state->flags. This is not true as KVM_STATE_NESTED_EVMCS
can also be set on this field to signal that eVMCS should be enabled.

Therefore, fix code to check for guest-mode and pending VMLAUNCH/VMRESUME
explicitly.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5c470db311f7..27ff04874f67 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5373,7 +5373,10 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	 * nor can VMLAUNCH/VMRESUME be pending.  Outside SMM, SMM flags
 	 * must be zero.
 	 */
-	if (is_smm(vcpu) ? kvm_state->flags : kvm_state->hdr.vmx.smm.flags)
+	if (is_smm(vcpu) ?
+		(kvm_state->flags &
+		 (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PENDING))
+		: kvm_state->hdr.vmx.smm.flags)
 		return -EINVAL;
 
 	if ((kvm_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_GUEST_MODE) &&
-- 
2.20.1

