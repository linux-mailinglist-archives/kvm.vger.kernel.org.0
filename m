Return-Path: <kvm+bounces-45380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D738AA8ADC
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D9683A637A
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:55:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB9691EF0A1;
	Mon,  5 May 2025 01:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NCmXcskC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A831F1E834B
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409981; cv=none; b=ovRt6BJD1Sf862rjl4h2i8hpyHeyHDxFq/fc3d5OCzJqThlA8SX/kFahe/nknVvRCNlsuCIPh9pG9MUqZzUmhqB5b/CXnSDTW/4z2GNeonFO0joAPE1g423m+xxXGUj4/UN7aPeidfG4TMy+/YHRIEeUBFyYD8YV2ZqTDRWVsN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409981; c=relaxed/simple;
	bh=ENP2hN0JkLSGgU+MLNHwU2T/tGgXwB94KuX7uaX3DAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3OhcZph9QSnb6bkZyypN9y/glDX/3D7B69ius3+PMlbJE088CMkZQyDMh9d8R+TJKUx66ZtqUqAFeWvUkY7vnEJmiRVeAQokXIPEmz6r5ZQs+4RyTvj7eNWKclKIGDfviHBJV6SG1+1Utwn3xlLK+H70lKhgi8GjknXxQYBHbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NCmXcskC; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7398d65476eso3060360b3a.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409979; x=1747014779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=NCmXcskCnrtPga/N73j+Dw/CiwVjEMd0MIecZwXbHMBxDvvixZ84V6i0P749nifDaM
         Kh6E+1KlK8KZvqWZvMJBNh/tIDNcpDI4XC0I121w6R5biTs1tq6HBe3/+GrLMtXtQMYa
         Gou+LvA1N+DTjRmU8rkjcL+Hhj5u9o48G5524gMLiLUl1wTO4sQm7j09z9zW16uvg/z3
         9RbbxMQE+CZOHhYGQOOzDEJ7U4ua/5YZkY3sXBjYl33TSQqYwkZRg+JBkLSdLzK0RELP
         ngcJe0JyJ7llpSJaaZxH6qxZ3FjUgDJEt5ElmLEn4hJXJyjCEc37SVJrJJTij7fBEDl6
         fbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409979; x=1747014779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=F4Nc8a9ff8RDAcMiemuUJqque4r2xpDSp0+ygBIEEPNJIoOqbiLqNL6lg4mjhNYj5B
         V6QUHxHMDcUyGmpUvNFt+na9AGhVFLWQP62MjHTu9OBjAYssHJ58wjzFmgZndT5QRjmC
         nuQ+3au2FDWesRvNf3JDS9dQXNEuwKYD5YYznUYJ0QeuGJPDUik419NbQfIinIZK3XVF
         CbwaFlTzgwKa+0gXsVlkwmMYymh95DxxMkNycKDCVFt/fWDNQciADWvIlintDB/k2Ft4
         oUf7jFDp9o6LleTDzndhEzlks4f4atNtGYWCVCw4fo4k7aMKELJcX0ZNP2e55hkNJczf
         SL0g==
X-Forwarded-Encrypted: i=1; AJvYcCVuTLLG2SJ51HXYjgZpQzoFEpiPL1eozPtkDSNxJCRJBzVbE+plGv1SWRo3ULkPH55KbnU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2Z+5E8oa4+b56mvR9MNST4rI3vLUSv7xU0KH7vajboEFoJ+If
	IvwJRaL0OTNLf2lDLpfhq5o78psUMIw2GGLmuldLv8hHu4AMgymlJHbbEzjo84I=
X-Gm-Gg: ASbGnctpA2Y/xZ+NXra8sgvFfDSgGalssIGyL2PHkB5biy5r/ZM5Wq568eRvSDemmsr
	zBsyv7oGaP1oaCDQHuPQ6p087lLOvzhcqlTUmdTUr0JFPNulT0n7i3FqY1OfdoEU51x8eERHPB3
	rzMTc+XwuifJmvSRW4R1QB8VhvRcotJAfNmNFIKNEgEhcYvPojvPhFrg5VRgJp+O6YbbXlO6uSN
	yCb4SHvT1bYiC2bSjlp5EqXKgN9xKOq55ie5V0CvMGKuCUKpW248Khqsw4uH3p+1CkH20QIZLSs
	Qo6yc83Z2Z/GP86g+xHmoN+A7lrBIP64W2RqWeq8
X-Google-Smtp-Source: AGHT+IEBqSWAZSrJB6FCEJYBOGMoQn9NjDs/eddpBPADMLAHWe8pda3zWyhyviTYa40vpwkWQJSf5g==
X-Received: by 2002:a05:6a00:440e:b0:73d:fdd9:a55 with SMTP id d2e1a72fcca58-74057beac3fmr17689934b3a.8.1746409979095;
        Sun, 04 May 2025 18:52:59 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:58 -0700 (PDT)
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
Subject: [PATCH v5 33/48] target/arm/ptw: compile file once (system)
Date: Sun,  4 May 2025 18:52:08 -0700
Message-ID: <20250505015223.3895275-34-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


