Return-Path: <kvm+bounces-45295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 829C2AA83EB
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A385189A7BB
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8332017A306;
	Sun,  4 May 2025 05:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sXS8NvRO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176A01581EE
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336564; cv=none; b=c5oY3TrDHE0Bhh9ypaDjfOPNoKLAu3aTV/XGqXKgVhpSuFyP3UYSaKG9/y9tdvSpqtVQMFcs1eeoOtPEN2/oD78mw0+OL64xqgStk9DR/736CS5/MTs4omAiCJKrNKA9mL1BPAFBUSyWHqKDiJgzPJopGpFbUyDysYYhZ1QoR/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336564; c=relaxed/simple;
	bh=vpF3aqJ8G1Nzy1z4/D/QO4/GNb59/siAKHys0N7ei/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SnfS6cGHPjtFo5GID8GiNfDlodDHI0/o6G77+A9tt+Ftu4RrXFTa2Y9E8D+AJfUYgJT92TSUWaoZnEG02vldU8TI1qKdvgbOhMhxXAHT2Vrz1b/Y2dsKd0FFibkO24htMrC2rDL6zUtmmCXO1oJL5rnxyl/fxKDYa9MDnGZ5tms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sXS8NvRO; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-736c1cf75e4so3044274b3a.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336562; x=1746941362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=sXS8NvROmuk1shptgzFDWTc2HsNFPt4a/jhb8mXbGO9gwUwJiHi8mpuMbscxOX5iC8
         l7ybd9zQYTM9HdsWQ2Us2E/8v0NOy+0rs7PIbmB7b3F9ponC4VJtkbqOBhu9uV5v06UT
         xK0B16YL2LbZ8MFBuit8VSQiZP4tXY4Xu0zupHVBkEHRGZhipEzRoayipshdsbCmZr6h
         QI1HvlM5hJaZgcaJ44arAzzv3v1SqWiqJxFOCZfo+TmodX1Mhp1T1PeGsRL6GBlOQtvT
         Wj3RNKoQZJDNuKnJs5QXRl3QB24TeE6QVVx4K6+CUGKAxYFIqvsYxlkqEuwJXKSi8l5S
         jBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336562; x=1746941362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=lH89HTZ+vhygJwEUV2IRmCVED7dqKst0X86taWT8wZZaMj9xkEAhpTufUlG72XJObL
         OOwonw4Yd463IFFz5PSAGZ4e/Gn8iTkaNRsOV4U48SkoEjvqgCY3tUZxBJfkXvvynFmd
         tH6J4sC5t29Aoz5mom57QgEtG8shmGQD2bMeI6L8Kd2pkPK9wUu/Mq5METnS4yLWFavl
         1ezK3+Hoepf2qqCPnoZUYyfRnaMNdFb30dQRUhXNUevhHIFxqgkuEliYPwBJ3Sc4PT3r
         /oW/xSz2R+mvHuiGygZwQOODjLThKbbfZ5q9gqqicB6icyDa9UDTOfenNisEyGPuvooj
         3ycw==
X-Forwarded-Encrypted: i=1; AJvYcCUgRVkUKaDKALFBVim2VCKLjg9JVAfM+P1C0+Tm37/E1+hpBLlHfYX1MKY63FJd/qNOtpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvegYyULuiGUEcb5/tfZEvHQRpMysBoscVh7fREuVeoT3bOn+G
	pBleFtlZQlUQsawzsV3pPhcVH5Z2XK6FbRMhJGAVfeLEA0uj0fQ+zPTwqdC9G0o=
X-Gm-Gg: ASbGncvlKB30XEsEUli48eFUYNA1hR9yo+uwu+HOrCHhKAbyoDGokA1vow+UsBBd3Sp
	eSAzPLSAq4U4EElihN154c0stKE3WHzxA8f+vEtC7Q4HMfR8HXGQx2V+jwVLzTfzq21QyJ3kjIo
	QpsvCnlA4stxK1VNXeqnlElbHUvohdoLY08qewpFqJ+hYpDqUO7uPI7+blBpD55hvMd2PJ0e+da
	BRKtgzACTkrsgytjwLD1w38IIm8XpN0xqDhAXyUFaZfZB7lkaZAaujVnnay9olBTjJ/48NGs9Ls
	91wxyuKuYPC7TNcYyEN43jQSdUjNa1iugamG8kvq
X-Google-Smtp-Source: AGHT+IGVK6o8RnQD2bGJOKl+UHtGTQnnp3KoDBZBcEbovmyUrpyvzVjbZzuPCUjgGT+PmS29OCZQbg==
X-Received: by 2002:a05:6a20:d524:b0:1f5:8605:9530 with SMTP id adf61e73a8af0-20e97ac0020mr4372318637.28.1746336562311;
        Sat, 03 May 2025 22:29:22 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:21 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 02/40] include/system/hvf: missing vaddr include
Date: Sat,  3 May 2025 22:28:36 -0700
Message-ID: <20250504052914.3525365-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
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


