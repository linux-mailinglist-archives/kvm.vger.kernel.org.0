Return-Path: <kvm+bounces-17169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C03428C2369
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E36BA1C2335B
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85A517557E;
	Fri, 10 May 2024 11:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jnzy1UI7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EFD17556F
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340453; cv=none; b=hm7vSIXFH+vpf4EpX2FIajYHPnoOgu4g0e/TNOgdv3EI626KmuHcnfOIqup1szHckhS248m067/RRhCTzpQ9W7hwLWz+rZbXvJA/o5VvAOjiZ4whoATkpkKJpGY3cN7FLMac5iTVZt1Vd0W77l6jYRhUYiplr0sbM4imHfODNNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340453; c=relaxed/simple;
	bh=RuQZrcKwOHj3TG5Qgns1mzsOfW6oRw1bJHQR20VMa7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mPzqjgS58by34BrAjrjOaL080fRSB/gxQbHLGDIxlAJRHIFmfE1p5fN73iwJdtvvKq4X8RjTcP4/Rb97ZyKD8YAi47FBau6pJL8YXmR3+FINBkETKDNAP9/bfwOpOFAj7owOmsoml0tGFkPx2HKxEiIgjuS2ake+KD4R5jjYBn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jnzy1UI7; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61c9675ae5aso30498807b3.0
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340450; x=1715945250; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qcEzQNh9dWuFIVjzg9t8TylWGTumh3MZGtqI9gQXfso=;
        b=Jnzy1UI7iv9I62lwksYuhu2v/nnXCrKXmtbzoUXJq9HQdxPJATzHZDpr2s9m9KdThQ
         ithu8kcOjQ7FxYSaBQtDW/oMmCOq3LeqMFJ1gAwJ7i80SFP2KU2KX3/K7VN91yucBJFI
         0Xw7n34EXcmWm0fjmMReokZ4VQMb/EnooaCmR8+vkKVsPv4S8YGMVk6LT21h/hEFNsKS
         Xmd0cIe5L7Q97evxLQZAE7jLkrEKMiFBAdZyrXDSKPYRNGWKyTdH2zVjCfYtciad7sHo
         EM1owmxCn/v9beyx5nt5kOObIoIQvs/yHE84oF5beVY2JrYk3Agblg+YOpsk+O07eS9v
         TNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340450; x=1715945250;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qcEzQNh9dWuFIVjzg9t8TylWGTumh3MZGtqI9gQXfso=;
        b=dCqbTM45KHcMckuEX0IkX+KLH7sRtnrBueBKetlM30Rcr7iFJN3kJxbqjRpeTfIyyb
         cSDjjz+mw1OHhBezBhXoKveyLGuwGFz8btRENZzfJO4aXXgx19S96zuXz1dbUg9usAi5
         SOjG7NRQuK3bQJ2ZIIxNrutbEM3lF/X07x8bD+JaXPl/7h1Hzi5EyOO1vP/oHTpugB2x
         2/kNNrBAsqOFsHPhY/6hp619hNcA78WLZtPvcl7vHym/6y0PPDG5FGh4OC4GPYcElbuw
         OGwzJjYB1IsMEexWUYdpjEOhWrPZHMAvoAS7nGE474pjlDm2PmMPq7TX/gsGIeBjB6ZA
         LQwg==
X-Forwarded-Encrypted: i=1; AJvYcCWhbl7xR5FooOjLt5LI2cJ73P3jGMPUZGKcxSy5LdCoCTpJOFvxVPbUyAQRRe4twLaW9f6yLjHAXcnCp7jn1IUeIruO
X-Gm-Message-State: AOJu0YyJlUddVYYyjIOjWc6Xw7kkMTOu5Q+mGPVgm1yj4bdSGUh4k7Hi
	hcLQjRo/x/jzFSQYh6F09HKqdEkraOdMQZveoHDsQUUOF89x/wFEFdzqyaBdv2bUaPLw3uCSuQ=
	=
X-Google-Smtp-Source: AGHT+IF00DsgRNr4wMWPoZLxFG4BzAtNHmn3WH+94RNNB3FGneRo+0N3ZZ2Yl4THjXTnNjJION1G71wXVw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:690c:4507:b0:61b:3b02:6901 with SMTP id
 00721157ae682-622b001dd60mr5562717b3.9.1715340450084; Fri, 10 May 2024
 04:27:30 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:34 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-6-ptosi@google.com>
Subject: [PATCH v3 05/12] KVM: arm64: nVHE: Add EL2h sync exception handler
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Introduce a handler for EL2h synchronous exceptions distinct from
handlers for other "invalid" exceptions when running with the nVHE host
vector. This will allow a future patch to handle kCFI (synchronous)
errors without affecting other classes of exceptions.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.=
S
index 7397b4f1838a..0613b6e35137 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -183,7 +183,7 @@ SYM_FUNC_END(__host_hvc)
 .endif
 .endm
=20
-.macro invalid_host_el2_vect
+.macro __host_el2_vect handler:req
 	.align 7
=20
 	/*
@@ -202,7 +202,7 @@ SYM_FUNC_END(__host_hvc)
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	__hyp_panic
+	b	\handler
=20
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
@@ -212,6 +212,10 @@ SYM_FUNC_END(__host_hvc)
 	ASM_BUG()
 .endm
=20
+.macro host_el2_sync_vect
+	__host_el2_vect __hyp_panic
+.endm
+
 .macro invalid_host_el1_vect
 	.align 7
 	mov	x0, xzr		/* restore_host =3D false */
@@ -221,6 +225,10 @@ SYM_FUNC_END(__host_hvc)
 	b	__hyp_do_panic
 .endm
=20
+.macro invalid_host_el2_vect
+	__host_el2_vect __hyp_panic
+.endm
+
 /*
  * The host vector does not use an ESB instruction in order to avoid consu=
ming
  * SErrors that should only be consumed by the host. Guest entry is deferr=
ed by
@@ -238,7 +246,7 @@ SYM_CODE_START(__kvm_hyp_host_vector)
 	invalid_host_el2_vect			// FIQ EL2t
 	invalid_host_el2_vect			// Error EL2t
=20
-	invalid_host_el2_vect			// Synchronous EL2h
+	host_el2_sync_vect			// Synchronous EL2h
 	invalid_host_el2_vect			// IRQ EL2h
 	invalid_host_el2_vect			// FIQ EL2h
 	invalid_host_el2_vect			// Error EL2h
--=20
2.45.0.118.g7fe29c98d7-goog


