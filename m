Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8425C67F158
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 23:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjA0Wq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 17:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjA0WqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 17:46:25 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D221C599
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:46:24 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id p24so6395801plw.11
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 14:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZEYnhr/B5b9mHUoTu3/hsSx7bXw1ljXohhUlX7HpfeQ=;
        b=VX7UwjHqDndiT8deGr2yNk6PuKZhLEkrMsCxTDrbAD+YJvACNeKBitXSo7rWBR8s3A
         hex+j/TahRdLE2+iXhdd/UZb1N5ZP4YjQpuOtlHkxjhl0l+XHWZNkWbRhb2cynLezN9V
         1hWvNC6omWu32vQ0CgIM9Qu5o3NtRQfbjLQhTrtDyqqd/LoN6zYDH+S8qtTm+VsIyLvJ
         66/r+PgaIWU5CQzt4XpAaNeEvNOtYUug32Sw7NpOk6GGqz/CB5yY9JiBRQB/YyScad1V
         EmguIJVtWtaW2iLlKox6drY7m71gggdbgQHupqAv7gTX8JPpUS6O06qWYIU6BrEeKrB3
         4Dew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZEYnhr/B5b9mHUoTu3/hsSx7bXw1ljXohhUlX7HpfeQ=;
        b=tlBgy0Xd88YHdHBtfCR+WZXUi2ZNx6DxUCmN1VqhrT7tDP+ZgMJ9VB9+wcct08QRyQ
         PRkWo0q2voTfHOE6EpHnsdymtut5HJ0hDtx9RYL1MAWgqo1WguXaBaYb1Re9meyjquJQ
         PaUBKQPDqifEjSb1XDoFblmQ04j4eXkmXHHAv6ZmvFbIOOOQFFk+pb4lypUKja5yH3fs
         FDtRCJAro0MvMBEzk7kL45YsARKvnBDGDY4XyEnKMeZSgNbefewc95z+kVZeZ8SV6TML
         yJvrgsJ81d5+9jl0/isD31WUdvukgIB7loz4i3K4cDmlyiL+79fbM00MqcWPPKmdsREa
         F4kA==
X-Gm-Message-State: AO0yUKWq7Bj+w9c3UbbvcE+4GzHgXGHRkChV9LuxU+du+6nlR8QKzJGQ
        j20yIiMZFi1YPU/l+3NibB01JQ==
X-Google-Smtp-Source: AK7set8OSkfemmivnzt+FaTqk7pVCDdsxRS5FakopzxPZyWWlPwJdqWTOnIrlHupwNkFnDayOuy2BQ==
X-Received: by 2002:a17:90a:6949:b0:219:f970:5119 with SMTP id j9-20020a17090a694900b00219f9705119mr170655pjm.1.1674859583405;
        Fri, 27 Jan 2023 14:46:23 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c71-20020a63354a000000b004cffa8c0227sm2802295pga.23.2023.01.27.14.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 14:46:22 -0800 (PST)
Date:   Fri, 27 Jan 2023 22:46:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v2 00/15] Introduce Architectural LBR for vPMU
Message-ID: <Y9RUOvJ5dkCU9J8C@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> Intel CPU model-specific LBR(Legacy LBR) has evolved to Architectural
> LBR(Arch LBR [0]), it's the replacement of legacy LBR on new platforms.
> The native support patches were merged into 5.9 kernel tree, and this
> patch series is to enable Arch LBR in vPMU so that guest can benefit
> from the feature.
> 
> The main advantages of Arch LBR are [1]:
> - Faster context switching due to XSAVES support and faster reset of
>   LBR MSRs via the new DEPTH MSR
> - Faster LBR read for a non-PEBS event due to XSAVES support, which
>   lowers the overhead of the NMI handler.
> - Linux kernel can support the LBR features without knowing the model
>   number of the current CPU.
> 
> From end user's point of view, the usage of Arch LBR is the same as
> the Legacy LBR that has been merged in the mainline.
> 
> Note, in this series, there's one restriction for guest Arch LBR, i.e.,
> guest can only set its LBR record depth the same as host's. This is due
> to the special behavior of MSR_ARCH_LBR_DEPTH: 
> 1) On write to the MSR, it'll reset all Arch LBR recording MSRs to 0s.
> 2) XRSTORS resets all record MSRs to 0s if the saved depth mismatches
> MSR_ARCH_LBR_DEPTH.
> Enforcing the restriction keeps KVM Arch LBR vPMU working flow simple
> and straightforward.
> 
> Paolo refactored the old series and the resulting patches became the
> base of this new series, therefore he's the author of some patches.

To be very blunt, this series is a mess.  I don't want to point fingers as there
is plenty of blame to go around.  The existing LBR support is a confusing mess,
vPMU as a whole has been neglected for too long, review feedback has been relatively
non-existent, and I'm sure some of the mess is due to Paolo trying to hastily fix
things up back when this was temporarily queued.

However, for arch LBR support to be merged, things need to change.

First and foremost, the existing LBR support needs to be documented.  Someone,
I don't care who, needs to provide a detailed writeup of the contract between KVM
and perf.  Specifically, I want to know:

  1. When exactly is perf allowed to take control of LBR MRS.  Task switch?  IRQ?
     NMI?

  2. What is the expected behavior when perf is using LBRs?  Is the guest supposed
     to be traced?

  3. Why does KVM snapshot DEBUGCTL with IRQs enabled, but disables IRQs when
     accessing LBR MSRs?

It doesn't have to be polished, e.g. I'll happily wordsmith things into proper
documentation, but I want to have a very clear understanding of how LBR support
is _intended_ to function and how it all _actually_ functions without having to
make guesses.

And depending on the answers, I want to revisit KVM's LBR implementation before
tackling arch LBRs.  Letting perf usurp LBRs while KVM has the vCPU loaded is
frankly ridiculous.  Just have perf set a flag telling KVM that it needs to take
control of LBRs and have KVM service the flag as a request or something.  Stealing
the LBRs back in IRQ context adds a stupid amount of complexity without much value,
e.g. waiting a few branches for KVM to get to a safe place isn't going to meaningfully
change the traces.  If that can't actually happen, then why on earth does KVM need
to disable IRQs to read MSRs?

And AFAICT, since KVM unconditionally loads the guest's DEBUGCTL, whether or not
guest branches show up in the LBRs when the host is tracing is completely up to
the whims of the guest.  If that's correct, then again, what's the point of the
dance between KVM and perf?

Beyond the "how does this work" issues, there needs to be tests.  At the absolute
minimum, there needs to be selftests showing that this stuff actually works, that
save/restore (migration) works, that the MSRs can/can't be accessed when guest
CPUID is (in)correctly configured, etc. And I would really, really like to have
tests that force contention between host and guests, e.g. to make sure that KVM
isn't leaking host state or outright exploding, but I can understand that those
types of tests would be very difficult to write.

I've pushed a heavily reworked, but definitely broken, version to

  git@github.com:sean-jc/linux.git x86/arch_lbrs

It compiles, but it's otherwise untested and there are known gaps.  E.g. I omitted
toggling load+clear of ARCH_LBR_CTL because I couldn't figure out the intended
behavior.
