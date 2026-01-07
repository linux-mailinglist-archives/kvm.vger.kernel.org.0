Return-Path: <kvm+bounces-67272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B41FD000CB
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:47:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0FA403032AFF
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC463338936;
	Wed,  7 Jan 2026 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pi96HkM3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA722C181
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767818750; cv=none; b=iACp2GAwsilMUP1Aavl8fKjiO65nWv/CfniFgo/+fyGmDJ2YgIKz6ev1oHKyjIkBg85kuY4AlmRhlc/2TmhOMMPZXUT8Mpw2Gwp0yx2PbcnmyH+NoxwwxoQr5svl4gJ4TXSkPp/zChaaXZNM+Xpt8gF8bzNsx08nKA3mN/TDUJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767818750; c=relaxed/simple;
	bh=kLf+Jhn9BfWaW9wP6Rr3K8VfNR2h8kLz770YadG23A0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NwWc8fjwURjFCLLIJse37qzsmKrmv5jpfYg9Ars4ivrKZK1wq80Jj/+6gKByZ8e0e8wrmVrLXmb0ZU/kvG3sXepsnvhxQDhqACxvuK+1EnT+S4zEwxn1jw4Rhg2mvcUTMkRGIf/+av2AdCTv20oSKp2Mm+ZKA/ZGSXZxm/XcKms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pi96HkM3; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0a4b748a0so49105785ad.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767818749; x=1768423549; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n48nbRlaDLWOB1PZTlBX2sKsu5Tn10eECYRBDhE9kPk=;
        b=Pi96HkM30gG3/ofGhrbgV9XdEd30XVrgzoU4UFVkKoT8Nw2tMolOogcEGJsj0g1qC9
         ywt4bc/bDKu5VDQIyPmw3yv3R5UlzN9edsojuLtluELaNmeKgaqrKtEzD/ryLC4Ob5l1
         iWwUIffsS+A+4f41D4AYZ4ty6TrB+Nf6SHuYUQcG7gK9ELwh1PwdQVXvt22UjEySV6Dz
         eviAyjdg9Sjys0BWwWPbFGR4hwKNiTxjV3ncu6VXIV+SAE47GeAP9o1SMvKqgmuLphU1
         PjB9ke60gauirjJEprbF727RmbvTZyQ/kvUBaDsr7PFFjfcm5hNaXZPPjIt8UDGYLAe9
         xGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767818749; x=1768423549;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n48nbRlaDLWOB1PZTlBX2sKsu5Tn10eECYRBDhE9kPk=;
        b=pNkgt6VY4SD320wbk9lEetd3fS5K7X/EK06EVqJ9KG8GW6EiMBgO2gSh8d9P1kqqqN
         NH07XS8zap4w7ImOh+dHglT8sGVLaDmHpqMMWWQwZOtYekx1R0Tm2H/2i+AIjP6sY9Ru
         /kj2NYNOTbrpJsmZmioQJ4RxObRdJJvNArp7PreSZXq+lGnInWXH5HzvkgNgtrzQUpIw
         nlWFLx+iN/RS81dirgOo/6Ab/hMWqyBz0eNm9mxNQQDXpzFNvUSbJ5nq90ZgsrMH79ae
         4Ne08LfKa+VNpMPKF/Izt2XB6MXhlWAiu3yXaPgu9HPg4Wur1wiu19WQhL/B1M6B8TgG
         jhBA==
X-Gm-Message-State: AOJu0YzMa+RuSRdNa3sbAVHkkw7QtUMkemgpjJ6yqlfRteyayjYmp932
	sQQ8DOyPAgwkNRs42xP5ZdPApftB1N3lyFL8OeMdthW5QmePL8qpOlm+Oj04X9nZg/ANYefbKSu
	+QOGknQ==
X-Google-Smtp-Source: AGHT+IH10+6CBxqa1obwGhtxkz9iOMN8jfrH74bwHIBvEWL+FWgb30WsryZCuj71R9V67aLEnEs04iSsxh8=
X-Received: from plbbi2.prod.google.com ([2002:a17:902:bf02:b0:2a0:c92e:a37a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f4e:b0:2a1:388c:ca63
 with SMTP id d9443c01a7336-2a3ee48ab8bmr33621325ad.31.1767818748919; Wed, 07
 Jan 2026 12:45:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  7 Jan 2026 12:45:46 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260107204546.570403-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Fix an off-by-one typo in the comment for enabling
 AVIC by default
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Fix a goof in the comment that documents KVM's logic for enabling AVIC by
default to reference Zen5+ as family 0x1A (Zen5), not family 0x19 (Zen4).
The code is correct (checks for _greater_ than 0x19), only the comment is
flawed.

Fixes: ca2967de5a5b ("KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support")
Cc: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6b77b2033208..7e62d05c2136 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1224,7 +1224,7 @@ static bool __init avic_want_avic_enabled(void)
 	 * In "auto" mode, enable AVIC by default for Zen4+ if x2AVIC is
 	 * supported (to avoid enabling partial support by default, and because
 	 * x2AVIC should be supported by all Zen4+ CPUs).  Explicitly check for
-	 * family 0x19 and later (Zen5+), as the kernel's synthetic ZenX flags
+	 * family 0x1A and later (Zen5+), as the kernel's synthetic ZenX flags
 	 * aren't inclusive of previous generations, i.e. the kernel will set
 	 * at most one ZenX feature flag.
 	 */

base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.351.gbe84eed79e-goog


