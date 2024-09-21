Return-Path: <kvm+bounces-27240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0FF97DCCE
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 12:09:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECE541F21E57
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 10:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE55170A22;
	Sat, 21 Sep 2024 10:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="njxzkdNL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D139516FF45
	for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 10:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726913325; cv=none; b=H1x2W6yopaUZOswrLxXcFzdWy6kXZI7a5+U1S2RetEnvoJdmDtqGpEBIst6rEgldyXfuO0NpnqDdBENdfSsjEOZTQktgFQslSMQsj5jPRmhQmgGrva6Dy32g3KhxAdfDeVNJF93e5sDpP1sdvbnYQ90sSwjIigLg7rB9CUWZoKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726913325; c=relaxed/simple;
	bh=IMfRddgxO+Ck7w1rZ7mJX/ULuUtwX0ZdE2OumGDsgHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODcWA90KO2AvCht4uhi+yd2mzyKsmwaPuXjsw7FKjmd8Vf/2tXvm/1wjHojFpo4rr5BBMOw3LC7oB1Rms3G4oJ53aNA4uTX8j/eNZnyuQX3ebrf9FPkjHWfE2wDV6RAfKdv7nlQV1QRJ3yuQyhPt6ib6gZ+fN52b+QubrVbcoW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=njxzkdNL; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7d4f9e39c55so2030129a12.2
        for <kvm@vger.kernel.org>; Sat, 21 Sep 2024 03:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726913323; x=1727518123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wKeR26fKWW24AqGwklYBuZ/CX5RZfiOMbUMOXvSoTdQ=;
        b=njxzkdNLBctPvYXNw4h2aiRnUyrxYdfjAiB7joKE3bqFA+ZyuREfqpihy0mbpyeu/l
         T2IbZvKej4l6WNNhJeuoiOrF8fopWLLiQCkayrPSlMHvOkGfF08fLsrk41uiFKX7m4iC
         u3JcJTEWFbyErOCBdF70fC3Vxj8phsodl7saWcVcM9lNA5uXGpvPuCZlTYDbNmkaqPsl
         Y4ZdQ4VL04oEoc57ZcQo8IMwSMi9/6+909wefdYbRmC01zIa65qfzNTmeiYOCLaxFsxd
         QNYStr4TkXNS2bhZUSKLlsKzzjOAHoA9LrlawcukvPKwjKKrhkyefndwpN2xVYEXjlgu
         PQwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726913323; x=1727518123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wKeR26fKWW24AqGwklYBuZ/CX5RZfiOMbUMOXvSoTdQ=;
        b=l1cx8ybbJ7wBSNldVGK/Xcb3yAxpzq5rFSDOGXRWXwRl7qkYSE2136oSNQfJ8V3JlC
         R6+qQtM2I0PzBSx7FEnl3KRbaT4pStTEYE1xXFDoOM9tXNki4AO3BNFoblAHYszqkD3P
         k2r3BHUvjzNQClLzgr+0+nKvalvTt5tnEINT0S0CXOlZ9wsqVks3n5I65TTDiondafr6
         pUyJ8Yr1bcz7zL9cMK0qWgmNfYmbW2prc+z5PHysemild3cpVwePk/xR3t4SvqXOMFEI
         xn2oHjzRl+Ha16Llt72dIV+GG1qkJevDqz3ShpA8FU9UoSkqRDn61cpx1e++giACdmM3
         gLjg==
X-Gm-Message-State: AOJu0YxbjbIOb70lL1ADwJguKJy1uiGAKAZYENyGJnsLENJ4Knvjpjj6
	Ap+klAlHPtNoaMzHTCacSpCZGIPZGX1JKVWy0ShhLbnCZjUS+N25EqO7zZJR3y0=
X-Google-Smtp-Source: AGHT+IFqEt+sAml1MwSoxe/AAbU+GYbDUS6+AJasT6OAnDfupYS56nbuVhq6qnLPs//IFiu9+aoRkA==
X-Received: by 2002:a17:90a:62c1:b0:2d3:dca0:89b7 with SMTP id 98e67ed59e1d1-2dd7f38132fmr6611862a91.3.1726913322867;
        Sat, 21 Sep 2024 03:08:42 -0700 (PDT)
Received: from JRT-PC.. ([203.116.176.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ee7c03fsm5680024a91.11.2024.09.21.03.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 03:08:42 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 4/5] riscv: Add helper method to set cpu started mask
Date: Sat, 21 Sep 2024 18:08:22 +0800
Message-ID: <20240921100824.151761-5-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240921100824.151761-1-jamestiotio@gmail.com>
References: <20240921100824.151761-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a CPU abruptly stops during the RISC-V SBI hart stop tests, it is
considered to be offline. As such, it should be removed from the
cpu_started mask so that future tests can initiate another
smp_boot_secondary. Add a helper method to allow the RISC-V SBI
boot hart to remove a dead CPU from the mask.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/smp.h | 2 ++
 lib/riscv/smp.c     | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/lib/riscv/asm/smp.h b/lib/riscv/asm/smp.h
index b3ead4e8..5d379a7a 100644
--- a/lib/riscv/asm/smp.h
+++ b/lib/riscv/asm/smp.h
@@ -26,4 +26,6 @@ secondary_func_t secondary_cinit(struct secondary_data *data);
 void smp_boot_secondary(int cpu, void (*func)(void));
 void smp_boot_secondary_nofail(int cpu, void (*func)(void));
 
+void set_cpu_started(int cpu, bool started);
+
 #endif /* _ASMRISCV_SMP_H_ */
diff --git a/lib/riscv/smp.c b/lib/riscv/smp.c
index eb7061ab..eb7cfb72 100644
--- a/lib/riscv/smp.c
+++ b/lib/riscv/smp.c
@@ -74,3 +74,11 @@ void smp_boot_secondary_nofail(int cpu, void (*func)(void))
 	while (!cpu_online(cpu))
 		smp_wait_for_event();
 }
+
+void set_cpu_started(int cpu, bool started)
+{
+	if (started)
+		cpumask_set_cpu(cpu, &cpu_started);
+	else
+		cpumask_clear_cpu(cpu, &cpu_started);
+}
-- 
2.43.0


