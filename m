Return-Path: <kvm+bounces-47574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5425AC2187
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 12:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 888A21B684CD
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C1E22A80D;
	Fri, 23 May 2025 10:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="m6Eq7HnK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA94F184E
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 10:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747997544; cv=none; b=VZAnmqr6jTFhpcvuEFX0Pa95iun64OE4oHRrsQNZ5/bDtDLNSSiGnnv0EofJRda5uN5EE/gCCUerQwl2cSIQz9T4DX+YSn5g6zt+Jt4ypF5vJuClpsJOq283KwLBowz2cMogSYVu3hbdQ+1CY0q7gSN1P57L/l72BRrK5ibDXLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747997544; c=relaxed/simple;
	bh=Ekl+hGAB44Rldtp80MChpA/wZATRMQ1Vak431vW9/qk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q9Kc55sY1DitpwJ1Fwv/rhcULeye5fAOghCnUkpUqISj1V0gqtfnSW4cQXkft/+Eub74roacCneLSG/i7Xb5CG97UbSwv8YdMBtGpY3cc8eFG8akIU+Ue/2K0y4Dn9+BCdJ6CF79vVhuorBZlLbF8JoKfRcWwsfoO3tn/4PG7q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=m6Eq7HnK; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a367226ad2so691254f8f.0
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 03:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1747997541; x=1748602341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qMi4ApElv9UTRXKLCAFiLHeHw33aLOhDiUIk/Js8sWU=;
        b=m6Eq7HnKZoBo8XLjvhH83fOPp+KwcyUNJTp4kT5iGDUFP6XrhZZi5IQk0Z45udZDpD
         H1gAkac9vUx2xvQbEPU+lYJfV+KBjUHVUqZyUM93voBBT/XtJYcBcywEtFf8QvithBgw
         bsaEFwBNHu63bWlHgWf3W5GeqDC8ozJ+teEWwz8rfiqJoYriRifT6alPxIe9l6Kgxgq8
         wrJ+NYyebIWUNOMLj6OEK/HO354+KLdJCpFBIhGXUshBqM8UriMr3wkIZvkiEzr0AfFX
         OG7SexElzwLeC2NwVT6rc3Bp5X4wvlZSY01v0K1gr700u/RWADygBIco8ehKzLKUg151
         13RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747997541; x=1748602341;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qMi4ApElv9UTRXKLCAFiLHeHw33aLOhDiUIk/Js8sWU=;
        b=e6Yk2hKgrQtrwuNCE+PcTgmlGZmMng/CZMvr6gw07sH2aWRKUtXaGsCee3On9wXm9w
         yXWlCVaMEmRFARoaPYnKkAirfMafhheefGyjs0G5+CMWyC2yhxKjc2wBFhPyNwmuFgDI
         eq1mtWHg/7zZAGQE5sl9PL+3uKmV40V83j/vr5qXvDO0WYHJBxHuq3eHS+YvMdcQYdsG
         /sOINreBmMa86IiiqXvjtGiQf1uo7Oac6hfSQNO0Nyb4Gi7ssQhnRFukQeojV+l+9Nev
         NE55yw0bUrc12TPnYDIZYqyo1CxVWZ87FcK6XKBcUNBnLrkes0yU8JfTPzejvzyDU1cU
         B8QQ==
X-Gm-Message-State: AOJu0YzGKKURH1pWRyypbNnxTjngTjhYKKwsk+XWhYvUhLV2ddj6gsZz
	XzrY8KcGl7YNuj3NfOlCkoNLq4HCwtE150ASp8v5o+6xq6CEv8mHw18zcBHfuut2WVoFVrItwga
	eLSts
X-Gm-Gg: ASbGnctZEDwCCgG/ClUqe6/ce7xynnfUCtzDPy3X6DR+P5vmKbcoifGSdyfJ/lKtItn
	W8uB02pMJiyjYMxu92m9ZDhBT2WEgP7LW2KtajvfbMvg3XALiTQKJBWOEqeH0nUO+4fCT/zqXps
	pqDlBGzBzR3+ObWEBN2EeCeDrjzoRWml2qVYKgD7R8LW3exe3epTSfi0PbejOQ3KxhwfHoO0UPN
	johtAQQ3nqjx7ZHg1/JpQ0FQ1UjJ8o3M4zrmSl4fMcV0vEBCH1GbYkm7wNO4f007Tk7l2ZWXeWV
	fAJeWxN32kjF012za2wV5mSraogNeGh4GEPXnvaroul75ytV+1Zkqv0SLCo=
X-Google-Smtp-Source: AGHT+IEZmpBdHidSmMll0Tt/cMd2jy3jhCSZ/4z88K5W2YuxN+ezZzGMi4M3/53vgB32or4XtWGoCA==
X-Received: by 2002:a05:6000:1acc:b0:3a4:7373:7a6a with SMTP id ffacd0b85a97d-3a4c2e443a3mr745998f8f.10.1747997541137;
        Fri, 23 May 2025 03:52:21 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:be84:d9ad:e5e6:f60b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca8cf66sm25590521f8f.87.2025.05.23.03.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 03:52:20 -0700 (PDT)
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
To: kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>
Subject: [PATCH] RISC-V: KVM: lock the correct mp_state during reset
Date: Fri, 23 May 2025 12:47:28 +0200
Message-ID: <20250523104725.2894546-4-rkrcmar@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We're writing to *tmp, but locking *vcpu.

Fixes: 2121cadec45a ("RISCV: KVM: Introduce mp_state_lock to avoid lock inversion")
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 31fd3cc98d66..6e09b518a5d1 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -143,9 +143,9 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 	struct kvm_vcpu *tmp;
 
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
-		spin_lock(&vcpu->arch.mp_state_lock);
+		spin_lock(&tmp->arch.mp_state_lock);
 		WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
-		spin_unlock(&vcpu->arch.mp_state_lock);
+		spin_unlock(&tmp->arch.mp_state_lock);
 	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
-- 
2.49.0


