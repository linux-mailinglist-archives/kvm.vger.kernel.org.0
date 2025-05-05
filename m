Return-Path: <kvm+bounces-45509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC42BAAAFFF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D6824C4B3A
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2338306706;
	Mon,  5 May 2025 23:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z3WmApVp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAAC3B2F4F
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487252; cv=none; b=tt1E14KyPiK7FK4wH88O92Q4TQm3JoLWo0KN8Ee5wnIMSH1Bg6b1ICQNHSYp+McSp+i4+iTK14HGaNe9Ucg+pAq5tRwHLg0ElZxh0h8C8TPLwLwo3A3fvXJoBh/FAulvhA/PmGJnkKM61sR+Ysobad/JbpIX6XXOBJOCJ334gLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487252; c=relaxed/simple;
	bh=ENP2hN0JkLSGgU+MLNHwU2T/tGgXwB94KuX7uaX3DAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0jJ//43itW5REamN7dtS2GJdFBvsJh7HXPSUHAYF5+PDw5uP20+jXKRqiJhvI0SORbXCjXwXg4ITpoSNEBwDZvvxHTGEoDP0tQ09a8P8oJY2kCVzqKb3Z2JmTctv06NVtBohv+8JQinS9Hyqm3BS3YVHcY0yA9YkAZ1gezXTWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z3WmApVp; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-225477548e1so52739925ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487250; x=1747092050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=Z3WmApVp4mcIsFaYXewJmIu7IgsXKqtjplENDU3mnOit0exDngp3TboFPHhg7Yg9QV
         JRIAw7RTfmGIElhqcIeF0LDcHwjdWy7YJ+ci++X9LZQlCcbEO77pjDUztHmEcx1OAE6W
         7ACf1C2++iU7icUusMgljRfulyTEe3d+tBpcvweB1rC62rJEZVnfAaA4IbISPN+xkbG0
         V8ctNEiAGoVWSYxWyXKLpY/Z4uZ0kkvI9d/hcA8mr0ULHJRbUX7FzV4tx9xlYlO7/7dr
         MM+iak6leDlfOdEHu3b6/2Js6I723deGb5uzXAUZdZGWZzXSfiEJQw5SlVf8oIBjQD8o
         7C8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487250; x=1747092050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E27VnLHwdjjgu7+qzkSpdD6sP1u8J5fzfB0GITxze0s=;
        b=nSPD/EMuUVIVa75rHJI+iFB1Uy0kcewOyPQwsJujXP2+GsQTvWEqlxQQ6DYywYmMO1
         sTCKH4kfXqjIdTkett20v9GWmME4XTiQpcuJRBOwUayJAhWMlaxllcf84ZiIAgpRg+BY
         db38IVKFMRHoyZmi2f1NKHRkC9TdX4DykCNJKZdURXpXnoIdV1XFDiDM/lGvPzVYLetq
         fNLXA9Zx0T+gsuo56Cx2NUkNulJlzIORyEPEe3LGuxpsAnRKvMMSzxr/NrF5qvmXfy9z
         2XXLo6t60x94RM/Bvn88DsDR3RYhcTwcGWvo4Gg5VTcS0jw7hobVo0JHmOy+j3KaWFth
         0A1A==
X-Forwarded-Encrypted: i=1; AJvYcCXE4sPIymIAOhRrdqDE51MZHiyeUzOBXuutORSaDSj1HYIXYLVAQPFMXV1VuJr0MRhtyYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZxFtIJ0mv+bH2FZokleg7EDLEPM992c2i4OaW2atMcFbpv7cq
	6Q/VfmG1ErzPeg7A2jiJDUWbJmZlTr/9hN9jJjFVI5Ixgq88ROmn3usSKJ9jDrY=
X-Gm-Gg: ASbGncv4INMkTHZgTzR405UsWjVnL7Xmx8nZahdEZwXEbttrbgEjjZoTPUM6BYs3Xex
	LMDcnCLc1Drrv3NA8oa9PwrXtbMlrAV0y4RbKvNrgoNEtYY1dAPiB9isf8KDvI4owqtDMKHokeP
	EjrrrImFx+Eu03Al7fYyAXCVun7oPKNQZD/IxbXu7VL66Zv24f7gs4iO0zn2HyLB1S485Y2yzsq
	9l1ucZnTbavlZ0EH2c4whnnd9meQsBXs0HyE8zkdeQdDWoxGdKmlijGYK3F5EESs7FmmFrR28N7
	CbRfr4F9UQZ+JZnn29IckDH8qysLdnLqHI6e/AJF
X-Google-Smtp-Source: AGHT+IETv5cggtK7g8tYeqBJIFsslayFPnvoIslaVy/AYK+NCIa76R0mH5k9pEhCIh+PzFXX9HxutA==
X-Received: by 2002:a17:903:291:b0:223:2aab:462c with SMTP id d9443c01a7336-22e1e8e6848mr130031445ad.15.1746487249736;
        Mon, 05 May 2025 16:20:49 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:49 -0700 (PDT)
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
Subject: [PATCH v6 33/50] target/arm/ptw: compile file once (system)
Date: Mon,  5 May 2025 16:19:58 -0700
Message-ID: <20250505232015.130990-34-pierrick.bouvier@linaro.org>
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


