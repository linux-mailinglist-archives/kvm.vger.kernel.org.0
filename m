Return-Path: <kvm+bounces-19471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE84E9056FF
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 17:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52B2F281A8F
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 15:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 053C11802CE;
	Wed, 12 Jun 2024 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SnRqwwB+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D698180A74
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718206515; cv=none; b=ZOJvKUdw8D0mOXen7TodZITo4SudRifT8LlVqAkIgkVkiyWuGuw+iSmAip8YFlqof9KWSY0+3m5TcV6auU9bH22AzOE8GcGfkPN39lGDcvv7rkggcaLoejA57CTD3gXTaC3xY7cAg+qRZ4DXBbVzosPvrgiHltEzrfPqvJ346qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718206515; c=relaxed/simple;
	bh=0M00rXsrO6MkSaLCtF/pVIWAbiHGBLpMU9mQ4Bs4H7I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RvkOFeKy9Lsv3UHDh0pEzgXlDf0BiA1vsk2Y5snQrYKbFWaLDxiq/jvTsZtXb9+kirE3FapKK8AV8lYRUI6xcb/5dcTMnp3qqcWp1ZQEFYQPW0sKodYy2fkbPRn+Mv9gLLMit0fHgvSdPN3KRl9LnsuXB8AFYOiMsr0cNkL2OUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SnRqwwB+; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a62ef52e837so106466b.3
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 08:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718206512; x=1718811312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0UFHAsoemA/1ZyFVkieFp/Fehtdb65Sq2hGoqSQrpDk=;
        b=SnRqwwB+pVL2DthNgouwYjz6Aq+jGH36oaQKVyG1bihxbnYwqc+figjvj8TJhTDVoh
         wKPJT8XNYI19F1AUyD19AkTqEMPnvaULe+r5iCa3w+NOLxpiIAAGeYYcWmLFn9idEC/3
         1GN+aTUbVAO8ZxIavKRkuX2Rh5zP4WppeHsMmjuRRmik3wGVhx9Fsxkn6SOsbgnP3v2e
         NKUei4t/UU5uAvlsIuzhp8tDq6hkeS0UV2djU/w39gpRU9jdt60/J3dgzTm6BXrQrYhp
         kbPZZ2dE+LuMV4CPPa4+ZuY7dpHVJQw4Djk0X60fpyvU8DXQvQfCw3ftY26eTzmfgvec
         bjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718206512; x=1718811312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0UFHAsoemA/1ZyFVkieFp/Fehtdb65Sq2hGoqSQrpDk=;
        b=pnBmgobt3HZ0eijrj5USh2TxH5YC4X9ov0t3Je+6fQwVkFW/M63styJ65Ja8fe0gKb
         OyhUHhdxHkaBLyfHgPjmrqKw9FULlZo4crRKppskui2g43VRd78OTulEq/CW+ECr2kRm
         S+WnVC7wq6LEW+cRig1QAweqvGTSF4s2N7Ds+cB7g3HML1fcHimwQ50jx1NTgWlJ06gV
         o76d246xPl58ZfrtdpRADhE/TWtHOa2XiRfUHDvIYPKJbZVEpAm2Z1r1zHblA9sm/6D2
         B8ns+l9V7MJxZf8Loy2p9ldDDIZ7Da54Vauv/d/KRa4cIJqWY9X0eYeIYJp171ruhasQ
         ivdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGbSSlVSF0rdbEG2S8E12kQvyIUgj2IRby082BdoMSzifZevPbYZjilXuC32w3qfnNZHY3ZbEZrToCRI6GHw+UHR+Q
X-Gm-Message-State: AOJu0Ywe4RwRQt+dzUSw/iVvjQxxknu5WdhUwjIuowCIrcBjWNbQpyCU
	mN7HpTwlww7jrlFECUnPFh6pjzPKBMEogkVg4DhkLaNnVbqRv86jTQhn07eVfwM=
X-Google-Smtp-Source: AGHT+IGNS2xktjqcOrTpVg66Qr2sh2nrR4+EQZaLWm4leOeKKyIa1XGx1bZYYSow5mTnEGpMAhUn6Q==
X-Received: by 2002:a17:907:7756:b0:a6f:4f3f:e6d8 with SMTP id a640c23a62f3a-a6f4f3fe75emr48893466b.20.1718206511842;
        Wed, 12 Jun 2024 08:35:11 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f2195a2a3sm370298966b.99.2024.06.12.08.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 08:35:09 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 784465F93D;
	Wed, 12 Jun 2024 16:35:08 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	qemu-s390x@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	qemu-arm@nongnu.org,
	Alexander Graf <agraf@csgraf.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	qemu-ppc@nongnu.org,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH 3/9] plugins: Ensure register handles are not NULL
Date: Wed, 12 Jun 2024 16:35:02 +0100
Message-Id: <20240612153508.1532940-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240612153508.1532940-1-alex.bennee@linaro.org>
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
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


