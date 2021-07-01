Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF43B9423
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 17:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhGAPnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 11:43:40 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51740 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhGAPnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 11:43:40 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A491022891;
        Thu,  1 Jul 2021 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=upovNwSZjv8f/iecsKALo/k8SCqL9R0LoxKlal4MHxw=;
        b=b4fYRKsHielTGsj+p0iJjnZfPn8+LTBhqB6ZyhTEUT9lDbF2wSVPpn6+4aTMKANIhTHdkw
        VgRt3j0/5duL08x9ABYMvZv+/vYaznkIaqmekSXYgQUAC+25fSOuVe1nsIuJwvXQ4zTv5z
        8mX/m1WcA9MsMHqfBDrh25S2ifLzPi8=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 1D66011CD5;
        Thu,  1 Jul 2021 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=upovNwSZjv8f/iecsKALo/k8SCqL9R0LoxKlal4MHxw=;
        b=b4fYRKsHielTGsj+p0iJjnZfPn8+LTBhqB6ZyhTEUT9lDbF2wSVPpn6+4aTMKANIhTHdkw
        VgRt3j0/5duL08x9ABYMvZv+/vYaznkIaqmekSXYgQUAC+25fSOuVe1nsIuJwvXQ4zTv5z
        8mX/m1WcA9MsMHqfBDrh25S2ifLzPi8=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id lUxpBRTi3WAOFwAALh3uQQ
        (envelope-from <jgross@suse.com>); Thu, 01 Jul 2021 15:41:08 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/6] x86/kvm: add boot parameters for max vcpu configs
Date:   Thu,  1 Jul 2021 17:40:59 +0200
Message-Id: <20210701154105.23215-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to be able to have a single kernel for supporting even huge
numbers of vcpus per guest some arrays should be sized dynamically.

The easiest way to do that is to add boot parameters for the maximum
number of vcpus and the highest supported vcpu-id overwriting the
normal default.

This patch series is doing that for x86. The same scheme can be easily
adapted to other architectures, but I don't want to do that in the
first iteration.

In the long term I'd suggest to have a per-guest setting of the two
parameters allowing to spare some memory for smaller guests. OTOH this
would require new ioctl()s and respective qemu modifications, so I let
those away for now.

I've tested the series not to break normal guest operation and the new
parameters to be effective on x86. For Arm64 I did a compile test only.

Juergen Gross (6):
  x86/kvm: fix vcpu-id indexed array sizes
  x86/kvm: remove non-x86 stuff from arch/x86/kvm/ioapic.h
  x86/kvm: add boot parameter for maximum vcpu-id
  x86/kvm: introduce per cpu vcpu masks
  kvm: allocate vcpu pointer array separately
  x86/kvm: add boot parameter for setting max number of vcpus per guest

 .../admin-guide/kernel-parameters.txt         | 18 +++++++
 arch/arm64/kvm/arm.c                          | 28 +++++++++--
 arch/x86/include/asm/kvm_host.h               | 22 ++++++---
 arch/x86/kvm/hyperv.c                         | 25 +++++++---
 arch/x86/kvm/ioapic.c                         | 14 +++++-
 arch/x86/kvm/ioapic.h                         |  8 +--
 arch/x86/kvm/irq_comm.c                       |  9 +++-
 arch/x86/kvm/x86.c                            | 49 ++++++++++++++++++-
 include/linux/kvm_host.h                      | 17 ++++++-
 9 files changed, 160 insertions(+), 30 deletions(-)

-- 
2.26.2

