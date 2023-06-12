Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94172C18A
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 12:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbjFLK6y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 06:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbjFLKym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 06:54:42 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA3D3A96
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 03:41:10 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f7fc9014fdso30302235e9.3
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 03:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686566469; x=1689158469;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9tBU14E6VKx0YubCyPNQ5lyogOgkdDtf33E5BuQuYsw=;
        b=Z34TIB7boruHotdH1rDFRTTBoMFSIB3TD1z3RGNuQby4W3EPnvTgahzb+MdVcxwQQX
         Nce8Ks1ZZEIb5KD4NibYq6f9CHonGjatKr4HhjVQs7vUim1dk7qEIAXJLBpFBGankPJZ
         WbKh87PbL6mx9P6ZabQZ3LLksG2HGBW5xTJIG/Zptjco4oeDJDtBVDp4KS9p5HZ9MSTy
         jPkhpkr6/olSSW5qE24BYkiTmg9qLqyPMgerD7Q9m7LnQYrP8uO0xzFaqX5Qju1FOfMb
         IsEeABUcW1zB80CEsKm/f8RjjF8g+/P1g3ngyABpxGwxklRSHHHXffdsb69FgyopVund
         t7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686566469; x=1689158469;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tBU14E6VKx0YubCyPNQ5lyogOgkdDtf33E5BuQuYsw=;
        b=EcdYsIgZCUtBH7Js8/bSc1Zg1VIe+WrBDO0xKmTNPnZLiuclc65xsxBc3OyaescZ6j
         Nx953LLzPtCI+lM1R5qhUaRQmJRtm0F0ZiGCI7kKGgUKjtLGkv9LcF8XayhC5s4RfNJp
         CqgZeR+Xp6Go8nUweVXOsBxmSVfprjLvy3j9ya2UR6JyXD8B+Fw+nmyWj/bRFTVNvS71
         AZm0P4xFTrIt46jBOPSaYGHSyvpLSuc9QdG38o3QLDZeWa6lN+ELhy1+XFkZyavbtcrH
         EDtRlTJAzVaGOQojWddVXbA7COhS6UI63ssBNIua1TPEf6uPHGvcGxIH7WShK9UZXv8G
         xX2A==
X-Gm-Message-State: AC+VfDzJaMcgseOLn272dYiT5DmCE/ZlaQ78OmlGkWgIwggI8qZr9kf5
        pN+JuPzQXSMzT2d/9n7D+PeVsg==
X-Google-Smtp-Source: ACHHUZ5J1iNkaETbBu27FRv7AwM9V8iffK4aOJ+xUv7HDf997VyUZog9DPqRi/Gu9HT6HBxNqGeljg==
X-Received: by 2002:a7b:c318:0:b0:3f7:3074:d2f2 with SMTP id k24-20020a7bc318000000b003f73074d2f2mr6479793wmj.34.1686566468731;
        Mon, 12 Jun 2023 03:41:08 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id m9-20020a056000008900b0030ae499da59sm12039371wrx.111.2023.06.12.03.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 03:41:08 -0700 (PDT)
Date:   Mon, 12 Jun 2023 12:41:07 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Nadav Amit <nadav.amit@gmail.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Message-ID: <20230612-a9f763ef517c2c5fe728bc38@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
 <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 10:52:00AM +0100, Nikos Nikoleris wrote:
> On 12/06/2023 08:52, Andrew Jones wrote:
> > On Sat, Jun 10, 2023 at 01:32:59AM -0700, Nadav Amit wrote:
> > > 
> > > > On May 30, 2023, at 9:08 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
> > > > 
> > > > Hello,
> > > > 
> > > > This series adds initial support for building arm64 tests as EFI
> > > > apps and running them under QEMU. Much like x86_64, we import external
> > > > dependencies from gnu-efi and adapt them to work with types and other
> > > > assumptions from kvm-unit-tests. In addition, this series adds support
> > > > for enumerating parts of the system using ACPI.
> > > 
> > > Just an issue I encountered, which I am not sure is arm64 specific:
> > > 
> > > All the printf’s in efi_main() are before current_thread_info() is
> > > initialized (or even memset’d to zero, as done in setup_efi).
> > > 
> > > But printf() calls puts() which checks if mmu_enabled(). And
> > > mmu_enabled() uses is_user() and current_thread_info()->cpu, both
> > > of which read uninitialized data from current_thread_info().
> > > 
> > > IOW: Any printf in efi_main() can cause a crash.
> > > 
> > 
> > Nice catch, Nadav. Nikos, shouldn't we drop the memset() in setup_efi and
> > put a zero_range call, similar to the one in arm/cstart64.S which zero's
> > the thread-info area, in arm/efi/crt0-efi-aarch64.S?
> > 
> 
> While I haven't run into any problems with this in this series,

We're fine on QEMU, since QEMU zeros the memory.


> I had in a
> previous version and back then the solution was this patch:
> 
> 993c37be - arm/arm64: Zero BSS and stack at startup
> 
> So I agree we should drop the memset and call some macro like zero_range in
> arm/efi/crt0-efi-aarch64.S.
> 
> Let me know if you want me to send a patch for this.

Yes, please, but we also don't have to hold this series up by it, since we
agreed that this series was focused on EFI over QEMU as a first step.
We'll need to worry about zeroing memory and more when we start running
on bare-metal.

To be clear, the patch for this can be on top of this series.

Thanks,
drew
