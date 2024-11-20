Return-Path: <kvm+bounces-32160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA4CC9D3D59
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 15:18:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FFC3281255
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 14:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96F51BBBDA;
	Wed, 20 Nov 2024 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="AZCZRucq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846301C879E
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 14:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732111795; cv=none; b=T3xm+82OftezFzxB3dtdwy4K9E2URfrI02eYcJXbIqBqV62m4IpmyPzSySyddZi8AdPeXxCGrcoktCTATvHS5Lj61kK85hIxmxi5A3Fn11oOcwlcaedb7NTsOAujhNm5bhtjz9/pT+AVw/53JwDAHN5r28+dQ7AiArYzv6DuJVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732111795; c=relaxed/simple;
	bh=CJT0iMPgfMMKY590TyF/jv0a/eQmMMiUwvdaVlMZsfs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VZxhl77xSGtiH7exkgUrsbEzcRXUSPrLgiCkfccpZtBJhmfyWyhJHlnWmYdWMMiI4L/60uDKqLpnrgYxCHydkO4FxWV61JgI+KSuRbqEGu09YQA2z5qyHXvJltUDlSd0B+V4qigH84A8PKGm5fVL9hAjsnqxaY3aJkbuG6QGEtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=AZCZRucq; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20cbcd71012so49165855ad.3
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 06:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1732111794; x=1732716594; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZzaCab4EHiwWgil1/Ov6nfcjuRXdoG8N44OR/d6zxqU=;
        b=AZCZRucqf7a15JSeZKFqNYU9351g+sAnoMOyy0GL8Qft4HPSuARV2oCNEiEi8RWDBE
         u3tvm/ccKFQdL5nmawDoaSv6F0fEdk0x92hrTHtBfCU/N/BBk3fGXjZg9nlF0VHCqXlC
         icZQY3UjDTpcU3A5VaAJbouuigAFN6cHmYckbVfMzDR0s59xkLPn1WSfKmLQGK9kko2u
         6V3VicdTKWqQ6UrKgA7H19JTfM1PC4tI1cBNdDNOkO+Sn61DPrcAHoRgu1GWpc7VdZlg
         iAUqXjTh0tgGJ/iAz8h1JsYP9OQQiAj5S4VehOrpPVetaPOXbiEfMjhZ1Uo4abxTfH9j
         vteg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732111794; x=1732716594;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzaCab4EHiwWgil1/Ov6nfcjuRXdoG8N44OR/d6zxqU=;
        b=u63PJiDsaJ0CIFu4Y8RFDgfkbPfjcD5qtqAKr9KYf/vwhzE1V6tl0DdMIp/NUPpQcF
         3uk9HMkq14MmygtsXGarRo9kmjEpN0QM+tMywMYR064tRPupY7PjVijvmlCL5FVhYuLi
         yG0HxNSXxrcZSEyvHybnWeOnRRnsuTJ4+FeN7I3bLTmAymcdWNFafgHGcYFDRvW/em3Y
         PyiWi/JyD0cRAUQ8K9zu5yKNddlqEhoYm1vjwd1u+78Jz8aCHQ4px9e29QlrPB6SIPv1
         9bUlD6aI5mddaOoDy3UvnZ5hI2Q3jXX/NgwGI7gZ7YGWwuqYO1YB3oqpv5AYPw3uUPJ7
         jZ3w==
X-Forwarded-Encrypted: i=1; AJvYcCUoAHuuRRSf+eBYQX7TQKbnGBVxs3uHqAosAhlp1f9U2Xc3RU6gPq9kDBeywnLkr7DESJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7xSir3TvB+xomNrkJaVyfwYiPo86aasaCTzO1tdMIwlKIMrBy
	idH9RcwF9SHUR7Jg2sMa1m9fzLQutOdlETlA3gn5sIVEO68B9CLnkJ2p7UFR1QE=
X-Google-Smtp-Source: AGHT+IFOL5TGyzlW376Xm8KJIH1icYR3lg7mocMWM7r0WKrZePcwEdBegYT8u0kbgOQDNjc9If25Dg==
X-Received: by 2002:a17:902:f688:b0:20c:a692:cf1e with SMTP id d9443c01a7336-2126ff7e7c6mr19809445ad.43.1732111793787;
        Wed, 20 Nov 2024 06:09:53 -0800 (PST)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f474fcsm92502505ad.213.2024.11.20.06.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 06:09:53 -0800 (PST)
From: Max Hsu <max.hsu@sifive.com>
Date: Wed, 20 Nov 2024 22:09:34 +0800
Subject: [PATCH RFC v3 3/3] riscv: KVM: Add Svukte extension support for
 Guest/VM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241120-dev-maxh-svukte-v3-v3-3-1e533d41ae15@sifive.com>
References: <20241120-dev-maxh-svukte-v3-v3-0-1e533d41ae15@sifive.com>
In-Reply-To: <20241120-dev-maxh-svukte-v3-v3-0-1e533d41ae15@sifive.com>
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 Max Hsu <max.hsu@sifive.com>, Samuel Holland <samuel.holland@sifive.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1321; i=max.hsu@sifive.com;
 h=from:subject:message-id; bh=CJT0iMPgfMMKY590TyF/jv0a/eQmMMiUwvdaVlMZsfs=;
 b=owEB7QES/pANAwAKAdID/Z0HeUC9AcsmYgBnPe2kadvH5t/olEh4nZ968ktrx/equF2lYqvX8
 y0+ccmYkHyJAbMEAAEKAB0WIQTqXmcbOhS2KZE9X2jSA/2dB3lAvQUCZz3tpAAKCRDSA/2dB3lA
 vQSQDACIUsjg3BUBC94txWJFJnsW+HdGsZK9TdrvP+9cahCFdSbYefBFYDX+F6qrGFGZ4xd1dZI
 FgYxgtdj1e571lb++BZPkfR4WVNcV3JrX5/B0UmnEXolTaLvraICuVl5r1gPmRDUbTKGlPGka/a
 hHMAQocMymw6cUu6/MM2ZTscgvJSzCEYgcdwJ9YPXvEKKsmaepFSBoZjfsL5SuJG/Ja3pyTgvCF
 X1/njUvmXBN5+VLfqj91GeLNPV5tCcYxZe1oLWqljxohLeXrEdmTy+4+1i6g4AsQi7vIsQs3Wzk
 cOy+tDP1uTNQrUQ6HVD8QT12FAUuH27qlxxJoSVy1YNWvDknVuM94hkLv7Y6O/eSNGNJGnlV1Kj
 I2IDHywxZohyBH7rV5Ny2An8bjvPfJHS1wf2r3G/gt6vNXu4qNDclE+TGyuawb4KxLkLtFx6RON
 DwJgbyToqac448RyXhmMEWoDDOMcfwnlsB7aqqbAFcN3VfhT4WQG7OlCWDJmnpSKyFbhw=
X-Developer-Key: i=max.hsu@sifive.com; a=openpgp;
 fpr=EA5E671B3A14B629913D5F68D203FD9D077940BD

Add KVM_RISCV_ISA_EXT_SVUKTE for VMM to detect the enablement
or disablement the Svukte extension for Guest/VM

Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 4f24201376b17215315cf1fb8888d0a562dc76ac..158f9253658c4c28a533b2bda179fb48bf41e1fc 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -177,6 +177,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZAWRS,
 	KVM_RISCV_ISA_EXT_SMNPM,
 	KVM_RISCV_ISA_EXT_SSNPM,
+	KVM_RISCV_ISA_EXT_SVUKTE,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 5b68490ad9b75fef6a18289d8c5cf9291594e01e..4c3a77cdeed0956e21e53d1ab4e948a170ac5c5c 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -43,6 +43,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVNAPOT),
 	KVM_ISA_EXT_ARR(SVPBMT),
+	KVM_ISA_EXT_ARR(SVUKTE),
 	KVM_ISA_EXT_ARR(ZACAS),
 	KVM_ISA_EXT_ARR(ZAWRS),
 	KVM_ISA_EXT_ARR(ZBA),

-- 
2.43.2


