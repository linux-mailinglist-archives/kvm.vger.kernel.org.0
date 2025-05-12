Return-Path: <kvm+bounces-46206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E22CAB420B
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BFBF18897CD
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:17:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFEA72BD915;
	Mon, 12 May 2025 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MCHx1Li1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381002BD581
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073118; cv=none; b=V1fOmGR8ocdWg+Xqco5AjTw8HNtg9erm7453wwEmJhWvLtLzaHaz2iNjsMhUZB8dUgkVX1oZYYMQPC8hQIvOnU0Pt1EUYkbBcONNRO2hnPrOZh2MMx4U81bVd9lkXaPFhjltn+o/X4rZQaj20G7hVFxNAi0DrlGvFR6+f6/k1Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073118; c=relaxed/simple;
	bh=1hAGtngwcXI/K1ZVwOSxlRZCzxWzI2kpJ8rbj0YHGnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+Use842pV4vdsmmLeV5AldflzpWrhz7RUvpcS+UgNm+bNxET0s6ELRiW6PJR8jCqh0LzTDtEEPrmZ+k+5JFHBvIyf5/+QOdZvaXJWqEpIMfqdgi8Pyezsclf17GNaPrKrygxQJySSWpQW3GO1AI1tdacWszbVO6CFP513HXA/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MCHx1Li1; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22fac0694aaso35621355ad.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073116; x=1747677916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=MCHx1Li16dvvKjBIP6+O62/X54FzWpb5rHgPRSL0lhcyC3OWbfY6YtgRIk4TBA9y8m
         eLdcFTq3VQZPJ1RZEtNFeSIScnGJ8ZSjfaCqRqLxyQjccDvD45cYw73Od2itfhVtR+Qn
         m/5lBc4xlKv5tUBQF+OaPBmyQXH3pkmShZKLy/FozBMcR4reGU8ED/OKYL+ZKotydgRO
         cN4/34Axogy7gpc4vgIBsvQP/Kkc2TbqOhM7hNtkH3rYpH2uRNVwQIh6uSK+3SuJLkjM
         XkARZPKrLOjg/JY7qBY13gIj5eyieMDkzzgvmqei0k9uIJz/0ENMRM2zEp9X8FhPZybz
         VwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073116; x=1747677916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=QGYQz7UC2bgOdTNpkSL0/ySFoSvmHKYqImrS9YUgD+3eS+4aWnm+ADO6tgzuZ8QW/X
         i2O2LSKFJ+4szIDA4uSt/fTOBRs8akqoaedI4SU6pQAzAK38jHUbdoj0tNqj35aS4Kyi
         EFyvAlhZDDXa/GVRYYW0ipffa4Fx99CNT9bVVB+ROWX9o9Py4xGwOHsSxIIwc7yGN1wB
         tX7HNc01VJ/AyF5YsnLeZNVgdzo/ZWHiig9k1+6OMDB/mP4D1et1KhTUxrKq1PicmiE4
         5xX3oW3Pl2e19YbK0fDZkUXN0UvV5rUU4uPNqitTKyARqK+/lCzKH08Ad3CtO8gFopAy
         5lYw==
X-Forwarded-Encrypted: i=1; AJvYcCXdMaj5eawJ++259ikBQT2oV6nyikH/yUkBeMfehmfl9ch52foyYcU2i0yRFC2+0P6kPko=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5loUsV+O3LWGEeljms98c1whB4WIzkQlSb35/8pqwmU6fvwdc
	Rxe3t6LJxqaK5nU2PvRjpRAt9ChO4AFgcfrLaCsQf7bugx5CaL/ZCkqCyij1kBA=
X-Gm-Gg: ASbGncsQ4I1bH8MgtUGzsRNLXmSNKAWYhE4U9LWfs4aK5XRcPTvpqVl/iD1Vb1PqWCY
	qEYagOWkNAzU39HmW5wIKCbGcErX9iwQ+E00ZFPT8I6nAHp2i7MDfOcQjeWkRq0HDcdmhPgm7Dm
	0OzDgw9Iv0hvR2Y7kunJPMOctQqD4poPMl763wsqsMwLynwQX3pT8T9ljCoFcpBaPvfSj7ZZc7a
	atNnwjDBqCRN27vjLz7FGtrJR8swCbKAICi17XbaemHJegK54UpdEhMnndG7K1vNN2Q+bLFjlj8
	Ad1kvfnb6fsiPwujonuJg9Zx33thF8DbtvUQCkebYK0n+VD07e0=
X-Google-Smtp-Source: AGHT+IHV34nofPlHI7j/tovgmgz66yejcHSaMZaqrSu57vJ9NQ3EVTbiO5LssTGmikR7Zmo7cr5jug==
X-Received: by 2002:a17:903:187:b0:224:194c:694c with SMTP id d9443c01a7336-22fc8b592c5mr225744135ad.28.1747073116233;
        Mon, 12 May 2025 11:05:16 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:15 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 05/48] target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
Date: Mon, 12 May 2025 11:04:19 -0700
Message-ID: <20250512180502.2395029-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed in target/arm/cpu.c once kvm is possible.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 2b73d0598c1..e34d3f5e6b4 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -99,3 +99,8 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_reset_vcpu(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


