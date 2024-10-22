Return-Path: <kvm+bounces-29379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC5F9AA0C1
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 13:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FA88283A09
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6AD19ABCE;
	Tue, 22 Oct 2024 11:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JltsfjPB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553BD19538D
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 11:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729595039; cv=none; b=B8VdohvBxt3AIsPmtzlhURRHIOYm7UdHAflSn+6P/PIi/1BbXH2dCgXh5ogdezSN2Yz1Hd6L2CE9v9oJZ/JR8gOJBtdlJIpIQldG5I9yXp+WCwe6IIkLP+0rW5F6CdM+BKkdzyb5JD7oo0SV3h5RuVPdMWA83bNmXbf6Y65TtbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729595039; c=relaxed/simple;
	bh=5yTCZimV0gEI7gmCOKCJLILXfJ8kpMTOraKSBNxiVlk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oY1k8NKAuCERNcVaVkIRziaUC9JMueJRrx2ZUxiK66AI7UYuUAzFuM5uC/0tKFW3eQjHhknqkP67bzi9FmUudhYS113Jm4+AKY0h0RlwhW2AiRKHoNWr95Sp3+l4rSt4HhM1+VFT18lyIGfAa/tAGhrTb4DAS3iLBwBHC6vHAnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JltsfjPB; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539d9fffea1so5223374e87.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 04:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729595035; x=1730199835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yP4SNsaEappmzZc/gnms0PRD/uAmEAQCRgu6RQMiI8=;
        b=JltsfjPBEY7pYsTjPyFgizxiaTZB4NaAqC63Ip1HBIfaHuiJRRl7L+ZIDrAHNVzJzo
         wklN2U+BM9yssiRESQSFtD/iZLQYJGdEAuyZ9cERa0+z19rv4zDB3B7jbcFttu30HQIU
         S26S1MUNykxg1cX8kkAXr4JXSPmNzFTFDyVxlGn9sOr1nlv0Yk0cM198eYS9DCMnQbV2
         zJ+cbal1v/sD9vJx8eSF8T7WRfffTolvOgVMmFfJcd0AyiyLJeAHl71CubjjNayZnfL3
         wPtVfxDYjQi1HeYvI/+iLCD8vU/0gM4/VrcWi1aQb81wxJOPsStWBHm83U81TAqjML2G
         wTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729595035; x=1730199835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yP4SNsaEappmzZc/gnms0PRD/uAmEAQCRgu6RQMiI8=;
        b=Xx3a4W3Svtgw8+0Vm8TtnJhcekCWxzzO1Hja9dFVpv8b5Rb85Uz6yu15YtVGcneqWV
         aGJYlLUVLGJpk9n7PO8QzMOgIiU6orIABAg7kq0RqADn4knkoYhZvOgqSldqIXuuPkBc
         PYS+YNTDdaQpcKiiLal8aslxEPIqIydfFcW1dHignlvIY/daD6AAsOXGyB6w35rOXw36
         6+aeRCSCZqzxxsbiU6jXxybzexbz+TDpkGWUBQ1jVyZbGU6NfOcX2U7NvtnqH1p24Std
         Qh7npDLJUA6tng7JCVijPhTQJi8RUNT7NL4JSrx8lN60UnEJ6wCpRuxhw4VJPOsojr4X
         tjTw==
X-Forwarded-Encrypted: i=1; AJvYcCUebO25dmJ5/Y9Kc1dXINXrv+uZJxyAi1KnnE+ydR4nMjS/fwkXQan4y0k6A1iDss33BJE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX3JckjvJp+wPK6ZyO2xQoMhHTBCJa+lcRzC6PeLYNF/rSwC5J
	HdKLSIo82fuJt5Qc7NTOr6XV2gB1a6xSjHFSz9WssPx7pxGp6DvtLrPzcSHMNPE=
X-Google-Smtp-Source: AGHT+IEerx6lkR1+H7tItyS3VilRAHodTVWStIRDZTkyjhuKwUz1Vl6o1rNVP7ypMvtICJM1uC4+EA==
X-Received: by 2002:a05:6512:3185:b0:539:f65b:3d1 with SMTP id 2adb3069b0e04-53a152198c9mr7757327e87.21.1729595035308;
        Tue, 22 Oct 2024 04:03:55 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c6b120sm3010139a12.59.2024.10.22.04.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 04:03:54 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 62F045FC48;
	Tue, 22 Oct 2024 11:56:16 +0100 (BST)
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
	Robbin Ehn <rehn@rivosinc.com>
Subject: [PATCH v2 20/20] plugins: fix qemu_plugin_reset
Date: Tue, 22 Oct 2024 11:56:14 +0100
Message-Id: <20241022105614.839199-21-alex.bennee@linaro.org>
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


