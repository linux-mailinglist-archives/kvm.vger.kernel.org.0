Return-Path: <kvm+bounces-5056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CDC481B43C
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 11:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5867282741
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98096745C6;
	Thu, 21 Dec 2023 10:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JYV/3jvG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE5F6EB75
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 10:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40c39ef63d9so6406065e9.3
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 02:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703155627; x=1703760427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sLk9Y6V09YT5mxoKGySQqDe7AUl7PrL/RJQ+Y1wnbw=;
        b=JYV/3jvGK8jNFQmr3IZUxjfW0IXW2+0GBXVuE+H0atdosRjMUVTuzMR98FchnxmYOl
         wpRoWwry5Rs1JZ9tzt6DMQdcR8OgUV+iCBM1IDro0AkaSz0RsZ1mmFubaiOWxSJF3wMK
         cUh1C5kSYdgHSwTuRD5n0Aam7h1xMT18LrirbWK4aqeiIOa52qljdrpeeobV7/nYVCXJ
         rDjnwTINidLEe22GEDINrGzCck8H2/eLxeZBr3hhjWRHCGFCgVe0fIV/hVyvRaNNT5RL
         bq8CvO/Zj1Sbult9GN398hXK+8ssEwTZ0S84FQW0QJG3btkHy4gs8R+yvtAuP5oFExRw
         DNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703155627; x=1703760427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0sLk9Y6V09YT5mxoKGySQqDe7AUl7PrL/RJQ+Y1wnbw=;
        b=oyybSe/vCQZEbChkI8thGyWaFeX0sjq6R4fQB+oupXOltT2g1xQsmMs4tTsccmIbsZ
         zkVwJtedcf1HxGeRk+VuhTBl5dQ4v9LxkU1S0kj0kEHDXRUxpxqYwDKC+iMWZsb/NLJK
         elFO4CmFkCxJuiBuYyg+l2+dcd8jovg+GgT2rb+DGH5d2Kvuag6MpdZ1wvQzynnhzdwu
         7wjquhI+JExUiXLM/zzc/gJgtOcEsLWbPCKqVGFlDIxeiU2sESYywHkEdtc1F7WBOdWo
         AA3KL6PiXFofZDGKBjMnXiUkoQxcFLeA2zjFvHWnaWxvK3w6ZGiezL/ZCn5OQ6y/4ZCm
         /t5g==
X-Gm-Message-State: AOJu0Yy577LWqnebDnJeYLBUcYlbjT6iTK2zPz+epl2fYhF7k8gv3z8v
	OeqdN+QgUmoC/3NfLLhnOZhfmA==
X-Google-Smtp-Source: AGHT+IEh4A/ofvHjjDxGae4dNp01ycAbrgSKgNLymJ1Ha3Ry/GdnF3Tf0BsMFDRp8ivuX9KZRRwyWg==
X-Received: by 2002:a05:600c:1682:b0:40c:3984:4977 with SMTP id k2-20020a05600c168200b0040c39844977mr650705wmn.174.1703155627469;
        Thu, 21 Dec 2023 02:47:07 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id b2-20020a05600c4e0200b0040c440f9393sm3526519wmq.42.2023.12.21.02.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 02:47:06 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id CEF355F8E3;
	Thu, 21 Dec 2023 10:38:20 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Cleber Rosa <crosa@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-s390x@nongnu.org,
	David Woodhouse <dwmw2@infradead.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Thomas Huth <thuth@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-ppc@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Richard Henderson <richard.henderson@linaro.org>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Bin Meng <bin.meng@windriver.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH 20/40] mtest2make: stop disabling meson test timeouts
Date: Thu, 21 Dec 2023 10:37:58 +0000
Message-Id: <20231221103818.1633766-21-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231221103818.1633766-1-alex.bennee@linaro.org>
References: <20231221103818.1633766-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel P. Berrangé <berrange@redhat.com>

The mtest2make.py script passes the arg '-t 0' to 'meson test' which
disables all test timeouts. This is a major source of pain when running
in GitLab CI and a test gets stuck. It will stall until GitLab kills the
CI job. This leaves us with little easily consumable information about
the stalled test. The TAP format doesn't show the test name until it is
completed, and TAP output from multiple tests it interleaved. So we
have to analyse the log to figure out what tests had un-finished TAP
output present and thus infer which test case caused the hang. This is
very time consuming and error prone.

By allowing meson to kill stalled tests, we get a direct display of what
test program got stuck, which lets us more directly focus in on what
specific test case within the test program hung.

The other issue with disabling meson test timeouts by default is that it
makes it more likely that maintainers inadvertantly introduce slowdowns.
For example the recent-ish change that accidentally made migrate-test
take 15-20 minutes instead of around 1 minute.

The main risk of this change is that the individual test timeouts might
be too short to allow completion in high load scenarios. Thus, there is
likely to be some short term pain where we have to bump the timeouts for
certain tests to make them reliable enough. The preceeding few patches
raised the timeouts for all failures that were immediately apparent
in GitLab CI.

Even with the possible short term instability, this should still be a
net win for debuggability of failed CI pipelines over the long term.

Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-ID: <20230717182859.707658-13-berrange@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20231215070357.10888-17-thuth@redhat.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 scripts/mtest2make.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/mtest2make.py b/scripts/mtest2make.py
index 179dd548718..eb01a05ddbd 100644
--- a/scripts/mtest2make.py
+++ b/scripts/mtest2make.py
@@ -27,7 +27,8 @@ def names(self, base):
 .speed.slow = $(foreach s,$(sort $(filter-out %-thorough, $1)), --suite $s)
 .speed.thorough = $(foreach s,$(sort $1), --suite $s)
 
-.mtestargs = --no-rebuild -t 0
+TIMEOUT_MULTIPLIER = 1
+.mtestargs = --no-rebuild -t $(TIMEOUT_MULTIPLIER)
 ifneq ($(SPEED), quick)
 .mtestargs += --setup $(SPEED)
 endif
-- 
2.39.2


