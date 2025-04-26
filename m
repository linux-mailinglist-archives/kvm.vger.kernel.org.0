Return-Path: <kvm+bounces-44404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C815A9DA4B
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ECFC9A2750
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498F722423E;
	Sat, 26 Apr 2025 11:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="DzPMBd4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234A51E519
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665459; cv=none; b=AZnizZwbJoMFqmY/1f9MWSz/j199B8oGe5OlEDv38vkqbI97RoIEhxi5ZxPopRaHA5tONcXYDtqfODFJZZ66c6Pwizrg2+YsqrQorKpJRa7gtbeESpXgBkn3fQsTSI4QMYo20hzm0JRRgTZCMUaGlnjLJ++4XCy1+Nf08iM/lXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665459; c=relaxed/simple;
	bh=mM0z+Py5asgRfQ7PGAt/36YgTUgSINGwQ/hKbI4b/Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+j9taVurk2vwttxx00qP6dWSVhSu1U6d/SeYuMkzxULlwkYUA97bNG2f8VF6TLO+5mGPl92sMYN2tPAfHTbNkS2zm7jcK+4SJxOqTYW4BT9C+kyPRFyhNKUSf81vrT4ArZJXIPftaDWFXHo1HKbVlcpu6X50dzvLN4zcPc4smI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=DzPMBd4x; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-af28bc68846so3259465a12.1
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665457; x=1746270257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izVZE3MINqb+sB5P+aMg5WCU4bsWOfV4in60wkm/uDE=;
        b=DzPMBd4xbCxjBd3REi3PexGoYS/65LvvTTd/pS+D65Fyv++I7z3DoqYzgRK1thl/m2
         NZXHLHmXwLvA+Qdzt792Xh4g8OugpjyiFUWK4wCqNOm2J8VWzjmK4e9qqwCzw68ylLIZ
         Nj4wwdjjOGPnN54Z5RVYPVoWDgbUNT121yPewTA2/+UqznnO+vlnnW2Ovyrj/Y9FCDNB
         mRgk8LKiaJPQo7ZgOZLIU0oMU5lkmZGUuc5Pb4fYJiNNX1omQFQLo8V2ZdOdwv+NPRUk
         UaCxy5A5tjeFIIiDeZXka6co++1zTcYMi+UNsgAyBU5lC71pJ5hE7iCjjLWTkjYL/T7w
         g5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665457; x=1746270257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=izVZE3MINqb+sB5P+aMg5WCU4bsWOfV4in60wkm/uDE=;
        b=ww97KRHL6DuJYwfjWOCvvUd6DpIFyMoWbdteoHEBZOhBeZ6HNTuLZ6/RlcGmsX8LH7
         cskb1VqFDj7KKIA7Mkj6o6+5oPEcNmoc2n60TOxOJ/yioEhBA6Ki+nyHzRDE34ZzfI0P
         /mN1slUHbEf2PHKraFXdZbzjBDZtIBVAaBT4wekPGLJSgIvswts7QO4Zh/Ue0xLHr8E6
         kUtyKYMhr4r6lRb5J8bz21bDk2TMc9IityUIpzZDgkQOEtXHBKla7IayQ3m9NafHOlso
         XJlxg8hfD2J43XqvP1TS9gPaj3h+yss+a271OgUeMNkbqF9Pft6u+XT+0x+6Vh0WgbIg
         5mag==
X-Forwarded-Encrypted: i=1; AJvYcCVsYH9Da44C+PJxd92MmDqdZC0oO0e0Pg9piTVABdLHPX6eUeay2G/8QmdkxeszBqJQD2M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNaY4eV87r/1VjTyGrgRdR48vvkLRkI7tVlVlNOC7URbhG993p
	RGdVIyUMsJ+CJoYSvbnIghk4ka8bDHUyLnbU3Dt7buI9Ntobm0mC9y9STSfpBIA=
X-Gm-Gg: ASbGncvdOl2rC6S6Cmt93Q/OLiDxy2N1JC2816h2WWEjmf9CmxP0cvbHgPpnCEtCPlg
	9daufh87YOB8RbrCO+bSKxCOKdNe3efSN+T0Tj3k/ylLXlEn6VMIEzYWCLCcem6MLjX8fa8QQnI
	Nr7O8QNzmmAOnxlCvNCLbMJxVwMOMzonl2uGgZgxD2ntoX1pVjfvMQ9/lhTqRT8RUHWe6CAZKmH
	83mW2taH3gjh/rQhFqG5qkmveEXqlGuM3eWq6Ynh2qUwYczc0mUfyQDkvDToyJ+UZX8VG9Ob8hC
	n2ilulM54Aj9XAkv/DMhQPutycZiS7cOufR3NAPnrZrhMs7AUTN9szHuJASc1MxcuNuu+JYt5L2
	39jZS
X-Google-Smtp-Source: AGHT+IG9EHq/xB2zNOXuLSF9BV0SIkfLVwrgKN8lCCWUKGV9wk6lqP9f2yss0VbScLNDw+w5niQchg==
X-Received: by 2002:a17:902:fc46:b0:224:179a:3b8f with SMTP id d9443c01a7336-22dbf5fa5c1mr85746525ad.23.1745665457249;
        Sat, 26 Apr 2025 04:04:17 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:16 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 04/10] riscv: Add Ziccrse extension support
Date: Sat, 26 Apr 2025 16:33:41 +0530
Message-ID: <20250426110348.338114-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Ziccrse extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index ddd0b28..3ee20a9 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -48,6 +48,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
 	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
+	{"ziccrse", KVM_RISCV_ISA_EXT_ZICCRSE},
 	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
 	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
 	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index d86158d..5badb74 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -121,6 +121,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zicboz",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOZ],	\
 		    "Disable Zicboz Extension"),			\
+	OPT_BOOLEAN('\0', "disable-ziccrse",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICCRSE],	\
+		    "Disable Ziccrse Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zicntr",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICNTR],	\
 		    "Disable Zicntr Extension"),			\
-- 
2.43.0


