Return-Path: <kvm+bounces-58601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3180B97C96
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 01:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 364904A6DBB
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 23:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B188A30FF1D;
	Tue, 23 Sep 2025 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3xCdy4jj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677DD27A47F
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758669266; cv=none; b=A23TNR0G6cysGvXW8nRu8iIt/ElAhAKAv1HU241eVxhKzsNGGCJwsvRnqzWt57ZY2i0LEHXx2dhNk54y0C16LUYhkGEvBRuVqDKvRR8SWn8XKvjbhO7DsGqJMsan32A527LHk4svyBPIrZV0MnpSdge/CRCaYNQdA7vQOnrm6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758669266; c=relaxed/simple;
	bh=MpCZNf/GOy6NjD2pRT0oH9uqgGjRWpMlqYprIbTOK8Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XbjTlHiiXJbOYvHPH9ukQF16QbfKIDddJpG1/ribHypdJ2Kq6kSLQ+YytRkneO+Q7xSt1E/qUCsN5FZmOD/xpDm5UE4iN5BwgHG344kcurzV5w+D1Vncq5ZqndQZ+/Fo26rteQ0yUn4csc25RMnxpnCrVWMawhV4Jgx1Xft7GgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3xCdy4jj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329b750757aso5086986a91.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 16:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758669265; x=1759274065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FTiou86pN61TAcjufn8tJnmM28G83FXY+P+7y8ivzfs=;
        b=3xCdy4jjEQO8VNjQpRVsirO7yBb40rq8HGPYuL71iGKvKwCox4qHoUlRkWXb/Xnlwg
         IhoQ5hskXcs5AOqK7Ef7JKT1Lh+yQfLEhm3UIh7w4HTQB+8asg5KZ+rqzlra4GMvvmCr
         ts+C6WyaFcyGykjEqyEaoKPqH5YSo1dfA5QRC+4WLiz06BmgFlnSwUKH694JDE5k2vyN
         /R+Ex7hY0PawyDwXmKUHPHihnfAQ7BSRGs3474ztzK2Gz9nrkoobfTiJ5BJA11ahTkUH
         27KKSVpVAr5tGlWOKThQsEJWUBxc+I0Me9968+XDQ9ySUN2bPXHJXn8ItPO3uC33oLJh
         BZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758669265; x=1759274065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FTiou86pN61TAcjufn8tJnmM28G83FXY+P+7y8ivzfs=;
        b=toOHr+9S2v8yZCS/5GEIyJ7OuzXqj5ojNSTV91GhydKyzCTZRpJQ9/RZ2Z/z4WfS6f
         T7ekjZaKyinRhB347xJYzpHq4+444rzS7fTtiPhB2N7ukzXhaZtuhaFLQ+hbL/JvKSzn
         XEx7D9xvvKtc5mstazpr40A6giFoVjuchx05FNWk9fWQlJcOoZsGz6UrDkTzrFXOGrNC
         Z0HZsMAxHBKLOKhUFjGGm9b5jOUyrfcmYKujPQyRfbi0mavPlN8xg2giGUG147cxgGPg
         ulA5ZXMyjZQ9cFjVE2GRk24jQ3PN1XBWi6y+rF3etR8xHw8R04Inu0g5fz5ncuX0OC79
         o6pQ==
X-Forwarded-Encrypted: i=1; AJvYcCXy1upBXL5Vr83vMXTgis2qed1AfIMIiev7NQrieTrYFZeMPas01CZ0ZOwDL7csPFe1g3c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVcF2jiuAKsGfMKvYDkPNtFNHvrBnBfSid+9qLrrYXVEGdUt8G
	/1zHjh6JaZ1bv8ubuGRKZ/W/PpYXavHuh5fwYiPxN3PbOqdcmHx05wZUdDGZ0CXd9Wk/ksc39y3
	aAtyfQQ==
X-Google-Smtp-Source: AGHT+IFU+CrjvrJHu/esfPz+HcGN3HFugrI+IxFF24KE5muZangbuUY6NmTSpKqTbb1DNw37VcIcYKwJVjE=
X-Received: from pjbmw15.prod.google.com ([2002:a17:90b:4d0f:b0:32e:ddac:6ea5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8d:b0:32e:1b1c:f8b8
 with SMTP id 98e67ed59e1d1-332a95b42c2mr4833792a91.26.1758669264699; Tue, 23
 Sep 2025 16:14:24 -0700 (PDT)
Date: Tue, 23 Sep 2025 16:14:23 -0700
In-Reply-To: <23f11dc1-4fd1-4286-a69a-3892a869ed33@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250813192313.132431-1-mlevitsk@redhat.com> <20250813192313.132431-3-mlevitsk@redhat.com>
 <7c7a5a75-a786-4a05-a836-4368582ca4c2@redhat.com> <aNLtMC-k95pIYfeq@google.com>
 <23f11dc1-4fd1-4286-a69a-3892a869ed33@redhat.com>
Message-ID: <aNMpz96c9JOtPh-w@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present_queued
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, 
	Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Paolo Bonzini wrote:
> On 9/23/25 20:55, Sean Christopherson wrote:
> > On Tue, Sep 23, 2025, Paolo Bonzini wrote:
> > > On 8/13/25 21:23, Maxim Levitsky wrote:
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 9018d56b4b0a..3d45a4cd08a4 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -13459,9 +13459,14 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> > > >    void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
> > > >    {
> > > > -	kvm_make_request(KVM_REQ_APF_READY, vcpu);
> > > > -	if (!vcpu->arch.apf.pageready_pending)
> > > > +	/* Pairs with smp_store_release in vcpu_enter_guest. */
> > > > +	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
> > > > +	bool page_ready_pending = READ_ONCE(vcpu->arch.apf.pageready_pending);
> > > > +
> > > > +	if (!in_guest_mode || !page_ready_pending) {
> > > > +		kvm_make_request(KVM_REQ_APF_READY, vcpu);
> > > >    		kvm_vcpu_kick(vcpu);
> > > > +	}
> > > 
> > > Unlike Sean, I think the race exists in abstract and is not benign
> > 
> > How is it not benign?  I never said the race doesn't exist, I said that consuming
> > a stale vcpu->arch.apf.pageready_pending in kvm_arch_async_page_present_queued()
> > is benign.
> 
> In principle there is a possibility that a KVM_REQ_APF_READY is missed.

I think you mean a kick (wakeup or IPI), is missed, not that the APF_READY itself
is missed.  I.e. KVM_REQ_APF_READY will never be lost, KVM just might enter the
guest or schedule out the vCPU with the flag set.

All in all, I think we're in violent agreement.  I agree that kvm_vcpu_kick()
could be missed (theoretically), but I'm saying that missing the kick would be
benign due to a myriad of other barriers and checks, i.e. that the vCPU is
guaranteed to see KVM_REQ_APF_READY anyways.

E.g. my suggestion earlier regarding OUTSIDE_GUEST_MODE was to rely on the
smp_mb__after_srcu_read_{,un}lock() barriers in vcpu_enter_guest() to ensure
KVM_REQ_APF_READY would be observed before trying VM-Enter, and that if KVM might
be in the process of emulating HLT (blocking), that either KVM_REQ_APF_READY is
visible to the vCPU or that kvm_arch_async_page_present() wakes the vCPU.  Oh,
hilarious, async_pf_execute() also does an unconditional __kvm_vcpu_wake_up().

Huh.  But isn't that a real bug?  KVM doesn't consider KVM_REQ_APF_READY to be a
wake event, so isn't this an actual race?

  vCPU                                  async #PF
  kvm_check_async_pf_completion()
  pageready_pending = false
  VM-Enter
  HLT
  VM-Exit
                                        kvm_make_request(KVM_REQ_APF_READY, vcpu)
                                        kvm_vcpu_kick(vcpu)  // nop as the vCPU isn't blocking, yet
                                        __kvm_vcpu_wake_up() // nop for the same reason
  vcpu_block()
  <hang>

On x86, the "page ready" IRQ is only injected from vCPU context, so AFAICT nothing
is guarnateed wake the vCPU in the above sequence.



> broken:
> 
> 	kvm_make_request(KVM_REQ_APF_READY, vcpu);
> 	if (!vcpu->arch.apf.pageready_pending)
>    		kvm_vcpu_kick(vcpu);
> 
> It won't happen because set_bit() is written with asm("memory"), because x86
> set_bit() does prevent reordering at the processor level, etc.
> 
> In other words the race is only avoided by the fact that compiler
> reorderings are prevented even in cases that memory-barriers.txt does not
> promise.



