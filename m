Return-Path: <kvm+bounces-21945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5497B937A71
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 092061F22DC4
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C64146587;
	Fri, 19 Jul 2024 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="PBL5/cXy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F061487C3
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405388; cv=none; b=St7lkPo1vPNnHty4ezSEQ0HhinxYespVnYa24aqHU9YdgpKkSWTqd9sg3J2mckWNqQ+wCERpn5/XkeNJFVxHQ8mwnxyFJiDr0W7suBN5kcKQqKRornGFD/BcB99l/gwqDZyXUqfe8YuQHwSDAUCM5gJAaX/Pjc8ftS7I7zCYuxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405388; c=relaxed/simple;
	bh=CayvJpwqAvJdfQdSd2Y5GdFSxQA0Pu7twwYIv0jlrp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fVCtxVTqsJYjdWPOmrdWLZM2a0T0S8Xnyngxxp/ccnM9rfRj/r7E88+jFNQ4bJ9fuLbbLwooHvsOrruAf1T4S7Ep1RG7pYGD3BTl6xp0ELX2Xz0EH0bPDvA3qt0QjADxxY9p5v923r/FH4P91r9N4ER7bNfsSgyZFQ8zShL2TBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=PBL5/cXy; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fc49c0aaffso20451905ad.3
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405386; x=1722010186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvm3hpKvRW81Dir7XpGK5V4AZ1ZJAiyVeCH2mMtrPq8=;
        b=PBL5/cXyoJdgHAe1hd1FdcVUlVH7rxUpcu2w3RoG00+yF08qmh+ijS57I48AgHAvJ/
         5ROcpbyXyZeBLByCvMyzQDv3rF0xcDryRvgX2bgE+160GRKUJlUwnFmE2/50+GMDVcOb
         OI94QjJirW84Hv1ppslMcoHUp9NHF5J77DT2OfYaC+3bwVUeWpXkR89s0AY6OgxIQCo3
         Zv01ur/1PqkQsH+MCfBnOzubLlQTkyXzDBZtzOGRgKjXGGnBZkdsw0CnMHwKnuqDpPv1
         35woNReeoSZLGPPZyqEwRiOzRc0ycrfYDq9t3+nXLjLG8yUEWNsxV5uXpZ982Vi86x4r
         n03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405386; x=1722010186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvm3hpKvRW81Dir7XpGK5V4AZ1ZJAiyVeCH2mMtrPq8=;
        b=Ikqx5vCluMU6SgpVbeWRUHKypMygXcsLOgvnjJOe1EEFjwEnDjBkOpQ+4t6kNTvPXp
         3ahPu7ihpJuERW/a5QjyWie2/JAmfiQYvUdl+1E9Z46IlULoXKrakO6RhnLZx5syzWye
         wltTVPFLBeRdKrMsM9pbzp7QfhH14GwFyhaI8Xt8z3AT/X3rMxEkkhfueMbn3s/LRhQd
         BT3N7m79uLzk3m3hmDPeLvkdxM+Da+KkDHkvkHnh65FUfFNtwsUFSav1vlZtLQy4LQGN
         2nQibUbQ1N3DfhWZtW0WQVZLSixFfJgWjUvs7I4f5ic5qtuPcNdY43FMag1KQEJ8i+YE
         /PWw==
X-Forwarded-Encrypted: i=1; AJvYcCUAz3Sk9YK+K60HZLdUgIi7JEP6E42YSWCx73LYtjzdiQODCDL9OMj+Tb1esfOlDhH4ZD/DylpLeYwLJmCZYIAkRqvl
X-Gm-Message-State: AOJu0YwxJBmyMLC0vsieTQISSqFxTjXXkPGmFQ5bJ1lmwE6aAtxH6sD1
	evRZ3EG7JoE0W5DUx2t6J67xzBpk7UDGKW5KYbYcme5ohqfUlApaag0nDsQ6zd6Y8jCzbCaZFX9
	t
X-Google-Smtp-Source: AGHT+IHTBp6zlsH1hrlMfviNDvDhBwVMm6bPyuRntoKMRuaLAxmrocV1MrWIWDQcyMq9zx2+n0JCxw==
X-Received: by 2002:a17:902:dac8:b0:1fc:5e18:f369 with SMTP id d9443c01a7336-1fd7459dd67mr3483245ad.23.1721405385835;
        Fri, 19 Jul 2024 09:09:45 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:09:45 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 06/13] RISC-V: KVM: Don't setup SGEI for zero guest external interrupts
Date: Fri, 19 Jul 2024 21:39:06 +0530
Message-Id: <20240719160913.342027-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240719160913.342027-1-apatel@ventanamicro.com>
References: <20240719160913.342027-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No need to setup SGEI local interrupt when there are zero guest
external interrupts (i.e. zero HW IMSIC guest files).

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/aia.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 17ae4a7c0e94..8ffae0330c89 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -499,6 +499,10 @@ static int aia_hgei_init(void)
 			hgctrl->free_bitmap = 0;
 	}
 
+	/* Skip SGEI interrupt setup for zero guest external interrupts */
+	if (!kvm_riscv_aia_nr_hgei)
+		goto skip_sgei_interrupt;
+
 	/* Find INTC irq domain */
 	domain = irq_find_matching_fwnode(riscv_get_intc_hwnode(),
 					  DOMAIN_BUS_ANY);
@@ -522,11 +526,16 @@ static int aia_hgei_init(void)
 		return rc;
 	}
 
+skip_sgei_interrupt:
 	return 0;
 }
 
 static void aia_hgei_exit(void)
 {
+	/* Do nothing for zero guest external interrupts */
+	if (!kvm_riscv_aia_nr_hgei)
+		return;
+
 	/* Free per-CPU SGEI interrupt */
 	free_percpu_irq(hgei_parent_irq, &aia_hgei);
 }
-- 
2.34.1


