Return-Path: <kvm+bounces-29361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F159AA08D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D215283A18
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E29419C559;
	Tue, 22 Oct 2024 10:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dWlC8Otx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEA6198838
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594581; cv=none; b=pPoCdjcPCr/uZNFrTpGiSM1GUt8Lt0GEfjoXWFEo5GbFqqtt1y9EuhNXGOroeeyVazfkx/fctvSxq55gNtEC+mdbfn8C61PLszfNdcAkGwgqd9YjDvvku8XFjx5vyKwrY6R+2Qnqdxw0Gsz1q6Q4RXUo+mN3RJ7hBsVcN9iWjxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594581; c=relaxed/simple;
	bh=dycqCm1NPayXEmQsWH/9aZ0ifAR2NBSL9Ke2mXMrvic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PR5mZyyePEVGv2ZMkcZaRAHoR7RSsncffMBSByaOl618qUkQjxcFUPRvvsYvb01DEijzBLcZyGq5pIYew5ScMh/390CTRZX6erMr0n6jrCDL85JuWE+Vct06DA1y7kmkkAKHW9eyrZPsteB+y+Z9zHnZwDHesy2Mjz/um+UzRD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dWlC8Otx; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53b13ea6b78so964003e87.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594577; x=1730199377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9/+YXB0yFn3lOXE+wDfnOMUk7oakkE6QbrJ6dxZQ+4=;
        b=dWlC8OtxoLze6ZOa5Wz+GP73CVZah6sLFeEV5ijCAEbcYr5YWUvG6N1dmplG/fQJob
         bdbr22+NIAZ3VFFJ0ln2ZTHbfhFwf5o0WiD+1WWGKEnsm+Bf2opFKIEF3mKqlR9l4HhY
         5DI54wqMUJEsckvBndPwGYAbudrwWH3jpudynGG/cy5tzzrFfB2qbBJpY+BDANTsdYDw
         DYt5WUUu4MoRBy1MOrblrVupsp31GadoykW1yfTWpFKoju+Gu29uT1ykIoZnr3sCJzKh
         FhcmcK+M9gj/NWo/CX6mkcyBTTHkvdm8cmQUYUQebdWujdCAei6gekAtHzKlxPm2mChR
         YCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594577; x=1730199377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9/+YXB0yFn3lOXE+wDfnOMUk7oakkE6QbrJ6dxZQ+4=;
        b=UX6w46OMMYBIgVI6iZ20huDVDaKiO0lFIWLGKAICYjTEFgE5X6I8cuPz8Ev/2+/cya
         marP/HvEqjLhE+/9kDjRaEInzrj/kDBcCHOJZGc0RJX1rH6lATaJh0tHslTBHvPl8JST
         GG7yIzZIJgrr0Ctpq7IfzZ32f/xJOOSLLQIVjZ/dY24upRSXecYBaCkuAA4q5+w0ZhDM
         iznItWcKYCi/V6FLM4i7wCUFnFZxrXvHuR/mGaxiomrpQpv2BnhDRFRD3pcbTeRArsdQ
         1hexZQZXVG8sdncXyJH9KSwGGtbibsnzGZFIdt1VVM7f1O6rkUEI57PmuLDiWjhLaWhW
         O6yQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9ILiINj8wtGx1h+LBdTo3Zf8AebNePDrFPVX6urnfbBOJrqRm7h0QeEvosGVb8TMOPJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHyyKJYoboKoJvv/x6nBVgmZFPo3iz7w+7ThCnWp3A3lV9dom6
	dYVJCY/9/CjnpsVMRJtQm54/2EQf2F96IX70atiQth0Zawqy6JOZzRgcTagQIds=
X-Google-Smtp-Source: AGHT+IGyaTZRzVDmFkdPhfv0rvAvIdjH0I+E59F1p2dZtHMO7E+32HML2OhzkPGNPbWtrxG3At+wRA==
X-Received: by 2002:a05:6512:2388:b0:539:9767:903d with SMTP id 2adb3069b0e04-53a154eb91emr9004463e87.60.1729594577248;
        Tue, 22 Oct 2024 03:56:17 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d62e4sm321153666b.7.2024.10.22.03.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:15 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 0741C5F913;
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
Subject: [PATCH v2 04/20] meson: hide tsan related warnings
Date: Tue, 22 Oct 2024 11:55:58 +0100
Message-Id: <20241022105614.839199-5-alex.bennee@linaro.org>
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

From: Pierrick Bouvier <pierrick.bouvier@linaro.org>

When building with gcc-12 -fsanitize=thread, gcc reports some
constructions not supported with tsan.
Found on debian stable.

qemu/include/qemu/atomic.h:36:52: error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’ [-Werror=tsan]
   36 | #define smp_mb()                     ({ barrier(); __atomic_thread_fence(__ATOMIC_SEQ_CST); })
      |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20240910174013.1433331-2-pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 meson.build | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index d26690ce20..bdd67a2d6d 100644
--- a/meson.build
+++ b/meson.build
@@ -538,7 +538,15 @@ if get_option('tsan')
                          prefix: '#include <sanitizer/tsan_interface.h>')
     error('Cannot enable TSAN due to missing fiber annotation interface')
   endif
-  qemu_cflags = ['-fsanitize=thread'] + qemu_cflags
+  tsan_warn_suppress = []
+  # gcc (>=11) will report constructions not supported by tsan:
+  # "error: ‘atomic_thread_fence’ is not supported with ‘-fsanitize=thread’"
+  # https://gcc.gnu.org/gcc-11/changes.html
+  # However, clang does not support this warning and this triggers an error.
+  if cc.has_argument('-Wno-tsan')
+    tsan_warn_suppress = ['-Wno-tsan']
+  endif
+  qemu_cflags = ['-fsanitize=thread'] + tsan_warn_suppress + qemu_cflags
   qemu_ldflags = ['-fsanitize=thread'] + qemu_ldflags
 endif
 
-- 
2.39.5


