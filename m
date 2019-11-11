Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 119D8F704F
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 10:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKKJRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 04:17:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49932 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbfKKJRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 04:17:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB9EXcY067037;
        Mon, 11 Nov 2019 09:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=OejNard4656m7Kq8hOZzKL53qg3IHHmaWK+cnY5oQwY=;
 b=GqOz5Agtu6But1fsjY+757GZDyuA7VBDHbkyz+4oMV6cdm/RJsEHAvDGhqMG75pLoVF9
 p6goIczGTNnfE6Iu/JzjtwhZCZrwq6IdeiNGpUH+goLUUGMViaAYe1jf013LKsP1otKG
 XkcrmaQghjypPXgoB6CeR7kc+b+2u/q452ji39IG2C+wdAwx6oSi3EChq1HBlr4fNDpz
 vQ6cP00sYSoMliIeBpv773Q/5X7apiaD3katJMKa8RljHrRxNRvDpMZ35y5uxBR/BZy5
 oEzwOG+QPoz/PHDgBkR86gLjVXCBj/G2zwcgHs3EF/Jl14sMFqJqySemomZ6fYWb8zuX Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w5mvtdte5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 09:17:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB9DwQH025712;
        Mon, 11 Nov 2019 09:17:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w6r8j21f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 09:17:10 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAB9H91M013722;
        Mon, 11 Nov 2019 09:17:09 GMT
Received: from localhost.localdomain (/77.139.185.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 01:17:09 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>
Subject: [PATCH 2/2] KVM: x86: Prevent set vCPU into INIT/SIPI_RECEIVED state when INIT are latched
Date:   Mon, 11 Nov 2019 11:16:40 +0200
Message-Id: <20191111091640.92660-3-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191111091640.92660-1-liran.alon@oracle.com>
References: <20191111091640.92660-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=666
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=717 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
fixed KVM to also latch pending LAPIC INIT event when vCPU is in VMX
operation.

However, current API of KVM_SET_MP_STATE allows userspace to put vCPU
into KVM_MP_STATE_SIPI_RECEIVED or KVM_MP_STATE_INIT_RECEIVED even when
vCPU is in VMX operation.

Fix this by introducing a util method to check if vCPU state latch INIT
signals and use it in KVM_SET_MP_STATE handler.

Fixes: 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/lapic.c | 5 ++---
 arch/x86/kvm/x86.c   | 4 ++--
 arch/x86/kvm/x86.h   | 5 +++++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b29d00b661ff..0df265248cae 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2702,14 +2702,13 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 		return;
 
 	/*
-	 * INITs are latched while CPU is in specific states
-	 * (SMM, VMX non-root mode, SVM with GIF=0).
+	 * INITs are latched while CPU is in specific states.
 	 * Because a CPU cannot be in these states immediately
 	 * after it has processed an INIT signal (and thus in
 	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
 	 * and leave the INIT pending.
 	 */
-	if (is_smm(vcpu) || kvm_x86_ops->apic_init_signal_blocked(vcpu)) {
+	if (kvm_vcpu_latch_init(vcpu)) {
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
 		if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f41d5d05e9f2..eb992f5d299f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8675,8 +8675,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	    mp_state->mp_state != KVM_MP_STATE_RUNNABLE)
 		goto out;
 
-	/* INITs are latched while in SMM */
-	if ((is_smm(vcpu) || vcpu->arch.smi_pending) &&
+	/* INITs are latched while CPU is in specific states */
+	if ((kvm_vcpu_latch_init(vcpu) || vcpu->arch.smi_pending) &&
 	    (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED ||
 	     mp_state->mp_state == KVM_MP_STATE_INIT_RECEIVED))
 		goto out;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index dbf7442a822b..d40da892f889 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -260,6 +260,11 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
 	return !(kvm->arch.disabled_quirks & quirk);
 }
 
+static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
+{
+	return is_smm(vcpu) || kvm_x86_ops->apic_init_signal_blocked(vcpu);
+}
+
 void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
-- 
2.20.1

