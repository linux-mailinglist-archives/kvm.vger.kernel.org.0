Return-Path: <kvm+bounces-12603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D8788AA94
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 18:02:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 942B41F6164A
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85307763FF;
	Mon, 25 Mar 2024 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="PgsSx5Z7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DFB75814
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380753; cv=none; b=TmhitJpbHwdfOP80+wvJK4pQznCfwrzaSybCCMjm1MToVaAzmMqtAyvcJ2Wxx2JIwTe5vzWiAJQ4TsCd91yBKrgdoixHDYh/9JjEK3mwIWD6r0cLQAlNxJPVyGmVMiupV+jS71syFuzzOJi85xwQdAoJB6g3pKnFnXX1uJsFKk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380753; c=relaxed/simple;
	bh=9FRLaj26Nbc3olJZoasXCER2j1jcBTOkVRlidkh9x8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l7aKPb7FQhtJD79h11eFHTHbGqoiPXg7jL11JaQ3obMY8Q804cDSFm5bu9oPOMm9ERtTh3HK/iz+CaH0mUfEFkl3r3HnGykGwQdw3umAsM26dgo1SvFgsXyCQP8mj1gfgdaWN0LgZPT74zDCI47LiNMUFZh4pzAIoplTwqKDEyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=PgsSx5Z7; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e88e4c8500so3114500b3a.2
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380751; x=1711985551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aX0lk9qzFL2Ep07Hy3NQIs6ID/gEGXEzWmEmIs3hZ2Q=;
        b=PgsSx5Z7qZFl8QAY+YrCdgXCkj1Vm7qLDcHqigWDaumR8YeV01GaX8paYi+UWSAFTy
         aa3w97dtcwIJlAO2iDDPMZUjPQuQA7bbRqpD30m6mxon49nBw0LLZsCcjDs//dDbmNNd
         CB36nfdiLTnT8ITl8VmmgzOQOCRcYENCq8hbEdjJuss1q8c/zxMgZRs/uRB/8roik1r7
         NGtYlxYHYiQfIg/6JegvOPOI2eCgVLH7T+f02xVmxBz1RarsE9hgGHV+fl9aLRoV/gcn
         ZFrR0tItzPEcykcSmQmn9P14NDlTT9v9LWPq1PsfrCcyoq7W3bVz3CTgcaTa1hp17PSy
         VcoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380751; x=1711985551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aX0lk9qzFL2Ep07Hy3NQIs6ID/gEGXEzWmEmIs3hZ2Q=;
        b=rOyou5uggZxJD1LQpc0LuyEunGsMJ6iJsRYkR/z2+UfWX4asfQL9UXFTfwIhED9xo7
         xZ/tCQYTVEtpgmUFxGM5XxfVw6Uks8oeRPRBrU4/9XgHL+rWZKtOPGB70+3H1wYTUa84
         CMJfqEliBNfM5uFFOKEUB5oinYreagcg/K2wgsB1INh4XIH26FfZANRXYKfsQAxEcJk1
         PpsLqBEa8wdQ4cYBlOqlh4gJY4eyComRpX5dZ12fj5qMSbsBryfcxotgCKlxCsbzXVwS
         nuQcEfFbI2RKGcrfxb/wsQKvmuXlfMgchE3HcLEZUXyP5bBsST6u3AJTckiauifRvv2b
         JqFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjeocGBb8Q0QQS9n9QT6zwzjpcu37PVRHhLpf9YkMvGDl0XEmKx67akPjUuenghFZBmfYfDt0DNKspn6F7+u+Craes
X-Gm-Message-State: AOJu0YxfuUkplhGiZbjzTGpwuWId0Rm7homcHCuAKda3rTB/xoCtpdv8
	66x6f3Ocs3ECdd9MLeZixg1/TDYivpoA5kqTgrVa40BZLd7YeAxeKU6laQOIVeQ=
X-Google-Smtp-Source: AGHT+IGNnAkuwKt6vn7OKTa0ZSTpr/iGu7EkAF8A2AIVlxqpdmpM6K3l/lqP5wQp39/ghE0UXoK1DA==
X-Received: by 2002:a05:6a20:30d6:b0:1a3:63fa:d0e6 with SMTP id 22-20020a056a2030d600b001a363fad0e6mr124456pzo.57.1711380751545;
        Mon, 25 Mar 2024 08:32:31 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:32:31 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 10/10] riscv: Allow disabling SBI STA extension for Guest
Date: Mon, 25 Mar 2024 21:01:41 +0530
Message-Id: <20240325153141.6816-11-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240325153141.6816-1-apatel@ventanamicro.com>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We add "--disable-sbi-sta" options to allow users disable SBI steal-time
extension for the Guest.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/include/kvm/kvm-config-arch.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 6415d3d..e562d71 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -186,6 +186,9 @@ struct kvm_config_arch {
 		    "Disable SBI Vendor Extensions"),			\
 	OPT_BOOLEAN('\0', "disable-sbi-dbcn",				\
 		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_DBCN],	\
-		    "Disable SBI DBCN Extension"),
+		    "Disable SBI DBCN Extension"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-sta",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_STA],	\
+		    "Disable SBI STA Extension"),
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
-- 
2.34.1


