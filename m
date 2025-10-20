Return-Path: <kvm+bounces-60466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E09EBEF3D5
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 06:21:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 419124EB2A0
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 04:21:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75762C026B;
	Mon, 20 Oct 2025 04:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Fy+PcwA7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879BA2BE7CB
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 04:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760934081; cv=none; b=Y3sjgVPPEtym7njfXtki89x/JyDW7EcNyM8z0V+SnglRnVZuzldQcBkHR7/TjcTpoE3n7WxVs/e7eFO16OK36mqEoq5S9i/6QroVN6rCiBnkWFEQgCQLCkmlr/75skd0mjVhw9g3pb5olx8/7vTKbRRuSZunhU6HPKhr0red+38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760934081; c=relaxed/simple;
	bh=AHBUSWC6NQwt5gipootBG6lu9YU2EyCEcBy5+RZx010=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzVejydOH0xgn71I88EvinkOgi01qt/Y5TKRP5gM8h0zekOxlNvN1NoXHtIbNaQwm9oOy58PkH4aCzx0c7BSqslWRVaSqmvD5Mmao3iTjsT5tlVYj8FPjSOHN3iK4Gpv5U0ajcx1l1IScZ9Ynr90bG4ZPX9Ctvk6rwHKswkfxGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Fy+PcwA7; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7a1603a098eso2400046b3a.1
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760934079; x=1761538879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L4l4TBk/LGXRpjovIOSrhrLfanQNTxjIirl6+Uo+sE8=;
        b=Fy+PcwA7DJKVPgOFHkiOwNGCplaBhivkMWy6/hJY3vkJxrEQDOe5fH4wdDZxQuxdxM
         ODhGgX0SoHcvmHlc2xHQt6Ti199e3tpoU9wbX/omO0rb5AD4ULCVDe1yIrySnt9U5JuI
         EhUASxzV0eiUJxqKzxDLCL43n0DYeH68u/kr+PXngWRcm4yuNyVX+3WdsAZQ9QKCJPv7
         z/T2U4ZV0LspgeS6txCi543sRWb6EONfCRvdw8z4brMix3bYh/LSfJBe34RnvGkSLyJz
         OSOoUb07JHJQI+E4FWmc+xDzS6DfCpvwoYayVwcD9wF8WL09hKsrRM2SxQ6qjjDrHo/f
         7oqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760934079; x=1761538879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4l4TBk/LGXRpjovIOSrhrLfanQNTxjIirl6+Uo+sE8=;
        b=AFgR5BNaA/fiQoFG5yVvRazNG83W4vL7mYRhTeAccdtfbDHBPWDoaGxM0ZVkEXEhOg
         8L9y0m54CIzUP/KzcJwcQKlT3AaCqiQtBZec0iGXiMTaiAe7Gx88XvraksPE+Lhp4fd0
         gIk9szXxj45PdRctcmXQO47Jg4b6MBbJJ1R1swqwomJPpMcnlJVbp0DVMlYMCMTNviGB
         VBgAgvrxkqTcR/NgFG+DItPB3WEEGQA5r2BIc1nOg2zzBUF1jhvCxS2ZWXjg253C8SBm
         T6LDWzaK+oxbROlVdrjRUVxD2LelNPvwPnAnZ4bjKpqrFIdr+cYwFjMC7MITSwGieQPl
         QCjA==
X-Forwarded-Encrypted: i=1; AJvYcCUlicN6dwdu+oY1UQcGLu0ngCa9dbznLpKehhcXeUC3bsr0W8SUbfqxv926Jjc/wKQbSvo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiMtZLgf3PyNt/De3zPad3mD4QHZHaYP4tqEq6FJTt/DGWlUHc
	X+z7cAJ+LHO60ZZUjVcM0jYSg5qM1/SLqCOPPhzucr9qSy7P9asYeHADV5Tmx+OToAE=
X-Gm-Gg: ASbGnctJe1mMvjKuj1rTdK5eGyHjx+ejoFnJ29NTQx/4fChv4AkowuXvv+Fp+xvXryk
	QouvRQ0OUBDRQdRDdSOq7J2DWd1QtX66b5CN3ApsK3f1T1AEOr2oI5sMOzn5FWz1ip3yGDXQqOU
	VLiV/PSGEUsqPct3jygq5iWoi7wt49zTvi1aRi9sIIwSLnWkUQeN6Asf649gjjcPFyMC4uNxSdo
	Nk/V42atAhzmUw1FLBXJZ9LoPxPmtYlMBS+aiT9nUU3gLroNKLiFNIMkjWYfq4ULv9zJV0IljUk
	swZ3K2DiGnsfC4WIWZqLCOo3aDMmm1+T7xkuVAIc98OCOsyH9i3VUaNbEqSWJtKaT71cmOpmW0M
	CWZcbBogPFHZcwXT/jB73VtzF/c4UE/mLi0wCkbqzvm16KpJUXuixsRWeQiiWRpTTlZnJzeQCoP
	+XOf4pKrModehuiPjDV2vWuz3L/iacmDbTjEmGvkf2zhOb1aqCScvbxI9teOYEbcIBTTtKlpMvA
	zu8k1vnH70O
X-Google-Smtp-Source: AGHT+IGSr6CeYbnbhFqLb/PEPw/yfGu/4coKFj18cuRK0sGNHLwIgZvYXiVeS+ZT8M8+GdgG4XcYZw==
X-Received: by 2002:a17:903:120b:b0:290:cd5f:a876 with SMTP id d9443c01a7336-290cd5fa92emr146909545ad.13.1760934078867;
        Sun, 19 Oct 2025 21:21:18 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.55])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29246ec14e9sm68762035ad.9.2025.10.19.21.21.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 21:21:18 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	guoren@kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	lukas.bulwahn@gmail.com,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v4 01/10] riscv: Add ISA extension parsing for Zalasr
Date: Mon, 20 Oct 2025 12:20:47 +0800
Message-ID: <20251020042056.30283-2-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251020042056.30283-1-luxu.kernel@bytedance.com>
References: <20251020042056.30283-1-luxu.kernel@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add parsing for Zalasr ISA extension.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/hwcap.h | 1 +
 arch/riscv/kernel/cpufeature.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index affd63e11b0a3..ae3852c4f2ca2 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -106,6 +106,7 @@
 #define RISCV_ISA_EXT_ZAAMO		97
 #define RISCV_ISA_EXT_ZALRSC		98
 #define RISCV_ISA_EXT_ZICBOP		99
+#define RISCV_ISA_EXT_ZALASR		100
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 743d53415572e..bf9d3d92bf372 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -472,6 +472,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zaamo, RISCV_ISA_EXT_ZAAMO),
 	__RISCV_ISA_EXT_DATA(zabha, RISCV_ISA_EXT_ZABHA),
 	__RISCV_ISA_EXT_DATA(zacas, RISCV_ISA_EXT_ZACAS),
+	__RISCV_ISA_EXT_DATA(zalasr, RISCV_ISA_EXT_ZALASR),
 	__RISCV_ISA_EXT_DATA(zalrsc, RISCV_ISA_EXT_ZALRSC),
 	__RISCV_ISA_EXT_DATA(zawrs, RISCV_ISA_EXT_ZAWRS),
 	__RISCV_ISA_EXT_DATA(zfa, RISCV_ISA_EXT_ZFA),
-- 
2.20.1


