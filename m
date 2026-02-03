Return-Path: <kvm+bounces-70016-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QI0zLIAPgmm9OwMAu9opvQ
	(envelope-from <kvm+bounces-70016-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:08:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F66DB174
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:08:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 260A4314F807
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 14:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005813ACEF7;
	Tue,  3 Feb 2026 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BY3VoGt4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C729F395DAC
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770130693; cv=none; b=dCjw8dHdZd3SvfhnBTkvRZvVH47H/r8HD+tdWl4iyZZmTx4fF7nF0WdcDDyNioQz/tH3XnXb/URR/BvhRLlaJPidavUyNJPhG8qE6N9BFMT4aVa9bfri1R3rnRsPSm0vh9+JGCHtj8kXzwHc/LwNmFj0J5PF3CySoncvlkVCFaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770130693; c=relaxed/simple;
	bh=OiYgYJnTLd10oKbXhqFZKdCJGpgrYs+k/cw5yaRayWw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MEjqKsDGD0/dwAQPr2HGuRWxNQHwKMiI04PryC6uv1NZgdbqRlyV0Y0IVE1m9gVOg+qdsQlqO6tBgPQDMsQXb2gK5Kbo2VsctxLGk6AaqjkYF4KSoxIKTUfYOe2Nre+ek1vIUTTWuw3Y1J1YgJW74DcAihiyzKrgRcikx/rSNHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BY3VoGt4; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a07fa318fdso57783805ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 06:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770130691; x=1770735491; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w82IDFvykl0YHd41gNU5sR8h+mwuxYG5tbST4sK5PRg=;
        b=BY3VoGt4ODGAxBL02WA5YZVSDSWjl4eV78bH0X/cX4dXHpQmd9rAKfjZcK1IXdeQg+
         AJdN6Kb5M7cMozDQMrFi0EWg4v39y4c8PgerQvoxS4Mnm9LUqa9uZ6sQtjY7k25aHbBK
         ymxJp0rhfn8G4+f/V6LCdoPqx7PZA7s6vOTX+HzfDioTYhcqjguGXQee+bZLY671Qnah
         w7pUKOJfl1pIPwhQXgkEA8gFhDwhj7tDl6cAg6a0PDNa3s3/JniN6U+lMVLSmyCIF2lx
         aG6LihkrM9x5xQ+uNcChDWVrICV7lktnTRTxoIrQdIFVWSbxfj7LqMJm8tuLPzr0lEqF
         GArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770130691; x=1770735491;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w82IDFvykl0YHd41gNU5sR8h+mwuxYG5tbST4sK5PRg=;
        b=ZHNYjt3ecsTaDFEk4yEtZ5QFCwVk8YzW6V8c+5oxxOaNHybsPsm3/IVa7sgDaY+wuq
         OhwqdEtsW1bujIRqrltUpItFj1imm+G28jwgRIPgIOBfP+C1xATaKgYtTAtLFQ4Rq0ln
         FDgkJBCSGm+smNlMbaJaWqUE9Ta9dJ4gmZh1BawRKaTmrPKuaYEkDUbwuRdQFO8oL31D
         mL1FnRbLNq7ukZFPQhzghfxBFlyoNEuVHbcSoiTNWp1zupZQge8SpfA5G1S48HJfPFsu
         fWYy4WtHqhLWy/UEh+uPmQon3Dx+U6YCDB52IcxZy14g3UW3e5j57NgMxIIcTt/e1oRU
         Tnag==
X-Forwarded-Encrypted: i=1; AJvYcCUpaghhGSl1iTknBMW4yJetpRJhD+u1QmRYgOVVhdRvGQX9a6rQauNrzNiJLRYUN1L1psQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy41pkpHXiaN1zCoIAm8BVdm+1BjPYOAWNZDLcanwH01dKB1j1B
	4UpkKqsq/fbsucnpD/hnhMvszXi8lToLZZqWitRUjv+hdV8YwcXCAEamzMZtcdv01oyBaua9MsY
	2lpOPeQ==
X-Received: from plyw20.prod.google.com ([2002:a17:902:d714:b0:2a9:3211:e2f8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea0c:b0:29e:76b8:41e5
 with SMTP id d9443c01a7336-2a8d9919123mr154207415ad.30.1770130691106; Tue, 03
 Feb 2026 06:58:11 -0800 (PST)
Date: Tue, 3 Feb 2026 06:58:08 -0800
In-Reply-To: <peroaux2ghnb2ypg2ebzflb3xvg3bzpaircqht3vdgy7tkrwn4@pfpkfhasn44i>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250502050346.14274-1-manali.shukla@amd.com> <20250502050346.14274-5-manali.shukla@amd.com>
 <peroaux2ghnb2ypg2ebzflb3xvg3bzpaircqht3vdgy7tkrwn4@pfpkfhasn44i>
Message-ID: <aYINAAGPto_TqLt-@google.com>
Subject: Re: [PATCH v5 4/5] KVM: SVM: Add support for KVM_CAP_X86_BUS_LOCK_EXIT
 on SVM CPUs
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Manali Shukla <manali.shukla@amd.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, pbonzini@redhat.com, nikunj@amd.com, 
	bp@alien8.de
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70016-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 28F66DB174
X-Rspamd-Action: no action

On Mon, Feb 02, 2026, Yosry Ahmed wrote:
> On Fri, May 02, 2025 at 05:03:45AM +0000, Manali Shukla wrote:
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 834b67672d50..5369d9517fbb 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -678,6 +678,33 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> >  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
> >  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
> >  
> > +	/*
> > +	 * Stash vmcb02's counter if the guest hasn't moved past the guilty
> > +	 * instrution; otherwise, reset the counter to '0'.
> > +	 *
> > +	 * In order to detect if L2 has made forward progress or not, track the
> > +	 * RIP at which a bus lock has occurred on a per-vmcb12 basis.  If RIP
> > +	 * is changed, guest has clearly made forward progress, bus_lock_counter
> > +	 * still remained '1', so reset bus_lock_counter to '0'. Eg. In the
> > +	 * scenario, where a buslock happened in L1 before VMRUN, the bus lock
> > +	 * firmly happened on an instruction in the past. Even if vmcb01's
> > +	 * counter is still '1', (because the guilty instruction got patched),
> > +	 * the vCPU has clearly made forward progress and so KVM should reset
> > +	 * vmcb02's counter to '0'.
> > +	 *
> > +	 * If the RIP hasn't changed, stash the bus lock counter at nested VMRUN
> > +	 * to prevent the same guilty instruction from triggering a VM-Exit. Eg.
> > +	 * if userspace rate-limits the vCPU, then it's entirely possible that
> > +	 * L1's tick interrupt is pending by the time userspace re-runs the
> > +	 * vCPU.  If KVM unconditionally clears the counter on VMRUN, then when
> > +	 * L1 re-enters L2, the same instruction will trigger a VM-Exit and the
> > +	 * entire cycle start over.
> > +	 */
> > +	if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip))
> 
> Is vmcb02->save.rip the right thing to use here?

Objection, leading the witness your honor.

> IIUC, we want to find out if L2 made forward progress since the last bus
> lock #VMEXIT from L2 to L0

More or less.
  
>, at which point we record bus_lock_rip.
> However, on nested VMRUN, vmcb02->save.rip is only populated from the
> vmcb12 in nested_vmcb02_prepare_save(), which doesn't happen until after
> nested_vmcb02_prepare_control(). So waht we're comparing against here is
> L2's RIP last time KVM ran it.

Hrm, that definitely seems like what past me intended[*], as this quite clearly
suggests my intent was to check the RIP coming from vmcb12:

 : Again, it's imperfect, e.g. if L1 happens to run a different vCPU at the same
 : RIP, then KVM will allow a bus lock for the wrong vCPU.  But the odds of that
 : happening are absurdly low unless L1 is deliberately doing weird things, and so
 : I don't think

I have this vague feeling that I deliberately didn't check @vmcb12_rip, but the
more I look at this, the more I'm convinced I simply didn't notice @vmcb12_rip
when typing up the suggestion.

[*] https://lore.kernel.org/all/Zw6rJ3y_F-10xBcH@google.com

> It's even worse in the KVM_SET_NESTED_STATE path, because
> vmcb02->save.rip will be unintialized (probably zero).

FWIW, this one is arguably ideal, in the sense that KVM should probably assume
the worst if userspace is loading guest state.

> Probably you want to use vmcb12_rip here, as this is the RIP that L1
> wants to run L2 with, and what will end up in vmcb02->save.rip.
>
> HOWEVER, that is also broken in the KVM_SET_NESTED_STATE path. In that
> path we pass in the uninitialized vmcb02->save.rip as vmcb12_rip anyway.


> Fixing this is non-trivial because KVM_SET_REGS could be called before
> or after KVM_SET_NESTED_STATE, so the RIP may not be available at all at
> that point.

Eh, this code is completely meaningless on KVM_SET_NESTED_STATE.  There is no
"right" answer, because KVM has no clue what constitutes forward progress.

Luckily, no answer is completely "wrong" either, because the #VMEXIT is transparent
to L1 and L2.  E.g. it's like saying that sending an IRQ to CPU running a vCPU is
"wrong"; it's never truly "wrong", just suboptimal (sometimes *very* suboptimal).

> We probably want to set a flag in svm_set_nested_state() that the RIP
> needs fixing up, and the perhaps in svm_vcpu_pre_run() fix up the
> control fields in vmcb02 that depend on it: namely the bus_lock_counter,
> next_rip, and soft_int_* fields.

Nah, not unless there's a meaningful, negative impact on a real world setup.
And as above, in practice the only impact is effectively a performance blip due
to generating an unwanted userspace exit.  If userspace is stuffing nested state
so often that that's actually a performance problem, then userspace can set regs
before nested state.

There are a pile of edge cases and "what ifs" around this, none of which have a
perfect answer since KVM doesn't know userspace's intent.  And so I want to go
with a solution that is as simple as possible without risking putting L2 into an
infinite loop.

> It gets worse because I think next_rip is also not always properly
> saved/restored because we do not sync it from vmcb02 to cache in
> nested_sync_control_from_vmcb02() -- but that one is not relevant to
> bus_lock_counter AFAICT.

Correct.

All in all, I think just this?

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd..482092b2051c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -809,7 +809,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
         * L1 re-enters L2, the same instruction will trigger a VM-Exit and the
         * entire cycle start over.
         */
-       if (vmcb02->save.rip && (svm->nested.ctl.bus_lock_rip == vmcb02->save.rip))
+       if (vmcb12_rip && (svm->nested.ctl.bus_lock_rip == vmcb12_rip))
                vmcb02->control.bus_lock_counter = 1;
        else
                vmcb02->control.bus_lock_counter = 0;

