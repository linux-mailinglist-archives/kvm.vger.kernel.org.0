Return-Path: <kvm+bounces-42562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED175A7A1ED
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F37CB1896F97
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D8C24C06E;
	Thu,  3 Apr 2025 11:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oTL+AHk7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC80242907
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 11:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743679935; cv=none; b=qJvfi5Mon1+AvoJ3y5tV6mVCHG+dZjp9ZDxc5gGCU3QBOFo6ljXpCYIgc5GHgih/bjCLNc63KQrx9iCO29VwYjjXq2w0/pWgBos7A95Hx444o+wOCD9pVSGMQrbDKcyc0IrJZaBCuRSz2BPDqDP+JscFEpO4U/3J4yR3He6bLoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743679935; c=relaxed/simple;
	bh=81CpPwNVUGBQ1IoKRd80/VDp98uX+46nUa94lnHysns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GACZLGFBh/jhDMnuC+VaRptrB3nTl+wAVnmQOPbsi21OL8LiZfH/MHFxiPiBoiGI2zR23EiNCUYmQ7e2jmq2ehL/iu9NLVetmu6s2u6e8mhvK89DpICfFjYAZWHvhGXFjP8Gg3SLRAeqESIbZxRrs8WUyUY4h16yz9FtAFODcC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oTL+AHk7; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39123d2eb7fso109486f8f.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 04:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1743679931; x=1744284731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uzJLKlljfvfxPvPUZeysuKSPBVSnoaOxnTXwCnBbatE=;
        b=oTL+AHk7+pdvW5O7QsSLK/sZQdf3BBDK02IqEFHix6agx98uX8T80Om0DHAqkdHpI9
         nuHSyQ9vMDfGmcy5Nd1fYOqIp+28n6omrSLUQicbqSbCaEp2aA2OaO7jTg3SyulDnsDq
         6G/jncpJskUQIWpvBcP36mCX+zSKzQFMKnUg5aukK+c+qKSNIN6zVzZ6zp52pK1yOrHv
         OqAy+JUlv7XIkAfSKequUVwQwirUwY9s9XzZ5ZcxffQajs1rKaLcm9V+o+zkiwMBjaUu
         gvfyIC1uJmsQalCasQTq/7NSeX0tESCI9XFRbgk2GhJrPHN8fc+sc1kNHjEjxZg4j9gM
         J9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743679931; x=1744284731;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uzJLKlljfvfxPvPUZeysuKSPBVSnoaOxnTXwCnBbatE=;
        b=CSlaluUwjR8S2h0dotu+Xmu9bRIhaQ3TLuE1YWZAiI2inM3csKbcohAjKtQQvY9fU1
         EYMn6My98xJMPZsLmTiZGLMDZaOaqCLa/dQ/uR00erIfOzJyzMBGxYjoeUvDVmgWfn72
         U5/YcLonpsJa/+XMq/shfGBrgRjxAoz/ONTWkkvtOwWcZfTmLdXhY7jKwfrLupWFCbBl
         94VYphDWnkE+nXC9aTpqZK2Jx1tFLx9cHMmS67A1uxJfwm4qisNPMR+fWTEmZJLsSAlL
         PfvdaDp/AWBJjmc5+a6fxJr2P6w39HsMCFcXVMcujAPpa1RQ4kZTh7yIilaOIeG9GV3Z
         dFTg==
X-Gm-Message-State: AOJu0YzDbMlZEIYx3lneVeeStuw0CY/Tq46UfSlPZ8G6ruft12X3et3A
	2D5tayhJxo7hNmMDId+JEaP7r+BLWdAoZEBO/3DYKUB7Mo0CNCBh5pxBancyOr8=
X-Gm-Gg: ASbGncvZtydSm7j1qxPgE1uYFxSsi4sKGgHPIUDRV041DRD2WpK93vQTyL9jU4pHdZ9
	UacsLpu6pVBPZQIq87qdcpWTRsiVnoIlwiNEKRzDg5Kv93kZJIdRBKZOxV9SBLTV7Ju6Jx1bir6
	zKHmAD190dlNwef4yqSCApq+1PpZbUkOeD5BZH4+1BCzkYOZNDeP1PFUUx2MueBwCj/SwoXfdE6
	e1Q8VyaIkT2aVqMDNh7hwzrlJOxVEypDrEp8dw91cU2Lz9kDTXn/7RhggbvyxLmPEp9i5zmC+Tj
	4FXLEBs2MHfunU+tmZgcyKNWQSz4/O49pnmy1n1X2HKEd3txeJkr4ol8Pq7nE4vnzm71QGG89Nv
	PTg==
X-Google-Smtp-Source: AGHT+IH6xifwXMVfMLClIlm2BzAh7GveRJDcwc65VzrAXzSC6fsdF3OjurjTLfO2TtkYTUXlVLDtBQ==
X-Received: by 2002:a5d:64e9:0:b0:391:2a9a:47a6 with SMTP id ffacd0b85a97d-39c120db3demr6114098f8f.4.1743679931180;
        Thu, 03 Apr 2025 04:32:11 -0700 (PDT)
Received: from localhost (cst2-173-141.cust.vodafone.cz. [31.30.173.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec3669d0fsm15884455e9.36.2025.04.03.04.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 04:32:10 -0700 (PDT)
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
	Andrew Jones <ajones@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>
Subject: [PATCH 0/5] KVM: RISC-V: VCPU reset fixes
Date: Thu,  3 Apr 2025 13:25:19 +0200
Message-ID: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

this series started with a simple fix [5/5], which sadly didn't fix
enough without [4/5].  [1-3/5] are refactors to make the reset a bit
easier to follow.  ([1-3,5/5] are applicable without [4/5].)

[4/5] changes the userspace ABI and I'd like to gather your opinions on
how the ABI is supposed to work.

As another proposal, what do you think about an IOCTL that allows
userspace to invoke any KVM SBI ecall?
Userspace could call the KVM HSM implementation to reset and start a
VCPU, but I think that kvm_mp_state is an SBI HSM interface, so we have
an obscure IOCTL for it already.
I was also thinking about using KVM_MP_STATE_UNINITIALIZED to
distinguish that KVM should reset the state when becoming runnable.

I recommend to start with the following hunk in [4/5], as it's the only
significant part of this series:

  @@ -520,6 +525,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
   
   	switch (mp_state->mp_state) {
   	case KVM_MP_STATE_RUNNABLE:
  +		if (riscv_vcpu_supports_sbi_ext(vcpu, KVM_RISCV_SBI_EXT_HSM) &&
  +				vcpu->arch.ran_atleast_once &&
  +				kvm_riscv_vcpu_stopped(vcpu))
  +			kvm_riscv_vcpu_sbi_request_reset_from_userspace(vcpu);

Thanks.

Radim Krčmář (5):
  KVM: RISC-V: refactor vector state reset
  KVM: RISC-V: refactor sbi reset request
  KVM: RISC-V: remove unnecessary SBI reset state
  KVM: RISC-V: reset VCPU state when becoming runnable
  KVM: RISC-V: reset smstateen CSRs

 arch/riscv/include/asm/kvm_aia.h         |  3 --
 arch/riscv/include/asm/kvm_host.h        | 13 +++--
 arch/riscv/include/asm/kvm_vcpu_sbi.h    |  5 ++
 arch/riscv/include/asm/kvm_vcpu_vector.h |  6 +--
 arch/riscv/kvm/aia_device.c              |  4 +-
 arch/riscv/kvm/vcpu.c                    | 69 +++++++++++++++---------
 arch/riscv/kvm/vcpu_sbi.c                | 28 ++++++++++
 arch/riscv/kvm/vcpu_sbi_hsm.c            | 13 +----
 arch/riscv/kvm/vcpu_sbi_system.c         | 10 +---
 arch/riscv/kvm/vcpu_vector.c             | 13 ++---
 10 files changed, 97 insertions(+), 67 deletions(-)

-- 
2.48.1


