Return-Path: <kvm+bounces-22655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6922C940E31
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 11:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ABF31C2247F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 09:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5860B195FE6;
	Tue, 30 Jul 2024 09:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b="PcvRPzpA"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.freebsd.org (mx2.freebsd.org [96.47.72.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588DF15FA68;
	Tue, 30 Jul 2024 09:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=96.47.72.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722332744; cv=pass; b=CLnVEHiAQMHwsJGfgpua6nvn5sXVPUETqgTs+n0P6Dl95MwC486qLdNYb2raNPsH/eETL7hWpdE5lDMFjQtmCA9nU6KNuhwODfdZWl9sCtZ1l4K0iMWJ5KEGYx5/UbRmm+bNQEFSn3T8Tw+RL0D9sn9lsD+MzNH+8Hzq6gherpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722332744; c=relaxed/simple;
	bh=NxJQHFeKDBPSSCSem9Kg5zW3ESKcJl+9AC5WX+DwD6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ospzn9l0FfIpuNyQkC2mvXELdFM4fvZDHPU7nafiHuCO8ndhnjfJ8oj7x5SJ7A6AVVEPQCPgmH5cMBLrQzJpWEjxI0OYGQgmGvY1lnoBOQcMQmQZ9MXzmBmmhtGbFq8SHL9SVNLYGFeyypsMEas0mcOasMji+AE5IfesfWfq9Mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org; spf=pass smtp.mailfrom=freebsd.org; dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b=PcvRPzpA; arc=pass smtp.client-ip=96.47.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebsd.org
Received: from mx1.freebsd.org (mx1.freebsd.org [IPv6:2610:1c1:1:606c::19:1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits)
	 client-signature RSA-PSS (4096 bits))
	(Client CN "mx1.freebsd.org", Issuer "R10" (verified OK))
	by mx2.freebsd.org (Postfix) with ESMTPS id 4WY9MT0lFCz4Q2S;
	Tue, 30 Jul 2024 09:45:41 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
Received: from freefall.freebsd.org (freefall.freebsd.org [IPv6:2610:1c1:1:6074::16:84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "freefall.freebsd.org", Issuer "R3" (verified OK))
	by mx1.freebsd.org (Postfix) with ESMTPS id 4WY9MS6kNfz4L7B;
	Tue, 30 Jul 2024 09:45:40 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org; s=dkim;
	t=1722332740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mm7A2OClIPrdIz1avKQCGU773Am3hFLJmryBXSiCwwQ=;
	b=PcvRPzpAKzoFZbE6SFnpFEYMdc0RBgAWBKgZpjelRv79tpLVdPc8EXppIylLtdM99tx3Id
	1E+ZUPL0lnRdcfr5c1NFI4EbZ0yhFpFtopnM6znTwr0hTq7eFA3gsHyZVhmKLm6zMCo8Hv
	REc4w/Lsgs6z+eXQpJLJHJVLv/v+0xu/VIZM6Cz4agZt/bTdah4dTYpuCIJ5mMevklB3MH
	VXETZTFmWrMdn3MNZ8/vydlTt/wBiWzaWVNvGX/mEPV9HmX9pIkQgY4NoAio5r7A/bFNUb
	/D1UMnu8Wj+K38NYpG3O+4hRXvflHUltTrVgMh5Fk7A5eIQvPNXKPywqHOfWIA==
ARC-Seal: i=1; s=dkim; d=freebsd.org; t=1722332740; a=rsa-sha256; cv=none;
	b=I39drHy52c0QMmlwa/plZO9SPPCc6G2WNNEiboLNugZjlZ9Sw/UpRzFzXOaG24MDB9Qjv1
	GzokEwi8fX9mh/00Ksv/2lhkM2sxRtIlc8oMx+aB3hFsHmkOU4JCzbu+vGYfboK3mAyOpV
	oECw0R373p0ZoQbIvOdUD1lKoI04ssS/1pgil+6HKaU2RtyeLWeLcVMcBuMYC6gUhSokr9
	aFI9TBFz2X6c51uwVPfw+VLGPk8nL7zzMfKdEea2rNBKHh6kWWh+lFhm/EnPvPQWCc5O8M
	Pl3UfZPiNXcGVdTcxWicBDv1Zqqc4vqqgeWexRa1PuuBG4/VEu9qVRYMFoGBOQ==
ARC-Authentication-Results: i=1;
	mx1.freebsd.org;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org;
	s=dkim; t=1722332740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mm7A2OClIPrdIz1avKQCGU773Am3hFLJmryBXSiCwwQ=;
	b=EIsyOaBI1T6PH8ETeh6ZpJ+VXnQIM5QHsX0Ji/Rk28aAoxfS3ixgLjCzFOik3LJB8Nwpeg
	OPERCmeBJXvG63mQXUC1Qbp2ajrUaC7bBq/9U79ss2DrlDUT6ddkPeBvVWBEkYDfRTijj0
	Ow0RnGSnSnI9Zwz3X+1ZzDbr5q28lQdUq2JEUfkmZddL+EBgjuNn07JKHlbxc5mXRFyzQ3
	638sjzxR6Q+A/n+X0A0yFZa5FEMiIPxD3Bs922VCPEryKFydp4rRNwyfw+Mw+/8N0isJ2n
	q0Wf8xTaeeMMIUpDk3D6LVElRPyQibLSfMc/8rc7J/cfJEFa4BrcwU4vDdg4uw==
Received: by freefall.freebsd.org (Postfix, from userid 1026)
	id BFEF1CAAD; Tue, 30 Jul 2024 09:45:40 +0000 (UTC)
Date: Tue, 30 Jul 2024 09:45:40 +0000
From: Suleiman Souhlal <ssouhlal@freebsd.org>
To: Chao Gao <chao.gao@intel.com>
Cc: Suleiman Souhlal <suleiman@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Include host suspended time in steal time.
Message-ID: <Zqi2RJKp8JxSedOI@freefall.freebsd.org>
References: <20240710074410.770409-1-suleiman@google.com>
 <ZqhPVnmD7XwFPHtW@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqhPVnmD7XwFPHtW@chao-email>

On Tue, Jul 30, 2024 at 10:26:30AM +0800, Chao Gao wrote:
> Hi,
> 
> On Wed, Jul 10, 2024 at 04:44:10PM +0900, Suleiman Souhlal wrote:
> >When the host resumes from a suspend, the guest thinks any task
> >that was running during the suspend ran for a long time, even though
> >the effective run time was much shorter, which can end up having
> >negative effects with scheduling. This can be particularly noticeable
> >if the guest task was RT, as it can end up getting throttled for a
> >long time.
> >
> >To mitigate this issue, we include the time that the host was
> >suspended in steal time, which lets the guest can subtract the
> >duration from the tasks' runtime.
> >
> >Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> >---
> > arch/x86/kvm/x86.c       | 23 ++++++++++++++++++++++-
> > include/linux/kvm_host.h |  4 ++++
> > 2 files changed, 26 insertions(+), 1 deletion(-)
> >
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 0763a0f72a067f..94bbdeef843863 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -3669,7 +3669,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> > 	struct kvm_steal_time __user *st;
> > 	struct kvm_memslots *slots;
> > 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> >-	u64 steal;
> >+	u64 steal, suspend_duration;
> > 	u32 version;
> > 
> > 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
> >@@ -3696,6 +3696,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> > 			return;
> > 	}
> > 
> >+	suspend_duration = 0;
> >+	if (READ_ONCE(vcpu->suspended)) {
> >+		suspend_duration = vcpu->kvm->last_suspend_duration;
> >+		vcpu->suspended = 0;
> 
> Can you explain why READ_ONCE() is necessary here, but WRITE_ONCE() isn't used
> for clearing vcpu->suspended?

Because this part of the code is essentially single-threaded, it didn't seem
like WRITE_ONCE() was needed. I can add it in an eventual future version of
the patch if it makes things less confusing (if this code still exists).

> 
> >+	}
> >+
> > 	st = (struct kvm_steal_time __user *)ghc->hva;
> > 	/*
> > 	 * Doing a TLB flush here, on the guest's behalf, can avoid
> >@@ -3749,6 +3755,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
> > 	unsafe_get_user(steal, &st->steal, out);
> > 	steal += current->sched_info.run_delay -
> > 		vcpu->arch.st.last_steal;
> >+	steal += suspend_duration;
> > 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
> > 	unsafe_put_user(steal, &st->steal, out);
> > 
> >@@ -6920,6 +6927,7 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
> > 
> > 	mutex_lock(&kvm->lock);
> > 	kvm_for_each_vcpu(i, vcpu, kvm) {
> >+		WRITE_ONCE(vcpu->suspended, 1);
> > 		if (!vcpu->arch.pv_time.active)
> > 			continue;
> > 
> >@@ -6932,15 +6940,28 @@ static int kvm_arch_suspend_notifier(struct kvm *kvm)
> > 	}
> > 	mutex_unlock(&kvm->lock);
> > 
> >+	kvm->suspended_time = ktime_get_boottime_ns();
> >+
> > 	return ret ? NOTIFY_BAD : NOTIFY_DONE;
> > }
> > 
> >+static int
> >+kvm_arch_resume_notifier(struct kvm *kvm)
> >+{
> >+	kvm->last_suspend_duration = ktime_get_boottime_ns() -
> >+	    kvm->suspended_time;
> 
> Is it possible that a vCPU doesn't get any chance to run (i.e., update steal
> time) between two suspends? In this case, only the second suspend would be
> recorded.

Good point. I'll address this.

> 
> Maybe we need an infrastructure in the PM subsystem to record accumulated
> suspended time. When updating steal time, KVM can add the additional suspended
> time since the last update into steal_time (as how KVM deals with
> current->sched_info.run_deley). This way, the scenario I mentioned above won't
> be a problem and KVM needn't calculate the suspend duration for each guest. And
> this approach can potentially benefit RISC-V and ARM as well, since they have
> the same logic as x86 regarding steal_time.

Thanks for the suggestion.
I'm a bit wary of making a whole PM subsystem addition for such a counter, but
maybe I can make a architecture-independent KVM change for it, with a PM
notifier in kvm_main.c.

> 
> Additionally, it seems that if a guest migrates to another system after a suspend
> and before updating steal time, the suspended time is lost during migration. I'm
> not sure if this is a practical issue.

The systems where the host suspends don't usually do VM migrations. Or at least
the ones where we're encountering the problem this patch is trying to address
don't (laptops).
But even if they did, it doesn't seem that likely that the migration would
happen over a host suspend.
If it's ok with you, I'll put this issue aside for the time being.

Thanks for the comments.
-- Suleiman

