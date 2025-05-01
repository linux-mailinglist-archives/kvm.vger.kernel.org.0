Return-Path: <kvm+bounces-45062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E612AA5AEE
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E0C616AED0
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007FC26FDA1;
	Thu,  1 May 2025 06:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uPzS6jHx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6DC27E7C3
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080663; cv=none; b=QFUkzPpGHeFO6GusqtlYZkwXuOEZ8L8SLVF8bRZVnyz93ajGTgPnv1BLSsxSKzA5ZM8r495PrgaNkrOXr6WJ8mXLPDe03fKjC2up55DcsT/uIraajXgCH1LbbFYcRhrtzoX7wLI6RfI00UCBHbxYZuTzkOMyRN0q0ZwiyadMinc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080663; c=relaxed/simple;
	bh=3YQ7dLFAB1979xjcLHSB2qfhbh04ZFQmKX819koZ1jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dD0hT+oiFu3t9pafDL4kXEpd0Q3ejqExWAbsxZRSNXZ/sHBaJQYtgyT6hZHYRL+lPdy5STcnd16TAl7K6Mfs2QyQpNTcflCm5qlP1rrF5QuTfu6MXbEBJLF6BMhGUwjXUkq0DMbBdqif6cAzK2r1qkKf0GtxW39JtjJUIUGHT3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uPzS6jHx; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-739be717eddso551118b3a.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080659; x=1746685459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smxeq8t77rmr1khTGCWgeqn2IHOGcCtHx62ulud5haY=;
        b=uPzS6jHxqRe5FeB/m2p5QEe1FyouiWBkqsEDuEhcjXzyDiPn9odMOKVWbyQCwurGag
         3JP54+OAl9qGfCossEzTnGHwRehTNn+zpN3Wloqn7fXhPd4sWZr3o4T4zMwqfaOu12Za
         R3CaRI3EsHjpST4BH8x2yFvou1ENz88UbogTJboQskdLq+AETOOsFui0Ct4UJY9W4wxd
         AlOKLQPxPS+ig/V/islyrpYZjWC+aVoyUHMf5o6wnJNKYleIzflcyCLkzZ8eduCWHSEC
         KMOcS9TvWSxXs0vAR4ZEi7gVS9TsWaRwVJvuKiKiph/lFgZX0pd/9wMxgBHpYggjtCWA
         oxcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080659; x=1746685459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=smxeq8t77rmr1khTGCWgeqn2IHOGcCtHx62ulud5haY=;
        b=OIr/dECTl7ksea13yXK71uE0qaaXliYAS4D2rxZUAI/vwXLGlqYgj+lBAx0YftcX+P
         VUpaaM62C1Oin+rPWBpQeZ4cIwFtAe6FkuQHw3AkUC6N8/Sq6xhHtse8Sk6Qsgm2gb8Z
         8RfUIfSUOtT7E+lf2iszYb8+zlNK8tqKWrAKn1zkpRLDP0m+ydfTeaX376N5HFgX2/Jq
         LvPgesoHGSeeN5rrXyoq2y30TIdASWRRZh6uRtfRXS8PyGR6G3UeUajrzRMDNuo+/EZy
         EbeQMpbGMVdQFoyyrFqH9gOnxntYc17JJQtiQ6r8EVMf5BGDST2kvoO5goT6Uiocoq5Q
         EKJg==
X-Forwarded-Encrypted: i=1; AJvYcCWdFJ/ZDXfHpmy0pC9QtLRS2fg+eNGCT8t2YEBoD6b/tKAQiRYLSRvKF/48+TeY8Yl3iBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcxEE7LvfDhVWNJ+DJ11Gsl7BlbSu3tQq6g0l9Q9V2eeKNHAXS
	eyA3mYaQI136YjJ/KjKTswA+pN/RYkbHuvm8dF0VXy4B1qQsCPY7tnA8fJCIrbM=
X-Gm-Gg: ASbGncvnsKNJKv3+04Zhp+Q6PeQ1TfhQwm53DYw08EwkTOhVFmbDnKuZqKoBCX40KXf
	K30W016J3TJhZZJcckADoXC3tMvUtM6QL9ckNUBkusR+JOl/aljBsSIbTWRuJKwowkfq+SsA1hv
	jeqxweS0/8Fv9+HcEzCCF3arTzf+FstvX1W0M8PF/q6ypRLzUlwXbAlPCZC97pgW/X18UitYKld
	6DQ121FAAL2rBelyxeZp9f5A47j+acjcQvkbrAfnZJxOBxeafo3Aikydyv1Hx5QDg5O8sIDQu3T
	h3ka8Zhc9umi2VK83l2xmrw8XFLtCrqf4rcfk0Ct
X-Google-Smtp-Source: AGHT+IHG4UGGkkz608m5AZZyK3bj7kb6xgjT5nZou0FUnCfiy2hpqLLhUwXRyD5HV3onb5k4znr43Q==
X-Received: by 2002:a05:6a00:1942:b0:73e:2d7a:8fc0 with SMTP id d2e1a72fcca58-74038959453mr7648202b3a.1.1746080659119;
        Wed, 30 Apr 2025 23:24:19 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:18 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 31/33] target/arm/ptw: compile file once (system)
Date: Wed, 30 Apr 2025 23:23:42 -0700
Message-ID: <20250501062344.2526061-32-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 6e0327b6f5b..151184da71c 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -17,7 +17,6 @@ arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
   'machine.c',
-  'ptw.c',
 ))
 
 arm_user_ss = ss.source_set()
@@ -40,6 +39,7 @@ arm_common_system_ss.add(files(
   'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
+  'ptw.c',
   'vfp_fpscr.c',
 ))
 
-- 
2.47.2


