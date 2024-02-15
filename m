Return-Path: <kvm+bounces-8769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9568E8565D2
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 15:21:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7105AB26B7C
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 14:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19ECF131E3B;
	Thu, 15 Feb 2024 14:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uCrB+Ouy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812A8131E30
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 14:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708006853; cv=none; b=nuyXT2pQrDZa8IntmJr33s+1Z3DalLgo00+ZudTZaoRiBZ/qGe65wUxzEGdAOjCcrUTI1RUnjv1qUfP/ixpatfeWFRZlN2scUwApsncaHQ1k0FFiJrncdOT6I/e1MgynLmGpfd+1HSu16c6g+DhhZuxCePho5e0LH09OFjW6uvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708006853; c=relaxed/simple;
	bh=WyB1JhRirQvALYuIAg0sQ/WdGGgWts4aWXr39mwQhDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EP7KYRc3Wk3kJIYAaUl/19jAnDfHDuHtOEYxxxG50v+VdmiKvb3mxocn8V7dqgE4/+OTMboZgWjgvnd+t3KZ9uRFJYRPwEhHKMm1hEjupWGkrqgrkYm/BwZK2J/lpvryWfG90alJRmX4IbQjbfpdXKj5FTa8Z397TryMCqnxpi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uCrB+Ouy; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2d0a4e8444dso9701801fa.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 06:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708006849; x=1708611649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLvepa7gcmUSWKB1EKhqFyqI1EusKlbmBcij87F8F7E=;
        b=uCrB+OuyHUYzuOp8oJcVpncTV9DytoCUeMzUfJG99r6vFtLPTBWqaTbYBYzvy76lrY
         RLltpuSgp3gac2ncfEvuM8pWpe9WnekNIZvYkOBUfyNBFcftgnigW4x1eHTSgStE4E63
         1Pv0oFZ4qpvpgxiFDmtcqiszZ0jqb49uuctDnhpLftz0Hm9hxj41W7IKGE5GAaQ/DZ4R
         z4YLv8G+7/rA8SDS5NaNBiLAIFK2dnXrAr3PwVMQNTsiCrBeN9+N8RcYDDx9rCisGrz4
         6Ez6i/EtVILEyITpeQukeFdyNWy5BjtOupgaRqaOtOWLomAtTuC8t3L3vyeETcJEMzF1
         sEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708006849; x=1708611649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLvepa7gcmUSWKB1EKhqFyqI1EusKlbmBcij87F8F7E=;
        b=PnetNear3ZIFG6yIzWJi6WSEuGt2EdnL1u6RshAYTZ0Ezo4NQc6kinhcKqIeVEb/ZN
         J3j29b/0pmrdRy5ZdoCeyznJWlB1qCdCwe/KBYGddOC6CsH+hzRcz90aI6si7OX5mf9Q
         +40MYWdg4cjE7YxOR3l5BPq3asznTpMEamkB394ZV1JFaix5M4+SUQWk3tj79LhBNr4E
         cJxBFLz7BWPoYK2BiWr6nxj4IGVSl7AMBG8mE8YnZ15bBG+jC6qYsTjC0OO79vSmNOXe
         WhR939DD+kY4xW3b89aIxtxXBEcW63uIB+HC21k3PPQFDlE3vd6usAYo1MXG7FwF96YS
         uDug==
X-Forwarded-Encrypted: i=1; AJvYcCWERBvfvzKFSoID///Hhh3pLzpSQqY/AVia3BIAlXVx39i9mvCrSQMJbHcBGdcWuj0oLEitjuICYoAl1RcJESaHpse+
X-Gm-Message-State: AOJu0YxrBpLwfFEHVDrbxF5gKep9TADCYodxFVQfh0nIm7ke1m6NbqFY
	K95bhpjXwTP192Chrjoe4/6due1nUGjdEWgxZFqPbOsg4MirzKx9hz6k9/HrhXtjQ2wNZIZNFeJ
	zBCU=
X-Google-Smtp-Source: AGHT+IHYEUm7AulymZdpVTj48jkAUwAJORdqCYy7sFA89JTpfclzWJG6O7qdsxMhmWM6peItH9Yd8A==
X-Received: by 2002:a2e:a548:0:b0:2d0:c996:7c99 with SMTP id e8-20020a2ea548000000b002d0c9967c99mr1604340ljn.51.1708006849401;
        Thu, 15 Feb 2024 06:20:49 -0800 (PST)
Received: from m1x-phil.lan ([176.187.193.50])
        by smtp.gmail.com with ESMTPSA id m40-20020a05600c3b2800b00411c9c0ede4sm2228137wms.7.2024.02.15.06.20.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Feb 2024 06:20:48 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 2/3] hw/i386: Move SGX files within the kvm/ directory
Date: Thu, 15 Feb 2024 15:20:34 +0100
Message-ID: <20240215142035.73331-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240215142035.73331-1-philmd@linaro.org>
References: <20240215142035.73331-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Per hw/i386/Kconfig:

  config SGX
      bool
      depends on KVM

So move SGX related files under kvm/ for clarity.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/{ => kvm}/sgx-epc.c  | 0
 hw/i386/{ => kvm}/sgx-stub.c | 0
 hw/i386/{ => kvm}/sgx.c      | 0
 hw/i386/kvm/meson.build      | 3 +++
 hw/i386/meson.build          | 2 --
 5 files changed, 3 insertions(+), 2 deletions(-)
 rename hw/i386/{ => kvm}/sgx-epc.c (100%)
 rename hw/i386/{ => kvm}/sgx-stub.c (100%)
 rename hw/i386/{ => kvm}/sgx.c (100%)

diff --git a/hw/i386/sgx-epc.c b/hw/i386/kvm/sgx-epc.c
similarity index 100%
rename from hw/i386/sgx-epc.c
rename to hw/i386/kvm/sgx-epc.c
diff --git a/hw/i386/sgx-stub.c b/hw/i386/kvm/sgx-stub.c
similarity index 100%
rename from hw/i386/sgx-stub.c
rename to hw/i386/kvm/sgx-stub.c
diff --git a/hw/i386/sgx.c b/hw/i386/kvm/sgx.c
similarity index 100%
rename from hw/i386/sgx.c
rename to hw/i386/kvm/sgx.c
diff --git a/hw/i386/kvm/meson.build b/hw/i386/kvm/meson.build
index a4a2e23c06..c9c7adea77 100644
--- a/hw/i386/kvm/meson.build
+++ b/hw/i386/kvm/meson.build
@@ -13,6 +13,9 @@ i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files(
   'xenstore_impl.c',
   ))
 
+i386_ss.add(when: 'CONFIG_SGX', if_true: files('sgx-epc.c','sgx.c'),
+                                if_false: files('sgx-stub.c'))
+
 i386_ss.add_all(when: 'CONFIG_KVM', if_true: i386_kvm_ss)
 
 xen_stubs_ss = ss.source_set()
diff --git a/hw/i386/meson.build b/hw/i386/meson.build
index b9c1ca39cb..d7318b83e4 100644
--- a/hw/i386/meson.build
+++ b/hw/i386/meson.build
@@ -17,8 +17,6 @@ i386_ss.add(when: 'CONFIG_Q35', if_true: files('pc_q35.c'))
 i386_ss.add(when: 'CONFIG_VMMOUSE', if_true: files('vmmouse.c'))
 i386_ss.add(when: 'CONFIG_VMPORT', if_true: files('vmport.c'))
 i386_ss.add(when: 'CONFIG_VTD', if_true: files('intel_iommu.c'))
-i386_ss.add(when: 'CONFIG_SGX', if_true: files('sgx-epc.c','sgx.c'),
-                                if_false: files('sgx-stub.c'))
 
 i386_ss.add(when: 'CONFIG_ACPI', if_true: files('acpi-common.c'))
 i386_ss.add(when: 'CONFIG_PC', if_true: files(
-- 
2.41.0


