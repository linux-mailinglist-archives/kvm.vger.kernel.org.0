Return-Path: <kvm+bounces-72114-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4D/iByfjoGmhnwQAu9opvQ
	(envelope-from <kvm+bounces-72114-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:19:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D53801B1326
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 01:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 35DA530514A3
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1BDD2512DE;
	Fri, 27 Feb 2026 00:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="e2/QORc/"
X-Original-To: kvm@vger.kernel.org
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4251D86DC;
	Fri, 27 Feb 2026 00:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772151577; cv=none; b=G8J/y1pxMYQjWIKvtNmvRoJsHzzyF2YLgj/QRvacl8dDPKA9VeWZycwugmO4Eivq0/Bda1bDs5kX5c80EQHpuEpbUSeAIqZdLGyT08QR3NBcQEB7AzZ9/b+5ot8XA0FsnfZ6/gVmcmrGlDJiDWUYCaiUPO7wbu/bNFgwWINmq9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772151577; c=relaxed/simple;
	bh=PdDRZ1136gB9ByykHhCx7SagMxi8ihnkjGprhvvrQqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dxktX3/nq7Dr1WdaxnX7plam1G2COSGy2zvixD2qpv5enHnN8epHS5lOTdAvCUku3bBWJ+JzHUTbLKorMo67+xt7UdVxXWWMJL61JAl5Swe4+ir0oMDefsUZmNYu84YmlHODHOa5eoVro/TVv0Tx5Ix7Rt0LACV0En8LMgOWxpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=e2/QORc/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fMTV00h9Pz1XM5jn;
	Fri, 27 Feb 2026 00:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772151568; x=1774743569; bh=PdDRZ1136gB9ByykHhCx7Sag
	Mxi8ihnkjGprhvvrQqg=; b=e2/QORc/d72GzQUvZzpkNrGsAks90HyLmbZ6b2Ti
	Z8qM5Ib22t4huRDdas1B6JFswvibU1lcWoFP4ODvgmxJRFsUXje3HRSOBeVM0Mr0
	3AtWY0Jerf65O25sLMhYwyRT2vnSRJJdGwQLRQ+ZgO7Jn865N3ZOoFFE7P062m7N
	TVd44nQhxv3u+mUNxni4K40rM1PGa1vdQSqwHTf8DK8lwbblZNgOfhNLaabSBbK/
	P9WqSTmTxMSvHZOXQj1aYPPDcp0iX+3dMWiR52wDNLyLhTCXawgPzMsD0bo3PGIW
	5DeHDNWjHJHmQ30xJNv7rJlaDzF/IHFTaOrzGgbKfC6dPg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UB8PKPvG2cbV; Fri, 27 Feb 2026 00:19:28 +0000 (UTC)
Received: from [172.20.2.156] (unknown [4.28.11.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fMTTm3H28z1XM6JX;
	Fri, 27 Feb 2026 00:19:24 +0000 (UTC)
Message-ID: <e3946223-4543-4a76-a328-9c6865e95192@acm.org>
Date: Thu, 26 Feb 2026 16:19:21 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/62] kvm: Make pi_enable_wakeup_handler() easier to
 analyze
To: Marco Elver <elver@google.com>, Sean Christopherson <seanjc@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
 Jann Horn <jannh@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
References: <20260223215118.2154194-1-bvanassche@acm.org>
 <20260223215118.2154194-2-bvanassche@acm.org> <aZ3r5_P74tUJm2oF@google.com>
 <7a22294b-1150-4c55-a95a-ea918cfb9b76@acm.org> <aaCHS5ZRuW-QJkK7@google.com>
 <CANpmjNPKkFxg0gLu+n+PaGgkq0AQ70DdHi69D3iEwGFO-r-yiw@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CANpmjNPKkFxg0gLu+n+PaGgkq0AQ70DdHi69D3iEwGFO-r-yiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[acm.org,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[acm.org:s=mr01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72114-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[acm.org:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bvanassche@acm.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[acm.org:mid,acm.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D53801B1326
X-Rspamd-Action: no action

On 2/26/26 12:13 PM, Marco Elver wrote:
> The goal of RELOC_HIDE is to make the optimizer be less aggressive.
> But the Thread Safety Analysis's alias analysis happens during
> semantic analysis and is completely detached from the optimizer, and
> we could potentially construct an expression that (a) lets Thread
> Safety Analysis figure out that __ptr is an alias to ptr, while (b)
> still hiding it from the optimizer. But I think we're sufficiently
> scared of breaking (b) that I'm not sure if this is feasible in a
> clean enough way that won't have other side-effects (e.g. worse
> codegen).

Does the thread-safety alias analyzer assume that function calls with
identical inputs produce identical outputs? If so, how about changing
RELOC_HIDE() from a macro into an inline function? Would that be
sufficient to make the thread-safety checker recognize identical
per_cpu() expressions as identical without affecting the behavior of the
optimizer?

Thanks,

Bart.

