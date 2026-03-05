Return-Path: <kvm+bounces-72958-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IP8yEtEDqmliJgEAu9opvQ
	(envelope-from <kvm+bounces-72958-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:29:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 982E8218E95
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 457DC30D3EBB
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 22:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25B9364054;
	Thu,  5 Mar 2026 22:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PF2MmO8E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F5F3644C5
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 22:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772749622; cv=none; b=BqGZ28LheM2KqoX8UmfUdtSKXjohFLwp4gxvxQPKBSfj00TpoYoLENC58GFtGFUwPRnruE7ptdb8NHlOR6fl3yJGKFQ4/d9+5cYRfaGc8Ynw2/pygg9bHRb3GJAkPOBy26MZDSgFJcJqbJ5qRp8H8VwVeq53ysLUxDiRtjbpU34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772749622; c=relaxed/simple;
	bh=xP/iS5QVF94jNMbdVYFiaGjI87jTGDeHWpLO9YL7fTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SWC9AbbcYvd8eRU3v2uDjwgLBwoZqOIwyh72AdOEsH+FxcQJOc9J9g6iQAzKAFJV+LKyP66bbbUAP5hAoIS4w6/6e0kCrehw+PEyWwmbWkbFWXUi2/E6ErL4KxIjmThfcfJxKneJ+Fdudos5kE9q02ZAp4cmXDDs/wT7gH62/44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PF2MmO8E; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-463a075e177so41949362b6e.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 14:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772749619; x=1773354419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R69U7cvCJ2oN4Tlbx4DilCOHnfyWmS9IA2pb8ys74rU=;
        b=PF2MmO8EyyrYFDzetqVAHWO8kYu3fXPCNZwpPQynokQ44hIpm4wjGj7/hSSVzIox6v
         Yte0Dn/E/ap/jGXytiermegr8VuypSpDmyC8qi5UP2ExiQTcoK2NiShcDvuobGYS+4DI
         ky1dxezZKkn1rwy31yAHdn/YUjF52blOVl0V33zLhD3ZoZBRaBNx4G6hr6kW150y0x2+
         GZre4EuETSnO75MWtaPcOXtpgMZn5d9A/AgQFi4rb+RGrjgXDXbcI5ivEdn/2/4ZEd7C
         U/tpuY3T9YrsWQqLHq3GO5R+zCM5fVWuraYga3jR5z4wLxCjNozRFw654f312GZK1PKJ
         VUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772749619; x=1773354419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R69U7cvCJ2oN4Tlbx4DilCOHnfyWmS9IA2pb8ys74rU=;
        b=au5kIzKbONVfEQFIH69I7gL5YBynJzzczyOPtcYNLSQtIrbM9HceVkKkQA9q1YAMHA
         Ib/yRrtf+9ljYTgGbHPTU8uiBi9a/rTaUEJYD62NZu7tQJdo9dMhhA8Mbm47oA1rUJs3
         x+TzqYY9MFpZmj0q8tpKEIM1ug5BOBTc0Vqn2BwznVCDyGk7YDaUkGCcj551vQBGr/bE
         J9s30feUFVCIj9HZJkQwQHhpXHmquWD/rK0Ur7nDFanzTySv1oxbMyA2RhQnJjPKbm3a
         zp6anSIjX4y7R0UNddfid42suHyWBqCCueTaI0cyvjxEnK5exem1ax0E14LJPC46W4Jw
         59MA==
X-Forwarded-Encrypted: i=1; AJvYcCWD2fo26NyVQpDgIdCI5prkxRiWQOMcC8jQtGIz/f6ZQNvIzeFL9hoUlZN1ldcoF3Wt1c0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxmiwSKUHkTGZb7OJrW6M6SjYV0LC5fyYp74EVxSNvCsjN76fT
	PTpKY3FlJFmCGk2ilNj2DHogmOM7NTRtI3WZCPyH/70DudT5LwD2UPh10893TwpqpSvc6Lds4YM
	WYw==
X-Received: from jaqg20.prod.google.com ([2002:a02:cd14:0:b0:5ca:4040:79b5])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:618:b0:679:dd38:9946
 with SMTP id 006d021491bc7-67b9bd1afe0mr76930eaf.47.1772749619233; Thu, 05
 Mar 2026 14:26:59 -0800 (PST)
Date: Thu,  5 Mar 2026 22:26:26 +0000
In-Reply-To: <20260305222627.4193305-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260305222627.4193305-1-sagis@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260305222627.4193305-2-sagis@google.com>
Subject: [PATCH v4 1/2] KVM: TDX: Allow userspace to return errors to guest
 for MAPGPA
From: Sagi Shahar <sagis@google.com>
To: Vishal Annapurve <vannapurve@google.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 982E8218E95
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72958-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sagis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

From: Vishal Annapurve <vannapurve@google.com>

MAPGPA request from TDX VMs gets split into chunks by KVM using a loop
of userspace exits until the complete range is handled.

In some cases userspace VMM might decide to break the MAPGPA operation
and continue it later. For example: in the case of intrahost migration
userspace might decide to continue the MAPGPA operation after the
migration is completed.

Allow userspace to signal to TDX guests that the MAPGPA operation should
be retried the next time the guest is scheduled.

This is potentially a breaking change since if userspace sets
hypercall.ret to a value other than EBUSY or EINVAL an EINVAL error code
will be returned to userspace. As of now QEMU never sets hypercall.ret
to a non-zero value after handling KVM_EXIT_HYPERCALL so this change
should be safe.

Reviewed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 Documentation/virt/kvm/api.rst |  3 +++
 arch/x86/kvm/vmx/tdx.c         | 28 +++++++++++++++++++++-------
 arch/x86/kvm/x86.h             |  6 ++++++
 3 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6f85e1b321dd..027f7fadd757 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8808,6 +8808,9 @@ block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a
 
 This capability, if enabled, will cause KVM to exit to userspace
 with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
+Userspace may fail the hypercall by setting hypercall.ret to EINVAL
+or may request the hypercall to be retried the next time the guest run
+by setting hypercall.ret to EAGAIN.
 
 Calling KVM_CHECK_EXTENSION for this capability will return a bitmask
 of hypercalls that can be configured to exit to userspace.
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c5065f84b78b..f47d5e34f3fc 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1186,12 +1186,22 @@ static void __tdx_map_gpa(struct vcpu_tdx *tdx);
 
 static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
 {
+	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	long rc;
 
-	if (vcpu->run->hypercall.ret) {
-		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
-		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
-		return 1;
+	switch (hypercall_ret) {
+	case 0:
+		break;
+	case EAGAIN:
+		rc = TDVMCALL_STATUS_RETRY;
+		goto propagate_error;
+	case EINVAL:
+		rc = TDVMCALL_STATUS_INVALID_OPERAND;
+		goto propagate_error;
+	default:
+		WARN_ON_ONCE(kvm_is_valid_map_gpa_range_ret(hypercall_ret));
+		return -EINVAL;
 	}
 
 	tdx->map_gpa_next += TDX_MAP_GPA_MAX_LEN;
@@ -1204,13 +1214,17 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
 	 * TDVMCALL_MAP_GPA, see comments in tdx_protected_apic_has_interrupt().
 	 */
 	if (kvm_vcpu_has_events(vcpu)) {
-		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
-		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
-		return 1;
+		rc = TDVMCALL_STATUS_RETRY;
+		goto propagate_error;
 	}
 
 	__tdx_map_gpa(tdx);
 	return 0;
+
+propagate_error:
+	tdvmcall_set_return_code(vcpu, rc);
+	tdx->vp_enter_args.r11 = tdx->map_gpa_next;
+	return 1;
 }
 
 static void __tdx_map_gpa(struct vcpu_tdx *tdx)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 94d4f07aaaa0..9dc6da955c2a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -720,6 +720,12 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+static inline bool kvm_is_valid_map_gpa_range_ret(u64 hypercall_ret)
+{
+	return !hypercall_ret || hypercall_ret == EINVAL ||
+	       hypercall_ret == EAGAIN;
+}
+
 static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
 {
 	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
-- 
2.53.0.473.g4a7958ca14-goog


