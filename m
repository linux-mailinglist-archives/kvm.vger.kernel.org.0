Return-Path: <kvm+bounces-52725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18259B08904
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 11:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67C5856602F
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09F428850C;
	Thu, 17 Jul 2025 09:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UqJA9841"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029872C18A
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 09:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752743465; cv=none; b=Jvh/bjZrnVO01Mv3FYNI1WVf191tHVLmhCJoJGfEIi5w7O8yGXHDxDLOKj0Ojd5fFNde7xU/kJ7agPuOWuNjCWzWp19nKtQalVjvbnyTNxfznS6SVmnzo2LCosR1ZOcvimoNsKCdX2sBn5zZfamA1Iq4fuOGnhuUA7U3pTUdOis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752743465; c=relaxed/simple;
	bh=/8oQPYYz6cHSNYNwym9xwEu6RpZClPerPGm665iJk6s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=igFmXrFd5m3dfyLV0yAeRBpYRsTGS0O6Ki/7PD87dG1g0jWD/GQ/fZA93Zta6080q+uBI7Gh4JxnG2fvtXBF5nCqnpFtCuftGYlz/BikUxYA/aR9a0LG7gYEMu/XaFKeVJRdQLNAbxXNOtvTgUXL4CMG8APKqFtlpApBQ90YjV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UqJA9841; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a577ab8c34so90042f8f.3
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 02:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752743462; x=1753348262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HyhBoxrCNtsTMaq/ZkCXVp9e8dnMJwhtRa7CTroNyu4=;
        b=UqJA9841YGmp3b1DmzBZMKxbCOn7lw/Alv6kqdBDhCNgl8crteibLLII7hHyFAi8A5
         DdUUzBHTweeCYOA4JuFYJQnPeryjc6IGSxnUpg3Z7QlwDyGrCxatDcsE2CCV7XJevMGD
         k7iAgIIpPwS+JvAd/0FuNvCz3RWY2UO3Lfs+9hVxyiARutTwtLFTVO/nSgmQcniv1QbA
         HYhzZZkrxwbKWYSu5aw86NZ/pgIkmwXE9yUa0ceMsqlw5DqVKJaxMe3fQMkVwttO1Llz
         lyN4ZrVvztoFH2DkZHYEZOr8Q7BJuR9hQK9te/geSMbUKR3DY3XkVjSj4ji7movJ/Cl3
         +mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752743462; x=1753348262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HyhBoxrCNtsTMaq/ZkCXVp9e8dnMJwhtRa7CTroNyu4=;
        b=cHKuNJCCRdG75oBSZ0oobz84SMEUkZBdvHx9mVyRYjt2eAqVmJSy3TOXm5ip/kasd/
         w6zrSko2a2CGFdh4l46WlRxIJfPpuKo+DPiKtiNoffZ5pmlXPq7R+yJu8U3Ct6EBVroW
         LWNIH2qraW1C6DYTyEcaypZ1VTqKspyRUytU0c5oSUvmB7F/T4uuMQ1oKGJEvovgRmi2
         16wftUfQ4u2StuXNDXWUk2N2sesOdF7P2jQmCf+Psj/JqoOi/OzRMFgw+kjL4ARASKdI
         IILM9vSYT9W7df52KcF6gT+qA3YUUecliH8x+FtaxCJxbk9btaikNZv4x9nZL38lRj/r
         wB1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXSAh9dXhkebOsGD4f73fKhwO1sQPi2BD2eD3IFY3jEhM+qXZDAdx6V1sx2bOgQQyTz4j8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR/U2VZ8qkoH02hs1/hGN4t7aMkCzgZs599/crPwETPMq7PoL6
	gKlh/aq4xc26RjcVJpyeuQ6LYg+N0SsEG32jS7uBFALR7fJhvTzkwHRHWV3eMUoFV1Y=
X-Gm-Gg: ASbGnctPpMMQj5tfG81MxIdsOrPPR12OWqp4Xtq8hFBS+Hmgk+KRtk/rRT9883Fc58L
	L59hfE75Jsrq6GAaVrDbEs2CSmZdrCFEVLgG9wObyFE+qJgAn6A74MtA1FVRrpcMhUFlbYJUHES
	uOIJ8Vb3DGoDbyAWqYgzg7PEA3rHdU++LsVDI51+oa9Il9eKoGgv2JncezE7Ns9ndGm3eRhj0jF
	VffHVqsFNbMx2KVmag5S7fBqSPRAXz+FJHpDjIG78CFrdk9V9dz1dIfp6PeFpFzFC2YDilYQd6Q
	ATG+viz/5Jm7CRxgCiI5dIjdwehBVWnDEHrpl3Khous9qfgYA8f+4TC54kreF2T7lCnIvgSb0bV
	CQS0MQ1QVOFMD8szSfywhQilkOoY9js0B
X-Google-Smtp-Source: AGHT+IHrFGe3+kv5nwJd+XNeEujKS3DRWXLY9Byhf8ifVc9w27qoxH+x6Sv5cjsnKuMJ4OhTyD8jIg==
X-Received: by 2002:a05:6000:2103:b0:3a3:584b:f5d7 with SMTP id ffacd0b85a97d-3b60dd52d9cmr1905603f8f.5.1752743462195;
        Thu, 17 Jul 2025 02:11:02 -0700 (PDT)
Received: from kuoka.. ([178.197.222.89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e1e8cfsm19737019f8f.80.2025.07.17.02.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 02:11:01 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Nipun Gupta <nipun.gupta@amd.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH] vfio: cdx: Fix missing GENERIC_MSI_IRQ on compile test
Date: Thu, 17 Jul 2025 11:10:54 +0200
Message-ID: <20250717091053.129175-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1461; i=krzysztof.kozlowski@linaro.org;
 h=from:subject; bh=/8oQPYYz6cHSNYNwym9xwEu6RpZClPerPGm665iJk6s=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBoeL4d8/4TGosHV8mie+xfGtqZiciWrgzgpC30w
 na+ERnoJQaJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaHi+HQAKCRDBN2bmhouD
 1/zjD/0cJyPefGWza0F69QVCLfsnnCijvT/geB45kgr+TLK3lnT9lyLubK2hUCjwlKCFtiH8tz8
 wNeof8YKDcnPrBqyG4EGIOmfMhI+ijZ61jNFiTu4+gj7tVZ0dHqYx8MFtRjyDnjrTpdx0mBx0lg
 rSyaosVWs629AWEV9j2AapeB9gtgNQJnfhCyyoigze5uc1x6qAz2FPuShy5yfnJYTaglvbToCsM
 ncptmAomgrda477zTKNEmlvgdNnxNi86vmEZR0Vf6LWJHwj6gi/3vJKtj15M1OB4KCcT93QDlF9
 SmXfiLUozswlyVsrUicJV3l8OI2LKFviq1Lj2h/PdbTTLmFVUVtmYAYBhYqUDtnL+5h7XFGXFar
 0J0x0ZyYrViyo8XnNUc9vG3bN1xTGKNXMmPcZdw0RIfTNnclNmxbtoIOWUl9FfhCTmjatxxQAjk
 0aLfWgBslzg0FDl8tux9KXwJ5Vn+gjN3NwFa/U4lQ8BzYP+pkOTmKJJCs1naLhXCsfvPXPjz4bm
 lNvQEACOEtxjPDhc/2F1kdjetaBbmRtWhCf0iBR2K1pIFYSmrj20/jkSq5cuBpd4PDwRawqjNfA
 AWHelP78g1MBkw48ndHMh93lNulCY8IB8SHMxoQ7meVMeykTZmhNixthKHVcJEnjnYkdP5/AhRg wo8dIEv8fqBUaqQ==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp; fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B
Content-Transfer-Encoding: 8bit

VFIO_CDX driver uses msi_domain_alloc_irqs() which is provided by
non-user-visible GENERIC_MSI_IRQ, thus it should select that option
directly.

VFIO_CDX depends on CDX_BUS, which also will select GENERIC_MSI_IRQ
(separate fix), nevertheless driver should poll what is being used there
instead of relying on bus Kconfig.

Without the fix on CDX_BUS compile test fails:

  drivers/vfio/cdx/intr.c: In function ‘vfio_cdx_msi_enable’:
  drivers/vfio/cdx/intr.c:41:15: error: implicit declaration of function ‘msi_domain_alloc_irqs’;
    did you mean ‘irq_domain_alloc_irqs’? [-Wimplicit-function-declaration]

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/r/4a6fd102-f8e0-42f3-b789-6e3340897032@infradead.org/
Fixes: 848e447e000c ("vfio/cdx: add interrupt support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/vfio/cdx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/cdx/Kconfig b/drivers/vfio/cdx/Kconfig
index e6de0a0caa32..90cf3dee5dba 100644
--- a/drivers/vfio/cdx/Kconfig
+++ b/drivers/vfio/cdx/Kconfig
@@ -9,6 +9,7 @@ config VFIO_CDX
 	tristate "VFIO support for CDX bus devices"
 	depends on CDX_BUS
 	select EVENTFD
+	select GENERIC_MSI_IRQ
 	help
 	  Driver to enable VFIO support for the devices on CDX bus.
 	  This is required to make use of CDX devices present in
-- 
2.48.1


