Return-Path: <kvm+bounces-41351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3C8A668A8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 05:52:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EDBD7A7055
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 04:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D3DB1C700B;
	Tue, 18 Mar 2025 04:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bYS4dGnr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C16438FA6
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 04:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742273498; cv=none; b=T+gURZKW0mFVsQlEDFiajjk5uhO5dc9lraiLfIKNp9htudlfnQ0co9ghFSkA5edFSePffcFoP1egHF3p/HxHBxAwvvp/SzNUf2MLBbkuTcKWo3L/syLNPpk3lJtmkRlmf1j7eHRnvqLSyJ+3FmEnb+I95E6mm6SGKV3ITDR21lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742273498; c=relaxed/simple;
	bh=jaa7IfyywSLJT9eOoNlXt0fIhSE9+JRAFmZnoWLXufU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I4u6XEEgkBGrgtgWeWs3WA2Rc6HyyyU+umnXHkfDuIzP6b1vcGPQ+GxMSBTLDwOvywVNbe+rcB8OJ74VFL35oCZeLocbbk25rh5oQA6/Y2WM8yxPQ70/TDQ0S4SEDBru5rR4aKsStvLWVLmlfKgVTrX5cQKpJva+pKaJXv3Oic4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bYS4dGnr; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2255003f4c6so89474595ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742273497; x=1742878297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWIezDEnsVaTp50avzaVFN+/54kZx3DW446tGxF6xYk=;
        b=bYS4dGnrJ1UoPJMO5LjM0fs8n6mCjTTi+itFXypRJpFoXRWshLTgRrjHIzJ6fRJM67
         b7a8s2asIISE10jOdGRAZhz6ZPFuka+cFwvO7GdylYCRslt93hd43quUJ3ozVK02/qq6
         D/ce9IUqVArS8/ZUvxL7l7hYcMSNNZFIxdPLnhrIlVwHN0aK5Y2akwMy0IcyhsmX2l7O
         MD5VJlwRKhl8xeNViAOLWf/ImbRTOEj2UjOLOr+ZvZYrUEji+t1AEp2OzCS8kJ8dUA4b
         JxuoZtdcY3KowDn2xnTRJUp42arI/BvBTJpN1rg+32xdXz6O0ZaPVwqukKE28ScNOvP/
         uqcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742273497; x=1742878297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vWIezDEnsVaTp50avzaVFN+/54kZx3DW446tGxF6xYk=;
        b=AAtOC4CfYVhst5b8+XKO56kJJqx/L3zCfT20xahPVhmVBiVSUu83B9APmT6SSBWfC0
         Umffblmr8rcYQI8srdoI7pi/ARfYuV548SUfgnzH2Xgf7+UsuyTnIwYuTkZ0OAvConXq
         xzgEqwJH49JxntSLvlU4Gq/B6EzkO1gQfvzHf/psMEK9obhDwSkdRVO65Cujyd9pKiee
         6S5f3EDYU6FzynvLuCpoRcrV9gAWwrYg23Ps8LqdEWR70SZiqW1vfBwLNmH066gTvL9e
         RSeP3yNpgs2RqHYIYR56m6iDUtzCYmseE/7UN2+FoR7e/0lnJx33L4VSiYFPlrkP0+/o
         Fo4Q==
X-Forwarded-Encrypted: i=1; AJvYcCU3mPaFJq22uD7HKvZMDWN8PfqPLdY6vGxTcen+9PRCnzuf7g4zXeVCvZVyFfaFclntWvo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwphWz2PCLUhUHuFpryziI8/dY2pjymlXZFyM0QH3KMMIeJESOB
	92yaHZDKilku5MdJt4APDMHBc/67sfwRyCmXmYxD5Fk6j46HPc7bO6LUzR+/L2M=
X-Gm-Gg: ASbGnctle57YqqHRD/sYcfvTwA4Sl1JhWgol8PvqV2VwNmBQ06fyO9dQgDEyU0FLST3
	O0h4IwwKbVXyid9gLGvrrvL0ghTBPou/GfWGPfYjHlZt2tlntqP+QqabI0ldLzUOPAwcGDIL6gF
	EQxek9INoIY+chK2NLN6bilFyKAD1hZFS9Cw6AbwPiL7sgcPYPCczzirVMc0yaLzfsZhY9Jv0le
	qOYkJskVOF/Kdx5d3m+k/P+gKcLXobax8+5Fi+FE3YPt4WnD+ezHkrQk2w5Rv2pS4SCTm2a1hHE
	ciJk6fn7fM4yE7vQgQvpiR2PUZysGgcDMww6t2T4vYlD
X-Google-Smtp-Source: AGHT+IGfVS9r67mKi+C/QhYaIcplE7qOFrPBNlW784RCUzNr+6ZfRfHv2pwT7sOIOfbETdELQgrdAg==
X-Received: by 2002:a05:6a00:3cc1:b0:736:ab1d:83c4 with SMTP id d2e1a72fcca58-737222535c1mr17970185b3a.0.1742273496888;
        Mon, 17 Mar 2025 21:51:36 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711694b2csm8519195b3a.129.2025.03.17.21.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 21:51:36 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	alex.bennee@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 04/13] exec/cpu-all: allow to include specific cpu
Date: Mon, 17 Mar 2025 21:51:16 -0700
Message-Id: <20250318045125.759259-5-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Including "cpu.h" from code that is not compiled per target is ambiguous
by definition. Thus we introduce a conditional include, to allow every
architecture to set this, to point to the correct definition.

hw/X or target/X will now include directly "target/X/cpu.h", and
"target/X/cpu.h" will define CPU_INCLUDE to itself.
We already do this change for arm cpu as part of this commit.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 4 ++++
 target/arm/cpu.h       | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 7c6c47c43ed..1a756c0cfb3 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -46,7 +46,11 @@
 
 CPUArchState *cpu_copy(CPUArchState *env);
 
+#ifdef CPU_INCLUDE
+#include CPU_INCLUDE
+#else
 #include "cpu.h"
+#endif
 
 #ifdef CONFIG_USER_ONLY
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index a8177c6c2e8..7aeb012428c 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -31,6 +31,8 @@
 #include "target/arm/multiprocessing.h"
 #include "target/arm/gtimer.h"
 
+#define CPU_INCLUDE "target/arm/cpu.h"
+
 #ifdef TARGET_AARCH64
 #define KVM_HAVE_MCE_INJECTION 1
 #endif
-- 
2.39.5


