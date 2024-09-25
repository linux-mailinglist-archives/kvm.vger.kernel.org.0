Return-Path: <kvm+bounces-27472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA55986559
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E8B41F24A0F
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FF58175F;
	Wed, 25 Sep 2024 17:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nXp2f0xD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176A9481CE
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284306; cv=none; b=s0cmUFOdaQgOaVhl1J52TvxDWHL8uSOebm7SY+t/yjAUKRylvVQ4GcXcIIAksTmrGhl/nycBgSi4kOxL1NEuzrYCCH0voEvyENdRRDaNj6PjY2fLXKpd68sScpAeKhW7kVJ/ZzVMeMr5Kujjn2yxCMOoCUlXmHeFXdTzEgcOHM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284306; c=relaxed/simple;
	bh=2Yb7oTCka3wIE2DMAQMTcMy4sVLQbC/DU3rjrp80aIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oc5Cxg0Tm1PzbvM8pu/AYavonMSxROfS8MZ2kF/kQ9gUGmhUSaNFq4YQ+kNT3nhZBrSYkXLlctD7gQS916DW2Tuh640qeSQbMs4y4zYK/r3WygeRFJginSp9VOABp8zwOIn73I3f2PNBEX5Zb7TOfS5HjwJgV9KyrR93YkXBY3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nXp2f0xD; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-378f90ad32dso31580f8f.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284303; x=1727889103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nULHsaLuBuujYUxGLl/yUjxpzYZCDveoFrPVw941m7Y=;
        b=nXp2f0xD944fyZcNiQDBnJia9hbSoKXVoO48xSZux5Zz4fZ5FWQhw6OoCJAfhlgc9o
         zkx8jb2YtbpxvI6Dlm0ISFtgf6cVkzxa/QxLGKT75btu3H+tgybylY28iIC2z5++gX4f
         T5ebxDZ50cwO2JLvyd7t+NnMIseGcETlEDNgbcxI0kN90gTsSSkAT4Gnzm7lAXR1JRNl
         k3tH+s91JvFCoImkBJIXVnV22T90CQELu5qcjiHOemFqv0PDDXj13lT2IlPCuIRSZbjf
         HlQcVLTzX7iIQu0KtAJixfw7n2WIFTktaBebgGcG3ew4FcVFyNSYlF4akkEnjybW0Yhw
         Wv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284303; x=1727889103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nULHsaLuBuujYUxGLl/yUjxpzYZCDveoFrPVw941m7Y=;
        b=O7dMnuAL5n6WBCwVSJ61ebkYO1lATz6RxSoHYx4WrL7W/wjAujXOA2R/YDmakzcqez
         JS7yO/sYpUt1jYo2lpCnBfx2LD3tTraY92TXAcYQpSIp8Ckc2eoLPr95hF1PDBOaLi4J
         YpOsrGCSMEh/MwUi3UOZiCoqCz7T+h0QnVIiOys0byW6TTPuqYt15flqRaxlufh5ino3
         elqq12LuKrNzv4LA1Uul0a7EDL9vf5Afl4PMYH1N7O0hENaVTkN0jeJwhgYGDdkE5amy
         s0J6CmiLlf4guh7gItQKbP12ehom6IlYmSL6m3vG4gaF8tcsSQupO5e83oKYddfNDtTr
         JWYg==
X-Forwarded-Encrypted: i=1; AJvYcCWW5/RDSdpH6W0RAq7tMA6+2fGAArXmciZvjxD7eTvucPLiopm72wjp/wVt4iHJKuTGpHo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjyXL//18po+qwb0PnqPVeuHrgFq4DLaEH55Hjoi5tVvXt7sku
	eBvci88kbpznC8Qb9fV97jLvveOjkrYdcRVfss4WP3pBxFF/QnvizGtnlIVaJZo=
X-Google-Smtp-Source: AGHT+IEORzqVBB16eZ00Qj5TJ8YpgmN6tE1vpCu+cktnO6IgKyCPHtWZVud/qUVLpXrUdIz4Dy+68Q==
X-Received: by 2002:adf:fa41:0:b0:368:4910:8f49 with SMTP id ffacd0b85a97d-37cc246b405mr2347263f8f.12.1727284303257;
        Wed, 25 Sep 2024 10:11:43 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cbc3187a4sm4466876f8f.90.2024.09.25.10.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:41 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B47BE5FA12;
	Wed, 25 Sep 2024 18:11:40 +0100 (BST)
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
Subject: [PATCH 04/10] MAINTAINERS: mention my testing/next tree
Date: Wed, 25 Sep 2024 18:11:34 +0100
Message-Id: <20240925171140.1307033-5-alex.bennee@linaro.org>
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

I put it under my name as there may be other maintainer testing trees
as well.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ffacd60f40..7ac2252303 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4114,6 +4114,7 @@ Build and test automation
 -------------------------
 Build and test automation, general continuous integration
 M: Alex Bennée <alex.bennee@linaro.org>
+T: git https://gitlab.com/stsquad/qemu testing/next
 M: Philippe Mathieu-Daudé <philmd@linaro.org>
 M: Thomas Huth <thuth@redhat.com>
 R: Wainer dos Santos Moschetta <wainersm@redhat.com>
-- 
2.39.5


