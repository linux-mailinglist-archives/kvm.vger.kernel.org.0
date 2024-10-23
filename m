Return-Path: <kvm+bounces-29562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 486DE9ACEB6
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 737DB1C21E2D
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545B61C82F1;
	Wed, 23 Oct 2024 15:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UnptddTT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E988B1C232D
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697205; cv=none; b=myX3dxKIYG6eNWWbRnOknL2hica7ATw4/ayFrzMIktIoEjGSse5YNjKKNht3T24IJ1TbRdSoi1j/qKkkK1Pdhn85VTegMxxbwg+coo66EryH8Tz9bytIINBTYmKJ8MJIfL9MrK719/Cnh8HSlQZFMyZVIlxSIXbkISSamwJNoKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697205; c=relaxed/simple;
	bh=esQoNZuXsR24jwPl1DfQPAsmfQfBH1AfjOxCgQQxj50=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I7Xk6w+pSxxoEQOZOJ7wJr3ccpXk2ZQ+yJt0VxHrIJI+3yfDH213WDas4H/bWH7ggRrIwIRSB+xREGwqAwaGl9HRM2ItVNMfa2209sGGmSkTLibat1xpn8LvhNb0/U9g4skW7cE8rqT4Sv48Z6UyXf/ARWEToNzBs8SFk6dBTxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UnptddTT; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e3529d80e5so120963547b3.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 08:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697203; x=1730302003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eTpDcLprhbUi5YHe62ZQ4u0o+/QxbhbJTnRiVU+yROI=;
        b=UnptddTTjSWKqFJpFHyGYMDGmM0jP/sK2gHpXfLQk7V82ed287fPn46FIkFrKgU7KY
         MMnroaaEM9/iQOZjHXpxquCaux9bLcCGyhEiThtZGCwT3JLkf7B7rmBEzzD1Q1cLYRvi
         DnkOsJrDo0oTzeVq/dB9btZxFejWLXrhHMDLVtgOCbw6OZD6yVnvHfe7PPUWBGdgCPVh
         EBstI9G9vgJ83GR5vklGiCH4o/gY+yKao/pgtxyMzw6u+S8lQwaBY2B69aXdlJ+PXZjP
         kWcFj8OGAb6zsbkBhLqupwZsOCwzcMtlopkkVRUr9Py0o8EfpIIISFPtBopxxHt0YzS1
         jcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697203; x=1730302003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTpDcLprhbUi5YHe62ZQ4u0o+/QxbhbJTnRiVU+yROI=;
        b=rW32sshwo1652rPIrWes7mVdAe6zDe0orCL39g+NVSANj1vY21QzS5818XFqV05fFz
         2So0e/HqWAEGQQrtfFp5lczhG1iwa8dCN2+iS3Th1xvn5Qz6DWztvDYlzaig7k0AjBy1
         cJzXRKYOzOYS/o8qLZNlTjCGyCxzElEgqaIY/AfCCyiBNEgITKdxOqsCe0SJE2WSjfWV
         EZhC41m0nXxkGPQl47ybqZQ0Mfgv2e/8h0Xd97zyCW7TvFUHscOp93efRCkAi+c5Ar2b
         +zZDXHcyjAiB/NkrCmUtbmwwt0gknydeJ410giM/kRcZZZzssPBNn9hT/CTYaCu/u70U
         6o+g==
X-Forwarded-Encrypted: i=1; AJvYcCU5uggxgw0oBqf20p2YSA2vbetJmGMhLFvSkgSL+JmzsQpwUxhZjDpUFVVUyWLmaq4L1Bc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvQE6YJfTqfKVfkxBRfwZ4kC25CZlxDI73cMTiKa1Jd13Lh2v/
	dmpGU3KmZFsCdbZK2RPwYX5iItBLXSD6sMuPXjPVenljkUR5EG2TKdcg9TorYAGvre6GqLlqBAs
	DgEwkJw==
X-Google-Smtp-Source: AGHT+IGyKD6tDsN1UOGbK0zHzy2EM8WTJ3RRqhXskaDYZzY4RpWhowWcPc5+5VKKdGJS9/5Go7f2MraDRssJ
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:8e87:0:b0:e1d:912e:9350 with SMTP id
 3f1490d57ef6-e2e3a6bc055mr2784276.6.1729697202285; Wed, 23 Oct 2024 08:26:42
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:35 +0000
In-Reply-To: <20241023152638.3317648-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241023152638.3317648-1-rananta@google.com>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-2-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 1/4] arm: Fix clang error in sve_vl()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix the following clang error in sve_vl():

In file included from arm/selftest.c:16:
kvm-unit-tests/lib/asm/processor.h:163:16:
error: value size does not match register size specified by the
constraint and modifier [-Werror,-Wasm-operand-widths]
                     : "=r" (vl));
                             ^
kvm-unit-tests/lib/asm/processor.h:162:14:
note: use constraint modifier "w"
                     "rdvl %0, #8"
                           ^~
                           %w0
1 error generated.

Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 lib/arm64/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index b28d41fd..e261e74d 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -159,7 +159,7 @@ static inline int sve_vl(void)
 	int vl;
 
 	asm volatile(".arch_extension sve\n"
-		     "rdvl %0, #8"
+		     "rdvl %w0, #8"
 		     : "=r" (vl));
 
 	return vl;
-- 
2.47.0.105.g07ac214952-goog


