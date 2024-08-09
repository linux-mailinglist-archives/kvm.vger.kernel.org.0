Return-Path: <kvm+bounces-23693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4866C94D15A
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 15:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B88991F234CE
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 13:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA10195F22;
	Fri,  9 Aug 2024 13:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="iOiyH+/+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BCA197512
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 13:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723210499; cv=none; b=ZRwULKViiw5j1J5NEHXXue2DSwpwwrHMo176QpytbW2dYqSZjl0szmSE9H9Wm4qNG0rRUlwlK8UvOlxo0tdlEdyD84MAlRz+qFNT+GjmldP3KqROO8EPU4U/jIp2sBACkzx+LG4F6wki/kGyQRg9cRVlJZC6JZM8AbJ4vkSgsRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723210499; c=relaxed/simple;
	bh=fy1jkpYpkE6qm2m79ms2b9vDyDR5YEymMlq2ISlxvCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oHseXIXvcoaDq6q4ybbDR/bTROExyFdTPCCdRE8XK+pq/VCBtol0JVEuLIUUVoQCtQahzPS8bR9ivBabIA2k3TUnMA7G0qyFtodmcdVYGtVjwPnV0qhjj2uEu62xV68fMfuceZmxPT0Z6XgCF0b80RBm6OdPRcTJ9V30EN/BPG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=iOiyH+/+; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1ff4fa918afso14046405ad.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 06:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1723210497; x=1723815297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oINtVjqt1HSId9RPGFIf1FQmhq9XpHG+7bXI6iFdSBA=;
        b=iOiyH+/+o5Se6kGwk8wjL1EUnzxYkc1NalTDjQ83hzomVvPbb7F3rtheXkEHoWreUf
         hAWQ8RhQqdxEwZkrGRmgGqUDabxbLveqXE4NaBeGib/MJccwNp367BbaqZMHYUxO9Kec
         GoomvY1RURndgdFPKWtYm/LerlSyvs1ymV+HQS1YNEWK3VdIy+PZDz0KjIzfVLs6dqAD
         Z1p2DRsjocHlBcBhy2zLPlaSAGSpKCb1lgh/l9cX6hh1/LJhez5lRyKjZ1wXAuDzakAk
         lvRUmy5yPKhJ66GRLuT84yEHS0lOmwgIwsINETa08ISaxfXQiy7/1IClkZ2zvSHulM+I
         ugAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723210497; x=1723815297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oINtVjqt1HSId9RPGFIf1FQmhq9XpHG+7bXI6iFdSBA=;
        b=SXz7EvYZdEg1T5+jj8YYbLpHzfo1YfhJqn/u54uM78uKXMNTOvJvGocqCIBipipdt9
         FdTLykx3xzoUjJfFd97cz6d+uBBTkEixAuGxo7Zpw/RAr+mZAv4FLwtfiLKbKJmmpu2v
         +38mFAjdN/he5uV71HcdEcDV97n9V1fRUSRcPetCWPuFIixHLKJ1zcYpvC8VF2T2/SDG
         AYWMMedIU7/7i4evvdOlPRf/Z1qsZSzNF6mf6HE4O31GR2ftRmp0oo0pxLwMFWzAJ+nE
         0bYX/Mpvqun0KSqX320rslYQQsbxIojll0x9z+Q2OVbpYUaykt/1aN63VNrGaipXB5+Y
         xJog==
X-Forwarded-Encrypted: i=1; AJvYcCUC06PhcC5y/DsXy1aUm0FmV7Z8rRHqsrh/C7YqgsAYq4K1SvLJ8Fhmcs640UMmBBd+3usIQnSWIEDt+bjc3OT07AL9
X-Gm-Message-State: AOJu0YzKCueHnZITkWOGmIcqwELjMEUsESfEWdMHzB/G9aFwvObLMstp
	gwxndAqAnRkyi7cXvHSA5R6US/og6cOoKwdD+kJe83m8u/+/Yt0sPsCkbTwfdEE=
X-Google-Smtp-Source: AGHT+IHExaHn6KWfbZBKG3BC7NltP1BSB+1w2QjEnUOn48ApT2+REQEbjebTl6WS/iOKckRayd8UYA==
X-Received: by 2002:a17:902:e885:b0:1ff:4568:652f with SMTP id d9443c01a7336-200ae4bb4cdmr18679395ad.1.1723210496742;
        Fri, 09 Aug 2024 06:34:56 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f26f4bsm142107075ad.34.2024.08.09.06.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 06:34:56 -0700 (PDT)
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
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 2/3] riscv: Add Sscofpmf extensiona support
Date: Fri,  9 Aug 2024 19:04:30 +0530
Message-Id: <20240809133431.2465029-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240809133431.2465029-1-apatel@ventanamicro.com>
References: <20240809133431.2465029-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Atish Patra <atishp@rivosinc.com>

When the Sscofpmf extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index cf367b9..e331f80 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -18,6 +18,7 @@ struct isa_ext_info isa_info_arr[] = {
 	/* sorted alphabetically */
 	{"smstateen", KVM_RISCV_ISA_EXT_SMSTATEEN},
 	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
+	{"sscofpmf", KVM_RISCV_ISA_EXT_SSCOFPMF},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 17f0ceb..3fbc4f7 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -31,6 +31,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-ssaia",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSAIA],	\
 		    "Disable Ssaia Extension"),				\
+	OPT_BOOLEAN('\0', "disable-sscofpmf",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSCOFPMF],	\
+		    "Disable Sscofpmf Extension"),			\
 	OPT_BOOLEAN('\0', "disable-sstc",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SSTC],	\
 		    "Disable Sstc Extension"),				\
-- 
2.34.1


