Return-Path: <kvm+bounces-39075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 343B8A4321F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 01:54:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B38AF189EC7F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF7617BBF;
	Tue, 25 Feb 2025 00:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jJwD2Cd1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A813171CD
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 00:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740444851; cv=none; b=s3xe98r3oEjnX/V4MiCkl1sDJImPtbwublE6Le7qMmdvY0AJ63IjEVxN4zKVXGdTf/RopEQ18HdEA9JrZLqchUA3EBYbNhEqTzj0c4hBZelN0d2rIQZWcAUhcT5kmAw8eoQGRUL6bB2gbK4zfc0epOX1ASY8x41YF1adXpFZR9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740444851; c=relaxed/simple;
	bh=eSNE9SpqsMKJGUnfQSYvUpz0ITo6/+EEEAk6+jIriYs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NnWrMDxCUSeiNlWuoJDyJtwWkPRJ8T4p6UUlsjzMovvPiWorH07B1pUUyboZbxlMrpd6SfqZXGWCtyHbJL4KYnjxSYiGLU6L0HviZqqZO+WUR8f1PvSzrAV5bB55UUUx1liXpZW1OkDJMSQWM/1biDV9gFuFQ5sLzNq0V4x2Ng8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jJwD2Cd1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1c3b3dc7so9700675a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 16:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740444849; x=1741049649; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WMj3ogmbSNHf4nwGWlr5jLmxfUU0ZTeLt3VrAyHhBlI=;
        b=jJwD2Cd1QhpGtc2rCCYkWPnQ3dQH0wRLDlW5KsoHb7mrW5kEVf5or0+AUdLoN0jyIk
         n9Q3qgww3I4y6fiFCY+K6Jt56RxretwcsfN2RJl52ZDuzhGu0Q0M2RvTv4pkFqNZp5jh
         1Qi4kIPlcFjetMC1YsFEK0tC9975jN0KQaHUu9WYqhFJ6Z1MOnRg7bP/HtLE0Dc4f/wU
         5u0PNTqgl4BfR736lWgY4rTvHjgjeb7L3rOORW+Zr3c+oHHf42FEl4PWFZbisN5q2VHw
         ++PNKss75yN4CtJu1CHK7HFzr/Lxd4yWHOx3nxtzEYfwv7v/JQldTTop5RLfWbvUJn1i
         xuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740444849; x=1741049649;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WMj3ogmbSNHf4nwGWlr5jLmxfUU0ZTeLt3VrAyHhBlI=;
        b=oCj9708/p/BD1P2RWp92fuI4SzyFbsdwTSrQ6zt6izHjdj+vFVw2LHx7r707aMSNdd
         AHz5u5bZRJK7254pVNXozQ5rX4znqQhB9q6O+AiPoS+L2b2pkLWfW50cG2zFy377ZVnz
         9c7byLquWdXns6L1Ov2xQ9iNtEfjhr8KDTYR0d8lTCwzo6YBDeArHMrEYGKhpMGBX1oJ
         hY3l10KsqROYW2r9SrdQqwauhtEF5scybFlIELs2OXzBTVWXQ8ShO/kwm9wjhrGom45l
         d8WUKZ+JVPRaDsNEp4ktxnkU7YAJ/iUPka0leN5ORzton8dwIa92COrykxBIvidJLR1N
         hF0g==
X-Forwarded-Encrypted: i=1; AJvYcCXPyPk7eMjSy721LZUA41xCfKsZ3HIjY985aeib7Me36rb4FRqzRtVgR7c1Q32FysFV5YE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx659HCi9E4P+WvqVmyeb01CqzfdfQH5O8cIrS7ns8wi8XUTS6z
	0LxC5rlr48MUPWOEN5go9u0t8gtajDbifsY5V3EkXrjI4rMVZRhTghtSh/amtvEHnUOEjTtPYWx
	GmA==
X-Google-Smtp-Source: AGHT+IFwU4tsgKfQpQ0F9TpDCTa6nuPqHf5O1NRFL7byHKxAWJgpMYV1Sek68AsT2p2rXJmmuIZbuGqbSY8=
X-Received: from pjbsd8.prod.google.com ([2002:a17:90b:5148:b0:2ea:5613:4d5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:528f:b0:2ee:741c:e9f4
 with SMTP id 98e67ed59e1d1-2fce78ab918mr27279855a91.11.1740444849479; Mon, 24
 Feb 2025 16:54:09 -0800 (PST)
Date: Mon, 24 Feb 2025 16:54:08 -0800
In-Reply-To: <f9050ee1-3f82-7ae0-68b0-eccae6059fde@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com> <20250219012705.1495231-4-seanjc@google.com>
 <4e762d94-97d4-2822-4935-2f5ab409ab29@amd.com> <Z7z43JVe2C4a7ElJ@google.com> <f9050ee1-3f82-7ae0-68b0-eccae6059fde@amd.com>
Message-ID: <Z70UsI0kgcZu844d@google.com>
Subject: Re: [PATCH 03/10] KVM: SVM: Terminate the VM if a SEV-ES+ guest is
 run with an invalid VMSA
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 24, 2025, Tom Lendacky wrote:
> On 2/24/25 16:55, Sean Christopherson wrote:
> > On Mon, Feb 24, 2025, Tom Lendacky wrote:
> >> On 2/18/25 19:26, Sean Christopherson wrote:
> >>> -void pre_sev_run(struct vcpu_svm *svm, int cpu)
> >>> +int pre_sev_run(struct vcpu_svm *svm, int cpu)
> >>>  {
> >>>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> >>> -	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
> >>> +	struct kvm *kvm = svm->vcpu.kvm;
> >>> +	unsigned int asid = sev_get_asid(kvm);
> >>> +
> >>> +	/*
> >>> +	 * Terminate the VM if userspace attempts to run the vCPU with an
> >>> +	 * invalid VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after
> >>> +	 * an SNP AP Destroy event.
> >>> +	 */
> >>> +	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa)) {
> >>> +		kvm_vm_dead(kvm);
> >>> +		return -EIO;
> >>> +	}
> >>
> >> If a VMRUN is performed with the vmsa_pa value set to INVALID_PAGE, the
> >> VMRUN will fail and KVM will dump the VMCB and exit back to userspace
> > 
> > I haven't tested, but based on what the APM says, I'm pretty sure this would crash
> > the host due to a #GP on VMRUN, i.e. due to the resulting kvm_spurious_fault().
> > 
> >   IF (rAX contains an unsupported physical address)
> >     EXCEPTION [#GP]
> 
> Well that's for the VMCB, the VMSA is pointed to by the VMCB and results
> in a VMEXIT code of -1 if you don't supply a proper page-aligned,
> physical address.

Ah, good to know (and somewhat of a relief :-) ).

> >>>  static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> >>> @@ -4231,7 +4233,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
> >>>  	if (force_immediate_exit)
> >>>  		smp_send_reschedule(vcpu->cpu);
> >>>  
> >>> -	pre_svm_run(vcpu);
> >>> +	if (pre_svm_run(vcpu))
> >>> +		return EXIT_FASTPATH_EXIT_USERSPACE;
> 
> In testing this out, I think userspace continues on because I eventually
> get:
> 
> KVM_GET_PIT2 failed: Input/output error
> /tmp/cmdline.98112: line 1: 98163 Aborted (core dumped) ...
> 
> Haven't looked too close, but maybe an exit_reason needs to be set to
> get qemu to quit sooner?

Oh, the irony.  In trying to do the right thing (exit to userspace), I managed to
do the wrong thing.

If KVM tried to re-enter the guest, vcpu_enter_guest() would have encountered
the KVM_REQ_DEAD and exited with -EIO.

		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
			r = -EIO;
			goto out;
		}

By returning EXIT_FASTPATH_EXIT_USERSPACE, KVM exited to userspace more directly
and returned '0' instead of -EIO.

Getting KVM to return -EIO is easy, but doing so feels wrong, especially if we
take the quick-and-dirty route like so:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 454fd6b8f3db..9c8b400e04f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11102,7 +11102,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
                kvm_lapic_sync_from_vapic(vcpu);
 
        if (unlikely(exit_fastpath == EXIT_FASTPATH_EXIT_USERSPACE))
-               return 0;
+               return kvm_test_request(KVM_REQ_VM_DEAD, vcpu) ? -EIO : 0;
 
        r = kvm_x86_call(handle_exit)(vcpu, exit_fastpath);
        return r;

Given that, IIUC, KVM would eventually return KVM_EXIT_FAIL_ENTRY, I like your
idea of returning meaningful information.  And unless I'm missing something, that
would obviate any need to terminate the VM, which would address your earlier point
of whether terminating the VM is truly better than returning than returning a
familiar error code.

So this? (completely untested)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7345cac6f93a..71b340cbe561 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3463,10 +3463,8 @@ int pre_sev_run(struct vcpu_svm *svm, int cpu)
         * invalid VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after
         * an SNP AP Destroy event.
         */
-       if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa)) {
-               kvm_vm_dead(kvm);
-               return -EIO;
-       }
+       if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa))
+               return -EINVAL;
 
        /* Assign the asid allocated with this SEV guest */
        svm->asid = asid;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 46e0b65a9fec..f72bcf2e590e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4233,8 +4233,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
        if (force_immediate_exit)
                smp_send_reschedule(vcpu->cpu);
 
-       if (pre_svm_run(vcpu))
+       if (pre_svm_run(vcpu)) {
+               vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+               vcpu->run->fail_entry.hardware_entry_failure_reason = SVM_EXIT_ERR;
+               vcpu->run->fail_entry.cpu = vcpu->cpu;
                return EXIT_FASTPATH_EXIT_USERSPACE;
+       }
 
        sync_lapic_to_cr8(vcpu);

