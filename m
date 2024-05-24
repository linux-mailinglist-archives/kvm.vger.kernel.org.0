Return-Path: <kvm+bounces-18109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 564768CE43C
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 12:33:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFA2C1F22188
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 10:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76DE58526A;
	Fri, 24 May 2024 10:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="f66EnR3Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7EE39ADD
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 10:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716546794; cv=none; b=aqb9UdPSwS8H973U8il/spqEsKnHvsXIzCOjKyIoNAI/EXiN08iSvmGcL/NkV8erkBIr8umM8LfhCAFd7JKbmpE2qNr3UaHcRP7fBZm41FAyCHpWjyNtrAdlLZhca/PzODrHnVPi3DCoiLEmwL2vUqZrbPHnn7M6GsqEg25oReo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716546794; c=relaxed/simple;
	bh=KBb8GxidSAkL495p8yT+wAAifDziqSk2Ygi33pKg5yo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=O1c02VAbBsBHyCBa+k6X8UywKjIgcPVKyJnpKibGDNYwnb4RBXfT/CijHubym+czNiLdVEEt6haX0Af+t3v0CBnI6ZP/h3hLWM08Wro4mUYWqkFex5gQHVgIzLn1mc0UargrbYs4csQnvf7bcwVy2NjCHoQnLQAooOEIOtlkUjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=f66EnR3Y; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f3310a21d8so19389575ad.1
        for <kvm@vger.kernel.org>; Fri, 24 May 2024 03:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1716546792; x=1717151592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o5+OeJiNJH/1PCnl6kf4yooZjPqVSPQ1EmI9g6Y0DgE=;
        b=f66EnR3YlR1Q8CvqMSjsKjkMBkibGdYy4hNVwH5G1ypL+YTyeUrGqT/MZYA1F+iYZ0
         MLnspRz0d3gbDy9oJQ6vUq08iJt03/Eaqug0d7Q2qgocAsyAh/G1xjHsnQoeP1b2NHkv
         vBrM61YhLVkQTvHTSWaZDGNOPdQnGEBEGdyzndEjTy6exulNkCLuMvKDD0nju9bilUep
         pJvzyXhpENwDArCIuzMQAH6vHb4lcHJLS9Csq9gWHQtBZNPuoedNJFhIPtvO8BslI1pg
         9r9+NYd+vXgGHGqlWku6YNT9R6cD3A9LiAnonCYwUS7IRioH8cSeVeLV9LXNR7EYdGKN
         7zAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716546792; x=1717151592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5+OeJiNJH/1PCnl6kf4yooZjPqVSPQ1EmI9g6Y0DgE=;
        b=SJs5/73pWRauBARirG0WGriRtNdoeOBbm3J6eiJqLnhBearQn0odJSjvB4CTctMZjh
         KEXB6ok3dVDcbM8Bd7QzWpkDmeJ5A2dZViG1bd5roqUv8p8uNo95B8icUWD3R+TdFPrg
         MwHNozhEfSpxN17lOVanPJ7CAFkS585UNPfBDimu7EO0QhzCLtzRPNSlPYHy5XqV5Hge
         San6s294mjYYBfgiB0fu881NBNN+6Cwg71lWFotI0Ou0Blpb+Uk2+yEdcKASUsmPq3ay
         vUo4BZGlUJ+GLoE3FIk3gL30fyf8uAnKiugEK0JI2qUCkHddaCKaXDbC0UIPS0+/mBEs
         Iziw==
X-Forwarded-Encrypted: i=1; AJvYcCViIbTa0lUtmBfzdNxFOOnBi/8vMU7LaMKqOHixMjDnF6lnfrVFCf5EvWFHbWJcD9nfnbbpXc69jDBtSbEObjXwxDca
X-Gm-Message-State: AOJu0YxPyoP5Dbthhy0GRmdtY2P7s1W4qv6pn8SVWpq4Uk6fhcOEanW1
	bqtm5dDD1we/cns/0BDr5Dn4qj7v7NUp46sV+wAZwBSF6EP6yfMWBPSiusWku6o=
X-Google-Smtp-Source: AGHT+IE9eMxclG0+cNauzYQWG6YBPxa+DJVJBSIOCovX2C8vK9iNEwX0H6Fyj7KryEFR0rIeUI/J9g==
X-Received: by 2002:a17:902:d583:b0:1e4:6938:6fe3 with SMTP id d9443c01a7336-1f4497e5b89mr24702995ad.58.1716546792557;
        Fri, 24 May 2024 03:33:12 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c756996sm10936625ad.8.2024.05.24.03.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 03:33:12 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	cleger@rivosinc.com,
	alex@ghiti.fr,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [RFC PATCH v4 0/5] Add Svadu Extension Support
Date: Fri, 24 May 2024 18:33:00 +0800
Message-Id: <20240524103307.2684-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Svadu is a RISC-V extension for hardware updating of PTE A/D bits. This
patch set adds support to enable Svadu extension for both host and guest
OS.

For backward-compatibility, Svadu extension should be enabled through the
SBI FWFT extension. This patchset is based on the Linux implementation of
FWFT extension branch by Clément Léger [1], and can be verified with the
OpenSBI FWFT patchset [2].

[1] https://github.com/rivosinc/linux/commits/dev/cleger/fwft/
[2] https://lists.infradead.org/pipermail/opensbi/2024-May/006927.html

---
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

Yong-Xuan Wang (5):
  RISC-V: Detect and Enable Svadu Extension Support
  dt-bindings: riscv: Add Svadu Entry
  RISC-V: KVM: Add Svadu Extension Support for Guest/VM
  RISC-V: KVM: add support for SBI_FWFT_PTE_AD_HW_UPDATING
  KVM: riscv: selftests: Add Svadu Extension to get-reg-list testt

 .../devicetree/bindings/riscv/extensions.yaml |  6 +++
 arch/riscv/Kconfig                            |  1 +
 arch/riscv/include/asm/csr.h                  |  1 +
 arch/riscv/include/asm/hwcap.h                |  1 +
 arch/riscv/include/asm/kvm_vcpu_sbi_fwft.h    |  2 +-
 arch/riscv/include/asm/pgtable.h              |  8 +++-
 arch/riscv/include/uapi/asm/kvm.h             |  1 +
 arch/riscv/kernel/cpufeature.c                | 11 ++++++
 arch/riscv/kvm/vcpu_onereg.c                  |  1 +
 arch/riscv/kvm/vcpu_sbi_fwft.c                | 38 ++++++++++++++++++-
 .../selftests/kvm/riscv/get-reg-list.c        |  4 ++
 11 files changed, 71 insertions(+), 3 deletions(-)

-- 
2.17.1


