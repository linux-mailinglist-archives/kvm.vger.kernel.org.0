Return-Path: <kvm+bounces-18895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C10C98FCE16
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BD78295E88
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A051197A94;
	Wed,  5 Jun 2024 12:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="dknwMVeg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE58F194145
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 12:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717589720; cv=none; b=Ec2ZWYOvJ563CLoMFUlOpaaZj75UTBKlg+xYB3pr9LhBNZFVSd/O91doaWjdEsRhvAtJV2EEXwQitInFhSx4Do81EnNQKJuChzp6Pz0R0esHdLYBKapNnOFRNi50k0y973oYMyQxcP7K6fNcpXAQqypiK5JFZM2iktzLSqzvKYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717589720; c=relaxed/simple;
	bh=x0ytsCbviekBEjjLge1IWFvc2zY+68XMN37JrAm8Nrs=;
	h=From:To:Cc:Subject:Date:Message-Id; b=ZwvPZ9ZTurVbmciQDUZeJKtfFRlnYqFNIcR8SLjYmMVIafdWrhoTd+qBA9DUxlBszL+cRQDk5JN/cSr6TpcnqSPVMno9m4KxIXqxCzWkXzt49keE75vGH73yWceYaa/c1zCFU50WbLVIVfZ2sqn+fUUnagpKWS1oKejAsOLJgRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=dknwMVeg; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7026ad046a2so2526576b3a.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 05:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1717589718; x=1718194518; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5DXKLGOuzK7Mq9/TKsjijP76CNhcAYfch9wR/ZqBgRU=;
        b=dknwMVegqLrP6LEpTNCXP/amPBCTjdzD6ltz8cEhEoJIceRrRpac9YBlDVzspZn/vN
         08LeKVlokWY62yKSv6U7MxsJTCR38FDX0gWPNAv0XxFgX91i4veRM5JbT2Ezef1Pqg23
         mbeJMX8XNZqopZhABVGAuyK9hhbDg+T5kGRDWtQDktPxgrZq4TEH0W4p1W06cqRXQygR
         phDFuVRK0an9X7iwwzWzRNCrgPtrFqjeEqS9GPIS+xQ6veUTnVDdz583mDBbrCHDbkMj
         UKqEfwLZXGTuZ+0ceVBVSGnz6ARmxfacwDOgRrY9dUMNL22dc5NIS+Df9v0cD6NFji6B
         KPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717589718; x=1718194518;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5DXKLGOuzK7Mq9/TKsjijP76CNhcAYfch9wR/ZqBgRU=;
        b=amDX9CHwJVqWSI0DA0fI3taZuoqs5RCqEBJzEZKlT3gbqSL62I/9uzXj1M0UuLDV2N
         AqWqDw3gd5qTOB0tK2G3zbRVL6PYd04VtSSWzu+AKVCIrSLCdlh/VVZiQ6ncWP3UGNg8
         S/68Z74N8inFlGajsd8avzULTK7h8DwamVts6x07LPdPmlbqk0uP7xJeHKn3VnzY0h1C
         BCfqV/G0NK/YlIhiE38Z4QwlOE1fMSwORqDMigEkUnIup84RckFrTf6Wah2FnL7jeCSg
         npFGORn/ilE1G7ux6FHpQLTHAxXe8OI79wVNDCCogm1EuaMsiPaKIHoqX1MCcUsZPCNM
         PsyA==
X-Forwarded-Encrypted: i=1; AJvYcCUu+C+OrGWQVvz15Dmi2ShNHkXqffxYVOmnJ3LvkxVBmAN/LCSh7f57tYp9nZuzIdhkKj4L0zCBhTmVZog8XoZaXwGL
X-Gm-Message-State: AOJu0YzdRQkS93/jLbAX0Bzv5QEk5Xq5xgfz31+qZkOwhxGCyl16VXVQ
	3MXJSRWUIulIe3EtXXL3ptXBQPDeMCMe1nYdUisevrmYjs+tf8fiMS6u6pB4Zdw=
X-Google-Smtp-Source: AGHT+IFXmN1NTFby9QdaZWN6LCrZn10MZA93JJFtVVzaU83zYNY/GJ3zV52JcTW07LpaJw14DF1JKw==
X-Received: by 2002:a05:6a00:2e1b:b0:6eb:6:6b72 with SMTP id d2e1a72fcca58-703e5a7c2e5mr2473376b3a.25.1717589718025;
        Wed, 05 Jun 2024 05:15:18 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703ee672fb3sm885379b3a.216.2024.06.05.05.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 05:15:17 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: apatel@ventanamicro.com,
	alex@ghiti.fr,
	ajones@ventanamicro.com,
	greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v5 0/4] Add Svade and Svadu Extensions Support
Date: Wed,  5 Jun 2024 20:15:06 +0800
Message-Id: <20240605121512.32083-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Svade and Svadu extensions represent two schemes for managing the PTE A/D
bit. When the PTE A/D bits need to be set, Svade extension intdicates that
a related page fault will be raised. In contrast, the Svadu extension
supports hardware updating of PTE A/D bits. This series enables Svade and
Svadu extensions for both host and guest OS.

Regrading the mailing thread[1], we have 4 possible combinations of
these extensions in the device tree, the default hardware behavior for
these possibilities are:

1. Neither svade nor svadu in DT: default to svade.
2. Only svade in DT: use svade.
3. Only svadu in DT: use svadu.
4. Both svade and svadu in DT: default to svade.

The Svade extension is mandatory and the Svadu extension is optional in
RVA23 profile. Platforms want to take the advantage of Svadu can choose
3. Those are aware of the profile can choose 4, and Linux won't get the
benefit of svadu until the SBI FWFT extension is available.

[1] https://lore.kernel.org/linux-kernel/20240527-e9845c06619bca5cd285098c@orel/T/#m29644eb88e241ec282df4ccd5199514e913b06ee

---
v5:
- remove all Acked-by and Reviewed-by (Conor, Andrew)
- add Svade support
- update the arch_has_hw_pte_young() in PATCH1
- update the dtbinding in PATCH2 (Alexandre, Andrew)
- check the availibility of Svadu for Guest/VM based on
  arch_has_hw_pte_young() in PATCH3

v4:
- fix 32bit kernel build error in PATCH1 (Conor)
- update the status of Svadu extension to ratified in PATCH2
- add the PATCH4 to suporrt SBI_FWFT_PTE_AD_HW_UPDATING for guest OS
- update the PATCH1 and PATCH3 to integrate with FWFT extension
- rebase PATCH5 on the lastest get-reg-list test (Andrew)

v3:
- fix the control bit name to ADUE in PATCH1 and PATCH3
- update get-reg-list in PATCH4

v2:
- add Co-developed-by: in PATCH1
- use riscv_has_extension_unlikely() to runtime patch the branch in PATCH1
- update dt-binding

Yong-Xuan Wang (4):
  RISC-V: Add Svade and Svadu Extensions Support
  dt-bindings: riscv: Add Svade and Svadu Entries
  RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
  KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list
    test

 .../devicetree/bindings/riscv/extensions.yaml | 30 +++++++++++++++++++
 arch/riscv/Kconfig                            |  1 +
 arch/riscv/include/asm/csr.h                  |  1 +
 arch/riscv/include/asm/hwcap.h                |  2 ++
 arch/riscv/include/asm/pgtable.h              | 14 ++++++++-
 arch/riscv/include/uapi/asm/kvm.h             |  2 ++
 arch/riscv/kernel/cpufeature.c                |  2 ++
 arch/riscv/kvm/vcpu.c                         |  6 ++++
 arch/riscv/kvm/vcpu_onereg.c                  |  6 ++++
 .../selftests/kvm/riscv/get-reg-list.c        |  8 +++++
 10 files changed, 71 insertions(+), 1 deletion(-)

-- 
2.17.1


