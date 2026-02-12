Return-Path: <kvm+bounces-70929-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gGtfI42XjWkt5AAAu9opvQ
	(envelope-from <kvm+bounces-70929-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:04:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2666012BAC6
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F74730FAC1D
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2769A2DE71B;
	Thu, 12 Feb 2026 09:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fiVn+SM+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3800D2C0F68
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 09:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770886977; cv=none; b=eUZvZpU/zOVSpBYp67DPuhPQ4tfRA8vhsil8jLClFB+syNrwzKIi4hCiBiBYDw2MoFLKqtaaUetWEwO/i9xR83sJH77n4bt3Hn9r42F/INV2jCICoQiQxw+gMJ/UOo1FUMJrsf8HrOb66GyDtUIaVnDLzz9PfgMGr77YAxNyGZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770886977; c=relaxed/simple;
	bh=7pCt9xCI7qPEiR77wf/ej5qv5bbTMY2AsJNfNSMCbTk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m6h1E9e9CtlKFM2rDNzoUlCJ0ubHqhGdPi/zhds/+NGY+wQYhcnUidIwV9WBmlRdqOydtclLnQ0XYmB7aNzuACWSTDaUBGMExFvAS497uzf4FcR1KKbHobD+tN+PuX9OT6MkzTlvhtKPgeSneKx8lEwaamQa7Fwx2YoyTIMpwh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fiVn+SM+; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-65b9db0c150so511815a12.1
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 01:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770886974; x=1771491774; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hohgtHRfz1v94OB8xvfSs3emKAePAKag+PCIiCzGg6U=;
        b=fiVn+SM+VkIo4M283h54ZOy0ZMQCVSwvkeS/vrODF7QI3DUhjm9Gdl2QCH1NI/HqtT
         5alQRfskjpM3wliwn62b/nqEGck0UlTxx0MGb+vmNicOwXTLg2sg6fgXpaeqy23Zvf6m
         BBT4y0/SqDU/4t5vmodl541J7j8WCFVc3cU28r0Lngg99sFdDTzGyDlNLBvZu3+XtaZq
         Eo5zmH2PFEP3/buJReU2vfEATbrXda3TbaqA+qQkcHxLDw9nm6XXAvl0DKCwxtJelsxi
         8F3Ayk17YVN8IQtM5QCb29pgraUo3ivpOuUgmtsC1f8Cqru/hnnZ/xFK76lU0wq912O7
         dLwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770886974; x=1771491774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hohgtHRfz1v94OB8xvfSs3emKAePAKag+PCIiCzGg6U=;
        b=NbQluvV5aiRSvbdkxl2/rSKUQj/KqBW3dOp/mV0EtcWkqFKGcJmql29Rl1KuCGL+Fg
         9SX86VqKdiUyPX4MWHdgyyBsyD359+UEm9KSOtqkC3hAf87xpZ/65FEUmA5wDAJ/ltB7
         UvTxPs9XKbaG6AhoerR0UrVZabfeY7WJ2udZR/SNscnBYi8OVC5Ut3/3LVHC5l+F7XJ/
         s+CmXhwMLhZ4xzSEPnyOxw27cpIjwryCMQYgNM+likKXw/Tbp76o315CKewekgLszaVj
         QxjbitxPqIuCnRjIrEcWeFDgsjg1ecEskWFWdY7JcOGkZKz7yHRu8+vWMx6zvtAjowKQ
         QH7g==
X-Gm-Message-State: AOJu0YwM1yR7yCs11TvhbNczznlGKSscFi16U4Ey9wpYWu8+Fw/xz0cJ
	NGh60RvLcR47fg5yfQeDtQC0qRcZm6YFKSaiQVyZAJzQQ6xpifuBeIpPVrWFLbcb3986OCHT3Fc
	HrB4OO6h/XEqk1usdzinbSDvv3LLEnL1xyUe/gauXfLF5ElBFPv2jfQu0za4h8+4T8aEwTm0kZ2
	LzSnwhUZhydd37l3/bMxLQCki/GTk=
X-Received: from edpj17.prod.google.com ([2002:aa7:c0d1:0:b0:65b:a58f:6579])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2681:b0:659:3671:137
 with SMTP id 4fb4d7f45d1cf-65b9dabcd34mr606478a12.1.1770886974387; Thu, 12
 Feb 2026 01:02:54 -0800 (PST)
Date: Thu, 12 Feb 2026 09:02:50 +0000
In-Reply-To: <20260212090252.158689-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260212090252.158689-2-tabba@google.com>
Subject: [PATCH v1 1/3] KVM: arm64: Hide S1POE from guests when not supported
 by the host
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
	TAGGED_FROM(0.00)[bounces-70929-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 2666012BAC6
X-Rspamd-Action: no action

When CONFIG_ARM64_POE is disabled, KVM does not save/restore POR_EL1.
However, ID_AA64MMFR3_EL1 sanitisation currently exposes the feature to
guests whenever the hardware supports it, ignoring the host kernel
configuration.

If a guest detects this feature and attempts to use it, the host will
fail to context-switch POR_EL1, potentially leading to state corruption.

Fix this by masking ID_AA64MMFR3_EL1.S1POE and preventing KVM from
advertising the feature when the host does not support it, i.e.,
system_supports_poe() is false.

Fixes: 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ++-
 arch/arm64/kvm/sys_regs.c         | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac7f970c7883..7af72ca749a6 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1592,7 +1592,8 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
 
 #define kvm_has_s1poe(k)				\
-	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
+	(system_supports_poe() &&			\
+	 kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
 
 #define kvm_has_ras(k)					\
 	(kvm_has_feat((k), ID_AA64PFR0_EL1, RAS, IMP))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88a57ca36d96..237e8bd1cf29 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1816,6 +1816,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		       ID_AA64MMFR3_EL1_SCTLRX |
 		       ID_AA64MMFR3_EL1_S1POE |
 		       ID_AA64MMFR3_EL1_S1PIE;
+
+		if (!system_supports_poe())
+			val &= ~ID_AA64MMFR3_EL1_S1POE;
 		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ID_MMFR4_EL1_CCIDX;
-- 
2.53.0.239.g8d8fc8a987-goog


