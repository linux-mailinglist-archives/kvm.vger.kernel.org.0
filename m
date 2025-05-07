Return-Path: <kvm+bounces-45799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7876AAEF82
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10BD21BC4404
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD8E2949E7;
	Wed,  7 May 2025 23:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="muLH1IMl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475C4293B44
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661393; cv=none; b=NhBOBQP27Uo5QuYo8SZ2PuT1BSIGNbWLZDBG5lDkZhZgyAnP2iK04ueR4MuahmSJDP3UFjtsr6lBTmum+pEd5PN2fCt6s0zEbx0ilZC2qzkL1pRw2wZs2nMrE0RsOY9WsJ3WPk0O2EtEy7D9UUbp1YRk5HB2FSDjiFiNL4MboE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661393; c=relaxed/simple;
	bh=3RsKZ1Pgza19E1HBaBnLbv5wQ1rc1mFEhHbZHJJ5Hmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYPh1r6DkRlm3SDmvekmV2mGavIe2sZfp2Nnn6lpy9QhmgFsQ4AZ5o54b2Coc43Y/46J+wqlj5uZveR35DbL9suNK0jo+6dS3FwtavTfZwwVCIRSne3nOHuFq7PIe9wXpiDOWtcy/i9LW5u9o/hdb4IXMiabqqkyPdQlFG6Vat4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=muLH1IMl; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22fa414c478so469065ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661391; x=1747266191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=muLH1IMlhMRTQ12uiBYoFmmrlq1AoKPeoQJTf66GO4mYE2RHWEGAXLk/hfwSVrK7ge
         F5/if+KxGjUUMusM4D2iI7N0p0xbLAgOmpGgyUJXyfWTr0wWT/xr1IJAUZeakfSndYqJ
         zuGDNtrwPQvZuhGOBsf5Ot7jzqsIzjspNKR2ndzUuYllp7SEj9SwMbYQX6S6d2ifFXEk
         dDJNaBRkQ4pWCpkRkgxOEQ1W7th0N+xwoiaAYoAnE0sxBo5kzveYLR/O5EiRBO+CLVfa
         FbGZxkIzRZQ6nP2k6vaAEy20gxrPzSAPsq/waCOOvmltfFmndq3AsOaTvjjlB+sFjlDs
         XC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661391; x=1747266191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzXXutq4wGalZELe39I44dxOL/4dV/vBf09UEOe1qt8=;
        b=lJR1CtaAmEqI9CqcNPF8oNLEV7rNuzgoZFLlgcxc2nAvYrYlevr2kiPyW+itHET1ZD
         AQvJrJ1eyozqtjH17IhNuPjzOJ2gvkz31J2aU3tzmK1GWjFn7Rd5sg4r1yqywd8k25mD
         waNkQubBPARpq5u3ppCSdS2900R2VQKNw1iph+mOooRQYCqT/WFioqs7ftrmEzgfXmhI
         uCKT1mE5qjhJuRmEfB+quDMBkz3nyZcD1ZPiTMWpAJ2WjL5bd7P++b7OqZNEQgdT5HH0
         FjzbEApvd8wxn+YLzGu3aewZHecJba3A9pbbWHwE2cVF3a5QYoS0nokjKNPE//sDVT0p
         HcDA==
X-Forwarded-Encrypted: i=1; AJvYcCVjTOP1yQXPe5EjKP5mJP81crVI17+Nv4G67FzLF5DR+w98FVXVT4GuAI2k3l7R2sAFIWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsUsnV8eOyHirRAQXLpkl1uSa31rNPK87cA5vPmHLYWBKeZKoU
	77XghHRTodLFkPerPtehmfOKJpcmmHyAYkG4xfF5aZWIGKXNNiO3M5oZGnfFgtE=
X-Gm-Gg: ASbGncvcbvarqxqr8zwsQ9uqC13dOoA4XzSgg4Xq3gvTsKEo1DeM9EFFvZmwjUflvWr
	qPXwr32dYumrTTa3Xq4TGRm9l9y9K1vH0LZQVw/q7HV6ZUx6bmKadgWvEwT9/r3yaabDv4aifzw
	sln4le4gn3NV+0E/ogp3f7TcCeEez7g/VgFelwJuNpQJYk+nSBgYRFmYakwWeoitvpuPJQYdjqq
	ZhU9YpYlrPzm+Rs+hQXeNIlVxfP4SAA8cwzUyMwT0jkiGuaf0UluMsnjtPgMMlf5GioF19SvA5Q
	YfVO9zp7NCL2rYmuHvIBXOnJAxKowDU0djv4eE+a
X-Google-Smtp-Source: AGHT+IHHfhaE4ghnmTMiN28gxoqvv77AomE+VUqZxmC/QGbe+j45MBaR0QwIVVJeXMQ0iZnyM3zNjA==
X-Received: by 2002:a17:903:166e:b0:224:c47:cbd with SMTP id d9443c01a7336-22e5e98947fmr80627715ad.0.1746661391705;
        Wed, 07 May 2025 16:43:11 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:11 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 33/49] target/arm/meson: accelerator files are not needed in user mode
Date: Wed,  7 May 2025 16:42:24 -0700
Message-ID: <20250507234241.957746-34-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 151184da71c..29a36fb3c5e 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -5,9 +5,6 @@ arm_ss.add(files(
 ))
 arm_ss.add(zlib)
 
-arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
-arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
-
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'cpu64.c',
   'gdbstub64.c'))
@@ -18,6 +15,8 @@ arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
 ))
+arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
+arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
-- 
2.47.2


