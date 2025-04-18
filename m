Return-Path: <kvm+bounces-43608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7023DA931A7
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 07:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9D4C1B62E48
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 05:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4493253358;
	Fri, 18 Apr 2025 05:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="NiRpihx+"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF601CF8B
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 05:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744955427; cv=none; b=hymZ+QL2t88zCPnnPLOP0N6lTYmyOjEVQ5jd+VTEOmMFrgID+DPF9HeGuhvAuOyfi8MMkXOojzKfkbdqkqNzreNaNHOECD7BZ//xKOJGDsnScbfcdIR8J1snr1HPQye5W9IAAogF2csnoHuL7HJCMzFFyTwOaVd8e100F0iW3bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744955427; c=relaxed/simple;
	bh=YM57sx3wBPpN8+B1hZwcTaa3eagLLxnA1JjSjGC+ro8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fXdG5bCpbajwUz4leUJnKKLxqmgWFcvxL9iAeH5DdLX10ZLhZqzdQ+Oa3qr86BuLxxlyTqFjm94X3AxMxsnRVbdBynp+cmG6QJH0Q7lfUY+VRFmujP7eU9NmbSguT5/RMwOAOPOZyO5NHA04u7hf01DhZkykZpsn0nIK7wfQbSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=NiRpihx+; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=K4adI
	7ccpTdRfN3HSGkuNWOP+075nSqil0uuYEAUuVI=; b=NiRpihx+WrSnQ0gVx8mQU
	6xaRUwEJSZnsh0r36jVLpU5RCqE6uhJ52PWJU5s8wzCWpJsFQpbKMVXNIDbLdMED
	qsgSsJWHX6CmCKY50dnRNicHCkHdlH1tm96KbocDbUOyJnXTuG83UGY0gWuZWDF9
	PP96lrO+51LNYD7SCKD5H4=
Received: from node-1.domain.tld (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wBHS2cE6AFodXCPAw--.34969S2;
	Fri, 18 Apr 2025 13:49:57 +0800 (CST)
From: Jiayuan <ljykernel@163.com>
To: kvm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	marc.zyngier@arm.com
Subject: [Question] arm64: KVM: Optimizing cache flush during MMU enable to single vCPU
Date: Fri, 18 Apr 2025 13:49:55 +0800
Message-ID: <20250418054955.1883037-1-ljykernel@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHS2cE6AFodXCPAw--.34969S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFy7JF1DXFW8tFW8uFyfJFb_yoW5Jr4fpF
	Z7CF15tw4vgryIkanrtw48tr1FqrWkJF12q3s8Gw1Fvw15ZFn7WrykCrW8XFyDurs5Aa13
	Ga129FyDZr4DX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UpuWJUUUUU=
X-CM-SenderInfo: 5om1yvhuqhzqqrwthudrp/1tbiSg8zbmgB5iM5+QAAs0

Hi,

I'm investigating the cache flush behavior in the ARM64 KVM implementation, 
specifically regarding the commit 9d218a1fcf4c6b759d442ef702842fae92e1ea61 by 
Marc Zyngier that addresses cache flushing when guests enable caches.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/arch/arm/kvm/mmu.c?id=9d218a1fcf4c6b759d442ef702842fae92e1ea61

In the current implementation, the function kvm_toggle_cache() in arch/arm/kvm/mmu.c 
flushes the entire VM's stage2 page tables when any vCPU toggles its cache state:

void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
{
	bool now_enabled = vcpu_has_cache_enabled(vcpu);

	/*
	 * If switching the MMU+caches on, need to invalidate the caches.
	 * If switching it off, need to clean the caches.
	 * Clean + invalidate does the trick always.
	 */
	if (now_enabled != was_enabled)
		stage2_flush_vm(vcpu->kvm);

	/* Caches are now on, stop trapping VM ops (until a S/W op) */
	if (now_enabled)
		*vcpu_hcr(vcpu) &= ~HCR_TVM;

	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
}

I'm wondering if it would be feasible to optimize this by only performing the 
flush on the first vCPU (vcpu0) that enables caches? My reasoning is:

1. During guest boot, typically vcpu0 is the first to enable caches
2. Other vCPUs would follow after vcpu0 has already flushed the caches
3. This could potentially reduce redundant cache flushes in multi-vCPU guests

Specifically, I'm considering a change like this:

void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
{
	bool now_enabled = vcpu_has_cache_enabled(vcpu);

	/*
	 * If switching the MMU+caches on, need to invalidate the caches.
	 * If switching it off, need to clean the caches.
	 * Clean + invalidate does the trick always.
	 */
	if (now_enabled != was_enabled) {
		if (vcpu->vcpu_id == 0)
			stage2_flush_vm(vcpu->kvm);
	}

	/* Caches are now on, stop trapping VM ops (until a S/W op) */
	if (now_enabled)
		*vcpu_hcr(vcpu) &= ~HCR_TVM;

	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
}

Would such an optimization be correct from a cache coherency perspective? 
Are there scenarios where each vCPU needs to perform its own flush when 
enabling caches?

I'm working on optimizing KVM performance for ARM64 systems and noticed this 
potential area for improvement.

Thank you for your insights.

Best regards,
Jiayuan Liang


