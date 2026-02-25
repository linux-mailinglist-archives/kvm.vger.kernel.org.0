Return-Path: <kvm+bounces-71725-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAGCDshKnmnXUQQAu9opvQ
	(envelope-from <kvm+bounces-71725-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:05:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBF618E82E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:05:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AAFBF30A6DD4
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3512505B2;
	Wed, 25 Feb 2026 01:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSULf9g2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1863219B5A3
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771981269; cv=none; b=MC0PzEbYOZTvkfjTTLBuFX/TqzBhMoAwNnTUrcgGRskDBUSAVx7Bnl3HplZOa4eYYolfBre/GqgPVYnER1cqIP/Yao2yR0sbEde7cQenuo9q14mbUxX6PZB01w6bOSjafuQejENyIcvQwKeQNGqErcw2S4jCi/PFC9zgfe7azGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771981269; c=relaxed/simple;
	bh=TfYc7xs5AoCgDmaQhtHDFVfWTb2Pd0soWTYMVW9mmTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ojy06i3rbf2um1SQtny2CN72ClfyEDt3lIt+WR0h0COcmklrkh7Amj8A+Ey/g3GmnkPT+iOQwlmtt1az/sYJK1t8QjKq85lMySU+rL/EER1i1KJKtEY8zFI+w8qWlmyQcGkWRv7Wu8Doe3TYz0b+i7upHVDSIIu4yPumuqOVdmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSULf9g2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F282DC19424
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771981269;
	bh=TfYc7xs5AoCgDmaQhtHDFVfWTb2Pd0soWTYMVW9mmTc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CSULf9g2c/mr//kicDi1TLxptFOMTDvu4mMsHWH7kyXdRXjp0GI1p4ES32trT83o4
	 oXoh1Xtkq7ecOhmxcKBh1UnuMqFdZwCpEHTuKULR6M+3gLRzS/M73TeGOKs3C8wio4
	 niEl8QezvaAbq13ilQ6KhfExWMoEiwLuWGpS7QHqApoTyL7osRJHRDG7kmPcPBx/nJ
	 gXJbQOlg9u7UrZiBt8Fm+wxL5BfWEhexsw3grJTrTQa1MqKyGjAj/Fxppn0BL4ciAF
	 Xt+KlGAsi+0djbbQ8CYXKyOO70vLS+pUSk7Fv5HGNnnSY2f1uj0ONrssjMgo1HQsfl
	 wrDjMkEOB8D7Q==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65f71ed7c6cso1744277a12.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:01:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXg4QlNgskw0LfUXjPl21nGy0UpQ+4lqGrwNj0qSvZZHyTv9LyYPx53D405kdUJvXTbVnw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQPg4RdzhsjqWlTNOvyhqV/QEl2ddAZMFh0PSd9Ik5dFWNZS45
	gfT0SnOZV3x+RyCT8Ob10AnTA/tEWaHw6cUs8fjuputA8j1sZR/mJlIuBpAA6p9a98SjGWg63UU
	KNP3RHKAGcyJ4gmkKFBcw57gyalH0jGU=
X-Received: by 2002:a17:907:d94:b0:b73:6d56:7332 with SMTP id
 a640c23a62f3a-b9341903c5amr36094266b.13.1771981267786; Tue, 24 Feb 2026
 17:01:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223154636.116671-1-yosry@kernel.org> <20260223154636.116671-3-yosry@kernel.org>
 <CAO9r8zPsAMaiU794xoXDso3sdAM0_EN2PyE13vR4NqqEh9e2=g@mail.gmail.com> <aZ5ItfEUtIlVbzuQ@google.com>
In-Reply-To: <aZ5ItfEUtIlVbzuQ@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Feb 2026 17:00:56 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPbu1BsOsPU02YcCLDbRXZoDmVd8XiMHssSDnkjdDPC4g@mail.gmail.com>
X-Gm-Features: AaiRm52m3EoNOeCo__hUjoDPDKy5FvTWAW3YBfoYKKtnhYo-R9J1u6Qj27WjJ5A
Message-ID: <CAO9r8zPbu1BsOsPU02YcCLDbRXZoDmVd8XiMHssSDnkjdDPC4g@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: nSVM: Delay stuffing L2's current RIP into
 NextRIP until vCPU run
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71725-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: AEBF618E82E
X-Rspamd-Action: no action

> > Doing this in svm_prepare_switch_to_guest() is wrong, or at least
> > after the svm->guest_state_loaded check. It's possible to emulate the
> > nested VMRUN without doing a vcpu_put(), which means
> > svm->guest_state_loaded will remain true and this code will be
> > skipped.
> >
> > In fact, this breaks the svm_nested_soft_inject_test test. Funny
> > enough, I was only running it with my repro changes, which papered
> > over the bug because it forced an exit to userspace after VMRUN due to
> > single-stepping, so svm->guest_state_loaded got cleared and the code
> > was executed on the next KVM_RUN, before L2 runs.
> >
> > I can move it above the svm->guest_state_loaded check, but I think I
> > will just put it in pre_svm_run() instead.
>
> I would rather not expand pre_svm_run(), and instead just open code it in
> svm_vcpu_run().  pre_svm_run() probably should never have been added, because
> it's far from a generic "pre run" API.  E.g. if we want to keep the helper around,
> it should probably be named something something ASID.

I sent a new version before I saw your response.. sorry.

How strongly do you feel about this? :P

