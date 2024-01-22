Return-Path: <kvm+bounces-6565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E29AB836816
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 16:27:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B093285111
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 15:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0527D5DF2C;
	Mon, 22 Jan 2024 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MAWFguvw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9896145C12
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705935694; cv=none; b=dHEvjvDCpcGs7XeS0QeGlwdFAjwoyR7HaCDSxJkLN7e/EJ2CUQh985S8+vej+5Xzh6ji7VleDDMBGkXsNahGiwzZAS3WVhO0xyrcNpHJsjD6UgXShSWE+qfPOpguSIrYB7ImBCSzNfDemKjrQUvgTCMdkK2f4Fgs1tvQyv5CQjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705935694; c=relaxed/simple;
	bh=N1xz6b1bRtJo3GS38aPfHrL1bLiSmyukhlQlOkwmAcY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PqGtmRzIkm0KNXRh2vez10PHBXii9PUFUATtNe7Lz7uDM+PniiJhM9RbXOltbC7EauRUod1GOGFvPhssg+4qDrCG2wTHvs/9Fa3pNBX2fWbfzIsQYuNu/FfJQSFeO7mMLQmNzybNdnfAM+m0EQ4wuPlevroO8qB19K4yserhUO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MAWFguvw; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40e7065b7bdso39372685e9.3
        for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 07:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705935691; x=1706540491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZ1nEd8NJNCNQAO45v/M0dXLXOT0Wd7jVxF+jov+Saw=;
        b=MAWFguvwTiZxJ7V9Opk1X6ivfB8A/FSBzAtAJvCJIlNUcsbTCiAjVgAmjlcFJ5inGy
         ljqQquYCyaCvqjniPWCQ2G/qTQl4yyD5frUAWpYPuv6fN0oaONgvY7XlHg2982p34Szm
         3M4bK5khKDpHynPEb0XkjjeSq9ha0g0+6xc0/kvvEilYEh0crTfoQ1X0DsKP/Cdg4g/X
         5XjU2O6blPgczC1XW1eEbxQMpIsLfGyvHroptugT+Rg1EspNKQw9mFCC8YUq5EVAtdcA
         90MwzpClRo6MQIpTgLLh/pQsw5fabJgbUJsUlMXK8kh4XA3E4Xrwtfj3R+E601gp2yNt
         8+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705935691; x=1706540491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZ1nEd8NJNCNQAO45v/M0dXLXOT0Wd7jVxF+jov+Saw=;
        b=PZDqQ5VtMDv4tkEj/ynVsnDfSU63nQ12eHBtFI9OXuT730PbyW+QK0SYu3hYQsc2Os
         XZkhI1AV2QaiK3pZ5HlZvZU3sJQwSJ3ugonVHO38tDxV0bv4WAarH5ui213GHTUIaaid
         LdjbCLdUZb1+/uw6nlpztND71q55LV57pLdsL7UH627uohvK16eD+S+LkSnqOv6cbyqG
         w8ycka3ZNYLTK7dblEQ9chQL4vqh9HlTP+Ys1Kb22IEWY5+LmBxQksbIjG17HfH9hUSQ
         ZLIg6amFSJd0wrGNFB66FXtWWN36vtc63ZaYb3ErwX3DABQ5TmasQgZK2ZdXB+CK6UOX
         RQ0Q==
X-Gm-Message-State: AOJu0Yy5DgnViBq7nm98AgjzgyUiuqCtKiI57jlQYPQuGsJhMWtAEPGI
	vCaxM9PjloUg7TJEQW5kq1kvLSheWcpUJY4ie763VcMUWs3oumjzvdfXs8nWznI=
X-Google-Smtp-Source: AGHT+IEwv0U3gluOvjzxJUPlNZ0yWsCpKsoao62m327xZ8POdVEwgy/zDswLP5yfB02fCPKJ5stsXQ==
X-Received: by 2002:a05:600c:5403:b0:40e:a666:4729 with SMTP id he3-20020a05600c540300b0040ea6664729mr1258496wmb.278.1705935689716;
        Mon, 22 Jan 2024 07:01:29 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id v21-20020a05600c445500b0040d62f89381sm39534890wmn.35.2024.01.22.07.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 07:01:28 -0800 (PST)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id E12235F9D2;
	Mon, 22 Jan 2024 14:56:12 +0000 (GMT)
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
Subject: [PATCH v3 18/21] contrib/plugins: fix imatch
Date: Mon, 22 Jan 2024 14:56:07 +0000
Message-Id: <20240122145610.413836-19-alex.bennee@linaro.org>
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

We can't directly save the ephemeral imatch from argv as that memory
will get recycled.

Message-Id: <20240103173349.398526-40-alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 contrib/plugins/execlog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/contrib/plugins/execlog.c b/contrib/plugins/execlog.c
index 82dc2f584e2..f262e5555eb 100644
--- a/contrib/plugins/execlog.c
+++ b/contrib/plugins/execlog.c
@@ -199,7 +199,7 @@ static void parse_insn_match(char *match)
     if (!imatches) {
         imatches = g_ptr_array_new();
     }
-    g_ptr_array_add(imatches, match);
+    g_ptr_array_add(imatches, g_strdup(match));
 }
 
 static void parse_vaddr_match(char *match)
-- 
2.39.2


