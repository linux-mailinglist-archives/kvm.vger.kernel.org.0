Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991E039AA0D
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 20:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFCSfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 14:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhFCSfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 14:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B93CF613B8;
        Thu,  3 Jun 2021 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622745237;
        bh=mTX1Gfilu39wfuOraE/ww5xMJ6bnVmsdjqCBug2xBWM=;
        h=From:To:Cc:Subject:Date:From;
        b=agvkfBC8twP+tZhCehKLs0SBWL16nvksI3UyUQj6xm1GIZPhO5HpmerqqHpATH39L
         NmrM/4dVMYBwnX58Ev1uVxlzuEfSy5kjFYRO8sdwV33yvzyTCr0rLV/5t8Odss5sVb
         752IfXNj6esCtWQgOVnjeAHmIsik6f95ttIVL0G+Qssa/HNGGKVhnShf+MGkCj1GBd
         rarZ3CMi78hBXCJOu81PQzciTGS7s7mOa6zFMe3b+IePp+WXzo/q6uUIfSgD8yS8wK
         s0KbvW9sO119NYEqXiAeHdizNEQCIHmR98fuz4qzZ6DZ0GDdViHYjod2WfTweEGn6q
         4AC0QbPYZa3LQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4] kvm/arm64: Initial pKVM user ABI
Date:   Thu,  3 Jun 2021 19:33:43 +0100
Message-Id: <20210603183347.1695-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

These patches implement support for userspace to request a "Protected VM"
using KVM on arm64 when configured in Protected Mode (see the existing
kvm-arm.mode=protected command-line option).

The final patch documents the new ABI and its behaviour, so I won't
reproduce that here. Please go and have a look there instead!

Note that this series _doesn't_ implement the actual isolation of guest
memory; it's more about setting the groundwork for subsequent patches
and getting feedback on the user-facing side of things. The final patch
is marked RFC accordingly.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com> 
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com> 
Cc: Fuad Tabba <tabba@google.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org

--->8

Will Deacon (4):
  KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
  KVM: arm64: Extend comment in has_vhe()
  KVM: arm64: Parse reserved-memory node for pkvm guest firmware region
  KVM: arm64: Introduce KVM_CAP_ARM_PROTECTED_VM

 .../admin-guide/kernel-parameters.txt         |   1 -
 Documentation/virt/kvm/api.rst                |  69 ++++++++
 arch/arm64/include/asm/kvm_host.h             |  10 ++
 arch/arm64/include/asm/virt.h                 |   3 +
 arch/arm64/include/uapi/asm/kvm.h             |   9 +
 arch/arm64/kernel/cpufeature.c                |  10 +-
 arch/arm64/kvm/Makefile                       |   2 +-
 arch/arm64/kvm/arm.c                          |  24 +--
 arch/arm64/kvm/mmu.c                          |   3 +
 arch/arm64/kvm/pkvm.c                         | 156 ++++++++++++++++++
 include/uapi/linux/kvm.h                      |   1 +
 11 files changed, 267 insertions(+), 21 deletions(-)
 create mode 100644 arch/arm64/kvm/pkvm.c

-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

