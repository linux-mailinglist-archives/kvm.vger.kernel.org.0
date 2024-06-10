Return-Path: <kvm+bounces-19158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4314901B4C
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 08:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60D52281288
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 06:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E05BC224F6;
	Mon, 10 Jun 2024 06:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bfJ1hRhg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F57A10A22
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 06:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001194; cv=none; b=FOCxCFa04EPTE/MKSn3Gn6IH4U7q1qxlpFk5ZWtrap6thTm6w7crAS5w95YgIJKNBxs9QPA3VzjaKkGeal452xeBA/A64T9u6STpqeyfLiq2UoxyZqBg2HY558uORVaOxA+N4pCU7GhluUjY9ztvvw5Eh/pVQ3Lipxvqih32US0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001194; c=relaxed/simple;
	bh=gHt8zqUvDCjK16BTv1X5Tnkv3fxtChncwef6D10cFcA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NHeTm0mlHnoj4hujLH1AnmROcuykKygXNaY96P5y+WN8mRu8i3HwofmsHmmoUU7bgzHFR3Q5UPnfEcSYJeuC2NIinBuPu6V7DiLcPdJOY/hTdX24XTtMh2kFQPAglkX9BEYAxhypol4XSybD9bSrAgbzXGGDKJHdGw9vxtL2Rng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bfJ1hRhg; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a6f1e2404ecso35752766b.3
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2024 23:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001191; x=1718605991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z0udD/PdRvQwx4wKxPuf11kZ4dOxHkqKwOOLvcn5nZA=;
        b=bfJ1hRhgiESgLCusZ8JBJC3ces8P9x+3B1VJ7e/IJt+KM5iPimW7rsyrD8UGDC4un7
         lslZPuzuG8BeUhuyOsO1PsAiNV0lnSFqKbtXdTV9HRJfOaxPjEvWKWombhRzyh9m0DZo
         ytbo7+YAGmTDxbZ6BKUvJVFSMFf0Ak1YqY8TT6HUlN0tlY7qsVUCSMt6AkCGDQDl/0Rb
         RZf/IRAIfO6p1eRl+KwgVAcyAqPjQXPRbJadb1n2gM6Y8ByJkhpFH1EQ/2MHYlUp64ZG
         li9BI+qVM4DvEt6LfzpPG1p/GfjLcmAsnJE7fwZgejDTZbQ0/NjdDng2hugfZOtaXpkJ
         Vq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001191; x=1718605991;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z0udD/PdRvQwx4wKxPuf11kZ4dOxHkqKwOOLvcn5nZA=;
        b=QqsLO7gnvwmTMIZTAPHAb4dUAN/Y7+5W5LAXvh3sfnr2rQjObdPecxi2cRESz9fnh4
         F1Ja70u/l+VJE0Lln2hMf1nLJKldw035VdeemVZ3zQw1AnSX1NVICUIEddC04POjzCQ9
         hZUN1TLoyo/h0WIDRaUXA9rpVuBL+F9yndUbQ+q6G+p8fFQVSyK/S23Ne3InG49g9aKo
         yWOJRyjsS6ZnKHfsiH3ejeGzdGDe7ARJVZp7lB9wMEcW6u/g9Kfprl88lrJxy/RRKh1X
         82GQoo2iqetEocZqNenrlV1+Ij5kH4OEIHr3CvHpmOBGbyQTmvX64ndTLfafAr7OeQBF
         uhTw==
X-Forwarded-Encrypted: i=1; AJvYcCX6TCDvfPzD8CfKLBpgPHE6FWtbBPoyiCM8zhdtwgroIKIX0aMRdXfz1mmmcAxNHiGOKYUIDfOPjOah/gNvp0XQd76r
X-Gm-Message-State: AOJu0Ywg9mhewpaYKgSKnsliUMKxYXf6sb9J/kfp9Ro3zLR9KZIyW1bo
	5Vwl6OwXFlAtWLOhrlhUa5C6rNvt9DGLbspSdtm4Mt7DOXjFKoxy7BM6HtxV/LKC0bmtSwS/hg=
	=
X-Google-Smtp-Source: AGHT+IGv+s66RkOnG2No4QDLJnAjBEudC4CdDJBYCyTNdZf9o4rJX0PEOZM4CVBe0sIJilA7BZCLdN9lgQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:1cc5:b0:a6e:f44d:3c65 with SMTP id
 a640c23a62f3a-a6ef44d6407mr655866b.0.1718001190442; Sun, 09 Jun 2024 23:33:10
 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:33 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-5-ptosi@google.com>
Subject: [PATCH v5 4/8] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
the relocation table of the hypervisor. The toolchain might produce them
when generating function calls with kCFI to represent the 32-bit type ID
which can then be resolved across compilation units at link time.  These
are NOT actual 32-bit addresses and are therefore not needed in the
final (runtime) relocation table (which is unlikely to use 32-bit
absolute addresses for arm64 anyway).

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe=
/gen-hyprel.c
index 6bc88a756cb7..b63f4e1c1033 100644
--- a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
+++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
@@ -50,6 +50,9 @@
 #ifndef R_AARCH64_ABS64
 #define R_AARCH64_ABS64			257
 #endif
+#ifndef R_AARCH64_ABS32
+#define R_AARCH64_ABS32			258
+#endif
 #ifndef R_AARCH64_PREL64
 #define R_AARCH64_PREL64		260
 #endif
@@ -383,6 +386,9 @@ static void emit_rela_section(Elf64_Shdr *sh_rela)
 		case R_AARCH64_ABS64:
 			emit_rela_abs64(rela, sh_orig_name);
 			break;
+		/* Allow 32-bit absolute relocation, for kCFI type hashes. */
+		case R_AARCH64_ABS32:
+			break;
 		/* Allow position-relative data relocations. */
 		case R_AARCH64_PREL64:
 		case R_AARCH64_PREL32:
--=20
2.45.2.505.gda0bf45e8d-goog


