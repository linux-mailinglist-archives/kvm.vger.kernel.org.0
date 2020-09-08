Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA89260CC4
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgIHH67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729552AbgIHH6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:58:47 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FE312177B;
        Tue,  8 Sep 2020 07:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599551926;
        bh=e6KbWIX9OGeN9VN1JOdQtcvcUKxjsb2qiPcRPoyCsHw=;
        h=From:To:Cc:Subject:Date:From;
        b=V1GMiEH9/wCXi86KUjxIxMq6EbokUbEMvdMoN9ec2AwdoITqXPXjibb9zdCyFJbRq
         cWd8wXlxr0/odYmPSOXIFyrc6431tYf+wYKYrSpmoS+O7G0gdPnF3kZp1HEUR11E5E
         2H/Pf4DZNNsvKJBvFrH6NuWqVf/Uvf9gSjxy5LbQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kFYWa-009zhy-Jg; Tue, 08 Sep 2020 08:58:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>, graf@amazon.com,
        kernel-team@android.com
Subject: [PATCH v3 0/5] KVM: arm64: Filtering PMU events
Date:   Tue,  8 Sep 2020 08:58:25 +0100
Message-Id: <20200908075830.1161921-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, eric.auger@redhat.com, graf@amazon.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is at times necessary to prevent a guest from being able to sample
certain events if multiple CPUs share resources such as a cache level. In
this case, it would be interesting if the VMM could simply prevent certain
events from being counted instead of hiding the PMU.

Given that most events are not architected, there is no easy way to
designate which events shouldn't be counted other than specifying the raw
event number.

Since I have no idea whether it is better to use an event whitelist or
blacklist, the proposed API takes a cue from the x86 version and allows
either allowing or denying counting of ranges of events. The event space
being pretty large (16bits on ARMv8.1), the default policy is set by the
first filter that gets installed (default deny if we first allow, default
allow if we first deny).

The filter state is global to the guest, despite the PMU being per CPU. I'm
not sure whether it would be worth it making it CPU-private.

As an example of what can be done in userspace, I have the corresponding
kvmtool hack here[1].

* From v2:
  - Split out the error handling refactor for clarity
  - Added a terrible hack to fish out the PMU version, because BL is great
  - Update the guest's view of PCMEID{0,1}_EL1
  - General tidying up

* From v1:
  - Cleaned up handling of the cycle counter
  - Documented restrictions on SW_INC, CHAIN and CPU_CYCLES events

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/commit/?h=pmu-filter

Marc Zyngier (5):
  KVM: arm64: Refactor PMU attribute error handling
  KVM: arm64: Use event mask matching architecture revision
  KVM: arm64: Add PMU event filtering infrastructure
  KVM: arm64: Mask out filtered events in PCMEID{0,1}_EL1
  KVM: arm64: Document PMU filtering API

 Documentation/virt/kvm/devices/vcpu.rst |  46 ++++++
 arch/arm64/include/asm/kvm_host.h       |   7 +
 arch/arm64/include/uapi/asm/kvm.h       |  16 ++
 arch/arm64/kvm/arm.c                    |   2 +
 arch/arm64/kvm/pmu-emul.c               | 199 +++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c               |   5 +-
 include/kvm/arm_pmu.h                   |   5 +
 7 files changed, 254 insertions(+), 26 deletions(-)

-- 
2.28.0

