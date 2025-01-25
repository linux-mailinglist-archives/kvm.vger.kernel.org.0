Return-Path: <kvm+bounces-36592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 145A2A1C02F
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 02:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 594B716A814
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 01:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3345F1EE02F;
	Sat, 25 Jan 2025 01:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2yOT1U/c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66BC1487DD
	for <kvm@vger.kernel.org>; Sat, 25 Jan 2025 01:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737768220; cv=none; b=bVhp85AIPYD4UY3PDoFwOhwN8n/3CO7VItNzTxQrtMFvZN03i6QpwR5Ql7ekI8t5qAXEEn7V58WTfv16teGYtTfrb5KAQHJyl7nI79MxzE8DGXbmzDPzaCnncbj9d/SoCKWbjMz41tK2wiXChCvIyP2Q+eVPLUa7KtV/bEFLsiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737768220; c=relaxed/simple;
	bh=j+FKSDxUNM1F5iZlR69Fo6VPez9+4lHFP89cjSGtwWk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cWW+CSgaIBe6tD/QzFD/Bn6IfXonWbpc6L7dH1OrlGrGYWt9v9UfnTr44DnzOcY9ctvcXIYabSjIPq+0226bSGbHI8bJm29AQpxBwAptx01lsHHBtAIkx+VeTKj+aMwlF8na0+G20I1ZNy//BTy737H02t3MbqQ/jilx6cWh+qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2yOT1U/c; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef909597d9so7632145a91.3
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 17:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737768218; x=1738373018; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nyZcJNIvtx7/vtFw8wRArCMMiwsWya196s44k/cTvLM=;
        b=2yOT1U/c+aNBmMRe6C9nmywSYQVF+g4XrIYI4IB6s2T0PJhsMUg6x53r1oggjTC9lq
         uH1PS+MQinVo5F5QAKLpvTQWvEo7cC4MGwyYoYqkwa9VzbIshegBK6D/6KPSGTh5hPGP
         DKmzLdraFJqJ6vAuTpFqgPsTKq/NnRRZ0NkVYPLWD3AJwVjVu2lQ/BzZRnPr7RF/7W9e
         nGCoUXLViksHMO30HUsB7b+5QIARl4HSnmeV0vVvZv/Nw/mfETOgd6sk610SUSts1cyg
         KGsfD0mib+Uk6rtoPBA/LShWs7FKCpZxPibXDlIWakkTZiEQNYn0pnWFcaYrPRKgiFCR
         u6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737768218; x=1738373018;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nyZcJNIvtx7/vtFw8wRArCMMiwsWya196s44k/cTvLM=;
        b=DhqOsBgM0Q06IIzro1RY3u8XTDmFEpvGG3osodjaD3ZvaGzBdqOb71aUMqvC+VHnDr
         wHUVa6UTYNdz40VETwj4CsA8OKefuhnC3p2TndVxwjS2tXe05EJyU1P/Yu1nk3bo2O2J
         lOMf8SEioVeI9VUwLNFs2Z11EvpOOagVnjpo11qCtl0VxyCTUyKWClKArXLZ3go4xsDa
         FzGmjc1z3NxMtrfb5h1T6hAGQmGVUQ3yF0Ey/WL9wy+Z9xwmUdScyxGMfDF3JDvtm+mH
         w4C9SZhTHTQ9wpC9b+CMLG6gjjbB2o1y+6hJdYAjHD3siOqxm3pUDI7sNY/Wkc4Ww0iz
         WjrA==
X-Forwarded-Encrypted: i=1; AJvYcCWALwXSeRbSILuS91YDT9C8ZpTZN2+o18jQ0qfcHEGt47ofiQhV7/oY14V8lv/o0EpcRbU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya8WDz2h4cpJgYn21s0iyrEHmKewmZaHPNApkQH1rf+dQYbLQ6
	8/Se8BeUWyzAp1ziyLb8eTSg4aMaVfBNRinehWgJTMfoWPLpNLK9GojfM97pHZJfhMANWageayt
	cRQ==
X-Google-Smtp-Source: AGHT+IHDLdjZNyxLQN0ejQDDw2NTvh02ZzCQaOSR89rIlYqz4k/XO25Tst0eO8Neoqr6hdETLaRFpeg10FQ=
X-Received: from pfwz31.prod.google.com ([2002:a05:6a00:1d9f:b0:725:f14a:b57c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:811:b0:725:f282:1f04
 with SMTP id d2e1a72fcca58-72dafb70603mr51922168b3a.18.1737768218193; Fri, 24
 Jan 2025 17:23:38 -0800 (PST)
Date: Fri, 24 Jan 2025 17:23:36 -0800
In-Reply-To: <Z44DsmpFVZs3kxfE@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113020925.18789-1-yan.y.zhao@intel.com> <20250113021218.18922-1-yan.y.zhao@intel.com>
 <Z4rIGv4E7Jdmhl8P@google.com> <Z44DsmpFVZs3kxfE@yzhao56-desk.sh.intel.com>
Message-ID: <Z5Q9GNdCpSmuWSeZ@google.com>
Subject: Re: [PATCH 3/7] KVM: TDX: Retry locally in TDX EPT violation handler
 on RET_PF_RETRY
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com, 
	binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 20, 2025, Yan Zhao wrote:
> On Fri, Jan 17, 2025 at 01:14:02PM -0800, Sean Christopherson wrote:
> > On Mon, Jan 13, 2025, Yan Zhao wrote:
> > I don't see any point in adding this comment, if the reader can't follow the
> > logic of this code, these comments aren't going to help them.  And the comment
> > about vcpu_run() in particular is misleading, as posted interrupts aren't truly
> > handled by vcpu_run(), rather they're handled by hardware (although KVM does send
> > a self-IPI).
> What about below version?
> 
> "
> Bail out the local retry
> - for pending signal, so that vcpu_run() --> xfer_to_guest_mode_handle_work()
>   --> kvm_handle_signal_exit() can exit to userspace for signal handling.

Eh, pending signals should be self-explanatory.

> - for pending interrupts, so that tdx_vcpu_enter_exit() --> tdh_vp_enter() will
>   be re-executed for interrupt injection through posted interrupt.
> - for pending nmi or KVM_REQ_NMI, so that vcpu_enter_guest() will be
>   re-executed to process and pend NMI to the TDX module. KVM always regards NMI
>   as allowed and the TDX module will inject it when NMI is allowed in the TD.
> "
> 
> > > +		 */
> > > +		if (signal_pending(current) || pi_has_pending_interrupt(vcpu) ||
> > > +		    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending)
> > 
> > This needs to check that the IRQ/NMI is actually allowed.  I guess it doesn't
> > matter for IRQs, but it does matter for NMIs.  Why not use kvm_vcpu_has_events()?
> Yes. However, vt_nmi_allowed() is always true for TDs.
> For interrupt, tdx_interrupt_allowed() is always true unless the exit reason is
> EXIT_REASON_HLT. For the EPT violation handler, the exit reason should not be
> EXIT_REASON_HLT.
> 
> > Ah, it's a local function.  At a glance, I don't see any harm in exposing that
> > to TDX.
> Besides that kvm_vcpu_has_events() is a local function, the consideration to
> check "pi_has_pending_interrupt() || kvm_test_request(KVM_REQ_NMI, vcpu) ||
> vcpu->arch.nmi_pending" instead that

*sigh*

  PEND_NMI TDVPS field is a 1-bit filed, i.e. KVM can only pend one NMI in
  the TDX module. Also, TDX doesn't allow KVM to request NMI-window exit
  directly. When there is already one NMI pending in the TDX module, i.e. it
  has not been delivered to TDX guest yet, if there is NMI pending in KVM,
  collapse the pending NMI in KVM into the one pending in the TDX module.
  Such collapse is OK considering on X86 bare metal, multiple NMIs could
  collapse into one NMI, e.g. when NMI is blocked by SMI.  It's OS's
  responsibility to poll all NMI sources in the NMI handler to avoid missing
  handling of some NMI events. More details can be found in the changelog of
  the patch "KVM: TDX: Implement methods to inject NMI".

That's probably fine?  But it's still unfortunate that TDX manages to be different
at almost every opportunity :-(

> (1) the two are effectively equivalent for TDs (as nested is not supported yet)

If they're all equivalent, then *not* open coding is desriable, IMO.  Ah, but
they aren't equivalent.  tdx_protected_apic_has_interrupt() also checks whatever
TD_VCPU_STATE_DETAILS_NON_ARCH is.

	vcpu_state_details =
		td_state_non_arch_read64(to_tdx(vcpu), TD_VCPU_STATE_DETAILS_NON_ARCH);

	return tdx_vcpu_state_details_intr_pending(vcpu_state_details);

That code needs a comment, because depending on the behavior of that field, it
might not even be correct.

> (2) kvm_vcpu_has_events() may lead to unnecessary breaks due to exception
>     pending. However, vt_inject_exception() is NULL for TDs.

Wouldn't a pending exception be a KVM bug?

The bigger oddity, which I think is worth calling out, is that because KVM can't
determine if IRQs (or NMIs) are blocked at the time of the EPT violation, false
positives are inevitable.  I.e. KVM may re-enter the guest even if the IRQ/NMI
can't be delivered.  Call *that* out, and explain why it's fine.

> > > +			break;
> > > +
> > > +		cond_resched();
> > > +	}
> > 
> > Nit, IMO this reads better as:
> > 
> > 	do {
> > 		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
> > 	} while (ret == RET_PF_RETY && local_retry &&
> > 		 !kvm_vcpu_has_events(vcpu) && !signal_pending(current));
> >
> Hmm, the previous way can save one "cond_resched()" for the common cases, i.e.,
> when ret != RET_PF_RETRY or when gpa is shared .

Hrm, right.  Maybe this?  Dunno if that's any better.

	ret = 0;
	do {
		if (ret)
			cond_resched();

		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
	} while (...)

