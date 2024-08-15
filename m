Return-Path: <kvm+bounces-24333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02277953DEA
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 01:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 775411F26541
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 23:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C11155C98;
	Thu, 15 Aug 2024 23:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eqrYtWgA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30C91AC897;
	Thu, 15 Aug 2024 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723764685; cv=none; b=DIKn/oz3gm7Pto5hrCpFTqfPhufcRCC3MQs0jWt23G7Nou6v9sZVNP9s1dku+C65A7VdGlzRvc3BCJqg2GQx1xiWDkRFSjHc76iSoBK03DjWtizNahd+EGRSVoD3ZdkLpjMXtkbfbl4m8ufZ9ABTGtvhGWlFH4pI1zPbxd5ZaHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723764685; c=relaxed/simple;
	bh=Q00Wy/EH0Tpo4vlmp+Hm4TrJ3Hq2oPEIBrWzGhTrgug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RkJA5W390ranRyER/54ZtYggJGcebgYDW4kffcKH81sFj7jnBWL+fD7oXCrqXwdzea9TpDcKU1ADiY44JDd4/kJORdl/0iVcX4/6nk3dhqNlSqpfoI6Y/8GJxGaHnYm053m8/+RncZCmzbXkp7ompHVffWBnRYv4Vaq6NtS2wVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eqrYtWgA; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fc65329979so14463795ad.0;
        Thu, 15 Aug 2024 16:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723764683; x=1724369483; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TJUrcjdRDSHYk+JjRgPgoz0uj64QHPtt5Zknd43gI+Q=;
        b=eqrYtWgAxTDdXazmIbsbxd95ylo+IGd4Br6nd3vbWXJmP8J9zAGMr/IWF7jOsD1yL6
         QzDNaa0zd70m1lrFD/5M7pgGe71nS6StMMeik5VC7+FpdZZcH9qPEt4RfgpF83A/mJbg
         NnXczPb54nW7ADu3lWNvFFqFv3cpt+x1ufArdLkrPyN2bQA9FtfGeOG2O6TDEIObGW2K
         P1FGgfsNrz9UePuVy0yzmRqs0PAau3vi13NJ6UR8+hnnDSYJijj8ljNFcJ3EWrKC5vBw
         5VJReTApE+2ob1XJa160nNmNzb2fguARwh6HwJ035KzaiRIfDBZtN/myQMBEWwzxcYMn
         TPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723764683; x=1724369483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJUrcjdRDSHYk+JjRgPgoz0uj64QHPtt5Zknd43gI+Q=;
        b=RhXffbnLvSn/MTzL6+l7K5kwY2UBNCbnE+x3PLP79XCsBIxhtih3hJlNoEWbUTwD5Z
         ix3IEPgjXrTpBi5Azo/OM+QUYbt3Qn6CNFTi5NRQjnxgyt88osPLFIP2CRT7TEv8ICgI
         v41KKUa25ZLRU6jqftTMPZ1xjZ3OwFxaFYFO/F1tQP0ke/uIC4e+SARrR/qX68zFueZJ
         Fm5+2tzqjsMg6HX0ZsvdOGtYAGszAhrPbDavhm/kRUtaxXqUGInbwdHWpHNmHKgE+Ook
         hR5TZy0QMT0wR+ejjA7CnnnghABNNqMH/uwtdBQ4z7ADA00k12Qq7yWdSSHN+7ifC9g7
         ON1g==
X-Forwarded-Encrypted: i=1; AJvYcCX122imbbbqxB+epwZE+Q1HlXXCSo8zExhLOmfXalccnB1gaQGFYQ6IAht/LGl8mnFEsl3ELBKrXYomcjyTKRl4W9VtbUDGJfGl+v5llJDRz1SPDV+uDhu7A/63UU0Sx8KR
X-Gm-Message-State: AOJu0YxiXVJxFZ38SSmRRzBtLg8K338xlLBuS0EtvAOsfYkcZym0SFIU
	vr3KTrEINYNnQsljGYp+/xLqTzxH4ZxRmBSj0+GgwicdJxnXYzIn0WZgdQ==
X-Google-Smtp-Source: AGHT+IF+b039Cjf7T7Bg8XxuJ/M8/eT5IIR2en8CeRs7a7NXKHt8IOo5PeHoGADcAGX+98RuQoCJgQ==
X-Received: by 2002:a17:903:187:b0:1fa:8f64:8b0d with SMTP id d9443c01a7336-20203e4f2b4mr16331995ad.4.1723764682896;
        Thu, 15 Aug 2024 16:31:22 -0700 (PDT)
Received: from localhost (89.208.245.145.16clouds.com. [89.208.245.145])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03a35fcsm15149675ad.256.2024.08.15.16.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 16:31:22 -0700 (PDT)
Date: Fri, 16 Aug 2024 07:31:19 +0800
From: Yao Yuan <yaoyuan0329os@gmail.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Subject: Re: [PATCH 04/22] KVM: x86/mmu: Skip emulation on page fault iff 1+
 SPs were unprotected
Message-ID: <6fsgci4fceoin7fp3ejeulbaybaitx3yo3nylzecanoba5gvhd@3ubrvlykgonn>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-5-seanjc@google.com>
 <20240814142256.7neuthobi7k2ilr6@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814142256.7neuthobi7k2ilr6@yy-desk-7060>

On Wed, Aug 14, 2024 at 10:22:56PM GMT, Yuan Yao wrote:
> On Fri, Aug 09, 2024 at 12:03:01PM -0700, Sean Christopherson wrote:
> > When doing "fast unprotection" of nested TDP page tables, skip emulation
> > if and only if at least one gfn was unprotected, i.e. continue with
> > emulation if simply resuming is likely to hit the same fault and risk
> > putting the vCPU into an infinite loop.
> >
> > Note, it's entirely possible to get a false negative, e.g. if a different
> > vCPU faults on the same gfn and unprotects the gfn first, but that's a
> > relatively rare edge case, and emulating is still functionally ok, i.e.
> > the risk of putting the vCPU isn't an infinite loop isn't justified.
> >
> > Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++++++++--------
> >  1 file changed, 20 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e3aa04c498ea..95058ac4b78c 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5967,17 +5967,29 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  	bool direct = vcpu->arch.mmu->root_role.direct;
> >
> >  	/*
> > -	 * Before emulating the instruction, check if the error code
> > -	 * was due to a RO violation while translating the guest page.
> > -	 * This can occur when using nested virtualization with nested
> > -	 * paging in both guests. If true, we simply unprotect the page
> > -	 * and resume the guest.
> > +	 * Before emulating the instruction, check to see if the access may be
> > +	 * due to L1 accessing nested NPT/EPT entries used for L2, i.e. if the
> > +	 * gfn being written is for gPTEs that KVM is shadowing and has write-
> > +	 * protected.  Because AMD CPUs walk nested page table using a write

Hi Sean,

I Just want to consult how often of this on EPT:

The PFERR_GUEST_PAGE_MASK is set when EPT violation happens
in middle of walking the guest CR3 page table, and the guest
CR3 page table page is write-protected on EPT01, are these
guest CR3 page table pages also are EPT12 page table pages
often?  I just think most of time they should be data page
on guest CR3 table for L1 to access them by L1 GVA, if so
the PFERR_GUEST_FINAL_MASK should be set but not
PFERR_GUEST_PAGE_MASK.

> > +	 * operation, walking NPT entries in L1 can trigger write faults even
> > +	 * when L1 isn't modifying PTEs, and thus result in KVM emulating an
> > +	 * excessive number of L1 instructions without triggering KVM's write-
> > +	 * flooding detection, i.e. without unprotecting the gfn.
> > +	 *
> > +	 * If the error code was due to a RO violation while translating the
> > +	 * guest page, the current MMU is direct (L1 is active), and KVM has
> > +	 * shadow pages, then the above scenario is likely being hit.  Try to
> > +	 * unprotect the gfn, i.e. zap any shadow pages, so that L1 can walk
> > +	 * its NPT entries without triggering emulation.  If one or more shadow
> > +	 * pages was zapped, skip emulation and resume L1 to let it natively
> > +	 * execute the instruction.  If no shadow pages were zapped, then the
> > +	 * write-fault is due to something else entirely, i.e. KVM needs to
> > +	 * emulate, as resuming the guest will put it into an infinite loop.
> >  	 */
>
> Reviewed-by: Yuan Yao <yuan.yao@intel.com>
>
> >  	if (direct &&
> > -	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
> > -		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
> > +	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE &&
> > +	    kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
> >  		return RET_PF_FIXED;
> > -	}
> >
> >  	/*
> >  	 * The gfn is write-protected, but if emulation fails we can still
> > --
> > 2.46.0.76.ge559c4bf1a-goog
> >
> >
>

