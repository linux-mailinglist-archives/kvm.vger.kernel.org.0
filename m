Return-Path: <kvm+bounces-27477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2808E98655E
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 585D21C24C04
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1693C13A863;
	Wed, 25 Sep 2024 17:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CU+Ciedv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E2885628
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284311; cv=none; b=AWkKWY1XTg6XZwjWXsSc+8heX+mE89LivwL9j3X4g7l4FUf/FZ7NiGSzDvDtIGFIL+5XNvXDZwWiu3o+VrgYb/ooCDkxvwpvypNwdeMOcaxeP9H1Sjc6UpCPAPxAUUF+WBCbgQdUn3Tl7spoKlL7EWCIS7NzP6eAc+cehSGF7ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284311; c=relaxed/simple;
	bh=lOeioTiHb1xpwW5Cln9C3vr+QU6UmszUoUpZcKnkq+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=abnFsgMZorJdBMZn5pDcrJZcAiNodkKlwyaL+1n1+Lmob+WvpoIn9XP02EXmDMLE4g+UInsL04OClpAl+qaiA6UXrnAX450mcXtqvtG4qCaFn3Ce2tYD7DuGKPL+ehj64HFxFFAJTopekkMIfRMhgI4vIGYJXQss3TkayER08RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CU+Ciedv; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42cb1e623d1so349245e9.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284308; x=1727889108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPetPS+iPOZ9YsbRPGkth2UTt050VfI/4VOs20g6hTI=;
        b=CU+Ciedvv+lsH5zaV5GhPVx2PMvID12wdv1UQpCKcBvDzIMrHic2Q9T60amYWCIJJm
         LE7w2eivTqcvUARoarfg2UW5l1LsKQb0AIS95ZYEAsd1v4r2+KhIzY5C1oz1uvo0OO2f
         St95hKta9fWasj3Clhf7Rjj9sEnO/V+iiIPLLPuEHrDbIrF3eZYemgpG5dQdOLpeLuje
         YUZ2TNxH4+RU6Ybnb4mjchW/4u50CZ+SbL5V2lzdpFA0pES2WZ60vyw/F4m9tEmnl/As
         ti2USiUPWa6hcdtXLCNzQW5K/AinAhoIMAIaM0pc8jLT2BR6Beffl168dNFfT8XGcitc
         XQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284308; x=1727889108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oPetPS+iPOZ9YsbRPGkth2UTt050VfI/4VOs20g6hTI=;
        b=RpyItbcFuit59Y3uUW2fZcvnEoXraAqYLXRSOTQJGXaokauUWxS/lxgKdHFUWrZ8ZN
         g8sraCHB9BErN2AwliFJV8AmMISksFyH4c2McuGbe53XnjjTTxNVVx4WPv+HZj6bVNXP
         kWWC48N3KvlCWm9HX72IO9PBairEiSzotFYTgNMgUjFlbTJAkyWYOwaiMjAljHDViPDt
         PFOwwhMZbZnZqfVS+gLmJAHFPnE9h9SWXxnfo/wrUzLXwtg/4F40PejwlNTa0d8XXsF8
         Fpq3ezXWmgIF6wG1UFUmRj4EOSeI7xc2Wpeo4edYV1ZMdDFr1CxH2MqrA2EnAAwTqWg+
         3LOA==
X-Forwarded-Encrypted: i=1; AJvYcCVN5Al4Ib0Np+NUckLYep6geXYZhicMT5+KZ1cq3vxxEyd06pHGG4K+7A0LpOol256LQ7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF9CCfWRSeKkET9PGrjAqiheEDXDAIVmWlccMZK/cPGIh0pFBy
	mkKvemNLpjVlc9kpSHr93iyB+ZKn61j2XdkvN7Cy5v6kRlCrrRVVxm5jWVkECeU=
X-Google-Smtp-Source: AGHT+IGBCTHIWfSfgWAoxWqUTo8+jlKpLyEBTIm6tcnrukMNtvBJLrfotsddLNAtN5yhINvOVzR10A==
X-Received: by 2002:a05:600c:1c05:b0:42c:b63e:fea6 with SMTP id 5b1f17b1804b1-42e961362e8mr25316905e9.22.1727284307691;
        Wed, 25 Sep 2024 10:11:47 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e90cd2d3dsm44179475e9.1.2024.09.25.10.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:44 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1C5475FA77;
	Wed, 25 Sep 2024 18:11:41 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	kvm@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	devel@lists.libvirt.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	Beraldo Leal <bleal@redhat.com>
Subject: [PATCH 08/10] MAINTAINERS: mention my gdbstub/next tree
Date: Wed, 25 Sep 2024 18:11:38 +0100
Message-Id: <20240925171140.1307033-9-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240925171140.1307033-1-alex.bennee@linaro.org>
References: <20240925171140.1307033-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Make it easy for people to see what is already queued.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7ac2252303..f34b8843e4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3028,6 +3028,7 @@ F: gdb-xml/
 F: tests/tcg/multiarch/gdbstub/*
 F: scripts/feature_to_c.py
 F: scripts/probe-gdb-support.py
+T: git https://gitlab.com/stsquad/qemu gdbstub/next
 
 Memory API
 M: Paolo Bonzini <pbonzini@redhat.com>
-- 
2.39.5


