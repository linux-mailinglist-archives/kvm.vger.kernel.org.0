Return-Path: <kvm+bounces-37958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A49AA3220B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 10:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B494D7A3DE6
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 09:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B302063C6;
	Wed, 12 Feb 2025 09:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oa7sql/i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5309205E31
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 09:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739352274; cv=none; b=EUurnWoteoddchY6OdMUD45FfPynfqp9RuUSKQabk3VW/cpCX/KCdFdtRSBYFox9HvaJg9wsY8YiaGTlB7keyXZRs4qlZuBgerw15YAvb0fSNfS9lC9nmm7FXDSAeINapTzH6mdbCOZFW0S7p/9cSxdn9s4yrH7bkZTo2OdQ+tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739352274; c=relaxed/simple;
	bh=wgrVFTFnOMl1lbhU6THPXTQUTlt6qpr2q1PW7QzymIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jLmTurtnjxu4g2E0zCA7E0HsDO0rFtAE1ayI/+mtAt/jyZvLtSFD6xEOZwPj7xZuuLGLZZnXGEfQI2ZZNQ8LV0hYcHDob/JrE/9oIdJiNUEaWwezsSDg+PcyalHi9hpeU52dgK4jRXh/GtU0MAJobuhtRfhjZC8o/xq9XtSypZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oa7sql/i; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4718aea0718so253111cf.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 01:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739352271; x=1739957071; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ygZ+ykZUGXo+ghQO8/iDuCOuoQ9uPQROyXsAFRhKFU0=;
        b=oa7sql/iHWc+kv2P2lnVF+Vjn3qk2NRuVNgBRhi0ixk2AE5v2264HIwl68dtjk5sJY
         bgfHorHXCQztfbVAvQWXzEtpJflYX4XB7Ara5sdXeuhac3ZrjpPY+6JVzZrVs0adjpMW
         i6k7Tj7bqp3z/fRegAN49HCMQVHyjn7GrYz6AUhK33R+QHl5laGrb8fsLRORzpMNJgDS
         I5uu1LPg3uFTbfvjYEeN30VHi+25XB8ib61jPO/MtfjSorunK3x0xTLn0DxiFmjZxaL3
         8kLNkN5TcIp4zNaHKy3MbbERQT97YZjXM/3chS382ilDJMC1B2d/rxsxTY+0t4H1aAzn
         sO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739352271; x=1739957071;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ygZ+ykZUGXo+ghQO8/iDuCOuoQ9uPQROyXsAFRhKFU0=;
        b=jO/OYozqlN88WzB6nl7VMqQdx/yqAxtUO20PJFjkSHYFxiaiqsHmu7V+KHL6folavx
         Ueh6SkAeMoe/vjkrWj+Z8k22oWoyMFhq3CuSOt06D7XZUu8j+aHT9v+I3A82G6WjctJP
         pseZjHO1qUrq90FkfoDpac06RPy/IXwA/7/pG+2QumirsCYMoKUHm1AoX9Loo/bFq5fe
         DSODywrtYUqnKybnnyXWKWqI8btgnkC3W0R+elAOrGXZAKdQbkL8Duwf5MBz6pDHpS8G
         QbFfw25op1z4G/qXVmTE4qj5XqGwyk8tgr1XaYJ5R0jADUBmxpXCoakVnBbwpCAcrjCf
         Ha1A==
X-Gm-Message-State: AOJu0Yz0zUqF4DH+IRZ//xEsYbvIpbLDmMAN2f0AAlyb3DEUcnmaa3c+
	GpgQqgNO6YgfGXtjEEjtYDkF8+mix8AAo0/xslOxciJzUNTPkV2JjHZWbhXWlguDlgJj0C+cvtI
	u7aCym8Kb37dN6ZlvE7kOPbBVGIuGal43CWUf
X-Gm-Gg: ASbGncuKE2FCGOtP82YRlFBQcwglmRvaaD1BcptcLck5zG8h3AJkdumd6U6Dz6dbg22
	JJr4nbRTeCYxYAch062tHIN2AzPoeinYltqNmRGY1RY4tF8HmvjiS2oDEId5ik07FevYR1na3W6
	SI3S1hVZmMC1A5TEY9dZqUc8mvmg==
X-Google-Smtp-Source: AGHT+IH0MGBH1wbXmpKqOTa38xCr+F5lULEXEpEmWTgKUlomn2kZYLWxS8V6z3W5XVKksUIXSMwWGhpoTDuH2GiN2j8=
X-Received: by 2002:a05:622a:4893:b0:46c:78e4:a9cc with SMTP id
 d75a77b69052e-471b1e3ee78mr2602041cf.25.1739352271281; Wed, 12 Feb 2025
 01:24:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-6-tabba@google.com> <diqzh65081cc.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzh65081cc.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 12 Feb 2025 09:23:54 +0000
X-Gm-Features: AWEUYZmGdlfRAPQIp-gV7T21UQk0_Xr9eEyUSfbJ4EqrwW15zpIk1JjIyMqdHd4
Message-ID: <CA+EHjTyGhHdDsH=U9QUni3vrbF+-bxXVX30QFBumk6-19UtaLA@mail.gmail.com>
Subject: Re: [PATCH v3 05/11] KVM: guest_memfd: Handle in-place shared memory
 as guest_memfd backed memory
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Wed, 12 Feb 2025 at 00:15, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > For VMs that allow sharing guest_memfd backed memory in-place,
> > handle that memory the same as "private" guest_memfd memory. This
> > means that faulting that memory in the host or in the guest will
> > go through the guest_memfd subsystem.
> >
> > Note that the word "private" in the name of the function
> > kvm_mem_is_private() doesn't necessarily indicate that the memory
> > isn't shared, but is due to the history and evolution of
> > guest_memfd and the various names it has received. In effect,
> > this function is used to multiplex between the path of a normal
> > page fault and the path of a guest_memfd backed page fault.
> >
>
> Thanks for this summary! It has always been confusing and this really
> helps.
>
> Is there any chance we could rename the functions in KVM, or maybe add a
> comment at the function definitions? The name of the userspace flag will
> have to remain, of course.

Actually, I was thinking of doing that in V4. Rename, or at least add
an alias, as a separate patch, to see what the community thinks.
Since, even with this comment, it is still confusing (as
evidenced by Quentin's comment on the later patch).

Cheers,
/fuad


> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  include/linux/kvm_host.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 438aa3df3175..39fd6e35c723 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  #else
> >  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  {
> > -     return false;
> > +     return kvm_arch_gmem_supports_shared_mem(kvm) &&
> > +            kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
> >  }
> >  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */

