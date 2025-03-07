Return-Path: <kvm+bounces-40458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 121FCA57434
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2B783B0CA0
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E57C257AED;
	Fri,  7 Mar 2025 21:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GUK5ubYm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A91257AF7
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384601; cv=none; b=ddTeH1pJs5BjtKA5C57IjtL31d3hL8zRDpERkx7P0YZwWEDuzGVq5HwvPVq+eDOR/cW1u5ukxVwJeoTBZwvWvOQZPYvNnEXHWeuTT9tc5LM9ZgCaFamhYtZcLHaeVIWO89pzJneERjpvPj9/xz5O61i9qVvWDziBGjqu/bgxKjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384601; c=relaxed/simple;
	bh=yio0TGkUh6/xOEAR0qrHm9LcWB2v70X+5IB7niAjnMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ht+MTMy9o8gxC3dtQgnouJlH2/MpqPVjMaiAJrzj2rygNZeqjmgfp222fVVxXIzIL00OqIW2PlZqojYq0gSQSEaFIqnQwDPry9QrwMTqOxKDBoD0mQIy/oG8BUjNIrINFLf1/HOOJSso3DhrheLkInjXLMrF6IyflQYofFHdQf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GUK5ubYm; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22349bb8605so45677835ad.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741384599; x=1741989399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWZd7ZFPXeg1oTJFx/lxzeskCkUEMUuswiCEr0poukA=;
        b=GUK5ubYmbMBRd/IP8bQYbOQ3XdwV0wd2pmPADOH9+EIvek0Ljlf2cBNp7+t622VpcT
         UO87Jr+Sd79ON1dUaEn4UG2UusjNUH/7jz7Te3wB/RkzQtz0zf7mesreq+EcqiG9OM8K
         cxMQQ+RGC/3yvtpOI8lI+T6evE7MvACWlNeg/NG7c2T0K0ICNmUg69vUPtkowIQFyecw
         TDybflsOm+OFahCvWAduUggnSvzP4+V+QZNaSIH8NkZmBCWSiUMMnW0PfOSgxm4Ry3wQ
         OnImuPZROAEmY3FlviSiFXoxl6s5OvKCJY5eRHyu/qHwsumxeW/9BRMHUETIFMSDfMY7
         mGMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741384599; x=1741989399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DWZd7ZFPXeg1oTJFx/lxzeskCkUEMUuswiCEr0poukA=;
        b=Ss9nMO74gXqme18k2dVS3ww3k0xorGSl77TPzBZxuctlb94n7BykB2LwlJH5i8qa1x
         UbjnJavUwhvtEPJqY8ixpPd568LmiGzSyhmiEP5WHke00OxCFr3oX8iOfrgaF0V9LZIj
         NgGJ5vhPUeSBi8hMCRDT7swcymsoPkBtBX0Wj+OS38SBnzFmCyu15KQhieg0HGqZQapy
         QpN4GdG0mxhAiMbeYKnR53Uf+sHc1Ve48QykevgapHl43bJSIMf/6uq/lyn3HtCW0z7q
         6MIV5Ht21k5uQ1qYzVp0KPGg0bwp75VqelMOb+qiz5aTnvSv1HjL3mkl1QoFss0vWegw
         H/9w==
X-Forwarded-Encrypted: i=1; AJvYcCVYWTTMY9j0iw3qRVZJLhzXbC3o889eP5la97vXDNKVPfZcr7FCal4SEODZKOuDT2hwV2c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWE7U7FUtUGYw+v4Jb6qN8gZ20baSFmHblPDcBgcthmmP9fOZR
	cA3ilQniBWcs2gEx4ZvcXnRtucG9QaEslgYxanR0hljXkfJcYc8e6B2a7KMKYw0=
X-Gm-Gg: ASbGncssHY3SN0jB3NzXkvNDoo5Td0zuLbQM0dKY+a1ExQKjk0tcTMFTQ0K1hJOAFBA
	9jC56sK6aMHbCEvEu4/Tw5fvi1Py4224dTLv8wDb6nGRlKwgiNXoMEO2wehPl686yGIXVQIaB4c
	J4hBOwY4EPoYb6e53tLe5V0UP8HKvjkvz6SgsOLCjNoPTxS0lM3ocbelcI2B95XBYporjyvHUYD
	Ew6nwUIdkR8EJLeAfXnsiGQV/S9Zn3dItytVe2syp7nB/ug01JhR7KVz5ejfq1UAAGXXSBMx3PX
	xSrQpAAWNGb9Rqr2vBfTNtDJ0wva2AD7mcgDgV40ro1A
X-Google-Smtp-Source: AGHT+IEf0nDxCbA48uVWT5RLLhww+kYNc7RKaulJqeeGh65HDYuCmuub/N7o5BoUJW92oxv3wqHUOw==
X-Received: by 2002:a05:6a00:2351:b0:736:4fe0:2661 with SMTP id d2e1a72fcca58-736aaa079e4mr7096514b3a.11.1741384599320;
        Fri, 07 Mar 2025 13:56:39 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ac9247dcsm2000927b3a.125.2025.03.07.13.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 13:56:38 -0800 (PST)
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
Subject: [PATCH v4 6/7] hw/hyperv/balloon: common balloon compilation units
Date: Fri,  7 Mar 2025 13:56:22 -0800
Message-Id: <20250307215623.524987-7-pierrick.bouvier@linaro.org>
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
 hw/hyperv/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index a9f2045a9af..5acd709bdd5 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -2,5 +2,5 @@ specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
 specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
-specific_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
+system_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_false: files('hv-balloon-stub.c'))
-- 
2.39.5


