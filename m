Return-Path: <kvm+bounces-29931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3405E9B44FF
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 09:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B779E1F2261C
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 08:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887EB20408C;
	Tue, 29 Oct 2024 08:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="WyJFokw9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2421D7994
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 08:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730192150; cv=none; b=L3+34J+9qqOR0NzR+ZIvcs4F9QJdj1Kxs4dvqwaYwfOTA9bDkSdZlI6ryb/eE/8l2dLA3t9plW0x8eqVb/YEF3GZDWkZA72wkBK9hNXbYUxF5qFOJ4oh62H45+SsSi0XQFRM8TU5rUUgM1es69wbSBor+dYAoN+To/opYSWIur4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730192150; c=relaxed/simple;
	bh=4gFt5SNrfp0SWXU5+NH1gVt41zrxB2+OF6ksw2y669E=;
	h=From:To:Cc:Subject:Date:Message-Id; b=gC8PAwhaq97tUfI1hP+nHJFh6+3RXrLcmNkg2MFSQzu7e0/R+KCvPglw6rMNz5i26K78uE0USvVIDfjk5rq91lnkVnSZ/Hw/vrh+BokaBxEMgvAbbjspyLPfvQ73SDBUFkQ54YY0b9CO3PKY2kB531X3iOYyHeixezzQUIowW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=WyJFokw9; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7ea8ecacf16so3303572a12.1
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 01:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1730192148; x=1730796948; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuWnhLJQw+PAY3xEBfJ+QJn2JlieNeFBTgX6ZFMdL84=;
        b=WyJFokw9U1deMTx9dGui8OG44BfPiimFXzDnt0Z08OGppSUaI2Q+LkO932iw00AVKf
         btX/W56kQOdabMb9XppMfxLJgYdgdeH7yusmYB6l2dtXT1xaCIISSY4r+m2QBp809V5o
         wNrD6lTqEw8wKkx/MwAwjCENTxFRDyoMGMqyGeWetKZL17t4vUoE5AjDgCmk4gjfVj1Y
         mX5iHJgm4ckT/jg6GlHOt6gxw9M+wer5ZQEOKKY7CYb45wCsj7XxUr5y63f6+U66g3z6
         CTUFGUTWoNEKiKuppzP8J1qDnM4zzOi8xC5vfS5P5eo467V8Je+CHenuTT+ZdKW2WtTX
         RB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730192148; x=1730796948;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xuWnhLJQw+PAY3xEBfJ+QJn2JlieNeFBTgX6ZFMdL84=;
        b=QIs8aFO5FgaoaQx/2OZI4I95JCl0zzFtIbkz7vFc/joGMVG0q3ybE9Gbq+IAsiIse0
         S8EqGpRFya/59NZeIZ9ef7EtQ1HAOYfSl++hPfRyQU2WlpFf3KH13ukf90sOnb6qTls2
         yPnUhTWZ/lBPiYbSFAJVXTe6RD5HsE9LKzqMtzz3uxYHQ/CZLa85lfWm6Bf469vKtD75
         Og1YsTrO97+yCqTQObw/L5gHEWQ0J97OWKxam68BxyvdUtvY9bHB771lDoAcBDQlkjgT
         426cAtheigHGpYedjBVIf/2sk6OeZdDYEOIbTAfbgWalqrk5RALdRY5sW39XVP2gQ0XB
         1uOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ2nH3kG4Z3ZHW/Ef2H+jE8QmrOoyJGKUI7H9M7KZ9WpW2eMsF4gGfE8GFFMYzQ/OoblU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu4p5+y8CBylwphkv39zyVnDA0Z5KjcqjopeSS9COoU9T0+czj
	VaTcLlBAL4vSvMy8XGJSDQgZ4Ph4yKvYD9Y4XODxkf2WFrB9Kt23aEgVJeEl3OA=
X-Google-Smtp-Source: AGHT+IHf0YC+Ea5Ksx4oBfD4ogAxvHzzwCrdPrdXaYrCaa9GKLqYlspwFnf6XIm9UGsHOjhUqPUyrA==
X-Received: by 2002:a05:6a21:a24c:b0:1cf:2853:bc6c with SMTP id adf61e73a8af0-1d9a84de0a3mr14026908637.33.1730192148007;
        Tue, 29 Oct 2024 01:55:48 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057931a06sm7054189b3a.55.2024.10.29.01.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 01:55:47 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v2 1/1] RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation
Date: Tue, 29 Oct 2024 16:55:39 +0800
Message-Id: <20241029085542.30541-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

In the section "4.7 Precise effects on interrupt-pending bits"
of the RISC-V AIA specification defines that:

"If the source mode is Level1 or Level0 and the interrupt domain
is configured in MSI delivery mode (domaincfg.DM = 1):
The pending bit is cleared whenever the rectified input value is
low, when the interrupt is forwarded by MSI, or by a relevant
write to an in_clrip register or to clripnum."

Update the aplic_write_pending() to match the spec.

Fixes: d8dd9f113e16 ("RISC-V: KVM: Fix APLIC setipnum_le/be write emulation")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
---
v2;
- add fixes tag (Anup)
- follow the suggestion from Anup
---
 arch/riscv/kvm/aia_aplic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index da6ff1bade0d..f59d1c0c8c43 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -143,7 +143,7 @@ static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)
 	if (sm == APLIC_SOURCECFG_SM_LEVEL_HIGH ||
 	    sm == APLIC_SOURCECFG_SM_LEVEL_LOW) {
 		if (!pending)
-			goto skip_write_pending;
+			goto noskip_write_pending;
 		if ((irqd->state & APLIC_IRQ_STATE_INPUT) &&
 		    sm == APLIC_SOURCECFG_SM_LEVEL_LOW)
 			goto skip_write_pending;
@@ -152,6 +152,7 @@ static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)
 			goto skip_write_pending;
 	}
 
+noskip_write_pending:
 	if (pending)
 		irqd->state |= APLIC_IRQ_STATE_PENDING;
 	else
-- 
2.17.1


