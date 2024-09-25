Return-Path: <kvm+bounces-27480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E362986561
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4411628913A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A464E13C8F4;
	Wed, 25 Sep 2024 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yf5y4BUJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDFE13A86A
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 17:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727284313; cv=none; b=QKv3YW7tOU1iB9dJekzWJ69sibWwGHz9Vcz/6+vY63JXfL1+r+fP+19AftuyP+mFKJgRXkcWTLu23WNqSFymk6Ydn2nFCkLCBIv0IY29qOfAtc/PRVWKhPPcfHssgKsB+96ZXoAZeF6qcf3zc5ca6HEBrDj1sOxuK9WJIW+A2Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727284313; c=relaxed/simple;
	bh=Fy+nXGVNyw9VouRuwhWL6Rfjvq8Z32bsxn56JCTmNOw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1HOjVLhtsqIEoIpbIeypmlEjRrfOW6GxpPvGhJYzkVf/AwuEkz2v4lCd6A6bQwRbo5jgtuSTy3EwHJZIlfEoj9F3CXEwRfILM15uU+dk1FNWmrpiRmg7U4ZJ5KVDZR8cBH3o3yxkTpJwdbrd1gXLZ26UrpjAQc1tbMWpGtTcT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Yf5y4BUJ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-42e748f78d6so333855e9.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727284310; x=1727889110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nfK3IifqQwqKch4WY/r8cAsLiv59o8B10mtnbYAB2U8=;
        b=Yf5y4BUJe+b44yOvKBv7RgCCmmtjZWq5qW4AyWk7DIkPxLUIABoQjiLoKJJmCNx1a3
         MtVShKr+qqD4Mz91ZLaMMSakZlc2JdYYuUMk24tuaMYe3AozmPKQElHVoWKatfLd7hOY
         6jqhY7xcD7rgOS1vuCaClPKJhUgCzo8S7oAdv17R3XaZFI7IjNfzijzZjGbh/qFFbB1g
         3l3r6WlqbJulbXMnl8fx0Z6VJrxh8I+HkA7Fe38X4LbyF2InrKyhLUCJZIndISALEbnk
         Mxxs1BFmC4swbKqVanHRdmbCURdppwKpLKiz34qNhF0dngZvpHvoXre/tdQZ23fT2Sto
         TAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727284310; x=1727889110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nfK3IifqQwqKch4WY/r8cAsLiv59o8B10mtnbYAB2U8=;
        b=j3o46jZ+HHzO43pJXcv20Ecr56te4x2YoTC8HU08AK7giXGQmF7zT85Z8NHQjvYDkd
         BJYKhkKEG4K4A6KY66bwJ4aM9ApTNmqjuw+TX8AnYLZH7OIvi1ppnVSqvzw9mf6QokiT
         /j81aWte/RpBJCt9Q1DJpCfFpmSZ51nO5zX2RjtBEX7FxeNg0knlW5IRwIqRKPGgKztc
         iKZftOqdkcqm1eMJ50DAuIMyQ0AzORLEyIVn23YMRVNkBdWjWvMIHDsQXld2wmHHU1Jy
         695Ou91w1wao6iOzCTBECakkzVa+1xCOVK3IVYthmAtZKfDiWBn4aIG/nsHswAadslse
         1g/g==
X-Forwarded-Encrypted: i=1; AJvYcCXj1w2sQmHief/YtVGU0Nq20CrgxPgH8uBve3rDxNMo2SPaj7SgLjQ3trLJZDTJLrAJJYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRYgS1r7StypAlCxjk8uNnwySwsnWWwc2WKYhkjvSpYdOdqeJE
	tdziLB81gVTr9PAxpIqg/ys++3aMcRo9IZgz8+znSDRiq36k5txaIg0v1z7D4UA=
X-Google-Smtp-Source: AGHT+IGD3jF88KfAngOylDc8CVhYjnNX1NcQOwwW95cwuwuTfBIj06W2PgowxTm83aXeaqFntp0hUQ==
X-Received: by 2002:a05:600c:45ce:b0:42b:af1c:66e with SMTP id 5b1f17b1804b1-42e9610c1c6mr23225565e9.9.1727284310137;
        Wed, 25 Sep 2024 10:11:50 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e969feb45sm23955035e9.20.2024.09.25.10.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 10:11:45 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 345F15FA8E;
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
Subject: [PATCH 09/10] config/targets: update aarch64_be-linux-user gdb XML list
Date: Wed, 25 Sep 2024 18:11:39 +0100
Message-Id: <20240925171140.1307033-10-alex.bennee@linaro.org>
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

Attempting to run the binary asserts when it can't find the XML entry.
We can fix it so we don't although I suspect other stuff is broken.

Fixes: https://gitlab.com/qemu-project/qemu/-/issues/2580
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 configs/targets/aarch64_be-linux-user.mak | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configs/targets/aarch64_be-linux-user.mak b/configs/targets/aarch64_be-linux-user.mak
index acb5620cdb..14623ac076 100644
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


