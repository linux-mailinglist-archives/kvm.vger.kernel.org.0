Return-Path: <kvm+bounces-30380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95A4B9B996A
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 21:27:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 262361F22149
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 20:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1949C1D9A62;
	Fri,  1 Nov 2024 20:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="bdKYNoLR";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="z/S8Ff0J"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBDC1D4340;
	Fri,  1 Nov 2024 20:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730492828; cv=none; b=EItjAToQaA2aw94jp/YA5m7n4cp0lzil96mBnAcxMK2P1n6KiU+fOikfW+v53TdmcgzPaEhEt4qmFoVrSDzVAUdmJ4Zd/yhzxEf9yVccBB0HB1L72VKFimt0ezbRFJeUsHBgxJSgMn4htWtGVraEIS700yUxdCm5eo/jFs/4LuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730492828; c=relaxed/simple;
	bh=ISQjNBpVnwth0z+xcapjqqbKON+VNDQxUdZT8Zeo8l8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=og2Am4o1u4vsYqcFr1MhwBlOTzSvVTjZ3TMKsmV/exGLlI/RPuLa2DCKcRi+HI3XLaLjlNpGtLG2nwKxup04V87Uw/FM66Dwinr9CKik0yE4lPtd+2sm1ntbp24trAED5yzHLli2o5dAMtDfuPCT0jtRCbUFjDq0SeXa3LHP/pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=bdKYNoLR; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=z/S8Ff0J; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1730492824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1xV06QTqGl9nixnpVpVhm4ITfCkevbgwfgxifl3glXs=;
	b=bdKYNoLRW/D6u9dVR1Re/YsN9u1+39ZdE7c7n6w6JMSHxUgegbgrQ2/feVQH4Ns2UhxbXv
	5R/lMYH3/5wnLbxfNPjnJ28b+8WzHCswX8tJ30IwZIkbQTOpTbNDANbI2rkOU28grnlFqG
	6vV1ixY5sS+dLUhowYMcqqeHVGn5/rSUVvyARdl9YNW/1PDIU9wiwP9iRFnY0fkLLqrzEE
	FQdULVwLCjeZ+djwB0KHPNcn1hotUoCwvvSDsEYT74Nowrcn4ZqHU06Aowwe5wr6qp2RJh
	DtsZ2zF+0sS/DcC5jxWrAPms2vH29ByFylYP0EVgME3ujZ53UrsAANqMBB7dQA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1730492824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1xV06QTqGl9nixnpVpVhm4ITfCkevbgwfgxifl3glXs=;
	b=z/S8Ff0JoHnOXPst4EdLogpr30PKrdNkL8kIbeI27e7fNEc8RRebLhMh+dJv1eMqVIf0ua
	wm8hdcOmpHV/gmCg==
To: Junaid Shahid <junaids@google.com>, Brendan Jackman
 <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Sean
 Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandre Chartre <alexandre.chartre@oracle.com>, Liran Alon
 <liran.alon@oracle.com>, Jan Setje-Eilers <jan.setjeeilers@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Andrew Morton
 <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Lorenzo Stoakes
 <lstoakes@gmail.com>, David Hildenbrand <david@redhat.com>, Vlastimil
 Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>, Khalid Aziz
 <khalid.aziz@oracle.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent
 Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Valentin
 Schneider <vschneid@redhat.com>, Paul Turner <pjt@google.com>, Reiji
 Watanabe <reijiw@google.com>, Ofir Weisse <oweisse@google.com>, Yosry
 Ahmed <yosryahmed@google.com>, Patrick Bellasi <derkling@google.com>, KP
 Singh <kpsingh@google.com>, Alexandra Sandulescu <aesa@google.com>, Matteo
 Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>,
 x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-toolchains@vger.kernel.org
Subject: Re: [PATCH 01/26] mm: asi: Make some utility functions noinstr
 compatible
In-Reply-To: <d0a38982-b811-4429-8b89-81e5da3aaf72@google.com>
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
 <20240712-asi-rfc-24-v1-1-144b319a40d8@google.com>
 <20241025113455.GMZxuCX2Tzu8ulwN3o@fat_crate.local>
 <CA+i-1C3SZ4FEPJyvbrDfE-0nQtB_8L_H_i67dQb5yQ2t8KJF9Q@mail.gmail.com>
 <ab8ef5ef-f51c-4940-9094-28fbaa926d37@google.com> <878qu6205g.ffs@tglx>
 <d0a38982-b811-4429-8b89-81e5da3aaf72@google.com>
Date: Fri, 01 Nov 2024 21:27:03 +0100
Message-ID: <87cyjevgx4.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Oct 31 2024 at 18:44, Junaid Shahid wrote:
> On 10/29/24 12:12 PM, Thomas Gleixner wrote:
>> 
>> I doubt that it works as you want it to work.
>> 
>> +	inline notrace __attribute((__section__(".noinstr.text")))	\
>> 
>> So this explicitely puts the inline into the .noinstr.text section,
>> which means when it is used in .text the compiler will generate an out-of
>> line function in the .noinstr.text section and insert a call into the
>> usage site. That's independent of the size of the inline.
>> 
>
> Oh, that's interesting. IIRC I had seen regular (.text) inline functions get 
> inlined into .noinstr.text callers. I assume the difference is that here the 
> section is marked explicitly rather than being implicit?

Correct. Inlines without any section attribute are free to be inlined in
any section, but if the compiler decides to uninline them, then it
sticks the uninlined version into the default section ".text".

The other problem there is that an out of line version can be
instrumented if not explicitely forbidden.

That's why we mark them __always_inline, which forces the compiler to
inline it into the usage site unconditionally.

> In any case, I guess we could just mark these functions as plain
> noinstr.

No. Some of them are used in hotpath '.text'. 'noinstr' prevents them to
be actually inlined then as I explained to you before.

> (Unless there happens to be some other way to indicate to the compiler to place 
> any non-inlined copy of the function in .noinstr.text but still allow inlining 
> into .text if it makes sense optimization-wise.)

Ideally the compilers would provide

        __attribute__(force_caller_section)

which makes them place an out of line inline into the section of the
function from which it is called. But we can't have useful things or
they are so badly documented that I can't find them ...

What actually works by some definition of "works" is:

       static __always_inline void __foo(void) { }

       static inline void foo(void)
       {
                __(foo);
       }

       static inline noinstr void foo_noinstr(void)
       {
                __(foo);
       }

The problem is that both GCC and clang optimize foo[_noinstr]() away and
then follow the __always_inline directive of __foo() even if I make
__foo() insanely large and have a gazillion of different functions
marked noinline invoking foo() or foo_noinstr(), unless I add -fno-inline
to the command line.

Which means it's not much different from just having '__always_inline
foo()' without the wrappers....

Compilers clearly lack a --do-what-I-mean command line option.

Now if I'm truly nasty then both compilers do what I mean even without a
magic command line option:

       static __always_inline void __foo(void) { }

       static __maybe_unused void foo(void)
       {
                __(foo);
       }

       static __maybe_unused noinstr void foo_noinstr(void)
       {
                __(foo);
       }

If there is a single invocation of either foo() or foo_noinstr() and
they are small enough then the compiler inlines them, unless -fno-inline
is on the command line. If there are multiple invocations and/or foo
gets big enough then both compilers out of line them. The out of line
wrappers with __foo() inlined in them end always up in the correct
section.

I actually really like the programming model as it is very clear about
the intention of usage and it allows static checkers to validate.

Thoughts?

Thanks,

        tglx

