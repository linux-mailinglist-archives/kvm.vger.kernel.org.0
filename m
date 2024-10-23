Return-Path: <kvm+bounces-29483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB6B9AC906
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FA281F21564
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9AA1ADFE2;
	Wed, 23 Oct 2024 11:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IYYHbcCF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF011ABEA0
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683254; cv=none; b=P4ab+L1vE4IVcoRinzt3/AxZQU7iv78fC9FWufg77pE+VJb00JECrvLaC0oUe5AOcKXH7dnmnkSzHFJIe5RixP8k1Tyb/kuedHMltLY1ffTMbY8HTUYFKz/YrySUc1m++ngFfW6YeP9GrKYbmRifFhAqD8G3JOYyq/POQBaMpdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683254; c=relaxed/simple;
	bh=dycqCm1NPayXEmQsWH/9aZ0ifAR2NBSL9Ke2mXMrvic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GzIny1DpoMZ568ntragsrDw+K/AtJD+uwmHwdDIn0/zPjkBLPG3k0CHuuOfGfmrZvcW2+DqaJDROlnsdpB+7KLt6T5k7uJPUVawdj+OU+/clcAkL/zsX36RfA54JKV4ZgfgBinr6o4urAhdxzLFFsqT8+w/PlHJthas9Ep4ypGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IYYHbcCF; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a9a0cee600aso830277466b.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683251; x=1730288051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9/+YXB0yFn3lOXE+wDfnOMUk7oakkE6QbrJ6dxZQ+4=;
        b=IYYHbcCFwhuW49RZAF89pNnyGucFgecMVsXm0JeeMGTg7VRgPArjV98CErJg7DGZT2
         6weDmPOwoGj5s1L0pu6b4P0m+EK9lFfbW8/ulSCSqm50ri2VmivDsRYJpsh8DOfOKR1o
         jeYjT4GQ+aThnHE3V71DbIYq5M9rIN1zX5gcWUdLF72XwhbP4tYoZ7ncnZOYIgExtr6G
         WglfC5wtPgTdrEphltlPoTRhi3ZojUnIytdKbaYAn7+EGlitr+AkubcGaNlh6B4UwelO
         EUoZyyc0XLPGyEFR8sBYtjSi7n4WigXV42nmN/0HrakgI+ZLJHXccwbH2dpUS1EQTrAd
         L9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683251; x=1730288051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9/+YXB0yFn3lOXE+wDfnOMUk7oakkE6QbrJ6dxZQ+4=;
        b=ds38LBnNQ7nqZ3kztpMvM1ThTcgLOvx+aTGxi/XfUW33BDHC5b6jxV4lKZp1r6y3wU
         rZ3dmnBoSGa/QtfMU8OX2QaiZSmA5gn+NadtPjRJOpK3v25Tw8aurhaE78DrlmC2lbUj
         YNhm8+Dm43yUA2dCTv15MLt5xXq45eJ9pUIewfeV6G/hFsGaxuy9ovzZ6ujOTh62cQQR
         KuocfWVIdQwR+0mXsfNMMSFXclJQTcvA8FqBXb6M09O+zbj/n64JJZKIV+o2TGBLBQnw
         jvES6mw/M3LlGhIZC4VMjxiPHPoH2DlBDCHLpWR/wFltVr/pNBd56aKpRe3Buq5hzU1S
         Cvng==
X-Forwarded-Encrypted: i=1; AJvYcCWJHmXYGPgr6HdPKzhfHcXLTBH+DQbV1n25IUH3ZwMdIyhUE3I1P1d1j4oXNDprKHV2rrg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwboqJKsVsWYobtXvix45kkC9h7RybJsyUlHMgDzPJN5gVO9w/1
	06yAX1tDqMiZXeq+Y0UF7eQLOmIRreu0JLJbNMqpLDJN/1Mfvpy4bCZFbKhsQhY=
X-Google-Smtp-Source: AGHT+IHwbt07id+3Aor1n1Uw1SIwY71B+kw6O/tu5t2PwERx5fCQ43YmiWLOmkaJNzRIJ+hnNpC7YQ==
X-Received: by 2002:a17:907:9496:b0:a9a:1bb4:800c with SMTP id a640c23a62f3a-a9abf85caf5mr187274866b.4.1729683250848;
        Wed, 23 Oct 2024 04:34:10 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9acad2eeabsm12746666b.20.2024.10.23.04.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:08 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 570455F8D7;
	Wed, 23 Oct 2024 12:34:07 +0100 (BST)
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
Subject: [PATCH v3 04/18] meson: hide tsan related warnings
Date: Wed, 23 Oct 2024 12:33:52 +0100
Message-Id: <20241023113406.1284676-5-alex.bennee@linaro.org>
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


