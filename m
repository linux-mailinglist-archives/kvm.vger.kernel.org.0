Return-Path: <kvm+bounces-51644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFCFAAFAA70
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19BA2179B36
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B191C258CC8;
	Mon,  7 Jul 2025 03:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pHbqzyqB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6906625B1E9
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 03:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751860441; cv=none; b=CQ1Bae+pX2KiHxA6JaNymGOT9V2AOH/22RvlkugllFuR+56UAjs9tqaBiIOF9kuDyRjgRKsUZrWeKgNiK3mS8CUkJjcNIFwF6R7DVcQkM/EZhIhAa4ws/h3caBgl6PnE10srKJX322PbOWmP0T+hGYbLA7geg4HE6rF9NG+zfHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751860441; c=relaxed/simple;
	bh=hDVuO6vGjj6gmA0OjjMdUnkUd5ry1pE2UWNS+DuqCZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU1G1wjrTbyXhoF/V7MR1iTNYeTYvhfoRbdMnf9jGksqbsvQmZyPYOCBzeGTihtQlmREeS7TQLCeDR3mBeE+MDUyxIypukE+KDrLhkYlUyZY0xS0t9fJKQ+DA6C5ctEBCdh2FVEq8zZKmSxHvxOBO41vDgGAY5pVu76nNgXktcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=pHbqzyqB; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-31329098ae8so1962296a91.1
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 20:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1751860439; x=1752465239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfAi3fd+E8Ej2lF9gnj/0qdp/peypswYQnHcbvVqddo=;
        b=pHbqzyqBpvnBEMkpkN4764eHbL7kfRj+4+lVQ4J7ixF1be14NJhTSQkQ7TWfBFb0ZG
         oi5ro+wUGFOnmkt3DomKrNKY+fs3zbc0u69LEot9xfI2AdvzqSl3adOL6E8IHcOLxeF9
         1Z+2MCeDT2rMjMuYNOsWauhw0mQJzbhn9LCBu1TzWXZL0qjs8mHk8sjESgYm+bUV2KWW
         +E7gdPMZyLDw2V6GyN91mn9AGmFmalaXAZgl089ms5jhYkoq/fR5+JyvXpaHe42pBY/B
         fNb8VyhUd9ZDHKDiFSuy7q5u46z6m7NEQnxTKwmrMfQCUPlIdKter8EVE1XahtRl6rnd
         fJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751860439; x=1752465239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OfAi3fd+E8Ej2lF9gnj/0qdp/peypswYQnHcbvVqddo=;
        b=vVnEUEFQOdfR5xTlZJt+ATdErTdHO3uWQ79MfrRtXEc6PB5og4EeaR49jPNjxXtAlQ
         A9783ZdAjPGry08go9yLwVy1o4Ink+ymLE2+1kCSpmUGAgtPNss50WO+OKKHhJb+U/yl
         8KlRMKSEtf4oR7bj25op2tfuFKhK7zuQz8C5DdKHhS0khldXahvBGRgFVtqgthG3zo7A
         ovPVTh3O/MWiUUifM7HmPjQlyNsn/kn06LcRx88+XWEEZNbQXuvRfWsdWE7+FQ7BYnHR
         XyjKEr+o37m8doo/IcyPH32DEF7rwDjEQzNe803MqJvXTo4bp7MshkbmzWwwAMgCx0Qq
         E5rQ==
X-Forwarded-Encrypted: i=1; AJvYcCUINXPZ/XVQV/V17g+lFGuRYccosoPbRFQm2m77Tx/qIsp7EifCinh1RGwsGi+nAmQLVV8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVnzlWx/NRxntnjZ5cLxZkSL8Wlg8/b4JrC88bVhfB9c6qnhoN
	0Htju4mqclYZwYToqxal8O/XkEHOAcP/W4hdoABNvYZQI7HQ4g6u4sdwUz7nqCoMqnw=
X-Gm-Gg: ASbGncv5Mtj/QP5toFQSmo61+P64aKjhKU/dFGttqvEv6dHIKdHeAfk5FIzLCXRa3xM
	NglU/Im527KRVx1kJkEp0Wl9m7wI6J32M5EisDl+87Loj4eiRPKNuDCYe8HmYWc2NMcJVSXeq2Q
	S6XV8joxI0jx7Bjhyq8xun0AejrPxHqKCON9j8BDNURNGSYUFF3UKhjarl32+G7rPiMp1RpGLhc
	7zowjF5Ecjo886OsdOmD99YXVe7wvDFrCfaFlMBXF9bWxjsQP1w+Kz67ZPc5962tgiTg2sn8aD/
	yrlhjaFLVKlRVBQdmx2ipguJb6zG3XxxnpV/S140rO5ftJ5OxM9LfLuMxyaIWwrCP5YEwb7RUgN
	O5EeGQj+U+gEt0cYAKbw=
X-Google-Smtp-Source: AGHT+IGeNKIzrYtZHWrzPyAaXd9wmbWip0uCwcq3zrRW80YaPsp+TGeA7hn5Q+daneEYm75wjzhZiw==
X-Received: by 2002:a17:90b:5847:b0:313:f995:91cc with SMTP id 98e67ed59e1d1-31aaaf7301bmr16967530a91.2.1751860439499;
        Sun, 06 Jul 2025 20:53:59 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.152])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31aaae80ae0sm8159137a91.21.2025.07.06.20.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jul 2025 20:53:59 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH v2 1/2] RISC-V: KVM: Disable vstimecmp before exiting to user-space
Date: Mon,  7 Jul 2025 09:23:43 +0530
Message-ID: <20250707035345.17494-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250707035345.17494-1-apatel@ventanamicro.com>
References: <20250707035345.17494-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If VS-timer expires when no VCPU running on a host CPU then WFI
executed by such host CPU will be effective NOP resulting in no
power savings. This is as-per RISC-V Privileged specificaiton
which says: "WFI is also required to resume execution for locally
enabled interrupts pending at any privilege level, regardless of
the global interrupt enable at each privilege level."

To address the above issue, vstimecmp CSR must be set to -1UL over
here when VCPU is scheduled-out or exits to user space.

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Tested-by: Atish Patra <atishp@rivosinc.com>
Tested-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
Fixes: cea8896bd936 ("RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc")
Reported-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2112578
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_timer.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index ff672fa71fcc..85a7262115e1 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -345,8 +345,24 @@ void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
 	/*
 	 * The vstimecmp CSRs are saved by kvm_riscv_vcpu_timer_sync()
 	 * upon every VM exit so no need to save here.
+	 *
+	 * If VS-timer expires when no VCPU running on a host CPU then
+	 * WFI executed by such host CPU will be effective NOP resulting
+	 * in no power savings. This is because as-per RISC-V Privileged
+	 * specificaiton: "WFI is also required to resume execution for
+	 * locally enabled interrupts pending at any privilege level,
+	 * regardless of the global interrupt enable at each privilege
+	 * level."
+	 *
+	 * To address the above issue, vstimecmp CSR must be set to -1UL
+	 * over here when VCPU is scheduled-out or exits to user space.
 	 */
 
+	csr_write(CSR_VSTIMECMP, -1UL);
+#if defined(CONFIG_32BIT)
+	csr_write(CSR_VSTIMECMPH, -1UL);
+#endif
+
 	/* timer should be enabled for the remaining operations */
 	if (unlikely(!t->init_done))
 		return;
-- 
2.43.0


