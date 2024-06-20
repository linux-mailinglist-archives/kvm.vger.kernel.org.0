Return-Path: <kvm+bounces-20098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 463B09109A9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01DA6283C29
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B011AF6BD;
	Thu, 20 Jun 2024 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d33g02an"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D851AB91B
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896951; cv=none; b=CmaniTqjA3UznLB3DEEjo4KK3c2RSFweedbMbECr7f7B7poMQJjQbk8O104LspDsA+yUMBrpNyl0D6YS6HG2mSjGMD7TQ+MqVPLotSR3ojwpSZoVflAXBPr/cCJP9+KkVvGadsmUJibi5Cq4K1lTIH7nQEo7/Q+OO5mJMt8MbNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896951; c=relaxed/simple;
	bh=x0KN3Mbd8aMVqPHdgl1/SMy2aZnIAphEJs/rdAHKmrw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hgr/l1YYhA5kGAe+LKu5NvuTOSO+C7Eha7K8g3qqeE4eD37rbei9voC1XIl8uLeMrPggeAI7rGQScIBRYonpFMpikX/ZOfiPUsmXzJg0y2pFaUrbXEQiWIOls26fKsT4mrrKbcGI55rofsq3jk009QU5unAOs7G6vT6q71GVPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d33g02an; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-57d1679ee83so1031878a12.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896948; x=1719501748; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJDItK1lJ7pU44CkysDABVIUb9quWUurAs3tDshcfJY=;
        b=d33g02anEkaGb2oAj6f5puwMLJH+XqUU0wBW1ly6KJFMd1O4o+NT8QfXqiUM+7ZcwC
         tgcfuNC6JK5D21ZwoQyYXiiXSthUBanSXu4KJ1Sd/pt0vZgA+Zh5kt5g4LY4t8SrGu1H
         06TduZTuAATsmdQLJG/7mmNxTRKomwezxm+jKaRKGaJtGsjbshvrd4Lk0DElgCQ3dORo
         KhIskuV+gT/K34rTZ4pQklWk0E+iafXoOgTuNSpYBip5ZO8hjuNV7D6tpASOBcuq355v
         YvEXJWbzggs8RjpzEsG8zAnUVxiS8U2j6lB7jXGSQrMj1EFicj4Xruz182OZpt4HVjaC
         /Vmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896948; x=1719501748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJDItK1lJ7pU44CkysDABVIUb9quWUurAs3tDshcfJY=;
        b=apegAAU5TgvNKJegHUllAycTt8oAf/04zcVuD7cN7AKz1W+g28HNgCjmcXe5TTJL4N
         P9ZWGFI5j7/I5+JYTZOBofffmK8YOox/9P5K5FExUVBCHqAV2igsHXBSqmRaViQbl2yU
         llIPz9YiZbsFXJwJjMS+NKWRhQMBdqY/G+dIeSMXlsU1H22WYUbT+4yP6iGDKxD9e5nn
         0wFnsay+b7/kt2gJaLwglGGHHnBfYoVjTHLrAKqjaHSnC6SnATRak2boiE/M9Ukd9vmG
         VZj0/H0R0j9ZerTfGywwGDRpdrcG0HFk70/X4r82nopd/fHMT4f6gbwnfZJMi6ofQGeN
         hOpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgdoQ0Kxf0uZdhkF5yMG0tKR/ZcoZmAGsWWZnJGMOm/XMmY9MuAgpo6IiRov13eqXM+lIBjD/zxDrHGIjzUzFgdnVm
X-Gm-Message-State: AOJu0Yxwz5QbYAiTOl5lPtbsxrfHMIaTrj56bt4Y7YUtxdk2J7rQP6jh
	jaaBLzkPSSqhxFyduGsByFSK/temnt0jhTyiB7mv8UGGehcHNxGJjaxt2dNdhbs=
X-Google-Smtp-Source: AGHT+IH0DozvQRi/LaMdJtXI1+l7Oz911+HmQ8KveXTxshkIx5oakUEt56iH61txi2255uJDmlcM0w==
X-Received: by 2002:a50:cd97:0:b0:57d:61a:7f20 with SMTP id 4fb4d7f45d1cf-57d07e6ba6cmr3862286a12.3.1718896948159;
        Thu, 20 Jun 2024 08:22:28 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d16160c18sm1609800a12.26.2024.06.20.08.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:22 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 51EE45F9F4;
	Thu, 20 Jun 2024 16:22:21 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v2 03/12] plugins: Ensure register handles are not NULL
Date: Thu, 20 Jun 2024 16:22:11 +0100
Message-Id: <20240620152220.2192768-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akihiko Odaki <akihiko.odaki@daynix.com>

Ensure register handles are not NULL so that a plugin can assume NULL is
invalid as a register handle.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Message-Id: <20240612153508.1532940-4-alex.bennee@linaro.org>
Message-Id: <20240229-null-v1-1-e716501d981e@daynix.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 plugins/api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/plugins/api.c b/plugins/api.c
index 5a0a7f8c71..6bdb26bbe3 100644
--- a/plugins/api.c
+++ b/plugins/api.c
@@ -507,7 +507,7 @@ static GArray *create_register_handles(GArray *gdbstub_regs)
         }
 
         /* Create a record for the plugin */
-        desc.handle = GINT_TO_POINTER(grd->gdb_reg);
+        desc.handle = GINT_TO_POINTER(grd->gdb_reg + 1);
         desc.name = g_intern_string(grd->name);
         desc.feature = g_intern_string(grd->feature_name);
         g_array_append_val(find_data, desc);
@@ -528,7 +528,7 @@ int qemu_plugin_read_register(struct qemu_plugin_register *reg, GByteArray *buf)
 {
     g_assert(current_cpu);
 
-    return gdb_read_register(current_cpu, buf, GPOINTER_TO_INT(reg));
+    return gdb_read_register(current_cpu, buf, GPOINTER_TO_INT(reg) - 1);
 }
 
 struct qemu_plugin_scoreboard *qemu_plugin_scoreboard_new(size_t element_size)
-- 
2.39.2


