Return-Path: <kvm+bounces-45464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF06AA9CC2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:47:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29F9F3AD495
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD40426F44A;
	Mon,  5 May 2025 19:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Iqwdar3u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BDA158858
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 19:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746474423; cv=none; b=SJRZQhF17NvoaVciKBI0mVZYYgOBpJXEo9vmjNtph+J4K8qyBPyKpnmHSS/UtKr4tX0heAZWOJjWScL//yJuGmHcpAJ56N5MBh5KmMZyAjNfC2Ja7H2ZkEz+Wx6y/z5Og+nYkzyCKFX4+maOk0nZNCCdiCl9bXEDsNnhchRDF94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746474423; c=relaxed/simple;
	bh=gHO9fquV+zDgJiymZ5293Xw5P7vTTrARFXDIotkcy9k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=P6MhCgeVrM3Rj9VYIf5dXlXNqdLkidePk/hjK37yWY5E25bYR7UnvfA3otp9Ngjw/hugBbvoN2fZq6P54J1chf3WIfynfhc5F9pqmFP8bHvg9rmX1unuS0G67f5AdWqiWq3o2VxHmEIStic0rEbIXZdj+4m7OHWQ+tjj9bvYf2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Iqwdar3u; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-309d2e8c20cso6317486a91.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 12:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1746474419; x=1747079219; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Plt6knEw0shoMZnzf8M4P2C9rMIfWDgHR7NQgQL6Uzo=;
        b=Iqwdar3u63rvXa/MpAnbXNYy19YZgJgHnzUCcqqyT/AL1sDLmL2rXYakDMexVBeliY
         VQLE6YPgzO9gmmcnlHxWFCnogLzKTtGcsm4rrB1qWRmVCYuebWSfWHLxbo1XNo05eiB6
         lDFpXXbwoPzTIMQdAYWnIbpGw3zQY3jB2KeUOO61D/dQwv2PkfG5eQVdKnmreFGjFRu3
         6iecEWgFKjfi1tULahqk6Dbov55yRCEYw+kkGS6Df+hyRyNbUswFZ1QPdHY4+vhTZlN6
         FSKclSTSmlbUP1/j9orKZ++7WKnOsGTP30F24JkZoxIMHnWNMN8lM3EE1YIDK9MFMogC
         MccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746474419; x=1747079219;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Plt6knEw0shoMZnzf8M4P2C9rMIfWDgHR7NQgQL6Uzo=;
        b=qjDPdgxygqK2HYluocX6EApEkelm8HI7rNYt+x6ixgO+or7FYUnsflgZr+tbSr/JOy
         rXAJY+HuiZHXkLfOoQOYYUtR7d7gQ18TqZvhyir4pholcjmJz/qASxltLDE4iEo721bp
         PFGjVY4/c1oYqJW0tHI/xK+N0n4hook1CPnn1K8Q00+UnQLaF/O8XMQf+Xevxbv53rNc
         goZnK4xpfR4Sv5OPcvT2TZxXrxi439TyqS9UagtTkhZ2RekCN+z6mn28UVjXQDXZ/F1G
         oJFekL6gF3Und6l47jXg6z1RdzNbU6Q+wvss627j9DKZSuGisC4f4b8IzQ5L+ZnVc+An
         KoiQ==
X-Gm-Message-State: AOJu0Ywu8GH+c22EgEJ2Uomwvsutn4jk2vd+H0gdz40lea8sHJvRxgbo
	K2q4hjhGfDXdBHRjUej1BnSMz6L9FcFstPdWNzQPXAyfL1hBbOSlGd5D2hXfmvPD28f0dThLQzI
	g
X-Gm-Gg: ASbGncvh2fPVxq5aNLGrk9v9l9Sljt9vSdzgb3fnW53J6Ko8J0GRCqllYFtl/PimCbf
	ouWHBk0l2KzYTCpkU6FgxlZvxDV3r7qExZqbvlVDSOGzsUtFJOJWXqCsFuXM6gj/lhsZ/Z7ANzM
	0wVsovDJN3e+WiQH+XdULOIu7MfVKntD+p5+QNXbR3PE0EJ5xS4PJVpFf6gHrbLobCl6fMnTGUW
	ThXyRYMCLwOywNnBa0wRr1tjErwbhSfBKlfYDS4Y9exJCvntvj0Ylu1UqaHfqgMPFtOnJBKBZm0
	kEXFu9Et+NZ9fGYpdHqPxE2m/6qkMTN84Lh6Xit8IWo05dwscnof2g==
X-Google-Smtp-Source: AGHT+IF9N2TMIjAxtdrrQ2QWC7apsZXf1n2ya4YvkWtGuqNlHbY6PxtJ98wUVfZSK5UimT5DfxWc6Q==
X-Received: by 2002:a17:90b:2744:b0:2fe:b8b9:5aa6 with SMTP id 98e67ed59e1d1-30a800a11cfmr172541a91.31.1746474419573;
        Mon, 05 May 2025 12:46:59 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e15228ce9sm59083085ad.163.2025.05.05.12.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 12:46:59 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 05 May 2025 12:46:53 -0700
Subject: [PATCH] RISC-V: KVM: Remove experimental tag for RISC-V
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250505-kvm_tag_change-v1-1-6dbf6af240af@rivosinc.com>
X-B4-Tracking: v=1; b=H4sIAKwVGWgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDINTNLsuNL0lMj4fKpqQmGpkYmxomGpuaKgE1FRSlpmVWgA2Mjq2tBQA
 HM59HYAAAAA==
X-Change-ID: 20250505-kvm_tag_change-dea24351a355
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

RISC-V KVM port is no longer experimental. Let's remove it to avoid
confusion.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 0c3cbb0915ff..704c2899197e 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -18,7 +18,7 @@ menuconfig VIRTUALIZATION
 if VIRTUALIZATION
 
 config KVM
-	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
+	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on RISCV_SBI && MMU
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING

---
base-commit: f15d97df5afae16f40ecef942031235d1c6ba14f
change-id: 20250505-kvm_tag_change-dea24351a355
--
Regards,
Atish patra


