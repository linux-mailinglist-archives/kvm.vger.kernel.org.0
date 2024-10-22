Return-Path: <kvm+bounces-29370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F22FE9AA09B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A96B3283A33
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE7519D09F;
	Tue, 22 Oct 2024 10:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dNmFWFyh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E932F19C547
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594593; cv=none; b=rOg4yvb/vbqhXbPOZFqkc4BQUhxFNI6NMxp4etcSaGx09Ng6JlFP6fS2tLbAlOXh8vmGyZaEu6PxMGrwKlFEVIIcItiFebe9w/UsFYr+94EfQ3KNDC3c0PqkpjEdKfUGsymIn/987u1yzz03xB51e6Iw3w1IOuHkgyhumdAK1RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594593; c=relaxed/simple;
	bh=F1IaLKRSbm9Uapi2UOS+fME09MgEwbeqN+Y21eQizjo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kcuHCJTkL6Vi9spTUAoSFUKRUFQjhW/hFd2qd+oPhJ7ISiDssoQ2LGgWf5ZySIjRpUgFOAkjt6IRWMZKnkh897MVcDh56LX1q1AACg9hG3YZ4Yhzj/x+TVNo3kKUwI+XQdEQXFVSr9VlM8NzdIxlNPH/n7JKS26BJyayyigFBOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dNmFWFyh; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c40aea5c40so1438931a12.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594590; x=1730199390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nuVL16OURPo6SfQxD2PzScmfjsPxu4HizBAVk8u7e/E=;
        b=dNmFWFyhPLs4vQfw1em4h4iTSPWVFo0nOvId2oeCaI9WIDqU5TuWJaQirhDYCn4fB+
         dZW03RnCCgO87173O3HMEOuc/s7pPWe/9xD1xt6Iq2qSSbrriV/pu3fLYFe2SoWHhF4C
         EDA5io6VwGcyN/WeP1JbaXV/n5mJpaMz0aiNdoLcK8MRMi7pIVwYSMTf95lpGdG0VLck
         kuScnOxpHsWq1S5BzcUpX/m1sIdLjrlNtg2eU+glzYK3LbcUJrOtcKm5NV5y+2II9xcd
         gudCGgic9irWC+i9fGEjx+PB26wxsW19CnoT54TeojC3eBfNWfxkYGpSTKcsa6ls1EbH
         OxQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594590; x=1730199390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nuVL16OURPo6SfQxD2PzScmfjsPxu4HizBAVk8u7e/E=;
        b=aFlTyFrT03LNj9XftjEnydvGcwjkXHs4ktwf3abg+kLfOOIc+LaOYzHvF/Fuhgcue+
         wHltZw+e+mJ2T5f1nQPd3Wdd/l++sNMwMfKclXboW88bBGMNXdz73qGikRQo59CpsvSD
         rPCV+ueg1lG7Hp+8uHAypB9UAEjpy6ANPyy9VUic9dTznfeo1u/noc9e1xSAYG5N2IWM
         8ChG2zBPsvUN1MG2BwjIwQjmfuoq0dp4E8umRZrRousoaDAM3l43z2ajGq8BpYaS+oRo
         uZvRwPrHe0ZXDKev8Ak2aiCLbOtoR2MXYs9pPU3dZiGzumv0luvSvoF0XrqDvxbV5Wo/
         Ly4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUC9vGaz8edtDk43zmq1g9yZTdZ/Qn+PhNhLi3JgyORM6CIuoPocuQrne9qByPNjgIzUgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqtpRa44io0BJ/Z0TWDL3sDpdNlZNwKuDmyFH8m3J4UnXwq3pY
	/jP90B8N/2XlaNp2V+UdFGiywHYQQs66KM5OG3tdk1mzi+5j4SxdEkz4lT6K/PE=
X-Google-Smtp-Source: AGHT+IHwi1+vxmbQ3YLA9r6WePtD03FZyJBvumSeivnyntfSu8jv5XX9sGc6cj7ZvugURHt1idsIcQ==
X-Received: by 2002:a05:6402:35c2:b0:5c9:3070:701e with SMTP id 4fb4d7f45d1cf-5cb794670eemr2833546a12.9.1729594589755;
        Tue, 22 Oct 2024 03:56:29 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c7255esm3123937a12.80.2024.10.22.03.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:28 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id ADE0A5FABE;
	Tue, 22 Oct 2024 11:56:15 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	devel@lists.libvirt.org,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 12/20] config/targets: update aarch64_be-linux-user gdb XML list
Date: Tue, 22 Oct 2024 11:56:06 +0100
Message-Id: <20241022105614.839199-13-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241022105614.839199-1-alex.bennee@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Attempting to run the binary asserts when it can't find the XML entry.
We can fix it so we don't although I suspect other stuff is broken.

Fixes: https://gitlab.com/qemu-project/qemu/-/issues/2580
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 configs/targets/aarch64_be-linux-user.mak | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configs/targets/aarch64_be-linux-user.mak b/configs/targets/aarch64_be-linux-user.mak
index 778d22b2a9..dcef597a80 100644
--- a/configs/targets/aarch64_be-linux-user.mak
+++ b/configs/targets/aarch64_be-linux-user.mak
@@ -1,7 +1,7 @@
 TARGET_ARCH=aarch64
 TARGET_BASE_ARCH=arm
 TARGET_BIG_ENDIAN=y
-TARGET_XML_FILES= gdb-xml/aarch64-core.xml gdb-xml/aarch64-fpu.xml gdb-xml/aarch64-pauth.xml
+TARGET_XML_FILES= gdb-xml/aarch64-core.xml gdb-xml/aarch64-fpu.xml gdb-xml/aarch64-pauth.xml gdb-xml/aarch64-mte.xml
 TARGET_HAS_BFLT=y
 CONFIG_SEMIHOSTING=y
 CONFIG_ARM_COMPATIBLE_SEMIHOSTING=y
-- 
2.39.5


