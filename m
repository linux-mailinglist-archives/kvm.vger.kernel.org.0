Return-Path: <kvm+bounces-17171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F2778C236B
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 13:31:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 197D1287C3A
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 11:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC905176FBE;
	Fri, 10 May 2024 11:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YMgX0NO8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82886176FC0
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 11:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340458; cv=none; b=UOMqdXxA2tXcCLHjr7rfkXGWZb74XWgXQDQjUXTimYNJ+fKV76oqQsv7d3o9R8Rz9FmcUFjAGPI+5qmf+H1GcGoZDWXwZpAB8IlvEee7CPzvRrzpOwcGOL1E/9grQrcuu2FtHdttOqXhqVOhFapfdsgoMTQdxQYmPja0dXzmdA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340458; c=relaxed/simple;
	bh=UDXy6AJXVdSAeErVZLumP8NwdL16orqGjCY+2++AVXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YjN5b8GFUy1XR7FHTs498OT5ClUToiv9FeRQ+y3hyGYfX+IvVTrt6ZG3mnO/F2xhmVP6H135Ui44JHof1iNVI+AIMRdxzZPey7dK7l/HVR1V/IwwkBhswPe0tj1Hj7bdmKUQQEogvl3y39LlGEksOG0ZsXRnibmXFrSWX9J7JKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YMgX0NO8; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a5a180153aeso122655966b.3
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 04:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340455; x=1715945255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8DKhkb6dSizyRVlRq/XnhdKj6+BlqFPiK9mn9/+w2yc=;
        b=YMgX0NO8i2ruahaVrrW2lhzPt2LjHkuIuJ2hb0+wk2WexIquRAmr1ucakEZO4F1q21
         Gx8X+IlF8myaM6hjbhQEK0wPHSS4Y6eawrDF/RPkkeO6aAG4lIPuE2x1MO2Ya7gmW2ku
         TvoIWct2ef5+ymwL+Va8qdf1VpcMGqoq9jFqBZnSDvrndzNgGh0yeVX1197I29bLto/U
         DVT8a2KlEoGq9cq05XSWvT63UrBg9Ag1Bj8pOfJdsEcUfrIAS26a9/oPLu2osdQco8SB
         BekGdFC13k+ABqjYK3rs+fgK32xBpEIqHfw6C8Y4Y8kSvnL63eYPFLiPSyUwve2byYqe
         KPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340455; x=1715945255;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8DKhkb6dSizyRVlRq/XnhdKj6+BlqFPiK9mn9/+w2yc=;
        b=okx/+nQ1H/OZt3oWBeH49KwIx68qlQUAw2/a8PxFU2XLCbIh3q8lQhjzgmCSUEw2s6
         mwUBgLqFQbO67YQyXNdQL8+hO8eTrycwzG9adBCY+ztvfxxfSayPKgWVXlibuOPenNtn
         hlwXS+2PIpwTp4fol36QLB2D8bdgzpqfdr/IQ2+OQosAYAF34ln6VzXSGwNG9E4fFdGT
         gaHO+3B9Y2SuL3lbUYvzvT4kx4NEnveWpzOmVgaRLhTjgVqDeztdSv7CZs7Lcqi6CiSG
         2ADcPMUhNCWRSCMDHg3wSRFVJTEoukFQOCBYzDCJwdClK+HAHg6/pzQm2FIf+WqsqZJc
         gUWw==
X-Forwarded-Encrypted: i=1; AJvYcCVHVTiiHlF+IBCoWQ11o4qH+qsRLoK3GmarPU2Jz0a+BzkgX8CwwTu8nHBNcmpnPd0K3E5xxxeDYGBWA0ParGrSunTW
X-Gm-Message-State: AOJu0YzKNSHyj1Ns9+70MbK+BAsxXOpxGg2grczQugxqs52IrMow7gld
	UWb5wZvmgVvrGbQ9wpzpgPrN+FP3XphXyVlJMevfPhkLMdVD108AXApTu+dwKm3OVHx6/pIdhQ=
	=
X-Google-Smtp-Source: AGHT+IGkpwxqeSN6EavlDA+BXVJp1GAbnEIVQnql+hC6cCYj3jthHFCaBNvnkUk/0Xp8MBeg6nGyR3xjIA==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:907:d383:b0:a59:dcdc:a490 with SMTP id
 a640c23a62f3a-a5a2d65d604mr184166b.12.1715340454681; Fri, 10 May 2024
 04:27:34 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:36 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-8-ptosi@google.com>
Subject: [PATCH v3 07/12] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Given that the sole purpose of __hyp_call_panic() is to call panic(), a
__noreturn function, give it the __noreturn attribute, removing the need
for its caller to use unreachable().

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switc=
h.c
index 1581df6aec87..9db04a286398 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -301,7 +301,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -326,7 +326,6 @@ void __noreturn hyp_panic(void)
 	u64 par =3D read_sysreg_par();
=20
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
=20
 asmlinkage void kvm_unexpected_el2_exception(void)
--=20
2.45.0.118.g7fe29c98d7-goog


