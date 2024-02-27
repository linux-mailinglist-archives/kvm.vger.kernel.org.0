Return-Path: <kvm+bounces-10077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E060B868F8A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:57:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93D17283FDF
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 11:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5273013A255;
	Tue, 27 Feb 2024 11:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YxmnW8DC"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5253E12F581
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 11:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709035019; cv=none; b=KDQ7uyk1CavrvKdlFMQ9lajdUI4FnUm1OA1iZseIPe27i7rpsMKtix23t+1y3rTd1tr/WYIZo6DhXImGsMdCJB46RzHT2vqP2yBFhUM/KmbhYKg/W1nEzVTP3cn2mxbP+zrYZ5njzN63Q8gQKEcBpR9HJdnulN1tZLEePBGzH+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709035019; c=relaxed/simple;
	bh=HnO4xc35jrQguliZlaxh0Zjk4Ght5IMc72SPKCT//yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJBLPwNQA0dq3AvLWw2mpA1Hn+gN2UXNwUGWJtnxp29kCX/xHQCQWH1SJZIVzm2WIm9rk//8Uj3oA7VRTUJtVONMhHKSZCCN0A/bnfcw3Jesd/jzquOGhurUhIj+ddMw+Y7lzNh5UdfQ9jI2scLMDMkFSSwtErHLFOzLogrSdlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YxmnW8DC; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=HJUVfEzfpfQ6/ZOZU2Or4QVmUenWrNRUEquSgFacOeg=; b=YxmnW8DCXiTyZ8pcRLtCqNUsNx
	NGPlnjajQOQTeJCGu/ga+g2cxs0ynH0FryA2aV4sJSBemM/0Eliehqn+NCfp/0np2CY4g2fpPXqzQ
	c014A5XvrCvtW6acDeDDsTyMiuW3xHhA1GS6nQ2rL3OZD23aXdxgD1I+AzWenz4d8rM7H3c+8ezVm
	WbfdlbTwVx74kEMlqafW3RVBg3NpZX9CeBpmsHyhh3q7kri0E8FWaruLJUO5xJPOKf06IZwvMMnF1
	Kw3gYUBSVdYH+k+maWwaiPT8MZ3tdGuZMb7b2Vh1Cxkt4xVYJLKfsmjop/IWYyUFuYrSrjrt1lgF1
	izTCsDIw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4p-00000001j63-3s5b;
	Tue, 27 Feb 2024 11:56:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4o-000000000wh-0W6o;
	Tue, 27 Feb 2024 11:56:50 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Paul Durrant <pdurrant@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Woodhouse <dwmw2@infradead.org>,
	x86@kernel.org
Subject: [PATCH v2 7/8] KVM: x86/xen: avoid blocking in hardirq context in kvm_xen_set_evtchn_fast()
Date: Tue, 27 Feb 2024 11:49:21 +0000
Message-ID: <20240227115648.3104-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227115648.3104-1-dwmw2@infradead.org>
References: <20240227115648.3104-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: Paul Durrant <pdurrant@amazon.com>

As described in [1] compiling with CONFIG_PROVE_RAW_LOCK_NESTING shows that
kvm_xen_set_evtchn_fast() is blocking on pfncache locks in IRQ context.
There is only actually blocking with PREEMPT_RT because the locks will
turned into mutexes. There is no 'raw' version of rwlock_t that can be used
to avoid that, so use read_trylock() and treat failure to lock the same as
an invalid cache.

[1] https://lore.kernel.org/lkml/99771ef3a4966a01fefd3adbb2ba9c3a75f97cf2.camel@infradead.org/T/#mbd06e5a04534ce9c0ee94bd8f1e8d942b2d45bd6
Fixes: 77c9b9dea4fb ("KVM: x86/xen: Use fast path for Xen timer delivery")
Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org

v2:
 • Use read_trylock only in interrupt context, to avoid concerns about
   unfairness in the slow path.
---
 arch/x86/kvm/xen.c | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index c16b6d394d55..d8b5326ecebc 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1736,9 +1736,23 @@ static int set_shinfo_evtchn_pending(struct kvm_vcpu *vcpu, u32 port)
 	unsigned long flags;
 	int rc = -EWOULDBLOCK;
 
-	read_lock_irqsave(&gpc->lock, flags);
+	local_irq_save(flags);
+	if (!read_trylock(&gpc->lock)) {
+		/*
+		 * When PREEMPT_RT turns locks into mutexes, rwlocks are
+		 * turned into mutexes and most interrupts are threaded.
+		 * But timer events may be delivered in hardirq mode due
+		 * to using HRTIMER_MODE_ABS_HARD. So bail to the slow
+		 * path if the trylock fails in interrupt context.
+		 */
+		if (in_interrupt())
+			goto out;
+
+		read_lock(&gpc->lock);
+	}
+
 	if (!kvm_gpc_check(gpc, PAGE_SIZE))
-		goto out;
+		goto out_unlock;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
 		struct shared_info *shinfo = gpc->khva;
@@ -1761,8 +1775,10 @@ static int set_shinfo_evtchn_pending(struct kvm_vcpu *vcpu, u32 port)
 		rc = 1; /* It is newly raised */
 	}
 
+ out_unlock:
+	read_unlock(&gpc->lock);
  out:
-	read_unlock_irqrestore(&gpc->lock, flags);
+	local_irq_restore(flags);
 	return rc;
 }
 
@@ -1772,21 +1788,23 @@ static bool set_vcpu_info_evtchn_pending(struct kvm_vcpu *vcpu, u32 port)
 	struct gfn_to_pfn_cache *gpc = &vcpu->arch.xen.vcpu_info_cache;
 	unsigned long flags;
 	bool kick_vcpu = false;
+	bool locked;
 
-	read_lock_irqsave(&gpc->lock, flags);
+	local_irq_save(flags);
+	locked = read_trylock(&gpc->lock);
 
 	/*
 	 * Try to deliver the event directly to the vcpu_info. If successful and
 	 * the guest is using upcall_vector delivery, send the MSI.
-	 * If the pfncache is invalid, set the shadow. In this case, or if the
-	 * guest is using another form of event delivery, the vCPU must be
-	 * kicked to complete the delivery.
+	 * If the pfncache lock is contended or the cache is invalid, set the
+	 * shadow. In this case, or if the guest is using another form of event
+	 * delivery, the vCPU must be kicked to complete the delivery.
 	 */
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
 		struct vcpu_info *vcpu_info = gpc->khva;
 		int port_word_bit = port / 64;
 
-		if (!kvm_gpc_check(gpc, sizeof(*vcpu_info))) {
+		if ((!locked || !kvm_gpc_check(gpc, sizeof(*vcpu_info)))) {
 			if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))
 				kick_vcpu = true;
 			goto out;
@@ -1800,7 +1818,7 @@ static bool set_vcpu_info_evtchn_pending(struct kvm_vcpu *vcpu, u32 port)
 		struct compat_vcpu_info *vcpu_info = gpc->khva;
 		int port_word_bit = port / 32;
 
-		if (!kvm_gpc_check(gpc, sizeof(*vcpu_info))) {
+		if ((!locked || !kvm_gpc_check(gpc, sizeof(*vcpu_info)))) {
 			if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))
 				kick_vcpu = true;
 			goto out;
@@ -1819,7 +1837,10 @@ static bool set_vcpu_info_evtchn_pending(struct kvm_vcpu *vcpu, u32 port)
 	}
 
  out:
-	read_unlock_irqrestore(&gpc->lock, flags);
+	if (locked)
+		read_unlock(&gpc->lock);
+
+	local_irq_restore(flags);
 	return kick_vcpu;
 }
 
-- 
2.43.0


