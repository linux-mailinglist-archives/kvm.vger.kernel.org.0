Return-Path: <kvm+bounces-71663-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DblJl/7nWmeSwQAu9opvQ
	(envelope-from <kvm+bounces-71663-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:26:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B006518C0ED
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6B1E3309DDE9
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D6743ACA7E;
	Tue, 24 Feb 2026 19:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ge3kA35s"
X-Original-To: kvm@vger.kernel.org
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6906D2F617C;
	Tue, 24 Feb 2026 19:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771961168; cv=none; b=TgpfjQwCwWcnT0i1O61s0LcTbMJyTQQoJqBCwsSZz6D2mh4IaU3aecZ2TPWLUeatzhnWDens8Aq+chru32KQXgycLGWSOB4/AeY0dBOky8bdjLj/UUPAl/Tjaqsf730857jTUOPZWI7AHm1yKO6ZExVi0fSO93CaSZ/XqVi5xGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771961168; c=relaxed/simple;
	bh=m23sxk2fsrDn0ix0e/ZaHu0BCuHJX82d/xQJo5X520k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FaTgUQO7rds5OEa+3mL9s8/h6KdI4mQGj4Cj4XV2LdAD86IkohxXY0Ds3UkhHjuA1PJ/XMY+8iBaYL6Fz+K0zyuD0BkaX2lF9AxcH+aCu3uXPMZzuPPpAzNkJ05N+m+bt0b+W5LFNbuwfelLwAsDOQWUN1tPkH+mWXkiUJNNeDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ge3kA35s; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fL74G4bGYz1XM6JH;
	Tue, 24 Feb 2026 19:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1771961163; x=1774553164; bh=YUwsQGY2aFfZKK7Wlzh+EJtf
	iWdyE9X0mtY4U0hZqxM=; b=Ge3kA35sBhCoJF8c3Ti1glvz8fLxq82vKp/Kwnwb
	+iTUsyjRNVXuQ7SFVkqBPKfkCCAwkR6gm7dU77rxAs78UKc4sFO6oa1JP/5tbOAK
	AdTUZhh3kGegZDXLJE9z5HsonLgH9kQME2EChYeK9WpyZipCfLLgSmoc35HVdKuY
	mgo5qiMeG61wGt8ty4lSq2/1mUZWqoqVWvjy9OBCHz9FOnjQKZUlZtYWAdLJ23lu
	qJD9VLoA0r7HYl5XIellHSPrUtYCStYskIvtGRyfi8YBJZftVFMv68yQQlR22Um1
	ymblRp5e8wWR8qNO8bixPnrN1iaxlks6949ViZ5AMl3HWw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id J7sLZpho_xoS; Tue, 24 Feb 2026 19:26:03 +0000 (UTC)
Received: from [172.20.2.156] (unknown [4.28.11.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fL7464Psrz1XM6J6;
	Tue, 24 Feb 2026 19:25:58 +0000 (UTC)
Message-ID: <7a22294b-1150-4c55-a95a-ea918cfb9b76@acm.org>
Date: Tue, 24 Feb 2026 11:25:56 -0800
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aZ3r5_P74tUJm2oF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[acm.org,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[acm.org:s=mr01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_FROM(0.00)[bounces-71663-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[acm.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bvanassche@acm.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,acm.org:mid,acm.org:dkim,acm.org:email]
X-Rspamd-Queue-Id: B006518C0ED
X-Rspamd-Action: no action

On 2/24/26 10:20 AM, Sean Christopherson wrote:
> For the scope, please use:
> 
>     KVM: VMX:
> 
> On Mon, Feb 23, 2026, Bart Van Assche wrote:
>> The Clang thread-safety analyzer does not support comparing expressions
>> that use per_cpu(). Hence introduce a new local variable to capture the
>> address of a per-cpu spinlock. This patch prepares for enabling the
>> Clang thread-safety analyzer.
>>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: kvm@vger.kernel.org
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   arch/x86/kvm/vmx/posted_intr.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
>> index 4a6d9a17da23..f8711b7b85a8 100644
>> --- a/arch/x86/kvm/vmx/posted_intr.c
>> +++ b/arch/x86/kvm/vmx/posted_intr.c
>> @@ -164,6 +164,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>>   	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>>   	struct vcpu_vt *vt = to_vt(vcpu);
>>   	struct pi_desc old, new;
>> +	raw_spinlock_t *wakeup_lock;
>>   
>>   	lockdep_assert_irqs_disabled();
>>   
>> @@ -179,11 +180,11 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>>   	 * entirety of the sched_out critical section, i.e. the wakeup handler
>>   	 * can't run while the scheduler locks are held.
>>   	 */
>> -	raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu),
>> -			     PI_LOCK_SCHED_OUT);
>> +	wakeup_lock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
> 
> Addressing this piecemeal doesn't seem maintainable in the long term.  The odds
> of unintentionally regressing the coverage with a cleanup are rather high.  Or
> we'll end up with confused and/or grumpy developers because they're required to
> write code in a very specific way because of what are effectively shortcomings
> in the compiler.

I think it's worth mentioning that the number of patches similar to the
above is small. If I remember correctly, I only encountered two similar
cases in the entire kernel tree.

Regarding why the above patch is necessary, I don't think that it is
fair to blame the compiler in this case. The macros that implement
per_cpu() make it impossible for the compiler to conclude that the
pointers passed to the raw_spin_lock_nested() and raw_spin_unlock()
calls are identical:

/*
  * Add an offset to a pointer.  Use RELOC_HIDE() to prevent the compiler
  * from making incorrect assumptions about the pointer value.
  */
#define SHIFT_PERCPU_PTR(__p, __offset)				\
	RELOC_HIDE(PERCPU_PTR(__p), (__offset))

#define RELOC_HIDE(ptr, off)					\
({								\
	unsigned long __ptr;					\
	__asm__ ("" : "=r"(__ptr) : "0"(ptr));			\
	(typeof(ptr)) (__ptr + (off));				\
})

By the way, the above patch is not the only possible solution for
addressing the thread-safety warning Clang reports for this function. 
Another possibility is adding __no_context_analysis to the function
definition. Is the latter perhaps what you prefer?

Bart.

