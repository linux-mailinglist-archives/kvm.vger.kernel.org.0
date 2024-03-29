Return-Path: <kvm+bounces-13062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 954938915DF
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 10:29:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B1ED1F223F6
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 09:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA656537E7;
	Fri, 29 Mar 2024 09:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="LJEHAOEX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8449154BD4
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 09:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711704476; cv=none; b=N9NiKaSuyk5sIy3X74SEolfssLIKOURjZ1g/lPC78lH8CykCB8yPLHf7ItQWJlOPdp/CC1nWQCtmlTpfM00ClbdDvrVwWSVeJIaLeL8pBGjptvaNNx0Vqqe+9byLYOlPhgHEJ7Yo2Un+dMraxvu/eQqQGPWz9EmNotk3XUsbOIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711704476; c=relaxed/simple;
	bh=kFYDos5oOuWgkjmYMwk9XxLgUS9cjG+wC5rkcBK9y+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MRgUedw2qnpMsYoBNgF+A59BXDzNmuqfqWvI7cKlCEsAMtacEg09lAMYlpy7+D/+xarpNDUw89WHKj+FJnNQgTyGHCRREKNy6nMOflVNTIyMeMpsu2FXGISqcYirZU7riZA0EMpr4G5QkUkSVgSqZfvbydSgg4P31xzFiRwSgZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=LJEHAOEX; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e88e4c8500so1500828b3a.2
        for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 02:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1711704475; x=1712309275; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AWJBCH09eu6e6/Y/jgxKzI6AZAa7BXYvEZEuKCZc7nk=;
        b=LJEHAOEXbmpdLGymnH1Slp9iJZNh7Z2+VK2iLh5CS7SjuzLoCvou6ZsWxFxyQfwoEv
         Cb8iE9m+wW9K5lTcfCgqGFlss3W+w1DqBd8wdunA2QTsV3NL9JVdqYjFuF8G8kFzIKmB
         aJWlsNrNBWGiLm6SMFJPD9UHCHWNGM0xZIrYqJVOESB9yQQjvnlJFiMbba7piMh37vTH
         MHFKZR4UOhRK1tXQvBAarb84ZLnBasrIlwrAIGhMFJBvTM+ECsqFQSH7jC3esPx9jJZz
         mGa4ENT3h0GuJ1CK2Yqy3nvn46H1GE+6Gvj5PsVzbIK06rqRaFLxpAajWd/617EvtfVx
         l6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711704475; x=1712309275;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AWJBCH09eu6e6/Y/jgxKzI6AZAa7BXYvEZEuKCZc7nk=;
        b=Scy1DwpUwytSmB8bCJM1B7A7vb1jxP1U01A0ZurGjLeMV8H8SHZp9rX5OHmvrNM7Ae
         FLs+h6ePfxZl89k6/NCvvK8nAFS374RTmXvXGz8s7tX4AW/N3P+NsnkGrabMbXWF5LMS
         10Gp/jsnw8neDuwUXCdmlq2pqB62cuW+SRkxmqgmmvZeWlwjNxU62TOd45zG9rWwmNuw
         BF6MdH2sbzKwHtRxo2z3N3KSAg1DYm7a7mUY6tBYfRhaOQV0CktD8Jja1UJUVpm7+s6u
         emtuYVIxpfLED8p5lXXbk/o8HUBnx+LJbt11i4Iyyo8KgOAskSB1kKnx2QrF7Ji271md
         uhxw==
X-Forwarded-Encrypted: i=1; AJvYcCU868qAeTyWNL8Kdz6rVrX4bNnxnS90Pr1CEsaqHpnPcqwG3zW3fu4kfuSlxxOh5QWCTmjnniUFXFgipzhJ40ZP1YT9
X-Gm-Message-State: AOJu0YwhTobfBFeSj3pTJ07Dtt1si9QsPw9Ato0XCFvq11uppfeVrha9
	bTKMF0y82a0uMb322rdbursIsds8sgC+1oJIQC6n7Oka+dMaL9mXgNNhsRMgnHk=
X-Google-Smtp-Source: AGHT+IHveAaHJ+i93XoWQQhAxL1npi1lTK697/I+K/Ux4G4x9neoQ8w5TBypEt7P1DanmINkW4zEcQ==
X-Received: by 2002:a05:6a21:3986:b0:1a3:af50:18bd with SMTP id ad6-20020a056a21398600b001a3af5018bdmr1630725pzc.28.1711704474638;
        Fri, 29 Mar 2024 02:27:54 -0700 (PDT)
Received: from [127.0.1.1] (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id cv17-20020a17090afd1100b002a02f8d350fsm2628830pjb.53.2024.03.29.02.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 02:27:54 -0700 (PDT)
From: Max Hsu <max.hsu@sifive.com>
Date: Fri, 29 Mar 2024 17:26:20 +0800
Subject: [PATCH RFC 04/11] riscv: Add Sdtrig CSRs definition, Smstateen bit
 to access Sdtrig CSRs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240329-dev-maxh-lin-452-6-9-v1-4-1534f93b94a7@sifive.com>
References: <20240329-dev-maxh-lin-452-6-9-v1-0-1534f93b94a7@sifive.com>
In-Reply-To: <20240329-dev-maxh-lin-452-6-9-v1-0-1534f93b94a7@sifive.com>
To: Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>, 
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: Palmer Dabbelt <palmer@sifive.com>, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
 Max Hsu <max.hsu@sifive.com>
X-Mailer: b4 0.13.0

Add hcontext/scontext CSRs definition to csr.h

As riscv-state-enable [1] Smstateen extension spec:
Sdtrig CSRs: hcontext/scontext availability are controlled by
bit 57 of Smstateen CSRs.

Link: https://github.com/riscvarchive/riscv-state-enable/releases/download/v1.0.0/Smstateen.pdf [1]
Signed-off-by: Max Hsu <max.hsu@sifive.com>
---
 arch/riscv/include/asm/csr.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 2468c55933cd..308ae795dc82 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -204,6 +204,8 @@
 #define ENVCFG_FIOM			_AC(0x1, UL)
 
 /* Smstateen bits */
+#define SMSTATEEN0_HSCONTEXT_SHIFT	57
+#define SMSTATEEN0_HSCONTEXT		(_ULL(1) << SMSTATEEN0_HSCONTEXT_SHIFT)
 #define SMSTATEEN0_AIA_IMSIC_SHIFT	58
 #define SMSTATEEN0_AIA_IMSIC		(_ULL(1) << SMSTATEEN0_AIA_IMSIC_SHIFT)
 #define SMSTATEEN0_AIA_SHIFT		59
@@ -480,6 +482,10 @@
 #define IE_TIE		(_AC(0x1, UL) << RV_IRQ_TIMER)
 #define IE_EIE		(_AC(0x1, UL) << RV_IRQ_EXT)
 
+/* riscv-debug-spec: Sdtrig extension */
+#define CSR_SCONTEXT	0x5a8
+#define CSR_HCONTEXT	0x6a8
+
 #ifndef __ASSEMBLY__
 
 #define csr_swap(csr, val)					\

-- 
2.43.2


