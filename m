Return-Path: <kvm+bounces-21901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B1C93704B
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FF4C1F22751
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37371145B26;
	Thu, 18 Jul 2024 21:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zVzFYJeF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0F113DDAA
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 21:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721339739; cv=none; b=sbKcX0N+tyTFqvgU7fypQBxMMg+u0HoUxVUuGra2eQIbjZCJ5Okuir6LimWUrlLteQmgdV6HPIje+zodWbDkSl/oh07gIkldVnTrONBO1u9NmNnyQJT9Zx1pODsU6lgE04pTrjye4xxvPiXTK4XFe4ArtF8noi40OMnKrICAVQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721339739; c=relaxed/simple;
	bh=oy+xhyLxOF6scskKrZGttBuTtQp9Z+cIPmP+Qd92V1g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qvPHRR2Lnn9Mc+fJzmyHmdMJ9HP02CtOYAlLlERocKEvrJ19YzX6iNktN4ER6WU3oczIEfN9EZvCFzryx8Tj4aRLYjiKcRa1vvanaQGAUFd4iti85ne4ZAeHfdL3Hux/KKHz4cl0EU11W0wYJTzmOtOPZu2smvsvggriOgHhKDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zVzFYJeF; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e037c3d20a6so2994301276.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 14:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721339737; x=1721944537; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EypkathlExzRF6s7Pw1Va6Kut8AWRhF2PFYDjZMhs2I=;
        b=zVzFYJeFvDbrFKBzt4FVBnY3JHkMCyGDeNtWE4rds+etePLJqQxkgpfTaZxbNeDeRx
         0h4xpU6AURlo9IWLm5N0kgWwQgKHu3bBFGsWe85/HdHcaffgn09a7MMZVIaIeem/0EKl
         ugQ1azJ84eYUA31mIGrRTFgGGDN+hS+TVTfisn0JWa5fWoiD0WbpWt51yzgw2R3L8XXV
         sIiP3dDD8a/dNTxNTe6q/nkDuT4nW5dizeaKSTwf4AQQxqutsxFwSHDjojzRfYHmrTZk
         YzRExjXpX179N6loqo3G99WfQtj0S6CkMzpOaJICqMHVgqe1Cp2SrWEMNbJ9LX30rsAT
         q5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721339737; x=1721944537;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EypkathlExzRF6s7Pw1Va6Kut8AWRhF2PFYDjZMhs2I=;
        b=EtC5f4as6tABK1mke6D0H3bvEV+7kHH0U2XTHOWOOdV+hQOh0V0/VbVrpkPsq/Q8EQ
         6ZAQmr3mWxOpicUssq502A9NJwCS8Stg436LRLADQ5oU5l0oz94E8Jteo+6udiQfiuyn
         QT8vaxVh6CIfkodnvMh/PtPY0CeAEF5Ml+77PI1Iiti6plwh29Cd640OCnu/1YvILUvJ
         m6ki90QusbXL9x8SwPLdI+dweyrp/kE4E3bkhaJdPwtFSiuot7zchn8YuHUTn3Hb+gEl
         NmvJI2iPqUQAZGSmonuU3qDN0M5tVkN1vOlKC2SNc4xEBDbMAKWLdFRmJpC1LtjpRl9R
         PImA==
X-Forwarded-Encrypted: i=1; AJvYcCWECsFsCdghAjeK5eed+w08Heq0yt7iI3tdbYR+pbAJfDIxvzajdfRYjWCdRJSe/EtaGxvPPr3LibER478phBicSLlK
X-Gm-Message-State: AOJu0Yz/GqpZ6RQ6Rkl3bu462lHwQP5vYwWxbii9iRsVq7Je6jYpck71
	hFNzP4+YTWjl++3noaGtL8G/W8MV12c1olx0y5mBzd4E09n436WMD67ySInZj9PjCHHb4jsA1xD
	umTUu8A==
X-Google-Smtp-Source: AGHT+IFixUR+r//SSF50MMiOX3++HyGfKjJb2WSupKJ5Es5CNqnpttrvuhfPOedVV7rtWVwhpror9bgKMQQv
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:180c:b0:e03:5144:1d48 with SMTP
 id 3f1490d57ef6-e05fec1f9d9mr6383276.11.1721339736356; Thu, 18 Jul 2024
 14:55:36 -0700 (PDT)
Date: Thu, 18 Jul 2024 21:55:32 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.1089.g2a221341d9-goog
Message-ID: <20240718215532.616447-1-rananta@google.com>
Subject: [PATCH] arm64/sysreg: Correct the values for GICv4.1
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Brown <broonie@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Currently, sysreg has value as 0b0010 for the presence of GICv4.1 in
ID_PFR1_EL1 and ID_AA64PFR0_EL1, instead of 0b0011 as per ARM ARM.
Hence, correct them to reflect ARM ARM.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/tools/sysreg | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a4c1dd4741a47..7ceaa1e0b4bc2 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -149,7 +149,7 @@ Res0	63:32
 UnsignedEnum	31:28	GIC
 	0b0000	NI
 	0b0001	GICv3
-	0b0010	GICv4p1
+	0b0011	GICv4p1
 EndEnum
 UnsignedEnum	27:24	Virt_frac
 	0b0000	NI
@@ -903,7 +903,7 @@ EndEnum
 UnsignedEnum	27:24	GIC
 	0b0000	NI
 	0b0001	IMP
-	0b0010	V4P1
+	0b0011	V4P1
 EndEnum
 SignedEnum	23:20	AdvSIMD
 	0b0000	IMP

base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
-- 
2.45.2.1089.g2a221341d9-goog


