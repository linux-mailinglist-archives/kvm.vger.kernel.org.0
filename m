Return-Path: <kvm+bounces-17879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B95FE8CB69C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D085B219DA
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9295D2837D;
	Wed, 22 May 2024 00:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZiAwLk5x"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E771865;
	Wed, 22 May 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337116; cv=none; b=m3JBkNKtgrRSNutRwMHK/mM4dB7dGvI+fVy+62icl98LDAJOuBi0GUl5bKJktWcT7ePrRT+Zx57Z9yCVSo8aOacVl5kaEjaFX8RFUrPanYNpOyQNszcoDykfYU2VWxPsTLDoex1OsWQHft19G0Gy55mGyFtf/G5NBOm4Je9Ev6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337116; c=relaxed/simple;
	bh=A+p1JCXNjeyY6dd0DQowKml3zMVyfpLxgdI/by9Mxt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0PpPPgP5PGoJTnlDlTalSDS2825jMb99BdCbR7Vu6uf/DZffQohVroHNxsTIaR61+LxbOVs40h1yp/dEvJMyEw69XRL0NDP2MiYRAjUtMxSOKf8Up//CqxtMeT/hUXuGUu1O0FUcipjdRzAYwiYChwIOZEBwjt2q2S98j2CZKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZiAwLk5x; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UxiRRxPq36DAxt9YPbtUOyBfO+hb8ej0BDeIjH3bF2U=; b=ZiAwLk5xpc+1KkexLm8kmym0xL
	VFmJ/pr21hFHOhKeYLp5WLnbKkJi+6W0E0S8KqPhbuplfSHbguZ6Ws9OU7HYchugdlO977aa/E8uy
	r6eQYcz+dyR5B7kQJoC2vhXFORux8EO/OUrqUcQIKNsWZv/eDK4Ulfc8zNiEZsp8VRszq/5o6wDn8
	7NjEVsVpke6agpUOUa91JxB2e7m5yW8eNVtnRlLOkPJB1GYsBFzsPnkmb7nTqFsGznogKFxiciDLk
	Xo6WPEQ81OjHjwUKMd71xL9hzHHaQ8zTSHq9o6ulo/9gBirMsbTZ8JSJLLhgB/VsnyMdxhm/IDLUD
	mSxfzarg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-0000000081P-4ANW;
	Wed, 22 May 2024 00:18:21 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-00000002b5J-2Xta;
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
Subject: [RFC PATCH v3 17/21] KVM: x86: Avoid global clock update on setting KVM clock MSR
Date: Wed, 22 May 2024 01:17:12 +0100
Message-ID: <20240522001817.619072-18-dwmw2@infradead.org>
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
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Commit 0061d53daf26 ("KVM: x86: limit difference between kvmclock updates")
introduced a KVM_REQ_GLOBAL_CLOCK_UPDATE when one vCPU set up its clock.

This was a workaround for the ever-drifting clocks which were based on the
host's CLOCK_MONOTONIC and thus subject to NTP skew. On booting or resuming
a guest, it just leads to running kvm_guest_time_update() twice for each
vCPU for now good reason.

Just use KVM_REQ_CLOCK_UPDATE on the vCPU itself, and only in the case
where the KVM clock is being set up, not turned off.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 437412b36cae..32a873d5ed00 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2361,13 +2361,13 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 	}
 
 	vcpu->arch.time = system_time;
-	kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
 
 	/* we verify if the enable bit is set... */
-	if (system_time & 1)
+	if (system_time & 1) {
 		kvm_gpc_activate(&vcpu->arch.pv_time, system_time & ~1ULL,
 				 sizeof(struct pvclock_vcpu_time_info));
-	else
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+	} else
 		kvm_gpc_deactivate(&vcpu->arch.pv_time);
 
 	return;
-- 
2.44.0


