Return-Path: <kvm+bounces-6567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EFDA836819
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:27:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E046228754C
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400E95EE82;
	Mon, 22 Jan 2024 15:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hdPM5csf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79C15DF24
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935696; cv=none; b=bw+FM9SyzQKS6EulDnVuCTiwHu1YfYNi6+W+U4n7aGI7wAzGTzGW4AfejvfyA4RNIydKlLz0x5N9FE0PWnuUBD6IsNI7ivzUqatkYTR7ev/TdBJiRB6s5/82bkQ1F2BDncF1VjUg5HXZuni8jjnY272FUzaanmMX/bj/LX4pRho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935696; c=relaxed/simple;
	bh=qk9Fc4n+yThTQUr/IY5f6fw8mfY0PIL0MImGk4TIDlQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwaqQFDjth+ZFW1LZFCkUQ+BD1gzRzZRaAUVqVoHC/CcN6Blzmx120pmr0MBWVVH2B+neyg0u1pZ0/rb3z/z56EJDhERN7cegguqewBmCB7XKjsFvCW0C3h4dzk588HLCVap00+mpJauVkgOHwMFagSkT4HB96iOalUcnnz/2Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hdPM5csf; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-33924df7245so2162496f8f.0
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 07:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935693; x=1706540493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+Lu1aUTzILJv+8PeOqcfRU9ypZOJg6L0bg1/V/uBfw=;
        b=hdPM5csfwzX3Ylww/36RyitwnXmcADgctxEjsL0tmEQTLA26NOte4xFvoht0PuoWwj
         vckpAlDCuz7LkUe8e741n0Lu5ZGjmiuT7UC+xcIOtYxlLZCO/3RYZjNjKizaG7uGUrWN
         /OdNT11NizRFheH0kyPhbu2QqnVGNfZQ732hQtGOZKJ/qpBugOiG/xAB+haJ1lfHYwIY
         kY1Me3sQfchNOgSr1NcU5FTrFcSDIoQf2bmvYR0y7SxcM56oeeTaGLKouSF+4ewjvwUj
         /XXlFQOCy9Zot1aT9/2lKZrhIjZDujc9HvLIMCJmeIKDPiPGLim7lYILxjw93hjWt62A
         itWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935693; x=1706540493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t+Lu1aUTzILJv+8PeOqcfRU9ypZOJg6L0bg1/V/uBfw=;
        b=DDhRpgjzhWLEnxeuww3gPpRWmH7CF6KaDKldwCgZvMe5lMxRftAYb4eeybmFhV7P3n
         wnqoMdWPcX9svDZb/Jcxu17HtS06qYtQc2ap7yOasdZeTrAPNQx0MW2slJEzR76tX2Gb
         m77wh1j34mrx/oZG9RkTzlwl/QFxSecW04/ygt2YU9gJXBwEaYwKLBJgJaSquYmrooXS
         OvzWjc7aO72Ya6Vp1vIwcZLhlaANOhqWSl5u5TD214sCENvgdJg3sYb987HeIqCEiz8u
         mVSl8xQ6j6/57ncDncP642Oe78q2H6xZDosktP1I3Qd1Jv5UqOzHFH4rPYoWqTdfBqjJ
         QdNA==
X-Gm-Message-State: AOJu0Yz4BLJIc7J5HyXmeoc2Ox7qWCPAFzt4TGpLp50crrmKfDmJywiT
	z4xyRz3P4RAaIcW1aT3fqsoAf/15/EO5dk4mwBOJPXIJQ2cNUN6gJ6rmX3QqEqA=
X-Google-Smtp-Source: AGHT+IHRTiofbHHbDcY7uv6w4qbyhJzpWSu85QzckhLtxFm+BHNGyxBTpaRUgd7Z2Eylz9B6B5o7cg==
X-Received: by 2002:a05:600c:4fc7:b0:40e:60a3:b3e6 with SMTP id o7-20020a05600c4fc700b0040e60a3b3e6mr2319898wmq.170.1705935692106;
        Mon, 22 Jan 2024 07:01:32 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id u6-20020a05600c138600b0040d5a9d6b68sm43621458wmf.6.2024.01.22.07.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 07:01:31 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 1D9245F9D4;
	Mon, 22 Jan 2024 14:56:13 +0000 (GMT)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>,
	kvm@vger.kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-ppc@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-s390x@nongnu.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	John Snow <jsnow@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Cleber Rosa <crosa@redhat.com>,
	Beraldo Leal <bleal@redhat.com>,
	Bin Meng <bin.meng@windriver.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	qemu-riscv@nongnu.org,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Song Gao <gaosong@loongson.cn>,
	Eduardo Habkost <eduardo@habkost.net>,
	Brian Cain <bcain@quicinc.com>,
	Paul Durrant <paul@xen.org>
Subject: [PATCH v3 20/21] docs/devel: lift example and plugin API sections up
Date: Mon, 22 Jan 2024 14:56:09 +0000
Message-Id: <20240122145610.413836-21-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122145610.413836-1-alex.bennee@linaro.org>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This makes them a bit more visible in the TCG emulation menu rather
than hiding them away bellow the ToC limit.

Message-Id: <20240103173349.398526-43-alex.bennee@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 docs/devel/tcg-plugins.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/docs/devel/tcg-plugins.rst b/docs/devel/tcg-plugins.rst
index fa7421279f5..535a74684c5 100644
--- a/docs/devel/tcg-plugins.rst
+++ b/docs/devel/tcg-plugins.rst
@@ -143,7 +143,7 @@ requested. The plugin isn't completely uninstalled until the safe work
 has executed while all vCPUs are quiescent.
 
 Example Plugins
----------------
+===============
 
 There are a number of plugins included with QEMU and you are
 encouraged to contribute your own plugins plugins upstream. There is a
@@ -591,8 +591,8 @@ The plugin has a number of arguments, all of them are optional:
   configuration arguments implies ``l2=on``.
   (default: N = 2097152 (2MB), B = 64, A = 16)
 
-API
----
+Plugin API
+==========
 
 The following API is generated from the inline documentation in
 ``include/qemu/qemu-plugin.h``. Please ensure any updates to the API
-- 
2.39.2


