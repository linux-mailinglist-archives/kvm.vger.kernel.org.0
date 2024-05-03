Return-Path: <kvm+bounces-16480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3AA18BA6AC
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 07:36:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63FF41F22A94
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 05:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE776139CE0;
	Fri,  3 May 2024 05:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ARpYEVIX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D99139586
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 05:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714714583; cv=none; b=iArqCKrSjIQmJgo6ukTBsqOnliIoAY/niet4PzaW7xTH4dhcEn9RykgJ1hcq2BuasrPIvWeZ52QD3IInRijv4OnqXN4ngB2oxXlOqDMhfGE4hyJQKwgyEoK2EgYQYbZLlkTWcd9zT62V6kVVn4XX1obsgTKW/Rij6TXeQ2K/lqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714714583; c=relaxed/simple;
	bh=9woJKz561k3BmIJeSyzSgAIZSfow6SyCQwn7RrH5cmo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CgGqKDgN6kj67quWUsNLKB05ScVYPwCllbPm4M1FzrVeH9upHmpalaKxtv7ucfIy8/yUhdaRk8ufbTgbIxxtb3mtyHy5JdECzNdunnTkYF6ZmK8njT01/SfNRj5qxyi8qF3ELmmBFbXW4OJ4vZw8W6FBHaIoxr/lCpGWzRvdQtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ARpYEVIX; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5aa28cde736so5502226eaf.1
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 22:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714714581; x=1715319381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ksQigzmu/mhdxtYztX6n94p+b8D5dLurSF5k4y5qz+8=;
        b=ARpYEVIXuMDntoLeKvTBHHcXPfg2v5Tg6Z0K05pX1CppHg50OLHYhffNf3h1fYcohP
         o/nbCtIIJNtEBCO0wIZZ/ZGq6YklQKiKo64+w3WQ24gwguxLujT2CSi1xvt9s5khUiMC
         heOK322d/wCyyxhV+2O7osjFQUotQxvtmyWpDEQHD2f2gQgsKudHp3f8I/QfFp6g2cZP
         lsfoxSFE+8wbl3KblcOjfNA3OzWzk/FxVeRfbEdijP6SYL+pmvjL9OmN61A0d5Zkf1Yu
         SwOnueVJ/9dkfoKt26dUg2/ySsOuoN5/lZksdCMGRYPYT199Q3trJCOYsmfnOZd2DVux
         4snA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714714581; x=1715319381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksQigzmu/mhdxtYztX6n94p+b8D5dLurSF5k4y5qz+8=;
        b=Yv5DHu37+fAiYAoYwzCfpt53j69FkSkr3iYSloVdJ1vABNGs/273DmX3Au71kDDODa
         hB4GcX1mahKThQgzr9Lo2Kw5biOjTBGJkE54HDPQovt+mm2LYdBMMDnSuL3NmGGe+Nhz
         eAGeKDeTbqA4T1JphUXDsdTya8zcBfcqdwfHmiFCAjD5MsjzXnm1Z7s03lY8xpwBuY3D
         /62Ppcz6EInc9sbpIG+1AhQJhIqGvm/RWKC6hMOr2MApZUi1osnujZTJdACtOCLx+RSh
         aC9Zbt0Mw3qCSfEVYbc3j2m4k7ka2LJY7r/V7beOPfMB8lATtj+A9NzupOwEV3b/he/h
         kjBw==
X-Forwarded-Encrypted: i=1; AJvYcCUq6fLa+zFhnEscbobFH/vbWTHYkvcvfh5Dq7nlvnIPqBYC+S3xv9CwwE/peFTJtcbQbzkERjFWXgLrkpQf3SCocQTa
X-Gm-Message-State: AOJu0Yyn7i9OdFmwJPdqFB5XTSK6ZpCg29OJ6bN3+1r+4+A62dtrEtq4
	90umvxUxATaSLb2lfRksJM4G0dinP3W1oVe9lllJMGnsHB+RUbFbGvSGxIyf
X-Google-Smtp-Source: AGHT+IH23T1zlgu8fIWHhSwPE647lTxKadI5h3o/PXq5T5k2VfPhiZNAHqK4UJWt0D89jXhEMzEn2Q==
X-Received: by 2002:a05:6358:702:b0:186:5c1:1dd1 with SMTP id e2-20020a056358070200b0018605c11dd1mr1914326rwj.19.1714714580753;
        Thu, 02 May 2024 22:36:20 -0700 (PDT)
Received: from wheely.local0.net ([1.146.23.181])
        by smtp.gmail.com with ESMTPSA id g1-20020a63dd41000000b00606dd49d3b8sm2255283pgj.57.2024.05.02.22.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 22:36:20 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] Fix check-kerneldoc for out of tree builds
Date: Fri,  3 May 2024 15:36:11 +1000
Message-ID: <20240503053612.970770-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Search the source path rather than cwd.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
I leave ctags and cscope targets not working, since I don't use those
tools and so don't have a test at hand. Being dev tools maybe(?) they
would only get used in the source directory anyway, whereas check
targets are useful for CI, etc.

It should be trivial to fix them up if we want though.

Thanks,
Nick
---

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b0f7ad08b..5b7998b79 100644
--- a/Makefile
+++ b/Makefile
@@ -150,4 +150,4 @@ tags:
 	ctags -R
 
 check-kerneldoc:
-	find . -name '*.[ch]' -exec scripts/kernel-doc -none {} +
+	find $(SRCDIR) -name '*.[ch]' -exec scripts/kernel-doc -none {} +
-- 
2.43.0


