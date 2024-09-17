Return-Path: <kvm+bounces-27041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 465AB97AFA6
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 13:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06A9228AEC7
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 11:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79B1167D83;
	Tue, 17 Sep 2024 11:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="g2+s7uGV"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1CD1E4A6;
	Tue, 17 Sep 2024 11:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726572168; cv=none; b=owEam0aASctTh41nmekpUbJvn2alAL3t33ehK0bNFKFSJHRXFsWZMwK4vRrpp92clNJAz8zTlz/hE139vy0Xgt7XFF4ijRB7dqFUoZ95jf6yCYNaOxJYOcTKm6DdEtWaTCaDdSjNqvACI1Mw2mFPrktNscdK/OBg10SfvSiZm+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726572168; c=relaxed/simple;
	bh=LrAW5SivDoH7YHmTe5TPntp4/hRDax2rAZmK/k/uH2w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CMDoxpK63apiuGjvOaymNaaU9CvqbSjOwvk/75wfHXXPro6KZOqqXPy476tE7fXeTOHMwNf1Xi1F2pFlNK3Sw5DpZNj40EdEqpyu97YPM8uA1EjebGvtUr+7+/x5JfGSkZtgrbQb4LWOd68i3KOcT330wohk4zslYyWeJmeA4FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=g2+s7uGV; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:5f15:0:640:bf90:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 5A94960F03;
	Tue, 17 Sep 2024 14:20:39 +0300 (MSK)
Received: from den-plotnikov-n.yandex-team.ru (unknown [2a02:6b8:b081:7214::1:1b])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TKK9lj3Ii4Y0-h7KM0hhf;
	Tue, 17 Sep 2024 14:20:38 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1726572038;
	bh=GPlHKz08eh5JpfwcCmqhd1AHvMsp+hVruo3KXNsfxow=;
	h=Message-Id:Date:Cc:Subject:To:From;
	b=g2+s7uGV6icnOlygfn9FAI2sNsOVzesMzcqkigW13FRwjoPcgsyUh7Ab6hSe86BEh
	 +aRQ6LqKhK+4kN/1pzYwHzk6VOL7YAlAvalAR+WkwuPXzxa12geRMUHbMh/OY2vwHB
	 8C1LZK7tq33id2LbX7kBXx0gQEII2RF3I8abOelk=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Denis Plotnikov <den-plotnikov@yandex-team.ru>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	yc-core@yandex-team.ru,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kvm/debugfs: add file to get vcpu steal time statistics
Date: Tue, 17 Sep 2024 14:20:28 +0300
Message-Id: <20240917112028.278005-1-den-plotnikov@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's helpful to know whether some other host activity affects a virtual
machine to estimate virtual machine quality of sevice.
The fact of virtual machine affection from the host side can be obtained
by reading "preemption_reported" counter via kvm entries of sysfs, but
the exact vcpu waiting time isn't reported to the host.
This patch adds this reporting.

Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/debugfs.c          | 17 +++++++++++++++++
 arch/x86/kvm/x86.c              |  1 +
 3 files changed, 19 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4a68cb3eba78f..3d4bd3ca83593 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -899,6 +899,7 @@ struct kvm_vcpu_arch {
 		u64 msr_val;
 		u64 last_steal;
 		struct gfn_to_hva_cache cache;
+		u64 steal_total;
 	} st;
 
 	u64 l1_tsc_offset;
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 999227fc7c665..e67136954c095 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -11,6 +11,7 @@
 #include "lapic.h"
 #include "mmu.h"
 #include "mmu/mmu_internal.h"
+#include "cpuid.h"
 
 static int vcpu_get_timer_advance_ns(void *data, u64 *val)
 {
@@ -56,6 +57,19 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
 
+static int vcpu_get_steal_time(void *data, u64 *val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+
+	if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
+		return 1;
+
+	*val = vcpu->arch.st.steal_total;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_steal_time_fops, vcpu_get_steal_time, NULL, "%llu\n");
+
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
 {
 	debugfs_create_file("guest_mode", 0444, debugfs_dentry, vcpu,
@@ -76,6 +90,9 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 				    debugfs_dentry, vcpu,
 				    &vcpu_tsc_scaling_frac_fops);
 	}
+
+	debugfs_create_file("steal-time", 0444, debugfs_dentry, vcpu,
+			    &vcpu_steal_time_fops);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70219e4069874..ca5f21b930d4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3735,6 +3735,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	vcpu->arch.st.steal_total = steal;
 	unsafe_put_user(steal, &st->steal, out);
 
 	version += 1;
-- 
2.34.1


