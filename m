Return-Path: <kvm+bounces-23177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D693946F08
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 15:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE5F41F214D7
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 13:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA4850288;
	Sun,  4 Aug 2024 13:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6qzwBYw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353944C627
	for <kvm@vger.kernel.org>; Sun,  4 Aug 2024 13:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722778289; cv=none; b=a3XHFVsZhMNAIdRUeaj93XrTmbMUKmqMuvdC7XybLCByGah+HRkkdOzkJrg1jpCE+pxDPkNBwpC+01uECfkdIvmuXgXfvch0XNi0jBaG0OxeBiRA47IoYAqShcnts877+orhFJT/7rkQvO8SmOpZIUsFiFVqjkvdWS658XJfF3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722778289; c=relaxed/simple;
	bh=ZLsnBiPBDSFELEP21k+1SkCoQQia6Oe5iaeVaXpj9D0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N0H8QIFT+T2E62FnvM6nFobJj+rUAY+zG0zkfyZM7F+yQzaAvkIWJ4XJz4HLh8bSPsgf4+88inqnH2Bs9Gu4CP95NuXmGsxUA6l+/F78OZDQeLtjJDpehS5ZYei8CTr2e3lM5FgCXzJuzrVTyVm/NWD/6RSkcdMFoEUZxfXpM84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6qzwBYw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722778285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yzljz7zFdusmtedzaMMn1iGtnMQpOk40I0Wp+DiG0Yg=;
	b=f6qzwBYw6XBELKJFozN7bLseuKWfJRc/8WFU2k667K6WaeXvc1xHUdTAnacDXDLnD0zaC1
	l4ZkbDzfnixPP4P5u3Ht9kU1ZsqjSCOaX+AO06pVeja9fwWpNKg7AfTCusbbGuUF79jvwD
	WsKNMGA1NR8wb/OCIkohmY4HrGoR2Rg=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-feQzHXUaO4yyxUoAB7Kffg-1; Sun, 04 Aug 2024 09:31:23 -0400
X-MC-Unique: feQzHXUaO4yyxUoAB7Kffg-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7093752a9f5so2151037a34.1
        for <kvm@vger.kernel.org>; Sun, 04 Aug 2024 06:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722778283; x=1723383083;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yzljz7zFdusmtedzaMMn1iGtnMQpOk40I0Wp+DiG0Yg=;
        b=D4j0oK8lOz5Jyneb0XOOaeFJJO062+SA35ZCLSxiOICZcDoA05hOAWiI5HrYMz3X2T
         tXuj/JEcH0RXE9dXW3xVEH/GHOpjUG6wn4KsrbnebzTlxkIim6xSbWEee2Y6F2bL85Up
         4/hDXDels728xK/E/++dqJpN7X60GeYmY06C/o7VVEtdoV646OtfRsl4MIUouxcdosai
         GU6uMNnCqp/fO01UWJl2eBdWhDmrzA3ypl/kZkdiaVgxnq8aJ0WhonidKlQvBOYZ8hm+
         1F/sWSfKJrfwQHVVsZuFgd23B9E8G4i04RRCuZ6m8eNKw9Z2Pr0T6mK41QdnpWYWZOqT
         yoNg==
X-Forwarded-Encrypted: i=1; AJvYcCUroM8Jixu32L5AldWHowDhdFjjDOEWBaYNCVOVW9Y6PVEPbRQHHUYmolRrtfwu+8GAk/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxypT3XZd9S6hPlHZ5Dx1XFtmFdMv+Sdbm+AYqaCZw8rQYDr/w9
	CDoeVkrYz9d+ox3Ji25hxSkdurUw/t55VwLFTisENdWrA02zhn3IlsNvJDKn9ywTIVuV//0S+Tw
	L1db0Fx0Xuldih0VIp9sKUriBpO2j43UyfC1qOy0QQ1JCS+BBKQ==
X-Received: by 2002:a05:6830:6582:b0:703:5c2d:6d30 with SMTP id 46e09a7af769-7099ea3ad03mr5182828a34.0.1722778282822;
        Sun, 04 Aug 2024 06:31:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVAwWmeGFfzpNaruJ0rX+cQMbAUjtorFb8Y7NaDBarrl/5zMYsYzeHsuxBnCiAgdVn3xEpXw==
X-Received: by 2002:a05:6830:6582:b0:703:5c2d:6d30 with SMTP id 46e09a7af769-7099ea3ad03mr5182813a34.0.1722778282444;
        Sun, 04 Aug 2024 06:31:22 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a34f6fbc40sm255563085a.58.2024.08.04.06.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Aug 2024 06:31:21 -0700 (PDT)
Date: Sun, 4 Aug 2024 09:31:19 -0400
From: Peter Xu <peterx@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Carsten Stollmaier <stollmc@amazon.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, nh-open-source@amazon.com,
	Sebastian Biemueller <sbiemue@amazon.de>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] KVM: x86: Use gfn_to_pfn_cache for steal_time
Message-ID: <Zq-Cp1LzimPYZ8E7@x1n>
References: <20240802114402.96669-1-stollmc@amazon.com>
 <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>
 <Zq1gavwLBHeSr2ju@x1n>
 <ae8412474f793ff59d5567bc721dc012d6ee0199.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae8412474f793ff59d5567bc721dc012d6ee0199.camel@infradead.org>

On Sat, Aug 03, 2024 at 09:35:56AM +0100, David Woodhouse wrote:
> On Fri, 2024-08-02 at 18:40 -0400, Peter Xu wrote:
> > On Fri, Aug 02, 2024 at 01:03:16PM +0100, David Woodhouse wrote:
> > > An alternative workaround (which perhaps we should *also* consider)
> > > looked like this (plus some suitable code comment, of course):
> > > 
> > > --- a/arch/x86/mm/fault.c
> > > +++ b/arch/x86/mm/fault.c
> > > @@ -1304,6 +1304,8 @@ void do_user_addr_fault(struct pt_regs *regs,
> > >          */
> > >         if (user_mode(regs))
> > >                 flags |= FAULT_FLAG_USER;
> > > +       else
> > > +               flags &= ~FAULT_FLAG_INTERRUPTIBLE;
> > >  
> ...
> > Instead of "interruptible exception" or the original patch (which might
> > still be worthwhile, though?  I didn't follow much on kvm and the new gpc
> > cache, but looks still nicer than get/put user from initial glance), above
> 
> Yes, I definitely think we want the GPC conversion anyway. That's why I
> suggested it to Carsten, to resolve our *immediate* problem while we
> continue to ponder the general case.
> 
> > looks like the easier and complete solution to me.  For "completeness", I
> > mean I am not sure how many other copy_to/from_user() code in kvm can hit
> > this, so looks like still possible to hit outside steal time page?
> 
> Right. It theoretically applies to *any* user access. It's just that
> anything other than *guest* pages is slightly less likely to be backed
> by userfaultfd.
> 
> > I thought only the slow fault path was involved in INTERRUPTIBLE thing and
> > that was the plan, but I guess I overlooked how the default value could
> > affect copy to/from user invoked from KVM as well..
> > 
> > With above patch to drop FAULT_FLAG_INTERRUPTIBLE for !user, KVM can still
> > opt-in INTERRUPTIBLE anywhere by leveraging hva_to_pfn[_slow]() API, which
> > is "INTERRUPTIBLE"-ready with a boolean the caller can set. But the caller
> > will need to be able to process KVM_PFN_ERR_SIGPENDING.
> 
> Right. I think converting kvm_{read,write}_guest() and friends to do
> that and be interruptible might make sense?

Makes sense to me. It's just that there seem to be a lot of the contexts
that using this, so I'm not sure how much work needed to integrate the new
KVM_PFN_ERR_SIGPENDING, and whether it'll be worthwhile.  Also, not sure
whether some context that can be too involved to only handle sigkill/quit.

And this can also, logically, trigger with kvm_{read,write}_guest() or
similar path already, right?  I wonder why it can so far only trigger with
steal time; I probably missed something.

> 
> The patch snippet above obviously only fixes it for x86 and would need
> to be done across the board. Unless we do this one instead, abusing the
> knowledge that uffd is the only thing which honours
> FAULT_FLAG_INTERRUPTIBLE?
> 
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -351,7 +351,7 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
>  
>  static inline unsigned int userfaultfd_get_blocking_state(unsigned int flags)
>  {
> -       if (flags & FAULT_FLAG_INTERRUPTIBLE)
> +       if ((flags & FAULT_FLAG_INTERRUPTIBLE) && (flags & FAULT_FLAG_USER))
>                 return TASK_INTERRUPTIBLE;
>  
>         if (flags & FAULT_FLAG_KILLABLE)

This smells hacky to me, as FAULT_FLAG_INTERRUPTIBLE is a fault API that
the fault handler says "let's respond to non-fatal signals".  It means here
userfault is violating the ABI..

And, IIUC this concept of "handling non-fatal signal" can apply outside
userfaultfd too. The one in my mind is __folio_lock_or_retry().

The previous change looks more reasonable, as I think it's a bug that in
do_user_addr_fault() (just take x86 as example) it specifies the
INTERRUPTIBLE but later after handle_mm_fault() it ignored it in
fault_signal_pending() for !user.

So it makes sense to me to have FAULT_FLAG_DEFAULT matching what
fault_signal_pending() does. From that POV perhaps if FAULT_FLAG_DEFAULT
can take "user" as input would be even cleaner (instead of clearing it
later).

> 
> I still quite like the idea of *optional* interruptible exceptions, as
> seen in my proof of concept. Perhaps we wouldn't want the read(2) and
> write(2) system calls to use them, but there are plenty of other system
> calls which could be interruptible instead of blocking.

I don't have enough much direct experience there, but it sounds reasonable
to me.

> 
> Right now, even the simple case of a trivial SIGINT handler which does
> some minor cleanup before exiting, makes it a non-fatal signal so the
> kernel blocks and waits for ever.
> 

Thanks,

-- 
Peter Xu


