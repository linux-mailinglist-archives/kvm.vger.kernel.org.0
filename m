Return-Path: <kvm+bounces-70930-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJ+hBJqXjWkt5AAAu9opvQ
	(envelope-from <kvm+bounces-70930-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:04:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6755312BADC
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:04:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A47E3128E82
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBCC2DAFAC;
	Thu, 12 Feb 2026 09:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AFnBU1CP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066E0279DAE
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 09:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770886978; cv=none; b=CQuz6a1/TcdZ2NZNRj1MsdHfEcGwGL/9rR1d1cswEaSrECOP5t887Oz1n41KVvIcKOG74vebdF28/sjCXBowa8g7J5JI3fUI59LlJ/VwhHIf7nm4+7K+F0fJADT0cHTScXfMwNBnabc71Czy0fflvrb4MKCqQlULtch43fjZeyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770886978; c=relaxed/simple;
	bh=Lg7kND86VXNrl9kVbjruzNAW8/pyZ1wa8nTrxBB+aro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h2Ea4n0rVxRsxi7uRS7NsNg61QUxo9mjccng/RJbr5f0f/uWg9BDS50qBMXO3v4u89aYkIHDiU2tIPF/y9Zt7U+pzETxuza4IYTW8yqZz7h3e2OZ70WwrgFDMVUsKQ+Va4RoaOS8ILbMo3t9pzrnvOvCjVCDJxZBa5eeL2PArqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AFnBU1CP; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43768e2aa4dso3709326f8f.0
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 01:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770886975; x=1771491775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=okszUF6rn81wokN6MFCx8nZtl6u7oamXEuCUR6T4heI=;
        b=AFnBU1CPuqlfGj8VmiNKml9A27jrtyqVsoLg9pCdHjhw/T89QEUV3q5UeYgo72qZ6r
         o5XSQcOXSDUrD22KPp9zLSP3sZsZgqHLlMMGn1YNt1FZOEtAXBwNmIR4T0TppOBvRLq0
         o2c2qC+iXZyjqnnBIHyLTNHUxkSqL0agcmvC4Mf6sNxBbdjNOYwZCKcv2sZVTtVVHNOB
         hGCRzVxa66RAyy+kTObdjRBqP23MVhDuhKILkZ0lGA2bz7NcZlaBA3fs0Aace5nL+iqC
         9DGvwuSy5mc43FMUeoGvu2+p7G33Uvu49pxjAwFgSVYi5niEvxz/eut0STjLjPukd2dk
         DdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770886975; x=1771491775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=okszUF6rn81wokN6MFCx8nZtl6u7oamXEuCUR6T4heI=;
        b=uWMtisRz2u4BA7NLPfjJSc/fEO7+5Xy51dopnDtp4YRWlS/oACXvE/nSfG+3jghv3E
         2wRZlJhTLrLJnAWMNxOIEE+z0VwBZ4EUj2dDbHJvNBHRMmE1Qv7e7DQXsgEnIIu1qhQT
         cSIK0pQuOEubectzBA9bcmKwD1tZgYlZs+rf60Upqa7XKug5ttst9QmV/FAAw9Z9hw4D
         E94TphTKCpMx9jeWR1PaXip6smsaz0SruDOGO6Vi6IY560LeS56CkguI7x8V39yZGPwx
         kxZbiV4VHPz5gZoM65es7t4CIuskTz7gRJitE3K+pas3R6JR4O3i9elPhFnItQ0xZa8Q
         fS8A==
X-Gm-Message-State: AOJu0YyqOI1ioV8BZbEo8i3PknG4ALJ3YnA69DWuw3Re+N5iJPVVhKZa
	U513dosCmW+jlYZ+nOoqlzY55YF1Iiubxi4/vVL7iWLzLUpHL4HXSvGXPoCOq7KCl8UsWlHszxJ
	0Iz3roci4lIL1KHDPI/vVcO2CGiYcK2drfBsGsWtpmdy7jCtrk73zI4zEGt10yXlX/67xXtetdY
	07KehhYcYLsv/ZUQMTeff7eJ7rFmM=
X-Received: from wrbfv12.prod.google.com ([2002:a05:6000:2c0c:b0:437:72d9:7316])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f48:0:b0:436:3475:3687
 with SMTP id ffacd0b85a97d-4378adca042mr3331122f8f.57.1770886975548; Thu, 12
 Feb 2026 01:02:55 -0800 (PST)
Date: Thu, 12 Feb 2026 09:02:51 +0000
In-Reply-To: <20260212090252.158689-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212090252.158689-3-tabba@google.com>
Subject: [PATCH v1 2/3] KVM: arm64: Fix ID register initialization for
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-70930-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6755312BADC
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
the hypervisor `kvm` for non-protected VMs during vCPU initialization,
since we trust the host with its non-protected guests' features. Also
ensure `KVM_ARCH_FLAG_ID_REGS_INITIALIZED` is cleared initially in
`pkvm_init_features_from_host` so that `vm_copy_id_regs` can properly
initialize them and set the flag once done.

Fixes: 41d6028e28bd ("KVM: arm64: Convert the SVE guest vcpu flag to a vm flag")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 37 ++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 12b2acfbcfd1..267854ed29c8 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -344,6 +344,8 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
+		clear_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &host_arch_flags);
+
 		hyp_vm->kvm.arch.flags = host_arch_flags;
 
 		bitmap_copy(kvm->arch.vcpu_features,
@@ -471,6 +473,36 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *h
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
+	if (test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags))
+		return 0;
+
+	memcpy(kvm->arch.id_regs, host_kvm->arch.id_regs, sizeof(kvm->arch.id_regs));
+	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
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
@@ -490,8 +522,9 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
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
2.53.0.239.g8d8fc8a987-goog


