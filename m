Return-Path: <kvm+bounces-5554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B6782335C
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 18:35:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B96A1F24ECF
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 17:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8711D698;
	Wed,  3 Jan 2024 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fo8WVUpy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA711D53B
	for <kvm@vger.kernel.org>; Wed,  3 Jan 2024 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ccbded5aa4so83785641fa.1
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 09:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704303243; x=1704908043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G7uxGZGov81O+5jLuoaBr/C5I/uZZh1/zGx1+p9cIt8=;
        b=fo8WVUpyaIVxsr8IDUuJQ759QsxZYe8PvUGK488cBozqCqPqVr2BxjxvvkXiT92KSX
         VR6kHuGdcsUB16k5zSEAhTZRhe+KHQrdxhbhIk47sNxsAlbiXpp0qYflGd0lKbtk5+0d
         V5r8f5JhOQi1rHIBOStfntkLP6OPdiNmCbrweS+QdRdIuDvzqDmbnNgkhXu0Wp7981h4
         EQ8P56GwVCtRvaZgmNLY9Xi6q19jAtjJ6v5MRJLuyQovUQDSjbKFAo2YyvvT+dRattiB
         KI9uG+D5ZewdhsgOjfeZioxfDD7Fv6E3zvA62sn1cPPFwheVV0yieSWNHCqU9yXGCRFs
         R8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704303243; x=1704908043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G7uxGZGov81O+5jLuoaBr/C5I/uZZh1/zGx1+p9cIt8=;
        b=eNG3cdOzcdb4ciy2ds6QLPKEdcoP5mkx8OM3Rs+0viUx/z0mkYyaHq2fWGnhqndfnM
         cIqMA3WDgmXcc3Dbbwx7iD2aGQ/W6tn6L9vzlUpUz69mpf6sJPHfD6QoU6SH2tOc7W3n
         9rBFK0gtxbdf+vzyPvBbsI5tFqyPOS2vzuQBS/ZSc+Qlz0rwIfA76mtJNhmAjIMQA8dz
         rlnHGMhNauheg0B4lmF1l3s1YEWLSAQm8hB/og5/3yRmeYsC2Glrwk7pr3GWquNQ7yvf
         e+Rzq5zNcRs6VQhrmJZekoe4U+xwIQbMeoOQpSzp9CevEUIgtyySmhZlYlX7PPyefW3j
         anBg==
X-Gm-Message-State: AOJu0YxyZuWyDmfsx54wsXdnA3ggfiR1wUTVHoEDziyGI9whVTM8wAjz
	2vrTv11wX0dtpUZ23t3MoBY+c4/UjXB0Xw==
X-Google-Smtp-Source: AGHT+IFhNAa0ExWYCS2KvTjl2oi2iRsIB5/oaggT0hzzaXckkjHspuvOE576DfxADqAu/SUDJduuEQ==
X-Received: by 2002:a05:651c:686:b0:2cc:d555:bc66 with SMTP id x6-20020a05651c068600b002ccd555bc66mr4899025ljb.76.1704303242728;
        Wed, 03 Jan 2024 09:34:02 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id q28-20020adfab1c000000b0033690139ea5sm28923405wrc.44.2024.01.03.09.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jan 2024 09:33:56 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 817AB5F944;
	Wed,  3 Jan 2024 17:33:50 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Yanan Wang <wangyanan55@huawei.com>,
	Bin Meng <bin.meng@windriver.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Laurent Vivier <laurent@vivier.eu>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Brian Cain <bcain@quicinc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Beraldo Leal <bleal@redhat.com>,
	Paul Durrant <paul@xen.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	qemu-arm@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	John Snow <jsnow@redhat.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH v2 13/43] qtest: bump qos-test timeout to 2 minutes
Date: Wed,  3 Jan 2024 17:33:19 +0000
Message-Id: <20240103173349.398526-14-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240103173349.398526-1-alex.bennee@linaro.org>
References: <20240103173349.398526-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel P. Berrangé <berrange@redhat.com>

The qos-test takes just under 1 minute in a --enable-debug
build. Bumping to 2 minutes will give more headroom.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Message-ID: <20230717182859.707658-10-berrange@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-10-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/qtest/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
index dc1e6da5c7b..b02ca540cff 100644
--- a/tests/qtest/meson.build
+++ b/tests/qtest/meson.build
@@ -7,6 +7,7 @@ slow_qtests = {
   'pxe-test': 600,
   'prom-env-test': 360,
   'boot-serial-test': 180,
+  'qos-test': 120,
 }
 
 qtests_generic = [
-- 
2.39.2


