Return-Path: <kvm+bounces-71048-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AvlAWQ3j2n2MgEAu9opvQ
	(envelope-from <kvm+bounces-71048-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:38:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7415C1371EA
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E8A84305CE22
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 14:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AC236167E;
	Fri, 13 Feb 2026 14:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T12PBBDC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404EC361672
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770993500; cv=none; b=iyYInmehkK9/BwU4ak1ciUrCyqvAOo1gHNwZMKtmoVkH49smMu+9e1jPmaFI5J2HbvrWF5kBsA+T6h1OB7ilrsgSejeEuroTmkz+6YOSYqhGF6ItYbm/UfqHr1mQBPq9FROcsDF00So2Z5Eo+sIg8+08dGkZa/CiKuuURt8ZNSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770993500; c=relaxed/simple;
	bh=CBGX9joKWS1ZTVo7NrOlT+lG2W3Inq1FjMPAVo9hcsA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NLAiR36QkWmFHNB63z0vufvJvuf6lOO86rhjdBRWUvq3btLfpUlaOaFOkw3gVzjv42xi0/g/Eo2ki9Ta0cDu4EulisPVsytuRDnvZOXIBOLDmhBHLMkppYv9C9oubGGhiye6bU+iYNzj/wwz4sjG998eSId/SOWn95W+7zxn8ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T12PBBDC; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836b7c302fso13151955e9.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 06:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770993498; x=1771598298; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI3PiRBCJaOtbE31TrtopwnjhpEV4zI9W7Z3S9kmPS8=;
        b=T12PBBDCjIa6XpME3Lh1g8nk+10W5ShthXvDiu0pLv9nnwMOdeAk4E7FB8J+gtrHoD
         BtRClVarCHzNB5BDMqupdsd68MVQEBEPlqzp/6ZpGU/7y+crq2PgwFSxexEnwBGhtewa
         BJdlBOS9fyvBND6SsOpXyjEZjQ2PnKQHYNk1+OD0JJM0djdwKl4M8mrwiK0XohEEv+AT
         XmVxYfj1hqf+LcgCG5nOMGjt6E+JO7hju5Dj5JRMbDrhgMDxMMVCtWRiflEgI7m3tbMn
         oBjFoFnho8ohnmYgfhGdsEWzj7A+rICsErgeIG9Vui/QO7L3njMzWcl5rY6jPYu3t7R4
         rEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770993498; x=1771598298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZI3PiRBCJaOtbE31TrtopwnjhpEV4zI9W7Z3S9kmPS8=;
        b=CHlzBoBncP+Tycw3chNhyOvUMm5U8vC0RNZ+rUQRW54gnxe714ckNxWYne7Kmyxhg1
         W7be1RvB3IZHgF9LjlSlVYuBHh5KEflChvdzxTtdfHdIHQ/f0vN4R7vFYOcU1WGujs/i
         p1nFeHUGKF1olrdCwwP2Lcnc8gu5T8O4TxfZvBmF71IvNwqoAE/kekz25UUXV421liX+
         vKCgfYsgGQryzFJIbYCmqC1qHLRRNpQjwhPiUsBthkOcBeT75RN1stJhLoAskw0myWLi
         PCilm4oQemnthNcSiAlSDg+ObrvRTOGPsTPsiIDpExQzROZbIPauWyjttUhhYro2ik9O
         +8Tw==
X-Gm-Message-State: AOJu0YzmZyFbQ8RfbuZhEkg0gr50kiGO01Y7MfmRZY9BAu4aPWyCpflY
	pqIA6Wc9gAe0WI8Szv6RFibEFVna0l8YeuZ/rxubszT6DtKWsTTAxVU5kiedIy/uEImbyY/Gz0w
	e3lJKQp2tFqbut3z2TMUK4uP/jA7eiRFEYV0czzKiGpvnPywgTt9C2yoSQ1VTVQKnC9FedfzWCx
	lq9Fl13muO/vn2tW14Tx2U+xW/Zgg=
X-Received: from wmbz20.prod.google.com ([2002:a05:600c:c094:b0:47b:d5ad:dd7f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:474e:b0:480:4be7:4f53
 with SMTP id 5b1f17b1804b1-48371095fa6mr56214175e9.31.1770993497276; Fri, 13
 Feb 2026 06:38:17 -0800 (PST)
Date: Fri, 13 Feb 2026 14:38:12 +0000
In-Reply-To: <20260213143815.1732675-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260213143815.1732675-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260213143815.1732675-2-tabba@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Hide S1POE from guests when not supported
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-71048-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7415C1371EA
X-Rspamd-Action: no action

When CONFIG_ARM64_POE is disabled, KVM does not save/restore POR_EL1.
However, ID_AA64MMFR3_EL1 sanitisation currently exposes the feature to
guests whenever the hardware supports it, ignoring the host kernel
configuration.

If a guest detects this feature and attempts to use it, the host will
fail to context-switch POR_EL1, potentially leading to state corruption.

Fix this by masking ID_AA64MMFR3_EL1.S1POE in the sanitised system
registers, preventing KVM from advertising the feature when the host
does not support it (i.e. system_supports_poe() is false).

Fixes: 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 3 +++
 1 file changed, 3 insertions(+)

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
2.53.0.273.g2a3d683680-goog


