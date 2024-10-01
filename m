Return-Path: <kvm+bounces-27726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44BF098B35E
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76A911C2310E
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551CC1BE865;
	Tue,  1 Oct 2024 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="f1VGdrSp"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D0E1BBBC5;
	Tue,  1 Oct 2024 05:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758939; cv=none; b=Ed2SGh3byOxSwgnZQRNWgQm+kqHzQWTCuD0LVKEdh/Oty9GlrSyBpFh4FXqjpB+oy5UoBPINDiiHeHLuT+IBmP7Qx8gwPAAcRrErT59mgcsUBbCm2AJpdq8vDtiR9kAarz+q/xLtMFUNPqi6JP37wQjYIVoAZePvGVLW8rji3q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758939; c=relaxed/simple;
	bh=1HHdCROku9KHCkOxCVa1BFpb20qNw59Ovg2AGy/Du+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9TAar1Jatz1kkhBzzTXdQENo1AHaX75Xw4z6HpAAiPBL2+Jqa2WcZArFPVVIHqBZ0y0EgddJwdGnuNQHLIWlEzfKi2VxGy+jCeidAYVhywQWDEzICK4qkgsgrnp2MRi5sEmRviY9h46hHzdIz3R2zaxTTevhERJdS2Xa4+eVzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=f1VGdrSp; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7Y3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7Y3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758885;
	bh=Fcrp8N3TnQ5gyW//6qj6v/cEutthr7kh/dHXKU3Du2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f1VGdrSpiCBltxKZzChcSXZe8GeIPuQ0zCA3HfrrxzLcAQIBemWBvmYa4b1IILykZ
	 +UFSmA+UAkXevkPqFoSovwq9jVRQ1eVuNj1dZ0cLiUQMpRckfdfAAZOdPaiIHIVZYp
	 mbKbuSgcFtfUKxyN6czyokwNTIjInoVdOW1rgOgEhh9R+/6W9+aSQlf/BtVFe+6OWk
	 avX+T+betHL69ibYAsmbTL4mopnrMN7Kx+q1t1NRzVknTFJdkHdxfteJnAKeXsP0QX
	 GGGYiLqEsOOqdZKIfpZsHpQGcwJ4WH/M2ytx4lEsRJOzffZG48ShOXUSCdngiUh2E/
	 PEKnQxhz6IPXQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 09/27] KVM: VMX: Do not use MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
Date: Mon, 30 Sep 2024 22:00:52 -0700
Message-ID: <20241001050110.3643764-10-xin@zytor.com>
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

No need to use MAX_POSSIBLE_PASSTHROUGH_MSRS in the definition of array
vmx_possible_passthrough_msrs, as the macro name indicates the _possible_
maximum size of passthrough MSRs.

Use ARRAY_SIZE instead of MAX_POSSIBLE_PASSTHROUGH_MSRS when the size of
the array is needed and add a BUILD_BUG_ON to make sure the actual array
size does not exceed the possible maximum size of passthrough MSRs.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++++---
 arch/x86/kvm/vmx/vmx.h | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9acc9661fdb2..28cf89c97bda 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -167,7 +167,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
  * List of MSRs that can be directly passed to the guest.
  * In addition to these x2apic, PT and LBR MSRs are handled specially.
  */
-static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
+static u32 vmx_possible_passthrough_msrs[] = {
 	MSR_IA32_SPEC_CTRL,
 	MSR_IA32_PRED_CMD,
 	MSR_IA32_FLUSH_CMD,
@@ -4182,6 +4182,8 @@ void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
+	BUILD_BUG_ON(ARRAY_SIZE(vmx_possible_passthrough_msrs) > MAX_POSSIBLE_PASSTHROUGH_MSRS);
+
 	/*
 	 * Redo intercept permissions for MSRs that KVM is passing through to
 	 * the guest.  Disabling interception will check the new MSR filter and
@@ -7626,8 +7628,8 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	}
 
 	/* The MSR bitmap starts with all ones */
-	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
+	bitmap_fill(vmx->shadow_msr_intercept.read, ARRAY_SIZE(vmx_possible_passthrough_msrs));
+	bitmap_fill(vmx->shadow_msr_intercept.write, ARRAY_SIZE(vmx_possible_passthrough_msrs));
 
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e0d76d2460ef..e7409f8f28b1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -356,7 +356,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	64
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-- 
2.46.2


