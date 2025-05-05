Return-Path: <kvm+bounces-45530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E10AAB5A7
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A991F7BADC5
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8120C34A1BE;
	Tue,  6 May 2025 00:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y8ncsjCD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C7528B3F2
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487226; cv=none; b=Y4BSU+8DX5u1phl/2txoIBRwg9jhZWY77JJ/A/mSBauIpJSwYZzE5gOt7pwdeZmY81Np/VOq/PWCaPZ156bPxb0BkwQ3Xf8Xi8LAyQN/hR0VqP5PeXysdO+FdubTHiIdfIgbMX3i+zQe4onRnE5XjymLqADtV6JlBOojTfAqqvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487226; c=relaxed/simple;
	bh=vpF3aqJ8G1Nzy1z4/D/QO4/GNb59/siAKHys0N7ei/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpUvc3LzIJvIdRFrMKO3yH4zeO5yhuiRKux4ZPdh5WoIunZTmwi9VkrEszLm1hVdLy4ZZeO9x1o0/YGrBDlA5GqJXHt8VW9T807B8SWa/ziRbWPYx/V2QMrJEm6OcFinyhxtLSytAk2mSpHBkdVwMFqPAsFsVRVL/pKubVtgrEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y8ncsjCD; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22c33e5013aso53522765ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487222; x=1747092022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=Y8ncsjCD6xXDpEPhewtI3DBmMn9ACp33WO0ackJjhvFPxJJqHaKjEFWNOj+dxOB8GR
         1PUKuyOQeBAUq7MyTQjbRhkNnhvqF9ouDk53UnoKQTz1pkL8XNH4IMio5dRSCmaGDEE4
         85qMNgNZ8YfRs4UKL4GWssNX/VZCUTyZQmvQ4KNfDoMG/7vxWrikKwIf84PvM671mFRX
         jPyJPBgsYL6LS55asevK7rct6x0nO8Hy6VKEbOFNVUgAl90U8b8H8MomZuYg56+WcSPE
         MnI0oe2rjewQ6UZu2MgICjrR6vXJwLW3wWJN/ki/1hIq5Ob8xROYpOkE6SnlETzp5TF0
         2jIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487222; x=1747092022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=pBQwUP4KuCfsH3/8UpLYP0EiVe7c+5D4GrwrFigF79ps55N8sNp82ZrReimt4a2huk
         a4w5NXOd/OHB03vg0lYGY7SfyXkaOBkHY87pimn7P1B4YKtdpcvPorrQpmmkjH+wj6dm
         Yha7ZmwFHtl+3gVOYgGt/nKY8ExZBwG588bXVeOYCKAz81q8UxObkgdPuAKljewcaxE2
         PE8XuWpePU1S9oO55k76Kvu7Zilt3XAQBxlzimFanSjTpSvRqH4GPpARSMCp2Nrxj+1q
         gjGgcQmWx6gN1oeCA2GIGQUX+letwwf/qdHfNIyYOHA0C895VulEtXpoxwrJHupKC6ZT
         uGrw==
X-Forwarded-Encrypted: i=1; AJvYcCUShsygT+FbCgxjbbdWN2w7c8bruzPMZ0KZDpHaDVx+vqbVWtrl7N57CF4urjnxRN+Ep4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbuchZo7Jc1TaWrhqNFdkckFzu3WtPsnjgkmzltVoTSCPkR8Tp
	jMoUVqqqXMAD5BSvzdbu9dQZX+y+1Z9LBh9h3MXSqhXuLI80tSLPXCPhz663rEc=
X-Gm-Gg: ASbGncsEF4EeSO9zLTjg0ApREdephSwae0z6TLI0o6SluPZklgpvwcA1HepvkU15nwu
	siD7GJdoA2BjpvXhKpmOEKCF9/4YVHXZxvc9kwPrhvtl1Rv2zCgLmmHfdsB28rjhQIgCd9VdorW
	aZlEHhXDUc8e910P2+b/RWPgJjja1v4pKLiyE63lqHTaGmnUvcOrmvLjaVb86kLlLfn16vp2WXH
	viCqGJU9EGwVCF9jZ9//9AMXjyU6OFuRJKmqksYRIopiR6VmZ2qh4N7dI93pyhX0DaOHK1tzlYe
	Rf1Vy40XzYDI/7fNgxLYvOL1ej46YwgioPbCzUdN
X-Google-Smtp-Source: AGHT+IEkGA7F23dh8r0tL3IOEwmD1EC+JY8O4ZS7CbJfLPw/hDppOvggFCwGVG9SRLWdvxy/22v8Xg==
X-Received: by 2002:a17:902:ce12:b0:224:2717:7992 with SMTP id d9443c01a7336-22e1eae4d3emr132746025ad.33.1746487222470;
        Mon, 05 May 2025 16:20:22 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:22 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 02/50] include/system/hvf: missing vaddr include
Date: Mon,  5 May 2025 16:19:27 -0700
Message-ID: <20250505232015.130990-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On MacOS x86_64:
In file included from ../target/i386/hvf/x86_task.c:13:
/Users/runner/work/qemu/qemu/include/system/hvf.h:42:5: error: unknown type name 'vaddr'
    vaddr pc;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:43:5: error: unknown type name 'vaddr'
    vaddr saved_insn;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:5: error: type name requires a specifier or qualifier
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
    ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:18: error: a parameter list without types is only allowed in a function definition
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
                 ^
/Users/runner/work/qemu/qemu/include/system/hvf.h:45:36: error: expected ';' at end of declaration list
    QTAILQ_ENTRY(hvf_sw_breakpoint) entry;

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/system/hvf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/system/hvf.h b/include/system/hvf.h
index 730f927f034..356fced63e3 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -15,6 +15,7 @@
 
 #include "qemu/accel.h"
 #include "qom/object.h"
+#include "exec/vaddr.h"
 
 #ifdef COMPILING_PER_TARGET
 #include "cpu.h"
-- 
2.47.2


