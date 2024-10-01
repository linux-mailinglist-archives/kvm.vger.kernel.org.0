Return-Path: <kvm+bounces-27740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 090BC98B36D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A18CD1F247A0
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525111BFDFC;
	Tue,  1 Oct 2024 05:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="XauhJKax"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E1F1BC094;
	Tue,  1 Oct 2024 05:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758940; cv=none; b=DgHWY6uQfu1Q5YIW7Aq2eRaIiTcEeTtSzcM2kEm22/xLpSXYsodSLQTlCjqlq/bKeDgcjdjWudkQ41MNkFbVlGAp5OU5qNoMNbfMIPgX8WjZEr2YJWvAXJs866uVdw+jvXbCx56aN+38mcx26KzklbXaTlcCGhCdw+Miu+vshTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758940; c=relaxed/simple;
	bh=vBh0fJFgPmYid6l2yKk2mdBw8NaT541Y5D4O8YV15qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNSfGxodeR2IGl/Q1uECatGHM5O1KojXg4yuaR2Bup0JaVlK9tPOFNgV3iMf7Too4uXFXPRCQQ8I2d8N9EI/aPemgWnNa5ywrSqMLz+GJSWb8P8cet9txn0n0taQfmctptL9zs9/Axxs6S3TRZHAxniaj76igzUpBXW7SNn63q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=XauhJKax; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7R3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:17 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7R3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758878;
	bh=U978N1Id9kULENCyRAQtZo8eJ1d3JeFHDWBAjDeix6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XauhJKaxr3tacRyngr9pVxuFekbUqCFPl9hAY+QYR/SfLe5KDtpdDg2vZ64WRNecA
	 ecUJPqWznxGkyyxFTysVkYKZLB3ZR7I0jHsLzaZeqQg9EB6Cxk654fFMjRajI7VX2H
	 hmt31gE4WRVXVWnJXKP7YPoIiSfA27gdyczepAMVo7O7l0eRGhHkR8t4ZfHlhzI7HL
	 TMRHE+yCJPOhgrqneKIwEC1tl1ciDJHz78nQ3moi38W0Xtvg6ahcJK3/4XEH0mh4kU
	 O52kjBf/Le28+EXB12tHP+NxOXBAi3Nl8NyqPWSxWZ/TtE4e5FkJtaEylwotYqQLjH
	 Ql2vMRzYZYMsw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 02/27] KVM: VMX: Don't modify guest XFD_ERR if CR0.TS=1
Date: Mon, 30 Sep 2024 22:00:45 -0700
Message-ID: <20241001050110.3643764-3-xin@zytor.com>
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

Don't update the guest's XFD_ERR MSR if CR0.TS is set; per the SDM,
XFD_ERR is not modified if CR0.TS=1.  Although it's not explicitly stated
in the SDM, conceptually it makes sense the CR0.TS check would be done
prior to the XFD_ERR check, e.g. CR0.TS=1 blocks all SIMD state, whereas
XFD blocks only XTILE state.

  Device-not-available exceptions that are not due to XFD - those
  resulting from setting CR0.TS to 1 - do not modify the IA32_XFD_ERR MSR.

Opportunistically update the comment to call out that XFD_ERR is updated
before the VM-Exit check occurs.  Nothing in the SDM explicitly calls out
this behavior, but logically it must be the behavior, otherwise reading
XFD_ERR in handle_nm_fault_irqoff() would return stale data, i.e. the
to-be-delivered XFD_ERR value would need to be saved in EXIT_QUALIFICATION,
a la DR6 for #DB and CR2 for #PF, so that software could capture the guest
value.

Fixes: ec5be88ab29f ("kvm: x86: Intercept #NM for saving IA32_XFD_ERR")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6a93f5edbc0d..3f6257d88ded 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6976,16 +6976,16 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 	 * MSR value is not clobbered by the host activity before the guest
 	 * has chance to consume it.
 	 *
-	 * Do not blindly read xfd_err here, since this exception might
-	 * be caused by L1 interception on a platform which doesn't
-	 * support xfd at all.
+	 * Update the guest's XFD_ERR if and only if XFD is enabled, as the #NM
+	 * interception may have been caused by L1 interception.  Per the SDM,
+	 * XFD_ERR is not modified if CR0.TS=1.
 	 *
-	 * Do it conditionally upon guest_fpu::xfd. xfd_err matters
-	 * only when xfd contains a non-zero value.
-	 *
-	 * Queuing exception is done in vmx_handle_exit. See comment there.
+	 * Note, XFD_ERR is updated _before_ the #NM interception check, i.e.
+	 * unlike CR2 and DR6, the value is not a payload that is attached to
+	 * the #NM exception.
 	 */
-	if (vcpu->arch.guest_fpu.fpstate->xfd)
+	if (vcpu->arch.guest_fpu.fpstate->xfd &&
+	    !kvm_is_cr0_bit_set(vcpu, X86_CR0_TS))
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }
 
-- 
2.46.2


