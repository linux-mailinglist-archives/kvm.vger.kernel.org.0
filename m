Return-Path: <kvm+bounces-71049-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MBmuK4Q3j2n2MgEAu9opvQ
	(envelope-from <kvm+bounces-71049-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:39:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 194FA13721E
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:39:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 23CBE3095481
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 14:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A287360750;
	Fri, 13 Feb 2026 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gx/GmjSq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8122E36164E
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770993501; cv=none; b=o7PLsKKn37ie+F4Xiv9ZV/nBkhd4X3msdXcQIPJoi69i52iV/YbK0Hn+tu4oPFc3gPirA1tocMxClOWDmOh+IfTyDQjxlqyz1elLakDKxVPQwQtuYLloWlHz2SjdviIX7t8mKOqbwOaZBjNO6GnqEIv31kYQHOsPm9pkiRiqF9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770993501; c=relaxed/simple;
	bh=nTibB9VvAnMArBkmdQHWooCRiGNpPUf8nLZ7D5ImAVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pd16byTkz3Ay1BK4hueZlNA+IudYD8WK1tJ8aA5yUfsp2YZjoTGNQvefoIpwyXYoBz9IA6TWus23MAvpZ/yEv7QvXvWo2frcybXB0lEFcdfepLnA6fZFF/WFHi5uWaHSjZcUZu56P7ve5h2vxowwuy7pJtwQMZd6M9vNVyYoxZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gx/GmjSq; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8db7f340b3so29318666b.3
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 06:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770993499; x=1771598299; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iwg8k07MnblHsBD301KLHziw381Y4vRMO8Vvy4eyPOQ=;
        b=Gx/GmjSq0yDEqBviWvEbipl9nkUjCfYxOpHPCGt9uVCRd/kSYxE2OrUkz0mCVBpLwY
         FgHwJWMVuSVvr73XLlrCIf14cxXg4snfPqCsAueP24Ai+T6/3pcbPk/4NY4vTYcrr7xE
         kSe9YZEbWpUHEYNr5nPFuNxnes7luzNN0s0q/Lutg+4dPGrUlwblMC3a7teydjyi+2gv
         08KXyQwkHoBASP7zkp7nStBX8qQJI0v7+CaDLOm+ENOfnU9QCinXDTtV1nrlY5qEZyv3
         J4u+MImRZPM7oX/KURfyEWstLncoUq20m5ktsiKag01UwBhcg4GbgP9iY+Wi6NRJPeHr
         QnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770993499; x=1771598299;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iwg8k07MnblHsBD301KLHziw381Y4vRMO8Vvy4eyPOQ=;
        b=wzNNhMCiW1OAoB0xLJfeUOfcRpAEgv4RLC3fsEPK8ZHsAN2Kcp9jKZXNe1kYWRg44J
         it+jbJDh7wy4a4eszwI36Umm078jE/USVlt+Do7fnQIIRz+3ryF0SrWrjTUik7w2+fys
         lkgk4LIsmNOW+6hyOaJG+Thu2b4qg05y3tDinIvi8bbXs7+z0tM/u0LBhcmvKvTJF9Z0
         1bSivN831PJZW39oOQMgfeFx0SVasWKJWw2uRQz25LY5/hI3VooDBNbjcXFf8k1AasIK
         vRk6NfR2pph5QNxBfK7dvY56EgcyAJGllEPB3yq/ECMOg/HHMEM1flX2xS2QOWg1HNdR
         RLxQ==
X-Gm-Message-State: AOJu0YwZizfo01FjfBPAy172uxKRUDxRCjR4DwZpFTxr/4XAlozgWQZ2
	XBHg0LXVO/6rNugGMDP3caH3o/psR6KLA52kaSuwK4lnfmSq94+a5DneHv7bzjFSt7zvvAcKAcS
	SuUO7k8uR7ZN7Mu9pieXPDO8Ah7GAizSDx3MMM3RkljSiqhK7yJgeNRn4xvfCMlDCCB705mMmMB
	Oh5EEUq2aj/ywPKupC0pS05RhzMbY=
X-Received: from ejdbe22.prod.google.com ([2002:a17:906:f416:b0:b8f:7a4f:842f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:c104:b0:b8f:7014:48fb
 with SMTP id a640c23a62f3a-b8fb41ddfdamr117462566b.16.1770993498644; Fri, 13
 Feb 2026 06:38:18 -0800 (PST)
Date: Fri, 13 Feb 2026 14:38:13 +0000
In-Reply-To: <20260213143815.1732675-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260213143815.1732675-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213143815.1732675-3-tabba@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: Optimise away S1POE handling when not
 supported by host
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-71049-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 194FA13721E
X-Rspamd-Action: no action

Although ID register sanitisation prevents guests from seeing the
feature, adding this check to the helper allows the compiler to entirely
eliminate S1POE-specific code paths (such as context switching POR_EL1)
when the host kernel is compiled without support (CONFIG_ARM64_POE is
disabled).

This aligns with the pattern used for other optional features like SVE
(kvm_has_sve()) and FPMR (kvm_has_fpmr()), ensuring no POE logic if the
host lacks support, regardless of the guest configuration state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
-- 
2.53.0.273.g2a3d683680-goog


