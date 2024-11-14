Return-Path: <kvm+bounces-31865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6379C8F9A
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:22:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E32AC28868D
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A26B1A4AAA;
	Thu, 14 Nov 2024 16:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="K04vfsoH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001A819CCF9
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601146; cv=none; b=YcMY1EW6omAD8mYimZKp0PATJZy+9uhdB4sy1wemsiRrOpbyV0VtP7H31anmIsit0GsEHtppdwBoIK0txJcp+P4dt4P9Imac/QBMGUoTByfgfEO1RZyyxmOgG0O4bsF/Rxv621zBgfLYYl2HtxTorkEZAFEE+A/LRjUgh4Xbt/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601146; c=relaxed/simple;
	bh=zG8rAEuB5eoKnSaZdksATDcRCj9Xf9/S0fQz+A0rat0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+cSpy/24AqbeR6r33o/qNi/N8wgQ7oyM8DoQ+cmpIU3Buw6mvN3pTGhGHk/fLjsFD3zdTX7vNxSAb3yENJcvZNxvakd30dyCSlOjTsYMP/Mw7R1K/2Phh/lffkJgybI4KP2L7yvq0e6R1JojaHIFIRhi6EmbvwDjYPEWgTePGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=K04vfsoH; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4314b316495so7193755e9.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601143; x=1732205943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ylj9cSUnN7lZBYMxGOa796BuugfVNbbIfct9OAjDsOY=;
        b=K04vfsoHPQ8sPeJn6OLhB5+OzhmlWfrdBFhPGKUrNINOuOXu7fCIATXEeIeCvnOEeg
         ybzd4rUCMGjVI6vyH18f5fd+tj8MT3QzxXD6mYG8Dukd3Tkd9kr6WuvHibe/cElDo84M
         0XQ47hsTA8SgFAWvcegXtscWvB64wR6bblP3U40lR+deWbXLx5c7KoG9dKxm8l2LndGz
         /lKctDSgyMzk7cKrQGXCfasEn1ANX8BdXepDysl8yQbGzlOzrexRXNHDv+x5L7BXKg6f
         YNwRxI0Lo8dRbPahvtSCpd1SO/EXlyJUZL/ZC0nr1X0AO8ZuLMsqechg5oc3rCAlY06J
         6wAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601143; x=1732205943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ylj9cSUnN7lZBYMxGOa796BuugfVNbbIfct9OAjDsOY=;
        b=aB2mweQi9zMKvWmOsjGAUy8WOQ3aq2tC71kl78oilR5u4G4UTv9Lh9N/ITblKah3Ik
         wZbwF6MeaONPKc78WTL0G/YXSwvBPjwQ7WDwRjLFVFrRE32EgKsg8DRkP9KZwnAJgEuS
         Uj1v3mD3F45gaq05peT4e/6KbiZ/HH1ORpQhA7hHKvJ9F8gyQJYM0epFooIVeMbe8yi1
         djwX7HhTTAQQR8A8W8k+otAO9N83fb9hjEavPmNz9VVCqzf7UYJxHEYR3agLMi3VQ4+7
         IQfDOJbti9gVAulBXcG8rqgDUJUFtn9QQ5c8yHyPnIUJko1gpbh1fCuKsi/L/zgX/Itw
         NJKg==
X-Forwarded-Encrypted: i=1; AJvYcCWhpY0PwRmvM/CXOr5WCxrlasUi3hx9ZVqkiCMan3BQOcZf6R4YX28oNnJFR/q9ewj2CcI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfiKXCOGqJeerg0JuOLCQGtBLX/iOrmGBzTw+vqzZL7hnalf88
	8dQ8Rkd6yzRsJnwWcAasFg1fwV1lzDD5LiqycBVxXlWmEzg84y+wo2i0rSYvmP4=
X-Google-Smtp-Source: AGHT+IGWufmtM+epbPX600D1VFEI9w8hjUWbvA+ZtsTOBkgX8kbCaXoJN+2t/PgDnUc4rlU+m8h9BA==
X-Received: by 2002:a05:600c:3114:b0:42c:bd4d:e8ba with SMTP id 5b1f17b1804b1-432d4aae479mr69854575e9.8.1731601143362;
        Thu, 14 Nov 2024 08:19:03 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da265ca8sm28719625e9.14.2024.11.14.08.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:19:02 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com,
	zong.li@sifive.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [RFC PATCH 09/15] RISC-V: KVM: Enable KVM_VFIO interfaces on RISC-V arch
Date: Thu, 14 Nov 2024 17:18:54 +0100
Message-ID: <20241114161845.502027-26-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114161845.502027-17-ajones@ventanamicro.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tomasz Jeznach <tjeznach@rivosinc.com>

Enable KVM/VFIO support on RISC-V architecture.

Signed-off-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 0c3cbb0915ff..333d95da8ebe 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -29,10 +29,12 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_MMIO
+	select KVM_VFIO
 	select KVM_XFER_TO_GUEST_WORK
 	select KVM_GENERIC_MMU_NOTIFIER
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
+	select SRCU
 	help
 	  Support hosting virtualized guest machines.
 
-- 
2.47.0


