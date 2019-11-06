Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADCCF1D0E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 19:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbfKFSAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 13:00:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38278 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732176AbfKFSAK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 13:00:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6HsOlM184712;
        Wed, 6 Nov 2019 17:58:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=BWj5wteifYX6HnPR/tFjqG4VivjyAPJWMRU45ipFAE0=;
 b=EnvL+1BBy2GqhrtxpLJyTvmqK8sGYPQIM9ePxq8qxdSq9ZSnFr8ql1L0WCVDcL1ebG+n
 vkbdllI9vQYz56YirT8HXYy/xXw7nsJxcgjOFjDc0C7ALJQYSUrFDfkMh7yuJPPVV38H
 4CXA5nid2LL5zrmZhjgT7GYP8zYZ3VTgqQX5NBGSgzLshYNpczRCVLaqrHxmeVBvPlp/
 Dsfo434ULF/zg/ln1QhzqKsdp70m1eYgkrvIqm/E+gTZFGK1xHU0nan3Ull2Zb0Kqq23
 5Egc6tVFCqotX/v32fIYSzDr+NAAheIunvQlBRQbffpA7spQq1R3L7+2mDuW4jUuR3tc 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w41w0rmba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 17:58:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6HrmXl143146;
        Wed, 6 Nov 2019 17:56:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w41wds1by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 17:56:28 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA6HuRZF003895;
        Wed, 6 Nov 2019 17:56:27 GMT
Received: from paddy.uk.oracle.com (/10.175.178.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 09:56:26 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
Subject: [PATCH v1 1/3] KVM: VMX: Consider PID.PIR to determine if vCPU has pending interrupts
Date:   Wed,  6 Nov 2019 17:56:00 +0000
Message-Id: <20191106175602.4515-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191106175602.4515-1-joao.m.martins@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=881
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=959 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060174
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
introduced vmx_dy_apicv_has_pending_interrupt() in order to determine
if a vCPU have a pending posted interrupt. This routine is used by
kvm_vcpu_on_spin() when searching for a a new runnable vCPU to schedule
on pCPU instead of a vCPU doing busy loop.

vmx_dy_apicv_has_pending_interrupt() determines if a
vCPU has a pending posted interrupt solely based on PID.ON. However,
when a vCPU is preempted, vmx_vcpu_pi_put() sets PID.SN which cause
raised posted interrupts to only set bit in PID.PIR without setting
PID.ON (and without sending notification vector), as depicted in VT-d
manual section 5.2.3 "Interrupt-Posting Hardware Operation".

Therefore, checking PID.ON is insufficient to determine if a vCPU has
pending posted interrupts and instead we should also check if there is
some bit set on PID.PIR.

Fixes: 17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 31ce6bc2c371..18b0bee662a5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6141,7 +6141,10 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 
 static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_test_on(vcpu_to_pi_desc(vcpu));
+	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+
+	return pi_test_on(pi_desc) ||
+		!bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
 }
 
 static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
-- 
2.11.0

