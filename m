Return-Path: <kvm+bounces-18289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 105C18D3618
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40DE01C2362C
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B09D181B94;
	Wed, 29 May 2024 12:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SxL5x3rk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AA6181B87
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984885; cv=none; b=TJR6TZUyLR22P8VrA11S/9/MRz1cLRkfTiooaNKpPFFnGxYkuASTxDWfOygLBChh0AfPZEgoom1SUgVXLOtMVdSvoh7x7YpBUzcbgrBolJSTnSlvK8vEMt4dcAOvgfjP2VKp2puwmq44XCZNQwC84aCkv7M3tL7OqMomjf8JcII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984885; c=relaxed/simple;
	bh=+cKcneugNDE7L/qpVl91ixp1M6xylMEZ521Xa4hyBQI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vg+9FPmYeNp/xQBbeQNataBooBc8PuDFBUfTxOxRPSf9ALjYS6G7pmZLsdRtXhM0KYoZIpPyLS4Hylx6F4VYalYtQtPFQDd6AiLChnCSMsmYSGAawcNnCKeBXeGvrPCYIrVwoTpxV8SQW+KDuk+3hUDlYtIjRhvuNTCQLTlzfEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SxL5x3rk; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a50486746so27729687b3.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984883; x=1717589683; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jFr7qj90it7wD8ycil4shHE/w7boH3XXa9rQ6TceJ7g=;
        b=SxL5x3rkad37Ye+46JX/VG7oHFQS9sK2Z/zbLDApvqy+KRko4D+fOpcdGOYUyNswxN
         mxIbQi9dv5tvtjWfcmVYBOmybVQJVRLW1StIg4Y9zFKORLNsBecj9H1YJdLA8rUvu06T
         tKtJYRCHw90BrPrcEKnaWFOsV6SFp0VfsnSyCFEWCpk1lcDdVzRFEQkSNqHBMtlK636X
         Bd7tq9byjUPWiJRMAHd7YF1FLany+9aFEHjN/lGXBiENpFJ+V6OKVHJObwwsGY4PyfFo
         hXFxvSpkiIY1lX/vZpdlTLzqCYZHWAcKrX79ww/g43YmU1UnF7xM/LqOTgEoDCro9P9G
         rOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984883; x=1717589683;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jFr7qj90it7wD8ycil4shHE/w7boH3XXa9rQ6TceJ7g=;
        b=TfqbGYZi0VoGqlNlLiXfbs2CwHmZel15sERXRu53OrFoyIt4/l98qKRT4GCa0kv2ud
         /7vlqtzwnL6amfPRkN97bpm2hnQYwtpGSIORp1Xiq+p3z8H2TzEe/Znh83YkQExbQQph
         2PioLui8a6Luzc2GBrL4m2iE0A4QyJMZvVEM1YRcQOodA/2uAiJCin+MM36HXdEYweKm
         y7/3z+APPluIC25DK1/horRi+3vHcEF/1C6c+LdloLPR8i6qOGfwvhkmYoCwaq6DL+Sh
         b8CDYGDLm/Vi8zZnWYMVVGh5iJion0OxUn5wPMa9q3eBPOj35p45cbHqAaL17Wtba1Sr
         ASRw==
X-Forwarded-Encrypted: i=1; AJvYcCWbuHG4u0zdNKnJeXlny7vDfbtAuQB6LaM4iQopQGF3rN6Y7H2tg+UPfCRi5f/xfJF7HDBRQtHpypu1MpypH/qHg6y8
X-Gm-Message-State: AOJu0Yw/bo+9p+QoCc2nv8sjqybJk9wNxCkKEgL3pGn+/OUhPgsEAMVe
	BVwNtcTqYi3HrTumjFxZ6X2hst4nPzRB4J+Na57QVKtpT9xl7gUVhQCNulu6bdrSQ420RMqRpg=
	=
X-Google-Smtp-Source: AGHT+IFkqfeHx8YzJAunywpRdidgNdjLeTtWgg2p4V4vZYTrR/3mutQzX2qxXb5fN2wPSUT3J1iB5pmTTg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a81:4c56:0:b0:61a:d0d2:b31 with SMTP id
 00721157ae682-62a08d9304emr35784307b3.3.1716984883084; Wed, 29 May 2024
 05:14:43 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:12 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-7-ptosi@google.com>
Subject: [PATCH v4 06/13] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
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
2.45.1.288.g0e0cd299f1-goog


