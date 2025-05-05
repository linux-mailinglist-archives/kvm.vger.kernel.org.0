Return-Path: <kvm+bounces-45349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7111AA8AB0
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D29817266D
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DB219CCEA;
	Mon,  5 May 2025 01:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B971rkMr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DE8188734
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409951; cv=none; b=XvbXfgl4YxG2uv7SMW0JxEhtqwq2MxA3GA6bs/eHV17+aVjZUOxE4fA4ZJP/ZEz92fJWWxcRlTKitXJS7wFqdLy2GbOjleH9DFns6yKoaZB8mjkcLHN1bYAnjTjvijc1LP9gNjF++AlRXP1Lz4NJI4LI3TV2q/mxeC5whPFmDLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409951; c=relaxed/simple;
	bh=vpF3aqJ8G1Nzy1z4/D/QO4/GNb59/siAKHys0N7ei/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gFDpEg664Qe9Bg1Q+vAeLLpTtQuELsgWT4nyunFbe/3akFhlQrgMvHrON+GF1DKZrqNat0+NODTPeccKCRHNY23r8J31AgWq3vuZQT64P0ESSVQh+MrIwNQwiDcBmJgyEke/7o54O2yo1ljMENeqKKnmbWlb6ag0B2Usjly9fSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B971rkMr; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-736a7e126c7so3433153b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409949; x=1747014749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=B971rkMrVcIPEo1z4cbwmo5gnszT8tRhNMVRXkr19uevpgo0I/SiP/pCRgzaghZtLe
         V8ne5Ru3HylVc5EpXzVMZYdPe/wgypeNStAa/zSg/aPPSZ/dOrvh1c2vQMYojAm13jpD
         2xNywg1/s9f9SIPiZzq8akfWlDPvszeXlhHfGpiNHnSKukupWHma76THSgEVRRDWGz+8
         d/SSTrZg4qbowGNCZblI2mgJWbWXMtJUrlWLT7a4JrzRZVd26Vf7PmNq/t4agXq1Lp7/
         p/4Obw+zaxU7NeH2KNmYS7AHVLh/4urmwJNV0NoZCjp80jRZbWUESmZFKJThHZkgB9j4
         kyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409949; x=1747014749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=o0zhEiBH7sOukTcdZPb4DZkgdCRZOgcxqBn5a/chvec9lubltrQ3qKoI1iuOpgeEUt
         tLWxRjnpFL22HILrM1TmrUMPtuA4busRZf3v5D1h783pDy+/LWglxbrfaFH0g5foE0Ou
         h8Mod9pQBwVjAgG9p7XDuZHeaFcoY/en25l2GidD5OC979On8N2uevVQ6KI8JcXBqZ4Z
         4xhPONZfQbmTDBqXkcv066u+9BrHa67skedTgonuqkdDPwUWfg+6mkLrWP8sw0EgaZ51
         8tUaNL27taM5s55Pk/Wtc2y2ol+E7YYVP6i1XE1S/jhoIxFXeZoYPafpv8h35IkNArgK
         ZSdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjh4Snq2rSuehtZWNVmHf9kEYcckjlpN8Q5g9Znf2nOMy85nztfJq+kJasR4WaGsQ3lao=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH9UH302jhItMyJPwKCsoZPcXzoqdoMfYHL3xxtjQkEYvQAefz
	rHDUNzeokE6o+1in2RBIWNLXWrzkhDw4NM+a5KcQx9DshAeQZS9JBlzxBvhH43g=
X-Gm-Gg: ASbGncuo/don2W2YNWxMnC8ts9vWOEsE/2BU8dyxA51NiLO4LblMcpE1c0IyHGxB9PC
	Jv4chBqCtpcgbRWR5mfdDmkm5VAxQ+du4oKfAxJKf4aV8j9sZXCGef9jzvy406+pmZk/JYcVWhY
	RL6knsqR/6MKYsaEC1tb1vEFlVO097qTMccI55DoSN2sUTFUJpr+6fD0LwKAQE4dcoM7f6Fzv9U
	tHBI9OlvDHLYTI4sDg4ieYw8vZbbIxBvZIlFwiV3+9/dLQDKk7Z6R6SijZhAEMEJLpESaAnw0rh
	G9fc3xY9WIHdpiZ9DufObJWzizzPpnNkLHtyMsXL
X-Google-Smtp-Source: AGHT+IFC1SHa+o2dht0iDyRVFrIxZhJ91FqkHDCIfZcHBadorNJvzlHZJmoxbvRhIrg0G0wVvQGeMg==
X-Received: by 2002:a05:6a21:399:b0:1f5:8e94:2e83 with SMTP id adf61e73a8af0-20e96206067mr8026628637.8.1746409948979;
        Sun, 04 May 2025 18:52:28 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:28 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 02/48] include/system/hvf: missing vaddr include
Date: Sun,  4 May 2025 18:51:37 -0700
Message-ID: <20250505015223.3895275-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


