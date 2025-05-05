Return-Path: <kvm+bounces-45360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64316AA8ABB
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D89CD1893547
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB8C019AD48;
	Mon,  5 May 2025 01:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aCQuDL/n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4AE1AF0AE
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409962; cv=none; b=IJYb8fZEatuiX49Ir1/l9ulOiA3fWN05i9+CoAb2Zn5Vu2+pMlsNFU9d6i+0J+95kDcVnqfVWe2UISKCAFLIm7aUXa35m5GUkRkrCH7u9NtXTXyGQqpMLepHXk+AGOZqtdTnxrHhmHdjsXPk+XI9vV2ypeeUVXoSGUgEQEWNM2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409962; c=relaxed/simple;
	bh=AEdec6YxwqEM2SMva6W9gXoK89VbojQSf/TWlriKM5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXnzUOlMWz6Q9CTlDLhk4TAmJCw7AAiGsFtI9o60nqSOcCh8ork2nBQKtSnspxES36o3WoEQxWaeSBPyD4CHTaSPkx3v6cbPMQouOu+VJMlvmRKWetG2D/JTn6xsJag28IM69QODBQMH+3kpxPm97FI4Mv1oiqERVY1fk9Xc6/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aCQuDL/n; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-74019695377so3122098b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409960; x=1747014760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=aCQuDL/n9OCXhFlkuJzBYSXWvieC0NSE9vBsjXUsyUjHzXxQPJqwIKTzMYt1+7V0q5
         BzsX1G6lAQBMAiblfbd6cUQ73cjge0w7cxd1QBWRMyxlb0LfhBfsjFtBr8FfdsRRbte+
         +Ljba5U1IG9M7aEbu1zPYIQtSCSfMlcZbO3aFPJRdHDmBXODDvrE6UkBiOFqbts1neg5
         HzKahSv7QCXIJpK5e6Q+CDRfklPxJGPaqZMhsyc5AqiihpIDMCocBMuqQPiyihb5zRbf
         8PWq4fHCv8X3DMo1ceIMpvKbXRCCtFCWg+N++aaxw0GM+vwCwsRMAtyhOJDVHKHTwqTM
         0wmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409960; x=1747014760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=c2jiYbFF9bSyEN/Lpr/eWgxIkEeTwgZVH3BwFRm3Y7Ul7vq+ccycQKsrUoHsif0PoU
         LzUlP+t5DZhj0Z3ndAUXPvP6DRnUdv08HljmU6lpVG/lTSIy4EYOD4xBuBMI9xTZpnYz
         xqS5IT/qWtxe41sZPd9FmlC4z/gIKwAV7V1ITsCrCAYP2O0qNGdiM+ntLh4R1FviXIeL
         mkUrob4697o8eDCugD4PJ4ETMRb5NaYOPkSJuyJcywPqEJfSlMCwS9061qaL7bXB4SLB
         FAdrmhDyYPJchayNyMLYSnWG17yk9SRDDbmLCZ6e860CBbuE6NTDunzhAJoa0lcPaL3k
         JZvA==
X-Forwarded-Encrypted: i=1; AJvYcCWuf7Y76lNtvox6/2Luhm0+amIBgmLpnEIQnTeQ+b1k/bVsPkT/JqkOKvuFnX9Wir1MoEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVWESnLdLszNX22ghcANiEEXUV0KuxsSvh8NekgcfUerrZWooX
	T74Bx55yubKnh4+qKNXI3hr5gUoIsh9SXYZGKyZibcgbL+/BTftDcJaTQOYGG5Q=
X-Gm-Gg: ASbGncv5sYaUMMyvR8aL5i6h7yO9IOTyXwONOgXtuzS3gMQQCcAbRijRCBlvcuFvE63
	0bLnwj42NA9bUKyqLbhFQvW9oXl7aLARKuTGmBCaKvvsrD4/rfwATdfv9a9v3AACtSluWxE5weS
	1aH5U5NPHSnPvgoDzefRUldlKLlpoFAI1PO5A0wssph46WPEOvCGxEZxvowUiLeXOHhSVsjA9OP
	d9jRwf1C2iaxR8wHPYv1QPbTWtOftyWvKv4MdJ6ARC6ZUIrZc/oNPtwOe2A27VS6GCjR1IQrCKX
	m7dDDqTPdn7JRjdYpZ+TJHZ1pAT080RWHE/7/Yh5
X-Google-Smtp-Source: AGHT+IFk2nTZ/2szMRArYw4zKgFF+u89wGma1goBz8QRVaaG2xYMWCbEQLMiDHJTA0UwqgVt1ZSd+Q==
X-Received: by 2002:a05:6a20:3950:b0:1f5:86c6:5747 with SMTP id adf61e73a8af0-20e97ac1a8bmr9116493637.32.1746409959886;
        Sun, 04 May 2025 18:52:39 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:39 -0700 (PDT)
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
Subject: [PATCH v5 13/48] target/arm/cpu32-stubs.c: compile file twice (user, system)
Date: Sun,  4 May 2025 18:51:48 -0700
Message-ID: <20250505015223.3895275-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It could be squashed with commit introducing it, but I would prefer to
introduce target/arm/cpu.c first.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index 89e305eb56a..de214fe5d56 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -11,13 +11,9 @@ arm_ss.add(zlib)
 arm_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'), if_false: files('kvm-stub.c'))
 arm_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
 
-arm_ss.add(when: 'TARGET_AARCH64',
-  if_true: files(
-    'cpu64.c',
-    'gdbstub64.c'),
-  if_false: files(
-    'cpu32-stubs.c'),
-)
+arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
+  'cpu64.c',
+  'gdbstub64.c'))
 
 arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
@@ -32,8 +28,12 @@ arm_system_ss.add(files(
 
 arm_user_ss = ss.source_set()
 arm_user_ss.add(files('cpu.c'))
+arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 arm_common_system_ss.add(files('cpu.c'), capstone)
+arm_common_system_ss.add(when: 'TARGET_AARCH64', if_false: files(
+  'cpu32-stubs.c'))
 
 subdir('hvf')
 
-- 
2.47.2


