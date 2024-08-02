Return-Path: <kvm+bounces-23159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B9E9465EA
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2024 00:41:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 211C21F22BBE
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 22:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC3213AA47;
	Fri,  2 Aug 2024 22:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C5hSFL3U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B43A56446
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 22:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722638451; cv=none; b=AZYoUGV4fWJ2DHFC5FNCoRFkWROqcnlDAl4X17h4hTciJmGGYt83z/vJIohz3arW2iKRYzUvReLh9ABY+J0ZMVA5cpVOUPUoBNwYDkrdGNjkP67YBZsFK1b20gtMXwhIXtfORf51s7/R02HFcjnn1MLTlnlzo/08r2L/A0ueZqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722638451; c=relaxed/simple;
	bh=2Ox92wS/j6LT6RW2Owt087/gAztSsKgOWN6KoTSnzI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H87iS+TUj87Vm71GmljUduhvuF6JAbFyQWvgVN3a8PYjENUUHNF9n79sUZqgeFBe77J5s5PPcgmM5aOV0w+TsD7BQ8jykz5dCN1q6wNWlqqU9C74gCZ3jEDYEUpmJ+aymSK1gzoA/EfObLqxsdxXClQDdmmhrHBOYS3iooz2c3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C5hSFL3U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722638447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UIQ24+48TE0Ta9LNm8rRrMJXnuaT0qzUCWhnHkojtRo=;
	b=C5hSFL3UBYsGPDVqyTmba/8c/CqjFUOS4CmD/mWs5YP5mL2Qjcw+urMQmCL3jgFSdDGGKS
	So9nqwpc5MLZb7gXeufCdQLSZDIVa0aau6sEsUXbfHg6DOdgJWTelOLKS2ecmDw10TOxo2
	Mt1F5EPFndv4uRzxV5O2RCS16o4EqSc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-hfLHcd5UPPmD4prrz9cHDw-1; Fri, 02 Aug 2024 18:40:46 -0400
X-MC-Unique: hfLHcd5UPPmD4prrz9cHDw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6bba0f9d3efso1938616d6.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 15:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722638446; x=1723243246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIQ24+48TE0Ta9LNm8rRrMJXnuaT0qzUCWhnHkojtRo=;
        b=A5G8KvHR7Pj/4AQBB4k+3dZf7Al8bhWGoBTz8rkjIfv8eY8jn7kvzy6YV78Es8NGRW
         2AZCtml4kwbgAXtTLncM/AG34OVygXYOIDlsaEIcTmTfN/Zpuo58fm/bOaCWqZTEyOpO
         Mc2X7lLjHIlOHfcq3kzRJ9hKdUlD1tBEKrkI7NCV2OvCu/X7rNgp4wX2+NgeZpbGOxEt
         N9ot768+jfO1fd8e29HHT2J/79b8hq08Bflexq3Qfe+P+L1fXGXvfrVTk/EM2SoNp9ym
         RImJeFY1jpQ7cr2MIw3O1RxNroPIQFbjzPYB87BNdfpmxDbj8rJpmQja3Dr90fkBYLta
         SIMA==
X-Forwarded-Encrypted: i=1; AJvYcCVDXgwA204H7k3lQhd2n3asnI72vYuF93L6tCw9GYGbp/4lEJdmkFNU8U+Y51N87SKt8w8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeGui/hP4sTwzrxp1j+kXbSjAGLFyjR9X03U0n489svKMCSB24
	ts7oOJe3O8VaiwvdLzH8LL/jhS53mZq5mUAN9ZJGHx82kypskvs7/VPMI1nZG6mEyHbJemLuact
	MOzPdGftH8UPc6zUEHKKDOECZcJsnReyJKCeh+XZ7JeRMhAU4vw==
X-Received: by 2002:a05:6214:3008:b0:6b7:885c:b750 with SMTP id 6a1803df08f44-6bb9832e268mr35451826d6.1.1722638445948;
        Fri, 02 Aug 2024 15:40:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGuQ/TysjxPmr8e9IL8H+rnOjczzC8Pn9LtVkMqryMZ3GwIYnbZ1EzE5cR19PNfrempSFmMA==
X-Received: by 2002:a05:6214:3008:b0:6b7:885c:b750 with SMTP id 6a1803df08f44-6bb9832e268mr35451646d6.1.1722638445539;
        Fri, 02 Aug 2024 15:40:45 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c86baa8sm10847796d6.118.2024.08.02.15.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 15:40:45 -0700 (PDT)
Date: Fri, 2 Aug 2024 18:40:42 -0400
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
Message-ID: <Zq1gavwLBHeSr2ju@x1n>
References: <20240802114402.96669-1-stollmc@amazon.com>
 <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b40f244f50ce3a14d637fd1769a9b3f709b0842e.camel@infradead.org>

On Fri, Aug 02, 2024 at 01:03:16PM +0100, David Woodhouse wrote:
> On Fri, 2024-08-02 at 11:44 +0000, Carsten Stollmaier wrote:
> > On vcpu_run, before entering the guest, the update of the steal time
> > information causes a page-fault if the page is not present. In our
> > scenario, this gets handled by do_user_addr_fault and successively
> > handle_userfault since we have the region registered to that.
> > 
> > handle_userfault uses TASK_INTERRUPTIBLE, so it is interruptible by
> > signals. do_user_addr_fault then busy-retries it if the pending signal
> > is non-fatal. This leads to contention of the mmap_lock.
> 
> The busy-loop causes so much contention on mmap_lock that post-copy
> live migration fails to make progress, and is leading to failures. Yes?
> 
> > This patch replaces the use of gfn_to_hva_cache with gfn_to_pfn_cache,
> > as gfn_to_pfn_cache ensures page presence for the memory access,
> > preventing the contention of the mmap_lock.
> > 
> > Signed-off-by: Carsten Stollmaier <stollmc@amazon.com>
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> 
> I think this makes sense on its own, as it addresses the specific case
> where KVM is *likely* to be touching a userfaulted (guest) page. And it
> allows us to ditch yet another explicit asm exception handler.
> 
> We should note, though, that in terms of the original problem described
> above, it's a bit of a workaround. It just means that by using
> kvm_gpc_refresh() to obtain the user page, we end up in
> handle_userfault() without the FAULT_FLAG_INTERRUPTIBLE flag.
> 
> (Note to self: should kvm_gpc_refresh() take fault flags, to allow
> interruptible and killable modes to be selected by its caller?)
> 
> 
> An alternative workaround (which perhaps we should *also* consider)
> looked like this (plus some suitable code comment, of course):
> 
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1304,6 +1304,8 @@ void do_user_addr_fault(struct pt_regs *regs,
>          */
>         if (user_mode(regs))
>                 flags |= FAULT_FLAG_USER;
> +       else
> +               flags &= ~FAULT_FLAG_INTERRUPTIBLE;
>  
>  #ifdef CONFIG_X86_64
>         /*
> 
> 
> That would *also* handle arbitrary copy_to_user/copy_from_user() to
> userfault pages, which could theoretically hit the same busy loop.
> 
> I'm actually tempted to make user access *interruptible* though, and
> either add copy_{from,to}_user_interruptible() or change the semantics
> of the existing ones (which I believe are already killable).
> 
> That would require each architecture implementing interruptible
> exceptions, by doing an extable lookup before the retry. Not overly
> complex, but needs to be done for all architectures (although not at
> once; we could live with not-yet-done architectures just remaining
> killable).
> 
> Thoughts?

Instead of "interruptible exception" or the original patch (which might
still be worthwhile, though?  I didn't follow much on kvm and the new gpc
cache, but looks still nicer than get/put user from initial glance), above
looks like the easier and complete solution to me.  For "completeness", I
mean I am not sure how many other copy_to/from_user() code in kvm can hit
this, so looks like still possible to hit outside steal time page?

I thought only the slow fault path was involved in INTERRUPTIBLE thing and
that was the plan, but I guess I overlooked how the default value could
affect copy to/from user invoked from KVM as well..

With above patch to drop FAULT_FLAG_INTERRUPTIBLE for !user, KVM can still
opt-in INTERRUPTIBLE anywhere by leveraging hva_to_pfn[_slow]() API, which
is "INTERRUPTIBLE"-ready with a boolean the caller can set. But the caller
will need to be able to process KVM_PFN_ERR_SIGPENDING.

Thanks,

-- 
Peter Xu


