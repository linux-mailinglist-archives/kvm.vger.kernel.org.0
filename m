Return-Path: <kvm+bounces-45508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA79AAAD52
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDFF016EAF3
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:30:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FEA3EBDC4;
	Mon,  5 May 2025 23:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AXbPYKhC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C8C3B28BB
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487249; cv=none; b=mKDE7uw79PA+mIGdq9v67pqoBdO2e2vieylme0QOWGBVrJR2JR0xFn1a+BSwwcHZpKniut+8k4Ot2+fOSgt18Nr5KGsZaIMNM5G1x7Lf7w8N6bBJoL1gb+Q8Ox0LSHbHHIdV40CYPvNt5qwY6IP/pJmVwLGBZuymb67URKqZ8os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487249; c=relaxed/simple;
	bh=nio9YJkiK2g8f7JN+bhkPA8UAPODA+S829FcakWQE/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8+PFjEY6YA0/hhBYYBIK/GemBopivcwKIbtmXTww4ibZKyH8oARlCjIMPi1xHcbDNkV23Fc2VaxSsxIREK6XYtFZjoEkUNz6Qph2jBx9KzKwICnKvcJ+4uXx+dc0O6tiiB3aNU6+/ROor5LE6G63WGDvhK/hPi/MHxU/qiwu+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AXbPYKhC; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22c33e4fdb8so50781735ad.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487247; x=1747092047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=AXbPYKhCYeJNY1J9rcFDa0pqLWH2GcWlkJrcHDZunHZrLBJ9sVh5iO5y3WHkoDoBdS
         uyifD1oG02bvC2vnV62uKb1vAV6F6f3AWueN5TzlTMJL3XJSZ1pLa7J6fmUyJQdlLeYI
         NzxvP74VCLid2KrfjdPd0633oK8nJ61pYYMOsR7aBKdzvWrw6riZ4/nwkTk95QXyHrsO
         es2QLW+Aww8lTUwD2/f3mLdqClCRlbZVYicBWZaXYnT94BLHMO4D9YQnVgnd8z/NOl4h
         d+bUJXZKziRZwL7+hSixFLzFKiheSWryPWOOf2fLWvLuifdzmfxmSo4G9qjmLj26q6GC
         FB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487247; x=1747092047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rVtP/RnhHG9awohdmhc7BZy6oUycGDI8ImSQa94LuXo=;
        b=KfqxF5AomabSlLMTcPINpDQhB8llhplg7G8MT506yHcxCKLy0PDnoVWPLWzdWPSMmg
         kGU2pSp51tq+MhUi5IhMO6DP421V/4Ip0vp+xgVqIbjSIPhGp1kqsPddHrtXzC7etSSb
         QKzhNeLb3I9HsCG6nMJfZmH3CAsC8IvL1NVqff/8gHiOPL8k+UgpjHVwzVzmTxutSAuO
         Th57/w54LMdhWUjdKVVMgoFzIZtLvC/uJTj1xINZ7WW74RReWmYGS7wHo+94i8dr+u7E
         w+ufIvjcZvO515nP2Ahl0qB6wnT7jw71RETwF9LTQ0nDz+e9Nm5BuZ+aWpzyQtSqffe3
         ngrA==
X-Forwarded-Encrypted: i=1; AJvYcCXswQhOTWmRMBYeppw29/aon7vGbw2dgQehmSbLdxI+hElfclMQ1FUg0F2UfWV2lMOS2LM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLPIraLXQjUVpK7fyWjEBydB67gNnIV2NNNoS9RxQ3S1EM/ktj
	FNJtluB8CnYrEQ7OAj4BMqAKKpnrYYrBs21JnMb9BZtWlZz7fV+Aiv0rcJd+xsw=
X-Gm-Gg: ASbGncvmpWro9vizhgX28hTwjMjFy0syhrHe1TLaigne5dUPiS9bfm7rYvYzZa/SGzH
	PPl2LBndFUs6MsNSVH72+vylVfnjOh2Lo0EwawHLjy2qV6XbVvpqU7BvBQ4FRR6UHDGp0PPTsIh
	btCQTYzmVA0uFQBcZyVmenJGQiq24UhIZcLKlkmVBzUHLjQ0H+jkYwXd42FgqpbtEYNEfNmeDOq
	ptAYnyM2fWoiihRY0raAbsLEfiqFnqbTSha5Gg8Dnt7S7hBMyBL0TvKqSbkBC14jqePuQpm8SLl
	QlrjhtgoS0usiHC2ltJuuAwzpsf/ABzOp2WXIP9X
X-Google-Smtp-Source: AGHT+IEMmS6ciWk/Y5QYiejcijVDCumZ8eY2Sx72qIxgeSdq7SZvIl1V5RaehgZdSDls9z4ASH3d6w==
X-Received: by 2002:a17:902:d585:b0:223:66bb:8993 with SMTP id d9443c01a7336-22e1ea79d91mr141126175ad.43.1746487247181;
        Mon, 05 May 2025 16:20:47 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:46 -0700 (PDT)
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
Subject: [PATCH v6 30/50] target/arm/cortex-regs: compile file once (system)
Date: Mon,  5 May 2025 16:19:55 -0700
Message-ID: <20250505232015.130990-31-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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
 target/arm/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 7db573f4a97..6e0327b6f5b 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -16,7 +16,6 @@ arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
-  'cortex-regs.c',
   'machine.c',
   'ptw.c',
 ))
@@ -38,6 +37,7 @@ arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
 arm_common_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
+  'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
   'vfp_fpscr.c',
-- 
2.47.2


