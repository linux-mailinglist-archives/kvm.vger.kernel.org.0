Return-Path: <kvm+bounces-52430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF441B05228
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 08:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AADA57A6ED1
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 06:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44B626D4C3;
	Tue, 15 Jul 2025 06:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o0KlhbvB"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07810266574
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 06:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752562285; cv=none; b=LyogvTkO5UQF+cV7kEQXf7ye/BLfXHiKBjFWMqxD1NoNLBpgti7YL9WNM+prQXev1vLaPFzG7No2LviebYcwgga7i1HXP08Qg/lNu3GtSL3tFCqassY/gkkOsgc0GRPnwOuTdIXZhf/UZ9WL9IDjG+AtGysqNT6SDlPeh/9kYbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752562285; c=relaxed/simple;
	bh=ZknCB9lutQWkJ5ii+Y5PBOLYdmgluIDDdb/Wo6JJxgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgHzSnDliz5JJY/3IIboRQrSJAmAYmp/KOwrH0Z5vhtHRGsb7/gFwaMqgSnRcn2f5gs6UV4CCMzi1nwrfZcJQ0DfzzhwBJ10kWS6My1OISAZue4Vdn2y/nfF1RCehsTKB7MkzFzacgz+/MPTFll1MYzAnsxQOjev8zWImUQ2Ohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o0KlhbvB; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 14 Jul 2025 23:51:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752562280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m2RK1i7+eBOT39Iv0WjoNburedSnmTk8yWXXCGmNFM4=;
	b=o0KlhbvB7Rx6sbzPcsB0t7Br4dB5Nl/s1EXH8SzNQJbh2P6ADQSHaoveeud4N/4q4osw/w
	Jn85v2eNN/1nHRO3b3NtwpAKyyNE/FnNdag1U9hkdpGCItiuhfs3I9aDZdlJTt+VYr7iji
	LEuZ7j50hjD1AIHW1+GZxT2tF/11w+A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	syzbot+4e09b1432de3774b86ae@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: arm64: Clear pending exception state before
 injecting a new one
Message-ID: <aHX6XXhSSnHL_T1d@linux.dev>
References: <20250714144636.3569479-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714144636.3569479-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Mon, Jul 14, 2025 at 03:46:36PM +0100, Marc Zyngier wrote:
> Repeatedly injecting an exception from userspace without running
> the vcpu between calls results in a nasty warning, as we're not
> really keen on losing already pending exceptions.
> 
> But this precaution doesn't really apply to userspace, who can
> do whatever it wants (within reason). So let's simply clear any
> previous exception state before injecting a new one.
> 
> Note that this is done unconditionally, even if the injection
> ultimately fails.
> 
> Reported-by: syzbot+4e09b1432de3774b86ae@syzkaller.appspotmail.com
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Thanks for taking a look at this. I think the correct fix is a bit more
involved, as:

 - ABI prior to my patches allowed dumb things like injecting both an
   SEA and SError from the same ioctl. With your patch I think you could
   still get the warning to fire with serror_pending && ext_dabt_pending

 - KVM_GET_VCPU_EVENTS is broken for 'pending' SEAs, as we assume
   they're committed in the vCPU state immediately when they're actually
   deferred to the next KVM_RUN.

I thoroughly hate the fix I have but it should address both of these
issues. Although the pending PC adjustment flags seem more like a
liability than anything else if ioctls need to flush them before
returning to userspace. Might look at a larger cleanup down the road.

Thanks,
Oliver

From 149262689dfe881542f5c5b60f9ee308a00f0596 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oliver.upton@linux.dev>
Date: Mon, 14 Jul 2025 23:25:07 -0700
Subject: [PATCH] KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS
 immediately

syzkaller has found that it can trip a warning in KVM's exception
emulation infrastructure by repeatedly injecting exceptions into the
guest.

While it's unlikely that a reasonable VMM will do this, further
investigation of the issue reveals that KVM can potentially discard the
"pending" SEA state. While the handling of KVM_GET_VCPU_EVENTS presumes
that userspace-injected SEAs are realized immediately, in reality the
emulated exception entry is deferred until the next call to KVM_RUN.

Hack-a-fix the immediate issues by committing the pending exceptions to
the vCPU's architectural state immediately in KVM_SET_VCPU_EVENTS. This
is no different to the way KVM-injected exceptions are handled in
KVM_RUN where we potentially call __kvm_adjust_pc() before returning to
userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/guest.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index e2702718d56d..16ba5e9ac86c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -834,6 +834,19 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static void commit_pending_events(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu_get_flag(vcpu, PENDING_EXCEPTION))
+		return;
+
+	/*
+	 * Reset the MMIO emulation state to avoid stepping PC after emulating
+	 * the exception entry.
+	 */
+	vcpu->mmio_needed = false;
+	kvm_call_hyp(__kvm_adjust_pc, vcpu);
+}
+
 int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events)
 {
@@ -843,8 +856,15 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	u64 esr = events->exception.serror_esr;
 	int ret = 0;
 
-	if (ext_dabt_pending)
+	/*
+	 * Immediately commit the pending SEA to the vCPU's architectural
+	 * state which is necessary since we do not return a pending SEA
+	 * to userspace via KVM_GET_VCPU_EVENTS.
+	 */
+	if (ext_dabt_pending) {
 		ret = kvm_inject_sea_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+		commit_pending_events(vcpu);
+	}
 
 	if (ret < 0)
 		return ret;
@@ -863,6 +883,12 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	else
 		ret = kvm_inject_serror(vcpu);
 
+	/*
+	 * We could've decided that the SError is due for immediate software
+	 * injection; commit the exception in case userspace decides it wants
+	 * to inject more exceptions for some strange reason.
+	 */
+	commit_pending_events(vcpu);
 	return (ret < 0) ? ret : 0;
 }
 
-- 
2.39.5

