Return-Path: <kvm+bounces-50070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C76AE1B75
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5DF7167332
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B8728C2A2;
	Fri, 20 Jun 2025 13:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nWFxam2d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5A928BA9B
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424852; cv=none; b=WlcPYBngQh8YgqteQbuPHiHnyJEGA8tzIhDQ8Vqx2OH/OWft4VTLNekqF0R4/2YJgNPtYUq1k6qCP/1ay6sqmH1AvwzfIlWMo0gsO9/mUKQyEAYx84gelDT5jjCTTO3Hjuiu6nq/pA07mbHKof7oejJx6HP79tnD5Hb6Kl5rS3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424852; c=relaxed/simple;
	bh=ZO/i7m17/UWggquSZiea8ez2n78wL0tYYfUv3t3wbak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXGdHJKYI1vEje9bLPF2/4qxBhu5vMXJxOv6Ck7bXZA9MAPBSV0QUKVsAkdYVSheEL68yOyQDQB0S8ifUmkp3xMIoD1eegHLawTMEjIqClkPS19k2JL4D/LcmmhB3AwPVYz1nsU2lnW9D3hrlF0xjDXNC1ZFxMkOb63kbuQng3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nWFxam2d; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-441ab63a415so19971625e9.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424849; x=1751029649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g4jpPoIjWAnN20gltB2a/vOsrmaIk3+mmplMj5/YsrY=;
        b=nWFxam2dhcV705TVfQaOeFo2fP9wRndDaEjKVnQS61V8jr0oKi1te+HfbfGIs3BboO
         wpw1q5dEHK7tEatp3Wpuph3yY/j8uX9S+R34C/X9pmi/MfyPic8fdhgokrkYlQfMXMeT
         oLyxAfTKLniRQ4tWdb+nTWe2uWtSCwnqoPOvG4nDEn4xLIPnx+yNp74muaOPAHHZM4Ca
         QZT+7gbb1AJNOM59oXSHRGlrRFsG4+mIioD+DixxgfsxJLs56/suj9I3tIeoNnFIsi9x
         kjgycRNRVaZZqnr3mc9LCBMF7qQYHiBItWIEO9RKb5/1e7tpJIi1oUOP0oS+eboxxNc1
         dSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424849; x=1751029649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g4jpPoIjWAnN20gltB2a/vOsrmaIk3+mmplMj5/YsrY=;
        b=ChbZYiIl/wrQz9EYs2/fyy1TyEhT3Ue2JdxLPFyRkW0SqSrUlxBZPDugPmTnIX+Q0Z
         0LStN3vMquN3UaPmtFDddB0fZi1otg+3kxjUoda++daDc3CJ6xs/Xta3jV9q7s6wl4R9
         xikumACMM3WW3jO/g2NsUHPEerd+YF7RqIq27YOmrufFDG0x0k3F1wgvJt+5KaGT71F3
         0b1RijBwZEnknhacfQ9SH48ueIjm0CN8DxZ5h+/4GoxFowIRTIPzqjU3TeiRKt5qDhgq
         mG+pxrII2ySDnI/LM07bQse2NNeFJLEVJAcfcUtzZEsmDL+cTRTwwtHcpdMlHAG3BJPf
         Zhsw==
X-Forwarded-Encrypted: i=1; AJvYcCXiJqok8n+zICkq8VWJhCV0oQJIQoAt1pCyM4njjupYMMPgj3ZCfXdxXEtZWDLRH2yEzNY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5GKpMfOeGWMElT2XAyXMU2AwjciC7qNDYwtIhmgrgyehXEdnv
	ZxRRKMiheOr0PYdtzy5Rb2RJTwocRG7Ccf73JKAq2bOgTJXPP+7/I8bLFJ4gH5IbogU=
X-Gm-Gg: ASbGnctkTQthDlYysTkc5kTOCbVhSlu1uqSprPcb8V12B9mbDW3xgAs4LYVge66uDqW
	mE67JgWKnTV4fw5ebZp0Y2hKrDhnLwy/xV3eQcja8tlcN+SZOPiIgiC+fWv9TvRZrr+Ng1fDkh+
	VA9UbM7EEmI5n6lDmKQthFx3MUL5q0LYiSsS5kyEg9HXN23J/fegQGTG412H8G+PyP0P00RUSGY
	szjX5H2JLs/sCzpsGiFI84Dq9WOuvBJGJaD9OLFtyo+xjN58+fiWyhbpAfsWIA2VUCDbAT6LvvA
	0vgBl+Jc/J/x8mpvTAUT1XEKugfr5A7CHnYrXv50loAOOfLllZqI0lQMR/A/gqNkAttHV8z6mH4
	eWGrRNyrbfHg0vPAJ/TlvzVNVUb0MMZHmBcOO
X-Google-Smtp-Source: AGHT+IHvqyAxctyWiDO7wt3FaACda4gkUZk2ECgfjgeswwsSXX3ba2fXpQZsZ/3OnTwR/gx0VWlMzw==
X-Received: by 2002:a05:600c:154b:b0:43d:40b0:5b with SMTP id 5b1f17b1804b1-453659b885emr24539615e9.25.1750424848387;
        Fri, 20 Jun 2025 06:07:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535e983a4bsm59724925e9.13.2025.06.20.06.07.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:07:27 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 03/26] target/arm: Unify gen_exception_internal()
Date: Fri, 20 Jun 2025 15:06:46 +0200
Message-ID: <20250620130709.31073-4-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
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


