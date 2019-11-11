Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4461AF79BC
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 18:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfKKRVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 12:21:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40092 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbfKKRVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 12:21:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABH9AoR033271;
        Mon, 11 Nov 2019 17:20:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=426E+3tZ3P7XAvx0RdbuUGJqDwgjBVmFHPsj3Cn88VA=;
 b=VI7VbmgnGf6rV6T1muUGly0uwijnTrelnAepUJfbfmWVM0Wh/LXLY1CAyd+KHkLStT3h
 vyxU493FkviyTW/pbcDKIaEjdE2pxoMZjf4AgDys1zuEjinhucrP2uw0e3tO8wvJ5z6M
 auYL6NNvwk8hegrw19LzksU8suXJA5fXGVSd7Ot3fc56kNQ6pYDpRfUpIEewvvj96vXG
 B5IAjfDberXUFtzVobK6MMTr/EjyMfKyHhlCNr2oS74FeP3NQrlwtHJqxFA7h2dFJzT0
 oN6JSbgfUH5C8ZLqfLyUY81ek0S3XDHAj4ZU4w6oFSKjs9b60GmcC2RmXj23eod2Si+q fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w5p3qg2ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 17:20:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABHEbKm130490;
        Mon, 11 Nov 2019 17:20:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w6r8jx9wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 17:20:26 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABHKQx7032399;
        Mon, 11 Nov 2019 17:20:26 GMT
Received: from paddy.uk.oracle.com (/10.175.169.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 09:20:26 -0800
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
Subject: [PATCH v2 1/3] KVM: VMX: Consider PID.PIR to determine if vCPU has pending interrupts
Date:   Mon, 11 Nov 2019 17:20:10 +0000
Message-Id: <20191111172012.28356-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111172012.28356-1-joao.m.martins@oracle.com>
References: <20191111172012.28356-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=948
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110155
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
some bit set on PID.PIR if PID.SN=1.

Fixes: 17e433b54393 ("KVM: Fix leak vCPU's VMCS value into other pCPU")
Reviewed-by: Jagannathan Raman <jag.raman@oracle.com>
Co-developed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
v2:
* Fixed broken Sob Chain;
* Add missing tags;
* Only test PID.PIR if PID.SN=1 and reflect that in commit message last
paragraph;
---
 arch/x86/kvm/vmx/vmx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 31ce6bc2c371..4c7d2935f7ec 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6141,7 +6141,11 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 
 static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_test_on(vcpu_to_pi_desc(vcpu));
+	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+
+	return pi_test_on(pi_desc) ||
+		(pi_test_sn(pi_desc) &&
+		!bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS));
 }
 
 static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
-- 
2.11.0

