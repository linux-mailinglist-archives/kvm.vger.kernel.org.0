Return-Path: <kvm+bounces-44234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF381A9BB3E
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:29:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA00F1BA430D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AC529117E;
	Thu, 24 Apr 2025 23:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dOUBUekb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A11E28FFD4
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537324; cv=none; b=iuGK6jKAf7MRGFB3t0BTTc1wI3h+WIKvNTSYaHWuM2GM01YsDbNBcN4EW7YRZoBfId3IAsebIEnlWtgyL2W8tddjiwI5c8ePLocUVYj9PmSSr8jYPiCjf1H0Ne7UtBBujkN3B/WSgIDoHz6oZ8tMFio0iqjDb8Edljp/CoqgVbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537324; c=relaxed/simple;
	bh=yio0TGkUh6/xOEAR0qrHm9LcWB2v70X+5IB7niAjnMc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bsgneznbAu2foUzQRYORIMlrgmAgSt1Y1G4bcOw0BHJnRx1bn5xSxxz9opRW+RuwoH4iCijZe2NrvmEvFS4CaRKo9NYakKelJgKd2AneCbNfeebBATkkoeLThJlyKTKqyNNhPe/27S6YgeNhjMnEy89Wx/tMSyN5ygZZBXI7ruc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dOUBUekb; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-736dd9c4b40so2459249b3a.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537323; x=1746142123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWZd7ZFPXeg1oTJFx/lxzeskCkUEMUuswiCEr0poukA=;
        b=dOUBUekbgLTeZSJ6A+YbtCiepN/e+ZI7Cwz+Z6h4T5x8hpMfdBgHR0XGalBlht8k1b
         nhiV28Mk/JLF+l/UK2htV6qPqnlnm1IU9RWRKSG2S6xH2JZBiJxj+jdoHTrxfE1PBOsf
         ik3sgybShUmBLvAGxp75Vh0cUW+dKHPzkhqMEMfyQQec5pxNxdEy3Xh5VPcorlhlf+X6
         3yPxrnckqvzTtF3dUQKxrLpbvkXJPC8OtIM3/IUGxUX0b44cIEtTmsKbXmiJcORzch1N
         3U8YfsO6dgApByUIKC3NGCxTrdMZID9Hjn1jcBPG+6BBzrTF9VDm62Ufl3ZzuKi8TsFN
         lcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537323; x=1746142123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DWZd7ZFPXeg1oTJFx/lxzeskCkUEMUuswiCEr0poukA=;
        b=lW5umpk44eQjnxn3hXC4BohppBXNIQxhkEp8zHdF6fZDQfrSMd86qazBny9EhWpz+M
         g3FoPK8EtsTqpKJ6Dzp6JSCcrtfnESpgfSDnfwuVZH6c5SPaIirK+qCdyILX7XWCVJeb
         UblcoxDwdOdJWRO1/3rf/0ML9J53wx3ZGS13fq18Pnh/zbPqhQkdS16SOQ4qR3g+48M0
         psZeHCuMYuZzenHcOjouV15P/aSdfU6+WRAm/MSOX8a1WcvXOVgm5ZrV4vw2Idn+Wqi/
         tZi2RrKB14QOs5ncW74f7lfdPFgbpHSuPesPFQcdq7dNNcKrMzEaUJ0JqbdixL5rejVE
         JksA==
X-Forwarded-Encrypted: i=1; AJvYcCXn0AHV2tvgwYZGredx2VjMmXUJM+HQctlH9BcnFkran3VNHvW+X9S6xYHgBd2jzk8i7uI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/dFGNyETtDCAkhDId5A93rdwlSILcG/Il6ITwa72YiMdU4SWS
	gaGDJXbW6VKc7MNDxNSvZYAoSS3HZSJqfp9kmLZBd3kGM8wHSLZTqKzgGDGTCp0=
X-Gm-Gg: ASbGncvmYIN4tuIVP9YDc6pITGCY3o2WQpFQVeDq7l/reiBMt9IQbeDQ7kq364mAVA1
	zsu3H9S5DGOaWXCYYQ4fMh1l/QVA56H8UFF5nmcr1cpTFqUoiARoLDO1bbkhwpdk4O8y15nWTY+
	Ic1T/24mx44XgrZG4wtNriV47fLSPM9uIS3fOdjl6pqr+KBYhYmXLO5c+n4E7hNZxbFnZkSPxDn
	1NwnDRoOSPd8MxhOJ9ZLtMgPezZft4Dd3qf2KkKG6hym6d+yTzEnwWz4kX1+AJkng342DgW34i+
	FmLr/StyPZv/IsP5Q+/9xzaIOL4TFxyRBSK2K3i6
X-Google-Smtp-Source: AGHT+IHUeAU9jg7fjJObe8hCoNYEdqjCS8GEtZp7KBDMKRkvfiCPytcC+P5/ygxZ7lW0ZTirnPOC8A==
X-Received: by 2002:a05:6a00:2306:b0:736:4e14:8ec5 with SMTP id d2e1a72fcca58-73fd7cba6d9mr127621b3a.11.1745537322839;
        Thu, 24 Apr 2025 16:28:42 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25accfbesm2044318b3a.177.2025.04.24.16.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:28:42 -0700 (PDT)
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
Subject: [PATCH v5 5/8] hw/hyperv/balloon: common balloon compilation units
Date: Thu, 24 Apr 2025 16:28:26 -0700
Message-Id: <20250424232829.141163-6-pierrick.bouvier@linaro.org>
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


