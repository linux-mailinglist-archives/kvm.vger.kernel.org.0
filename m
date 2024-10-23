Return-Path: <kvm+bounces-29490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A36BA9AC913
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65632283F61
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B8E1AB51D;
	Wed, 23 Oct 2024 11:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i97Pd1zU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79591B4F2E
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683261; cv=none; b=rZ1kwpux5nWONCSdNjzTDr6MMTmjUuNRzSPlXcMSrHZ5YBcZsIatQog3U3dit89P0uxQXK+s/G2pb7hpoG5WNrL/a7eUNwmUzjMW59Lq9guUZPL10mqTFkMfVJ8dR7HGw3X7HfmX6f8edTFUrFtw/79WA2m3cVI8DfKqCTAkMjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683261; c=relaxed/simple;
	bh=XjeuRo7TzAGu1R/uBx/TgkWRcWrKW8ll6PR9wdm/+Pc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1vK67l0AFnlgiTCOVdEuHWtNhYIc0zyGdLzzZ03MhCQ30VMPs5Tk8/kVnFBFshB31zDr7r+9KRGO4RjvNlSEXVS0N96LEGY2TCmRCXboPDIp1aczVpgM+yTkvVb5peRqndLPIf1Heq+VSMZx+dyKCSci3ICzPI1bCOsElAXp48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i97Pd1zU; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a86e9db75b9so881410766b.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683258; x=1730288058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VE6CRJWS0PrV56e8l4nrxhdjzzIjf9914lqwk9uoLck=;
        b=i97Pd1zUJYOCIYmzC+xt8f7/o1T5/rN522ZW3hBuMwUSopz2zbQW53IWix34FvcixL
         5+yF57CM7CoK6BOS01n9O1nkG9QHeWfDxdyXv7yQ2yO9Eedz5gCddwqQzQPkTENlZ5p4
         xjAfhMJ1DHxiUovm35myGt62HVbxBtD3pmiScx0pBtpo9MO27cZzlEDmxoMzh8UZ5BPl
         Mq2+0GeVorQU2XT9OI/Kf+36tWmKVWAQXwApcyzvACa4jX/1Mz3e+ww498r2w7SdjtBI
         I+SCYHNeze3bBTyA9GaajNif5848W5bxB7yNOSxy3gYfIUJI22ndzTNL2a+08XsgGNOq
         +7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683258; x=1730288058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VE6CRJWS0PrV56e8l4nrxhdjzzIjf9914lqwk9uoLck=;
        b=B0pMrRH3h+1E8gwYhr7AUxWsCT8w/1o7Gd+qkEasFje2AIjXRF+dakoQxhkLQJL+Uz
         jUCjCLvwdJmcn3JIeGPWezUclH0x/b4F2WP/PfwZJNx3WLuVeO7+fK5jTZusWvDb2MaN
         hKwJ1KoW1rJaDgEli6YvGWaTvuf73KPNeGaeuaRumL8GR9MkJInI/rsTos4r9IU3nk9S
         KIXy2defdkqq9pXP+6U102vr2vmkP7vd6wH9LziI7UBgo+wHvB4yF3FbNs3T03rIsvcG
         xTXOqq4Zchzg/ult2eTpjN6yCoRuDRGKMLQcxR8cxME1S5/5PWcCFPMcmswgCsre9JpI
         C7zw==
X-Forwarded-Encrypted: i=1; AJvYcCV/jMdOI7ZzwhMt+V/ry/87PduI3rjmskSpJwrbd0+NrsYklJsd64Nj6k0Seiut5JsSiDk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxfm/sjPgRgdDSFTKuBAfWULIXehDO/2un1aZWGdnMkz6AOFjc
	jc+iokm7NPSOZOwxaGIHVca5C8t8TfVfalr3ngKtN2qNGNAMVkbbg9eGyEBs3Zg=
X-Google-Smtp-Source: AGHT+IHrhhTz3PwOAFp8f6BmbbVAGO5Fci9mgs+aD3Tdtawg2G5g++Jm9xg3Lf7GfxT1VEbPz5On3w==
X-Received: by 2002:a17:907:3e27:b0:a99:e82a:87ee with SMTP id a640c23a62f3a-a9abf9660a9mr167046366b.57.1729683257920;
        Wed, 23 Oct 2024 04:34:17 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91306fc0sm464586866b.91.2024.10.23.04.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:16 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1BD045FA0B;
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
Subject: [PATCH v3 12/18] config/targets: update aarch64_be-linux-user gdb XML list
Date: Wed, 23 Oct 2024 12:34:00 +0100
Message-Id: <20241023113406.1284676-13-alex.bennee@linaro.org>
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

Attempting to run the binary asserts when it can't find the XML entry.
We can fix it so we don't although I suspect other stuff is broken.

Fixes: https://gitlab.com/qemu-project/qemu/-/issues/2580
Message-Id: <20241022105614.839199-13-alex.bennee@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
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


