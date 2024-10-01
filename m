Return-Path: <kvm+bounces-27730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5BA98B35F
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F4DE1F2456B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6536E1BE875;
	Tue,  1 Oct 2024 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="oWgBmdBM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7151BBBC0;
	Tue,  1 Oct 2024 05:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758939; cv=none; b=efcs0SW1hTI8QD7An6+ITH3241QxeJB3Avll6gFDZvDu8pzwFr8DoxcyjLR6K08lMCoiURFnFQmXSO9LfyE66GaobP8rxVyoCv3k2XJ5YZptku4buO7iFOIfF2W89Jh9nDKdjcwJbByQBN+EDCyYf5uG3rWh86CZaeh/4VXwkc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758939; c=relaxed/simple;
	bh=FaOy2OKqH01C/5KaZwl3BA3eqU5CpRgqgJfpSRXqSFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzRApy5iyVFW/vyxiIMRpz8EwXyGxkBLwkWCnMEPl2YeAeA/o0668otvQ7adseuBzLbZuSdg0oQ5Vi7b7TP+2MtsYtLHK+C7se6Wd8TBpOq39h/jrLiDNztmhm4GbQrKrwkLEyGY7hEjgnKlCpk+uPWKEu1UTQ/wvVU+94MJzbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=oWgBmdBM; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7d3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:29 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7d3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758890;
	bh=aFNnDSBwVY5YKUBEj/le6GcdKhI3wUL+k7nBIu5vESQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWgBmdBMjl2otaU1XfWCC+8W37HzOFp98bNixS5+a9Eg5MnudDAsElV/ZdksaXSB5
	 s/qyiQuKDdSSTKJZzJEe53Tzl03GHPc19boFabExtOrj/kYQQnDqQK2O+zXl0PDoLm
	 mPuCY9miR5z0zhQ0WhDl6zxdqBdDpzNLsgJGozNpu0QVEVC3QuWd6E88zX4ZfuBFtW
	 IfU4YOYh+E29+d5ECQOkT/T43Nb6S1je2O1eaVP6ik6ZiTE19sBKgx3StAl1m1Q29Q
	 vbUsw4805zTTN2Xj1pmiOO65IDh0wtBDWsy1nHVrC2JwOckfdC0Kt5hPILE4cXfoWn
	 yvNsJWQZs2E9g==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 14/27] KVM: VMX: Pass XFD_ERR as pseudo-payload when injecting #NM
Date: Mon, 30 Sep 2024 22:00:57 -0700
Message-ID: <20241001050110.3643764-15-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Pass XFD_ERR via KVM's exception payload mechanism when injecting an #NM
after interception so that XFD_ERR can be propagated to FRED's event_data
field without needing a dedicated field (which would need to be migrated).

For non-FRED vCPUs, this is a glorified NOP as
kvm_deliver_exception_payload() will simply do nothing (which is desirable
and correct).

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 65ab26b13d24..686006fe6d45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5336,6 +5336,12 @@ bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu)
 	       (kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
 }
 
+static bool is_xfd_nm_fault(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.guest_fpu.fpstate->xfd &&
+	       !kvm_is_cr0_bit_set(vcpu, X86_CR0_TS);
+}
+
 static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -5362,7 +5368,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	 * point.
 	 */
 	if (is_nm_fault(intr_info)) {
-		kvm_queue_exception(vcpu, NM_VECTOR);
+		kvm_queue_exception_p(vcpu, NM_VECTOR,
+				      is_xfd_nm_fault(vcpu) ? vcpu->arch.guest_fpu.xfd_err : 0);
 		return 1;
 	}
 
@@ -7110,14 +7117,13 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 	 *
 	 * Update the guest's XFD_ERR if and only if XFD is enabled, as the #NM
 	 * interception may have been caused by L1 interception.  Per the SDM,
-	 * XFD_ERR is not modified if CR0.TS=1.
+	 * XFD_ERR is not modified for non-XFD #NM, i.e. if CR0.TS=1.
 	 *
 	 * Note, XFD_ERR is updated _before_ the #NM interception check, i.e.
 	 * unlike CR2 and DR6, the value is not a payload that is attached to
 	 * the #NM exception.
 	 */
-	if (vcpu->arch.guest_fpu.fpstate->xfd &&
-	    !kvm_is_cr0_bit_set(vcpu, X86_CR0_TS))
+	if (is_xfd_nm_fault(vcpu))
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }
 
-- 
2.46.2


