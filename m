Return-Path: <kvm+bounces-40395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E74A57126
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:10:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF875189AC64
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14AED2528FC;
	Fri,  7 Mar 2025 19:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g0U7RYvd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFF42512C0
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741374619; cv=none; b=LTVnbyT4/q/ay/jueuH5IyDE8ORggVKpiykBtL949zf7Pgq8+Mt4nZ1Z4yRLYHgGdAmpVKJriAQIhgyWOceweo0vPcHzM6eGAP+CYhvMs7HM4KkMtHSf36OTrkHsP2WXUZffFyu6OeA/4v02x+WUQygSB/rk5cggxtFKLKr0Lyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741374619; c=relaxed/simple;
	bh=HyHaiDVA7lVwaYVjiQIxGFKufAoNsvAgFuXov2/NWCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JDxfA2xLvRr1uVAkc/qYEVMsQo5T3111rMiiQKPryWeK2ReTpgJl+34/DKA4Z1fm0fQqB2ReIOO1XXa+YyDmURGXUak7nztkj8s6QY9HPKzcI05covJl6bs68JMLf4lgW1Pxo2j/TvoEpkLoSGLuclJJaIIRHXfE+L2+Gmt8V7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g0U7RYvd; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2239c066347so42283675ad.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741374617; x=1741979417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KS1pyoPrhLTMjTQ7DxzuSKRnXO6pGHCc8r+hitBpHy0=;
        b=g0U7RYvdFvJlVEBNQUHm/Z5s7UXub0xy1bVlgX2ioIKzE18N+/qneB14aM1U2IANju
         doV4wQJmhxMBbQo5sgqa6owWI3EqJYZwZPW8Y5NDVzuwb75nk/kj8Q8RS+k8W9Ywx5mZ
         fhHQFhpTnOJhvnXKO2ryWG/LBtwpr6ROIZu5HTsgQHCSDNb3unhuAYu3k8bo2Wyes+xp
         +ntBc6dT00G6VIwcaY9JPU63OVyZJt6ObQY8br/itd4e6FgQHHFCkdUuT25bQawj0uHI
         2jUIk4iqWo496bPAQ2Bg2q3h3R5Y9ve41vexcpO0SPUsXtI3s7UBXsL8vgcrbUP1vn/w
         GthA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741374617; x=1741979417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KS1pyoPrhLTMjTQ7DxzuSKRnXO6pGHCc8r+hitBpHy0=;
        b=M24P7hIDP17dvsea1YEtTCtmcVchfaP3dTSNwV9dM3z7GeBFzDnkqRcGUe4JyyAhIB
         wQvSiXuuPeT+aF24GjSdDsfjmSAXxAYq0OiwCexPe6NDdJ+MKn2Wl5H7I8KaaNaDFX/C
         8p11NJaq62Jv3xX1GW7Tyi/rpfhnydzPIAIkmm39zqF0UQdkZ3K9m8Ou7aTnNaDkKm8a
         Z9318RZiLTMEe9nSXlCbG39MNoKF9CT3EyjNgxzT+4rUMu/Pl++PcojquAKSFOyof+WP
         xvuq0snPd7BnRknvlXzrAowxVtG2Okc+/yYx45uA39knQBNRp5CmwlcFp2mgXSxp3H05
         Ymqw==
X-Forwarded-Encrypted: i=1; AJvYcCUhPsPbPBFlwIpvycEeHI5208e/VdzzA7DolbPx5JFPrRFYk7OJNTWSJSpz83/dMZ4oecg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMFNSnFYYRkzpnhkUTdmETbifuQRxzvemx3nrxD0eHncJF2mdP
	YIPJaJC6h39lFRab6K9ibd96FYjFdkIlukobfbEErf1f2llI8thkvEOJCLRIrew=
X-Gm-Gg: ASbGncvG7f+GaMLa2nGJwxN6bPwuYahgay+WpI7XW5biEP0kGKWEfv8wu+X/IdEhnhh
	aJ03BIuw7Tb7Gi0nyrQM3QjTbKMC1mUNz8rbXgmeVaJUgKd9HZvcLpK9HXO7AWBQQ+DGYiUPRrg
	HmG9T+Bf80EW5t0l4xsFnt1Q0+sZmmSqNBQxm2Xjte45EePDUoDOvbpIxOBJSl57Il843x9NBhN
	mw6NjJFOKwAi5c9Jp3XKh1jR7vW3HtyppQu3OkK4YRcHv2R6E36gdzN6UINJ4YeeHbucIS0e8HA
	MGl6HZqUsaKY3camkVMrP8Z/Ut0bUhDB29wJQsqXdWUY
X-Google-Smtp-Source: AGHT+IG6FYKNJhA8fJgyJC2Shcb8wrPw9XFICBMg0Te6QK6uwGTN0bNhmb4BB9yGI8nrBiug8C0XEA==
X-Received: by 2002:a05:6a00:4b4a:b0:736:54c9:df2c with SMTP id d2e1a72fcca58-736aaab75e8mr6208720b3a.15.1741374617086;
        Fri, 07 Mar 2025 11:10:17 -0800 (PST)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736b2da32c6sm1449895b3a.149.2025.03.07.11.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 11:10:16 -0800 (PST)
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
Subject: [PATCH v2 7/7] hw/hyperv/hyperv_testdev: common compilation unit
Date: Fri,  7 Mar 2025 11:10:03 -0800
Message-Id: <20250307191003.248950-8-pierrick.bouvier@linaro.org>
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
 hw/hyperv/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/hyperv/meson.build b/hw/hyperv/meson.build
index 5acd709bdd5..ef5a596c8ab 100644
--- a/hw/hyperv/meson.build
+++ b/hw/hyperv/meson.build
@@ -1,5 +1,5 @@
 specific_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'))
-specific_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
+system_ss.add(when: 'CONFIG_HYPERV_TESTDEV', if_true: files('hyperv_testdev.c'))
 system_ss.add(when: 'CONFIG_VMBUS', if_true: files('vmbus.c'))
 system_ss.add(when: 'CONFIG_SYNDBG', if_true: files('syndbg.c'))
 system_ss.add(when: 'CONFIG_HV_BALLOON', if_true: files('hv-balloon.c', 'hv-balloon-page_range_tree.c', 'hv-balloon-our_range_memslots.c'))
-- 
2.39.5


