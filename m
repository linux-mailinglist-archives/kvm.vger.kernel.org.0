Return-Path: <kvm+bounces-29374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 765449AA09E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A573F1C21EDC
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A5119D8BB;
	Tue, 22 Oct 2024 10:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VYyPx6am"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F69D19D090
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594595; cv=none; b=Nr3oZb6lomO4vwzkzp/E2EFE6M8kA1TIhyeehqetHkxxYHPG/5WwGR6ussiGpKNDnOh6ulfWCEXZQJhFMjv5a6QGgooM0EXYsDmJyhrDWfXHpyLVLwmtoiQ/ioPfe4qZaLFw/+ttnAoeY4zD8srweJPqDUCimIgtzVSHO8rcspo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594595; c=relaxed/simple;
	bh=UXQdLtabbiMtGUHNw3CuGAH7Y7y/tqHPMvrpotkPjug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NbA+VvrZ2BTvFRZRupsDUInzcO9K1iIZJc4BQWuJl9THKxjM5JClKZ3j1Y39Msx11GBwqujlf9c6WCgOEkVpCSF6NLu9rQ0rpXXulikv1qxgVvR13OVJiKFZU6Wng+cjZ7czl/BduytJlB64qD1N4L6TNiVxYh7Os0bHu6UgyNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VYyPx6am; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a99f1fd20c4so751336266b.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594593; x=1730199393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pgb6ox3Ya7i122uZlocXrETTS1VOKhPW7bSAndX3jjQ=;
        b=VYyPx6amSMKv5u/ZEpVNJyWbpoZ5ls+G6x341/ynWLqKBv8oT3adprYZ5/Lq46h7OM
         fVbpfxDK1x2osBTWZMtqFnY4AOI2R8C55xwQHW0DlYoUiw+ciG6Inew2jeoXPvV5vM9X
         i9NVhQRCjbTS6/ruHl0cqGGY76lxdWbIIB/bFuf3tysdH4JmwiizOhJYdYg5b+AgNXqM
         mPjasm0pBrlLYGsm6awz7syGZ5OXY4hGZTE5P+RMM7ubf93Nn4k+r9H1+0RCWj81lEIY
         deimx6jd9JZspDBnvkaJykF+IdifhBMj3+q6eQIZICuu/JG/KKeOzxeePHOLBU2mquGf
         L7vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594593; x=1730199393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pgb6ox3Ya7i122uZlocXrETTS1VOKhPW7bSAndX3jjQ=;
        b=K4j80YI8mkRwbOULt00xiPJJeVitPsnylfXk4rWFDvJO/RqYPcNlEmQVlPEtzoBcFa
         tHWvzIpu66m8OJNWrLzHCoXWjTm+T82HXH6etPgSa0Tlz4QlnUCP+aTFokYvX5KM98jt
         SDTQUeDprcSujrDfQfnR1NuzP/3imgV01P8JDqAw7Z7RqPQh3+wRojwDBGUNVPXGMYl6
         NI4VRN2jvoICsaEcSnEqPY+p0x0OhrtbeTnnv+QFIxotYzgNizyz/0hj99uUowZG0Av2
         O57FP4Y5BPIDPn1z8gzEByy03KvHSS3fv4fkIRztFQq2VcBM+zCny3+UWhBoiPpcLzAe
         55ag==
X-Forwarded-Encrypted: i=1; AJvYcCXpsLFpMNtPVjS+CnG7yCiFtdYW7I9f7RXb0YPxcBNRgU6hxYlvkilymvv+3wZxs9KziiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF78PquEgUEZbEguUHdNcuUD0BRxEFX1gOBNQCNuzq5dlo/gMf
	zeGO34zAFdobNCqzzEjIBRcFVlZwNUaGhfJOn7Kkx2gqxHhFycjMWfBhFaQtiBU=
X-Google-Smtp-Source: AGHT+IGPREmWhIG8Sxc2dRJUVUnivk8DPIAg98Rjd0GSZmqkbNvMhBR1OB4OKQK6ufaSF5tJ1fK0uw==
X-Received: by 2002:a17:907:97d2:b0:a99:fb56:39cc with SMTP id a640c23a62f3a-a9aace98a17mr198686166b.38.1729594592591;
        Tue, 22 Oct 2024 03:56:32 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d838csm323114066b.8.2024.10.22.03.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:28 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id D97B25FC0F;
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
	Paolo Bonzini <pbonzini@redhat.com>,
	Gustavo Romero <gustavo.romero@linaro.org>
Subject: [PATCH v2 14/20] tests/tcg/aarch64: Use raw strings for regexes in test-mte.py
Date: Tue, 22 Oct 2024 11:56:08 +0100
Message-Id: <20241022105614.839199-15-alex.bennee@linaro.org>
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


