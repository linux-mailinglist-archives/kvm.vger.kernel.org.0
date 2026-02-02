Return-Path: <kvm+bounces-69820-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Ja4FgNngGlA7wIAu9opvQ
	(envelope-from <kvm+bounces-69820-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:57:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B97C9D6D
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:57:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E5B76301105E
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 08:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4532D063E;
	Mon,  2 Feb 2026 08:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YS86LRye"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A13D3542E4
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 08:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022648; cv=none; b=dcnUGlBDOTY9xEnriNe7oGJF7zNcIne3MctL9BFItW2Tlgvb8Chi8OU614dEjkPudPtg2AmuqQSMqcYmmrsMz4PU2bIVcGTwUNkz+bwRi0NCVcUHtE4AezDHfroS++HeU/eEEzzts8d4brkDKz8yyCN2yk/vS6UTi4+08Xxdigk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022648; c=relaxed/simple;
	bh=mimq3Ea6QsBhqEZaawbP5tbHpUK8J8WuXfTEv/BkgmY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aZWEzfrDN9mytSEgR34uenMlJZ138+SrY+LjATjAzJNyGD0OtUBxRidhBPZ/NKO0j7M6+axUz+ZhBUiTjiJm7lY4kHspF2LTXIuaHD/L7ospAoTLrq6wXD7/Ab1tZOhuVWBTpvMjswPtrwiu7dqstI+Z3ZfKkIcpj2UEKd6vN+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YS86LRye; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6580e793380so6097827a12.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 00:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770022646; x=1770627446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e4bYzuIeTIcCNGWSl8VjsJtqLHBazJT084269tJJreU=;
        b=YS86LRyedHs34kJRZ9aqt8Y/VcygJFy4Si8Uv1qwoOaQKQQi3yv0EZrG/STxPlFJDh
         ZPMD1w2Ph1Bp6jHUYlIVjMlphAw6wtlrlGSiSVYrmepldNzqJqPEc07QpuCxS6HAQDM6
         7A31aZ+OXCBuSL4tKliaa8KooUN/cLJkGFFj0neuiyaWlTFIv4sLogyODa1iYU1x8ms+
         3gwY+dneQvkielo4o2wuXjxaIApjkB2Hchjbi11dNm7FVEteOYNJ4KxzZ3mld994RZWW
         BRizNYHXIeXRcxYoH90/1YFOFVJ5RLEMDRv3dG3qeACYOMFPDUS/Ak2EAD0CChdgqXud
         lNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770022646; x=1770627446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e4bYzuIeTIcCNGWSl8VjsJtqLHBazJT084269tJJreU=;
        b=As8ofIsBGZyQRxZIpkA8/RL3jSnhjLbZPzR7XCCthN2/dhqvsRT4LGDekG46fjINZb
         mpCFiqNtn/90sgCY55J8zsTUakGBTMQTX554VOgxbguvlZ2ZlcMDUTxsN+AfEkiJev6S
         a1CoId81O9HtaYFU+nBBqFCRP0v2WMaje7eEJ0a0k+1XRGj4NEhdooffyjJSm2L06BgN
         oXpya4c4m7p2lltjT/ZF31bLIx5RhLlw25Oj8Z/gYo9qlvNEycgPKe2lGkVyTexb2cdn
         /nKAtOYGnZcdndW8YFFFU4IKJ6LXHUZItkacq6XvPaCt3yqZGV6vNUHk2qHNxfFkh4H7
         MtNQ==
X-Gm-Message-State: AOJu0YwWuMZjEl3m+NTFkx2kTCeg2yK4bGFEsvWq1+/Z27tUY7Ep+DEJ
	6UtjPav4X5Pi7SOH2L1g6ZbO/6KvfmxWOKakvDFSOgmtv4ZpLKGxTtYRV5ZmH7eJxt6Fa3wx2ja
	uIGpILneJ2QW1b7hN12e2dEQI8/hm6eP8H7iB9r7bmAROJIfoVjtsHyO4ouDRqc/JDu5JIUFINa
	5ndZ53fnPz1cn8+jC6I/QeNy0zjic=
X-Received: from edzh14.prod.google.com ([2002:a05:6402:94e:b0:64b:a7f2:4991])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:254c:b0:658:b55d:2822
 with SMTP id 4fb4d7f45d1cf-658de58d9cfmr6382582a12.16.1770022645475; Mon, 02
 Feb 2026 00:57:25 -0800 (PST)
Date: Mon,  2 Feb 2026 08:57:21 +0000
In-Reply-To: <20260202085721.3954942-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260202085721.3954942-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202085721.3954942-4-tabba@google.com>
Subject: [PATCH v1 3/3] KVM: arm64: Use standard seq_file iterator for
 vgic-debug debugfs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
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
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_FROM(0.00)[bounces-69820-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Queue-Id: D1B97C9D6D
X-Rspamd-Action: no action

The current implementation uses `vgic_state_iter` in `struct
vgic_dist` to track the sequence position. This effectively makes the
iterator shared across all open file descriptors for the VM.

This approach has significant drawbacks:
- It enforces mutual exclusion, preventing concurrent reads of the
  debugfs file (returning -EBUSY).
- It relies on storing transient iterator state in the long-lived
  VM structure (`vgic_dist`).

Refactor the implementation to use the standard `seq_file` iterator.
Instead of storing state in `kvm_arch`, rely on the `pos` argument
passed to the `start` and `next` callbacks, which tracks the logical
index specific to the file descriptor.

This change enables concurrent access and eliminates the
`vgic_state_iter` field from `struct vgic_dist`.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 40 ++++++++++----------------------
 include/kvm/arm_vgic.h           |  3 ---
 2 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index ec3d0c1fe703..2c6776a1779b 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -104,58 +104,42 @@ static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
 	struct kvm *kvm = s->private;
 	struct vgic_state_iter *iter;
 
-	mutex_lock(&kvm->arch.config_lock);
-	iter = kvm->arch.vgic.iter;
-	if (iter) {
-		iter = ERR_PTR(-EBUSY);
-		goto out;
-	}
-
 	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter) {
-		iter = ERR_PTR(-ENOMEM);
-		goto out;
-	}
+	if (!iter)
+		return ERR_PTR(-ENOMEM);
 
 	iter_init(kvm, iter, *pos);
-	kvm->arch.vgic.iter = iter;
 
-	if (end_of_vgic(iter))
+	if (end_of_vgic(iter)) {
+		kfree(iter);
 		iter = NULL;
-out:
-	mutex_unlock(&kvm->arch.config_lock);
+	}
+
 	return iter;
 }
 
 static void *vgic_debug_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct kvm *kvm = s->private;
-	struct vgic_state_iter *iter = kvm->arch.vgic.iter;
+	struct vgic_state_iter *iter = v;
 
 	++*pos;
 	iter_next(kvm, iter);
-	if (end_of_vgic(iter))
+	if (end_of_vgic(iter)) {
+		kfree(iter);
 		iter = NULL;
+	}
 	return iter;
 }
 
 static void vgic_debug_stop(struct seq_file *s, void *v)
 {
-	struct kvm *kvm = s->private;
-	struct vgic_state_iter *iter;
+	struct vgic_state_iter *iter = v;
 
-	/*
-	 * If the seq file wasn't properly opened, there's nothing to clearn
-	 * up.
-	 */
-	if (IS_ERR(v))
+	if (IS_ERR_OR_NULL(v))
 		return;
 
-	mutex_lock(&kvm->arch.config_lock);
-	iter = kvm->arch.vgic.iter;
 	kfree(iter);
-	kvm->arch.vgic.iter = NULL;
-	mutex_unlock(&kvm->arch.config_lock);
 }
 
 static void print_dist_state(struct seq_file *s, struct vgic_dist *dist,
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d32fafbd2907..f2eafc65bbf4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -302,9 +302,6 @@ struct vgic_dist {
 
 	struct xarray		lpi_xa;
 
-	/* used by vgic-debug */
-	struct vgic_state_iter *iter;
-
 	/*
 	 * GICv4 ITS per-VM data, containing the IRQ domain, the VPE
 	 * array, the property table pointer as well as allocation
-- 
2.53.0.rc1.225.gd81095ad13-goog


