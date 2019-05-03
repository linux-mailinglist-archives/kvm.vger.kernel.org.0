Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17712E66
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfECMrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:47:53 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:32938 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbfECMrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:47:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B2781684;
        Fri,  3 May 2019 05:47:52 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03E6C3F220;
        Fri,  3 May 2019 05:47:48 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 54/56] arm64: docs: Document perf event attributes
Date:   Fri,  3 May 2019 13:44:25 +0100
Message-Id: <20190503124427.190206-55-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

The interaction between the exclude_{host,guest} flags,
exclude_{user,kernel,hv} flags and presence of VHE can result in
different exception levels being filtered by the ARMv8 PMU. As this
can be confusing let's document how they work on arm64.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/arm64/perf.txt | 85 ++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 Documentation/arm64/perf.txt

diff --git a/Documentation/arm64/perf.txt b/Documentation/arm64/perf.txt
new file mode 100644
index 000000000000..0d6a7d87d49e
--- /dev/null
+++ b/Documentation/arm64/perf.txt
@@ -0,0 +1,85 @@
+Perf Event Attributes
+=====================
+
+Author: Andrew Murray <andrew.murray@arm.com>
+Date: 2019-03-06
+
+exclude_user
+------------
+
+This attribute excludes userspace.
+
+Userspace always runs at EL0 and thus this attribute will exclude EL0.
+
+
+exclude_kernel
+--------------
+
+This attribute excludes the kernel.
+
+The kernel runs at EL2 with VHE and EL1 without. Guest kernels always run
+at EL1.
+
+For the host this attribute will exclude EL1 and additionally EL2 on a VHE
+system.
+
+For the guest this attribute will exclude EL1. Please note that EL2 is
+never counted within a guest.
+
+
+exclude_hv
+----------
+
+This attribute excludes the hypervisor.
+
+For a VHE host this attribute is ignored as we consider the host kernel to
+be the hypervisor.
+
+For a non-VHE host this attribute will exclude EL2 as we consider the
+hypervisor to be any code that runs at EL2 which is predominantly used for
+guest/host transitions.
+
+For the guest this attribute has no effect. Please note that EL2 is
+never counted within a guest.
+
+
+exclude_host / exclude_guest
+----------------------------
+
+These attributes exclude the KVM host and guest, respectively.
+
+The KVM host may run at EL0 (userspace), EL1 (non-VHE kernel) and EL2 (VHE
+kernel or non-VHE hypervisor).
+
+The KVM guest may run at EL0 (userspace) and EL1 (kernel).
+
+Due to the overlapping exception levels between host and guests we cannot
+exclusively rely on the PMU's hardware exception filtering - therefore we
+must enable/disable counting on the entry and exit to the guest. This is
+performed differently on VHE and non-VHE systems.
+
+For non-VHE systems we exclude EL2 for exclude_host - upon entering and
+exiting the guest we disable/enable the event as appropriate based on the
+exclude_host and exclude_guest attributes.
+
+For VHE systems we exclude EL1 for exclude_guest and exclude both EL0,EL2
+for exclude_host. Upon entering and exiting the guest we modify the event
+to include/exclude EL0 as appropriate based on the exclude_host and
+exclude_guest attributes.
+
+The statements above also apply when these attributes are used within a
+non-VHE guest however please note that EL2 is never counted within a guest.
+
+
+Accuracy
+--------
+
+On non-VHE hosts we enable/disable counters on the entry/exit of host/guest
+transition at EL2 - however there is a period of time between
+enabling/disabling the counters and entering/exiting the guest. We are
+able to eliminate counters counting host events on the boundaries of guest
+entry/exit when counting guest events by filtering out EL2 for
+exclude_host. However when using !exclude_hv there is a small blackout
+window at the guest entry/exit where host events are not captured.
+
+On VHE systems there are no blackout windows.
-- 
2.20.1

