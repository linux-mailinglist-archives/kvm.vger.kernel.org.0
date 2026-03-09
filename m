Return-Path: <kvm+bounces-73355-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kHjbFi0gr2neOAIAu9opvQ
	(envelope-from <kvm+bounces-73355-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:31:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C85240072
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 20:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D7A96302298A
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 19:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5461A362120;
	Mon,  9 Mar 2026 19:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HH6kr/x1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6532D978C
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 19:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773084476; cv=none; b=A3KwxmVFMC2304u7W8gTwPSbJkKzexdCvIwVOvZv5bOL5bGexsUDoqF/w2kT4ZO9pHAad0UN5TWTlZFTLXTvGrnEgAySGHUfuRNNbQw+5bpGKoj5H+XRCwJrZF5X6+Ni7oiwnQT8eUy/2VVdLDQ/JlTf2IqWri25Dllt29tIcRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773084476; c=relaxed/simple;
	bh=mDnIlWt5S6ZYGX9wYtM4TlzRPCybD/Bxq0jFAVwaScE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOEkJ/8+15ou7/JWvak4Fd46BJrE5U/TveAWSv9L6g6KyftgQR0reREYl+2KzQ5ORgbW7NCfDKtbxQ7yM9yKPXy4JUqwCG69//ZnQVjsDBjwRxkx3SsaD5QhqtsBJr9ehYlsatHoKGOJ3YMMJwen0KpRBUWzmjtdkxJGo4jVFoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HH6kr/x1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ae3f822163so20955ad.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 12:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773084475; x=1773689275; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+5+N+QS7JaZPLj+uCtT6Y1yacnGRCT6luuIZGAnMNOM=;
        b=HH6kr/x1pVeM9tsVVf2aG71BPUUjvh3qWnKiTEVcn5AMBjBvmFpvSqRpCQ1KQqeGCS
         7S3cl8iJPjXP6dIAmuVubCIZiDQN9uYap/gN0qd1xCoN/LZdePKpkWq2ljXrLUW0mbx4
         sejRYFYs28Oh1k7pUniwY0V9fZH8t9DHLfla367AzDuH45s0pHcoCR2TC4cCVzofj6cZ
         QCQ+aaW9i9SXPUqF5BNHeL0jnyhAwFLOObm9s3BmOTPVYsdWkvIsVnmuA1++RIatG5sW
         jmK+XrgEzSUgSsjPsQNhzRd0JV0krXpBl1yReH7+S3rzheK6HHVK2zqBaJ3kgsWlOveF
         XuYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773084475; x=1773689275;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+5+N+QS7JaZPLj+uCtT6Y1yacnGRCT6luuIZGAnMNOM=;
        b=dNlnm9lpGLma7VTUo0wKbpsYJQ9q8HUWZ5dkp1AlOTzLuirwoua6a4aGwDj+k/iZuY
         NdO2de7sKs39HrUYB5RN/RBD8zETRgqukBtoYgcZfIOupotNZsBETTyn1vL3ypZUp5pR
         uPcRI2q7BQlUVzzgyS8v6cQzTqRsNyMJ7IEgDdsqTxEXqYBs6vWh5PlOCz0uHsWDWPE9
         9PdUSVVIT4tWSP0JGVK2Gv6yvKoxKa0HTs3zvu0p98U/HNDLSHII7PI96u1IqFjb5tLc
         FVUCqR+5sqeaESBt1nQ+v1lc2bM9AvAKBSpL5P/8/7k724LJ5+ChIAklsqVebDquZdkU
         eNGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeGBVw+TlhzpqukrCagZKUVjO7hedFYMZDGybhUeVNc0B8V8geQKXTFRsKHBik7Sj0xlo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxSkzRa26a8jeemqmMn+sZrUE7XBmMoSieg8QLD009KDkSV4FR
	yYRGrOrImQd5/O8ts7QZWPOwe9HCMJEQPcctyaiLc13i2F9cL8xRd4yvymwNELR8Bg==
X-Gm-Gg: ATEYQzwO+32a04gZCxc7W61um+ngU1HD3HeAQBPQ1A/PSI6oPeGIxK/Ip8e42ZlCd+1
	bZVLz3fLZBOygu0BYWcOxwzuejyXB8a+Wi1qZq4ch4QOPKmJ2EfJcQy7eD2HFMSasMYMdHgRh+d
	gkXYui7W8rnBIGT3Y3fgIDYm8ePK2bYBBGfE6Ja1CAx9rr6UTHxomY8F4CUGcfQ1aLF3K+hJJv2
	mVuE2K5ulNJQLCqpLXRdu3wMJOMNKRHWkgp4+Inruzt+gyCf+h5jAbpDkvZHDq0BttmL45jDG/V
	NZgZY3ZujKh2SLVLK5GU071ummevNX5Hlzn8/+4CUeKM5IkJwdbVFi5unuIVEVv/OJcONbGT/wY
	07aai++3DP1dWhegOjSu+dvS4Onr2666/ozo1XTQV1VyRfUwYJn7TIG/FwGd8KTvdXATZG/z4nB
	GBUWDXbdWE8JT2oxe9uuwl60h2MKumqaw7e+I2hWXoqN3iZ/uGvVixay+S8Fy5I8aigiOeaxh0
X-Received: by 2002:a17:902:ce0c:b0:2a7:87c2:fcde with SMTP id d9443c01a7336-2aea3258530mr529395ad.15.1773084474262;
        Mon, 09 Mar 2026 12:27:54 -0700 (PDT)
Received: from google.com (154.52.125.34.bc.googleusercontent.com. [34.125.52.154])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e16cebbsm9655626a12.16.2026.03.09.12.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 12:27:53 -0700 (PDT)
Date: Mon, 9 Mar 2026 19:27:49 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sean Christopherson <seanjc@google.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
	Will McVicker <willmcvicker@google.com>
Subject: Re: [PATCH v4 09/17] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
Message-ID: <aa8fNT3P54t5W53T@google.com>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-10-seanjc@google.com>
 <YfrQzoIWyv9lNljh@google.com>
 <CABCJKufg=ONNOvF8+BRXfLoTUfeiZZsdd8TnpV-GaNK_o-HuaA@mail.gmail.com>
 <202202061011.A255DE55B@keescook>
 <YgAvhG4wvnslbTqP@hirez.programming.kicks-ass.net>
 <202202061854.B5B11282@keescook>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202202061854.B5B11282@keescook>
X-Rspamd-Queue-Id: 56C85240072
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73355-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[cmllamas@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Sun, Feb 06, 2022 at 06:55:56PM -0800, Kees Cook wrote:
> On Sun, Feb 06, 2022 at 09:28:52PM +0100, Peter Zijlstra wrote:
> > On Sun, Feb 06, 2022 at 10:45:15AM -0800, Kees Cook wrote:
> > 
> > > I'm digging through the macros to sort this out, but IIUC, an example of
> > > the problem is:
> > > 
> > 
> > > so the caller is expecting "unsigned int (*)(void)" but the prototype
> > > of __static_call_return0 is "long (*)(void)":
> > > 
> > > long __static_call_return0(void);
> > > 
> > > Could we simply declare a type-matched ret0 trampoline too?
> > 
> > That'll work for this case, but the next case the function will have
> > arguments we'll need even more nonsense...
> 
> Shouldn't the typeof() work there too, though? I.e. as long as the
> return value can hold a "0", it'd work.

I gave this a shot but then hit a wall with the arguments indeed:

typedef int (perf_snapshot_branch_stack_t)(struct perf_branch_entry *entries,
					   unsigned int cnt);
[...]
DEFINE_STATIC_CALL_RET0(perf_snapshot_branch_stack, perf_snapshot_branch_stack_t);

I can generate a stub with the matching return type using typeof() but
the arguments have to be fixed e.g. to (void):

#define DEFINE_STATIC_CALL_RET0(name, _func)				\
	static inline typeof(((typeof(_func)*)0)())			\
		__static_call_ret0_##name(void) { return 0; }		\
	__DEFINE_STATIC_CALL(name, _func, __static_call_ret0_##name)

I believe this would work for most perf callbacks cases except the one
above because the arguments would generate a different hash for CFI.

> 
> > And as stated in that other email, there's tb_stub_func() having the
> > exact same problem as well.
> 
> Yeah, I'd need to go look at that again.

Is this testing for "_func == __static_call_return0" in static_call()?
Ok, but I don't understand how to handle the arguments here either.
The call sites do "static_call(name)(...)", and I don't see a way to
handle this using macro magic.

> 
> > The x86_64 CFI patches had a work-around for this, that could trivially
> > be lifted I suppose.
> 
> Yeah, I think it'd be similar. I haven't had a chance to go look at that
> again...
> 

What is this work-around for x86?

Downstream I had to resolve this my providing individual stubs for each
DEFINE_STATIC_CALL_RET0() :( If you care to see my hack:
https://android-review.googlesource.com/c/kernel/common/+/3980171

I don't have a clue on how to fix this properly though. Any ideas?

--
Carlos Llamas

