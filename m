Return-Path: <kvm+bounces-29495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD889AC953
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:44:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3E542865CB
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 11:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93991AB539;
	Wed, 23 Oct 2024 11:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EXErP1tg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542001A265D
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 11:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729683848; cv=none; b=mPPhQd9v/KU8NX4lel/1oUcYshlwO+jBKRLQ7Ih2l5BPUczcPw9Yw522HOzM82zPFOUZIbNr6y9PJG/0FrbAd81OQp5kwMRRu0AdSS4H/u+A5WiunxS07in+5TvBwWQi3cMIxMSKLaX6Q/CO0AZyI8fjyi4AyZ/BRv+LZTxgN5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729683848; c=relaxed/simple;
	bh=5yTCZimV0gEI7gmCOKCJLILXfJ8kpMTOraKSBNxiVlk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NPO8f/hdK1L4nZ1Guq2xFnuTKCbGNp6yOak4CEK7h29faODo3dZZkVVa41pVDF5eTBLkyhROX7Puc9HQrT/ZEotnu+LXvvWZM/T/3F6KEj2hsqdtZUBnswryvUvs11LIJf3XkNzZo7geFkfEPdLR+oBFND9JLSUSk4LddDHRPZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EXErP1tg; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9aa8895facso338674966b.2
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 04:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729683844; x=1730288644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yP4SNsaEappmzZc/gnms0PRD/uAmEAQCRgu6RQMiI8=;
        b=EXErP1tgIT7ow2MLebopcMO9QsJVfHVMYuvLMpiC0tzDx+HPF8Os2sG+iPVcqs3Qlt
         J7/Zr7q+1g/Ip21bAJ3VrT4hg5w4ooFrm/22B6qvc2Un11pxLmDzh+yzN2WjnrPh8Ksl
         001EQLE4La4xCs1wdnSS+T0moGBDzM/CQb6/I5C0J1nj+vISGbP8cVW9dlQZ5MwLm6LG
         gmEgPV2axgLHGGpD0xF5Y4W9evIHyb9iiizrd6DamU5Z9uXhdyuEZMhZGtA9fAWj66RL
         woQjnIkSlg+P27EuKqF9z8Hk5WhIYGSzI5q7sdIjTRnPXqgVYbWaVZrheqUowEv+Cygw
         LoLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729683844; x=1730288644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yP4SNsaEappmzZc/gnms0PRD/uAmEAQCRgu6RQMiI8=;
        b=PLWjDFIUsob6U26lILff2bfgxuYi3ineoxxrB9MBlOOAn01GtqgBMQa3uTgNskRWFa
         6W7YpsImfzdtzMZ8twrk+fkt8lNqco557srqt1g+5MW6Bq+1ZhoGYIpVXMyWDgxnP5o0
         M9KU5g728x/VfbkImPud6FGZ6ZYR4rjmLsE22u43nP4NIOhzCp9drT/xlVWpUrQZYSs+
         OD/dFEUIfYvkdpqA0quI5wLMVyNpW2/DsAj8pu3/ZQlRW0b9Fqcp5yeGcnUPeVQ61ebs
         nyLuOzuXx49J1QL1PP7FQYA8ywcOAbGX97Mf68oCu5P88dtcyIrHTv2A80wly71mW383
         R/WA==
X-Forwarded-Encrypted: i=1; AJvYcCU9p4ruCe4TWvjkvHI0yiWW3ADuKYb57VOX9SaAJygaYkhvP8FrZ+YjAxSoj1ToFiErqdI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy615SfbK/YWVSKp27yK5Tk7EYrR/bUhvFZnm3dPNu+6m4qrf6Q
	6qFHzWvBP0sd+VQcdCB14iWdTXKraoJP8nMKOrwb4mcNFWXMaz5qKw4twAkqdYI=
X-Google-Smtp-Source: AGHT+IHMnbwSpFbIxFr8E05r4uLkxn6q0bmtEG4CkFZ2WZbJ45lEqJq6MM15OG/HAzJxk8Ota85Nkw==
X-Received: by 2002:a17:907:a4c:b0:a9a:e9c:1d8d with SMTP id a640c23a62f3a-a9abf8664aamr189274166b.17.1729683844365;
        Wed, 23 Oct 2024 04:44:04 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91571ed3sm463602366b.164.2024.10.23.04.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 04:44:03 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B34075FC34;
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
	Robbin Ehn <rehn@rivosinc.com>
Subject: [PATCH v3 18/18] plugins: fix qemu_plugin_reset
Date: Wed, 23 Oct 2024 12:34:06 +0100
Message-Id: <20241023113406.1284676-19-alex.bennee@linaro.org>
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

34e5e1 refactored the plugin context initialization. After this change,
tcg_ctx->plugin_insn is not reset inconditionnally anymore, but only if
one plugin at least is active.

When uninstalling the last plugin active, we stopped reinitializing
tcg_ctx->plugin_insn, which leads to memory callbacks being emitted.
This results in an error as they don't appear in a plugin op sequence as
expected.

The correct fix is to make sure we reset plugin translation variables
after current block translation ends. This way, we can catch any
potential misuse of those after a given block, in more than fixing the
current bug.

Fixes: https://gitlab.com/qemu-project/qemu/-/issues/2570
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Tested-by: Robbin Ehn <rehn@rivosinc.com>
Message-Id: <20241015003819.984601-1-pierrick.bouvier@linaro.org>
[AJB: trim patch version details from commit msg]
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 accel/tcg/plugin-gen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/accel/tcg/plugin-gen.c b/accel/tcg/plugin-gen.c
index 2ee4c22bef..0f47bfbb48 100644
--- a/accel/tcg/plugin-gen.c
+++ b/accel/tcg/plugin-gen.c
@@ -467,4 +467,8 @@ void plugin_gen_tb_end(CPUState *cpu, size_t num_insns)
 
     /* inject the instrumentation at the appropriate places */
     plugin_gen_inject(ptb);
+
+    /* reset plugin translation state (plugin_tb is reused between blocks) */
+    tcg_ctx->plugin_db = NULL;
+    tcg_ctx->plugin_insn = NULL;
 }
-- 
2.39.5


