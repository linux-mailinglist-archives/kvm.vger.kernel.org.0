Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51184421E82
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 07:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhJEGA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 02:00:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231142AbhJEGA2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 02:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633413517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HsMAFeG6+BJulfWL44xpPhDecEuG0faLg66D1hhuZ0c=;
        b=Nd1pIl38x8Sj8Apdv2yd9SlFADceknMTHhK9rQZBwPLYZuw5SIs/GDz8ws6HgzFr3+kudo
        1axrmAIaa+9tyIz5tCUAQ7yt4UXxowXficJonE+/5ZXrPHhHZHv36m1N7MoaIiS+tq4036
        uAMRnDgFgfI2ttg3PP2ax6XOt5Kyo48=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-h3f9l-U9Nk6FjyajoLWyXg-1; Tue, 05 Oct 2021 01:58:36 -0400
X-MC-Unique: h3f9l-U9Nk6FjyajoLWyXg-1
Received: by mail-ed1-f72.google.com with SMTP id k10-20020a508aca000000b003dad77857f7so3636985edk.22
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 22:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HsMAFeG6+BJulfWL44xpPhDecEuG0faLg66D1hhuZ0c=;
        b=uMQDUj6trUX2bvOFf0WSJI9teh8OLGpVfhh7pmuYy86E6+eEjHhC28JsIf7mPDeN9/
         p2gFFopj+xlfZfnEfhEa1euUdQk14WXwcqCywEsJOtS3d1/JmWXqcwsnJlpSqbloOpjm
         Fl4PDTAZnZQ7jlA2720/kozmN9zbz+QuBuwyE/+CAXp+rCzGqin76xgjTuJ/K/Wv/NUh
         EU1LfmE7d8Jqu7be7hfS2qEYoMqnRpOdCgU6mPM+iDZgTUToYY6HGEEKPDhOPe8gC6Dn
         C+cP/XrGVZcvOw7OP5i7oxcpiAtSdT9yOf0mMjjzyCp5MGOVwHSUBM/569ZIUT6adc9h
         0bJQ==
X-Gm-Message-State: AOAM5318svov4kKiaSmGVU5hJqPLLhZRNsbtFwXihTxpWVvndQGiPhUs
        fayJypi3sL1dc9mocEfCL/lIomnJl4qINHWvqxgb1LJGLEOGF04DoV5gW/MGAA/tZP/jv6+Q0y3
        fRqIsvO0pIrrA
X-Received: by 2002:a17:907:7844:: with SMTP id lb4mr23265042ejc.381.1633413515272;
        Mon, 04 Oct 2021 22:58:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJye3pNQbAcI3j6rYSGRP8RP4yVgS+GebagBzOCq7nmMGcStdNi0mOi44z/h1JII6r8RiIAwYA==
X-Received: by 2002:a17:907:7844:: with SMTP id lb4mr23265030ejc.381.1633413515120;
        Mon, 04 Oct 2021 22:58:35 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id y3sm9257316eda.9.2021.10.04.22.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 22:58:34 -0700 (PDT)
Date:   Tue, 5 Oct 2021 07:58:32 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Zixuan Wang <zxwang42@gmail.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Tom Roeder <tmroeder@google.com>, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 03/17] x86 UEFI: Copy code from GNU-EFI
Message-ID: <20211005055832.psdm4mha22n336pv@gator.home>
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-4-zixuanwang@google.com>
 <20211004124411.nqikc4wyvpal73sh@gator>
 <CAEDJ5ZR63OzHG+_Yz5vNxSUYUwUAqsMgfz9TJnUnENiVTZa01Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEDJ5ZR63OzHG+_Yz5vNxSUYUwUAqsMgfz9TJnUnENiVTZa01Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 03:09:23PM -0700, Zixuan Wang wrote:
> On Mon, Oct 4, 2021 at 5:46 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Fri, Aug 27, 2021 at 03:12:08AM +0000, Zixuan Wang wrote:
> > > +More details can be found in `GNU-EFI/README.gnuefi`, section "Building
> > > +Relocatable Binaries".
> > > +
> > > +KVM-Unit-Tests follows a similar build process, but does not link with GNU-EFI
> > > +library.
> >
> > So, for AArch64, I also want to drop the gnu-efi dependency of my original
> > PoC. My second PoC, which I haven't finished, took things a bit further
> > than this does, though. I was integrating a PE/COFF header and linker
> > script changes directly into the kvm-unit-tests code rather than copying
> > these files over.
> >
> > Thanks,
> > drew
> >
> 
> This approach sounds really interesting. Is there a public repo for
> this new PoC?

Not yet, but reviewing this series has inspired me to reprioritize that
work. I'll try to get it dusted off, improved, and published somewhere.

> 
> I think the self-relocation code is the most important one in this
> patch. If we can avoid or rewrite the self-relocation process, then we
> can pretty much avoid copying GNU-EFI files.

Yup. AArch64 already has a simple relocator (only does R_AARCH64_RELATIVE)
in cstart64.S::start. I also wrote a R_PPC_RELATIVE relocator for ppc in
C, see powerpc/reloc64.c. But, if the gnu-efi one is better for x86, then
I don't see much problem in importing it.

Thanks,
drew

