Return-Path: <kvm+bounces-50045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E84AE1753
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 11:17:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70B2A3BA42F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 09:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE9628002A;
	Fri, 20 Jun 2025 09:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="BoPTQRvM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C3227FD73
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 09:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750411051; cv=none; b=G1OdXREj4KddiqRB51v0DN25Q9VOW4TjxQOpI1ZFUW7B7vB00838Mrtjk//sIXNNFJVnK+8uBriCvbOPFoleluzTK/iDYB4kpVhDzYw/HeBQsvfHj5MOv89JArm+lZwZSO9tfM59rhZ5OYaYaVKtZFs+5iL00/bO0U/O9KfTbg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750411051; c=relaxed/simple;
	bh=ixQNp5ANh6UfdRBKRrYl0UcGHfvIBMJLk6zo1If86DE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gFumlOVqDBkPrU2aMCvG/Sf4abYBVnx0KhlDgYU1obLhMdnz/g75qADYvfmhIOUINqtNB03jd/sOdCHYhbMHjHbrsyOEQmtbGuVzTDYPosOlo4ZKc407LJtJuz6I9bd55/goN9REW5G+cAnCGzdm/m4vtarOhnzz2NQEMA6X8tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=BoPTQRvM; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-748435ce7cdso1391296b3a.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 02:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1750411049; x=1751015849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dNLJBKjnEtfhUDU8FDwmcm2NO13Gl9xrFkTR60m39TU=;
        b=BoPTQRvMiaVsA+UWQUH2P9nYxUe9LPYI7ycwAMzYnje1T4RAewcYY9ygI7E6PXhkC1
         ez/qgMsUnW2jAGIiFlgiUz9hrA/DHcYCBAqQSZcZxQ0nHO5tDnvVDqVW9eaSNEjhj4z3
         e5U13FIS7A21MckQBbxKbm5/ryOifWfJ4ix11Ey7PJB4Goqh1fH/5kFoac7VBXvDvdEd
         7rE6mTCRUOa2pnvCX91VnYltOo+9DmgatdCjGM1XkvhONxL8aR90KfI8X/I9jy4ialNo
         Uuy2gr4XvjZ6qB/w4mVvLd6U4aVYsj5kH+lUyg1aq0l83g/5D7PxZtzyUoMcN3jF+31T
         ZF5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750411049; x=1751015849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dNLJBKjnEtfhUDU8FDwmcm2NO13Gl9xrFkTR60m39TU=;
        b=hj9n5/RPwW4pRwgZgHLbKWTKORG4CxFS9WI4Ow3yD8ziViy9P3HHjolaJp0S226KLs
         M0OJkuxakeLeutYzXZC5jM3s9LN+zRpoElS6H1JAsTNvMca4dPFmDtSqJYdLzUhgF1Xy
         1XhUhFHsMl2boQIrfc/YS4U/z4K4hnwRiiXwSbEv4UEpIYljlVXKvjzomAEk7X42Jr+n
         GN+g5Pu5d4vG3sAo09YS2RFv0h1xsTTcMG71vUlTcuE+TTBiQeGsRc+zb4dQopD6PCbE
         /aMZfJ5CRZ7BZOpMKZRAKNbWI3BGaw9yoYVCV/Azt1B44yoKHn46FumB1S4ksSgskBMs
         ERrg==
X-Gm-Message-State: AOJu0Ywu7hwrGeky8UjoH+XSbRjNmNyMpDGE9e9pSFdJbzdCHrdVnq1u
	73Lh1p5BIqhRddpCcGsaTmIWPmIU5vrruhatm0wEFg7uxgsDPKuqpIsvBUUxZHtI/MI=
X-Gm-Gg: ASbGncv3lA0p8Zrfc35o+cBJ6qW8p17oxnPAWSlrLrQBak45IqbUZ8SdUjZK2qTwjFr
	TrU3D/N0lz9JIYC8VRUZ2eOUpr94lfR8HC8hYfTHnqb3QrcXGkRIoMgS75XNEmnAbsVgtAwUujM
	j0msVhiBJVCWCDceVlJkqI14ay+PB+0itOlqpuIHXQrPVfRZ0RCzCKZa0RGsMlWwcdJoElq6WtU
	9Q3XmI03ppwuS2BuZO6uR62aIsH/2AT2g6rbAk5qonJQkDM9YRGacS7ouyvk8FVTObYCjmrEQ9/
	tvkOs5x1yLophIGFb+JAESwMfNOg6OgVdzMND9osAg1vYp/NnYTOg8BvBNUXU433ZUGm3VD7DCn
	1PzP2sKOCOaPbTPCnBACmBVyXnQo08q5AktO1FX2BBT3Qa03i8E4xVZo=
X-Google-Smtp-Source: AGHT+IFl+mvsVS8E+myUXJyeRA0NPyQGQ4vLveBBEzuD3+Qemhmjod5mWIqNQeJQuwr4ZVik1pW6cw==
X-Received: by 2002:a05:6a00:2789:b0:730:95a6:3761 with SMTP id d2e1a72fcca58-7490d4f533amr4072727b3a.3.1750411049294;
        Fri, 20 Jun 2025 02:17:29 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7490a4a488esm1643231b3a.63.2025.06.20.02.17.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 02:17:28 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH] RISC-V: KVM: Delegate illegal instruction fault
Date: Fri, 20 Jun 2025 17:17:20 +0800
Message-Id: <20250620091720.85633-1-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Delegate illegal instruction fault to VS mode in default to avoid such
exceptions being trapped to HS and redirected back to VS.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/kvm_host.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 85cfebc32e4cf..97cc2c0dba73a 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -48,6 +48,7 @@
 					 BIT(EXC_SYSCALL)         | \
 					 BIT(EXC_INST_PAGE_FAULT) | \
 					 BIT(EXC_LOAD_PAGE_FAULT) | \
+					 BIT(EXC_INST_ILLEGAL)    | \
 					 BIT(EXC_STORE_PAGE_FAULT))
 
 #define KVM_HIDELEG_DEFAULT		(BIT(IRQ_VS_SOFT)  | \
-- 
2.20.1


