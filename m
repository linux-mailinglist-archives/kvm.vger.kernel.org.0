Return-Path: <kvm+bounces-18287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1C78D3616
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25256288804
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7E0181331;
	Wed, 29 May 2024 12:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IAcVHXwg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0295C180A8C
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984881; cv=none; b=SQnNE24ig9fqgVs9FPLTzt91bFZ5SdYwYH/wF82XijndxPsyxTcgal8Ob2DOxAQWz99iGBJrJ9W+1/gp0iRR3td8p8vMvNeWa8fLpvY/SJ3VnBUfLw/tDe1WyaTiRynBhHbDJXS4Qu60VfeKxc8qmjnkdTlScWSYKAJmkozEOdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984881; c=relaxed/simple;
	bh=UZ7wcKpZc50gJ2LcQ6z4UFnFYSLyGvDPH6gSgnrtEM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XaHc1Rsx1JJ5v07UNXabY3nYUQIrN8mr59uayWnSaMWtAGlzvlpHxzHIK4MatWE0SQu96ZLXKpI8JI7yH0k81yZUnUpaF5ACaHGWLZGCa8GG5/YsQQLkO6vUf8Hg13bWhHCCKYwyMKOU+UErtdVmGh0/XGfy1cj3pLxcgahqQOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IAcVHXwg; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a6265d3cc76so111540166b.0
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984878; x=1717589678; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLEJ3O4kV4RVdclClpDnM/s5WQUclK7m/dX1iG4Slsk=;
        b=IAcVHXwgYpD4JB2BvwJyr0x9xBaXhtt8yxtKgrjY93W01BOa+4roKzEKEhqdz8Bsma
         /Bw92o8nRJUYl8K+0Og/S6ZFnof2ClCI+X1Hwt6lAXyDDSCc+S8RQ7e+Xm9Dq90AYKu7
         NWzElOg6sPfFh1SHderhr/oLYMMPohNR0x1najaljOZMOMBRKaifp3MFqt4/HlOBZUC9
         R3LGaq2ZHPWFZdRJ+oijMSZF+QxgWzj7v4IUD0wcKacv6wTBCeO39J06gvGHCYvr40BE
         rvzPxhXocF93XZMfwycblpmUYeOxj1CToiK2kH6BWEY4KBpy2JrLj0eefxgRtSIP9Fkc
         zclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984878; x=1717589678;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QLEJ3O4kV4RVdclClpDnM/s5WQUclK7m/dX1iG4Slsk=;
        b=U3mn3PAd5lyji5SuNTiaUIjZxipGAsM1CguRubpp1iO796voqNqeb5VQU72OWFNKKo
         NT6yQG8Sn/6whpNq/bQFPm4nObWRBkiXzATMhHYS+yhWIq3QPclIo0LBvjaQDouwXw5W
         mSoCzDfSkHP2kId/m/AmJVrznxRjNsFr8/w25hCB2GP6/3RuMPXju7XTKZV0wTwWK59C
         0zWacuOHRlalG7JKwGog0m3xihVM5g9Y8lXnbGj9WDblMvFQBd1+1s4irgSYeD0oj4rv
         Ubihe3+wVgjYcd8HxBUbUXnMJA94J2OjaY1tpLiBMKou0ppGh2fDcZMkNRxXQ5+TJhfi
         tfOA==
X-Forwarded-Encrypted: i=1; AJvYcCUFBHWRIKGTK98UICCzZIo5OGzRQiczhkGYFuJlZsjkNTXx2Aw0mG2OQ8tJ1NvSbopd2+jE0C3AGweIttYI1HIG7lpq
X-Gm-Message-State: AOJu0YyzYAdwUnpCSq2e12kC7CkKwb7+VnkfStnUKNUh4DyirFNbFfmz
	1eHJ+posZE9kE0/c6Xa9VAQyelmwvHCGLK4MzjgKrXfioMYEE+DnXzIhTHXp3PQ1JAUpcbvTCA=
	=
X-Google-Smtp-Source: AGHT+IHcGsvak0IaIBaJRsxrOxRAaw1LTq+hg6b9qMn9Z3a3+Nx+yXco9WUVoWIw3Nxf0/WiUp16udA02A==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:1991:b0:a5c:e96f:6022 with SMTP id
 a640c23a62f3a-a62642e4314mr1531066b.3.1716984878101; Wed, 29 May 2024
 05:14:38 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:10 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-5-ptosi@google.com>
Subject: [PATCH v4 04/13] KVM: arm64: nVHE: Add EL2h sync exception handler
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
index 71fb311b4c0e..bc0a73d9fcd0 100644
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
@@ -203,7 +203,7 @@ SYM_FUNC_END(__host_hvc)
 	 * been partially clobbered by __host_enter.
 	 */
 	stp	x0, x1, [sp, #-16]!
-	b	__guest_exit_panic
+	b	\handler
=20
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
@@ -213,6 +213,10 @@ SYM_FUNC_END(__host_hvc)
 	ASM_BUG()
 .endm
=20
+.macro host_el2_sync_vect
+	__host_el2_vect __guest_exit_panic
+.endm
+
 .macro invalid_host_el1_vect
 	.align 7
 	mov	x0, xzr		/* restore_host =3D false */
@@ -222,6 +226,10 @@ SYM_FUNC_END(__host_hvc)
 	b	__hyp_do_panic
 .endm
=20
+.macro invalid_host_el2_vect
+	__host_el2_vect __guest_exit_panic
+.endm
+
 /*
  * The host vector does not use an ESB instruction in order to avoid consu=
ming
  * SErrors that should only be consumed by the host. Guest entry is deferr=
ed by
@@ -239,7 +247,7 @@ SYM_CODE_START(__kvm_hyp_host_vector)
 	invalid_host_el2_vect			// FIQ EL2t
 	invalid_host_el2_vect			// Error EL2t
=20
-	invalid_host_el2_vect			// Synchronous EL2h
+	host_el2_sync_vect			// Synchronous EL2h
 	invalid_host_el2_vect			// IRQ EL2h
 	invalid_host_el2_vect			// FIQ EL2h
 	invalid_host_el2_vect			// Error EL2h
--=20
2.45.1.288.g0e0cd299f1-goog


