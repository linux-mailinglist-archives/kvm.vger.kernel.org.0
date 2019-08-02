Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB87F52C
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 12:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfHBKhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 06:37:45 -0400
Received: from foss.arm.com ([217.140.110.172]:49370 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbfHBKhp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 06:37:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 087D2344;
        Fri,  2 Aug 2019 03:37:45 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A60B53F71F;
        Fri,  2 Aug 2019 03:37:43 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Tangnianyao <tangnianyao@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/2] KVM: arm/arm64: Fix guest's PMR synchronization when blocking on WFI
Date:   Fri,  2 Aug 2019 11:37:07 +0100
Message-Id: <20190802103709.70148-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It recently came to light that if we run a guest that actively uses
interrupt priorities to block interrupts, vcpus can end-up being
blocked while they shouldn't, leading to an unresponsive guest (a
slightly less than desirable outcome).

Patch #1 fixes the issue (which has been with us since 4.12), which I plan
to take in for 5.3 with immediate backport to stable.

Patch #2 is more of an RFC, as it also impacts the SVN AVIC support. It
moves the kvm_arch_vcpu_blocking callback to happen earlier, leading to
much better performances on ARM, and leading to the above fix to be
applied at the best possible spot. I'd welcome any comment/testing on
this, specially on non-ARM systems.

Marc Zyngier (2):
  KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block
  KVM: Call kvm_arch_vcpu_blocking early into the blocking sequence

 include/kvm/arm_vgic.h      |  1 +
 virt/kvm/arm/arm.c          | 11 +++++++++++
 virt/kvm/arm/vgic/vgic-v2.c |  9 ++++++++-
 virt/kvm/arm/vgic/vgic-v3.c |  7 ++++++-
 virt/kvm/arm/vgic/vgic.c    | 11 +++++++++++
 virt/kvm/arm/vgic/vgic.h    |  2 ++
 virt/kvm/kvm_main.c         |  7 +++----
 7 files changed, 42 insertions(+), 6 deletions(-)

-- 
2.20.1

