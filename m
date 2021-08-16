Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F123ECF54
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 09:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhHPH1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 03:27:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233885AbhHPH1I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 03:27:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629098796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FA3O9kq9zZ4zw2PdWas27IkNRNFWE0SHht5f8XnWK9Q=;
        b=fYMVLS7V3PlRNwsckrzlqWwOy37g0iU7zPSoxCreZq8yZdgRwKTde3Y9xI+K0CHvOS/2W0
        Q+rq/Z/Ww3ES7kGmpzizBLVy7IqbpvB0Ah2ZUrFkS9r37+ZVgWeGCymnp2dvnZW61p1ieK
        /5Hc7NX9Iry+uKcmbCXuIJHAKNy9s0s=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-hj3AdDxHPlu6cFf539F-GQ-1; Mon, 16 Aug 2021 03:26:33 -0400
X-MC-Unique: hj3AdDxHPlu6cFf539F-GQ-1
Received: by mail-ej1-f70.google.com with SMTP id e15-20020a1709061fcf00b005bd9d618ea0so284480ejt.13
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 00:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FA3O9kq9zZ4zw2PdWas27IkNRNFWE0SHht5f8XnWK9Q=;
        b=s0GfzJ8+Kpaf5muAMazQjBbcgEAGWCnG1kjIwcjOzq+MrkCis5tCVeWlzKkim506CP
         5TVfrz764XpJi7ItQdTrOnk6cUAtt/525M4IkDc9xjF+t/GEXPvLwEn2ynLsInxKaj3a
         kvDcfWEImIaHq0IoQOUImq4yvVWiKBe4tQN7xPcoY8Z5RYI0/GqQTgM0zY1LIpOGIqgD
         ooHytQQdtU1lV53GbJDUpHMGk3K+FpJ9ZqrpPynX51SK1fiEvnWoe34ilhrH43l6A9hl
         k5GAMIUKHs7jZv6r9ZBFNzar6I0geIdgoJxr0oRKGbvAg9TuGJM0a3xLwskoSjYXkgux
         s91w==
X-Gm-Message-State: AOAM530GXCkfHTjkLDHXUp4nABAXlVx7CEeKLNGMc9VLaW3emRtGDfWY
        Y0JA/fCEeXJ8ObPH+JbiS4rjXOsdHfbzJG7gdZQiFNnDnQrYIbX18W2bB0SIewuGVNtomRKhDFT
        yKCWTwG7LqV4C
X-Received: by 2002:a17:906:a044:: with SMTP id bg4mr14805752ejb.312.1629098792212;
        Mon, 16 Aug 2021 00:26:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhkRj547CYPZat8QFWt2HQ16Cy9ciBgzRnXN1/vV8WNUA6TfT0SSqTWAmEddXG8z5naMHWyA==
X-Received: by 2002:a17:906:a044:: with SMTP id bg4mr14805735ejb.312.1629098792020;
        Mon, 16 Aug 2021 00:26:32 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id v13sm3339551ejx.24.2021.08.16.00.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 00:26:31 -0700 (PDT)
Date:   Mon, 16 Aug 2021 09:26:29 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Zixuan Wang <zixuanwang@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
Message-ID: <20210816072629.zbxooxhr3mkxuwbx@gator.home>
References: <20210702114820.16712-1-varad.gautam@suse.com>
 <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021 at 11:44:39AM -0700, Marc Orr wrote:
> On Fri, Jul 2, 2021 at 4:48 AM Varad Gautam <varad.gautam@suse.com> wrote:
> >
> > This series brings EFI support to a reduced subset of kvm-unit-tests
> > on x86_64. I'm sending it out for early review since it covers enough
> > ground to allow adding KVM testcases for EFI-only environments.
> >
> > EFI support works by changing the test entrypoint to a stub entry
> > point for the EFI loader to jump to in long mode, where the test binary
> > exits EFI boot services, performs the remaining CPU bootstrapping,
> > and then calls the testcase main().
> >
> > Since the EFI loader only understands PE objects, the first commit
> > introduces a `configure --efi` mode which builds each test as a shared
> > lib. This shared lib is repackaged into a PE via objdump.
> >
> > Commit 2-4 take a trip from the asm entrypoint to C to exit EFI and
> > relocate ELF .dynamic contents.
> >
> > Commit 5 adds post-EFI long mode x86_64 setup and calls the testcase.
> >
> > Commit 6 patches out some broken tests for EFI. Testcases that refuse
> > to build as shared libs are also left disabled, these need some massaging.
> >
> > git tree: https://github.com/varadgautam/kvm-unit-tests/commits/efi-stub
> 
> Thanks for this patchset. My colleague, Zixuan Wang
> <zixuanwang@google.com>, has also been working to extend
> kvm-unit-tests to run under UEFI. Our goal is to enable running
> kvm-unit-tests under SEV-ES.
> 
> Our approach is a bit different. Rather than pull in bits of the EFI
> library and Linux EFI ABI, we've elected to build the entire
> kvm-unit-tests binaries as an EFI app (similar to the ARM approach).
> 
> To date, we have _most_ x86 test cases (39/44) working under UEFI and
> we've also got some of the test cases to boot under SEV-ES, using the
> UEFI #VC handler.
> 
> We will post our patchset as soon as possible (hopefully by Monday) so
> that the community can see our approach. We are very eager to see
> kvm-unit-tests running under SEV-ES (and SNP) and are happy to work
> with you all on either approach, depending on what the community
> thinks is the best approach.
> 
> Thanks in advance,
> Marc
>

Hi Marc,

I'm definitely eager to see your approach. I was actually working on
a second version of EFI support for ARM using the stub approach like
this series before getting perpetually sidetracked. I've been wanted
to experiment with Varad's code to continue that, but haven't been
able to find the time. I'm curious if you considered the stub approach
as well, but then opted for the app approach in the end. I was
leaning towards the stub approach to avoid the gnu-efi dependency.

Thanks,
drew

