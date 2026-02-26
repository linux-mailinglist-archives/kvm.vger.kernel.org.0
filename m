Return-Path: <kvm+bounces-72096-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QA+cHhXLoGmlmgQAu9opvQ
	(envelope-from <kvm+bounces-72096-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:37:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D7F9C1B072C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1BE4D30630B7
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 22:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 675253A1E90;
	Thu, 26 Feb 2026 22:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2RF8GXaD"
X-Original-To: kvm@vger.kernel.org
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D592F1FDB;
	Thu, 26 Feb 2026 22:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772145397; cv=none; b=C8LrYYq9SSIkuYzkgCMzDez/wEsWfj2rhnhDTu+KtCdmKPsbaVgICKxe4K7NMDTWLksE4GODp7Efv+c/adPJwKqHXiepQRxz4H7NmNamBYLhHk6+s0uX87FUqqjajy61Vvf15fwuqEiSk6EVJxm5tpCPbv3tMeY+sBp/QFF0OLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772145397; c=relaxed/simple;
	bh=/sFmDFLV7XTL/ujLEyBFVnPqzpZhNj6reogTAVUkIQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h0Flg1heR160zpZvmPtRUxArllE8EBzZF4Yb9DBJey0MG33VPVIiNdhQuBI2JI+dRltlUxcmSlGXLPAvX24KlgTtTIG08jhOGLdvtmM6Ta9SRDa7en11/Kbl5fiGx+1XjbJybCFncuUFbkb8rF4GDR/u5UKWZHoRWE/mIvVQRCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2RF8GXaD; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fMRC23n8Wz1XM6Jb;
	Thu, 26 Feb 2026 22:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772145384; x=1774737385; bh=U9a4NSGWyP3kPh9xXL0EyR//
	4N9ALn1nDZ6jQB2mMHg=; b=2RF8GXaDiIGR2Ofoy9ESFPDtHyNG9crqUGC+Llvl
	0i19NxsfMwwTje1N/BX5gx+ozfoss07FcdyNBUThxfZtNabOomXEb3vCwRSfF7tj
	plh1akI9BAIAgS2VxDdrLQ5NeDgJC6ltNW4c+/9MFzUTQ1KcCasti9eWrDp9TTgd
	1NeHz8P1llhpBnmwgqwRG6i44+9Zm0Z61AEOewAbjftg5dcPipvzExPbH6uoQkP7
	bA5uChxJC65o0tiSDBgM1hwOA4eBQ3VgP5ZiI9BF+3FLDLV+WAvWOLkqauGOS8ox
	1yQVvJcX5MV2PyISsSmRXMSN16GopKgEZrL3Mk+1K6oLIw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Hvts2SWg2q21; Thu, 26 Feb 2026 22:36:24 +0000 (UTC)
Received: from [172.20.2.156] (unknown [4.28.11.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fMRBq2pBzz1XM5jn;
	Thu, 26 Feb 2026 22:36:19 +0000 (UTC)
Message-ID: <9a196181-cde0-4c9b-b9ec-f0c18eaf9cfd@acm.org>
Date: Thu, 26 Feb 2026 14:36:18 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/62] kvm: Make pi_enable_wakeup_handler() easier to
 analyze
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
 Marco Elver <elver@google.com>, Christoph Hellwig <hch@lst.de>,
 Steven Rostedt <rostedt@goodmis.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
 Jann Horn <jannh@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
References: <20260223215118.2154194-1-bvanassche@acm.org>
 <20260223215118.2154194-2-bvanassche@acm.org> <aZ3r5_P74tUJm2oF@google.com>
 <7a22294b-1150-4c55-a95a-ea918cfb9b76@acm.org> <aaCHS5ZRuW-QJkK7@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aaCHS5ZRuW-QJkK7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[acm.org,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[acm.org:s=mr01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72096-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,acm.org:mid,acm.org:dkim]
X-Rspamd-Queue-Id: D7F9C1B072C
X-Rspamd-Action: no action

On 2/26/26 9:47 AM, Sean Christopherson wrote:
> What's your timeline for enabling -Wthread-safety?  E.g. are you trying to land
> it in 7.1?  7.2+?  I'd be happy to formally post the below and get it landed in
> the N-1 kernel (assuming Paolo is also comfortable landing the patch in 7.0 if
> you're targeting 7.1).

Hi Sean,

I expect that I will need two or three release cycles to get all the 
patches upstream before -Wthread-safety can be enabled. How about
giving Marco a few weeks time to come up with an improvement for
RELOC_HIDE()?

Thanks,

Bart.

