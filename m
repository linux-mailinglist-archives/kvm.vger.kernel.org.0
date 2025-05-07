Return-Path: <kvm+bounces-45778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9419CAAEF65
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A21A050372E
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A99290D9B;
	Wed,  7 May 2025 23:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BY/WAw+1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEFB28DF43
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661376; cv=none; b=ALRPTPa6vwanCWxaf9F/fxzKnxj/0AJhObgqWyGkX1eFGnhD/6JMufxEmzIEwEuSi48GPOT5Sgesay0j3OiTXUh3XpUKJeSjYyCvnAMqKQgpA+YlvxidFf3Uwtk01xDVSvveUEy9oyX9iIKQvCO4tCO0t1aAGbZfsxTm64C10+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661376; c=relaxed/simple;
	bh=AEdec6YxwqEM2SMva6W9gXoK89VbojQSf/TWlriKM5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0iY2foHQ/0DOg9w3Sr2fP1p8qLEAGxEf42OpqalViX+9/v2NoeRd2tQ3Qou1GJVzU8y+H1T5jUjFSvF6Gk0qyaA70hCrYCyRxiK4/FSBfdfM8FMc0K7rzbc9IkIcVsL+LzYmTSiJsOEjV2OIRoAP8lrH3IvIDDReQpjM7GCRsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BY/WAw+1; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-af6a315b491so290501a12.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661374; x=1747266174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=BY/WAw+10DMs4ZV2VF75cFfTlaQwu8RAUDRpn4X6tHC+Mxvnglp2Bky2SLc/mZtCSk
         M8EFhs1ZC7VoQF6zOfRbkWiVw2lmpepMiGv7xDUCmDJTLOe8EBba+dTYti3bD/CvxBOJ
         AGaB+2Kvn1org1dq9KNBEx2XYM2Xk8ooFWmjj8tL8Qe2TZQYckoIt4V8njkOLbv6NIei
         FIBJPBs29Fv0Qrm6h17RUMypp7Hlrp0ZJJiNtCRZb2PYUvW8ubqnEk7UwLhrt9Xh6V67
         xYHsw2kmmkKmZdkALY8if9flWyQVAcXa0GnPRrGT03Dko+scGX3kn+NH1SJpcXL9K9y0
         VIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661374; x=1747266174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Emf7r2NlJCGBegzvSaP4+YNHnVcvC5KK1KGZi+oKRes=;
        b=b0ex1zDQoDECeW0M/eO9Z9Mph/6+Taemgh+UP62jGUnTKUoYsNetTvI+ZK1PlLajIn
         Q5rMntHNQEH6thZJItWhD3zV0MVroGlAlLw0T5iHuwLPB6p+eUaPnlQPRyaGOicV34Id
         Ln8UHBB6OfBVdEcRepjFd/TTf97bUzNwsWVMeoxh+W2cOiofk+SgmRO6K8rrCTX1IJiM
         SaiUg/7F4tks+boYfunf99B5unp49uYGvV0Ntv4Ywzgx4exBcWIYE9Yc4oPPL+QqDYrG
         jfWmGsF6QsG+m2TC0cBWe8SYrRyCZdjDKT2SEN+PsDj+TFZd/8bn6Ny/SfJKoKdAbWpe
         dnTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVspBs4fMt7fd1wsVMnpn9GZtL5JUV8arVSKgK9hEC8DBkulz5W6Ww8LJfVYY/7jtzgPVA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoCdM1lJ8Cp50++YHxx3fAimBtN3TOqjrDdZglZGYBeiU7Xmi2
	zml+bXpOcIHJarbZt0LQLoyt1D46fQw9f9RzWYZa+oA2kJmsnBMQdpDntVq8KqY=
X-Gm-Gg: ASbGncv98bejDnS+KJmkKYJcurWX7r9ruBLt636LQpBvN23pAej94/vOYG2f1JJvxK8
	RQyi6G3vamp4icBoLtIcPnx/49StDsQIwvLTEeGIRHco8JgZW1A2DO6p77Fox1RkTNDMqzfejvx
	7EHTol47XkCSW1/3kdKbHbjufPC3TbYtmZcX+TAUTcQRpDg4v7wEA9UspwEU3uwjILusEXle8yN
	TNLHbeF+GCTcgUzcPEfsHUX0OGPihjDmLUAD0SjcKN5IwlGoPw29NG4bfkBtHcf73f7jLFS9Y24
	MQTYl4/Dj7ixlNCNppOeZSHlhkygoo7j++RH0qRa
X-Google-Smtp-Source: AGHT+IE1rBPDLrD6YLcWU3G7gZr3FdqQdmTaG8RZa7lQY5J0VPLlZx24DjvL1QOATkDhsEsdcxhtug==
X-Received: by 2002:a17:90b:278e:b0:30a:2173:9f0b with SMTP id 98e67ed59e1d1-30aac290fe1mr8070966a91.28.1746661373761;
        Wed, 07 May 2025 16:42:53 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:53 -0700 (PDT)
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
Subject: [PATCH v7 12/49] target/arm/cpu32-stubs.c: compile file twice (user, system)
Date: Wed,  7 May 2025 16:42:03 -0700
Message-ID: <20250507234241.957746-13-pierrick.bouvier@linaro.org>
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


