Return-Path: <kvm+bounces-40390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF69A57120
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D738C1894369
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985FB2500CC;
	Fri,  7 Mar 2025 19:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XbziArqZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4467624E00E
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374614; cv=none; b=J7Uai72X6prWi2M1Vfs4LG4ljbD62CBz7YFFuWrLdTChbqWYphypGyooYcAQxnE63CFSOCTP3zuafg+oWmHbDTrxtVac1BP0WyciVvT/+n+KxoGHyQH5DCbzlnMAat5axFlYRG5LZbv4O5PdI9GZz/Mqk5jIajHZj8ifZeubRKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374614; c=relaxed/simple;
	bh=10QOE04Hzw2CVA127moBxFU93ptkxXvz4w3Lk4YoxwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=May4NSCyRjJpaJ5hrCltGyHBitHS8AxIF/SYbDodAfvyv9UpxYvWvdmDeyoUZ8LyjOuHMigFrrd1IW0/msO9zLqS+J+XMCJhOcqCzqxoVGWOs7RrFgcrKPJjKq6/8eFN6eO1xTpBxVM7mJwNKF3ZAmXxj4wZbC+Em0r7tvCWo50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XbziArqZ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22337bc9ac3so47629655ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374612; x=1741979412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGch4Y0Ix8wHfMNh+EmB6vJG8JHgkY01LTyS9A7oXr0=;
        b=XbziArqZ2r2ntDbFNULSZ6VNY21oLoK2CBujIk/lc4niwK80QuAtKRmQb6YX5H6IxT
         yskLYyA20TorjPIMKaQSX88JHXZsIunnc1E0E21/aGzdxAfR15XuDOzzjW5vSMkQ3n9q
         p68lVuGLRdgZJGEqDT30YFmkOnSnXkD7Z9Q5PqHsAUB3PuE1VtWaTXo0rs8hGgVD+nbm
         SJEB9BqbDLnlyqcyuu+d8LWxmfl5pogByrmtl5A1ia26WWnMeO9feJeh96If7YmJKIxc
         okQ4fTiKw/3OOR04nGCV9VhYos5ACcEtK56ptwfM4aqjCE1t7kN3ItZi8oPCEOy/JHfL
         VehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374612; x=1741979412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UGch4Y0Ix8wHfMNh+EmB6vJG8JHgkY01LTyS9A7oXr0=;
        b=e/xwEW9U5ZdXeFXDO14UrgnrDV/2VbHMgTW1Oc+IiMvb7HtEDI7gpC8Rc9F0f4tzqf
         vXGB8X5Py06KkwRYguq+Rq29gl8j+vyIeXhEEo9zf1bPfVcsZU1SBWcnWaKlh2naONkK
         DETlEJUK+fY/JWLrebK2dw7O1+G0AkcafqjpYVX0TXFb/mJHt0THq+iQkrDpXaJ6aL5N
         hB9HBv6hPLyk9bRARk05Km6Pc8A5iD/1VK4CknPsF10BJYGXjRa5rna5LTxQlGHdTgHY
         xymYUkSsN9cUOHNMwkzsfnzEIyj1kCVRONIabdx6NGI5K0E3YP+zFGQKjuvIo6hb04JT
         eRtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW1k6OTO0kRhMOJP9kRzsHv6J8kEs3jADAeNvl+BiL6KABSLuIJ9j5u8EplBmFG0ki8FA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6nh+Rct9vbhz9onV3DGn6oW3foeZ7zAUUoDpQ8YwlbBkgFlQ2
	z8NZRn9Y93H0U4reVKOspbvsCmcueQTUONkRArB/UFjLlyBgI+rCzJC82OrKqmo=
X-Gm-Gg: ASbGncuWIYXj54MZhseDw0j3ObBLaINz31kWIRbLqYLnt4w746PpLeRJsScFJmHIUqP
	mQZrtNaZjhbC/2DcRxkU4RwDDR+WGlUuuXe9cf7JHZQRHOezgo/xo/ql513uGx+sS6h8Eq6ji6D
	Cqn5HVtJuPLcMuRo6sxa0B/ei+q5YgzPQ5BH1V5nxAysTxPAPHxiXyg48U8NabEBzobbd9d5Jea
	Ugf1Rx10ScyAVJmE/Qr9msKKyKzC98I0fbe0nE3idA2oCOnLZt6OXF4CxliwUL9qFoV8UsTU0ub
	HpjNHsnDgp0k7sOEL7n3zAt0EkcAdEDTBOJPSMeAwmKs
X-Google-Smtp-Source: AGHT+IHuC+PNa1SmzqJI0M4CoWasSHWXoq4grtPPWkbR5pKc5S8Z5/JOsqXNjYzvCEePHATvEPGVWw==
X-Received: by 2002:a05:6a20:a11f:b0:1f2:f1a8:fbc8 with SMTP id adf61e73a8af0-1f544ad7265mr8852497637.2.1741374612398;
        Fri, 07 Mar 2025 11:10:12 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736b2da32c6sm1449895b3a.149.2025.03.07.11.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:10:11 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	pierrick.bouvier@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v2 2/7] hw/hyperv/hyperv.h: header cleanup
Date: Fri,  7 Mar 2025 11:09:58 -0800
Message-Id: <20250307191003.248950-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/hw/hyperv/hyperv.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/hw/hyperv/hyperv.h b/include/hw/hyperv/hyperv.h
index d717b4e13d4..63a8b65278f 100644
--- a/include/hw/hyperv/hyperv.h
+++ b/include/hw/hyperv/hyperv.h
@@ -10,7 +10,8 @@
 #ifndef HW_HYPERV_HYPERV_H
 #define HW_HYPERV_HYPERV_H
 
-#include "cpu-qom.h"
+#include "exec/hwaddr.h"
+#include "hw/core/cpu.h"
 #include "hw/hyperv/hyperv-proto.h"
 
 typedef struct HvSintRoute HvSintRoute;
-- 
2.39.5


