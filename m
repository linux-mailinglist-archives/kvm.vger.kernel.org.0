Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D3B17E083
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 13:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgCIMso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 08:48:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgCIMso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 08:48:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 285F620727;
        Mon,  9 Mar 2020 12:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583758124;
        bh=CSS+5INePZvmhimi/unCx0TEoioRr+d/iqq75Std27I=;
        h=From:To:Cc:Subject:Date:From;
        b=DByraDkcHaWW6E85jLzUQ23KZZw8zgL/sHKV0sqqrojbjcSmdvjv4QpPh1LVwr1w9
         BPEixptW++IaqFflCSjCZ5E03AGMNGh4mgsm58VieYChgPjUQaR/JwiZuTXPIjHuJW
         scaLyKQSpvuvNdN/wB1L2tH32qEregObfh7UZf+M=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jBHpq-00BHiN-C7; Mon, 09 Mar 2020 12:48:42 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 0/2] KVM: arm64: Filtering PMU events
Date:   Mon,  9 Mar 2020 12:48:35 +0000
Message-Id: <20200309124837.19908-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, eric.auger@redhat.com
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

* From v1:
  - Cleaned up handling of the cycle counter
  - Documented restrictions on SW_INC, CHAIN and CPU_CYCLES events

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/commit/?h=pmu-filter

Marc Zyngier (2):
  KVM: arm64: Add PMU event filtering infrastructure
  KVM: arm64: Document PMU filtering API

 Documentation/virt/kvm/devices/vcpu.rst | 40 ++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  6 ++
 arch/arm64/include/uapi/asm/kvm.h       | 16 +++++
 virt/kvm/arm/arm.c                      |  2 +
 virt/kvm/arm/pmu.c                      | 84 ++++++++++++++++++++-----
 5 files changed, 132 insertions(+), 16 deletions(-)

-- 
2.20.1

