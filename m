Return-Path: <kvm+bounces-45810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A461AAEF90
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0FDE1C02D82
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35CA9291874;
	Wed,  7 May 2025 23:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xx2qefqx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E0928FFEC
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661617; cv=none; b=CwJAfxa4lheZCgw5PEmgUzZBP0qLLY58wstql6/sj9YEoKi83IHFS65rWLcyJtQ1U5ygK57xx7elFTAG6MDQWOZ4b3S08NxFHqgoKlFInw1L7O+XiPTCp13f9vWSB/gY1PGtHK08DlPyKjEXr91/hrH+kCISS4VFVEoRX5tB2jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661617; c=relaxed/simple;
	bh=VnT71K8Ea2O5Onxo6pSBB5UNJtKdovZ2hzSFYNY+2bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJeIT5KtJNoPW4XR5DQBRrN+iRcpCsoU9syQ8cqpJckwCb08Nnem2Yi1ALKetIyaLes5iABJwiBPQepMLeK3LqFPVFvU9ESJP4SYOJQUgxZQeqc1/wkIOpR5rUhl4uSuv2tp7hlWg6XX7EfGc0nxn+o94QYLa1ghTJ+Qqf0vRzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xx2qefqx; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22e4db05fe8so5120155ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661615; x=1747266415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11Q55+gMF5u6Eo9NyNW4V+s1ceVG/+YyEcTpuHMGI4c=;
        b=xx2qefqxL6G4d+ZdYtqTScfuVF8xRKJw1+UF+g1LK2p30E423eH2jA8ivm5oAw+7ca
         aRWhnp11MUCaY18dJIeBSRSJt932DOPfDqtTAN8JyUQBe0F4mmY8pYxO+DExlPWsg/d5
         WdLV6rNHou8Zs4CAHKHa/VwhJ2ypNrKA22vQFxQa2TJ5EIMmENMcqht7VxhR1qPppa6O
         yx2Cb9LUbEJ+Eq1WQCa04BV+AK0F59IfKzk4APFlobSpwzgARuhasQcNeqgz8O1WmllN
         k9m6CoLFFBjzuo3L/G890aPynlrRUwKWw9SYgzRGJdVLgyMowMaqgc+dbDbFC3G6owra
         PmBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661615; x=1747266415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11Q55+gMF5u6Eo9NyNW4V+s1ceVG/+YyEcTpuHMGI4c=;
        b=hoCBNsYHnwGIzR+5KN87i+VAN73vTZnvK+ASqKwDkxG6oXt6aZwcjZui2nmZjZraQj
         2TTxEIgZhifBu1XQLKpEU7qk0w3BszYNxKhVlj3pgeEyOSOfG3eMXPkmRpbPTW8+YMVo
         3fey1uRrbyqHdLFKAK7Tx1x8orOgDVPWvEayNL4iNB5RT9AWDu4y2m7gkqSIYAKSIVjq
         IVVsy7dVBXCDyEquVGsVTRiE2LhMjeqCf3mgsgxGthTG36353rJb0lGnhxW+tRrMpSAS
         b3eEVN/77xqYZPnQnARz65T41ix7eIRjqq3UXj6jx73/ABBhHSBLP8a2YOJUqb7uiw62
         mCYA==
X-Forwarded-Encrypted: i=1; AJvYcCXX6N9+XIxKWbH6sNVzcXpanqT1w5xvEH1qgUVbsfcGZ4iIOYyCOQh1wJRC2P5JGd+1fgc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLLOyPb38u+OIkTEMj0nJ20M0dKTjRx/9Fzob/b6tAb6NYV8Bj
	EUgLgIVz6SmdI7MMNcMJEmbGP9cZdrvz2ODWjIBVxtiDythxOnVt2XbmHASX+c8=
X-Gm-Gg: ASbGnct7IUbSypAdpRKInoiJV4Y6gIAv09am/Avzca3RwQgVD88EKxXiMlH8YsSObYj
	B+oPqAUFMxXFYwQF7KvfgXHWiBEbftr/CrKUbraWVdi+cbQPkg7J1kB5ntRwK4XCAfS3f8I8Gny
	H9QNoBDtdozjDKV/jiWtuiO4ZRt3WxzCZ8+jgzHT+9RDN1bSfg3AYaHqpuagDucoeRH/BnLDIea
	xuuQ0jQSSjMbBy6mDZbRlNRZcAnlEUm9MqVyeyiPFt8UgXkX7KX7LQz5hbMrAhBL98/AQnT3Cmo
	6pRY5yAaQXgNzwP2bW5fIJBhx/QIbKU6CF+IfDIr
X-Google-Smtp-Source: AGHT+IEeb52mgakz+8TCt7s0DB7r7G8IMfnoPVX8rLcKaGa0HamIowdccKji4YJ4u1M8woCDTY1WYw==
X-Received: by 2002:a17:902:e748:b0:220:e1e6:4457 with SMTP id d9443c01a7336-22e5ea7d822mr69085515ad.26.1746661615265;
        Wed, 07 May 2025 16:46:55 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.54
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
Subject: [PATCH v7 44/49] target/arm/tcg/neon_helper: compile file twice (system, user)
Date: Wed,  7 May 2025 16:42:35 -0700
Message-ID: <20250507234241.957746-45-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/neon_helper.c | 4 +++-
 target/arm/tcg/meson.build   | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/neon_helper.c b/target/arm/tcg/neon_helper.c
index e2cc7cf4ee6..2cc8241f1e4 100644
--- a/target/arm/tcg/neon_helper.c
+++ b/target/arm/tcg/neon_helper.c
@@ -9,11 +9,13 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
 #include "vec_internal.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #define SIGNBIT (uint32_t)0x80000000
 #define SIGNBIT64 ((uint64_t)1 << 63)
 
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 02dfe768c5d..af786196d2f 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -32,7 +32,6 @@ arm_ss.add(files(
   'translate-vfp.c',
   'm_helper.c',
   'mve_helper.c',
-  'neon_helper.c',
   'op_helper.c',
   'tlb_helper.c',
   'vec_helper.c',
@@ -68,8 +67,10 @@ arm_common_ss.add(files(
 arm_common_system_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
+  'neon_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
+  'neon_helper.c',
 ))
-- 
2.47.2


