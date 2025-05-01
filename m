Return-Path: <kvm+bounces-45030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA4DAA5AC6
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5DB19A3759
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:23:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A9C26B2B3;
	Thu,  1 May 2025 06:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YuClf/6T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02631A0731
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080635; cv=none; b=JQZ6+ELUbMElqyKUCy8IPdhWuNY8QDHwdCVE4ocoaOhctpTbvOQJt7FJqQor7Q+V8bjEkNRL7eh1LwdA0ODwNvrmZvU+bvaE3fcXnrOu6rlNYwZ/y50leyA5CYiOWe7srMb7IycDABGoXLzbURZchfQBWMo0YJ4Ul1hpum3JZZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080635; c=relaxed/simple;
	bh=vpF3aqJ8G1Nzy1z4/D/QO4/GNb59/siAKHys0N7ei/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a91nAxlTXyirwlLLlqwu2JvzGtiBK9pujkGujf2sTifl4xUxJXfVepksbFB99L/2XmdFQwwVAryD9pppFzEMA2Dt1b/PSUfVOnhfNRIhwSRKotuQ+DfbZxHzO60NHdX9+Tihp/X++OUBwdM1bBjgPE9Uth2nr8vbRxgr4+vpGbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YuClf/6T; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7399838db7fso756270b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080633; x=1746685433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=YuClf/6TPloQUUaJj1xZDC4g+whBbEptW5vZqtEolfKNxsIbbqit+hOmK4xbeKDsR9
         /JvCJukc67kDdgCrLp5auX2WEVhUHvEEMT+3s5mwxaX5Zcq4GYEjQu8GuRGW1tRl+D3c
         sIxixsjn3LW25K7I9dkK6P8QzMthl5j3KQP/4hQV7LysFnLSAQu33yAmduX+7TuF4Eby
         PJIWVsGHEmdGzpIHbvg4+Svkzi5IfOOmhQ+RnR5FLzvijqatsHMdBZZOYnfHywyNfkpy
         osg/9BU44kMvm689861oVWZ7lAzXAOFiJT+Z/LYSc9ntx3w+zT/tkjgBDmuLokYHuMp3
         F26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080633; x=1746685433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFP3MpqDIAT/Xkpc6JOppR3V5lexoIXt45Qw9vGPUlk=;
        b=aloNFEuUWaW0x7t3VQzAq8YuJKIH3qqFX5Lo+RhccQh3KZ2liHKgDF4aLj01JhFssg
         5U9Lg/e6mwdeD2xDoU8KD7XNoUhmEZdhHZgRxrTBg3WExSfkj+RjgiVxDvvRfQA2z1Fe
         LoDkeKjFVWmggCHuHnFgL8iBCMgnlQkQjK0oUgYvWRTYZNdTRe5rFV/R44qN2IFzacc+
         bhRj1xTB6dmusaV8vtxEMUeukqOBavXrDmBDMJLEGlEsjYsSqEPhTUKeEWZGExfW+bZs
         43y3ljh1MNyXSpGsdqxaK0/kwwa3Ja5rtDinG6cpO3zt58dac5PAt341oTVsWlpWzvru
         B4Cw==
X-Forwarded-Encrypted: i=1; AJvYcCVJxoEPlNRzCZC7ow3kWTL01seNLJm58U2x1YMX5EiPDEvHDhoIDHKAKEYo7UabX04dE3E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8/KF67tqOLlrgApJYnPQRxaFtMOnX11u2GTlGRdEZ1pGFg9c7
	GVpeNKZnDH8iOItXn3vrNvuMVpy/NCvDMp/kqWqEb4pqdRXG+z0ff4RWBIlHhqY=
X-Gm-Gg: ASbGncug4gm4oN2WqrhJgbUR1iSPMkvUwzP5iYxzQCO4thusjpVg0mKHeGp7WKQLIKq
	m/cWuZj1w3jegvG2YWeejoeA1Q5fu72Yr1EPmTxpGp1D2yx9jNgl0nhJ4GZX76NbQDBVMdpAhAg
	oG0diJnmXwP2loayD8VR1Vngo+RobZD4gk7m/zZPFqx83FZDGfAOP55qZ2ngz65Wf4/Y9AEWVLz
	c967aqOQq4zMbZcVpqhZdnAvHnnVOgKbfylJmZ/Vymlt85wnGMYHAlX6azYZ2+5F8Am03UcB5Nb
	oWn2v1D/UgrJPzB41nuqTAs91UsGkm0N3ff1jI+tYXhph+hmcWE=
X-Google-Smtp-Source: AGHT+IHLp/Trg8oMhYx6nbkeIUGb3hwNnThgpDTal4sQohjTHqVJXTQEFUpkDpackSyscwLCbu/wfA==
X-Received: by 2002:a05:6a00:39aa:b0:73d:fdd9:a55 with SMTP id d2e1a72fcca58-7404944e683mr2015130b3a.8.1746080633256;
        Wed, 30 Apr 2025 23:23:53 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:52 -0700 (PDT)
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
Subject: [PATCH v3 02/33] include/system/hvf: missing vaddr include
Date: Wed, 30 Apr 2025 23:23:13 -0700
Message-ID: <20250501062344.2526061-3-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
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


