Return-Path: <kvm+bounces-60867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BD05EBFE960
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 01:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 69F9C35756C
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 23:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C23D30ACEA;
	Wed, 22 Oct 2025 23:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="StTRIB3i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B29B309DAF
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 23:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761175854; cv=none; b=KMdOt3fCms9jyZfqmorayS79U/AZCbwFjNFAoQBsn5kctRASb9WPtbFqTPg9Aedcmyqhq8koo91hoLwrVnEsXdv3M7xtvmrwG2ve3/KRwI7lo4DWUZJBDBN0enhdCEMfKY4gK/YhW3qj3cW+5nnJ5L5UUSt3EChY662UfWGfAlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761175854; c=relaxed/simple;
	bh=FJ5dPWeuTDRG2VX7FLyUJF0mD0hnFePTCkWS6C5Q3EA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JdXv3tVDicZ5RL/UqQ0UjZdNEFomY5SlC/cAOkdzVEhbnkV9ZmA5Cr9W8rYMoPfRzpoIeZSsh8laIB04lzhD1cPpnmr9IjcFJOUJyfcBUKNsO6a79wGxFGHSkjWY12WxVBbdeHeaTZ5r2pQDxcfAel2s3Sgn0xIYARghQEuy9qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=StTRIB3i; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6cf40b2c2bso311768a12.0
        for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 16:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761175851; x=1761780651; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3jEiO6iBxzy6fxnsgwrsRYGtWZsrwu6A5X9ZJxUc05s=;
        b=StTRIB3ia4VotH0oNfRldoeYZy7DFSoBOunCAH3g3FV7Z3yvRspTKvfuj7IksqTWM0
         R0IGmqesgalhEVemC6wY0/JcqcHSCrVBcdV27rgotEr/LL5jPQmnubqvILp06jqVzMkP
         P+aBREszcp1bnHDr7+/rtkyO1qHtbSDdJ9O4+d5lvjOF/AoISE8PaTDxYhB+A1t2XLqa
         hsUhjohqIeoIO4W2CenPOOkeusZFMnDYxB/RCpKwCXevQ1om0P+6YrwQBuJFqIwZZ6Ze
         RavicgAg0YBneomDyrLWdIZZFVDGKwPcbwbJ1IzZBqTsOOPFnRTm6e3kui9aNwTZ6Sct
         Sqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175851; x=1761780651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jEiO6iBxzy6fxnsgwrsRYGtWZsrwu6A5X9ZJxUc05s=;
        b=oe46Ya2ZNYbATXbccYEvqibZzI7jaZEWbRAzuhFHId4EkRM+Ad+SLzCHXcFxDlC7iP
         pbtK+hSdnbAkylds9e//j9zkCs6jC78X33vDlG/4KlYH8CTO33mehPgDBoQJ7i2KbLIL
         b2jkUmDBVSmoSvtqJxBnIJBQfN2uuHOCTCR3Ev6/X9dVAYrkWMumK9ftDKLWnJjrlGLa
         o2vDKyZ6Vu4iCRv1gMvzEDp86DcIcn1EqbC9npmT1Th78hSOoThb0rzYU6LZPpB3FUn4
         cCAJtQ1asG0uqmxKL/rlu3l9QtviqkKRtzlBqlY5ze4dyI0TSrBLUo2aRU2G+YhFPyWE
         ZZww==
X-Forwarded-Encrypted: i=1; AJvYcCWuYqxJCb/OzHHHOx6nm3TY7GV+u+1WUuDoFMw2f4CaVbm5TstOaTBo358otl4qX8mj0Kw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg6c2dlntg0JaYsuVZVtAojieqq6qD+O12LHEyXJxlFU2uT9lM
	A9EQeVy/uLXfq1P9aSO9taG9ZkWn7JeucATHlXDTz9qgWn1gixPmlEhp7VGFSfBlWAjic45gtUw
	+JabGeg==
X-Google-Smtp-Source: AGHT+IFg265zLGl2bQmWCvkKPU4u2q3qfh913c9juw3tQPbolW7ChzJ4nSIfXk8wuAQ4jQwhmqRekZFnQlI=
X-Received: from pjnj13.prod.google.com ([2002:a17:90a:840d:b0:329:7261:93b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d84:b0:2f9:39b0:fd88
 with SMTP id adf61e73a8af0-334a84da4b1mr29081038637.21.1761175851395; Wed, 22
 Oct 2025 16:30:51 -0700 (PDT)
Date: Wed, 22 Oct 2025 16:30:49 -0700
In-Reply-To: <diqzy0p2eet3.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com> <diqzy0p2eet3.fsf@google.com>
Message-ID: <aPlpKbHGea90IebS@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Steven Price <steven.price@arm.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org, 
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, 
	shakeel.butt@linux.dev, shuah@kernel.org, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 22, 2025, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> 
> Found another issue with KVM_CAP_MEMORY_ATTRIBUTES2.
> 
> KVM_CAP_MEMORY_ATTRIBUTES2 was defined to do the same thing as
> KVM_CAP_MEMORY_ATTRIBUTES, but that's wrong since
> KVM_CAP_MEMORY_ATTRIBUTES2 should indicate the presence of
> KVM_SET_MEMORY_ATTRIBUTES2 and struct kvm_memory_attributes2.

No?  If no attributes are supported, whether or not KVM_SET_MEMORY_ATTRIBUTES2
exists is largely irrelevant.  We can even provide the same -ENOTTY errno by
checking that _any_ attributes are supported, i.e. so that doing
KVM_SET_MEMORY_ATTRIBUTES2 on KVM without any support whatsoever fails in the
same way that KVM with code support but no attributes fails.

In other words, I don't see why it can't do both.  Even if we can't massage the
right errno, I would much rather KVM_SET_MEMORY_ATTRIBUTES2 enumerate the set of
supported attributes than simply '1'.  E.g. we have no plans to support
KVM_SET_MEMORY_ATTRIBUTES on guest_memfd, and so returning simply '1' creates an
unwanted and unnecessary dependency.

> @@ -1617,4 +1618,15 @@ struct kvm_pre_fault_memory {
>  	__u64 padding[5];
>  };
>  
> +/* Available with KVM_CAP_MEMORY_ATTRIBUTES2 */
> +#define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd6, struct kvm_memory_attributes2)

Please use the same literal number, 0xd2, as

  #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)

The "final" ioctl number that userspace sees incorporates the directionality and
the size of the struct, i.e. KVM_SET_MEMORY_ATTRIBUTES and KVM_SET_MEMORY_ATTRIBUTES2
are guaranteed to be distinct even if they both use 0xd2 as the "minor" number.

> +
> +struct kvm_memory_attributes2 {
> +	__u64 address;
> +	__u64 size;
> +	__u64 attributes;
> +	__u64 flags;
> +	__u64 reserved[4];

Maybe be paranoid and reserve 12 u64s?

