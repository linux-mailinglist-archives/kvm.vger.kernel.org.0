Return-Path: <kvm+bounces-25628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2480D967146
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56C241C21785
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49DFE17E016;
	Sat, 31 Aug 2024 11:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="XRYQAP5n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3073417E005
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725103714; cv=none; b=rmwTwY/yycMrM5N0R3+RsUOVemQKhiaHmGiaQaBCSFwZuXyw8sDWTsqshXDqPjxuLnKeztk38orb6UwZg0ou7e6AUlid5686Bza+D/oRGEwLMKxvA3wHbWZ3VBRUSCVdONhyptj2yvDwpKfOe6yeMfreoCOoFR77hhb01KOX9E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725103714; c=relaxed/simple;
	bh=0QyBTci/u+c1w5nD16bwwlBepXxhFcrdPFEPFBNyusA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ21utQi/Zz6ImN9n7BIrwdpVY/kTwAY6brE3fVfVvtpVlM3WoiJ/R1rIA/R+Ww0zk3yMVD0WrlylVk1JO5unzV1PfStTtsqXCpOjYwsTSR+FGEMf2nczo/vIDG251cgZAC+DDtx5i6EaJPsY1cBFFgjEw6OSKI81u7/7w0T/hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=XRYQAP5n; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-202376301e6so22108985ad.0
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 04:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1725103712; x=1725708512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9W/PvPhY4YAzclM2JSelJpHbbRGL1br7E3OrpY+DrE=;
        b=XRYQAP5nQUqqs0OmyOqocEQM+qAxqZ/Kw1KbG0ShCrsOep2NOj/xza0WDzgEKt39hO
         XHmrOY3q8EBqK0xFXcvByeh9ZU1pnkno7v9fL1zDvv7qI/GHNHwy64E6HUnB6VpZX8eE
         1RjUfq0gzfvWH0txT7reBv8JjsZDz5sw42LrPp61/Tv65DBR52ez8mRVP7J7mefFrEMC
         FvSseDAMJw+iqPzWBUMc8Vu1d+LLqC6G8JCQ08NQqLlzJryHyfwFomCAKMHGP9a8O9Se
         RHYstSjwEE9IKEa1bt7K3EpDHkTFTgxjkqEzQhRaxwSaQ5XyfVpqTgu0vvqI0VEAh3Tf
         uGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725103712; x=1725708512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G9W/PvPhY4YAzclM2JSelJpHbbRGL1br7E3OrpY+DrE=;
        b=w66nyGO+bNw9WDbMf+/qnU4nzi2g7WyhdxRIcp/qDhypkTlF5SLUuoqmNyztejHSxR
         OCZ84z5a1YD4p19zQ5OA3n6raY8zjSCrvTlCtRBgXIN90s7Eud5EYoQLSfN1sX8qs86C
         m9CY+No6xBilUm566myUKjuLMLdmqcxdhjjsGmuDfzalNdISL8MZJe/ehyXhwCNRvSZG
         ziud4sBza/3CCWGRWjVf84PmkMPlIbECMuGVKkjy8eGEu822m0TSxU76IAwSwXCHkBRG
         +vR24S46LbPMBpAJpGnOX1kaAT8LxixG6/ohou8/j4R01zv4PN67PsqM9xQnbZ2mX7sM
         8HuA==
X-Forwarded-Encrypted: i=1; AJvYcCUdUh5SoCtmbL2+3inTaS8dbMGIkTeYeXr+jn2gxo5itzS52X2XA1ejwA8tVuLaqFmuyiI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxaq/ZvkiOQ5QuvU+YY5aGnkycXaeTN1iMRHbl7O9NuoXamJ3ow
	qy0uFvXQ1xF+leVOtCCB7XGPNyRmdTOhbc/+bZTN21lRbWC/zGkG9U5mYHHdp1c=
X-Google-Smtp-Source: AGHT+IFrEDhaUx0SUuyIxblepXLqKc+yV2RqLyxEoF9AakA78LY3iMIC9EnV+9+yK3tprr3uVNI74g==
X-Received: by 2002:a17:903:1109:b0:203:a0c5:fcfd with SMTP id d9443c01a7336-2050c215d63mr88151465ad.3.1725103712253;
        Sat, 31 Aug 2024 04:28:32 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20542d5d1b2sm11934415ad.36.2024.08.31.04.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 04:28:31 -0700 (PDT)
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
Subject: [kvmtool PATCH 8/8] riscv: Add Zimop extension support
Date: Sat, 31 Aug 2024 16:57:43 +0530
Message-ID: <20240831112743.379709-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240831112743.379709-1-apatel@ventanamicro.com>
References: <20240831112743.379709-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zimop extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 768ee1f..8189601 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -49,6 +49,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
+	{"zimop", KVM_RISCV_ISA_EXT_ZIMOP},
 	{"zknd", KVM_RISCV_ISA_EXT_ZKND},
 	{"zkne", KVM_RISCV_ISA_EXT_ZKNE},
 	{"zknh", KVM_RISCV_ISA_EXT_ZKNH},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 5d655cf..7a9ca60 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -124,6 +124,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zihpm",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHPM],	\
 		    "Disable Zihpm Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zimop",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIMOP],	\
+		    "Disable Zimop Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zknd",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZKND],	\
 		    "Disable Zknd Extension"),				\
-- 
2.43.0


