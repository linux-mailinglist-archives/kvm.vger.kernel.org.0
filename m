Return-Path: <kvm+bounces-36774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A22A20BEC
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:22:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAF36162D90
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525861AA1C8;
	Tue, 28 Jan 2025 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c2sv6esd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9C01A83E8
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738074133; cv=none; b=Z+kUPGuaVuj49hRTYtmgY3CxdX0NBFy4uOpdqYzH+Fjdoc/VYxLZ5YA9mUj0W9V2Aki0uvPVs8eaXo426VsxpMb+wzvCqjO61UxCQ3xutiANps6Adxqvi3UldYuEGJV6CSMS+265UuQXKQuUcYIZeUcgDeCKbUQUEuB8j/pFY98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738074133; c=relaxed/simple;
	bh=e2tWFm+ltqlnBfMyVnEYkNHZ6l3M7cGECvJih3yAb5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+NyMPrhhgarbyWu+RKTJuiHpmjYromilNPlrSF75gdyb0Cexitg0WGXWg97tMHfAZuy9rtMDmJJ7RiKdyJdMph+zkwrxD9LXAXt7WsxYUpK3n7qHnDByomHIoyLRt1ZT+PECrJ7GgGFKyfmLHj+ankvNqHHT5Fiu5jeJZXu2+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c2sv6esd; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-438a3216fc2so58473825e9.1
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738074130; x=1738678930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cztkPvSxh9km+ESKvRBcfElc50oeVn4euS866OSUDwg=;
        b=c2sv6esdSvbTM7TuDqoCJBdwpU3Td+7cXi+PY/7mqsKX9sslHbAAqLe546IHyAAx+4
         jm0VzmABfb3/BqEllSTozovhuNLOm1ZVrDZSrryYDCPnUfaY0nuQbxEjHoKsk1pymTl8
         gkPTNWFhEnnpusKL00mt+Sd4OVhttKjYE3Gxjj3uCxAXSDOx0mETBGBGEulgLzUBkdsd
         SXB0zmdd29zyyhapGbn5k4qP3ouM+5hxOxw/IBRNih7Qa1UYHnSInARXrBkkohhwR7Uy
         jhDwva5FJgqQ7y+uCf+Jm2wJhxGmtsvhIO4d/dQE8cDf/co4whY2e9P65NkbaQnrhgOb
         1MWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738074130; x=1738678930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cztkPvSxh9km+ESKvRBcfElc50oeVn4euS866OSUDwg=;
        b=E+4swFY0rvtKopx8li7e5vdN31V2yAFshVOZ+0n9Xio75c+4CUQ2P15tUEIv4mhWwb
         EBu/q+FVzmFzj3Jsmx6vG1U4xadZAE919GHhM2cBCMUxvdWQnZC4ogmSlSt2/3+QC0Hj
         2qo7gyF4lfHhKAyoUUTih0mYKH9/Fpt/VqmlqBJcH6lmWCakg9NXgOvRJB7Xev41TsP7
         56zrNP4z9KA8M706sQvo8zoKS0u/N1zPCgOB2BMjdx9qeQYkhskPItQ3NbT80BpAUjvo
         IaUKt5Srg9OD9p7JYH7b6lhglDloh5ONjkkchNqp2hQuf/lMBr/3EcG3XZGpNwjrn0/B
         9vjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2F2Lqs3QrySAhw5FcZxHJgRKIXLsuzbE+SRaS1TXXirFsYi8s9b0royGLUoxmhsgSEh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZlm4aejJk1vEtqizPhcCPeTR4O2UpJCJQ9GWo1F42oF1blI9D
	jgU0oLdg6bCvMPIQ71+Mawx0sQiDURiWjRWMkuUv1b2frs8w0yyFGMgfnnaMHU8=
X-Gm-Gg: ASbGncvMb0Eo6DEXVRnBlIrIdM9XjJHXdvhgx9hnAOJi8T3j2wbmYxSV44Exu18ccSH
	luUq87BjC7UlPMV0fKG3MPndlZFREy9j/fOPkTBtrHN/hyxxCyVDYWx3XkB9KvTfZSFqMMwHUZk
	xGWyq0dUuWBMXkDJSMF4En40X3ychT1GLgQ0LSBGIKvIaw0bbOcJp9gBRWF5oqZ3/c7tZ4YCUbC
	qO9jaGka6TTxQ2sMmRu/IyMm6uPTZKMCEtmeH7ZF5jiOejJJyjANRUIkBg9qT7gbTxRnw3WhPwB
	cQ28Esh/fUJnam/D8QSX9GKvvLFyGlMApIj14AIK741JTJCavUL+pNIM85p6XC3MVA==
X-Google-Smtp-Source: AGHT+IHoy1cVhuk2i3/eWFOT57s+jua+XxxBspEQhqzWsAL+PWt7YkjOAw9jQh7HykZ8ESVDxkMIkQ==
X-Received: by 2002:a05:600c:4589:b0:436:f960:3428 with SMTP id 5b1f17b1804b1-4389144fbd4mr437166445e9.29.1738074130042;
        Tue, 28 Jan 2025 06:22:10 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd4fa57csm178828725e9.4.2025.01.28.06.22.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Jan 2025 06:22:09 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [RFC PATCH 3/9] cpus: Remove cpu from global queue after UNREALIZE completed
Date: Tue, 28 Jan 2025 15:21:46 +0100
Message-ID: <20250128142152.9889-4-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250128142152.9889-1-philmd@linaro.org>
References: <20250128142152.9889-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Previous commit removed the restriction on completing the full QDev
UNREALIZE step before removing vCPUs from global queue, it is now
safe to call cpu_list_remove() after accel_cpu_common_unrealize().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 cpu-target.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/cpu-target.c b/cpu-target.c
index 667688332c9..11592e2583f 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -172,12 +172,9 @@ void cpu_exec_unrealizefn(CPUState *cpu)
     }
 #endif
 
-    cpu_list_remove(cpu);
-    /*
-     * Now that the vCPU has been removed from the RCU list, we can call
-     * accel_cpu_common_unrealize, which may free fields using call_rcu.
-     */
     accel_cpu_common_unrealize(cpu);
+
+    cpu_list_remove(cpu);
 }
 
 /*
-- 
2.47.1


