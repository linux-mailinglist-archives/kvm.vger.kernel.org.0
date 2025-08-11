Return-Path: <kvm+bounces-54428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51BC6B212D6
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 420961908227
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0A02D3EC2;
	Mon, 11 Aug 2025 17:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IYE7tlrt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842EE18FC91
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754932031; cv=none; b=WWu30xDN0dlVIjJkLQ163pVlTlhhlpEXYHiAaagxy6R7XDe27e78PYQRVVqTfR+q0IZDJgOAptXX5Rnahxos7UlyYBKTG/Q9PWeSttOh9U/WTYLgiLbLs8Ne/BTDLeSrqkb193VHrWfdrOBBGuu002kFx+RUusFxESAmBXwxSHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754932031; c=relaxed/simple;
	bh=UgZqp7C5d6OA0hYq/JvBbkM/Xh5viNhsQTWv3h7dwhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/PsKY0p171RxVqnlavcyOFr4eBZ5bRr2Bl6Dd2SytJVC5IyQVlOxTnJqjWQ4HjcnlcHnd7zHKuitMga7k5HxxFSKyzRlxn65zHPKPLtGLsJoQ1LMh3afc5wyBLFxciRu1e9PeqeXtYAWnJ2h3UgXFYguIIiuV/pmJV9jwDpQ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IYE7tlrt; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-455fdfb5d04so23311475e9.2
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754932028; x=1755536828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SL9BjJEaO0GjattCvBT1sYPxfZkwHVSu+LlGdRsmcAg=;
        b=IYE7tlrtbNwDJp9ETc4St0cLbNCnHoVbi9BWr4FX1JQPWP3zQpRoZCFUymxcM+3tE1
         K+KIybRBwO54ACZ/rg+57RjVTZInY0ANC2921Exy+2jC7i5JxC64paLLNj43pW2phxgX
         vr9Fhxg14FOvg7W2j8HkHUNpE9tvKJlvCwbzm4LvoqdPgNsrwrrRb2GOVvQX1AlUMWxU
         Uy5j7rzC4ssuaVY7DIXKkUJWYV0e8GKeENNJ7/8G7CtNIUm7QRoku0XSYazUxKzggQXA
         224fn/+o66cgJOeDKvUN5yZa0bPLMkmZn+btJhJ/3SE8MVasXLmiD7vCZ9jTUPQlsuML
         D8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932028; x=1755536828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SL9BjJEaO0GjattCvBT1sYPxfZkwHVSu+LlGdRsmcAg=;
        b=oyYQ+03hj+7eTqPkCPsFM8Pt/qTr14oBtKdUSTNjc0cwtLHWdQjf4d1CD/si0wjS4K
         HGFz4IJgSB0NLMEobMy5yMDrfz3O/4PKt6boBIRc3JY/idWwR+W7Sq6Z6fanp60cEgaN
         CKVqEVNmEuMbks9wk9BYDWfuJGfRXJtitR4fU9juUR8WaXra1Gl4UFvqR6ZemlhB0hzf
         zqC923RJLI4IrRFwS2DbqGR1OSMKIFxHvypf42Xma0DvkIlyzShdYz/q2Fqd7uAwEvCg
         CdYW8DEfjbTB3/06yRrZDjPNjtbciPPpE4nVuyd6z+EK88rXRuLwXZLYeKHoJbV3Rbg0
         AEbw==
X-Forwarded-Encrypted: i=1; AJvYcCXSKXDBEa8jqgDKjpXKTbVJmxGrGJmdqKUKnqDVCrLb+tpJ9LOwG9chYtTLxOa+G7nSjTA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhRwJznCVexylXagIh6uHGnAPwZe0M2C0TCb72FPSlk7w4ebJy
	wd6STdPbFnffZqaMPco1U1C4yoWl+14Fsv1teWtlK/gZpeBqve9sGDtxrMFGKXoF6fI=
X-Gm-Gg: ASbGnctMzc3D2nZ5dJxU+xnduMU5OmKkp7OG9imtC16xnEvwF9T3ZYRxGSPliy7Dpnq
	fSO4bdrWennnzaguB8zEHFi1SJu6kZJ2r/veRgWK7VGp0wLoeGT8Qqg3qf7sJxnb/cxt0JiYzoR
	fYGMGPXRwRwTfKo1f5D5EEPQZz4DrIeJPyLkl89ov0FX4qbVRjwu3ItjdJpFPYVMF4WyaMZVgT5
	amJwszkbV3KvlBNMPJTlAMF+iq8e8oTO7qaTbRlcUgVsMZocCxiPvYQBJOLfuBsAMWF6C+X6Lbk
	R6tQuN8WQWfF7uoKgorrCV0EnIxK1rGSWzf5mClP2FBsHOQL1wjPae0NuLmmQl+Z+bZ4aUR7TmJ
	urmgQDP5DGjMsj81lF8m9PWwFL+Jsof9Usvs8mj5gQP9sdsuDvUdiRMFqBN7VQ1OJMFuI/WbW
X-Google-Smtp-Source: AGHT+IHfoaigvwFcg4KswaUsW5gj91pCHoOh4NHtbdx2nxS2EGq2EkpPF+O3AaqXm2LpMC3Avw3iGQ==
X-Received: by 2002:a05:600c:1c12:b0:450:d386:1afb with SMTP id 5b1f17b1804b1-45a10baf6f9mr5082985e9.9.1754932027824;
        Mon, 11 Aug 2025 10:07:07 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459dcb86d6asm311891055e9.5.2025.08.11.10.07.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:07:07 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Haibo Xu <haibo.xu@linaro.org>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Claudio Fontana <cfontana@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Mads Ynddal <mads@ynddal.dk>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 10/11] target/arm/hvf: Consider EL2 acceleration for Silicon M3+ chipsets
Date: Mon, 11 Aug 2025 19:06:10 +0200
Message-ID: <20250811170611.37482-11-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250811170611.37482-1-philmd@linaro.org>
References: <20250811170611.37482-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
Just a proof-of-concept...
---
 target/arm/hvf/hvf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 778dc3cedf7..d74f576b103 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1000,6 +1000,9 @@ uint32_t hvf_arm_get_max_ipa_bit_size(void)
 
 bool arm_hw_accel_cpu_feature_supported(enum arm_features feat, bool can_emulate)
 {
+    hv_return_t ret;
+    bool supported;
+
     if (!hvf_enabled()) {
         return false;
     }
@@ -1011,6 +1014,9 @@ bool arm_hw_accel_cpu_feature_supported(enum arm_features feat, bool can_emulate
     case ARM_FEATURE_GENERIC_TIMER:
         return true;
     case ARM_FEATURE_EL2:
+        ret = hv_vm_config_get_el2_supported(&supported);
+        assert_hvf_ok(ret);
+        return supported;
     case ARM_FEATURE_EL3:
         return false;
     default:
-- 
2.49.0


