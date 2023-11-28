Return-Path: <kvm+bounces-2633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 988237FBD7D
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C98441C20E94
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080235C09C;
	Tue, 28 Nov 2023 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nzAQpPBi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E55819A4
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:46 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cf89df1eecso38564415ad.3
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183406; x=1701788206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzvuCYvNDC4WAU9MiwvqT5G+x/uZAqkiyqUofd5JUWM=;
        b=nzAQpPBiBKviHGQAF6uedXqKC8F7Wx2NSmPgTNIynolMrXnaYwsUy4C+cz9BKBLpjR
         luK766NDlr4ARb8140s8MkJYZTY4sMhrFNG5ZHHHdlU64LEtbfYtq610kXXWabBdPslC
         2ols6tMhdyQMCaGV+noUiMXIovLHdfII5WxO96cD/nlm3Y2xWBuxwrLqCVz0rIebXLCR
         PSWMdbNvpuFxzeQejgJyc5kvYivUURvdyqd6Rwz/4nZqsy/dqXIhU+bYr4lAQuLxBQgb
         MR9ZvyUXUA+3msC1e0UsHyWAp3Fz6BJKUlz2peOa1AzQPXOMtmbdM8l08qR8yudHoFub
         AATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183406; x=1701788206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rzvuCYvNDC4WAU9MiwvqT5G+x/uZAqkiyqUofd5JUWM=;
        b=GHmHYHcZ0Y9eM9faBcEuYDXtV3Dz0oSk9jf+6Tifp04UD+E9l9xejdywkEx7ov1uxB
         8devibuuedR27/UlHN/VF0nsFi8u26ZZ6rk+VuPD+HjRhc8hhez2XbXwFsC27M3qiLva
         05pUDSB1CvjLuCtFFt50O4QVb9jQoOR778z0lKoRQe7a0ciNOFRDaZ+8UvGuAul5UiK6
         e2i6uc7vKsv4Kqfws+YjOGbKREw/EWHBZXt70lsasDVEB2KqbLYZ8TUyRupHEAsUBJ/c
         NHBmqj2YhAQiM/Kyf8ERqOctoBImcTsd5TE7jpJCWBSkSxivzUI8QOOiRSK9xW7FSxu0
         wsMg==
X-Gm-Message-State: AOJu0YyrgY7+5IM0CM7P7HKXz95TiS0ujhLeejtv1O7FTXjaNpk2Speq
	wYnJKMjTBEpKkloQGg6HixskaQ==
X-Google-Smtp-Source: AGHT+IFHabpA9QTBC99zG/ypygFsL3wJdocwojvWfvQDhDg9U7Uo3wdVa1mMxoziBAAenignp4vJfQ==
X-Received: by 2002:a17:903:1103:b0:1ce:6312:537c with SMTP id n3-20020a170903110300b001ce6312537cmr15885985plh.10.1701183405740;
        Tue, 28 Nov 2023 06:56:45 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:56:45 -0800 (PST)
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
Subject: [kvmtool PATCH 02/10] riscv: Improve warning in generate_cpu_nodes()
Date: Tue, 28 Nov 2023 20:26:20 +0530
Message-Id: <20231128145628.413414-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128145628.413414-1-apatel@ventanamicro.com>
References: <20231128145628.413414-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let's print name of the ISA extension in warning if generate_cpu_nodes()
drops the ISA extension from generated ISA string due to lack of space.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 9af71b5..b45f731 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -108,7 +108,8 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
 			}
 
 			if ((strlen(isa_info_arr[i].name) + pos + 1) >= CPU_ISA_MAX_LEN) {
-				pr_warning("Insufficient space to append ISA exension\n");
+				pr_warning("Insufficient space to append ISA exension %s\n",
+					   isa_info_arr[i].name);
 				break;
 			}
 			pos += snprintf(cpu_isa + pos, CPU_ISA_MAX_LEN, "_%s",
-- 
2.34.1


