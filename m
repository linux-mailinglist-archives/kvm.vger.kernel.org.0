Return-Path: <kvm+bounces-22006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C965993806B
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 11:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C3511F20FCD
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 09:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5144680046;
	Sat, 20 Jul 2024 09:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="COMGvs8J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8AC1B86FD
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 09:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721467876; cv=none; b=pfjYoxmz+ZvyunAB9CHBrKd4JtnCrASmfWKqJbxSMObuiRBlKY2KBh9EBF/jEBMvA2f7KRTEBC/+RRyH/tWXd78Cpr+azQMu2XNgJdjOuUbF18pgQ6ZY7pjw50zAwrZuXVV07bJfWPdLF3WiZWBKrspcTTP2037Upltt2pi60AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721467876; c=relaxed/simple;
	bh=ERdlLzGa2odaU7i0HYSX4l+QdtrQUmuPDF9e6WPI8e0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G7/btgoYDNvQ0dqsIMKdaAtFukeUnxNeN4Bk6b340IVJElZSgt4IWo3P6Fe3IFpdyimCAQdpSHtMMRF4L1OPKP6CySpWm2rlVdlv3c7LDLS4bzODQDL5Q+6Wl23HkCgKzeVgGsP6+GlKds/SKALksiNdIAF3PAv/0tbojfBKbdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=COMGvs8J; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2cb5243766dso1518456a91.0
        for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 02:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721467874; x=1722072674; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5yjuBamw9n461E4jaC/9ANa+4rItgiwUD6BgGhyaSGo=;
        b=COMGvs8Jqt5haRmvsjHQYhb/ALqMHedJ9zy9FaOZWAhYwQj3aMuPVvE1nEHiiExa7R
         j6fvzVdQjF490721hcrpnSsCFPCRABzc+aoPz9N+goZ4JJpdA+oO59zoEZPQHAYWkY+Q
         LIHHK6yFUwkOe0tgXlSzuxcOFYd1xjKKuQEzdhJYZUjdytFwHvEUkRkFj8L4ExF92wFg
         qPQPmlgWm/KiFR7n40cNoYGLkvToQjz7huT2W+/MOh2ULU/683EpUe8p5PYwrO2rlm/E
         aLYMml9oVNn6WLbCi+r3R0izMWDSSroh4Q0BtLA3YihNVPv/pagM7vFUB+JjRAeCQvny
         dBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721467874; x=1722072674;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5yjuBamw9n461E4jaC/9ANa+4rItgiwUD6BgGhyaSGo=;
        b=SXi7UoVEIj7pVjjK+4+ZClzDxWFMLHdvWHSACTQjEI8/QssQiVwn+/nc/ujl8Eoa5C
         nkBgpagOWeY+OpG6leYJq8Z7aMjHliy/qyygfd5itwxyz+v2UuZ4bhjLYwIdHvwFjMbE
         eJ3dHuSQcHPTib03hVwh2hDAKgC2gjQso1mO4l5AY+svKXJGWmeuTx6BcYQ91d7lgZWV
         Qfn//gYEDHCWlSW3kuY0jVGBrKpU0mZS1JYESvcCeTM9b/Ue2rhyUArctjhPACsdx2pJ
         nZgv1l7ZoSpcoPO/ao3ZlJF9G2HdRlEkh8DlaEl9HSdvReT3E4XV5d1JmDEIAgJcyyPo
         pJMA==
X-Forwarded-Encrypted: i=1; AJvYcCVJTQIXWOPjprF4hOo4TyLiUh3jGU7ZjIMzTEJBdppr0yj5jt5ALWYsYHcnfMG3R8fLfN5nJsz9Q1pFxCrtPLwkorbT
X-Gm-Message-State: AOJu0YyVsgvK2ILZfb1AUKbirhbopZZtJKwo7pkJm23XGBVcU7x4lHj/
	x/PZA5LALLjQt+punHdiDxnGDRT72rKUe+4rPTAIwa54rENba1eo3L6zfZjPI78=
X-Google-Smtp-Source: AGHT+IHR+NQTRhR3a2TfSAWIUHqlrVOnxn0GDTljibq5mmgHHmG24+/gEcCQ+grdVEK0g9Y/FvpQug==
X-Received: by 2002:a17:90b:518e:b0:2c9:8891:e128 with SMTP id 98e67ed59e1d1-2cd1603776amr2182284a91.4.1721467874472;
        Sat, 20 Jul 2024 02:31:14 -0700 (PDT)
Received: from localhost ([157.82.204.122])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2ccf808f08esm3099636a91.36.2024.07.20.02.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jul 2024 02:31:14 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 20 Jul 2024 18:30:49 +0900
Subject: [PATCH v4 1/6] target/arm/kvm: Set PMU for host only when
 available
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240720-pmu-v4-1-2a2b28f6b08f@daynix.com>
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
In-Reply-To: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

target/arm/kvm.c checked PMU availability but unconditionally set the
PMU feature flag for the host CPU model, which is confusing. Set the
feature flag only when available.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 70f79eda33cd..b20a35052f41 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -280,6 +280,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     if (kvm_arm_pmu_supported()) {
         init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
         pmu_supported = true;
+        features |= 1ULL << ARM_FEATURE_PMU;
     }
 
     if (!kvm_arm_create_scratch_host_vcpu(cpus_to_try, fdarray, &init)) {
@@ -448,7 +449,6 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
     features |= 1ULL << ARM_FEATURE_V8;
     features |= 1ULL << ARM_FEATURE_NEON;
     features |= 1ULL << ARM_FEATURE_AARCH64;
-    features |= 1ULL << ARM_FEATURE_PMU;
     features |= 1ULL << ARM_FEATURE_GENERIC_TIMER;
 
     ahcf->features = features;

-- 
2.45.2


