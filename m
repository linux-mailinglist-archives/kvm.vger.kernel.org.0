Return-Path: <kvm+bounces-69868-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NMCNkTCgGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69868-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:27:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 55CBECE331
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8890C305F4BE
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 15:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CFB37AA81;
	Mon,  2 Feb 2026 15:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wzM8/vwu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB3236B07F
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045794; cv=none; b=qshcowsPNoYAS2jXE/7SqBRr6NyAOQv+CgqvgIApHTsvr3w6IYBnQ84hbpFcMv62wc87d8lh1czaxRJchlknRCB9CC8u2cDUOS5leC6yDFtLHDd8bDaChBSOn53g4uS0ioApCfJjLskAo6lrWdn8ouQoQ4dMrhf9O0YCuyl3zK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045794; c=relaxed/simple;
	bh=Ab3Qd2Bs1lzOiZYwU5lsA+uRRbsMAuV7jYxkaEW0QUc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LK1LNclbFeA0Hr5lO+Uy07Rzq/qA3gAAnn79ZHEDYEkv3TyIHf926j66qWn5uVcauidPLG8oz9Q/ta90W/+1CqhZvHiHnfCpjzXwJTPs7loBunngB4REnrrNBE5A3y5rLMgNWEShV+b20eNX24gkAZkvw7ROYLYvBsPK8woG/PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wzM8/vwu; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47edf8ba319so48070115e9.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 07:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770045791; x=1770650591; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DpiJoHpkSUIEeyEcInw4W8Eny3OZ/gdfqU/Eqv54B88=;
        b=wzM8/vwupxRTxK3w6ZkuLmk1iC+s6tceO7/6/II/ojDtOR0HJoY5LIeHA3hYews+eW
         Ktqz32fKKxPJZ0BN5FnothyjbaprN2YDvU6lghtolu3YXR2oAS8EnjaFfEUYunMK4HEm
         AmFUJW96lFtUbEgXpqtSahjhRPioWsNvc9NmrcGdsGI6gLJZy8ZBtO2eHIN5IgA8ggDj
         bAeXGm06Oj0GZ0SIjos1SwLrcuH78IVyJkI6KKqD9PdEBDNsR+ed5W5ro2cwCQLIjruy
         BsTABSkR8MRLXu40nwVST/HbaEju2dIoWa8mVf0T4k1bT/LLWCgbVQ15uWMlpITK6BPZ
         Es6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770045791; x=1770650591;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DpiJoHpkSUIEeyEcInw4W8Eny3OZ/gdfqU/Eqv54B88=;
        b=oShtxSXIbA9KdKnv7wE7Z7bEJWevPe54OjHw1BgT7dWaPKFjLfQIDjBG0IQWhZkOgE
         B4SGITWKL37XVSdXLUL+F3RfwgRMsWjakxdO7PUK+vqG7l6VjqNpDfR/sKZ3TUpVUTiq
         NizZBhgWxqi4j1P2GzVLVayjjkIK5S3Tj1/MI+HnXypjyJq96WsXgV4lEx4LxS/5ROSH
         MGhoJ8D6aehCvGseJ+ITmbxUbn03KLYQTnnCQZ5ZRFt1b7xuDRS5vuBKao4dACnNJ75L
         fdsUSsZ6X+eCIcSKhuZgyc0nx21cdSvUkGkiKhEAGbsAziCuTIwQqZLkNjzoy6Rsxr9R
         11+Q==
X-Gm-Message-State: AOJu0YxcDX2jzCLCrFgXpIDamGlt5WkUwN0GOmb1ppz1KnW1Zh8T2HZc
	F1vL8mi8CTFJjbbSTeYA5xe+B4U05dLiE3siB22O4ujWZthkmGrQeXV3aEk8tcBdO3e5I3uI8+x
	GQFDeByMvxyHimGhD4Dc7Kha1v5F9ke92Jz6KZnJzvz3nHRSMAO9TpjkJauio/VOMNWT1gyu6fY
	M0G1aYPzXG0ov1aulb+akXD/GLL5k=
X-Received: from wmop16.prod.google.com ([2002:a05:600c:4690:b0:480:4be7:3f3a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f8a:b0:477:76c2:49c9
 with SMTP id 5b1f17b1804b1-482db4568dbmr166795515e9.2.1770045790988; Mon, 02
 Feb 2026 07:23:10 -0800 (PST)
Date: Mon,  2 Feb 2026 15:22:53 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202152310.113467-1-tabba@google.com>
Subject: [PATCH v1] KVM: arm64: nv: Avoid NV stage-2 code when NV is not supported
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69868-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[12];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 55CBECE331
X-Rspamd-Action: no action

The NV stage-2 manipulation functions kvm_nested_s2_unmap(),
kvm_nested_s2_wp(), and others, are being called for any stage-2
manipulation regardless of whether nested virtualization is supported or
enabled for the VM.

For protected KVM (pKVM), `struct kvm_pgtable` uses the
`pkvm_mappings` member of the union. This member aliases `ia_bits`,
which is used by the non-protected NV code paths. Attempting to
read `pgt->ia_bits` in these functions results in treating
protected mapping pointers or state values as bit-shift amounts.
This triggers a UBSAN shift-out-of-bounds error:

    UBSAN: shift-out-of-bounds in arch/arm64/kvm/nested.c:1127:34
    shift exponent 174565952 is too large for 64-bit type 'unsigned long'
    Call trace:
     __ubsan_handle_shift_out_of_bounds+0x28c/0x2c0
     kvm_nested_s2_unmap+0x228/0x248
     kvm_arch_flush_shadow_memslot+0x98/0xc0
     kvm_set_memslot+0x248/0xce0

Since pKVM and NV are mutually exclusive, prevent entry into these
NV handling functions if the VM has not allocated any nested MMUs
(i.e., `kvm->arch.nested_mmus_size` is 0).

Fixes: 7270cc9157f47 ("KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
Based on Linux 6.19-rc8
---
 arch/arm64/kvm/nested.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cdeeb8f09e72..d03e9b71bf6c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1101,6 +1101,9 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
@@ -1117,6 +1120,9 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
@@ -1133,6 +1139,9 @@ void kvm_nested_s2_flush(struct kvm *kvm)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
@@ -1145,6 +1154,9 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	int i;
 
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 

base-commit: 18f7fcd5e69a04df57b563360b88be72471d6b62
-- 
2.53.0.rc1.225.gd81095ad13-goog


