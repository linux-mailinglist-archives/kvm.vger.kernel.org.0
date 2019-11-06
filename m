Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 707C6F1CFF
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 18:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732249AbfKFR5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 12:57:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45030 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbfKFR5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 12:57:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6HsKcq003208;
        Wed, 6 Nov 2019 17:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MdbVWmDz8xkvlQ078mvBd8bDaGm/LTI2iHt8U7Q0AT0=;
 b=IkEA0Vxf9r2AB6/pbXp0iZ+ah6dQ9X4x/J11RYbAPKt/64+mZur6Dfye99u+b6VZLUTs
 jtluOOQRHlvgqgiCy/epmfAu/iNjvw4Uj7K4jNovK8QtnIFlKJRDjnvjEY7KI1XdYIam
 XRN659HAZJkBZD5vfSZDm17HRRymQo8tkL36Sf2O1jAy3BvP87mlEotAvdrZNGRJvviS
 sLLPZIZwOBwFAqZZPEQIQtetlM7vUKGwgPpxL3Q6aGGVtUlY+Eo0rFlxU+w/faxYlNDe
 ziWODqW2IoKfLJB9THUyrYSG0GMpHzPxKTMQAL6EF1o1pJtIKma8C6Aih0UdfaD4iFj3 fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w41w0rkrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 17:56:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6Hre4C022398;
        Wed, 6 Nov 2019 17:56:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wcvfav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 17:56:33 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA6HuXYZ032009;
        Wed, 6 Nov 2019 17:56:33 GMT
Received: from paddy.uk.oracle.com (/10.175.178.239)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 09:56:32 -0800
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
Subject: [PATCH v1 3/3] KVM: VMX: Introduce pi_is_pir_empty() helper
Date:   Wed,  6 Nov 2019 17:56:02 +0000
Message-Id: <20191106175602.4515-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191106175602.4515-1-joao.m.martins@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=634
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911060173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=712 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911060174
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Streamline the PID.PIR check and change its call sites to use
the newly added helper.

Suggested-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 ++---
 arch/x86/kvm/vmx/vmx.h | 5 +++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75d903455e1c..8e8dbb174d14 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1311,7 +1311,7 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	smp_mb__after_atomic();
 
-	if (!bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS))
+	if (!pi_is_pir_empty(pi_desc))
 		pi_set_on(pi_desc);
 }
 
@@ -6157,8 +6157,7 @@ static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	return pi_test_on(pi_desc) ||
-		!bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
+	return pi_test_on(pi_desc) || !pi_is_pir_empty(pi_desc);
 }
 
 static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1e32ab54fc2d..5a0f34b1e226 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -355,6 +355,11 @@ static inline int pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
 	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
 }
 
+static inline bool pi_is_pir_empty(struct pi_desc *pi_desc)
+{
+	return bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
+}
+
 static inline void pi_set_sn(struct pi_desc *pi_desc)
 {
 	set_bit(POSTED_INTR_SN,
-- 
2.11.0

