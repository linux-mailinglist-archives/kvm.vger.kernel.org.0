Return-Path: <kvm+bounces-29491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 002539AC914
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:35:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 301021C20F5C
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C96B1B85F0;
	Wed, 23 Oct 2024 11:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wzhkjsxk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67C61B4F3A
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683261; cv=none; b=LvZY0GE7SPuiAsYnkcvCmMHMFp99QUNp0vAX0AWFYSoYgXBIaEknKLMLo0DqDgtsoreOSp1zazdIST11jTwm+5/sWCJuViqWREglMghqrRLQ7RHp4CZP9OPbQ3uxtdcg61Bxc1ytofd7g3O87K5PFvDwhH2qjQYAYW24TsC04YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683261; c=relaxed/simple;
	bh=UXQdLtabbiMtGUHNw3CuGAH7Y7y/tqHPMvrpotkPjug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ujkztaw8pJ1aAxo4XOq5tv73nbukdsFQy/Ogv22almoPVaKhdwj/f9a3VAdU14N+l2+C0na8JR3nAuuOHNokTh8oeETHwIG2dTaCqhYgED8b5VP3oJJK0GKkJ5bsbOaQTYx7LOT87BBqdE9YK4IH5lIFIpXbHi3kQIjX92iRm7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wzhkjsxk; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9a0472306cso897215866b.3
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683258; x=1730288058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pgb6ox3Ya7i122uZlocXrETTS1VOKhPW7bSAndX3jjQ=;
        b=wzhkjsxkjQjtzd3+le+rCHbgi8DyM4AoPWJDRP76B74CttVI2lwON7aCJB7jbFfoxY
         A8IKfFLE1iiidts3vGemqT6FWYK0Ue52jl3mx+XbtqrOhfOPE4z2OgaiGg9TVxlIe+84
         n2Xiv2bSfyZK5XQj95Ltb84MJvG1+YP3xSuyjELEAgHAaU0oS+VJAmVz3Vcc/WZLb9vt
         86BhMqObvMKv1IIE6NXi6ZI1GSv9OunZA0Vv+3Fo2JeX6AskE+8dx3+68msGclO1mGmh
         WQ1rMPoimzSIgu8hDJwbh+Towm4kygzhHMKjoTCHrJgtVG445aSZxhKsRk9RRbVLthut
         Q7rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683258; x=1730288058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pgb6ox3Ya7i122uZlocXrETTS1VOKhPW7bSAndX3jjQ=;
        b=gjpTkS/HgWc6YR58blCfsmoCUnUYHCgWpuC1vQCWJcGrWIFE0gKXSr6KV+0qSa93/Q
         n+Ec6RMwsNHyjfwGSQVxJDnOax7Q5sX3Sl8TrBObIbK2dC8QPzImsC6wg6heRoIF0SWs
         Fr066WHPOIR/7vYLIXr/jRpPE9EgHuxA0Q1+PY728qgyKwdH7kUsjMQ+u937Jamjfw1r
         BPD1u1l7P+6Bufy7STOHSQl+fy1vONPKeY8uRquzI70wXH006DVMgOWySn4MthKBG98p
         70pVsPVNfjh8sYs480Kbet4Vrf6zXrmabnMZ+w8mW56QkBCPqbk77Jus0J5PRb4MQSQB
         9aWw==
X-Forwarded-Encrypted: i=1; AJvYcCUs2FW8tFI+1ul10rjNr7QSGovcbrHWoxIyNRoLrofInfkjsyNLdNcHzQHSwl6hfPd8/FE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgV5+MjBKSTP7MOQpjmYZ3LnVgOOUnGKMU5Dmddny/bXwENeAo
	eU5WUM1Iy0PV9LPhRqmQzrmsb3i/wDwARyOCtc/u6vcvwtnEtYOonyeRymscibw=
X-Google-Smtp-Source: AGHT+IGV1BmmYJYiHVOsfdD8NKiwKMyXPcWgCdf3lsOYC2w3ygGnh/9fI/TEjp6+W0G/coRG8ccRNQ==
X-Received: by 2002:a17:907:724b:b0:a9a:49a8:f1fa with SMTP id a640c23a62f3a-a9abf8933f0mr220298266b.23.1729683258240;
        Wed, 23 Oct 2024 04:34:18 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912ee0f5sm463385166b.66.2024.10.23.04.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:34:16 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 5288E5FBDC;
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
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Gustavo Romero <gustavo.romero@linaro.org>
Subject: [PATCH v3 14/18] tests/tcg/aarch64: Use raw strings for regexes in test-mte.py
Date: Wed, 23 Oct 2024 12:34:02 +0100
Message-Id: <20241023113406.1284676-15-alex.bennee@linaro.org>
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

From: Gustavo Romero <gustavo.romero@linaro.org>

Use Python's raw string notation instead of string literals for regex so
it's not necessary to double backslashes when regex special forms are
used. Raw notation is preferred for regex and easier to read.

Signed-off-by: Gustavo Romero <gustavo.romero@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20241015140806.385449-1-gustavo.romero@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 tests/tcg/aarch64/gdbstub/test-mte.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/tcg/aarch64/gdbstub/test-mte.py b/tests/tcg/aarch64/gdbstub/test-mte.py
index a4cae6caa0..9ad98e7a54 100644
--- a/tests/tcg/aarch64/gdbstub/test-mte.py
+++ b/tests/tcg/aarch64/gdbstub/test-mte.py
@@ -23,8 +23,8 @@
 from test_gdbstub import arg_parser, main, report
 
 
-PATTERN_0 = "Memory tags for address 0x[0-9a-f]+ match \\(0x[0-9a-f]+\\)."
-PATTERN_1 = ".*(0x[0-9a-f]+)"
+PATTERN_0 = r"Memory tags for address 0x[0-9a-f]+ match \(0x[0-9a-f]+\)."
+PATTERN_1 = r".*(0x[0-9a-f]+)"
 
 
 def run_test():
-- 
2.39.5


