Return-Path: <kvm+bounces-6442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E5C83202D
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 21:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E84728BB09
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 20:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0903B2FE09;
	Thu, 18 Jan 2024 20:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UFJLCyob"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB3E2EB07
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 20:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705608472; cv=none; b=a7dvh6dwNTqfEHKiIWfXIiDxue15VLpoD9FhNrSLXZdSK4SQ5oWM4/p0Uf0gJzhZ6YyAZcEyIoTxhbd6HdnCKaWWRzOWq3klsHIM79rJezfkCSFA1yL54g3FRFk+2353EaNHEhXN0rN0HASZKDCNPLRbhGCcO++0/2twb5HUz/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705608472; c=relaxed/simple;
	bh=2R/xi4qjLIoZXicOT+fjSBOBeerCpQzqeiOl7r6gHVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KbEAK6fsLZawOMCwTIWQfSN9aTHKHxPrCZFxczWXx7SsEDpvX6UuiQsTYKjBIwETQRxuaXXvzX01vF7jwvtCB9yL42xMU+hArK0QfyV3Wp6vNcV23rplCOvmIRD0Tqwb4JT7efF4ALA+kBwPLGP21CKe9GOuuqMyQyqkj0DlZx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UFJLCyob; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-337bad75860so680f8f.1
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 12:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705608469; x=1706213269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzXk5yiY5MpA6wV2WpkIOyNiGD0qCuniPF02smOcXHA=;
        b=UFJLCyobPVChjcVh0QBZw6H+tuq3aYRRgnQ5Sl/cziJZ4f3c7ktxkKvOSyx6CeXh5y
         EpfGO+SVp3nlkCxR0US3l6v4IiaR42d3rTtdjSJVaL4vPXUPblmaEdwtgI3GjGreToyg
         WCM1FvuH1QPP9HxuaUp/K0c6kcUBC59v322nMEQ+rK5XZO5OUYF+FpGZRJOIgmhZCx1E
         QMflE9AGd4mxNvpj8OeGjH389GRIadxqhR0Rf7UEeHjPIO0YqpMTa2tt7PIWOuwEDrZ0
         Wuz1BPEXDOFIBQVJgTUM4PYlT/CCO4sJLnvsvuv7YigH4sA92DHh4GnElGytooLBrxyu
         ackA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705608469; x=1706213269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzXk5yiY5MpA6wV2WpkIOyNiGD0qCuniPF02smOcXHA=;
        b=oDuMmiEiqVwR6AEmAE0V/33MuHJTeSbHM+GA/IvER6k/ZWUPy5KHkGV2DW2u0Gn7wZ
         s/WFpmklH05LF2YxYIqDTh7K5UcWmTr5gvV6vIP1HB4b7EBY000hTOKAMv3eSDQJfHEc
         gIvhBIFpsGNYSI06QnqNB75G2FabP4+3DARd89Xtj1vDfVziJDFWoih7nIi/Cmi7GJrI
         fBF5ht7KHMdMB0GOYpyNisd9dMsebBajc7RnuLmkSHZuMC4m+7bH0iV8xCNG6HFIXzEf
         GZr2SdTm8+2k79t+v3UxVU7YJavgEXI1V806J+6McPpes2mAtUqiVwmUYkf9UfbykgbL
         h4mw==
X-Gm-Message-State: AOJu0Yw1FIcFP17SqqntlBuqoSJ1pXgTXBc/iX664s1VvUBFtg/Lbpxs
	jCZk8tSFHKch5BHs2CpAguJl18WTmReb0kGW3JVPhwx+UZMF8VOuC7aMJu6S+EE=
X-Google-Smtp-Source: AGHT+IEp8Fqz9tymJZ6A+3yvqKGgKvpEkjLBs5M5134qAAIM06sEQbhoYAKYQgHskFvuYAdYPdlmpA==
X-Received: by 2002:adf:f191:0:b0:337:cef4:ae1e with SMTP id h17-20020adff191000000b00337cef4ae1emr909314wro.20.1705608469011;
        Thu, 18 Jan 2024 12:07:49 -0800 (PST)
Received: from localhost.localdomain ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id o9-20020adfe809000000b00337bf81e06bsm4758039wrm.48.2024.01.18.12.07.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jan 2024 12:07:48 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Igor Mitsyanko <i.mitsyanko@gmail.com>,
	qemu-arm@nongnu.org,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Eric Auger <eric.auger@redhat.com>,
	Niek Linnenbank <nieklinnenbank@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jan Kiszka <jan.kiszka@web.de>,
	Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
	Alistair Francis <alistair@alistair23.me>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Tyrone Ting <kfting@nuvoton.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	Alexander Graf <agraf@csgraf.de>,
	Leif Lindholm <quic_llindhol@quicinc.com>,
	Ani Sinha <anisinha@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Joel Stanley <joel@jms.id.au>,
	Hao Wu <wuhaotsh@google.com>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH 11/20] target/arm: Declare ARM_CPU_TYPE_NAME/SUFFIX in 'cpu-qom.h'
Date: Thu, 18 Jan 2024 21:06:32 +0100
Message-ID: <20240118200643.29037-12-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240118200643.29037-1-philmd@linaro.org>
References: <20240118200643.29037-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Missed in commit 2d56be5a29 ("target: Declare
FOO_CPU_TYPE_NAME/SUFFIX in 'cpu-qom.h'"). See
it for more details.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/cpu-qom.h | 3 +++
 target/arm/cpu.h     | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/arm/cpu-qom.h b/target/arm/cpu-qom.h
index 02b914c876..f795994135 100644
--- a/target/arm/cpu-qom.h
+++ b/target/arm/cpu-qom.h
@@ -33,4 +33,7 @@ typedef struct AArch64CPUClass AArch64CPUClass;
 DECLARE_CLASS_CHECKERS(AArch64CPUClass, AARCH64_CPU,
                        TYPE_AARCH64_CPU)
 
+#define ARM_CPU_TYPE_SUFFIX "-" TYPE_ARM_CPU
+#define ARM_CPU_TYPE_NAME(name) (name ARM_CPU_TYPE_SUFFIX)
+
 #endif
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index cecac4c0a1..41659d0ef1 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -2837,8 +2837,6 @@ bool write_cpustate_to_list(ARMCPU *cpu, bool kvm_sync);
 #define ARM_CPUID_TI915T      0x54029152
 #define ARM_CPUID_TI925T      0x54029252
 
-#define ARM_CPU_TYPE_SUFFIX "-" TYPE_ARM_CPU
-#define ARM_CPU_TYPE_NAME(name) (name ARM_CPU_TYPE_SUFFIX)
 #define CPU_RESOLVING_TYPE TYPE_ARM_CPU
 
 #define TYPE_ARM_HOST_CPU "host-" TYPE_ARM_CPU
-- 
2.41.0


