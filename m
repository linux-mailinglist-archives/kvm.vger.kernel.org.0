Return-Path: <kvm+bounces-29492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD719AC915
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2C5A28434C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0821B4F2E;
	Wed, 23 Oct 2024 11:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GWiRAY+E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810141B6556
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683262; cv=none; b=Qz2JrU53JL+bOMB5qo9L03g98rVbxoNh1DOTzU1RtCr9m1EWlAA+TA7cL9FDbAjUKmYq3rBpvojxuWEfNtZ86sCz6RMJJUWB+0q0iUeFnDSW66/X/8n/j/d9TptXUCpWPOGvWRjGIzUlqvXx1pUMDI3pXJZQWyBMo50K1XpuGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683262; c=relaxed/simple;
	bh=mnWwKbzWIkxs1PxarxnievH5Ee6EkI4EXpt7QoDMfW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VE9O+ZjGz07fbenkq7dG1iRIVaFslEwtNbklBNHZTbf3+8Bc5XsAuR0wR7t3hYCKJWbreomnGJRT3AUwfVe7dY/kVePn82xu6CNqwB2W6bMcTrVXC6GNmmTBSDPxxUMaA8E4lhAbDYNv45Hp7a9BNlo8jkPcvo3vlvVHtroretI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GWiRAY+E; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-539e6c754bdso6443296e87.2
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683258; x=1730288058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qX1H0ILZzPVxOYwNvN6Q27i9glRVOd//mtyRaXauYw=;
        b=GWiRAY+EOPnc1slFxG5u540GvmbLApzb64OXBmuST9nBz67LEOl8azKGvlhvEJZxVr
         I5j1F2QTxAS2gVHpU/FBlkasb5mzcaOU+4eYB1KbOAN27s2If6O8U1VOJxwmxpxMlcHl
         G2eAz3b01mpZd01ScPvoxqStSGm11K4UrPaD5Pgg5J3rdSP3mq6CditLQ+Pzol/GbxJ9
         zWrz171sTDm8jtlirqKcoZdwD9sYtIfvugNENkGHf8Rc+g6FPzwcVW/5VQCWlQcIuOtO
         yi+3lBv3Xdq7FASbR5DxRCYzRsBfsb0UBo+QbXA/t5HYNpJQJH0oK1n/V6ZdpNgkOAcv
         9uOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683258; x=1730288058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1qX1H0ILZzPVxOYwNvN6Q27i9glRVOd//mtyRaXauYw=;
        b=dtSsDaEGbdVlu6ZJZ9zolM7KkLs+Q8D2FaZU2bghlmA4WIjk/EhnHimOTo3BihbtMI
         +Pp+da66kB/usDteFPGt/duyx8bDGfBltFH8RJewfRaa2rpexmrrjpO683OwgtUImMmM
         ew826be7cYvYRUrQx1hzRufb2utfgOoXwvI1dI2Ga3EwDTbRofVwI2Qam4dvjyl4/SHJ
         NyoLxtZ/iIc5U/4zLt/40D1m7NvHvJCsQrcJPnbqI2avj8sDKHBigX8sBDyE03Pwc2kg
         LjFePEk1Ct9REPMR5ZPUmAgPMjWfmpgi6RHYb5T1KT0jQYPkGIBhXp65g52d7aPio3vL
         bbkw==
X-Forwarded-Encrypted: i=1; AJvYcCVQgFkIMP/DYLo4tsUOvVooq/9g1yPUTplsNYkHB+SAYGQ1TEZM7Qvd7N+sVZ5LhcFG+Hk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+yycj0FErcXMl2LQy61zxCueZ4F0qsyTFU56leEhD2Y8193+U
	5yOuTZBjbjUxXrcWIAhEKvovbXJfJO2VOR2uNAw8qzs0Ue7L2VAOeEpjiCZqSa4=
X-Google-Smtp-Source: AGHT+IGCC2NM7/OapfZX3EJCxpHGXNk03pm+wXvxRti6xI5ur+3RRTrTJkYiV0qwoYbB5Klb+BmBsg==
X-Received: by 2002:a05:6512:2243:b0:539:530e:9de5 with SMTP id 2adb3069b0e04-53b1a3a7ae9mr1018902e87.56.1729683257601;
        Wed, 23 Oct 2024 04:34:17 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912ee061sm464471066b.63.2024.10.23.04.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:16 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 061BA5F9EC;
	Wed, 23 Oct 2024 12:34:08 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	devel@lists.libvirt.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Beraldo Leal <bleal@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 11/18] MAINTAINERS: mention my gdbstub/next tree
Date: Wed, 23 Oct 2024 12:33:59 +0100
Message-Id: <20241023113406.1284676-12-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241023113406.1284676-1-alex.bennee@linaro.org>
References: <20241023113406.1284676-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make it easy for people to see what is already queued.

Message-Id: <20241022105614.839199-12-alex.bennee@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ef1678a1a8..7eea7b7954 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2984,6 +2984,7 @@ F: gdb-xml/
 F: tests/tcg/multiarch/gdbstub/*
 F: scripts/feature_to_c.py
 F: scripts/probe-gdb-support.py
+T: git https://gitlab.com/stsquad/qemu gdbstub/next
 
 Memory API
 M: Paolo Bonzini <pbonzini@redhat.com>
-- 
2.39.5


