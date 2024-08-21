Return-Path: <kvm+bounces-24727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E2EF959F11
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 15:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E1C3B23161
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE491AF4E0;
	Wed, 21 Aug 2024 13:51:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E412C1AD5DE;
	Wed, 21 Aug 2024 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724248260; cv=none; b=NVri2DO3p6b80twHh+GKnfLs+mTMSKpYacAu2pZo3pT1yGrH20UIJ8NTTj4yUQNRF7BbKJPBEpn1bnvOsqDt0Ig7BvQTd+mnUQMQC3e9oH8+kKuHEB0S/EsccdU0P1lJH0HamIyItRMpE8cy64XWHdR0aoAr9lo+3b3MHxPDun4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724248260; c=relaxed/simple;
	bh=lV6MYYkfu9QBMSbX9W44qSZXxu5DA+lxxbr2M68NmRs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=GNa4Rqjqe+7tiAAGUUjjRgtM5ZoVrDGp5DgbCbezt6TyepqLCzIJ/fwzEG1VHoMWo9W3ftClEr63eeYU/jLMau4V+YAzstGZ5IV+mCDmgcvhWUzD9FWyf9NFL7MdYNsYF4nT5gFDiTZY8Wtpr6awqJf1KN1NrD2lpf1s2k7drIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F381C32781;
	Wed, 21 Aug 2024 13:50:58 +0000 (UTC)
Date: Wed, 21 Aug 2024 09:51:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 "x86@kernel.org" <x86@kernel.org>, Joel Fernandes <joel@joelfernandes.org>,
 Suleiman Souhlal <ssouhlal@freebsd.org>, "Vineeth Pillai"
 <vineeth@bitbyteword.org>, Borislav Petkov <bp@alien8.de>, Anna-Maria
 Behnsen <anna-maria@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Frederic Weisbecker
 <fweisbec@gmail.com>
Subject: [RFC][PATCH] KVM: Remove HIGH_RES_TIMERS dependency
Message-ID: <20240821095127.45d17b19@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: Steven Rostedt <rostedt@goodmis.org>

Commit 92b5265d38f6a ("KVM: Depend on HIGH_RES_TIMERS") added a dependency
to high resolution timers with the comment:

    KVM lapic timer and tsc deadline timer based on hrtimer,
    setting a leftmost node to rb tree and then do hrtimer reprogram.
    If hrtimer not configured as high resolution, hrtimer_enqueue_reprogram
    do nothing and then make kvm lapic timer and tsc deadline timer fail.

That was back in 2012, where hrtimer_start_range_ns() would do the
reprogramming with hrtimer_enqueue_reprogram(). But as that was a nop with
high resolution timers disabled, this did not work. But a lot has changed
in the last 12 years.

For example, commit 49a2a07514a3a ("hrtimer: Kick lowres dynticks targets on
timer enqueue") modifies __hrtimer_start_range_ns() to work with low res
timers. There's been lots of other changes that make low res work.

I added this change to my main server that runs all my VMs (my mail
server, my web server, my ssh server) and disabled HIGH_RES_TIMERS and the
system has been running just fine for over a month.

ChromeOS has tested this before as well, and it hasn't seen any issues with
running KVM with high res timers disabled.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 arch/x86/kvm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 472a1537b7a9..c65127e796a9 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on HIGH_RES_TIMERS
 	depends on X86_LOCAL_APIC
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
-- 
2.43.0


