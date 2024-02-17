Return-Path: <kvm+bounces-8960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A633858F20
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 12:40:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADD1A1C20E60
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 11:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C387C69E02;
	Sat, 17 Feb 2024 11:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KBUyDBF2"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3127669DE1
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 11:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708170025; cv=none; b=B51CIRPeVZpCMpBxV7qSJkYlHe9AB5Ad24kMy+qCGnJCHo2cbUqCAJ0uY1GBGvRaqMQaJRi0Z3ro4C01Z3Q1zPnS0wRFM2jUOkRju2rni8LI9TlTi6ETRFlJUGeJYtwoQo+Up6m6OwHcgrVCfHrU0A4eh0EhPsSM4fCWG6yy96I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708170025; c=relaxed/simple;
	bh=By8tQ0MAT5qiJwmECK527g73NxX9Vi2/ED5npWSn874=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lThwZuhxvvM1mSLffPF8dF7JuiWVUza+XFwaeCwpR42/P+l7emszIiXfFCvhgsOKl4A8FZsW1dPRJ4of19jHn+6A9armFhSmvEBW2fqF7mt08OCTyFDCqs7fmNEXDtPRwEPqo1HN4bMODT99dUEaxKZEst1qWSWkb5Ocu6yBlro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KBUyDBF2; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E2u87X6rFncDNIqD+E/MeHzgPyotp0c53t/P40qA5ik=; b=KBUyDBF2Y6+/vgStL1GenZryVR
	1lUKJjVPRPHTsMcxYlTU9lrv6bDIpaZrw6/gqTE8gH4ZHhwM2mkFr6D8rj6eoxhNt1EdvFnmCroNF
	sgpIbJfr0YiS64szESPkJqW5kxr7dw8fRJW6renaA5xfZOE6HSNBzNu83xdlhESWiVNPd21Ob4JGD
	HJFNpR/kybpR7lK4Zf4CX5XMcAQW3QXjAMWdlvNsrvulbkvA1bCe9+6Ekfp0GbYvqb/1eq7Sj8Irh
	yBJdCd3EPfGsAYFCz7ahxf8962NXqfVKdxlPjrpxp9+C0SCpZB7w104hAPwKkLJqGK97n/1UKOAGg
	aAagxhRQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3M-00000000Kvk-42MU;
	Sat, 17 Feb 2024 11:40:21 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbJ3L-0000000034M-402n;
	Sat, 17 Feb 2024 11:40:19 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 5/6] KVM: x86/xen: fix recursive deadlock in timer injection
Date: Sat, 17 Feb 2024 11:27:03 +0000
Message-ID: <20240217114017.11551-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240217114017.11551-1-dwmw2@infradead.org>
References: <20240217114017.11551-1-dwmw2@infradead.org>
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

The fast-path timer delivery introduced a recursive locking deadlock
when userspace configures a timer which has already expired and is
delivered immediately. The call to kvm_xen_inject_timer_irqs() can
call to kvm_xen_set_evtchn() which may take kvm->arch.xen.xen_lock,
which is already held in kvm_xen_vcpu_get_attr().

 ============================================
 WARNING: possible recursive locking detected
 6.8.0-smp--5e10b4d51d77-drs #232 Tainted: G           O
 --------------------------------------------
 xen_shinfo_test/250013 is trying to acquire lock:
 ffff938c9930cc30 (&kvm->arch.xen.xen_lock){+.+.}-{3:3}, at: kvm_xen_set_evtchn+0x74/0x170 [kvm]

 but task is already holding lock:
 ffff938c9930cc30 (&kvm->arch.xen.xen_lock){+.+.}-{3:3}, at: kvm_xen_vcpu_get_attr+0x38/0x250 [kvm]

Now that the gfn_to_pfn_cache has its own self-sufficient locking, its
callers no longer need to ensure serialization, so just stop taking
kvm->arch.xen.xen_lock from kvm_xen_set_evtchn().

Fixes: 77c9b9dea4fb ("KVM: x86/xen: Use fast path for Xen timer delivery")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index e6c7353e5315..706af2935277 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1903,8 +1903,6 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		mm_borrowed = true;
 	}
 
-	mutex_lock(&kvm->arch.xen.xen_lock);
-
 	/*
 	 * It is theoretically possible for the page to be unmapped
 	 * and the MMU notifier to invalidate the shared_info before
@@ -1932,8 +1930,6 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
-	mutex_unlock(&kvm->arch.xen.xen_lock);
-
 	if (mm_borrowed)
 		kthread_unuse_mm(kvm->mm);
 
-- 
2.43.0


