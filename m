Return-Path: <kvm+bounces-45809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E62FAAEF9B
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01FDBB20BFC
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E43C20ADE6;
	Wed,  7 May 2025 23:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="APpbHV6t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D69A216E01
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661616; cv=none; b=AKNkV373AM7k2Mk3M84szLV+70nJ247/bSnmGnijZE7QZ8ypqU2B+APcD3GJs7if2/YaLKKafRrBjVD6GgmOoQfdmQAXBltnsF4B88M7jpA3DxFFujCBiAw9VrCnJfvYrVFrWpR5VFIq1Tc/70av9VgRpUGpl5bPtIgqmWrWEFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661616; c=relaxed/simple;
	bh=R7KaXfalIYRJfT+v9IQzgzHxQq4kx515QhTMDlYyHiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KACRO2jfJH8rm0d0xRgD/jAHUVrt0lfSLu/swrwwu7N+zKZiZYKC+9vLuAZDtgcNoU7Q3vsI6fQyBR6ol5ZIG1vnwKy6CMg6ZENxsJhkpKnwJ9SbRy8ATQa5util6xYBlYJLZYYnf+e56vcqD/eWXSA78y1U2tc0UjA7Yx00sNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=APpbHV6t; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22e4d235811so6476725ad.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661614; x=1747266414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsZT/scaGxab+Vo7Y7hWrcYUC7iBy9GgtXflG2/7Eik=;
        b=APpbHV6tkigTduN2SsbBuawRwNEuVeR/4D30LvLWLPBcgWqbE8gA1CY2D20ATiep4f
         BMywwYwauF4+NL4H3HfYxt6k0ZEnb8uAOHc1Yd8VEdA/C0Jz3HAfe+dVBMe2Rzty0taO
         DxqxeLawOyyDUd8w+VYY0bXcbTDxgvxDrsSu4BA1CBwt83RNvbXoBMvED89YFqZqbsBd
         N1Tdl7gjA9n/STuNVX/5nQj46o/lgyiAONJLopWzgLo+3LiierwqMs3VM3RIwC2lM7zV
         ADnEIzRGiILjI0qV3HqreLEE9ywNhh/SwsMLXeRrAQi1hm2ASUsuPFMJ+grQ/pRwkmui
         dGQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661614; x=1747266414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rsZT/scaGxab+Vo7Y7hWrcYUC7iBy9GgtXflG2/7Eik=;
        b=XsRyQGs+rquyD3RBN5ELW9cowkOiUvdPGdATQhzNDUuYPXGUsjnrE+ys1D80idrEXc
         du/eWJrR1PKdUbuSynMxNEdxrLFi3qHJqKPKBMOiXCUjThdLdnO9HPxehEFOr6ukhslQ
         sXIbXzO6bHfsqlfuCmCLfZjdyue6dO7OsjK4y3HIB9G502N0625t8bH9m+BzP8EGDzcJ
         g/riSJ9Giy/iKCUWRLUNNTOW5cpgduQYn0hE6RPUPpHkdWqLQIrGQxeP2S5W0NuEE0ce
         2vj5a9tcoFZEuIgjRtaLnwBRl+k1HdGQAnFSe90bGTV5nkOLwvcx/GsAzpCovMfjEX8q
         byfw==
X-Forwarded-Encrypted: i=1; AJvYcCUbinicsVxA0blKjxMeGFB2/ioZS/YHJwn6trYl/UD9ZpQiFJsEMoN0OpjgTVvmKCbgp/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDqzZ3vTGZRd0WCBNhfbLUd16bXxuNoNA3aPiHI79takyYhkqm
	6Fnu/pG2lmYo5qzA/3kH0Z4GabmRJduBFNLham3GhpXCfl7YwcFMBGbeUC+aevM=
X-Gm-Gg: ASbGncv7KDyGpFJsQT9SWZTzOMy/nxJFk5q+VN7VfU/hpMuRL4eFctV4HJxuYDiA56U
	AAgX77pEM4ykCpXr2xszEUKFQb3hp0WzvLSSCSqzdUCCtdIUZzH+GPhLuxpFHejDI+Z+ZWVa5fK
	7WeeEDD9zIJ0oNyHbvzyEf2xTeUqieA+IpEb/AsjC/6nc8Uafgho4vU4sIwuO5NGmLMV7T5cOqP
	9WV2Lp9gDibvFKUPmHdeEoWLxUCsQc6edEMDuJuVYeztbNxbC+5rNsck4MPLO7vLu+TCU/oanOA
	VKOh8oHOJWpAYdfVlYr+s9KeyDnSpsYmebN05Arw
X-Google-Smtp-Source: AGHT+IFL2cEF8uWqAwFWksJ6sodfxO21NIRA2iSBkFtqqdnEK0CiHPjzx/0QR8TPRq3IFPVB09ZJeQ==
X-Received: by 2002:a17:902:f60e:b0:22e:7c8b:7e66 with SMTP id d9443c01a7336-22e864ee727mr14841735ad.26.1746661614429;
        Wed, 07 May 2025 16:46:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:46:54 -0700 (PDT)
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
Subject: [PATCH v7 43/49] target/arm/tcg/iwmmxt_helper: compile file twice (system, user)
Date: Wed,  7 May 2025 16:42:34 -0700
Message-ID: <20250507234241.957746-44-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/iwmmxt_helper.c | 4 +++-
 target/arm/tcg/meson.build     | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/iwmmxt_helper.c b/target/arm/tcg/iwmmxt_helper.c
index 610b1b2103e..ba054b6b4db 100644
--- a/target/arm/tcg/iwmmxt_helper.c
+++ b/target/arm/tcg/iwmmxt_helper.c
@@ -22,7 +22,9 @@
 #include "qemu/osdep.h"
 
 #include "cpu.h"
-#include "exec/helper-proto.h"
+
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
 
 /* iwMMXt macros extracted from GNU gdb.  */
 
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index cee00b24cda..02dfe768c5d 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -30,7 +30,6 @@ arm_ss.add(files(
   'translate-mve.c',
   'translate-neon.c',
   'translate-vfp.c',
-  'iwmmxt_helper.c',
   'm_helper.c',
   'mve_helper.c',
   'neon_helper.c',
@@ -68,7 +67,9 @@ arm_common_ss.add(files(
 
 arm_common_system_ss.add(files(
   'hflags.c',
+  'iwmmxt_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
+  'iwmmxt_helper.c',
 ))
-- 
2.47.2


