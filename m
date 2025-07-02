Return-Path: <kvm+bounces-51328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 664A3AF61E8
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 396A23B85AE
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715B62BE620;
	Wed,  2 Jul 2025 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zk1263YF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33DE2F7D0E
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482490; cv=none; b=AfN1P6HPI7DYGGAFHOXVAZfiG0gukdL2cJFtG69KJSJNTqbxMyGacLyUHBGtuiRORuLZmoUyVQTfrYy4nT2ImA7vgT9td/XbtIAl+tpO3nAAXu6pTEMEMAySpTBAYw61vV9xYKYePPEk4bKx34YsQa93Y+0ePE5sgH82yf6ja/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482490; c=relaxed/simple;
	bh=oBM9B9UkFXMOXzsE0OgqYMIcYmx7Cri6OEx5/ZpgJGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CuuOy93u/HYIMaB2qj4h/fFmr6SDh8EQ1YosG3LL2VODoUymQas5GsFrrnpqVZh5xCm036FrTDq4H5TPpuatZZdnE+Ht19KgoPqENNO5mqPLV9MsBw0lliEGAuaAY9zacN6DNk8/F1O5imumyjCcefWEjGOAYRvZAFw7u9WSfQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Zk1263YF; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a510432236so3582967f8f.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482487; x=1752087287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7agq2/z/dMVKZ8AYrQE6GIlp8fdEIwRrjWbdb+ua6k=;
        b=Zk1263YFgeyT8dIBu/jMFxfUwE8zO4qpBzogAl0OtThWPWpgMKzjTvwkhwJLTZejt1
         iJ3uzPL/z8Fsr0/M7otnDjUwHHOdyIOOzHaNNghRAykV9TbnQvgi/CplGwNomeYFHzYG
         u44cBoaU0359fUfkA3GUNh0Wp5IrhzIVyr1oyXPVJdy4miuf32GfnTTpw+JvjfNYAN/q
         jBqjpFAOt5c6o6Q1YQVKbr0E42iA4cCYh13RmHlbLvnBJpoLLKma6UK8iuTOScoEDtW4
         r4H8C32eq7i+abOPtqw9e1h2PrS0JdSdzitoQCcFbiYI8BvDqlUocPMUdAiwa74m8pIm
         owJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482487; x=1752087287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K7agq2/z/dMVKZ8AYrQE6GIlp8fdEIwRrjWbdb+ua6k=;
        b=q/9RTh+3O9KYGCmbkAetJmNLAABURIsER/2pLYKOtx3v2r2rR03cKG1RXnbosU3Als
         ddr8P0N4D45bqCngQgH5SFe1OhnXhSjjHecm+isiKpHFfCcFFpLbNbO+sXsFtH8xgX12
         oCnqxdfKeBiBK/7sk6izx4kCu6W7ZEeNByUpxGjgTvGjzwyDp3dKc70tYSQpmBcGU2UW
         0MZX045rufd4zuVBAnrSIGzvoIi49+m8xsu4kPqh8aKmjNvf0yN7wfyS6K92UwUbPGYi
         X+Ssbrwtl8Og0IMHVifli+4TwNq+kR68BxVtDUQDnx5ECHqPQfCrliA0SraPvHjlW932
         uk/w==
X-Forwarded-Encrypted: i=1; AJvYcCVvP/WU8RECnD8NLdORBKYwWCxpZ0dUJwF3SUKJ4uT1laNtqEJAdPs1fa8ATKesezaQDkU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzExfJp8okYV7AHrFDMY2pPlm3gXPHbxc3Kckwz9laxIIkFcE+U
	ywPU35A3rhcimdwvEEi/BvbFxSebRpUBK9mLckydasiHXhYUExa2kCUHfLcU+OXgO5A=
X-Gm-Gg: ASbGnctQIFBzFOeYB8YwFeEU8OBASu6981uC+RyL0EB52kTtBwPBFTZ18pjH7cPBJDi
	dzgTu206BaakBfEtfOOmdkYQi4kHTFSlTqTSJWJmOYm/Qjrzq7vNFiDeafjv+Ll9phZrdJQYKrD
	O62I1L1ETuWtkVNOQE64+Nypj7JQzKkucbqF0YTBzPdY1dEfcCAZHsWbnR8tU9fqNsSDo/6Db0z
	44Q8X0WsyzsibXSPonVUq60WFvb4iPCd3MUpGafUhfQhOK/61/xQFFI9QknMaFWCNUZyZLFj4f2
	g3LTZf4WNIQcGgK5Blmyz3qSi/ARE7LjZiaV2286PznTkBh4niRfuvXgK+QJbJIsexFHtEPlpbG
	xbY/Gaklr/Ujyf4um5gRkR8ONWf4jN7XURgmB
X-Google-Smtp-Source: AGHT+IGUQtIt1emteiYwV891bgO7McJF2bqG2ULHbJtk+FF44HE2MvtisHO4HAlpGrc/qLCw3aFVzQ==
X-Received: by 2002:a05:6000:290d:b0:3a5:2848:2445 with SMTP id ffacd0b85a97d-3b1fe6b5ae9mr3546118f8f.16.1751482487269;
        Wed, 02 Jul 2025 11:54:47 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9989423sm5599515e9.19.2025.07.02.11.54.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:54:46 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v4 10/65] accel/kvm: Prefer local AccelState over global MachineState::accel
Date: Wed,  2 Jul 2025 20:52:32 +0200
Message-ID: <20250702185332.43650-11-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250702185332.43650-1-philmd@linaro.org>
References: <20250702185332.43650-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 264f288dc64..72fba12d9fa 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2588,15 +2588,13 @@ static int kvm_init(AccelState *as, MachineState *ms)
         { /* end of list */ }
     }, *nc = num_cpus;
     int soft_vcpus_limit, hard_vcpus_limit;
-    KVMState *s;
+    KVMState *s = KVM_STATE(as);
     const KVMCapabilityInfo *missing_cap;
     int ret;
     int type;
 
     qemu_mutex_init(&kml_slots_lock);
 
-    s = KVM_STATE(ms->accelerator);
-
     /*
      * On systems where the kernel can support different base page
      * sizes, host page size may be different from TARGET_PAGE_SIZE,
-- 
2.49.0


