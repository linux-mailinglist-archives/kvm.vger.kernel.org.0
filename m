Return-Path: <kvm+bounces-40215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACCB7A542E9
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 07:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 620C716C646
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0D41A5B8B;
	Thu,  6 Mar 2025 06:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v1E0rkRS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B1D1A0BFA
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 06:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741243289; cv=none; b=X021PKohqyMwO9zab4k0Y7hukIL+8Q2Wx05IsCibd6EtEqvGn1at09ZFfLb2rLt3KrtAYSFaAsCsVHD4E2XzbFNqKwH0hgDKeKPQtnpQWdQPMHQKk9gKhD0pBiFCXYcFPYXEa7hFWAkKee/zVIjXmKQsTt/9WKzPj+KoNNzBCog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741243289; c=relaxed/simple;
	bh=bMUfjPvXfN/tKkBw/WVniDJmAgFeqLIxrtzwYnfSHg0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dv7sfQCwpLp4L+OQQW1zdo/tAmXY+k5sR8tiU317p34EWfrzdbQPMfI2a4s8rYthWBM54IKGTnV5aJbyDvAMhdtxxSQdT1inlxUlKN1Ld+tqPngnFIL2JmtNImF1QMBGnlGsVoG57YzGRqgonlq1wkZF97/OlLWG7CsC0DCDGC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v1E0rkRS; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223959039f4so4517285ad.3
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 22:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741243287; x=1741848087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wT8pzATX7z0g510B/bcUtetzdKIxpUlAXqTAPEA9Pmo=;
        b=v1E0rkRSrXA7hiCgxnWaVNlQg+K4dmKLFKPeM1wizGHmU0C2Q2yy41akil1Mb5p9hX
         1AisQ989+ZLpCxbazUt+a+WG6rCzevIvUZkG1IRD4a1eppfJ/rw8OJRoeAkQxomdEzSi
         XaVOWxQWF50BB23SYM/mpt3zZzjBsmqxwt0zLCG/kg5VmGJFnF5UvfVEq1e0+3L+RKqA
         Lbu85niU3UIITiTJ9yTlkd6ML0zaKORI+FUguR3mXX71YhAn7Cr9RccQY+s1iiszr9VU
         tNaX1uDaGnvSsIiPZlLc6kUBq9eeVTRAaqRUJc2A++JYBQjP2eEeh8yiH8lVA916gTqD
         5pXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741243287; x=1741848087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wT8pzATX7z0g510B/bcUtetzdKIxpUlAXqTAPEA9Pmo=;
        b=fIULCLewr50Mv9TsJyYmKZPeSZ5IxXjwxU11ULsKi0Mlsx5iv7QPGIZs8EqzWCu1Rr
         ZeV67o8Pk9kHLfDb1N5eV5C0h1BiEI/ZVvaMLF5id/rCKGaipP7tfWSIlmPdDCrJxjRP
         GYQjjZrgHR0/wxeA03EY2sShgAY8z2tKx/gxSdTFcmxB6IyLkRxiUIN1AGZPn3C7ZS5e
         g3T8eNWiHlEDfHQKYU1Q89FppXbGdVA8OlCW6IGgzOBM8/atujnq/4mSarjY6kOqwpti
         AygCLUeUlLrrBUVUgC5P7hk3PUJUh83RepohJeOcnT+fu0vZYCM0u0QFGx1/z/u2gkIH
         dKIg==
X-Gm-Message-State: AOJu0YzGL51YbyYAENNuc9cUYY16MhHdK5uKSwRcgcdOG623Nfk74sXt
	zuinojQn8gdTqBdkdJKlLpTueF3eT9VP7HyUS/K/uDyHY39SelR+EE30ctsfsY4=
X-Gm-Gg: ASbGncsLHQ77PYyUhHkSthcPLqcxEUaTyarK+0wPTFoOmHFvrdtrMaAxKsLNcIt4CBc
	J+rE+GqqCilkeak9xoy4yE5kV/T09hHJwHyCqZEPWLn6HNtQIrXX6RelMtI1Y/K3YeUMkfoMpM9
	XdZMeO2n2v0gBG9mEuVXAAlIpX3aOHLRPGmMd4R5uN+tA7qTBeUvLgiMs2yRech1KJ6j8dy8Bpa
	jqS15JfUsCXn4bQ2PMoaC9d38lq+1Ci29NcUrGfnzkj4yPdVlp0XSKX27rKDyj93GXTCUsEM6Vo
	STV26itm0NYAi/lkhWu7+AioOJVksGgm0V4Jmk28W+DI
X-Google-Smtp-Source: AGHT+IFLB8iv4RFayusNn/dU8XKbHiB/II8ZC0o6pkKlvCRP8oMz/PdatWDGujnk6B+WsfH2+JYe+Q==
X-Received: by 2002:a17:902:d2ca:b0:224:10a2:cae1 with SMTP id d9443c01a7336-22410a2cdafmr13816755ad.37.1741243287140;
        Wed, 05 Mar 2025 22:41:27 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91cffsm4769355ad.174.2025.03.05.22.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 22:41:26 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	philmd@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	pierrick.bouvier@linaro.org,
	manos.pitsidianakis@linaro.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	richard.henderson@linaro.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org
Subject: [PATCH 1/7] hw/hyperv/hv-balloon-stub: common compilation unit
Date: Wed,  5 Mar 2025 22:41:12 -0800
Message-Id: <20250306064118.3879213-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
References: <20250306064118.3879213-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


