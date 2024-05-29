Return-Path: <kvm+bounces-18290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF658D3619
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E8411F260ED
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A1918130E;
	Wed, 29 May 2024 12:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GXtuJn9H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47593181B95
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984887; cv=none; b=HjzVY1jKan7zTggyhluu7yNbUSqH62lJ9YDQmPFAL14bgaPg/hs9Wkh3B7ZuG2O5rfLMFZ9kqZxIBcVDV4yCTOUNhTxojU5AGrKyUig4xyr+l8Z9Byaw+WgWzC3Ty1rVWZ1LUlngzn3AvtGNsRCK6mSDZSb981gjtUYoAldAS5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984887; c=relaxed/simple;
	bh=oY+YSwPHFqVVY3fzP9ou/E6BfHn7ARC/H1gWBIAm1+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ijrFEkoGCH0D2vyCxov2lt1hnE4t4mam0zyLjWI0zLvyA1ibYiGh+vNuYdK2m1+wSj/EJVm+02B+8bYQp93g74aDOUx1To2fP0Euh1N7bflZsSt25scgkAsRSkaouL4c48sgRsGl1Bew0LCXlMj3xRV/2Z2br2hNLiqKisOc1OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GXtuJn9H; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627f382fb97so32315897b3.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984885; x=1717589685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8LApYKgBNKEpQOUHCgPJ8rjKQvWvAO0g6PQmvtilIlw=;
        b=GXtuJn9HxhEM67Djw72HIPG3Vbsx/FqU15ckzdvn/tfUQXLGh+HpqlFormN42z5psV
         d6lhQHI1iozKFommHGTa+ULyWO4pXBYGamNklv9PwYVn95syjy8l84FuBVLjgvJPUNFM
         ibTrNBYmFH8Pz2U7KvhLq+fZ0dmNt7/hWeZaZV32k4Wp26AYn5uD9O6TLchlwRYTLK9S
         IpRLiehtYYpmyPAt3AZ5kkKWzKoi1E1mnQqF0qPWKvg1218ZZGylTBu867lHSjvSxuF8
         dMp55l2QpbVmF/w2Zib+EMBJPX2ioQ6UyGdQO9FBRTnNXW8gKeQvdZQI+2DgVAc/pgiQ
         zDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984885; x=1717589685;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8LApYKgBNKEpQOUHCgPJ8rjKQvWvAO0g6PQmvtilIlw=;
        b=gpdQoIONzHYTeUNJvPA4FU5IYibaVvcGcI3GHD19MQvr9xfw5jgEEKxqW+jACMFWYH
         UHewC37GTDSPuudZFGnV2gCtSVdBO+3Fnm+3HWaBJKfg8AjW/t5gbeR6cHa+3C7tav/z
         RkZXPe2pinEiVtr/JLlBNeXFZqdTWyWH+anj/nP1Pf6bIuHJ6C5s2uer5UWzUtVm6Pvc
         O6MPlU+PdzCye6i8tgwrSupHPWowbNf57YZYoLScis5PjMGuGf/yqzcqUqGTmsp/p9+o
         CFK+eBSkbyI5EbxdV4JaXBhbZGe8LqdjovzmrZPhdGx3bdPKTblys91dohW3DK0GjKDV
         D7lg==
X-Forwarded-Encrypted: i=1; AJvYcCUeckmo9uRGmvmbiIO+aGD6aNdHI6CsHRkF1q1iXgNKNPS+YhkLpw5/r7Ue6H0+EREYV44aQtnJxzE37l/QkcVoNZFF
X-Gm-Message-State: AOJu0Yzkob0AxQNxn7xiP9/B4ggMJVcFRvtdXPQPIcuC/VeqbpZkLBkI
	tQBC+0Rpg6Uzkh5QF80R3+naGIaVKEh8PvFoJDrwqjg0i6+Z9jilccJDlme7XQ8GvP+/S1btDA=
	=
X-Google-Smtp-Source: AGHT+IHSjvv323m46MNf64EsuTBJ/plesPXi5fnjH9bpFqNhZzaJSI42rMp8TuTkGGyShh9t0w2mdhFYDg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:1006:b0:df7:8c1b:430a with SMTP id
 3f1490d57ef6-df78c1b6af8mr3075741276.3.1716984885370; Wed, 29 May 2024
 05:14:45 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:13 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-8-ptosi@google.com>
Subject: [PATCH v4 07/13] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
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
index d7af5f46f22a..0550b9f6317f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -384,7 +384,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -409,7 +409,6 @@ void __noreturn hyp_panic(void)
 	u64 par =3D read_sysreg_par();
=20
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
=20
 asmlinkage void kvm_unexpected_el2_exception(void)
--=20
2.45.1.288.g0e0cd299f1-goog


