Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37145F1D0C
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 18:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732445AbfKFR7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 12:59:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33612 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfKFR7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 12:59:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6HsRgI015900;
        Wed, 6 Nov 2019 17:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oZuMeHaMaOYuKrxpCHjtxszEeyvg+X97FPZxAHAp6C4=;
 b=EY6rnttZWedzTFX/wcpCd2oM0+W/5yaQ04qdDT0/rDiJCiDVbD8NU2VdpNAKuWFXoMYm
 L7AFUVK33ETtp5+NcI6b6RANVQB9dbpJaWrGMPnvbFLgtj3w+4fjUOU2L6MhtOI9ZSBL
 ZxIJ/a//DW57FsrKErDiVhwr50GwEF7QeWDPPC0saHT58ROQMAWEXd/A/v3Sp5ELXRaP
 u4jatYyb2c75iQXrTVSqjqoRu5mUqDY5tC7pgFofd3qNszhdmgN+mdmxLuGrhqz6e32L
 w8ysmasiXoAJraOuCKZmfN5hYMQ+GNeDKGGVht7H1wHQs60ko6+8e6fG/6rLBkE1r9A1 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w41w10mp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 17:58:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6HrjYl142999;
        Wed, 6 Nov 2019 17:56:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w41wds1jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 17:56:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6HuUOR015793;
        Wed, 6 Nov 2019 17:56:30 GMT
Received: from paddy.uk.oracle.com (/10.175.178.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 09:56:29 -0800
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
Subject: [PATCH v1 2/3] KVM: VMX: Do not change PID.NDST when loading a blocked vCPU
Date:   Wed,  6 Nov 2019 17:56:01 +0000
Message-Id: <20191106175602.4515-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191106175602.4515-1-joao.m.martins@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060174
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When vCPU enters block phase, pi_pre_block() inserts vCPU to a per pCPU
linked list of all vCPUs that are blocked on this pCPU. Afterwards, it
changes PID.NV to POSTED_INTR_WAKEUP_VECTOR which its handler
(wakeup_handler()) is responsible to kick (unblock) any vCPU on that
linked list that now has pending posted interrupts.

While vCPU is blocked (in kvm_vcpu_block()), it may be preempted which
will cause vmx_vcpu_pi_put() to set PID.SN.  If later the vCPU will be
scheduled to run on a different pCPU, vmx_vcpu_pi_load() will clear
PID.SN but will also *overwrite PID.NDST to this different pCPU*.
Instead of keeping it with original pCPU which vCPU had entered block
phase on.

This results in an issue because when a posted interrupt is delivered,
the wakeup_handler() will be executed and fail to find blocked vCPU on
its per pCPU linked list of all vCPUs that are blocked on this pCPU.
Which is due to the vCPU being placed on a *different* per pCPU
linked list than the original pCPU that it had entered block phase.

The regression is introduced by commit c112b5f50232 ("KVM: x86:
Recompute PID.ON when clearing PID.SN"). Therefore, partially revert
it and reintroduce the condition in vmx_vcpu_pi_load() responsible for
avoiding changing PID.NDST when loading a blocked vCPU.

Fixes: c112b5f50232 ("KVM: x86: Recompute PID.ON when clearing PID.SN")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  6 ++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 18b0bee662a5..75d903455e1c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1274,6 +1274,18 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	if (!pi_test_sn(pi_desc) && vcpu->cpu == cpu)
 		return;
 
+	/*
+	 * If the 'nv' field is POSTED_INTR_WAKEUP_VECTOR, do not change
+	 * PI.NDST: pi_post_block is the one expected to change PID.NDST and the
+	 * wakeup handler expects the vCPU to be on the blocked_vcpu_list that
+	 * matches PI.NDST. Otherwise, a vcpu may not be able to be woken up
+	 * correctly.
+	 */
+	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR || vcpu->cpu == cpu) {
+		pi_clear_sn(pi_desc);
+		goto after_clear_sn;
+	}
+
 	/* The full case.  */
 	do {
 		old.control = new.control = pi_desc->control;
@@ -1289,6 +1301,8 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	} while (cmpxchg64(&pi_desc->control, old.control,
 			   new.control) != old.control);
 
+after_clear_sn:
+
 	/*
 	 * Clear SN before reading the bitmap.  The VT-d firmware
 	 * writes the bitmap and reads SN atomically (5.2.3 in the
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bee16687dc0b..1e32ab54fc2d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -373,6 +373,12 @@ static inline void pi_clear_on(struct pi_desc *pi_desc)
 		(unsigned long *)&pi_desc->control);
 }
 
+static inline void pi_clear_sn(struct pi_desc *pi_desc)
+{
+	clear_bit(POSTED_INTR_SN,
+		(unsigned long *)&pi_desc->control);
+}
+
 static inline int pi_test_on(struct pi_desc *pi_desc)
 {
 	return test_bit(POSTED_INTR_ON,
-- 
2.11.0

