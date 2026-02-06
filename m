Return-Path: <kvm+bounces-70517-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +Jy1MkVrhmnwMwQAu9opvQ
	(envelope-from <kvm+bounces-70517-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:29:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C63103CC2
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 23:29:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 184CB3057318
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 22:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50BC313E18;
	Fri,  6 Feb 2026 22:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T64y+4nS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC65F311959
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 22:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770416925; cv=none; b=mI77bHP7osFrJ2uui6gmlrNjfAnHeHW8jLmECG8Vu47nFrowY03UV50Sfumw966wYRA4cuCXoxjr76HTeA7Fk9tVIZgtPrkMcKe27ZBhU5l2c6ul2RKsbfVVIhbXH95LcwcgWZcIw5+D5MD6fmc+wcXmsY6nnz8aBxmjEMXBISc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770416925; c=relaxed/simple;
	bh=RD3ghT3BYR07kk+VT4kAGdDg0rE+/olup8G6vjo9ymA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L65FVHaoFDBofnZz4eHMgquRWanpFrLRdYcCo/sl2+p/l4F8EYkL7rtgfuKAIUFAnwJcMw7chNHHN7Mrx3uznTrcc30VPrcbaidUzlyT74KemUc6K1LLzlLYtUZSVAoRQH0fK8KhSzUDTPwI+N2Rr4tbF4d9DsuXucpm2xWectY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T64y+4nS; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-45e76684274so7938469b6e.3
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 14:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770416924; x=1771021724; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pUeR5gi86sqwVMcWfnpHhKWd8lA2xF2m2Gxy4doTFyc=;
        b=T64y+4nS7LzF4K0YhObHwNT9RI/kt304C4ts67ztuhy1yznLd6LMpkHXg4mjTTcJus
         A8CPy43MTpRgY1nJHFod9T52lBlr286v/nqOk5T9f0VsYtXK9ZS5dnctBg7gyoxTyFC8
         rsQWxsSHZY7EaUpHywl9A3Q4FGKjYYLD194Chuk6xslPA+zCXj9mBJlhHJa+n8f8Gxzy
         8Uum0P+SUMT4O3BFoZb6mb+xQq7tmeWxsB5UyBtqlksAMPQzU0UfJRB6Lf8bj93EhFOs
         rvYTCrdZZ6fAdwOMwWxenB4grTj4R5qyVVUDJ0ZeOqGPPQJQIkho/hs7tBYhyPeMEQhU
         HxhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770416924; x=1771021724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pUeR5gi86sqwVMcWfnpHhKWd8lA2xF2m2Gxy4doTFyc=;
        b=dJOY9UtF+o5yvr/YWOCll+SXVANlM2EsAAk/DGKyWJgZ9Nnb9CqbQ/aOU1rlxTyyZF
         m1OlVGLxpj8xpeqWWoNcPlOcrjEAgEZx04V0+zLDlBYgKA7TdxMtJP4rqsccpFXBzppY
         TUrwuRulTGPS23m3hzi28X9WMLBzRm/SegDUgh1A5r3tSj93n/JcaJ2y/0XlPunllEt3
         rzbk9l0HC2qZWQ8V+IXcNt0wi/1/80Sc4sy6KxXAK/o5zF7WSAst/t7xIjSsQAIIOF3J
         6TTSkIoG7aDnYyObHs2RZxXrIgMSvd6M7sYm7v/xgJvU3QtEkCZdY7X9NWhSC8+HxtXP
         xwuQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7pxpwOIBQYsSZgucDL6uXTtWltwjlWJv83P79RTa5H17vWw2dueYqaryU1R3yjOI4mtA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1rSiOzU5G0YpbZyi6SONyeGqvIX+4NMI0XT5VxroUMKLyCrox
	ZPJGnZDWDjPonSfGywttMCVTG4WNDIyMckBc0hFPMmqIuh/0xWgUFm+qIOLGQ+TOLXVlCoqjHu2
	mQA==
X-Received: from iobif47.prod.google.com ([2002:a05:6602:1e2f:b0:957:66a7:af96])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:81ca:b0:663:46f:603f
 with SMTP id 006d021491bc7-66d0a4782bemr1878081eaf.22.1770416923905; Fri, 06
 Feb 2026 14:28:43 -0800 (PST)
Date: Fri,  6 Feb 2026 22:28:28 +0000
In-Reply-To: <20260206222829.3758171-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260206222829.3758171-1-sagis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260206222829.3758171-2-sagis@google.com>
Subject: [PATCH v3 1/2] KVM: TDX: Allow userspace to return errors to guest
 for MAPGPA
From: Sagi Shahar <sagis@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Vishal Annapurve <vannapurve@google.com>, Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70517-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sagis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 83C63103CC2
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

Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 Documentation/virt/kvm/api.rst |  3 +++
 arch/x86/kvm/vmx/tdx.c         | 15 +++++++++++++--
 arch/x86/kvm/x86.h             |  6 ++++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..9978cd9d897e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8679,6 +8679,9 @@ block sizes is exposed in KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES as a
 
 This capability, if enabled, will cause KVM to exit to userspace
 with KVM_EXIT_HYPERCALL exit reason to process some hypercalls.
+Userspace may fail the hypercall by setting hypercall.ret to EINVAL
+or may request the hypercall to be retried the next time the guest run
+by setting hypercall.ret to EAGAIN.
 
 Calling KVM_CHECK_EXTENSION for this capability will return a bitmask
 of hypercalls that can be configured to exit to userspace.
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb..056a44b9d78b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1186,10 +1186,21 @@ static void __tdx_map_gpa(struct vcpu_tdx *tdx);
 
 static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
 {
+	u64 hypercall_ret = READ_ONCE(vcpu->run->hypercall.ret);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
-	if (vcpu->run->hypercall.ret) {
-		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+	if (hypercall_ret) {
+		if (hypercall_ret == EAGAIN) {
+			tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
+		} else if (vcpu->run->hypercall.ret == EINVAL) {
+			tdvmcall_set_return_code(
+				vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+		} else {
+			WARN_ON_ONCE(
+				kvm_is_valid_map_gpa_range_ret(hypercall_ret));
+			return -EINVAL;
+		}
+
 		tdx->vp_enter_args.r11 = tdx->map_gpa_next;
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fdab0ad49098..3d464d12423a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -706,6 +706,12 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
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
2.53.0.rc2.204.g2597b5adb4-goog


