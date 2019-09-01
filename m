Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75590A4C32
	for <lists+kvm@lfdr.de>; Sun,  1 Sep 2019 23:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbfIAVM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Sep 2019 17:12:57 -0400
Received: from foss.arm.com ([217.140.110.172]:46412 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbfIAVM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Sep 2019 17:12:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 552DE28;
        Sun,  1 Sep 2019 14:12:56 -0700 (PDT)
Received: from why.lan (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 180C73F718;
        Sun,  1 Sep 2019 14:12:54 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/3] arm64: KVM: Kiss hyp_alternate_select() goodbye
Date:   Sun,  1 Sep 2019 22:12:34 +0100
Message-Id: <20190901211237.11673-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hyp_alternate_select() is a leftover from the my second attempt at
supporting VHE (the first one was never merged, thankfully), and is
now an irrelevant relic. It was a way to patch function pointers
without having to dereference memory, a bit like static keys for
function calls.

Lovely idea, but since Christoffer mostly separated the VHE and !VHE
hypervisor paths, most of the uses of hyp_alternate_select() are
gone. What is left is two instances that are better replaced by
already existing static keys. One of the instances becomes
cpus_have_const_cap(), and the rest is a light sprinkling of
has_vhe().

So off it goes.

Marc Zyngier (3):
  arm64: KVM: Drop hyp_alternate_select for checking for
    ARM64_WORKAROUND_834220
  arm64: KVM: Replace hyp_alternate_select with has_vhe()
  arm64: KVM: Kill hyp_alternate_select()

 arch/arm64/include/asm/kvm_hyp.h | 24 ---------------------
 arch/arm64/kvm/hyp/switch.c      | 17 ++-------------
 arch/arm64/kvm/hyp/tlb.c         | 36 +++++++++++++++++++-------------
 3 files changed, 24 insertions(+), 53 deletions(-)

-- 
2.20.1

