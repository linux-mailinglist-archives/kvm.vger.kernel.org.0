Return-Path: <kvm+bounces-44230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59E9BA9BB3A
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:28:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11C85166EC2
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3D528E60C;
	Thu, 24 Apr 2025 23:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GeM96K4O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCC322127B
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537321; cv=none; b=iUSvbSZL5FFFTCFXehtwasEYGPKUF7LY64x6/OkXwcILnmXUrH+6X0bTDhVkOm752eEsOoUd+uVrNvDVTwNQ6KkI/gLhbIa4fhXI8mbJBA7dq+zyyfBNUmRtJsKNC3uNfgEcO1DE+htLeiSZ4irbut1UAGHAcnUzxR0l2OIPhzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537321; c=relaxed/simple;
	bh=gBV4um8wlOhOwRmzVNVgWoclDLVNGnUH5xpVA2pmGY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NixE/3L5pMtp44m0NVxRGXschCIp8hR6itrftc9WvoV4qSxfxCxbULJph5iGcP9DJ/8eOvFo+dLZLMfqNR3SySK3FeIQrObOJ97GfWqT1z5XX9rmLLajNtlrgPROfmaZJnTdM2m0ClfEP4vmhalWaErT+juTbH87cY25xwSTVj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GeM96K4O; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736a72220edso1675107b3a.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537319; x=1746142119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rr2e69lL8FG0Id6CFQe12hDqKFL6G/BQmRPiJllL+3c=;
        b=GeM96K4OS7j6zF3l9JAZOKlP3IiTzh8+jt4Hro8A7iMsgEGG3rmAqSnWz2BplP+nEP
         BCfDB61srDrqHVK2azXMYtwInKWVidpi4kqoWBoqZACDBF1BPm+1xnblqFFBYztOU62g
         lGxjj61hlWojHSS5OZsLaxJl3w52tXAYnNuyt7kC9Hdy+0emCJGin0I+kvbchsOpo3++
         J1HxAImkW/MoXvrGTRoE2YcOEsMqp26a+/U03I5UUrOtCS5TspyYtX9ZJ3OH12Rgs11L
         1GuULKt4YrKbmBr1xIMqEkHmbvKqqd9OcGsjrC8IRbuOygSjuhNBihvWMSxRd9Tt/CNQ
         D+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537319; x=1746142119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rr2e69lL8FG0Id6CFQe12hDqKFL6G/BQmRPiJllL+3c=;
        b=p7E9exik8RCCAv8HQSy/1zLBGQxNhXHnDwyPxz03dyqI9XG6G/9yiUQKpIXEOlC+3W
         7K0g1wF7ky6RSafzujfWyT/pOfShOxzDVNwu9gea1W0KUpRXA0+cjJ3/0gOAnnXqb2to
         s0kKcsjDyfPA27W6gRq+tYCgOx2w+WPEEnli30CFvLsfwv+LL1Yo2TCMLDwJEK1t/3u+
         RdzsX53sy7xW01SxQF8ydFW4P/xNSwuF4RKNzVBFc9C+buH2XjHqdkoMmcO8VRQ2CxZU
         2Odkgau3g6FvUP+Jm+odwdyNy2wuyXNkT/+ObNRIG3xK1veWV/fzmOwTGQtrwS02PIKd
         gRhg==
X-Forwarded-Encrypted: i=1; AJvYcCXrhVHVwCI00AbrmXSE+MyI65G/XUg64yfa7C090D6tvIg6HCU17+7Frf2fizNSjC8w07I=@vger.kernel.org
X-Gm-Message-State: AOJu0YySk/n+tjoZpkYOcGRDJIdjw33SKvJ2x7QwjRAJloaOftsvdOvO
	6CvaCmSXa+0TMN94fK3mKTPxYrFKbkMDylbyXDeoqo4tiLzPtYAXyi33O+X5JgU=
X-Gm-Gg: ASbGncvIEr2K1xT0fQFVAAtuLIho4DB4cvLKujli/r7zSeImvzdXASw55wG3lv1Bhmr
	Q4aALuViyn3Cseyu1Vkw3uXQReQ0IsrRdTQsLyZmo7haU3yKTyFWBLZZ7zwZ0qkAUrQi/y1Syl3
	ofYBL2LZJjdpIlmpk891IeVP2Wwa8NLi7Hrgq5VFVFCMhbzSIVXTBGbQfVsl4g8dF759KHL5ypm
	QDT0Yrz4gTaht1uHDhTg0mPq8owqBlXIVSySdNuT9DKl8AH9bEB3433lYfg9bJEayC/ayrkOtKe
	GRG/nbHEsghINR3eHGCTn+1C5+3Bhza58sKIY2oj
X-Google-Smtp-Source: AGHT+IGDAv7ZRPZK24JuZysSUxJD9eScszeTRLJf5rTSeNILzKD9xtRP+HXWEcWxmzdyLHweaX0IQQ==
X-Received: by 2002:a05:6a00:a8b:b0:73d:b1ff:c758 with SMTP id d2e1a72fcca58-73fd89776a2mr123943b3a.18.1745537319295;
        Thu, 24 Apr 2025 16:28:39 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25accfbesm2044318b3a.177.2025.04.24.16.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:28:38 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	philmd@linaro.org,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	richard.henderson@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH v5 1/8] hw/hyperv/hv-balloon-stub: common compilation unit
Date: Thu, 24 Apr 2025 16:28:22 -0700
Message-Id: <20250424232829.141163-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
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


