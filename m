Return-Path: <kvm+bounces-72174-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDsoIuXHoWkVwQQAu9opvQ
	(envelope-from <kvm+bounces-72174-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:35:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 062011BADC5
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 17:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9CEA23008296
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939A63469EE;
	Fri, 27 Feb 2026 16:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EtQs4IwN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AD63128BE
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772210054; cv=none; b=Y2DsKU7OZnAlkDZoKiNE7Zc+RYw39wQ8wB0HQZCUxn4tB6d7JC2naY3HcvPiUpRDByUKyMVQLVNUUyiZX6FizSw7TCaGO7A6f8x10z8tyxXehi2wwhEfc94GWlCthSCW3e+k3EmMowe7m4bMjQHiRGSyBIKguEvLC6RpKr6J6oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772210054; c=relaxed/simple;
	bh=HWAMGtrVz239eZa/rts3BRWHsXqlB+YyTW7YCGChg6o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CuaJBnVtTtUFw2mqyuJg1hh7kZx2mmsoU9bvqEzgfBseUQZjQVc9UpFK9madxqTQzcVXzHmVh6KldmlQFFI++spXGWrWfILvGPYx6tNKPJyq2FP+W8Fd8gyJfabskrtkdOyQCCrymp35IkPOPaCyYiOtBstCroYMhLRuEskVlCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EtQs4IwN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ad7e454f38so134267485ad.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 08:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772210053; x=1772814853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zApGe4We6+vRR7eV6TuzKhkG9THcIsxQGN31fWvJcu0=;
        b=EtQs4IwNge+T1HaZ6cDjGIdL+OgtBv84/Fli9yXF8/RAzBocQFGszqu3b/vb4RpRlJ
         g8vb3Qmcl94ZVKMOsrH4+w33KaE1EgMsA2iVV73zqRNS2DE86UyssmZCETQm8I2uWrcZ
         qggZg3Rz2dGgOMaR5vgivbXVlvtGs0unB2VIs0chzwqRP2p1PmRWnrYwPp8CA8ddaHnZ
         SCoM4GdxkMeYnjIP3eu57CzHnkMKv47h/ZJ1OrI+sWa2CBe1J9G1b4XP+Nui+qDZhatO
         VkuIfrjpwVh9lZx9ef/aAdEiPgxoAAa+jRASUHJ/C+iggRHcTG5t9rJqe37/mJnMLfBy
         Pmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772210053; x=1772814853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zApGe4We6+vRR7eV6TuzKhkG9THcIsxQGN31fWvJcu0=;
        b=jwUPGDYBss3FpheaF664jKeD/OQXOwXpnw4YaQfPo/m3VK6qzfGR2rHds+5WqSPaA1
         YFAn4k//u+YleBCc1U/AyNR+S5V7mMyDGpLUQhImhfyCdeNXTZjV3xi9tjkbH/ItRZ2S
         0fJt/K3de/H0AhROi5egOflc1NZog6Zr+SKs2e6xv2h0FKZ23gLcnDHk1UzyoOjGIT1Y
         t0ykQl41B0Eek4hB/NihZ4qJ3Tr9iSI0G/mhbY2eemJ5Md9+P+LFPvhQoLIDrPKyPOjO
         tAHvvmVvPXLzP0h4ZzDWMnaI/2G1oKws/ePKSixgP0TswG8sA13QauLyYfxnm9iZCkxq
         fe3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUdGf8vkO4juCrunC2mTqjDqLrCBAPpagYFYS9s/FcMNgeWl9a2hXHoxwQhrOOmWxVz8Bo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhJ738LvySl4LqZ0mUseVeDJWUu/8PIMvuaCqTi4b0OfUbN+ci
	GaxJiLAVbSMOrdhYI5XDvlpYr1BFB3sIAF9GyMfZe4LQO+KUKRQ6KLgaH//VogUWhaGANGjj8RB
	gTJDyZA==
X-Received: from plpj4.prod.google.com ([2002:a17:903:3d84:b0:2aa:d670:bf3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f541:b0:2ab:344e:1413
 with SMTP id d9443c01a7336-2ae2e46c080mr31921575ad.34.1772210052794; Fri, 27
 Feb 2026 08:34:12 -0800 (PST)
Date: Fri, 27 Feb 2026 08:34:11 -0800
In-Reply-To: <aaG_o58_0aHT8Xjg@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227011306.3111731-1-yosry@kernel.org> <20260227011306.3111731-4-yosry@kernel.org>
 <aaG_o58_0aHT8Xjg@google.com>
Message-ID: <aaHHg2-lcpvkejB8@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Check for injected exceptions before
 queuing a debug exception
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72174-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 062011BADC5
X-Rspamd-Action: no action

On Fri, Feb 27, 2026, Sean Christopherson wrote:
> So instead of patch 1, I want to try either (a) blocking KVM_SET_VCPU_EVENTS,
> KVM_X86_SET_MCE, and KVM_SET_GUEST_DEBUG if nested_run_pending=1, *and* follow-up
> with the below WARN-spree, or (b) add a separate flag, e.g. nested_run_in_progress
> or so, that is set with nested_run_pending, but cleared on an exit to userspace,
> and then WARN on _that_, i.e. so that we can detect KVM bugs (the whole point of
> the WARN) and hopefully stop playing this losing game of whack-a-mole with syzkaller.
> 
> I think I'm leaning toward (b)?  Except for KVM_SET_GUEST_DEBUG, where userspace
> is trying to interpose on the guest, restricting ioctls doesn't really add any
> value in practice.  Yeah, in theory it could _maybe_ prevent userspace from shooting
> itself in the foot, but practically speaking, if userspace is restoring state into
> a vCPU with nested_run_pending=1, it's either playing on expert mode or is already
> completely broken.
> 
> My only hesitation with (b) is that KVM wouldn't be entirely consistent, since
> vmx_unhandleable_emulation_required() _does_ explicitly reject a "userspace did
> something stupid with nested_run_pending=1" case.  So from that perspective, part
> of me wants to get greedy and try for (a).

On second (fifth?) thought, I don't think (a) is a good idea.  In addition to
potentially breaking userspace, it also risks preventing genuinely useful sequences.
E.g. even if no VMM does so today, it's entirely plausible that a VMM could want
to asynchronously inject an #MC to mimic a broadcast, and that the injection could
collide with a pending nested VM-Enter.

I'll send a separate (maybe RFC?) series for (b) using patch 1 as a starting point.
I want to fiddle around with some ideas, and it'll be faster to sketch things out
in code versus trying to describe things in text.

