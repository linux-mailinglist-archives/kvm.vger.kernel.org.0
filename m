Return-Path: <kvm+bounces-10082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BD30869047
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 13:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 767791C248AB
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60EB145FF9;
	Tue, 27 Feb 2024 12:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PlY0FZG6"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC28145B3F
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 12:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709036363; cv=none; b=g5OEnEmy+810kW5Vg7Uir8EFdTFosQiWYPjtLpbXu+TBepgBT8Ker4FtY24Xyygx/QNzVyfAv65JeZIcgx5DwNsjY0YT18/dvJFOLQxqnNOd8/A4oLHPLqAmPy0kg9oPTXaAzJeAH2dcQzklwyFBlHdQC9cc8/GrmD3HxYtKJMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709036363; c=relaxed/simple;
	bh=bjJNnJkWRL/Api8dIWKsCbEOSzz2wo75WnhMLLLSrO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xhf6fXHAj9/xvnWHQudjFODDRUTZ4CjIavcD3Ifpnx3gJ4xjGXCAFkCAUNyJRkTjD1xl12ei4Ct5wj9SEwe5wCDKfQ16C3j/cUVKJ3LA3Gz46tCPUSVfXaaCO5JH5hJLycEh5DOcpk6QUio6WsvSUMB+xaACzUb7SvtKiKumanA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PlY0FZG6; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/sTIyCCftUypl1kyj6aiS19fJBB0Y8ZkcViyOBYV8KA=; b=PlY0FZG6auRdHzfvHL/I2UBzB6
	83u95sLkMZlKAZAUn0FbdTjwASO7EbYUQvQj0KOHsnKs4GHe1N1Vd1NXE894e8WKsGHT0Wjt+Vr6z
	MJvJHpQd9vC8DPek4XX4IXb/g/tF+hTtRzh0yNl5Yhg7NZW9wYrLn5QZB6ZT7KrQEP8HrAcaV3jwS
	ptCZQ67vwOoRonNUCiHBf4kPbPJz9ehoLtV5QjgWFqnw6eI4eDT48RV6PKGqamlLPeZtsza8V0JQ0
	pnNgf7fHGBqyxL7OGE1pz72eyOYUMqDMXHjTxhSyXYIM1xYubNMwvmKXtY9ySKH73cC5v0OcDTfgF
	65Ir/srA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4p-00000002JfO-3KWq;
	Tue, 27 Feb 2024 11:56:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4o-000000000wa-03h7;
	Tue, 27 Feb 2024 11:56:50 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH v2 5/8] KVM: x86/xen: fix recursive deadlock in timer injection
Date: Tue, 27 Feb 2024 11:49:19 +0000
Message-ID: <20240227115648.3104-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227115648.3104-1-dwmw2@infradead.org>
References: <20240227115648.3104-1-dwmw2@infradead.org>
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
Reviewed-by: Paul Durrant <paul@xen.org>
---
 arch/x86/kvm/xen.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 54a4bdb63b17..e87b36590809 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1865,8 +1865,6 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		mm_borrowed = true;
 	}
 
-	mutex_lock(&kvm->arch.xen.xen_lock);
-
 	/*
 	 * It is theoretically possible for the page to be unmapped
 	 * and the MMU notifier to invalidate the shared_info before
@@ -1894,8 +1892,6 @@ static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		srcu_read_unlock(&kvm->srcu, idx);
 	} while(!rc);
 
-	mutex_unlock(&kvm->arch.xen.xen_lock);
-
 	if (mm_borrowed)
 		kthread_unuse_mm(kvm->mm);
 
-- 
2.43.0


