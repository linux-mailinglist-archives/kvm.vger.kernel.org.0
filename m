Return-Path: <kvm+bounces-17890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12CA78CB6A7
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:21:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 280ACB20C20
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1527153E22;
	Wed, 22 May 2024 00:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Solymps+"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A896442F;
	Wed, 22 May 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337118; cv=none; b=LoW3+M1u076alQGt4IdWZeS+z03U6ZQdL5k9xRXZYdxf9bONt3T0pU4oXEDUrKFs+G+QiT5vv+wEJj++83yu2D94KdIOvJJHTVyn45vdFm8iTs2tZtZk3HBx7brlQdZQC2C3Z9YiiWkhbpKM9y3kO7Wk3uRNJdVYIeri63hqbv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337118; c=relaxed/simple;
	bh=pBigEs6Nioq1CkWLrwtKHgBstTtX5RzQGI1djSgrsn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4h23BGh4y0D2ghmE7u8ZXdVetVYlVJxT0qOtgCwJKAIlNjT+UKd/sPyQkUvZJAzgdR0Q4kNY4b17SwI7ogGDpVY52U4TmzucxMZ9w+jLPHbmjKyXGaZDDi2RXaZxZVL8XmJ8ve9sSTOzq0i3Fj/VRNX6G20EPSlm9MjMBviki4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Solymps+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HzcOm5bAnf2WUPBPby/caN2TjEsVt9Rju1VrHQfmSvU=; b=Solymps+/oYdhoy+bt+ibcdpoO
	j3oI9aNSF8LQV6ObMQegSy6WRWCsr1jB9NzB9W5urbjL4aA2+jKqRsItDTXu14wseKFlQwZGTRqfc
	HZuPtXmWpP4Y+bF1aEUqmu/x9uuzKjNZDzol9XZh7aJ9K3hmSTvyffYyAO15TiFmm4gpjITZl8lOe
	JGoHuXsDjaO+LHhiOt8gdTfUNZIg7ZT7j/hKKjeHIvGY7241MQ/uXPwmCfbjUx7dAROoCG8xotEda
	3dwGKC0pjkja+jYe9yO1y+3MCEY+tyNq8XrS4XWirZfbAiYr3lSYtVu0DB+tjpZhy2zVlbOlGlqmO
	Pc7VW/HQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-0000000081Q-4BPN;
	Wed, 22 May 2024 00:18:21 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-00000002b5N-2s45;
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
Subject: [RFC PATCH v3 18/21] KVM: x86: Avoid gratuitous global clock reload in kvm_arch_vcpu_load()
Date: Wed, 22 May 2024 01:17:13 +0100
Message-ID: <20240522001817.619072-19-dwmw2@infradead.org>
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

Commit d98d07ca7e034 ("KVM: x86: update pvclock area conditionally, on
cpu migration") turned an unconditional KVM_REQ_CLOCK_UPDATE into a
conditional one, if either the master clock isn't enabled *or* the vCPU
was not previously scheduled (vcpu->cpu == -1). The commit message doesn't
explain the latter condition, which is specifically for the master clock
case.

Commit 0061d53daf26f ("KVM: x86: limit difference between kvmclock
updates") later turned that into a KVM_REQ_GLOBAL_CLOCK_UPDATE to avoid
skew between vCPUs.

In master clock mode there is no need for any of that, regardless of
whether/where this vCPU was previously scheduled.

Do it only if (!kvm->arch.use_master_clock).

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 32a873d5ed00..dd53860ca284 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5161,7 +5161,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		 * On a host with synchronized TSC, there is no need to update
 		 * kvmclock on vcpu->cpu migration
 		 */
-		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1)
+		if (!vcpu->kvm->arch.use_master_clock)
 			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
 		if (vcpu->cpu != cpu)
 			kvm_make_request(KVM_REQ_MIGRATE_TIMER, vcpu);
-- 
2.44.0


