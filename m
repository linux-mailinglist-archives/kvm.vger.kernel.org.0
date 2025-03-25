Return-Path: <kvm+bounces-41892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8037CA6E8F7
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:59:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CF507A35EA
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01F11AAA2F;
	Tue, 25 Mar 2025 04:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zUD1w6Rp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4471A5BA6
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878766; cv=none; b=Pf2AZMW4tf9rL+N+FulTnGc+UtdIjd5CmOtF09Amco8yrQEzdCs/1617iRl3jQr42L6D1Ez0zTSZb8qSLheVJDGlYovgKD/YCahZKRYFOfHkFf3gwJWinHfc8kmDuwQOQZLxqnl69yU9xoe6kHxUVVCRkQzI1pf96ctpZk4vwWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878766; c=relaxed/simple;
	bh=FNWbPWyIBiHF0nV0CfqBzfClbTGXCik9vgvx2iuBaPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U+Y0OJ2SjRJqOxD8wD25LKgOZcmqfKG5y8BNpcyEBw5RttBTYA4n4qYiurjRqrPCJ8BpvAdGvQN2ue9pwGoziZrSsbTiOwfbmIXUDY8jKTMwWjB81G/Si0TwSdMxY6gYnjA7H2Maanw+/MsU4Utt3zu9ocOvswt+UPLLxZarDPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zUD1w6Rp; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3014ae35534so7976535a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878764; x=1743483564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jR5zdvst1499BI4mZMYVh63tqJtsj49dtruLLQFFpJU=;
        b=zUD1w6Rp7NNJrhXxx34DZe3bEx5KT91lf7HxwXJEGJZahIEw4A+Ph8fgEAkxM09kfb
         X4JvafQaRprMZMOdWdBE0jymPoEBoFvq315/tQ/JoCkh3EmQMP5yZ+RVkIJikIWaJGxZ
         XlMSV3yh+/6nLWF+yowmYQYAjIaMXmpsa1RiibOLZAKW7p4h+DW5imGentTA8DNptqXG
         HeB7MPOVs1wmEJGEOTK2nr6BzEltUBOkCkMIwbMflArnP0ZfzuAnsWNat7fC3vdgZ1FL
         3r82TQ+QR4NHiYBq2jYMnpgFm3k+Goq3y5REm3TFMEMmw7kA1N6d1y1djot0o7OwSYjF
         p/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878764; x=1743483564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jR5zdvst1499BI4mZMYVh63tqJtsj49dtruLLQFFpJU=;
        b=eYSdC1p/LI1eivCK1NdKhxpw8GF0Fwm8Zs1CIgrih6nLfwxAyPji+quTRhDgn96AWL
         DNhfvkOPsRVaXyNZNMN/7oyRAS5IGIOigg+4t2FLDqrs2w0hxzgxjumH4VUebRujqlv3
         rjM8VXLrjyUX+1IO+WpGURFeOpWwuzN0HI5Zx0ZTa2U0GGOliW4OAGxenM1K5jkECCWn
         KzIDRggk+vPe4MzOshEdLGBbEXbV4ucurfUkbS1V7C++C4MJKlWggqDuSLsrlHIohx4E
         1hz5XParME1pCLM61u4Xwt0IIcX0nGPw8sDBrvBa1w4STajT2cHJl1TmP/E9AYf7HJNM
         ja6A==
X-Forwarded-Encrypted: i=1; AJvYcCVxjGWzdFBK4yN5wSHgTSP/Sb4Je1M3xb5+xETF127trHVHKLna12V9I1aEcYwag0pFqEg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+qJyMdGnZrRwv1HnieW5lQLkCAkz9oByFiHJX3xZqh4AV2Qd1
	jAXwo4yn5lfbDpIx0edgRsDLzX1hFyYeLI7Yv9sEDjR6+Cr0tadN8jFKzUzKk9U=
X-Gm-Gg: ASbGncuAzVU2so3A0C4k1sycRS470vmKstipbl2ZHfx1xvD44xD/qUMmLsOBVIderdX
	hdWWFIYrtwKeEOCA81b0wIdl3qdcr/izcCsMjKIbTd1DgB2qsMkT2oq/HOircC+a6raqhUJe08x
	tMJ3HRwlEdVPrLyDdx00RzoiEjcPKYqE1nR5aaLF7flXczJTgQQ8ZT4HqcqBNFQYN3c9MWXwBak
	GpNSorhJIoMObSiX5ObFpu2uZ4ysRTCMTIZr683VsD8LTVhZe8nMqzNFO3PDIygN0pv5GdFkoI9
	G6V3uja3TruisevxACXAwHEsrerLQ3n610HnpKb7TRPf
X-Google-Smtp-Source: AGHT+IF09e4GpcORPL+fT4DQZe28sf2+KbqBTnwWuE5q2cPmPm29mL0bJJJ9ciPPSpM9sPRBfLk61w==
X-Received: by 2002:a17:90a:e185:b0:2ff:52e1:c4b4 with SMTP id 98e67ed59e1d1-3031002b8b9mr20134582a91.32.1742878763623;
        Mon, 24 Mar 2025 21:59:23 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:23 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 02/29] exec/cpu-all: move cpu_copy to linux-user/qemu.h
Date: Mon, 24 Mar 2025 21:58:47 -0700
Message-Id: <20250325045915.994760-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h | 2 --
 linux-user/qemu.h      | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index d2895fb55b1..74017a5ce7c 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -32,8 +32,6 @@
 #include "exec/cpu-defs.h"
 #include "exec/target_page.h"
 
-CPUArchState *cpu_copy(CPUArchState *env);
-
 #include "cpu.h"
 
 /* Validate correct placement of CPUArchState. */
diff --git a/linux-user/qemu.h b/linux-user/qemu.h
index 5f007501518..948de8431a5 100644
--- a/linux-user/qemu.h
+++ b/linux-user/qemu.h
@@ -362,4 +362,7 @@ void *lock_user_string(abi_ulong guest_addr);
 #define unlock_user_struct(host_ptr, guest_addr, copy)		\
     unlock_user(host_ptr, guest_addr, (copy) ? sizeof(*host_ptr) : 0)
 
+/* Clone cpu state */
+CPUArchState *cpu_copy(CPUArchState *env);
+
 #endif /* QEMU_H */
-- 
2.39.5


