Return-Path: <kvm+bounces-50314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D6CAE3FDA
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CB4D164642
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB4F246BA5;
	Mon, 23 Jun 2025 12:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vFS9J3Fn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275C423D2BF
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681146; cv=none; b=XO6CrKhxQJAtiIR8LWnI6H5w8rAVt18ddZDiOB2c4ga7b1NPhOJtywrU1S641cdLOsMZEx8in2zqMkmCb96FWZTTtRmWrDNBL1dOBMMnt6jUoeoSuE99jK1IBkEdxoJE8W3WIDBwf2bcjepoFb5Kp8qY1Z6AYKFbYIPoBZOspBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681146; c=relaxed/simple;
	bh=ZO/i7m17/UWggquSZiea8ez2n78wL0tYYfUv3t3wbak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbxOCp1hVQUBsZ7M78j1jQi4+fhBr/Kj2cqw4HsMJaOKf8AKwD5z0r7A/AAiS2rhWmfgWlcfmM1r6jnot4KdUeeNydolXVOmAWBqqdY/KmkVC+dba02jc4GyAk82HIUDjtgwaZyfew5DzDdKSFqVl3aDGWhLTiW+5Y22w00MT+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vFS9J3Fn; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-450dd065828so29514985e9.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681143; x=1751285943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g4jpPoIjWAnN20gltB2a/vOsrmaIk3+mmplMj5/YsrY=;
        b=vFS9J3FnFKuW8e0ZFTy3Wz3by3wRf/YviWio0nQfXUsVBzVGaK+E9Uo/nK2vqjMZjJ
         xFozyy9USaq+WJH09yMXD0kt3VRmiLjuXLhszDLC7o3166cchbYenOiluLDP+VBc3J6h
         d/hueby/50wDgOPdV5gmwRptQaPV02AHmXkXmpFXFSL4o0HYIJi9Tx/3E0UTQVrzCKmK
         LHT2zKClEmHlyUQBFe0cYQtcMXnHRxxG79OV6r6ikv7aH4WnAAujUNDD/0kzXHwb1FTf
         hmFLv9Qi3XSIFyn27zDk7Iaqm96pt15oBVQ+MxBDmiOtHCyWdHjMNF6Oxcxv014iATk6
         GDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681143; x=1751285943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g4jpPoIjWAnN20gltB2a/vOsrmaIk3+mmplMj5/YsrY=;
        b=LEw0gQHp5rcjFupMQO0JpjbGvmveWIoTEE0t3X3RHIPGwV4ngHkaYvSP7DNjwcOVPA
         4Y12zRDcIWBYB95OKMK8Gu8laxchtmOutXBYSAd2RDRQBNJt3F0wB89J+ZrFqIgQ3J/c
         sU+FjRYEgsy42LNIkoClKxSUE2Sjoni90FxxQz/Ufn58iO0cZ2BICxnz1rGJYVdVjE+X
         ODSKZ3Eb7p9N6Fo471ltH4qEMw61D38K/VOHZTT25TFt+ghs9H64oZ0KecZN5WEG7L1B
         mHGd00h2CZqjUrKAjTZZGw+kNhCveCC5S8Rnm3FdvqAWci9mPh+zfa9qyG3OrwrfWK0j
         gqpg==
X-Forwarded-Encrypted: i=1; AJvYcCV9pW0DsjxPG9l4rYmPYvmqeNoHAQnpudxCASVKzRErLmzTsCnCiaZthuP+JaWdn2xA7YA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfoJix03QpIuJ2NBDehe62AnhocWnteHhOH8OIKYBHhkePJgbt
	DYDtsaswu6Xe+mxd09yAoqlBugx53AUoPgR35AZkwE5hy8LH/GFPCcTBc2rb+lhMqjg=
X-Gm-Gg: ASbGnct/h8zlEhUI7Z7Uw3SgT2e3uAdmG3c6LBe2iEQWHr8tYoH0oH7kebuBxxWJIm8
	71an8Eabn/lWWfQ2vqIEe46MSH96TWQPexSSEnBRDNrVGxH8xmZLBdK24pxifaT0Rk64R2JSnjc
	K+J9LsGR6MXsjQqpq3tLyvY0gN3/2Bc/0nH7u+f4XbFOZQR7Sk1Z9tjR/QH6CJzPU2cfPTZv0cf
	hsFyxmSqw4Hf1pa38iucGPYNYpkUcT34RSMKSADAqp2vv0HB/EQK/jwZGOUk3gV1qyAvw7VbFfi
	l0Aksd6pedU3tOWV29ntgBq8YoTxpr2+p7FtlnUbxqFJ8W94ZjkmsDb9g/rrY5ga5rQ4FcTdMEi
	X0cPg5ATKblKFpvWlkg7en/l033YXbLK865SJhOXfFS8P9sU=
X-Google-Smtp-Source: AGHT+IErlri5hkyOBSvRe8fCS9DDCc0yz8mXpTeS1g951cmKKKfzy6/tEWFiO/Q3SrTle+JMSQITVA==
X-Received: by 2002:a05:600c:3ac7:b0:450:d019:263 with SMTP id 5b1f17b1804b1-453659aef70mr119085105e9.18.1750681143141;
        Mon, 23 Jun 2025 05:19:03 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d0f189cdsm9443362f8f.35.2025.06.23.05.19.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:02 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 03/26] target/arm: Unify gen_exception_internal()
Date: Mon, 23 Jun 2025 14:18:22 +0200
Message-ID: <20250623121845.7214-4-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Same code, use the generic variant.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/tcg/translate.h     | 1 +
 target/arm/tcg/translate-a64.c | 6 ------
 target/arm/tcg/translate.c     | 2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/target/arm/tcg/translate.h b/target/arm/tcg/translate.h
index 1bfdb0fb9bb..0004a97219b 100644
--- a/target/arm/tcg/translate.h
+++ b/target/arm/tcg/translate.h
@@ -347,6 +347,7 @@ void arm_jump_cc(DisasCompare *cmp, TCGLabel *label);
 void arm_gen_test_cc(int cc, TCGLabel *label);
 MemOp pow2_align(unsigned i);
 void unallocated_encoding(DisasContext *s);
+void gen_exception_internal(int excp);
 void gen_exception_insn_el(DisasContext *s, target_long pc_diff, int excp,
                            uint32_t syn, uint32_t target_el);
 void gen_exception_insn(DisasContext *s, target_long pc_diff,
diff --git a/target/arm/tcg/translate-a64.c b/target/arm/tcg/translate-a64.c
index ac80f572a2d..7c79b8c4401 100644
--- a/target/arm/tcg/translate-a64.c
+++ b/target/arm/tcg/translate-a64.c
@@ -433,12 +433,6 @@ static void gen_rebuild_hflags(DisasContext *s)
     gen_helper_rebuild_hflags_a64(tcg_env, tcg_constant_i32(s->current_el));
 }
 
-static void gen_exception_internal(int excp)
-{
-    assert(excp_is_internal(excp));
-    gen_helper_exception_internal(tcg_env, tcg_constant_i32(excp));
-}
-
 static void gen_exception_internal_insn(DisasContext *s, int excp)
 {
     gen_a64_update_pc(s, 0);
diff --git a/target/arm/tcg/translate.c b/target/arm/tcg/translate.c
index 9962f43b1d0..f7d6d8ce196 100644
--- a/target/arm/tcg/translate.c
+++ b/target/arm/tcg/translate.c
@@ -372,7 +372,7 @@ static void gen_rebuild_hflags(DisasContext *s, bool new_el)
     }
 }
 
-static void gen_exception_internal(int excp)
+void gen_exception_internal(int excp)
 {
     assert(excp_is_internal(excp));
     gen_helper_exception_internal(tcg_env, tcg_constant_i32(excp));
-- 
2.49.0


