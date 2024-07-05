Return-Path: <kvm+bounces-21016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 764E2928093
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:48:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98A4C1C22FF9
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29A11D688;
	Fri,  5 Jul 2024 02:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABV4fi/6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48663219FC
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720147712; cv=none; b=F70lNeyMkIH5OdsCJLiNZWwFY5s6J1EXEwyjtI4H4jstNVWndC5pQk5z2x4UrkGm67rOflQVPfUKAWhLRIMUxkCvxrrUcbOsOuADTg7AyCXLjpnAo0FChjGCiyg/8FBsVkd3DqilQqSAj3/BGZVyf0G8AZvDz0IkZCU0uN50ah8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720147712; c=relaxed/simple;
	bh=3l/nDkTEuLQCAmReuSFbK+H5QoQlegddQFe774aFXiA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VZK6JLyPkYY3NCL5pQtG/X0UL/oOze3rIUZ8np8HlM9u1IijRS4AJGHpSljKsFxixdv7H4EWSPcpJbjDKNkmvQ+cjsgY+WA8769IgkV2xEDuamO9mj0rTk8/ccOZ/ey3zusHTUy7/u2WKU5RIwHQb0OdnuWcdgXQNf79miGnNww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ABV4fi/6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720147710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PIztTC41X3SqpITk7EO4e8WG4gHXfiYx/21IOkrtDk=;
	b=ABV4fi/69GHaP73ulNusgDVeVC5Bho2aUF0wGuhPin7QW6sL8DXX7RAtJRmupcfZVEWmjc
	Cq1RzyJUIJYhyRON6bzYtMlVbLP6Vm54d06Z7/+q+FjBFl9MWDLp2NBCa2CvQ4yXKiPj70
	05p8KAlYUY+xFgcxonYE/Fm/p7erww8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-kV_DXwiwPred3_CN6KdQGQ-1; Thu, 04 Jul 2024 22:48:28 -0400
X-MC-Unique: kV_DXwiwPred3_CN6KdQGQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6b22e2dfa6cso17582556d6.1
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720147708; x=1720752508;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2PIztTC41X3SqpITk7EO4e8WG4gHXfiYx/21IOkrtDk=;
        b=S4XhpbV3V26kcJYlp/0QpEp5U5Fk+LaEGiKfOY2/mpyLQ5s6re30kCsMbm7m2ts1to
         o5YqKs9yYNG0+CxB7L1jceOa5O/0aMeNetDdEUCIxF3fbviz/3/wP28jLkl7EVUG+i8q
         QuHQEVdXU/lYlIjTQoXCI1rEDQYzwtzhMWmH0P81vH4XYiVdylE2V/dI+XIgTNQn5VcZ
         BZJBj4fqJ6752qoA8Y8ri2dqstyJ7Ng4CTGO4WimsP4OfK2MYZxJ+UiNfhLBPLJfZvaW
         9msOcOsHBwoL9hOS5CHjh4Zijq22+nZeog6oydFbDnFguTe1py/7a47QmeStj8/wKJ5F
         i9AQ==
X-Gm-Message-State: AOJu0Yxkb0vtE2MSQkW/uvC/MjQrqHYFxOQl6ejad8R1XHhNNMqeJg3M
	cFZPkqBUUexs//t5OgOngknXJIbkCD5WBxiy6nYSw5D9wHw93j2KXgC5smOTxxKZFrxwxQLE4Vh
	qNga3X7VgIcWjId0g9pKJsMcCYVp6w25OOy9J4Bzf+dNaZtAm0A==
X-Received: by 2002:a05:6214:1bc7:b0:6b5:9439:f048 with SMTP id 6a1803df08f44-6b5ecf8ac28mr37106696d6.19.1720147708002;
        Thu, 04 Jul 2024 19:48:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQ/S6tPBwjVySOrVqy0W45xFpjJZKhw/JesQX4ihyGag/zigRZaDY6AUleexB2pxZ5dZtR5A==
X-Received: by 2002:a05:6214:1bc7:b0:6b5:9439:f048 with SMTP id 6a1803df08f44-6b5ecf8ac28mr37106526d6.19.1720147707696;
        Thu, 04 Jul 2024 19:48:27 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b5f9d42de5sm705516d6.15.2024.07.04.19.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:48:27 -0700 (PDT)
Message-ID: <73ab1d49f1dfffe42ab2a8625ca6c2de0f06d3ad.camel@redhat.com>
Subject: Re: [PATCH 1/1] KVM: selftests: pmu_counters_test: increase
 robustness of LLC cache misses
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org
Date: Thu, 04 Jul 2024 22:48:26 -0400
In-Reply-To: <Zn2ker_KZ7Fk-7W1@google.com>
References: <20240621204305.1730677-1-mlevitsk@redhat.com>
	 <20240621204305.1730677-2-mlevitsk@redhat.com>
	 <Zn2ker_KZ7Fk-7W1@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2024-06-27 at 10:42 -0700, Sean Christopherson wrote:
> On Fri, Jun 21, 2024, Maxim Levitsky wrote:
> > Currently this test does a single CLFLUSH on its memory location
> > but due to speculative execution this might not cause LLC misses.
> > 
> > Instead, do a cache flush on each loop iteration to confuse the prediction
> > and make sure that cache misses always occur.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  .../selftests/kvm/x86_64/pmu_counters_test.c  | 20 +++++++++----------
> >  1 file changed, 9 insertions(+), 11 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > index 96446134c00b7..ddc0b7e4a888e 100644
> > --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> > @@ -14,8 +14,8 @@
> >   * instructions that are needed to set up the loop and then disabled the
> >   * counter.  1 CLFLUSH/CLFLUSHOPT/NOP, 1 MFENCE, 2 MOV, 2 XOR, 1 WRMSR.
> >   */
> > -#define NUM_EXTRA_INSNS		7
> > -#define NUM_INSNS_RETIRED	(NUM_BRANCHES + NUM_EXTRA_INSNS)
> > +#define NUM_EXTRA_INSNS		5
> > +#define NUM_INSNS_RETIRED	(NUM_BRANCHES * 2 + NUM_EXTRA_INSNS)
> 
> The comment above is stale.  I also think it's worth adding a macro to capture
> that the '2' comes from having two instructions in the loop body (three, if we
> keep the MFENCE).

True, my mistake.

> 
> >  static uint8_t kvm_pmu_version;
> >  static bool kvm_has_perf_caps;
> > @@ -133,9 +133,8 @@ static void guest_assert_event_count(uint8_t idx,
> >   * doesn't need to be clobbered as the input value, @pmc_msr, is restored
> >   * before the end of the sequence.
> >   *
> > - * If CLFUSH{,OPT} is supported, flush the cacheline containing (at least) the
> > - * start of the loop to force LLC references and misses, i.e. to allow testing
> > - * that those events actually count.
> > + * If CLFUSH{,OPT} is supported, flush the cacheline containing the CLFUSH{,OPT}
> > + * instruction on each loop iteration to ensure that LLC cache misses happen.
> >   *
> >   * If forced emulation is enabled (and specified), force emulation on a subset
> >   * of the measured code to verify that KVM correctly emulates instructions and
> > @@ -145,10 +144,9 @@ static void guest_assert_event_count(uint8_t idx,
> >  #define GUEST_MEASURE_EVENT(_msr, _value, clflush, FEP)				\
> >  do {										\
> >  	__asm__ __volatile__("wrmsr\n\t"					\
> > -			     clflush "\n\t"					\
> > -			     "mfence\n\t"					\
> 
> Based on your testing, it's probably ok to drop the mfence, but I don't see any
> reason to do so.  It's not like that mfence meaningfully affects the runtime, and
> anything easy/free we can do to avoid flaky tests is worth doing.

Hi,

I just didn't want to add another instruction to the loop, since in theory
that will slow the test down.


From PRM:

"Executions of the CLFLUSH instruction are ordered with respect to each other and with respect to writes, locked
read-modify-write instructions, and fence instructions. 1 They are not ordered with respect to executions of
CLFLUSHOPT and CLWB. Software can use the SFENCE instruction to order an execution of CLFLUSH relative to one
of those operations."

Plus there is note that:

"Earlier versions of this manual specified that executions of the CLFLUSH instruction were ordered only by the MFENCE instruction.
All processors implementing the CLFLUSH instruction also order it relative to the other operations enumerated above."

Here we have an instruction fetch and cache flush, and it is not clear if MFENCE orders two operations.
Thus it is not clear if MFENCE helps or not.

I honestly would have preferred a cache flush on data memory, followed by a read from it, except
that this also sometimes doesn't work (maybe I made some mistake, maybe it is possible to make it work, don't know)

But overall I don't object keeping it.


> 
> I'll post and apply a v2, with a prep patch to add a NUM_INSNS_PER_LOOP macro and
> keep the MFENCE (I'll be offline all of next week, and don't want to push anything
> to -next tomorrow, even though the risk of breaking anything is minimal).

Sounds good.

Best regards,
	Maxim Levitsky


> 
> > -			     "1: mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"	\
> > -			     FEP "loop .\n\t"					\
> > +			     " mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"	\
> > +			     "1: " clflush "\n\t"				\
> > +			     FEP "loop 1b\n\t"					\
> >  			     FEP "mov %%edi, %%ecx\n\t"				\
> >  			     FEP "xor %%eax, %%eax\n\t"				\
> >  			     FEP "xor %%edx, %%edx\n\t"				\
> > @@ -163,9 +161,9 @@ do {										\
> >  	wrmsr(pmc_msr, 0);							\
> >  										\
> >  	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT))				\
> > -		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflushopt 1f", FEP);	\
> > +		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflushopt .", FEP);	\
> >  	else if (this_cpu_has(X86_FEATURE_CLFLUSH))				\
> > -		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflush 1f", FEP);	\
> > +		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflush .", FEP);	\
> >  	else									\
> >  		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "nop", FEP);		\
> >  										\
> > -- 
> > 2.26.3
> > 



