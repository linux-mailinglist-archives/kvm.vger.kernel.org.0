Return-Path: <kvm+bounces-45612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5DEAACB40
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CDE83BD0DB
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697D2284B55;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AB7dyfjo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A8C252282;
	Tue,  6 May 2025 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549848; cv=none; b=JzXt9BNvy10S4yah1YAJJMUmFj6qT21O9vC0b1r/XlNR7yi4amzqbK/M2mhhzBUIIgyNDCsXqBVeE9HcGMpXfYjRA0g/0ErZ7WQ7qu3KBLhUkBnw1vXlEZdL2CEL4eSeW/MYBbsTbLUMmQaI7a/+leZYBGXDdaAubNYY31dXVZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549848; c=relaxed/simple;
	bh=geXjI7e3xVdMJHmwrLdJeTsuEUT9kysy5HNGfgTThy8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tHpkngGAwCxAcGzgqwNuB5tn3fkw+i9h37w/TrVZMYsSfDEi1IFADlk/AN3FfZOnjB92kL4Fem7zhD5K5x0BvlOj3XMpwXuzK1hUMa2njaIXMZdoxHbYIh6Ox8Az54xBP6JYegAXkiSojyW8jyQDmyQUJnhzlN+NWL/GJXUSqBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AB7dyfjo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0834AC4CEE4;
	Tue,  6 May 2025 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549848;
	bh=geXjI7e3xVdMJHmwrLdJeTsuEUT9kysy5HNGfgTThy8=;
	h=From:To:Cc:Subject:Date:From;
	b=AB7dyfjozKuZZqAC7hFPnftj1PglNR0DKf6/pY2BR8VNm9yuH35JwXj4/KBcmAMhs
	 KaLFsDgxYB8F3fLnIVdp3AEwXlbfLz8eduN0sj343ffdM1oEaM74jdavkDbpJGfyC+
	 +WbK73LO0svX1BsERv8FWXSuneKDySyuFVe4GrqnrriJWcFdr/mU39tu/tqMC6EOcZ
	 2Gd+obaXTtdmxtxQ3LzxEy2iBVZznhmGCytPqsnVCRloTYv2ROQWyRqM5KOoUL38of
	 YbIzh/OxrsVUqhi3SwbWHRbYoCBf7Qxidr8qd4eXl6isupIoManoSVsMjNTXDa0jjk
	 lcPDOmdKwQh7Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOn-00CJkN-Mg;
	Tue, 06 May 2025 17:44:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 00/43] KVM: arm64: Revamp Fine Grained Trap handling
Date: Tue,  6 May 2025 17:43:05 +0100
Message-Id: <20250506164348.346001-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is yet another version of the series last posted at [1].

The eagled eye reviewer will have noticed that since v2, the series
has more or less doubled in size for any reasonable metric (number of
patches, number of lines added or deleted). It is therefore pretty
urgent that this gets either merged or forgotten! ;-)

See the change log below for the details -- most of it is related to
FGT2 (and its rather large dependencies) being added.

* From v3:

  - Added missing bit fields for CPACR_EL1

  - Fixed a bunch of typos in comments and commit messages

  - Cleaned-up whitespace damage from the sysreg generator

  - Collected RBs from Joey, with thanks!

* From v2:

  - Added comprehensive support for FEAT_FGT2, as the host kernel is
    now making use of these registers, without any form of context
    switch in KVM. What could possibly go wrong?

  - Reworked some of the FGT description and handling primitives,
    reducing the boilerplate code and tables that get added over time.

  - Rebased on 6.15-rc3.

[1]: https://lore.kernel.org/r/20250426122836.3341523-1-maz@kernel.org

Marc Zyngier (42):
  arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64 encoding for FEAT_LS64WB
  arm64: sysreg: Update ID_AA64MMFR4_EL1 description
  arm64: sysreg: Add layout for HCR_EL2
  arm64: sysreg: Replace HFGxTR_EL2 with HFG{R,W}TR_EL2
  arm64: sysreg: Update ID_AA64PFR0_EL1 description
  arm64: sysreg: Update PMSIDR_EL1 description
  arm64: sysreg: Update TRBIDR_EL1 description
  arm64: sysreg: Update CPACR_EL1 description
  arm64: sysreg: Add registers trapped by HFG{R,W}TR2_EL2
  arm64: sysreg: Add registers trapped by HDFG{R,W}TR2_EL2
  arm64: sysreg: Add system instructions trapped by HFGIRT2_EL2
  arm64: Remove duplicated sysreg encodings
  arm64: tools: Resync sysreg.h
  arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
  arm64: Add FEAT_FGT2 capability
  KVM: arm64: Tighten handling of unknown FGT groups
  KVM: arm64: Simplify handling of negative FGT bits
  KVM: arm64: Handle trapping of FEAT_LS64* instructions
  KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_LS64_ACCDATA being
    disabled
  KVM: arm64: Don't treat HCRX_EL2 as a FGT register
  KVM: arm64: Plug FEAT_GCS handling
  KVM: arm64: Compute FGT masks from KVM's own FGT tables
  KVM: arm64: Add description of FGT bits leading to EC!=0x18
  KVM: arm64: Use computed masks as sanitisers for FGT registers
  KVM: arm64: Propagate FGT masks to the nVHE hypervisor
  KVM: arm64: Use computed FGT masks to setup FGT registers
  KVM: arm64: Remove hand-crafted masks for FGT registers
  KVM: arm64: Use KVM-specific HCRX_EL2 RES0 mask
  KVM: arm64: Handle PSB CSYNC traps
  KVM: arm64: Switch to table-driven FGU configuration
  KVM: arm64: Validate FGT register descriptions against RES0 masks
  KVM: arm64: Use FGT feature maps to drive RES0 bits
  KVM: arm64: Allow kvm_has_feat() to take variable arguments
  KVM: arm64: Use HCRX_EL2 feature map to drive fixed-value bits
  KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits
  KVM: arm64: Add FEAT_FGT2 registers to the VNCR page
  KVM: arm64: Add sanitisation for FEAT_FGT2 registers
  KVM: arm64: Add trap routing for FEAT_FGT2 registers
  KVM: arm64: Add context-switch for FEAT_FGT2 registers
  KVM: arm64: Allow sysreg ranges for FGT descriptors
  KVM: arm64: Add FGT descriptors for FEAT_FGT2
  KVM: arm64: Handle TSB CSYNC traps

Mark Rutland (1):
  KVM: arm64: Unconditionally configure fine-grain traps

 arch/arm64/include/asm/el2_setup.h      |   14 +-
 arch/arm64/include/asm/esr.h            |   10 +-
 arch/arm64/include/asm/kvm_arm.h        |  186 ++--
 arch/arm64/include/asm/kvm_host.h       |   56 +-
 arch/arm64/include/asm/sysreg.h         |   26 +-
 arch/arm64/include/asm/vncr_mapping.h   |    5 +
 arch/arm64/kernel/cpufeature.c          |    7 +
 arch/arm64/kvm/Makefile                 |    2 +-
 arch/arm64/kvm/arm.c                    |   13 +
 arch/arm64/kvm/config.c                 | 1085 +++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c         |  583 ++++++++----
 arch/arm64/kvm/handle_exit.c            |   77 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  158 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c        |   12 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c         |    8 +-
 arch/arm64/kvm/nested.c                 |  223 +----
 arch/arm64/kvm/sys_regs.c               |   68 +-
 arch/arm64/tools/cpucaps                |    1 +
 arch/arm64/tools/sysreg                 | 1006 ++++++++++++++++++++-
 tools/arch/arm64/include/asm/sysreg.h   |   65 +-
 20 files changed, 2894 insertions(+), 711 deletions(-)
 create mode 100644 arch/arm64/kvm/config.c

-- 
2.39.2


