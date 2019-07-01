Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7473BB10
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 19:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388335AbfFJRfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 13:35:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43694 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387779AbfFJRft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 13:35:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AHSX71079843;
        Mon, 10 Jun 2019 17:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=vjpIkG4pJcSKkmi2v8G9rQvnvqiK3JvWrDwev2wP/CY=;
 b=DVguHHhwrSMLxqZGD1q8rgE702LTb9ImtrdMPncKJPQx8dRPyPwoXqwY3UDPEdge/J8V
 F0o2VcBs6KS1XXKo/XbtCYJ5M+pbmMslBeO4HB9p8u6ZutYKd/9bOLrsNVQu/jKKOoIX
 fotagtOYlzeLKASvULuKHN6Dx6xNPHkvIIrre7+D7g7veIBl/xa80wz39onIjlgJpWXN
 KAmIKS6M7hcDH4sTxaKQIjyq220pYfppUBQIbk1StxUbqDzd0xMY3YB2b4gFDrX9I/K+
 GQYri3sJpnOhVcuhyuykHxd+7wUySnv+ZYrWdqvR7PmimNVRu7FyY+g/ZO6vzzVXVFX4 Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2t02hegfta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 17:34:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5AHWqS0117029;
        Mon, 10 Jun 2019 17:34:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2t04hxwc0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 17:34:44 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5AHYcrW028023;
        Mon, 10 Jun 2019 17:34:38 GMT
Received: from ban25x6uut148.us.oracle.com (/10.153.73.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Jun 2019 10:34:38 -0700
From:   Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, alejandro.j.jimenez@oracle.com
Subject: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even if host does not
Date:   Mon, 10 Jun 2019 13:20:10 -0400
Message-Id: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=626
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906100119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=669 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906100119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bits set in x86_spec_ctrl_mask are used to calculate the
guest's value of SPEC_CTRL that is written to the MSR before
VMENTRY, and control which mitigations the guest can enable.
In the case of SSBD, unless the host has enabled SSBD always
on mode (by passing "spec_store_bypass_disable=on" in the
kernel parameters), the SSBD bit is not set in the mask and
the guest can not properly enable the SSBD always on
mitigation mode.

This is confirmed by running the SSBD PoC on a guest using
the SSBD always on mitigation mode (booted with kernel
parameter "spec_store_bypass_disable=on"), and verifying
that the guest is vulnerable unless the host is also using
SSBD always on mode. In addition, the guest OS incorrectly
reports the SSB vulnerability as mitigated.

Always set the SSBD bit in x86_spec_ctrl_mask when the host
CPU supports it, allowing the guest to use SSBD whether or
not the host has chosen to enable the mitigation in any of
its modes.

Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/cpu/bugs.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 03b4cc0..66ca906 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -836,6 +836,16 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 	}
 
 	/*
+	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
+	 * bit in the mask to allow guests to use the mitigation even in the
+	 * case where the host does not enable it.
+	 */
+	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
+		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
+	}
+
+	/*
 	 * We have three CPU feature flags that are in play here:
 	 *  - X86_BUG_SPEC_STORE_BYPASS - CPU is susceptible.
 	 *  - X86_FEATURE_SSBD - CPU is able to turn off speculative store bypass
@@ -852,7 +862,6 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
 			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 		}
 	}
-- 
1.8.3.1

