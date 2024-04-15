Return-Path: <kvm+bounces-14623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5634A8A4859
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EAE471F22489
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 06:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8C01EB48;
	Mon, 15 Apr 2024 06:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="GiyZ9NhV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2AA1EB30
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713163752; cv=none; b=UzKXdhM4FXWlGvzwutw5Vy6fPkJycrpRnnExrJsZwrDgLZgUnfCUUJNMd2zQP5C74R6xTuaUzlr7gTdoDhyY+zOcc1R6atDoCnUq4/KbUcpfkwIT8z+UlURoEMFarQNvHTua0qObEZMv7OJ52LdmiEfUxuJODXND9RBbYCQ4BzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713163752; c=relaxed/simple;
	bh=5liYRdehCxf/qgC8OqFtGeudno/7H0JcP2nubfjgSn0=;
	h=From:To:Cc:Subject:Date:Message-Id; b=YDMnBt4k9bJaewljZO7Y1dOoJGIvyVjKFA8Fhjpge496pJzdx80Jivd/1lLwpeNZVPeI8oTNs0TY8lKjU9L9X9brc90Co++W2uZtTEgsqdvHkObJY24I5Ss2mZGLbr8kN8kqlioKzDDr5a1o2Q9habGQ15BOUYJuPomfC6i1p6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=GiyZ9NhV; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ed11782727so2373642b3a.1
        for <kvm@vger.kernel.org>; Sun, 14 Apr 2024 23:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1713163750; x=1713768550; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DErZWi0JRkT/kr88yhBbwPniJ+j3I4IxiglXEXSEUgM=;
        b=GiyZ9NhVSKfgRFdZalM+OYGvYXOBpGhyw5eMnmk7ufdHa2HTeKs5Ay0w/guXrcuUzR
         zooenl1PuiQZpagpcgdrrE4JhLiIcr/RAHYvOLX/znoEY9EzPtlQA9Rr5geoShNKxEtJ
         dV4/6LGlZLvXvO+5k83+t/WMa2gdMmZVXPu6Q6QoTUHX2l+OMQoOZ+erYGXOcUI+fZfK
         qKgddMDcatYkJUJNiNQe/XcmYOLFijj+bsA6OknyDlX6lKZARphcdNwGiOsclmcSNnKl
         olNac8Wwi7SGaVK3yHbIwpqjIQwKz5u+eUo94q4iE+8zdR5Hd6g0PlD0clW43F6AB4Z8
         sw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713163750; x=1713768550;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DErZWi0JRkT/kr88yhBbwPniJ+j3I4IxiglXEXSEUgM=;
        b=Lw1xSZQz6QBvP9vFHWwEcaE4WTafAxv3qQMrfwVttlPg6NZtsi6Z4Lfkkc5WvvpGwq
         GOgOE8k3nvjBwXSB19zSpm5t5iEUMs4Tw07gnqJbCJfbU9Q1BLmmyaz+UhAj6ry4onrF
         tIZGUKgNfXk3dR3C+qy5YqeFDB0D5HhbtPNMFddw2fCuEv27kOyFSOZWqJjZtW5l5PzI
         +7H4YSc8tEwzAQCKke2yIfNntAcylGqwd0Y/ZTk/rRrsQP5CFBRyW4KkzlLFyvH0Kdfk
         0PiVrvv7/OvQ2fAhogkuUh0Kk9Y5iAwOY144O+PqXLMx6xWyzsgtTkZlyA/otyB94lEe
         +QVA==
X-Forwarded-Encrypted: i=1; AJvYcCU1GyyDovHahohjW5DumsKlUcwx4w2EzE3FpHxgqfH7Da77mVael8ff9XOPmFs50zFcI6+KLf9AlJV9IyRTqKenor1K
X-Gm-Message-State: AOJu0YyCKssp92xSsWNouz9+bFI7rG7jH1C6bWzcUwYw6bfL2KwSOkgH
	ydHes+R1dm2xgWRcsvbEguzjzXVLc4xuzdKu+zrDmnTHpfpMK5xY63vEkvecoU0=
X-Google-Smtp-Source: AGHT+IGn1W1xzHSGwkwC4Rv3qdVaNOqbbshITL3vRArjugmKJXVhxAVawHtGIDLdUvZYMVcufJ5VDQ==
X-Received: by 2002:a05:6a21:6da2:b0:1a9:4055:6dca with SMTP id wl34-20020a056a216da200b001a940556dcamr9192611pzb.40.1713163750420;
        Sun, 14 Apr 2024 23:49:10 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id f18-20020a170902ce9200b001e421f98ebdsm7148962plg.280.2024.04.14.23.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Apr 2024 23:49:10 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] RISC-V: KVM: No need to use mask when hart-index-bit is 0
Date: Mon, 15 Apr 2024 14:49:04 +0800
Message-Id: <20240415064905.25184-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

When the maximum hart number within groups is 1, hart-index-bit is set to
0. Consequently, there is no need to restore the hart ID from IMSIC
addresses and hart-index-bit settings. Currently, QEMU and kvmtool do not
pass correct hart-index-bit values when the maximum hart number is a
power of 2, thereby avoiding this issue. Corresponding patches for QEMU
and kvmtool will also be dispatched.

Fixes: 89d01306e34d ("RISC-V: KVM: Implement device interface for AIA irqchip")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 arch/riscv/kvm/aia_device.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 0eb689351b7d..5cd407c6a8e4 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -237,10 +237,11 @@ static gpa_t aia_imsic_ppn(struct kvm_aia *aia, gpa_t addr)
 
 static u32 aia_imsic_hart_index(struct kvm_aia *aia, gpa_t addr)
 {
-	u32 hart, group = 0;
+	u32 hart = 0, group = 0;
 
-	hart = (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_SHIFT)) &
-		GENMASK_ULL(aia->nr_hart_bits - 1, 0);
+	if (aia->nr_hart_bits)
+		hart = (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_SHIFT)) &
+		       GENMASK_ULL(aia->nr_hart_bits - 1, 0);
 	if (aia->nr_group_bits)
 		group = (addr >> aia->nr_group_shift) &
 			GENMASK_ULL(aia->nr_group_bits - 1, 0);
-- 
2.17.1


