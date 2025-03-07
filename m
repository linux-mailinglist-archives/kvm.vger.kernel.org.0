Return-Path: <kvm+bounces-40453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F18A5742C
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:56:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 217BA1726A0
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A193220B209;
	Fri,  7 Mar 2025 21:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jfs7LIov"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A5E2080FD
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384596; cv=none; b=KsFys7PQsxG9+BWYuwD96VfahYbeTiv99huwmjH8kYLYbAVkNocoP3DkqD1i0cB/YMmWR6hinolHDy6ap510T3OKSTBaCA2n/zBs43WSrNLCT0Ql4wRpPI38225bJbVDiO3ydFFevyhqQjhuAWEJfqQikiCgCWJQKbDsiGCpPHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384596; c=relaxed/simple;
	bh=gBV4um8wlOhOwRmzVNVgWoclDLVNGnUH5xpVA2pmGY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qhEs3vTBl13YqZXhOPt+GdxIdwitQRtImsRjO4HYwkPkNzTDD/6lNBQ1OV9o2Gldu96DHTLlF+DQ1nXZ9AS87BK4ppVKBCSQeEdtSAqxjmC8NTBeAHqyaDU8ZEpTw2aBtDs/vHlEdIYnYY4lV3o8dbRvtOtlJbX2X6RpRGV1KK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jfs7LIov; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2241053582dso20461285ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741384594; x=1741989394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rr2e69lL8FG0Id6CFQe12hDqKFL6G/BQmRPiJllL+3c=;
        b=jfs7LIovvJKM4hp72RG5rSUnKMWNkXq3dvEFHKVQk++HuWMcHbpWVsDtqE6JnHCnw9
         RxJkiblTeJLy0k3WdYeENId+iMHNqaMV+LpafJiXj+F4D63xDIAes/c7iM4Husv7Bw/f
         fAXWRMu5LMjqgxwmuzofOhGhOIpk1buuJEUOLuO0sspUbBgpinmn7ApaIBD1i7q9pv9a
         eRbqMM+PITKyWsd/Nv8qJeV/k0qOwUBzFQTPqVQ7MdgN+wY63PAK99HsOREM89BTrJJB
         cAXXYj7KWFhvMjElPOXTE1Oxv47D03eTH1h0IwGhd22Bz3mdiXyftbFzTzkzIUI3yuNI
         /umQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741384594; x=1741989394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rr2e69lL8FG0Id6CFQe12hDqKFL6G/BQmRPiJllL+3c=;
        b=Ljzh+NUwR7gyTq6Kia/WDS4aUtShuOIPf6VFGPaCjVDWxq0w1XSBlwU7uLMaW2Eqpp
         80mgM/ltm4KsQB+b2HYlU3lj6iRPCZLz9bIdaXgQMYbysGgvCmWSFxKiSsgZgcoS3UTT
         hs98y7CewFRDX+TyJo750mUCVkjYK8VEHnw9TxMK0himtUMcTsnQSlxuHzDTDtzoV6bR
         IG7NSdVov7JQknxMu+dtJJIamSfixGSKnoP1b2J+Coz+/hqzS52lumKBtt6Vjb1liKYD
         m3OauAQD9uW3SAOVi1VLz3yAq+eytTDCv4gikfQsVIaznVrWRp9ihDscFC3NeilkehuE
         0yDg==
X-Forwarded-Encrypted: i=1; AJvYcCUY5x8w22QHQM50M0K7DFiyg67jujwArxyNCk2GeQ60HMTD3qk0XJQMZJm2Df6vzRG2rn8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+uCzjCRYOMcCtQxwuoGFPC5yZbYdrOc5ydoRjNQ37ptl5SIKr
	b/br+5RDqAAcKZzqADxN1eOHrw7YrIedFVT0Swh62zDNNPnnZRpVoZI5ZTFgqdC0wmi2rby/XOE
	r
X-Gm-Gg: ASbGnctWsAbjx72oUvploNpiN1qaMAlwD6nJfVyp7PAtTaHKIpb2QewM5ZTKLbtuN83
	v7E1UglM9vXdnyxdfedHMdKuT/rY8VD+/Pb9CzgdDCWwzKfHGvJFl8l9pefYXPnXRdghcWwmrq9
	CdVHAQXdXnw4GoGcII9Ehqyp6vn56SqbVYMUa/l6rHi3i8BGFd7PnyYQVfYsTpON7kvuGRhxR5X
	nHn+mq3+FXMa9ASBstmoE3OyE38ZsGlKDFC+h+HGMeFWtaGxu4p8PP7G5Ysyfcy20vebCXMVKHA
	2HjE5W3EGeOJ+sEBYNe5BIzCRfCm4zkG1eFDndTgmy5W
X-Google-Smtp-Source: AGHT+IGQFEGM3zWoP1MGBVKNnQI/YWUNXjOKA9W7V+6fnwmx4R0V57091J+aPoAmgwXrY1gc8ntrpg==
X-Received: by 2002:a05:6a20:7fa7:b0:1f3:4761:2173 with SMTP id adf61e73a8af0-1f544b1859fmr9592188637.24.1741384594725;
        Fri, 07 Mar 2025 13:56:34 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ac9247dcsm2000927b3a.125.2025.03.07.13.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 13:56:34 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	manos.pitsidianakis@linaro.org
Subject: [PATCH v4 1/7] hw/hyperv/hv-balloon-stub: common compilation unit
Date: Fri,  7 Mar 2025 13:56:17 -0800
Message-Id: <20250307215623.524987-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
References: <20250307215623.524987-1-pierrick.bouvier@linaro.org>
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
 hw/hyperv/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index d3d2668c71a..f4aa0a5ada9 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -2,4 +2,5 @@ specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 specific_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 specific_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
-specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'), if_false: files('hv-balloon-stub.c'))
+specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
+system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


