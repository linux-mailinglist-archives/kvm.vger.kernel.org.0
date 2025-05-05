Return-Path: <kvm+bounces-45539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 878D5AAB61C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E6363AA263
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B254B13EF;
	Tue,  6 May 2025 00:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pw62Gg4r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99602EEBE8
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487451; cv=none; b=Su4Eq//stxTZ4U70/rqFe8BGVFsX5q0jQEudOavMott/NXRB0dVQGexKt6bLWyoiOWTX3Z0HBNS5CFNFWUSz7uESTN1Jkt6rL/65eAn6lb2hiTGkX8R7r6AXceorDRYwNnbEgoPUGk6uI60lnsgTo4WJ69emT5Pp4miRMVYd+DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487451; c=relaxed/simple;
	bh=/zYUGtiopuAnKe6Qv0yETkvli2mk8237qAU3JIOPtdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaCvVvw33V7bIPc8abSeXeiUAmjwRXJbhQQO7+Gdpoqt4B5BkQRPRQPOcW0HTiNV8WXb7N71hk9DlAzPOiI0PEJ/qEzVacK4OBbREobytb783TfQxvRViXM0sTtBwvoKqKsUIyTIEKPLOVrH9ODfTKtfIkPBfhchEZP7NuSqLCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pw62Gg4r; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-224171d6826so73701555ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487448; x=1747092248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6rvyCptpZZum3a3XLfgy4KbKHlT47oeB0wfjegrLwc=;
        b=pw62Gg4rKTGnd+rbV41U1W9bt2OPV15wV4HN+VrLpUwPLweyMx8DF7Q7h1FpLYS298
         LaX7Jg9aUoB9Owx3HBfaPF9u/bzmNGa5FyzxzTwcP3kRWFaNjufFoG+qlv19GG+hz81O
         EQGm2XOUu7zxwL447AJI0VIziIA5hLEvkhpfEgItMXB6OxpmoYZgz3UYy8iYgWoHwwVw
         Rn9xqZoF6L/rIvD1hVgzE0Q3ekFJu4p3036goxS+8LSGkybWtLU8AVdHUz0l0JaSUgWk
         vkaBtb3slr5TYzza5iShSDSQ2R7s0mKUPG7cu+c1HPC1O7OWV+uMr+elE6sAd1sBQASK
         cLXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487448; x=1747092248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6rvyCptpZZum3a3XLfgy4KbKHlT47oeB0wfjegrLwc=;
        b=kI3uPJ6eibGT898g6wji0NQQi2LCEl56J9nhGc0m+PmUruwsVld35G2MYgt8uO0i+w
         9IN8s9J5x3zQduiVM+UPOTnp2e3pqPgvmS7QZsN4u3zOqGqThZxSzkJljTK9t8iFZtSG
         gaj0t3YA4rfkyR7mSrJ6yAoqtHY66o1w/46u1UG+qLSHwmmyJQFlwiYbFpfgoyC3iEDZ
         MGOcCr290hu6tYj2Qikx0w4HsEgeDuFGtU1gieS76y7gURAbiPJrTQoT2iYjOOQZqSZJ
         ZL1QO+WAq6/zXLgdXBRle4zOTv3LMYwK4vhCPDpIFBb6Dz2miRu91Zk11wdQdNZQtFOS
         g4Cw==
X-Forwarded-Encrypted: i=1; AJvYcCWx6Mprgat19t03PC/B3/bHJ9plA49FdAtmBMu8HOsijgYarvJoQALW5as4Yuqcynsvr2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuCU/mDSOSVY6UKszqDRUbTYzKX5pf+80Gqy/M4Dd+BsOtteix
	8iVponjBQIZrM2ORB3KcdlT4yj6Bq+b12AZ6FtmExDz6RiBTedyq65jVQnnkdus=
X-Gm-Gg: ASbGncuhK4Vwh0gZHJvXoPl2I/IeK2LI6pZO0TnfiyZ58yp5NUMfNQEyq3x5MSLwc4D
	ht96keVwKFGau3XftjDmFA/Ei/2DPXupplDfZ7RseOGOnw1KIXrTs+7UHQwQZ/MROjdIZ1Mo/fS
	tTZMCatqrf6fY4c0bhH/fevg+FCAf/Zm2ee+MYjdEV7H3LN++GhE5U+uYGtkiOcmEVeDEM3jz+4
	JFC5ArmWU8/9ORG834XxP+56HB71XMc+sRTaMX8ZPhExYlT0eX4zHbSGrB865Bs7qWZ+Ad4QyPO
	/1Y1Tb5PlD02ev31sbzNxiqwmMiB9c4Mf5cRXB7/
X-Google-Smtp-Source: AGHT+IE4m0x6yn3Dhs8eTavS88cR0qWGl83trW3I/6iVUauH6UbtpdaA/Q0wYvVh89mav8zm9Mw0kQ==
X-Received: by 2002:a17:903:124b:b0:21f:1202:f2f5 with SMTP id d9443c01a7336-22e328a2987mr12958275ad.8.1746487448131;
        Mon, 05 May 2025 16:24:08 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:07 -0700 (PDT)
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
Subject: [PATCH v6 40/50] target/arm/machine: compile file once (system)
Date: Mon,  5 May 2025 16:20:05 -0700
Message-ID: <20250505232015.130990-41-pierrick.bouvier@linaro.org>
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
index bb1c09676d5..b404fa54863 100644
--- a/target/arm/meson.build
+++ b/target/arm/meson.build
@@ -13,7 +13,6 @@ arm_system_ss = ss.source_set()
 arm_common_system_ss = ss.source_set()
 arm_system_ss.add(files(
   'arm-qmp-cmds.c',
-  'machine.c',
 ))
 arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
 arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
@@ -39,6 +38,7 @@ arm_common_system_ss.add(files(
   'cortex-regs.c',
   'debug_helper.c',
   'helper.c',
+  'machine.c',
   'ptw.c',
   'vfp_fpscr.c',
 ))
-- 
2.47.2


