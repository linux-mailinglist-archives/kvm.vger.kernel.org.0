Return-Path: <kvm+bounces-72413-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MERvHI7/pWl5IwAAu9opvQ
	(envelope-from <kvm+bounces-72413-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:22:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B8B1E2950
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 22:22:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3ADDE332BD91
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 21:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6104DD6DB;
	Mon,  2 Mar 2026 20:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RLTXvBuI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906B04DC53F
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 20:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772484107; cv=none; b=nhzvUNnL/jP58hfuPrJDC7eQiWnVOu3EBDT0jPogZU31fIAxXYi5dG/WnpGklqV10dtbMh4XAyFxnEM56xhxhU9zKiaQ5jvZofSDx0zLt0II7EMYfNbu5h5t5DnaRJYgcO3kKr53LOPLfkJ0VEDOi0/nDyioFYTcNU4iFHiNoR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772484107; c=relaxed/simple;
	bh=R/MIcxqUVQTwE5wwGHyGtW9Y/bGlblc1zMp+2swWJbA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nNLAUj/eToPMQtJr2yGhJ5GCilhqMRc5kjtxD4B6nU3kpZtmiBn7U0Xhzl0Tq5qYrm55AiLFJWL4rHS4EwUIuInhBZVjiNLrXYfJTkVvoiFzTGmgMpap2DMC4tBu0IMjRmKhFt96cXNVaaNVG5hOixYJ1l2pnAxYMpvzTaHVavM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RLTXvBuI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3598d3e3bc7so1268086a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 12:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772484106; x=1773088906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LgZDmqmpagJozBHMzfcbK0Tu/J0kjNTVJeXoQ0mkXOo=;
        b=RLTXvBuIv+tpS/Y4nq4dGMGUemVDivwhhxcYUlswcPt7lFpV1LDYYeCDiH8SDr+eSE
         A7yPRj5NMUJYu0L1Dw8nOnlecvKDeh2XVosoiBXFX4i4LmPteiyV+nwigY8Pos5Qg+xa
         /wLjHqB2SIbcTZV9IbkOEy8brhzKgqJpMqD3BrzydBIb5fMREdE1tVSaT40xtYfIs3JS
         9kI+3YXL/JwYOM6nqL+OWQVUVtHmjlfJObefcFp0VwxtfvYU9OIndFgAyZIf380a9Wmh
         652egbnj1UvdeMZnt0dwhmCK9kemdK+EwkUufdmU6vAfw6AdrdeTu6keJjMXg6itRGEh
         AjEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772484106; x=1773088906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LgZDmqmpagJozBHMzfcbK0Tu/J0kjNTVJeXoQ0mkXOo=;
        b=YxilhJbF+rn+QjXBOZbRZ5+54WOWg7f0SBxRBYwkzGIVoZMn9TnGHs0rwvHE8ZAU+T
         on6yyMaZKAlMKWG2zAyA/6uS0Mj8VxuedBUsUfB0AHMwzBWCSSS53R1LZEOEDw95jPWI
         hsAcAlxpJrVtwAKGCpAClORUDNRkYTBCLtPKJuYDYBFN1bRbq/b9he04v9Kx3IkLMgbi
         v/7LZLyGnmFXWXVGzg5AA2dweZthLyXVn22qMK0+hTIu5nOBAb9KPQgVWqjuToBM/TM1
         gLDufJDFy2FpZi3j0Bfb8vGMznvc2pVC8Wfg8YBnC9OspnraeAvUOnFVIXxGmvteOSdI
         iZ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWyBw+Db3mcRDpBtD9n+V9uXRVQdL/ayrRT00Sd1bdHWhVUS92bpvcR+bBWmKzZduL44i4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxaDpx9zetj2vs6D6q+EEYU7e7j3/R7NIoBDrBs0qtUPPNB/5l
	oTgRPo9H6vgADwxLxBEQX24aoUdLon0QT7ZmwG1t011v1GaUdsO3EmvvuYzFwB5mn/5WeAWaRKQ
	YRZ4eBw==
X-Received: from pjwo3.prod.google.com ([2002:a17:90a:d243:b0:359:8c13:8588])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:524a:b0:356:7b41:d348
 with SMTP id 98e67ed59e1d1-35965cd00e3mr10408302a91.20.1772484105712; Mon, 02
 Mar 2026 12:41:45 -0800 (PST)
Date: Mon, 2 Mar 2026 12:41:44 -0800
In-Reply-To: <CAO9r8zMJ8rvzS00eXJ7RPkRPicg2BwB4eq+xVtKXFWn5ZUamUw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225005950.3739782-1-yosry@kernel.org> <20260225005950.3739782-3-yosry@kernel.org>
 <CAO9r8zMJ8rvzS00eXJ7RPkRPicg2BwB4eq+xVtKXFWn5ZUamUw@mail.gmail.com>
Message-ID: <aaX2CKeO831_Nx3r@google.com>
Subject: Re: [PATCH v3 2/8] KVM: nSVM: Sync interrupt shadow to cached vmcb12
 after VMRUN of L2
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: D1B8B1E2950
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72413-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Action: no action

On Fri, Feb 27, 2026, Yosry Ahmed wrote:
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index de90b104a0dd5..9909ff237e5ca 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -521,6 +521,7 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
> >         u32 mask;
> >         svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
> >         svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
> > +       svm->nested.ctl.int_state       = svm->vmcb->control.int_state;
> 
> FWIW, this is an incomplete fix. KVM might update the interrupt shadow
> after this point through __svm_skip_emulated_instruction(), and that
> won't be captured in svm->nested.ctl.int_state.
> 
> I think it's not worth fixing that case too, and any further effort
> should go toward teaching KVM_GET_NESTED_STATE to pull state from the
> correct place as discussed earlier.

+1.  FWIW, AMD doesn't have a MOV/POP SS shadow, so practically speaking the only
impact is that an STI shadow could get extended for one extra instruction.  Unless
the guest is doing e.g. "sti; hlt; cli", that's a non-issue.

