Return-Path: <kvm+bounces-25620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DFF696713E
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2670B217AA
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24C917D378;
	Sat, 31 Aug 2024 11:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ALjUV7lA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8631F33EA
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725103680; cv=none; b=nnLeo1lcQ5CFoJ++sLkrl92DZE4PsnUSFyCQHvj07gYl9KRZapAQ5avR/nBZWmv1GxAkiZT+N1bdwbU40V7bNtAu2Q04vKtm21RLit10VJWChdbp01w9tNJYDmtgPYPMwWWLhVgF1n4BKLMQLwX63ZWxu1HZBl20ykvEfL1jM4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725103680; c=relaxed/simple;
	bh=r8NsQw+jaEgJsnGcyXl/FAiH/KbRm8Hp9MqcUaqpkVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aDSCUs1co06u61/PqMED4bfUCUN8c+5lb/bpxIl4IryPlrH+S5b8DyJndP9Q8icfk98LuNkP7mdBPjtHGX4hEpM/LaKYH6boOebBSIvHDIfY8ERgsBrwU4lWpzZC1+9XouGV6O5IoNYyLAsqb5xZBKwUsjKnp194mRyxzK54e1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ALjUV7lA; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7c6b4222fe3so1788307a12.3
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 04:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1725103679; x=1725708479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FcylZIvitDXH2JbkwFnrxWj1RNQGgFDeZyR/6A5WZmE=;
        b=ALjUV7lA+Uk1TAcIqsRb39GX7dMBZF1C1GctfwpGsTa9JZFkVOPiDQsjX2c7gWIKQU
         6IYAtSb3wWHP5JHjWos+XoS+hbw0UJGn0OVcYhQK0mn7q+lEZs3rfkjhVrRDvT4OP1fQ
         WCEldPon4wB6lyiWN20+dq7G9ORieV3sXC0zNeb13E3UQAHPlc81yRr8WslmNU0ccwOC
         /SGSaBPzkSjuJXqhsyhBXLuOJ7Ym+04aAPXjSnISz4foXzNs+o0rzt5y1vQrRAB1K3LI
         +n7QQZ7OvM0mRy5H8qH9qmTMQm0IxoRZwdi+Vi86L8upoxCFddcFTOgTxLtNwQJatNou
         mbZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725103679; x=1725708479;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FcylZIvitDXH2JbkwFnrxWj1RNQGgFDeZyR/6A5WZmE=;
        b=ra528UlmDCDoOAQqIiW/thszdjGWylMkkIb26fM/zZ9POEN4ciGdz9SmZRMNF7pZ6f
         pByxrZR1ZpxsA/Umx75+DPEv2WP9ENILK7CCend0Oqimnwqhp7GnJZMnzyRoQEy87X0q
         vdv2g+RiqVQynxOoRa70sk8Nan5RuhVKQJJj2iBaTJ+Cn3msnvcHuRATDO/ygN9vqFAm
         C0TNwkGZDrxHuZqfXi820TNRaO0XXjGwiMsFb20CFCKCPB1pO+RWtUxIVj6JsoAoSv08
         1TadW8RyQclHfVjp6ol5Fkihja5m6Dg83iwwqgfNgQLGyNlrwaNtuavMv0FyG78gxaoY
         WCAw==
X-Forwarded-Encrypted: i=1; AJvYcCWghQWr5Y29v4U4Cm5jTs/c4Rw/i1oX5WTqAH+yq6B4xcoVeqnrvDHadXbSGE0IPus0Hmo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7AI3gPOE3fE33N17yJsNifHq8mnEfBKc4q0hceYz2ZdfQtibz
	v40gbslN6pRxm9S3WuOnIJhTNgkXcQbsE0x6JKyKqGJLgVAUp7iVSHjbiIyZniM=
X-Google-Smtp-Source: AGHT+IFHBarIky+gn6crdqAIyskR7PjMTfY0nJXHypkqIeBmR8aVb4N7PYoWNPkMPRolZNxxOyH9Mw==
X-Received: by 2002:a17:902:c94a:b0:202:3dcd:23ef with SMTP id d9443c01a7336-205447bc4c5mr17310615ad.61.1725103678391;
        Sat, 31 Aug 2024 04:27:58 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20542d5d1b2sm11934415ad.36.2024.08.31.04.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 04:27:57 -0700 (PDT)
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
Subject: [kvmtool PATCH 0/8] Add RISC-V ISA extensions based on Linux-6.11
Date: Sat, 31 Aug 2024 16:57:35 +0530
Message-ID: <20240831112743.379709-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds support for new ISA extensions based on Linux-6.11
namely: Zawrs, Zca, Zcb, Zcd, Zcf, Zcmop, and Zimop.

These patches can also be found in the riscv_more_exts_round4_v1 branch
at: https://github.com/avpatel/kvmtool.git

Anup Patel (8):
  Sync-up headers with Linux-6.11-rc4 kernel
  riscv: Add Zawrs extension support
  riscv: Add Zca extension support
  riscv: Add Zcb extension support
  riscv: Add Zcd extension support
  riscv: Add Zcf extension support
  riscv: Add Zcmop extension support
  riscv: Add Zimop extension support

 include/linux/kvm.h                 | 27 +++++++++++++++-
 powerpc/include/asm/kvm.h           |  3 ++
 riscv/fdt.c                         |  7 +++++
 riscv/include/asm/kvm.h             |  7 +++++
 riscv/include/kvm/kvm-config-arch.h | 21 +++++++++++++
 x86/include/asm/kvm.h               | 49 +++++++++++++++++++++++++++++
 6 files changed, 113 insertions(+), 1 deletion(-)

-- 
2.43.0


