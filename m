Return-Path: <kvm+bounces-17876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 651DB8CB68E
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:19:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88D681C21CE4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F4B619470;
	Wed, 22 May 2024 00:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KmWi7P4M"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C63CA3D;
	Wed, 22 May 2024 00:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337116; cv=none; b=nAR1yNCAzjKthrY06s3VGno2/HrfvKlejWxG5mr3Cqo9I8PP5NT+a98pkIjfVZztNmTsBwwraAq/+sYLMCsavOyJwN5a6vmM0R4yjpRIcSF1wPk6xdaOai0TDJNRYCqTtSTAQecIm7aqZA7Y8JDl3JVnkEiCB0HLoXhvvQa0P8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337116; c=relaxed/simple;
	bh=Oo8JbtaeAVvu+BiG99UZnDQlR6ltnkfLSQjDut8Wsjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esP0WUnA0uJPkVHcK8W6UvPRJssP9WcQY7XFjgjyk287j/5XdaksfOCgk4lPfsCuUSeF1ULfOuQ4gwiBAI3PUXy+H6HttqezYe9ELgB6foGPEhBZyOCxYraqYWB1UX9GyCv84EYSZN35wolvh0BWJhoCjWrYYhjX1k4OkltzvmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KmWi7P4M; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YKJKZHPi8YHtIl6vE/PG1igKqSrFyO9I4bvyYCkbel8=; b=KmWi7P4MnOzU1YY/8Gl7Zd2N6V
	BjuNxehos8cWeXvJkKwM2fmz/jT/72JXcOdv57I5HARobAuq9hVpYUS/6bjWRGemZmJ9FSFosF4DX
	/no4YCcHv6T9u7uwimiUnSalgivbogtd9DXtSuSHM9WO4F2F4MXV15yHfcgsmdyT9ItyZJHS81ljM
	JYiY5IBuPVG5RDy1wq0xWrylqLFiNYzXKx/BaTYCy5cxY8nTZqb3rlfcrYMQ7P3PYpmvy7rB0k2JF
	8KyIZr52Vf5nztQiibw02uAukGUZxC8VUexF+lQzaRaAREXT1h7d0dXgGfl1c8T1yWBh1z33I6lkG
	LpxyQwYg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgU-000000080jd-1mgY;
	Wed, 22 May 2024 00:18:23 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-00000002b5S-37J8;
	Wed, 22 May 2024 01:18:20 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paul Durrant <paul@xen.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jalliste@amazon.co.uk,
	sveith@amazon.de,
	zide.chen@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [RFC PATCH v3 19/21] KVM: x86: Avoid periodic KVM clock updates in master clock mode
Date: Wed, 22 May 2024 01:17:14 +0100
Message-ID: <20240522001817.619072-20-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240522001817.619072-1-dwmw2@infradead.org>
References: <20240522001817.619072-1-dwmw2@infradead.org>
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

When the KVM clock is in master clock mode, updating the KVM clock is
pointless. Let the periodic work 'expire', and start it running again
from kvm_end_pvclock_update() if the master clock mode is ever turned
off again.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dd53860ca284..10b82f1b110d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -158,6 +158,8 @@ module_param(min_timer_period_us, uint, 0644);
 static bool __read_mostly kvmclock_periodic_sync = true;
 module_param(kvmclock_periodic_sync, bool, 0444);
 
+#define KVMCLOCK_SYNC_PERIOD (300 * HZ)
+
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
 static u32 __read_mostly tsc_tolerance_ppm = 250;
 module_param(tsc_tolerance_ppm, uint, 0644);
@@ -3187,6 +3189,10 @@ static void kvm_end_pvclock_update(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
+	if (kvmclock_periodic_sync && !kvm->arch.use_master_clock)
+		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
+				      KVMCLOCK_SYNC_PERIOD);
+
 	/* guest entries allowed */
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
@@ -3555,8 +3561,6 @@ static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
 					KVMCLOCK_UPDATE_DELAY);
 }
 
-#define KVMCLOCK_SYNC_PERIOD (300 * HZ)
-
 static void kvmclock_sync_fn(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
@@ -3564,6 +3568,9 @@ static void kvmclock_sync_fn(struct work_struct *work)
 					   kvmclock_sync_work);
 	struct kvm *kvm = container_of(ka, struct kvm, arch);
 
+	if (!kvm->arch.use_master_clock)
+		return;
+
 	schedule_delayed_work(&kvm->arch.kvmclock_update_work, 0);
 	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
 					KVMCLOCK_SYNC_PERIOD);
@@ -12551,7 +12558,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 	mutex_unlock(&vcpu->mutex);
 
-	if (kvmclock_periodic_sync && vcpu->vcpu_idx == 0)
+	if (kvmclock_periodic_sync && !kvm->arch.use_master_clock &&
+	    vcpu->vcpu_idx == 0)
 		schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
 						KVMCLOCK_SYNC_PERIOD);
 }
-- 
2.44.0


