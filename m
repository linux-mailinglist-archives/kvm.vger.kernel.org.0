Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E793243B1
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 19:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhBXSXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 13:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbhBXSXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 13:23:21 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F19C061574
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 10:22:41 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id v200so1880605pfc.0
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 10:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Ekz/GZccERa3C1AHrp2icdATneuYRFX37mYpxu1zrQ=;
        b=njGvsO8oCNC80bXLA/su7EZCfgpaKEj+gTEierQXqYKbYtwjxbONX+BgrJCYejrNW4
         AtHlF0gYNE6m4O/ISBqN/n5663VyRVg07SEiR3sUfg65CJDWFefVpQiQEA74ick9DOGa
         NiWdrePl7Qpms0n6i2Tz/XEIxLKr7V3P6Na5pEzDO+k1uaXuZC9zMi/lA5Feqz8HmLWj
         xhXECg599qgL5TzAnjXR0n4pUJyQ8kKOOgJTpS+UWaMA/6kNwCKl/dmjBxeXsuwcLZ4+
         A5iIntAwScQCf4rWvFF0eK/MuAQiYxbi6Zt/BryIMckp5BWknj4ldLK10ZmMiyd4DyIY
         YCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Ekz/GZccERa3C1AHrp2icdATneuYRFX37mYpxu1zrQ=;
        b=JVyru9QVuH5SC9ag8MsvFpiB3y/shrhOyhHvToSM+kxlUvywIHtNP7z0z/F9+blrKt
         aikwYCirlPsnclLzVvyWptLPoaIHm8TXKzT4H1wrz9GuWKgMSbZOQZ25mbwHV6UeGA3a
         aNIvm2wy2SqW25dhGxmf0WquwEvVx0PgBmyo1+G7jQr4wsIl09mSrd3mAhOZVsIS6I8/
         9odBzT90P9/iRl+Z8uSJdw2ZxyBAMaxgCc5O+NoZWcr0iPICEHCwaGejEedd9yKJA0pH
         iZIfBpUyj8UT6EurY2FXdACH2mNuCli5MAo32Q25dBqeXRVjO68Lc9cUHNDB5iYOrv64
         TFkA==
X-Gm-Message-State: AOAM533NDg4KBeaVFzEXPZySaqxWViLp5S8zbSL3aN9wGvq65PazlXQY
        gU1VUwnGDS69vetxXR6Xv5BuMQ==
X-Google-Smtp-Source: ABdhPJwA2UgGDe5GNZf6z02NEbFcGcz1+uwS5k87G0Qizj5n2D+EpMCdlBdy20pPBAMzr06coaDmsA==
X-Received: by 2002:a05:6a00:23c5:b029:1e6:2f2e:a438 with SMTP id g5-20020a056a0023c5b02901e62f2ea438mr33576304pfc.75.1614190960438;
        Wed, 24 Feb 2021 10:22:40 -0800 (PST)
Received: from google.com ([2620:15c:f:10:385f:4012:d20f:26b5])
        by smtp.gmail.com with ESMTPSA id g19sm3441554pjv.43.2021.02.24.10.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 10:22:39 -0800 (PST)
Date:   Wed, 24 Feb 2021 10:22:33 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@suse.de" <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srutherford@google.com" <srutherford@google.com>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <YDaZacLqNQ4nK/Ex@google.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB27672FF8358D122EDD8CC0188E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <20210224175122.GA19661@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224175122.GA19661@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021, Ashish Kalra wrote:
> # Samples: 19K of event 'kvm:kvm_hypercall'
> # Event count (approx.): 19573
> #
> # Overhead  Command          Shared Object     Symbol
> # ........  ...............  ................  .........................
> #
>    100.00%  qemu-system-x86  [kernel.vmlinux]  [k] kvm_emulate_hypercall
> 
> Out of these 19573 hypercalls, # of page encryption status hcalls are 19479,
> so almost all hypercalls here are page encryption status hypercalls.

Oof.

> The above data indicates that there will be ~2% more Heavyweight VMEXITs
> during SEV guest boot if we do page encryption status hypercalls 
> pass-through to host userspace.
> 
> But, then Brijesh pointed out to me and highlighted that currently
> OVMF is doing lot of VMEXITs because they don't use the DMA pool to minimize the C-bit toggles,
> in other words, OVMF bounce buffer does page state change on every DMA allocate and free.
> 
> So here is the performance analysis after kernel and initrd have been
> loaded into memory using grub and then starting perf just before booting the kernel.
> 
> These are the performance #'s after kernel and initrd have been loaded into memory, 
> then perf is attached and kernel is booted : 
> 
> # Samples: 1M of event 'kvm:kvm_userspace_exit'
> # Event count (approx.): 1081235
> #
> # Overhead  Trace output
> # ........  ........................
> #
>     99.77%  reason KVM_EXIT_IO (2)
>      0.23%  reason KVM_EXIT_MMIO (6)
> 
> # Samples: 1K of event 'kvm:kvm_hypercall'
> # Event count (approx.): 1279
> #
> 
> So as the above data indicates, Linux is only making ~1K hypercalls,
> compared to ~18K hypercalls made by OVMF in the above use case.
> 
> Does the above adds a prerequisite that OVMF needs to be optimized if 
> and before hypercall pass-through can be done ? 

Disclaimer: my math could be totally wrong.

I doubt it's a hard requirement.  Assuming a conversative roundtrip time of 50k
cycles, those 18K hypercalls will add well under a 1/2 a second of boot time.
If userspace can push the roundtrip time down to 10k cycles, the overhead is
more like 50 milliseconds.

That being said, this does seem like a good OVMF cleanup, irrespective of this
new hypercall.  I assume it's not cheap to convert a page between encrypted and
decrypted.

Thanks much for getting the numbers!
