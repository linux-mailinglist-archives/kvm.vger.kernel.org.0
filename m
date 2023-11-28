Return-Path: <kvm+bounces-2615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F10707FBD47
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E66B1C21104
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236815C074;
	Tue, 28 Nov 2023 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="eKvUmA/t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C381919B6
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:54:07 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1cfb3ee8bc7so27923595ad.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183247; x=1701788047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5oGoP2GtxpZiKciaDqaxx+4G6dOpwmCS0pkpDHBsR78=;
        b=eKvUmA/tZfVGUUtsS1mCGBo/vNlQGQd1FrNz1E7SLPArwfsQbyuWL6Qtz4400DYPPi
         U44PQtoPiY9zFOHVhrrkdOVAlgcYlOMhyHi5sek/KBloT7MSN5kK9N/aTJthMxvb5Waw
         7wDeT+N/ztpSHg4WmHIuEWN47OhCnf3m74zathhqhQemMexJozVMWfnryXRoJmec5rdb
         VqBWVdQV+jxhuOhF5zd/tlqw8ZtjyvHXIGaPeUrIVYig2BBSFy+WmuhiEj69e1ee7Gag
         +uJqrr5uAmGDz42hQW+ZU+YU2O/N1VOfSNx21UZdHbrlFpUdTDyUVXZWT9rJEqTQR9qg
         sB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183247; x=1701788047;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5oGoP2GtxpZiKciaDqaxx+4G6dOpwmCS0pkpDHBsR78=;
        b=RbKNB/v/HnZT6PErAwQ+QKiBEHv8pg/lmtEFlQWnkT8tOqNjFg0dvB977wCmguh20r
         TpnCh08+ymm/HnCW62bGWkEtP+w0DK9SyfX4EdiNvoA3ef8atb3Om4l8PWMnFtyMMIY6
         b+n77OydcXAS5V+v12e0LJrvw34M9JEG9FoqMc3ue1il4lrlyCJtVOQNanWo2N385R9G
         aKpRv2fUHc+GBI9Tpn8RdkVKXRnwlXmOCCNSVn5IRzn5rqZ4GGMIlKCFuNvLRwaTxufL
         0tjiys3EgCCGJp/JtY8CB4vjnF5Upk5c+pItCPAO83t+1lKn0DJuEu+dDWnDZp1YVGg7
         9gGw==
X-Gm-Message-State: AOJu0YwBLcHUasFurEeT3HXaXmMxB38Go67puN/3OkvVoScfG5n9lf1Z
	pPt2s+dUq5ywH7pmPuO6RPfjHA==
X-Google-Smtp-Source: AGHT+IGsBlwznYL+eO1YLtU9utrEhljJYsPZTHdTwczY6ki0/qgSD6wR3fyYBpktQqzZ0f4ggbB5sQ==
X-Received: by 2002:a17:902:e88a:b0:1cf:cf34:d504 with SMTP id w10-20020a170902e88a00b001cfcf34d504mr8424957plg.36.1701183247023;
        Tue, 28 Nov 2023 06:54:07 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001bf11cf2e21sm10281552plg.210.2023.11.28.06.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:54:06 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 00/15] KVM RISC-V report more ISA extensions through ONE_REG
Date: Tue, 28 Nov 2023 20:23:42 +0530
Message-Id: <20231128145357.413321-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This extends the KVM RISC-V ONE_REG interface to report more ISA extensions
namely: Zbz, scalar crypto, vector crypto, Zfh[min], Zihintntl, Zvfh[min],
and Zfa.

This series depends upon the "riscv: report more ISA extensions through
hwprobe" series.from Clement.
(Link: https://lore.kernel.org/lkml/20231114141256.126749-1-cleger@rivosinc.com/)

To test these patches, use KVMTOOL from the riscv_more_exts_v1 branch at:
https://github.com/avpatel/kvmtool.git

These patches can also be found in the riscv_kvm_more_exts_v1 branch at:
https://github.com/avpatel/linux.git

Anup Patel (15):
  KVM: riscv: selftests: Generate ISA extension reg_list using macros
  RISC-V: KVM: Allow Zbc extension for Guest/VM
  KVM: riscv: selftests: Add Zbc extension to get-reg-list test
  RISC-V: KVM: Allow scalar crypto extensions for Guest/VM
  KVM: riscv: selftests: Add scaler crypto extensions to get-reg-list
    test
  RISC-V: KVM: Allow vector crypto extensions for Guest/VM
  KVM: riscv: selftests: Add vector crypto extensions to get-reg-list
    test
  RISC-V: KVM: Allow Zfh[min] extensions for Guest/VM
  KVM: riscv: selftests: Add Zfh[min] extensions to get-reg-list test
  RISC-V: KVM: Allow Zihintntl extension for Guest/VM
  KVM: riscv: selftests: Add Zihintntl extension to get-reg-list test
  RISC-V: KVM: Allow Zvfh[min] extensions for Guest/VM
  KVM: riscv: selftests: Add Zvfh[min] extensions to get-reg-list test
  RISC-V: KVM: Allow Zfa extension for Guest/VM
  KVM: riscv: selftests: Add Zfa extension to get-reg-list test

 arch/riscv/include/uapi/asm/kvm.h             |  27 ++
 arch/riscv/kvm/vcpu_onereg.c                  |  54 +++
 .../selftests/kvm/riscv/get-reg-list.c        | 439 ++++++++----------
 3 files changed, 265 insertions(+), 255 deletions(-)

-- 
2.34.1


