Return-Path: <kvm+bounces-19157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72378901B4B
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 08:33:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 117DF281402
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 06:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D73420DC3;
	Mon, 10 Jun 2024 06:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4P5KDlEO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA54200C7
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 06:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001190; cv=none; b=CJKurXGem8NREKDSrLXbuGhRsj2o8DrRLvL0HIoIC3uMlr6w89DH9OjuCfnCKX4JWfvi3P0omsFANcIMsYwWGpAdnNf2bBmd3TsxSv62c5Mq8NOHoTRBcPSGWumztP7Ilm1ekOSbWH8cdx8p2r1yi59X1xL0/PVr+WDN2bo9XzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001190; c=relaxed/simple;
	bh=4sBy4q9o+2XAwUMDPYKyMJ3gbWzk4GYah5sqC1TOQ/c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k7lRfBd2R4sGzc+eexyJHJROtmkMnbVu2rU3UmU2ugDI0qLU7d7yH85fZ7vvv1REKPP3iQr/K4anTn/6uS4+gRoir9cJ4L+EipjDS538iKc+vNLjnslri2j6bMc7YHUSmd55anPZOrzqGvSBPzdscSy16XRvZamzq1GzzFmXod8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4P5KDlEO; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfb0acdf0c6so3815494276.3
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2024 23:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001188; x=1718605988; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FAg4zwCV0ETMYk7uJAuzLLD4Wj6HS+UWIuwSFsyOCeM=;
        b=4P5KDlEOtBhnk0MWsHkv64l6GlsgWsGxGk9Kf92a68Ze2O33lFG7CVe1LcAKOqYJFI
         5K7CI0lp/IVPhPyzLvdraHEJ4BwRGME3KecvDdDE0nSTJSZdH4YPg2ZF4rrL9jcmyez8
         +SDtzQpIpiJ+sorhVZzGD+PUnfVXJmtQhlOW4buqdojGj8Z8qrGYxbbZgFHZF8nmOHBv
         D8GmuJDxLn/6GYtHTq81Z0RaLMI455hHl8OBdRt3nWAmCZzZrZSlm0dYBkzcgIWqn+bq
         zGCyY4cyEa1lgvKWLdpaitBGQamg1XZkKwOkac40JATfXXAkgi+3scxRG+IKrQfVtF3k
         aZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001188; x=1718605988;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FAg4zwCV0ETMYk7uJAuzLLD4Wj6HS+UWIuwSFsyOCeM=;
        b=UWJXMeNuDNWHbMAwRsZhgMiXPDQmadva1J27kHvnFQLcbrRzMDVpkXT2loKgAH3xer
         dfEXjGfCwgpCalG+XNUfWXYAnwkgfj0am7CqQtkCOttaLnVaATdOWfTRyISW8b2k4xVZ
         O/eBrCGarSsjfttGk4LyfEppEyqZRa1NEpubXPgD5WSGQwXHdX86HS5P8c0hIy4fypmY
         fw2NHFwuWBQsU0dsPlrNcIjnXZNtA3FCiDdklyuEWed4YUpc/+yG9JtxprTMmSR5l9EP
         wRjshKeQ9qfUoL3get5d2PNDvdGsDIpYuBnSc/RQuvz5Qmtocor6F6MWSbtoOUmEXUIf
         3Tsg==
X-Forwarded-Encrypted: i=1; AJvYcCV5cGD3CG4uFbAP//XX3PUJXeqLu1iVvl65O699X4hhFiVPTVAAajPGSpFbFUnS2AN0BZSH+4ufm0W3qm1J3MZeem+l
X-Gm-Message-State: AOJu0YxrymxuQPAiMR+QiOzK34UYl4Erca2BkYib0Ms4nnON/nfRNNB+
	K7Jqly+hVP/dXgVMYLW0q6ko3Lus/YgrWWaMLTaHegG7x5cqfNeNlAnUwTRz3soSVUiqP327bg=
	=
X-Google-Smtp-Source: AGHT+IFreq9wyxrRYtilc13+BKJ6v9CVdYWcuPyBidJggSdMr5wZPl1j8+ICTd1AZf0bVymxH29Mv4wpGg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:20c5:b0:df7:b717:10c2 with SMTP id
 3f1490d57ef6-dfaf6524ed6mr2518522276.2.1718001188121; Sun, 09 Jun 2024
 23:33:08 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:32 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-4-ptosi@google.com>
Subject: [PATCH v5 3/8] KVM: arm64: nVHE: Simplify invalid_host_el2_vect
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The invalid_host_el2_vect macro is used by EL2{t,h} handlers in nVHE
*host* context, which should never run with a guest context loaded.
Therefore, remove the superfluous vCPU context check and branch
unconditionally to hyp_panic.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.=
S
index 135cfb294ee5..3d610fc51f4d 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -197,12 +197,6 @@ SYM_FUNC_END(__host_hvc)
 	sub	x0, sp, x0			// x0'' =3D sp' - x0' =3D (sp + x0) - sp =3D x0
 	sub	sp, sp, x0			// sp'' =3D sp' - x0 =3D (sp + x0) - x0 =3D sp
=20
-	/* If a guest is loaded, panic out of it. */
-	stp	x0, x1, [sp, #-16]!
-	get_loaded_vcpu x0, x1
-	cbnz	x0, __guest_exit_panic
-	add	sp, sp, #16
-
 	/*
 	 * The panic may not be clean if the exception is taken before the host
 	 * context has been saved by __host_exit or after the hyp context has
--=20
2.45.2.505.gda0bf45e8d-goog


