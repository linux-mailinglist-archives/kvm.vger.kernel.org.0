Return-Path: <kvm+bounces-14088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A74A89ED9B
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFF631F22CA0
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C715F13D535;
	Wed, 10 Apr 2024 08:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MtXkiz7t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F72B13D529
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737751; cv=none; b=Y4P8NMv7a8xCntqgRo9T8M+Oji0WW5t4PA07TJaKls57Hg5Jf0GWEqB15TaS3XdNll7WsAH820wwyEalcjGkulSmIL69p82oofWh3sITTzUeonxCABwkgwBsTvtY8ajcbw2r9S/QLsbLTrIFbJ2xzYmiNA1tlDWnDjDfIu+ogtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737751; c=relaxed/simple;
	bh=kgnqMQDzRwAX/8s3ORh3D/qKYGRwk7ltldtZkzXhbzU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kb3nBrlgSlPXxN6fkq9LrreQtz9AgvYpT3Q9o/XoEpR/OSv0EKaREexUStNaGhe+EcZj6jCiR/offwjYXErpZZ+fJ6JCps/SVaWwbjHUTKrne79EadJYWEyHVvFT1jksFJz47XdZPLtErPkYWdPjz04vEXiE34HyS1ONKBXYTZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MtXkiz7t; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a519e1b0e2dso672989766b.2
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737747; x=1713342547; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PGd3bMV1YAEF5Hagbbpcdm+V4PDQlrcvcx2hUHTQ9g=;
        b=MtXkiz7tTmJzC58djRthp9IB+Hup4dsd3Qz6DAK5204q16qYs+S8rJxwZ0FiyiTKnw
         7sL4/ou55n966tSQq2oHb0PkC43ZN8PcqwvtXXDqomHHlxitHE99Yc2J/1aklkPHSyVR
         GZgfC7oKjiPrdomriA5MLhzvDmWiGisKBRd2XuX5HmVB2Q8nJXRYhyHoT6h3mJPPBjRG
         wD3VtovyrVQHzMFbB0Q8rgX5w33+7GUFpqNJzgvaMVG1HvZADIaXPFGfXzgcNVslMAIj
         RgoSfshjJXp/2+fhng7yCIp5MyBcvfRkrOamPsXzbj0+nwodBUbxmf3Cg7yFqMUv3c8i
         XBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737747; x=1713342547;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3PGd3bMV1YAEF5Hagbbpcdm+V4PDQlrcvcx2hUHTQ9g=;
        b=sAokYbDaqFsDsY9x4+eTqY06WBSat3SOUPQ655KX4LqSglrciVB+pGTMWjMs2JS5Od
         fZ2OBFb/WE+jVLofq7bOCXkjN+ZkLEStvPHtZFo2kPU/Jx7+GfDFER/UYWw6k87S0KTT
         s/JOIvWIGpTxxcz3tRZAmKcafzk6LYKQaLPMFRepr2/d3Wj9R4wezEH3lYLTqp1oiXuq
         tGB88QNxBc9nGVM3Rd2WuP31v2HhLmjt23G0o6FPAV24UwnrZIoggZYFUwVPfoLdLxJC
         2owY4eyXWaPzXqbeFPfWx39ls/Uo1VSWd4ErVFAeiNKVc2kREkKLLDvZ01RHKQqcGLsC
         5sVw==
X-Forwarded-Encrypted: i=1; AJvYcCUhbOkH+iN87S0jPUvUsi1wjnvYjfnzDUZCCi7stbruJhAO+ubfJV0V4NRfOuIunNccJs93MSIssOrxPAz39o9IaktE
X-Gm-Message-State: AOJu0YwbEJ5xf44UeXOBxLcsscmIwiNqMS1AzPKxDwqCs4xCsqyzXRNh
	ZH4CdKJfDtwGZJu9IFkQNilwZFyIqf45TkmlIDaAwNCngo3nz2sCr8gDXOq05w==
X-Google-Smtp-Source: AGHT+IH61cn+dX4vldfSxdcYm9FVH61Ciw9ZsCjHLsITsN4DKWMU3FJ45IW/shiIDSzz7xSZXKNICg==
X-Received: by 2002:a17:906:490:b0:a51:b326:ed41 with SMTP id f16-20020a170906049000b00a51b326ed41mr1201398eja.52.1712737747375;
        Wed, 10 Apr 2024 01:29:07 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id jx16-20020a170907761000b00a5197fa2970sm6678498ejc.25.2024.04.10.01.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:29:07 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:29:03 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 06/12] KVM: arm64: nVHE: gen-hyprel: Skip R_AARCH64_ABS32
Message-ID: <iyqimnbc75g264riny63k5y3tujiz4frzsexaiy5pjnla4cvfi@xzvncd4em5cs>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
the relocation table of the hypervisor. The toolchain might produce them
when generating function calls with kCFI, to allow type ID resolution
across compilation units (between the call-site check and the callee's
prefixed u32) at link time. They are therefore not needed in the final
(runtime) relocation table.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
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
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

