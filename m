Return-Path: <kvm+bounces-65024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C67E9C98B35
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 19:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 853243A2961
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 18:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454A9338582;
	Mon,  1 Dec 2025 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M/JVB0yS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E842B3376AA
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764613284; cv=none; b=NSeW992OzWTUkClle9xTLB86AH4yZrP3/eK5EhToO5R0d53ZfXQG5swyOADw1Dej3xA/fAeTFHLqnZbYxdw6Jm3VR7upVwqUjMTZ/WGcBd02mfW1ZKRdOFcVs3p8EgwH/RycGvu8Klf9Jh8/vlOIw5zU75QwenCf+Dm0SszLMxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764613284; c=relaxed/simple;
	bh=7vOZlkn7KxLEHBeqTq+/468rlp4RUVKGCfWwdJqKCH0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TcdqywBZ0FpQjh4AmWpHiiLfGY7iwbGiHiG1WO8F7WdJzQXOXZOS0IxhnaeA6yQ4pkGhIt3dflqfbqKOSZCithFtTGsrK2hIvoA8Eu9mZTUVFH8EROmrEs/odsWZ4gTXn9muTlWxkxe/picCH4W5emCKsd09cdAMHTvqW2c+DaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M/JVB0yS; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b71043a0e4fso489087266b.2
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 10:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764613281; x=1765218081; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=odX/ox3aZ6OfRTd6Iy2+oa0/EpTihBm90P4xNQBVkvs=;
        b=M/JVB0ySVXymcIbEhyQdjNGYxszF9FHVuLqHWOG7n6QpypVqOE3J+gdQkqpdFTk4FW
         +MMTqp/xJ0zvABI6v0uTY6i5cp6bZOfFw6oz1DK9aB8lbUDhqMH5J/r2EWrLn1TEpdpi
         +suoYitCWoDSe1jza5bTnT0TWDQPX8wDclUZi5nKunWuDyxBaxkdtHrkDNcGBq3V1PZu
         gZwSr9Pv1vurj0iBN5JJ+Ot5FtiWvssMrY/J70Jh21FrQZSK4zuwH8JuiYMQFJMnwIxf
         U222NNXhPNnuL+IIa4HMzBJRXoWVsD8O5dkdtxOsuPtak9bfYQJvJ0vAltwCXjAshf47
         5IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764613281; x=1765218081;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=odX/ox3aZ6OfRTd6Iy2+oa0/EpTihBm90P4xNQBVkvs=;
        b=IZi9Sfiyhjf1EFV7Yla+BmpS2AJvsbVFDXGmG1ckPBzFsgmNxKWBZ+4Fxf0pBpodAw
         GRjCxUG4zmjDatrdyRftobMlbt1DyVJvayrqbv9bb4fSBkaVioxNDXlEwvIPQggkyQ0R
         t/Jw8Tz+TAvBfnKIykK5cuztvSM9DaPBZgpGj40ShKvR/hxOZlpZMr6AwOhfWXUQIq+U
         ymDxQ/TaZ3fKmIDTYbCvdIEOJltctw9WiYRLhuRETUfV1rzK3Eikb9Dwz2ufj0A/5Gtg
         a2v3TisibkGZH2GOJMU9Y6+QrHqFOBFKsfdc8jykIqeBmPRsvCm1Kh9qtzznFUDuWeGg
         KCfQ==
X-Gm-Message-State: AOJu0Yzw8u/9YAkSqDhXPPXrr2Qa+/pzYC6QMwv+Ta/BJfZH3shRMje2
	T4rnS0KDdl2eFevOop7PQ3uY89nalVRua5GDCec90ALeCXeAFFaftWoZqVgcQUYTmKQcTsrxNTf
	Pr2AuPlHYL7PegPyW7neYwipU2YoLoisJejLZ/dQ8+o/J+eopBYTKXdwJTqpsQ99iTgJSWvEdpG
	0kry71HIwApKyUYpS/HOSOJWwNEGg=
X-Google-Smtp-Source: AGHT+IHh8EB3gV32tWgbXZNPjCoJvYZ5NAK7xEFvEDfY8RzeyPbORY5fp6hyi+V7tHYcCNBQoIRQPJhBGw==
X-Received: from ejclg11.prod.google.com ([2002:a17:907:180b:b0:b73:69d2:27b7])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9610:b0:b73:870f:fa2b
 with SMTP id a640c23a62f3a-b7671596300mr4237213466b.27.1764613281291; Mon, 01
 Dec 2025 10:21:21 -0800 (PST)
Date: Mon, 01 Dec 2025 18:21:09 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAJTcLWkC/x3MMQqAMAxA0atIZgNtQEGvIg4lpjaDVVJQQby7x
 fEN/z9QxFQKjM0DJqcW3XOFbxvgFPIqqEs1kKPOk/MYbMOyMTPuVxar5oS8RBoiUXB9hJoeJlH vfzvN7/sBPmjymGYAAAA=
X-Change-Id: 20251201-arm-smccc-owner-arch-cdf29f22a06f
X-Mailer: b4 0.14.2
Message-ID: <20251201-arm-smccc-owner-arch-v1-1-71f7d75f97a4@google.com>
Subject: [PATCH] KVM: arm64: Use ARM_SMCCC_OWNER_ARCH in place of 0
From: "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	"=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Trivial change to use the appropriate self-documenting macro.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hypercalls.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 58c5fe7d757274d9079606fcc378485980c6c0f8..3e7fdbcc6411f658f5cec818bfa=
d2e97711d37a7 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -126,14 +126,17 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *v=
cpu, u32 func_id)
 #define SMC32_ARCH_RANGE_BEGIN	ARM_SMCCC_VERSION_FUNC_ID
 #define SMC32_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_32,		\
-						   0, ARM_SMCCC_FUNC_MASK)
+						   ARM_SMCCC_OWNER_ARCH,	\
+						   ARM_SMCCC_FUNC_MASK)
=20
 #define SMC64_ARCH_RANGE_BEGIN	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_64,		\
-						   0, 0)
+						   ARM_SMCCC_OWNER_ARCH,	\
+						   0)
 #define SMC64_ARCH_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
 						   ARM_SMCCC_SMC_64,		\
-						   0, ARM_SMCCC_FUNC_MASK)
+						   ARM_SMCCC_OWNER_ARCH,	\
+						   ARM_SMCCC_FUNC_MASK)
=20
 static int kvm_smccc_filter_insert_reserved(struct kvm *kvm)
 {

---
base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
change-id: 20251201-arm-smccc-owner-arch-cdf29f22a06f

Best regards,
--=20
Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>


