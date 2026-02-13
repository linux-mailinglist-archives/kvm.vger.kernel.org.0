Return-Path: <kvm+bounces-71050-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APb/Imk3j2n2MgEAu9opvQ
	(envelope-from <kvm+bounces-71050-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:38:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC881137207
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:38:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 99E2F300A5A3
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 14:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229AF36167E;
	Fri, 13 Feb 2026 14:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNna3Hnf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0100361DD2
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770993503; cv=none; b=oP5K7gHfuXWbbbE3qCPajagMrqtB7fGmSitJ+1et8KBE1aTrjqyWa/PV1hSOJe6HHMMGIpJZ98JBnCNOcDg0wdwTzX2YxBW+L+Fp90b0RhEqZUPKgt73QlphVw6hlb9mrCzbI/Flbhn9H8fkgEmUyZEvUYoXXOBHVf3bxUe4W6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770993503; c=relaxed/simple;
	bh=0oexpWMVPOMBg/tm6NN+hzxx55lhIoUeedDj8t8xquQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X6SLNsqy9FY4cfIn4DKv9c6aJGRgZSpFOI6iTCp77KAtyso9GQ6AzzOFHMf0CZcuvR0dBcxmx71YTo8OhiFjVn3hibtol6sE2sQu56yDqgmleVDMfUk/5kTVsLQM2/AckxGc3RZPQczqK5TDVRQXwhnYJqR07DPIv7uq1kHAn8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dNna3Hnf; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8fc132b0b4so5045466b.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 06:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770993500; x=1771598300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jMJHo973aYDR+UWfROXQvwm6KfmNQpCUXcX+kTjqb1M=;
        b=dNna3HnfUHP5a1oE/uvnsX54ALUN9S7UA5qz7ZxyY2quCQG5qjg0Xe2xE94c9wB4FX
         Y4Ljt1vVEP1Crxy8AYIstboycUMCnPyBODqWxu5AZids0PpJSfNG34VL8bgTGryE9uaw
         Vi5V9kdepSWK4D4O3N2YGEjf953HZWW4m8h7WxriGPLBR5tssCMtve+0oCpbl3+CNPcP
         m3CVpNHip5j75iSmjgS5W3Sm3hOhOD5OZoCIq9wAjXDUm7vGDvU7R8otvySce7Z0531w
         Pi0ij3KbDBLsxp5j4Dyt3WakiYBRLoT//HGqSDfCRlTuW82C+a4w0+TwXi9ZRUh1TDQR
         1PwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770993500; x=1771598300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jMJHo973aYDR+UWfROXQvwm6KfmNQpCUXcX+kTjqb1M=;
        b=i6tBpB9tCNiJYgutymShgfr/OpMi67UujpA1PJQ9ITQuePr1alWN9Rws4uee09XEnT
         e5ECqWOEyTBw/v/BDk3NckCxjB75DTYSFvxTAUEDgDI4O06Bz1GocrdQ/bytJa1vDdZa
         aAoOdfENUpxAf2lPbSjr2hBNsWtwySkyX9n43Gy0Z11+wMlA3Mh02OvWH09IqpkYAlAJ
         1/+p1tceU4P/CNWY8clM9veWxes0NkZhsROQkP76RsSByR4PPo7GkoDAc8kQcxTA7xWM
         t5CM9AZ973Aq7Qo6BdUWipj/Y7sOe58dQSw0YZw465YpBUoTtZpMHdpt8N+5dM0tCCZY
         nqmw==
X-Gm-Message-State: AOJu0YzH5INQEMD1dVVOa8ANgBEw9Lb5KFjgde3GEcPUORIMB5FZocR4
	xEAIlSaYwpBuRGY+pXzTcKufVf8PvSbd8UvrkMhyqbWr+P12TC1LhDITUoOf6iRUQsfuJ+XnOF4
	akn2VtcfRtEsLnmvpgz+1/Mk/hQOUEjxsng7KdSd0WmCt9c1i3bM0oEyKdot09fRgLZ3jKy4i1P
	V3oyOD6hM7Wy+G8eUWx+WY8Dr5LNc=
X-Received: from ejrf19.prod.google.com ([2002:a17:906:7f93:b0:b88:47b9:4312])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3f8a:b0:b88:22f1:768f
 with SMTP id a640c23a62f3a-b8fb452e1e2mr118012766b.54.1770993500038; Fri, 13
 Feb 2026 06:38:20 -0800 (PST)
Date: Fri, 13 Feb 2026 14:38:14 +0000
In-Reply-To: <20260213143815.1732675-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260213143815.1732675-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213143815.1732675-4-tabba@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: Fix ID register initialization for
 non-protected pKVM guests
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-71050-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AC881137207
X-Rspamd-Action: no action

In protected mode, the hypervisor maintains a separate instance of
the `kvm` structure for each VM. For non-protected VMs, this structure is
initialized from the host's `kvm` state.

Currently, `pkvm_init_features_from_host()` copies the
`KVM_ARCH_FLAG_ID_REGS_INITIALIZED` flag from the host without the
underlying `id_regs` data being initialized. This results in the
hypervisor seeing the flag as set while the ID registers remain zeroed.

Consequently, `kvm_has_feat()` checks at EL2 fail (return 0) for
non-protected VMs. This breaks logic that relies on feature detection,
such as `ctxt_has_tcrx()` for TCR2_EL1 support. As a result, certain
system registers (e.g., TCR2_EL1, PIR_EL1, POR_EL1) are not
saved/restored during the world switch, which could lead to state
corruption.

Fix this by explicitly copying the ID registers from the host `kvm` to
the hypervisor `kvm` for non-protected VMs during initialization, since
we trust the host with its non-protected guests' features. Also ensure
`KVM_ARCH_FLAG_ID_REGS_INITIALIZED` is cleared initially in
`pkvm_init_features_from_host` so that `vm_copy_id_regs` can properly
initialize them and set the flag once done.

Fixes: 41d6028e28bd ("KVM: arm64: Convert the SVE guest vcpu flag to a vm flag")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 35 ++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 12b2acfbcfd1..59a010221818 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -345,6 +345,7 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
 		hyp_vm->kvm.arch.flags = host_arch_flags;
+		hyp_vm->kvm.arch.flags &= ~BIT_ULL(KVM_ARCH_FLAG_ID_REGS_INITIALIZED);
 
 		bitmap_copy(kvm->arch.vcpu_features,
 			    host_kvm->arch.vcpu_features,
@@ -471,6 +472,35 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
 	return ret;
 }
 
+static int vm_copy_id_regs(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+	const struct kvm *host_kvm = hyp_vm->host_kvm;
+	struct kvm *kvm = &hyp_vm->kvm;
+
+	if (!test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &host_kvm->arch.flags))
+		return -EINVAL;
+
+	if (test_and_set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
+		return 0;
+
+	memcpy(kvm->arch.id_regs, host_kvm->arch.id_regs, sizeof(kvm->arch.id_regs));
+
+	return 0;
+}
+
+static int pkvm_vcpu_init_sysregs(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	int ret = 0;
+
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		kvm_init_pvm_id_regs(&hyp_vcpu->vcpu);
+	else
+		ret = vm_copy_id_regs(hyp_vcpu);
+
+	return ret;
+}
+
 static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 			      struct pkvm_hyp_vm *hyp_vm,
 			      struct kvm_vcpu *host_vcpu)
@@ -490,8 +520,9 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 
-	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
-		kvm_init_pvm_id_regs(&hyp_vcpu->vcpu);
+	ret = pkvm_vcpu_init_sysregs(hyp_vcpu);
+	if (ret)
+		goto done;
 
 	ret = pkvm_vcpu_init_traps(hyp_vcpu);
 	if (ret)
-- 
2.53.0.273.g2a3d683680-goog


