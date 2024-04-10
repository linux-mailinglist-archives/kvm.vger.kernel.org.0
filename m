Return-Path: <kvm+bounces-14098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A5C89EE5C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 11:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9F791C20988
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C1A15CD7C;
	Wed, 10 Apr 2024 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rukvFi7k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE14B15ADBC
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 09:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712740278; cv=none; b=Ao8vDHtnF1uKYMH9NFN0BpXUQRn8ygdcZrdXam7inC8haD15H9Z4m3G4s9XKsRD2qZ/kXRmAVPrvC+eTomHga7bUUcO1C8LhVDWqYHiQLUjkguoIh3RXvPLi+ArIKOuqobvs9IIpVfbsKHZM2jl2iOZvXkSps5PM0++1f2XegpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712740278; c=relaxed/simple;
	bh=l6HwQhAS5cBw6tUNZ3QEVVTb2yliEfsikw1VTQcl4U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJrivF2rmnEJd3OhWomAwaLifmM2TtF39zxDbQTXfu0c+n1sR+zR2G8RWy+Jj9dm9BOi0y9iSD+R0QSTDMkKOprUEKCJl1UDoW/6b5SWWgQIETDBCIZYLJ7lHsXmiVPrbujSGhEQCbsGPxx+xmELpjExDm8J7bvUlHH9r3oGwYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=rukvFi7k; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-343cb97e7f5so1162486f8f.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 02:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712740274; x=1713345074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t82SHWSKnQwBrCB557sYOimgSCzDvuCob+i4t0Pqx/Q=;
        b=rukvFi7kKxcXSs1EmrLpymW11pzj+BJii6PCOqqd/SWWILtcCtkq9nlIdlTDZJi+Ew
         7LVOu+ndTQf0t/RhXvlGncC+0gpAlsQlT3uu8U7PKqmSV5me2dTzkorhkcox6rS/CW5T
         SUY4Hi/t3HtfpKlOgzg53OnUuKimRPONk+IMiE5kB9mbHbL2VPgpDrtJKEJtiHF6xsEW
         s49CyBVcquTRHGrS/+tkIJUvSb8U41kyDILXoaUdNQmastu0hTeY766zr9fFzTw1T9Qn
         2jnZYFckjD0iMExnYkRHq25LeSINzShxGDFJGEz3nn5AjdN6XaTLuTdELRnJrqk/egBo
         hx0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712740274; x=1713345074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t82SHWSKnQwBrCB557sYOimgSCzDvuCob+i4t0Pqx/Q=;
        b=DaTVusaYIiJvDrY3I6NhJRcfiw7vzYfYYfZTrStOej1j/GYxJnI6BIZMujxdAmABLO
         VjirZvtMlUOFxFmmzSFPq3RYefoPbDk+K879Z2DFhKN+eYmoc/rU1EKYK/0y0uPpQoPZ
         BRpKrfvgaLjU0svSswz3Dgjv67Ahkib2Fly9jfwP+sfXug3cJGIajcBBop7pAv0SsSTK
         h745V3EBrDbR66WaPU23HPSD3bTPrJImCkF64F1Zu4CO2xD9NBVkL/cLi25wm0fAzk/e
         VJbId+ZvqYYMRXDO4IMfIeQskAlTXtYRqzStPobNPttjPDK3L7Se3iShz4RU4PVPbWpZ
         YYQg==
X-Forwarded-Encrypted: i=1; AJvYcCWRqm1p+Rqmee7WWIjiTOOKLhlxSG8zPaGuWaoiQ0hIDbF2UukcnsydiUJ8diBfVbr6L2VFw1z5yFDTKVATuDXL3VA+
X-Gm-Message-State: AOJu0YwK5+xvRnc5pF+KQTRVk3G9Ex2R80klNWjdktTNBAgNuevsddFD
	JqY3eoOtcva8uvAtQKrlsLLqphfdM/lVUqR/hMVW70WvHiuv/fFrSdXhyFboFyU=
X-Google-Smtp-Source: AGHT+IFuCtcCydDrKWfn3jYR1RbT1CZEg8ojMks9EcbPdwaTPvasgPI0ZN7jPxJ/lA0ljO5M7tLzaA==
X-Received: by 2002:a05:6000:1a50:b0:343:d35c:d12c with SMTP id t16-20020a0560001a5000b00343d35cd12cmr1424773wry.3.1712740273999;
        Wed, 10 Apr 2024 02:11:13 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:d4a6:5856:3e6c:3dff])
        by smtp.gmail.com with ESMTPSA id d6-20020a056000114600b003456c693fa4sm9079086wrx.93.2024.04.10.02.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 02:11:13 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 03/10] riscv: hwprobe: export Zca, Zcf, Zcd and Zcb ISA extensions
Date: Wed, 10 Apr 2024 11:10:56 +0200
Message-ID: <20240410091106.749233-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240410091106.749233-1-cleger@rivosinc.com>
References: <20240410091106.749233-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Export Zca, Zcf, Zcd and Zcb ISA extension through hwprobe.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/arch/riscv/hwprobe.rst  | 20 ++++++++++++++++++++
 arch/riscv/include/uapi/asm/hwprobe.h |  4 ++++
 arch/riscv/kernel/sys_hwprobe.c       |  4 ++++
 3 files changed, 28 insertions(+)

diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/riscv/hwprobe.rst
index 9ca5b093b6d5..bf96b4e8ba3b 100644
--- a/Documentation/arch/riscv/hwprobe.rst
+++ b/Documentation/arch/riscv/hwprobe.rst
@@ -192,6 +192,26 @@ The following keys are defined:
        supported as defined in the RISC-V ISA manual starting from commit
        58220614a5f ("Zimop is ratified/1.0").
 
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCA`: The Zca extension part of Zc* standard
+       extensions for code size reduction, as ratified in commit 8be3419c1c0
+       ("Zcf doesn't exist on RV64 as it contains no instructions") of
+       riscv-code-size-reduction.
+
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCB`: The Zcb extension part of Zc* standard
+       extensions for code size reduction, as ratified in commit 8be3419c1c0
+       ("Zcf doesn't exist on RV64 as it contains no instructions") of
+       riscv-code-size-reduction.
+
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCD`: The Zcd extension part of Zc* standard
+       extensions for code size reduction, as ratified in commit 8be3419c1c0
+       ("Zcf doesn't exist on RV64 as it contains no instructions") of
+       riscv-code-size-reduction.
+
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCF`: The Zcf extension part of Zc* standard
+       extensions for code size reduction, as ratified in commit 8be3419c1c0
+       ("Zcf doesn't exist on RV64 as it contains no instructions") of
+       riscv-code-size-reduction.
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index ac6874ab743a..dd4ad77faf49 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -60,6 +60,10 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZACAS		(1ULL << 34)
 #define		RISCV_HWPROBE_EXT_ZICOND	(1ULL << 35)
 #define		RISCV_HWPROBE_EXT_ZIMOP		(1ULL << 36)
+#define		RISCV_HWPROBE_EXT_ZCA		(1ULL << 37)
+#define		RISCV_HWPROBE_EXT_ZCB		(1ULL << 38)
+#define		RISCV_HWPROBE_EXT_ZCD		(1ULL << 39)
+#define		RISCV_HWPROBE_EXT_ZCF		(1ULL << 40)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index c99a4cf231c5..2ffa0fe5101e 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -112,6 +112,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZACAS);
 		EXT_KEY(ZICOND);
 		EXT_KEY(ZIMOP);
+		EXT_KEY(ZCA);
+		EXT_KEY(ZCB);
 
 		if (has_vector()) {
 			EXT_KEY(ZVBB);
@@ -132,6 +134,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 			EXT_KEY(ZFH);
 			EXT_KEY(ZFHMIN);
 			EXT_KEY(ZFA);
+			EXT_KEY(ZCD);
+			EXT_KEY(ZCF);
 		}
 #undef EXT_KEY
 	}
-- 
2.43.0


