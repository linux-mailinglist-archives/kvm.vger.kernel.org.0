Return-Path: <kvm+bounces-41622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB2FA6B0DD
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7856C189ACE3
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 22:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1073C22A4FD;
	Thu, 20 Mar 2025 22:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NlWYp0Xm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80A522D4F3
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742509833; cv=none; b=FCtqWrRjHo8t49N69uDdPX9i0fv3B0vzyZ4BTmVbvoXtHOeZZHwHdbeDsLSeJcnQRYbPTlzVfvl4NIPpdav+cOLdAXlR7y0GwZvq6eqaEiP5meohTVhnWY6jU+fA6k775in/2l71ia96U0WuwggO6Ix5mjLZcGg1oUY4iRyQN+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742509833; c=relaxed/simple;
	bh=6doaygomDuttI7EqQkZwBCAJu4hqw3kFyKLyolOzKU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a7s/YqRFj0YHs+5vGUBU6n7X3CbWWKovHRZ8d7c97uaQfBtUIs3O2Fyz66DAhZp8PhfIpv/HjginweY7MWKOouBQXrwAy0oP4Y6lXtugi/EfFiNXxx58eauF+1X+cJM+ptcvRrQoCVNwnS/ALB+cu3jtJ9Zx4pmD7gBPaznMgg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NlWYp0Xm; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-223fb0f619dso27817885ad.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 15:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742509831; x=1743114631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lGjkhQ7Rm7y3SPTNm83ItgGSoGlWsmhX663zoINx/mY=;
        b=NlWYp0XmxdXI33EdaA+/ZIAvJ/5+Re9tRNlcM/uprtu58iG7UrHrDYKQWiopQQ2c0n
         iuwisn5pCwo5vy44Z/ire89LIsF5Ok+OueZJfezZ/k7HV2CRzJnXaY63v7z6bHkmRYVg
         k37AaSn8jCl+dW5NQYhz+YtvlQBkNsvGeqIHcnLoXq01orQ6Ddu9a5RU53uyQ5Demzdy
         7K7grcy4PpPGw28I9efk39IzlCijmXGZqaCl2kAH88o6Qmr1HWaYFox4v0a/1gv8auYl
         i/kMc0w6SO8VbZvh9+Ef9I84YdAYfI7/vk5gvpFQZh2gldQeD66oZILCZegaXDsStI4b
         7mDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742509831; x=1743114631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lGjkhQ7Rm7y3SPTNm83ItgGSoGlWsmhX663zoINx/mY=;
        b=NoXr4OSl+81JLkfsZCM3bEjZh3SBvLzIFk4EoaFs8lqWV1GBBrpKsNDIb5E7QIGbgs
         2IQxrWHNKXBlqbKCDNuNuzmQjJxHSO6EG0A/Cwm25WKO+UZPGuEKmbckMkalW2SyFT8G
         3uOe7yelbVQljHkFad0P0qxjYZWUt6OZbtl/RLebWyjxJWI7wSfVnOgJ4wPBilY1e30s
         wEndTC1KMugDUjiXtyq5uCV5ToWY5cdFS3wIyD6mK7zs0hAp9JBgkbEexU7Jrns466zH
         bvBGDPtm3jytlBgMJsTSMudMNfe58TqcnYLyDubGdSIn/CREIbOLEe4+3qf6Zft/056E
         /LiA==
X-Gm-Message-State: AOJu0YxsYcOiGoJ7fOq+83jUuPDSPeWw3XSpBaqDP6g9KDuaTum47nVW
	jowrZBeOt57DpEVu3E3H8DNIpYVgw3sQDuKbRNZKwC72F8Rb6ryuyO+wHXG1YtI=
X-Gm-Gg: ASbGnctl0AQq96+SWoFiP4brOT90xbnuJEQURUWRNW6ee+xWWfe83TdHRZy0XYXnvwU
	OQpYLFYVoGaHuDt0JOylUHIfcU6M5TyGosZ5wD4wwhEDBe3jtjRRByzo/Ka/TMlNq5Zoc1UDgYu
	zwzObFCI0UGyr0yG+/AJZLM0neKg+KB5jc6C4uBDdhOAV2GUHz1zeY44qKIYeQ162lqP0flhdAw
	pLIBib38/ieycrluKhWkgNCDLXVdCxuyRYZ16WXvymMdOak5ZBrTaeD6ht6IFaUZxDB8rXjDxYm
	qIEgdpVpKSarL+549OcH94JNpmwadWENIyXn1tPTt4kB
X-Google-Smtp-Source: AGHT+IECC2u96EUAdCu+nIhzRGOlzelUPCPjSbY+gS5iVhhPcKqW1YWZqHzKBvuL+vB+mhXdR/p94Q==
X-Received: by 2002:a17:903:2350:b0:223:517c:bfa1 with SMTP id d9443c01a7336-22780e10d13mr14113105ad.38.1742509831103;
        Thu, 20 Mar 2025 15:30:31 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f4581csm3370145ad.59.2025.03.20.15.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 15:30:30 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 19/30] exec/poison: KVM_HAVE_MCE_INJECTION can now be poisoned
Date: Thu, 20 Mar 2025 15:29:51 -0700
Message-Id: <20250320223002.2915728-20-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We prevent common code to use this define by mistake.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/poison.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/exec/poison.h b/include/exec/poison.h
index c72f56df921..d8495b1d358 100644
--- a/include/exec/poison.h
+++ b/include/exec/poison.h
@@ -74,4 +74,6 @@
 #pragma GCC poison CONFIG_SOFTMMU
 #endif
 
+#pragma GCC poison KVM_HAVE_MCE_INJECTION
+
 #endif
-- 
2.39.5


