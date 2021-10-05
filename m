Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415C2421EAD
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 08:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhJEGHp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 02:07:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhJEGHo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 02:07:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633413954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ugSvl2ghtG9j8DA+VCRDfTfXmeFrwGR1QAB3GpKA0Q=;
        b=JhGVnbW56dz/rx8QJGZjSTEG/fXkmlyvnewLfEqJVSsWTzpWu+7WWDanIGAH1crAwulKKZ
        XyW5z2VYLgxXgdSja77218eWBn1O0J/6ID/Na/Oqvvfy396nCSUPpUnuvg5XwTpjPGv6T6
        ttDRwFdSEI9/ICVuHJgHHwmXQJW993A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-yi3Rtz5WPUWUDtO2Th1Zxg-1; Tue, 05 Oct 2021 02:05:53 -0400
X-MC-Unique: yi3Rtz5WPUWUDtO2Th1Zxg-1
Received: by mail-ed1-f69.google.com with SMTP id r11-20020aa7cfcb000000b003d4fbd652b9so19537251edy.14
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 23:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ugSvl2ghtG9j8DA+VCRDfTfXmeFrwGR1QAB3GpKA0Q=;
        b=iAwZ5iUHNYHVjg5J1qJZzAMzWX7oYrlXlD4DVJXnJyaD3KynHVUcFp8Fey9i8Zgcl4
         Tf3A1UUBlztP/r9Ieic4hyI55BKhJkRagxrhgKue4ygcUd4uoicjHDdZZfrmVgjQlcww
         COUnPgOdmGOddjS75/4blEaUu12PjGWs65sQrUonnmsBt6ooo+MgcfpU0m74HoxGmpj7
         rIxqi4XPXT7BvhUOFG03Zug8+DC1KkSHvvnqBUS7S2EySxIOhON6D2OycMt7z7iUYcNk
         8ma8ml77k7B3vMD9yAc1B5a1PZ7GfizfQF7IPMUlJGzaiL9JhBdQFgGvMHR+RtM1CgjM
         ockQ==
X-Gm-Message-State: AOAM530S9btZgTmjdrnplTkbPOLfhukBH9AKLTdIR5FJfjgQICL9VNyg
        NUNi4VNmucldusoDBWr9dDW9cp+xc4ZjOeZLhCy50jaM83Qa8l+ZRhEJSig9zbXx5JOBZhYe1ug
        VXwMx81m9+PFw
X-Received: by 2002:a17:906:6549:: with SMTP id u9mr22047682ejn.514.1633413951802;
        Mon, 04 Oct 2021 23:05:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcxu9a3KuPsrYmGYXohB+aPjsfCV4lrFoPAjPG6QH2e880doxw7nvn1pm+Wzq0SbBYLhGtWw==
X-Received: by 2002:a17:906:6549:: with SMTP id u9mr22047668ejn.514.1633413951643;
        Mon, 04 Oct 2021 23:05:51 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id u19sm8321258edv.40.2021.10.04.23.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 23:05:51 -0700 (PDT)
Date:   Tue, 5 Oct 2021 08:05:49 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zxwang42@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 07/17] x86 UEFI: Set up memory allocator
Message-ID: <20211005060549.clar5nakynz2zecl@gator.home>
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-8-zixuanwang@google.com>
 <20211004130640.hdse6xkg4m6jx5c2@gator>
 <CAEDJ5ZS14keuvWEofbi2YD9QZ8ZE3nGZoq421wWEXy5jQnFkaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEDJ5ZS14keuvWEofbi2YD9QZ8ZE3nGZoq421wWEXy5jQnFkaQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 02:43:52PM -0700, Zixuan Wang wrote:
> On Mon, Oct 4, 2021 at 6:08 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Fri, Aug 27, 2021 at 03:12:12AM +0000, Zixuan Wang wrote:
> > > KVM-Unit-Tests library implements a memory allocator which requires
> > > two arguments to set up (See `lib/alloc_phys.c:phys_alloc_init()` for
> > > more details):
> > >
> > >  #endif /* TARGET_EFI */
> > > --
> > > 2.33.0.259.gc128427fd7-goog
> > >
> >
> > How about just getting the memory map (efi_boot_memmap) and then exiting
> > boot services in arch-neutral code and then have arch-specific code decide
> > what to do with the memory map?
> >
> > Thanks,
> > drew
> >
> 
> I see, I will try to refactor the code in the next version:
> 
> 1. Defines an arch-neutral data structure to store the memory map
> 2. Calls an arch-neutral function to get the memory map

So, in my first PoC, I was using the AArch64 mem_region structure,
but in hindsight, an arch-neutral structure already exists that
I should have used from the AArch64 code. That arch-neutral
structure is simply the EFI structure (efi_boot_memmap).

> 3. Exits UEFI boot services
> 4. Calls an arch-specific function to process the memory map

Sounds good.

Thanks,
drew

