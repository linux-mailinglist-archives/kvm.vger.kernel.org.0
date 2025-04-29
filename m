Return-Path: <kvm+bounces-44677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9761AA0189
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA56F4815AB
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063712749FF;
	Tue, 29 Apr 2025 05:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iqa+IKHY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD11E274FD1
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902829; cv=none; b=p0taBoNpzUiuMiCokaewR1bBjHERmxWiHjnCqbVr+NpOqVNSwgS+5Yu8hAIH8PSoi+xoxRdQBhUnCDzbIz71/Bj11yIHNWrKX125VnVYGIGkAkNBnd976Ov47/SkVRnNdG4bTdOYZgf7c8yK/eNQIDpeS/Y06nMEJT/G01/DOQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902829; c=relaxed/simple;
	bh=L3RK6cazlD+4isklQrUjoRwmR2X9C06dPPYneBTr45Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLElGhRM7ERN+95vZiDjIISjPgsEFh45OgnHrTmYkdf67DpGktsH3/vLCWIpx7vK2W7uoSrQ4JT28/YzvRarBxJqism9aJhvEIPV4X0uTBfyAZ6JUI3DUciDv1XQUtBj33jFvbXy+IwzBQOWhsHXygwDxDR71tyi5FxKvHkNiEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iqa+IKHY; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-224171d6826so83316895ad.3
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902827; x=1746507627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k54PyA3qe+UbX4AzHMockqDzIGWdHV1GUXIbKPo2M9I=;
        b=iqa+IKHY5R+QPX+pZjV9KJ/Cbocfg0NqAVBI01nr93UqBSVKMJutnoJLGioMPk5tDu
         NDFMdbkVv4OE/bniwHSr697Bli+ytJ8vc0psYQur2rllJg+wn+9lm2TINBcPZbCRrOIT
         qu2G+8qmsMFnJnKK7lqe7N0JxuuStaSozlsH8MYbQ+BWuabDbEysJeiLQ5eN59FicvSZ
         xdylzVfKD2O7C9RFGoq8x9XizqylnFGP5e/dmV3hRP248tSbAEZZCwFnfoZ9F6Kshk0R
         iaDVgEFzm6HlbTnxlcWH/BIrIT+71Ax/eihcxXSoX2523gouLaro+Ktas1btHay9yTsJ
         LJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902827; x=1746507627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k54PyA3qe+UbX4AzHMockqDzIGWdHV1GUXIbKPo2M9I=;
        b=bHExI7h5Yz6h0c1rbAUDg6kkVMayqX5ZfrmJJAE+7DxrWN3FVDMJDq1H/MKvjtqJa/
         1ERSv14cnR3FlBVOgb5nFy0R7Neb82R2/3HZk35PU5ZrpZU3O8r9YhmXapP2gvGkLnp0
         pl2AT2Oahn7wp9+Uop7+6XRrKfliRI9OmDTWqIC4fY8pz/Hrf/xxQqKSKnsLFvFFDDtf
         xG3I1fbFztPdP6ktJopR7GK68kfzKbLunQC9JCZSs8wv+J8iQs15VDQAyLUW4ULz4L55
         7PPn+lxio9z1rdSRxThdcXiuK2DgNncE/Z1ujxCBvvYRlaCYXQpyyOJa+yMAyQSjfECI
         LwGg==
X-Forwarded-Encrypted: i=1; AJvYcCWthEE0/L0TNZNUya3ZFbM8ODLTCHd8gflNsq0gRiwYTJasJAhxE1GvjivVmUGjBZ6aZlA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo9RTCvxbPx1m3IIeHvFa+qWkQCkyILhsP9xsmZ7MWzpvXBSVZ
	YaDzsARP4b6uPtRn1Wz1r6PDxqU2SuqJ93LlBXpYfdU4c9cjdcZdXFvf7C+dkvo=
X-Gm-Gg: ASbGncu0a/Zeiz31aGmpsgbopwz1Rhz94Wd90+TqMThTgNYAN3ImigdpLFt5PSuWoqR
	kmwuX3rDbI8ID8oqxJ67mGjDKGCFgRkwJPBjMJy0njvByhXE0sokBKdUXGsKNYUHKBan0GWnKW8
	mJ2ZBZkA0NCCMRP1s2dsDthdsMrT9xEVVEDgd8H3t9gDDWboo+NXxp95NWtiQIpW90VxDcrx1gq
	bR/KdMTGDoOleLnRmNMaxNUxYWj9qdFntnVZRXKAr/i26pT+WQb4xKPsNDzqmRntVOQ/6OPn/UJ
	WUIl713BXZrqAM5M9Oe2VzJqEbeaMkXlpQqwuFOX
X-Google-Smtp-Source: AGHT+IGBsvYnMwHnQTWjvEkq+70PORjBWNX+JNL7swJfV4JLCjXOenAAVaroor531SGQHMVm8lxvuw==
X-Received: by 2002:a17:903:3c47:b0:216:3c36:69a7 with SMTP id d9443c01a7336-22dc6a8744bmr177357855ad.45.1745902827034;
        Mon, 28 Apr 2025 22:00:27 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:26 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 12/13] target/arm/cpu: compile file twice (user, system) only
Date: Mon, 28 Apr 2025 22:00:09 -0700
Message-ID: <20250429050010.971128-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/meson.build | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/target/arm/meson.build b/target/arm/meson.build
index c39ddc4427b..89e305eb56a 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -1,6 +1,6 @@
 arm_ss = ss.source_set()
+arm_common_ss = ss.source_set()
 arm_ss.add(files(
-  'cpu.c',
   'debug_helper.c',
   'gdbstub.c',
   'helper.c',
@@ -20,6 +20,7 @@ arm_ss.add(when: 'TARGET_AARCH64',
 )
 
 arm_system_ss = ss.source_set()
+arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arch_dump.c',
   'arm-powerctl.c',
@@ -30,6 +31,9 @@ arm_system_ss.add(files(
 ))
 
 arm_user_ss = ss.source_set()
+arm_user_ss.add(files('cpu.c'))
+
+arm_common_system_ss.add(files('cpu.c'), capstone)
 
 subdir('hvf')
 
@@ -42,3 +46,5 @@ endif
 target_arch += {'arm': arm_ss}
 target_system_arch += {'arm': arm_system_ss}
 target_user_arch += {'arm': arm_user_ss}
+target_common_arch += {'arm': arm_common_ss}
+target_common_system_arch += {'arm': arm_common_system_ss}
-- 
2.47.2


