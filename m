Return-Path: <kvm+bounces-50349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D48F9AE43AF
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:35:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1157D17E0A8
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7999D253953;
	Mon, 23 Jun 2025 13:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fhFdLsed"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFEC248191;
	Mon, 23 Jun 2025 13:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685242; cv=none; b=qonDkb5qy3LmBzf5pXJR1VTctj+1rdm9MFz0dVBEDmtp/eAhdBBDs07g497HRx5xkZcO1taW/2RhGnW0NVGdnGL621xUfoO2TiH6eDYjZ9/LY0hWU3/6H99d8R4Fnu+l6NlD0xbYRcThhm26gNKkt7JlCuTJ7lIOr/gGLBVinXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685242; c=relaxed/simple;
	bh=+Yo6QHO/HDcDoO6sU/l2I7OQYWvWeS3PgqO/bbhd1Vo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LYyLpbssZDKiLB2jVHpIlw985AtNHDJ4NZkWGzBzigeEqxivJbwzUGXa1rfFq7/DUjtozsMcQC/r+0TevO6Sc0Yl57xLX0B133wVXSh/j1D+GfH0QRyKeg7OgOxY/S0uXfdNab0vwqS1zK3tFB4oJaEr+aSkLd94nJ9jew2zxaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fhFdLsed; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Cc:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=kVTNc/9jknS5UWRVRntQL1AqoiLE1DkjRtltxTY4gME=; b=fhFdLsed89bXtHgCUXKRvrY855
	uS/n0/sZv6VAii+sbTXtGN956j2OqjnQIfb3WLkOuaX+UY+Yp3E5JnQQOeQo4mK5E/RazM0p7unzB
	7CWtOari5IS3pZWoRAb5L77JdLUCDK8XPoMejX+OCM3HxUUd3Pjk5skldx464RuoJ/+gpOg0I+G4o
	EOyRgyNoYy4AtjhijxX+g6rtaLTb0bFS134Nbed1Zk1O9tAPRl4BjEzpAKTPT5WMsBtbexOOdLgi7
	RI5WVN15Ns8B9SYkr9WH/QEr0+aUnPbbVLHsn5CiQKm37/cfre46STxm1dOWtCwz5C0y0jdPPrQs5
	ZPY9Bopw==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uThCc-00000003XSl-3cfe;
	Mon, 23 Jun 2025 13:27:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uThCc-000000043AL-2a63;
	Mon, 23 Jun 2025 14:27:14 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [RFC PATCH 1/2] KVM: Add arch hooks for KVM syscore ops
Date: Mon, 23 Jun 2025 14:27:13 +0100
Message-ID: <20250623132714.965474-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Allow the architecture to hook kvm_shutdown(), kvm_suspend() and kvm_resume()

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/kvm_host.h |  3 +++
 virt/kvm/kvm_main.c      | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3bde4fb5c6aa..8e16b6c0d2ba 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1622,6 +1622,9 @@ void kvm_arch_disable_virtualization(void);
  */
 int kvm_arch_enable_virtualization_cpu(void);
 void kvm_arch_disable_virtualization_cpu(void);
+void kvm_arch_shutdown(void);
+void kvm_arch_suspend(void);
+void kvm_arch_resume(void);
 #endif
 bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eec82775c5bf..4af1d9943d39 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5609,6 +5609,20 @@ static int kvm_offline_cpu(unsigned int cpu)
 	return 0;
 }
 
+__weak void kvm_arch_shutdown(void)
+{
+
+}
+
+__weak void kvm_arch_suspend(void)
+{
+
+}
+__weak void kvm_arch_resume(void)
+{
+
+}
+
 static void kvm_shutdown(void)
 {
 	/*
@@ -5625,6 +5639,7 @@ static void kvm_shutdown(void)
 	pr_info("kvm: exiting hardware virtualization\n");
 	kvm_rebooting = true;
 	on_each_cpu(kvm_disable_virtualization_cpu, NULL, 1);
+	kvm_arch_shutdown();
 }
 
 static int kvm_suspend(void)
@@ -5641,6 +5656,7 @@ static int kvm_suspend(void)
 	lockdep_assert_irqs_disabled();
 
 	kvm_disable_virtualization_cpu(NULL);
+	kvm_arch_suspend();
 	return 0;
 }
 
@@ -5649,6 +5665,7 @@ static void kvm_resume(void)
 	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
+	kvm_arch_resume();
 	WARN_ON_ONCE(kvm_enable_virtualization_cpu());
 }
 
-- 
2.49.0


