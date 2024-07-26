Return-Path: <kvm+bounces-22301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E2F93CFD4
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 10:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A2921C20EFE
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCF4176AD5;
	Fri, 26 Jul 2024 08:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ezE2s6oA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D322E64B
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 08:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721983778; cv=none; b=eXnZ8Y4zJgk/57iYESUaJDWevVccPW5OsmOcknGs7sG24tbnOIoiIoq3w5G9H2bRiZuCYkxQ+Xja9GAw3htjYYKgiWi6ljLY9hezxnYpKptLlzHbUbnbHAqjsudKLX7uzdPtPxW7CJbf3euLid1rYctcpA1iUmwKXT8f3xcNQ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721983778; c=relaxed/simple;
	bh=cggH4Zf9zWp/WsOUF+1J+LtjLbXgCppNL6AUS86c1Mg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=HkNTfNVwQ8Rmtkget1tBwXi6XySaw9pLTgvkMm0fYGW+0WP1mVZ4FW/9P0P2vFbCUqho/cgwMtnPW4sLXhP8Bi7rwK3c1cnAA3p72Kg9SRxe3uRnXZO7G5jsZjeUcIvO4/CRlViRk73BtZ67Bz8ZQW0OF2n6lDvXaFvOuZGEVu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=ezE2s6oA; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-395e9f2ebc0so6629165ab.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 01:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1721983776; x=1722588576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7XZtOcVU71qgefN2Ru/3ZszUxxOG8b1uowiT0jlNrFY=;
        b=ezE2s6oA6wks8hvVIkdEbha3uNd+g+tuSnd7GTCZngIvznloylH8pzjYvgzvyeXehx
         5EzZJINc9abMjH+evqcwFtUSYqRPgGWCL40N7meyavXLmVpM8+0zZUPmGF5MMDvSYL4W
         DCBW0HkBzLr8sjzYuVGsYDx+WBfudO7QDn48qujopymE7Xtr2L457suxOV4ZGmtfNERy
         jhVpyTewzPCte89NKWVC03hdCjr9PL4JIjbCUKNyo84m7wi5I7GIcWmr1psOYGByl/CC
         YX0CdVlT5Zn6UvIzrMlV3huAAjjRdg2MPLU4FeGF0cmphR+i359ebEebgh+VRN7oOs2h
         vbgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721983776; x=1722588576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7XZtOcVU71qgefN2Ru/3ZszUxxOG8b1uowiT0jlNrFY=;
        b=a+oanFD8znylMj/SpUYqHYmO4JeUHSXpL30YI3hLMeX9cwNZgHr1+2ZanaHiDkGVWI
         ll/C5o+C4OD7pN+s01IGe0PV52hLUuxX0e2419Nd5X3xN46k50+2XHKI+6S6ZVHDHHp2
         nobL+c1RDw7ZrMD2NLqPwjpMO7Xo48MswUvxoVL4NeQSf42VGA+QzdSGITsYf19eUJKy
         mJWFiZH44q3Bisn2rqsCOOj4rqOaRD3c1fgWHga3n4cZ12YthG3/1sMyP9fDSZ29ofGf
         QWx4ZPVtK2alxBjl4dmDPzUjML0mFMSLB19tnr/7xebUuV2b232ZX9Ngep/Or/VjcNWo
         RhFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU72d7XCkAgAprZV7SHSjYdygdLeAQv97jI0vaCkaDNFxSbJuc6X8u1Vsr9Jp5ksJBolBQCV2e5zYN59RXqwyOJLeff
X-Gm-Message-State: AOJu0YzFnAtHHvWnQEA3Umfn8ZFlFS43zkkqsLi/JPkghAcLl++icXtu
	dKtVxd/Tn9TJaKjV2SOLjKKyQSlVNFXQ1e8mKHOeicnSOhN35gpwfzXTuHf3ov4=
X-Google-Smtp-Source: AGHT+IGIIC3hug3f1RinXPtTRLJ3e0ZL1wTw+7Nz0b4GXlvTkp9mdYRpo/TwavDaXmzo1aFws3QMLA==
X-Received: by 2002:a05:6e02:1aa1:b0:379:40e0:b0b8 with SMTP id e9e14a558f8ab-39a2185d921mr63531485ab.20.1721983775853;
        Fri, 26 Jul 2024 01:49:35 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9f816db18sm2049645a12.33.2024.07.26.01.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 01:49:35 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v8 0/5] Add Svade and Svadu Extensions Support
Date: Fri, 26 Jul 2024 16:49:25 +0800
Message-Id: <20240726084931.28924-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Svade and Svadu extensions represent two schemes for managing the PTE A/D
bit. When the PTE A/D bits need to be set, Svade extension intdicates that
a related page fault will be raised. In contrast, the Svadu extension
supports hardware updating of PTE A/D bits. This series enables Svade and
Svadu extensions for both host and guest OS.

Regrading the mailing thread[1], we have 4 possible combinations of
these extensions in the device tree, the default hardware behavior for
these possibilities are:
1) Neither Svade nor Svadu present in DT => It is technically
   unknown whether the platform uses Svade or Svadu. Supervisor
   software should be prepared to handle either hardware updating
   of the PTE A/D bits or page faults when they need updated.
2) Only Svade present in DT => Supervisor must assume Svade to be
   always enabled.
3) Only Svadu present in DT => Supervisor must assume Svadu to be
   always enabled.
4) Both Svade and Svadu present in DT => Supervisor must assume
   Svadu turned-off at boot time. To use Svadu, supervisor must
   explicitly enable it using the SBI FWFT extension.

The Svade extension is mandatory and the Svadu extension is optional in
RVA23 profile. Platforms want to take the advantage of Svadu can choose
3. Those are aware of the profile can choose 4, and Linux won't get the
benefit of svadu until the SBI FWFT extension is available.

[1] https://lore.kernel.org/linux-kernel/20240527-e9845c06619bca5cd285098c@orel/T/#m29644eb88e241ec282df4ccd5199514e913b06ee

---
v8:
- fix typo in PATCH1 (Samuel)
- use the new extension validating API in PATCH1 (Clément)
- update the dtbinding in PATCH2 (Samuel, Conor)
- add PATCH4 to fix compile error in get-reg-list test.

v7:
- fix alignment in PATCH1
- update the dtbinding in PATCH2 (Conor, Jessica)

v6:
- reflect the platform's behavior by riscv_isa_extension_available() and
  update the the arch_has_hw_pte_young() in PATCH1 (Conor, Andrew)
- update the dtbinding in PATCH2 (Alexandre, Andrew, Anup, Conor)
- update the henvcfg condition in PATCH3 (Andrew)
- check if Svade is allowed to disabled based on arch_has_hw_pte_young()
  in PATCH3

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

Yong-Xuan Wang (5):
  RISC-V: Add Svade and Svadu Extensions Support
  dt-bindings: riscv: Add Svade and Svadu Entries
  RISC-V: KVM: Add Svade and Svadu Extensions Support for Guest/VM
  KVM: riscv: selftests: Fix compile error
  KVM: riscv: selftests: Add Svade and Svadu Extension to get-reg-list
    test

 .../devicetree/bindings/riscv/extensions.yaml | 28 +++++++++++++++++++
 arch/riscv/Kconfig                            |  1 +
 arch/riscv/include/asm/csr.h                  |  1 +
 arch/riscv/include/asm/hwcap.h                |  2 ++
 arch/riscv/include/asm/pgtable.h              | 13 ++++++++-
 arch/riscv/include/uapi/asm/kvm.h             |  2 ++
 arch/riscv/kernel/cpufeature.c                | 12 ++++++++
 arch/riscv/kvm/vcpu.c                         |  4 +++
 arch/riscv/kvm/vcpu_onereg.c                  | 15 ++++++++++
 .../selftests/kvm/riscv/get-reg-list.c        | 16 ++++++++---
 10 files changed, 89 insertions(+), 5 deletions(-)

-- 
2.17.1


