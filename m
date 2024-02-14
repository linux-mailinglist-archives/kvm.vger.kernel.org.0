Return-Path: <kvm+bounces-8670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 62883854929
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:23:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03DF9B28762
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C994A1C6A7;
	Wed, 14 Feb 2024 12:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="UJ/LA9Bs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7691BC23
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913348; cv=none; b=K7AMdRTXU4Mf0+1RLN37RARakjfPwCWN6IB/HXcni7V8FRR3vWNL0t++5ivBoaNuX+528dvDBpSfgttKsgHRYylrZH/e1PN3FajfAOI4nPZkFg/tecfgohWFNTA1RikukIXfFnGdfBLpSM5g6VZyewzQFqYh0O7KByw19Ri2eUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913348; c=relaxed/simple;
	bh=FM8JJcijXwGvhwqUGfo3hl8R96UIlvkLcMUirnZUWYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VLiLHs6J/B7buz/AgPmLOmR+CbPXP/KQzdbt8w2rHiFC/MmNpVh2vTtJJD6IXSuPsSa8PkKclX27C6a9lcMHPqtqe9ITxKSQucWhI2bXyUt5xE5go9nHZkRrTzGMoVO1ZpEVOM/xSVYDVX47TQLfYc4OBenUV7Kt4Q3jZNXeQfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=UJ/LA9Bs; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e114708b67so127683b3a.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913346; x=1708518146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9C1EGpCLcxou/YpDDLj5lw71FvQ1ltUDDgItP+qJmT0=;
        b=UJ/LA9Bs8ZO0BRgSRlWuDNYpjeFqfpZNsS6dYOH7BRJsWszL5k9e8R4REiQqByxg5c
         p7R0Sg0wwFYgrXgsoRQR7MhbC45jtk88bWcRn7kS4rUPIPt2kM/QEnvIbUjVaNleO5Te
         htEZnOw2lLEoDPwL32vyDXHJ1qEi8IbQjcYldb+7k3sZRqsrKT2k+on/MRONbpNDM7QQ
         IYkJA14cBO70BdVcswz+eqqHjG1rtM7QtzwsI7dMi0Jc3B6K2HGmPTgaOBA8zxiz//MN
         /SmoJclg3eGiTIYG43gZIC3+oSRO0vcmZbKA2qyQq9ODN+AhXJVbPIle9Kmo8eVVP38g
         a6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913346; x=1708518146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9C1EGpCLcxou/YpDDLj5lw71FvQ1ltUDDgItP+qJmT0=;
        b=hIFHLmEvDzKb6KtJR6JTRCF9tu1ak6TZ1ibIr6v8cOV2P+Yba5vYWS7ew5kkgo1nk7
         BlmJlrQUVs1Ggrcub7lU6E0gPzF4ErHx3QD3iIHLuSJWbosPeQ2paoMzaSX/mKnEkSpp
         F3gNrNhGJQfroCjQ5B0Tlbz8knErrwhuxnbzbu5lhBPtIb5UD+Lrg6l4ZwQoZ8m3Grvq
         kfVC6JeQIZCWnO+WBoF0qcBw33pNIM2Y5afzaSK3U+fpfIBVnusHpucNaCNbEuKr9NEY
         WI81QsL/61HEpWCTNbX1bGREmPxCpR6LiJMTk2bE1A4o53a6naal0LO6T2PShtcfRqJS
         7XnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVT+FOUMGHcXRYip9gbjJtfTQeLcYmVYMLCymnN4jDdFsDeWuunZDvEN5glC9RBieQTu0JMJQNQVn6dZuYBC6PLgFoc
X-Gm-Message-State: AOJu0Yzz4RDgSqUzr3hUyXQtj7tohPYmTE4+LfhexeSymvm36hHln+Gs
	4nnKLqNHNIVsObcgthl8y+4VM4zJyg5QE5Epqq+r1oMHzD3SP2SqlzT7Ru3ap0c=
X-Google-Smtp-Source: AGHT+IEd9EmDHvdyrl4sNbWVOK7l4DrpU2Vek16busKhtxakrRGUD5bghoZIvvWTdAi53btmngg9Og==
X-Received: by 2002:a05:6a21:670b:b0:1a0:5a2f:bfca with SMTP id wh11-20020a056a21670b00b001a05a2fbfcamr2261950pzb.0.1707913345939;
        Wed, 14 Feb 2024 04:22:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUEP9cFoCcRbhytiU7SgBrNLRMTvsUJt8RZhPOFRupZKHPosbqEXPH24R1S9LvEyvr9TQhyQBMB0QzTMSOQFuC+BaUbKixR8+x3FOxUKBzyrZqWdiEBasYZMncViV5tQUoGHXU6OJdbSM1phk1I3gBVtFKKdrJtHsHl6FjOp7buZvcXs3sQhzNqYJYMNhwFIUbf1eO8oebQnOqM9lpk1rd4SSdXQqbD/ReiJ0Tr08RGA40/oPUVocHgRGg8t707Sxh6fc4aWj1FVMoV+CW99RMW6lAxt29t6WAnF9DgjZZLZGo2/UMr/cchZcJF32Ur9w==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:22:25 -0800 (PST)
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
Subject: [kvmtool PATCH 10/10] riscv: Allow disabling SBI STA extension for Guest
Date: Wed, 14 Feb 2024 17:51:41 +0530
Message-Id: <20240214122141.305126-11-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240214122141.305126-1-apatel@ventanamicro.com>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
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


