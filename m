Return-Path: <kvm+bounces-12133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D313687FE53
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DBA1283E74
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C930A823C5;
	Tue, 19 Mar 2024 13:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BzVstWiW"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF1781724;
	Tue, 19 Mar 2024 13:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853814; cv=none; b=lcK0oiHZ/SFoLG2uy49JFHzPnpyePdpCwXRBB9ILloJBy5aoApLyU/VRlq+FgtSDUOvMzeXI1/f1swRTRpGIm/Hx0/ilfU7OYn2icbgdV9p0hBD05J7cNJZFHd1hlIZM91V5QhiUJmEWYEdqjMJLQ+Bhs1y9bR/trfpD1FWN2mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853814; c=relaxed/simple;
	bh=HMH0aJ/yhL4TtEL6UtwH+nkbeX43Qv6MTp6+ytOSTDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlbOlof590IQW8Y6g0VsZmr/6OFzOjQoymgtogW4UmM7Muom6OzS7+B3tKtqyzQY5abKzRk55hE3tMsnOVbEEdlsOsZgSZNHBlFvE3sdRxEb9DySQ855Z5YM1hpYpGtaegEgmth7YZmfHgeiSEin3HYKTh26aVn9l1Yr7X2S8iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BzVstWiW; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Pmgtt4mh52E0ERFpZQ40Zoz9sGIFhtqH6Ihl0RxJeMs=; b=BzVstWiW0OSzgfgyp5EL36bCHd
	86Xs7gLeF5roLtNMG54Dn1YYIvNc7gFSioT8eLie20NZCKfUJ6KFGEiyFND8oEuIZ+7+7AezXl03n
	VULB8oA3SmrzJohhfyMB/jh4zIsGuA4NsqZXoacin9gfq2IfsgoPNeBzKwb6ETlsP3TBvRP2knK0I
	14S05r5narRksQo6uCu9f5Ck1Eza3Er1wUjTRC2D5JID3D2X6KgDEvDVynePdJ3uWgJlvNRv2ONKu
	DNdKKV8cej+zKVKSi6KYsz2pAyA7fa/tzmJbKlfx2NpbvBzSA1dDefq3bjUgZhWdByX2Z4P0cUMAm
	RgiQvtkw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZEA-0000000DDly-1ioY;
	Tue, 19 Mar 2024 13:10:02 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZE9-00000004PN6-0ttC;
	Tue, 19 Mar 2024 13:10:01 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-pm@vger.kernel.org
Subject: [RFC PATCH v3 5/5] arm64: Use SYSTEM_OFF2 PSCI call to power off for hibernate
Date: Tue, 19 Mar 2024 12:59:06 +0000
Message-ID: <20240319130957.1050637-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240319130957.1050637-1-dwmw2@infradead.org>
References: <20240319130957.1050637-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The PSCI v1.3 specification (alpha) adds support for a SYSTEM_OFF2
function which is analogous to ACPI S4 state. This will allow hosting
environments to determine that a guest is hibernated rather than just
powered off, and handle that state appropriately on subsequent launches.

Since commit 60c0d45a7f7a ("efi/arm64: use UEFI for system reset and
poweroff") the EFI shutdown method is deliberately preferred over PSCI
or other methods. So register a SYS_OFF_MODE_POWER_OFF handler which
*only* handles the hibernation, leaving the original PSCI SYSTEM_OFF as
a last resort via the legacy pm_power_off function pointer.

The hibernation code already exports a system_entering_hibernation()
function which is be used by the higher-priority handler to check for
hibernation. That existing function just returns the value of a static
boolean variable from hibernate.c, which was previously only set in the
hibernation_platform_enter() code path. Set the same flag in the simpler
code path around the call to kernel_power_off() too.

An alternative way to hook SYSTEM_OFF2 into the hibernation code would
be to register a platform_hibernation_ops structure with an ->enter()
method which makes the new SYSTEM_OFF2 call. But that would have the
unwanted side-effect of making hibernation take a completely different
code path in hibernation_platform_enter(), invoking a lot of special dpm
callbacks.

Another option might be to add a new SYS_OFF_MODE_HIBERNATE mode, with
fallback to SYS_OFF_MODE_POWER_OFF. Or to use the sys_off_data to
indicate whether the power off is for hibernation.

But this version works and is relatively simple.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/firmware/psci/psci.c | 35 +++++++++++++++++++++++++++++++++++
 kernel/power/hibernate.c     |  5 ++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index d9629ff87861..69d2f6969438 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -78,6 +78,7 @@ struct psci_0_1_function_ids get_psci_0_1_function_ids(void)
 
 static u32 psci_cpu_suspend_feature;
 static bool psci_system_reset2_supported;
+static bool psci_system_off2_supported;
 
 static inline bool psci_has_ext_power_state(void)
 {
@@ -333,6 +334,28 @@ static void psci_sys_poweroff(void)
 	invoke_psci_fn(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
 }
 
+#ifdef CONFIG_HIBERNATION
+static int psci_sys_hibernate(struct sys_off_data *data)
+{
+	if (system_entering_hibernation())
+		invoke_psci_fn(PSCI_FN_NATIVE(1_3, SYSTEM_OFF2),
+			       PSCI_1_3_HIBERNATE_TYPE_OFF, 0, 0);
+	return NOTIFY_DONE;
+}
+
+static int __init psci_hibernate_init(void)
+{
+	if (psci_system_off2_supported) {
+		/* Higher priority than EFI shutdown, but only for hibernate */
+		register_sys_off_handler(SYS_OFF_MODE_POWER_OFF,
+					 SYS_OFF_PRIO_FIRMWARE + 2,
+					 psci_sys_hibernate, NULL);
+	}
+	return 0;
+}
+subsys_initcall(psci_hibernate_init);
+#endif
+
 static int psci_features(u32 psci_func_id)
 {
 	return invoke_psci_fn(PSCI_1_0_FN_PSCI_FEATURES,
@@ -364,6 +387,7 @@ static const struct {
 	PSCI_ID_NATIVE(1_1, SYSTEM_RESET2),
 	PSCI_ID(1_1, MEM_PROTECT),
 	PSCI_ID_NATIVE(1_1, MEM_PROTECT_CHECK_RANGE),
+	PSCI_ID_NATIVE(1_3, SYSTEM_OFF2),
 };
 
 static int psci_debugfs_read(struct seq_file *s, void *data)
@@ -523,6 +547,16 @@ static void __init psci_init_system_reset2(void)
 		psci_system_reset2_supported = true;
 }
 
+static void __init psci_init_system_off2(void)
+{
+	int ret;
+
+	ret = psci_features(PSCI_FN_NATIVE(1_3, SYSTEM_OFF2));
+
+	if (ret != PSCI_RET_NOT_SUPPORTED)
+		psci_system_off2_supported = true;
+}
+
 static void __init psci_init_system_suspend(void)
 {
 	int ret;
@@ -653,6 +687,7 @@ static int __init psci_probe(void)
 		psci_init_cpu_suspend();
 		psci_init_system_suspend();
 		psci_init_system_reset2();
+		psci_init_system_off2();
 		kvm_init_hyp_services();
 	}
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 4b0b7cf2e019..ac87b3cb670c 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -676,8 +676,11 @@ static void power_down(void)
 		}
 		fallthrough;
 	case HIBERNATION_SHUTDOWN:
-		if (kernel_can_power_off())
+		if (kernel_can_power_off()) {
+			entering_platform_hibernation = true;
 			kernel_power_off();
+			entering_platform_hibernation = false;
+		}
 		break;
 	}
 	kernel_halt();
-- 
2.44.0


