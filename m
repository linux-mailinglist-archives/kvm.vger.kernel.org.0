Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01C13F3776
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 02:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhHUACA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 20:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhHUAB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 20:01:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C11C061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:01:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oc2-20020a17090b1c0200b00179e56772d6so5064916pjb.4
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mRc8XPC5uWxIlThaxLzdA1idj/Rq74IpjJRy+C3iwoM=;
        b=bfz4ROZ6LLFlWNA00f+eUgiocCenZJFHavOdFcjLE4H7uM1NznzUTYXM03Jkd+X0EV
         6ihQtANFTxGEDJdHCtzWUWjODEIW/ZZoHVWVYwtfsHYwuDrN77b6oPJorUgWEohy+9pO
         IhFpLOYWSEY5eaGuX9Fxu2Sercy5cJqmH94AAmGs3J2PyoSfzg8x9QAYWccz2gDCYmlX
         h0WOEc6hOd5G3c6dIOsfF5xWBw5Ebq43V2rhhRtFHG+6o78GITjBw3ijvPlowTIFXz4S
         Nwxn5gs0XlwwKESK3Ccj5F4AuZQXXBqfQpmtOcmU6Oj6wDCvdtPvA8NQSAC6pCvmpOpd
         NqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mRc8XPC5uWxIlThaxLzdA1idj/Rq74IpjJRy+C3iwoM=;
        b=TkwEswTk9XArw521rXndDJWOe6sYDAuHDekrKyibuLGIEcpFD1OG3ArJazZlHG6KPt
         Vk7/xr1o45tU0ACgzTwZo97sFsTMQN9h8um5qZD5JXR++jfeX0dH1nu7GvPHqDTCRfX5
         8NX7TPEX96k8K6gTNk/nhvLfwpifQ8Ao0CRYr5sKII6iFQQo9NIhHrUil9KoPVHeODz3
         voOw9aaKStkDmOFGCz5JxdQvX5P0PN6ycRGxVD/T22ab7qtKMDJyo4ChGPaCGUmaI+0V
         giI789j1d2VMmMOhyvl742IJB1Gn6U3hiPoKCxUNdM43iq3zThkJlCguqeIiBruGfVoJ
         BPDQ==
X-Gm-Message-State: AOAM5318/eROHqiJhKv1XAz7cKHtU2O/crIKZo1hXZJa/w4MOO/eEQS5
        JqiEAd88gmiDhrVgjunVQhsqZQ==
X-Google-Smtp-Source: ABdhPJxbI0sA3/UIUm29t0FkXc+C4RPgdNWi//8mqNoFsvYCWpdAJXuumfEnAa7JBmd/1OHG505qOg==
X-Received: by 2002:a17:902:8685:b0:12d:7f02:f7a6 with SMTP id g5-20020a170902868500b0012d7f02f7a6mr18475177plo.49.1629504080481;
        Fri, 20 Aug 2021 17:01:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o1sm8131215pfd.129.2021.08.20.17.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:01:20 -0700 (PDT)
Date:   Sat, 21 Aug 2021 00:01:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varadgautam@gmail.com>
Cc:     Zixuan Wang <zixuanwang@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        Hyunwook Baek <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>,
        Varad Gautam <varad.gautam@suse.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/6] Initial x86_64 UEFI support
Message-ID: <YSBCSjJKvvowFbyb@google.com>
References: <20210819113400.26516-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819113400.26516-1-varad.gautam@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021, Varad Gautam wrote:
> This series brings EFI support to kvm-unit-tests on x86_64.
> 
> EFI support works by changing the test entrypoint to a stub entry
> point for the EFI loader to jump to in long mode, where the test binary
> exits EFI boot services, performs the remaining CPU bootstrapping,
> and then calls the testcase main().
> 
> Since the EFI loader only understands PE objects, the first commit
> introduces a `configure --efi` mode which builds each test as a shared
> lib. This shared lib is repackaged into a PE via objdump.
> 
> Commit 2-4 take a trip from the asm entrypoint to C to exit EFI and
> relocate ELF .dynamic contents.
> 
> Commit 5 adds post-EFI long mode x86_64 setup and calls the testcase.
> 
> Commit 6 from Zixuan [1] fixes up some testcases with non-PIC inline
> asm stubs which allows building these as PIC.
> 
> Changes in v2:
> - Add Zixuan's patch to enable more testcases.
> - Fix TSS setup in cstart64.S for CONFIG_EFI.
> 
> [1]: https://lore.kernel.org/r/20210818000905.1111226-10-zixuanwang@google.com/
> git tree: https://github.com/varadgautam/kvm-unit-tests/tree/efi-stub-v2
> 
> Varad Gautam (5):
>   x86: Build tests as PE objects for the EFI loader
>   x86: Call efi_main from _efi_pe_entry
>   x86: efi_main: Get EFI memory map and exit boot services
>   x86: efi_main: Self-relocate ELF .dynamic addresses
>   cstart64.S: x86_64 bootstrapping after exiting EFI

Zixuan and Varad, are your two series complimentary or do they conflict?  E.g.
can Zixuan's series be applied on top with little-to-no change to Varad's patches,
or are both series trying to do the same things in different ways?

And if they conflict, are the conflicts largely superficial, or are there
fundamental differences in how the problems are being solved?

Thanks!

> Zixuan Wang (1):
>   x86 UEFI: Convert x86 test cases to PIC
