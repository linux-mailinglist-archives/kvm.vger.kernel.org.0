Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9635D4E9DE7
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 19:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244725AbiC1Rwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 13:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241511AbiC1Rwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 13:52:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04023C73F
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:50:56 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so31697pjo.2
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k9swn3UFVhgUXTfUhyp3q19zbpP+fWfmwmrzd9mdhuI=;
        b=H+qH3IZyJmG67UHSvVV7IVVXEF0PU0oygFqGrp1ftXvA0kbdX9isRmj4lQghH+0oVx
         M23tHe9cunGKcFjBk/S4/8xYZ5SZ6YwJawFegP8XU8ismQ8CEj7yYyBllhQeb58vnPS8
         QPZVd2kyVjHkP/Hw1BOfjEUGqPJsMJaVjj3ck3aZtDKniYz7BK6cM+WltubF/h852fzl
         R+frgR5k+wo4AOEZqBzvg0zNfdJicrQV1XGWNEY4otWyoD1MgbcdOlxN0/T41uZLhDlq
         HesGN+EFX8DRdAJDCkqFf2bw2P+XYpLpuc46eypq6pfAV/U7b+5TrRogLk89w4ZstQEq
         xB+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k9swn3UFVhgUXTfUhyp3q19zbpP+fWfmwmrzd9mdhuI=;
        b=S6AA0TCvH56cptT+ybGR9M3/SPunNNi4PDjYhiKvqnYtkf7L8GNHUkCWZ88/dvUsQd
         e0qpq1ESjleDXuOPZiyyNmGLDU2CmNF/afDrC1atcWq28UBSCAva/qIU3JuG7kYrRboS
         2mjklE/SU6Tp+dIWfmcKjLhUZMjbDHp/TSrmP454NbaQrZRL/CtBxZYDYRDNm/BSPTTc
         pAL1QT0nsXkmWUnovbH3eftcmbM1i/aoLt+/gFeTRDlyiuG29/egBIREo1XIasm6tXHE
         Jh9Mdf+/RloJE20UplHcSXtNYJe2rUuNKu4DBePS6FsBL5iaZVQnZIOrJrbLw8A3v4jX
         VDtQ==
X-Gm-Message-State: AOAM532ArtWHw8EgJhODhKJSarYYR/VrwLFJ+Py3kCQ5GaAaGu7niOBF
        8fjY+U2Vk79YtDt9AzMEE5iQNQ==
X-Google-Smtp-Source: ABdhPJxnaQhNGStKoPg9KikqgUp5Q7S6gz5EymGQc6i8+buIPXZRJ9565uoCA8b+0h1AfvpOm2r7Jw==
X-Received: by 2002:a17:903:11c7:b0:151:7290:ccc with SMTP id q7-20020a17090311c700b0015172900cccmr27401517plh.95.1648489856246;
        Mon, 28 Mar 2022 10:50:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z6-20020a056a00240600b004e17ab23340sm17616971pfh.177.2022.03.28.10.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 10:50:55 -0700 (PDT)
Date:   Mon, 28 Mar 2022 17:50:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
Message-ID: <YkH1e2kyFlQN3Hl9@google.com>
References: <20220311032801.3467418-1-seanjc@google.com>
 <08548cb00c4b20426e5ee9ae2432744d6fa44fe8.camel@redhat.com>
 <YjzjIhyw6aqsSI7Q@google.com>
 <e605082ac8361c1932bfddfe2055660c7cea5f2b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e605082ac8361c1932bfddfe2055660c7cea5f2b.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 27, 2022, Maxim Levitsky wrote:
> Other than that I am actually very happy that you posted this patch series,
> as this gives more chance that this long standing issue will be fixed,
> and if your patches are better/simpler/less invasive to KVM and still address the issue, 
> I fully support using them instead of mine.

I highly doubt they're simpler or less invasive, but I do hope that the approach
wil be easier to maintain.
  
> Totally agree with you about your thoughts about splitting pending/injected exception,
> I also can't say I liked my approach that much, for the same reasons you mentioned.
>  
> It is also the main reason I put the whole thing on the backlog lately, 
> because I was feeling that I am changing too much of the KVM, 
> for a relatively theoretical issue.
>  
>  
> I will review your patches, compare them to mine, and check if you or I missed something.
> 
> PS:
> 
> Back then, I also did an extensive review on few cases when qemu injects exceptions itself,
> which it does thankfully rarely. There are several (theoretical) issues there.
> I don't remember those details, I need to refresh my memory.
> 
> AFAIK, qemu injects #MC sometimes when it gets it from the kernel in form of a signal,
> if I recall this correctly, and it also reflects back #DB, when guest debug was enabled
> (and that is the reason for some work I did in this area, like the KVM_GUESTDBG_BLOCKIRQ thing)
> 
> Qemu does this without considering nested and/or pending exception/etc.
> It just kind of abuses the KVM_SET_VCPU_EVENTS for that.

I wouldn't call that abuse, the ioctl() isn't just for migration.  Not checking for
a pending exception is firmly a userspace bug and not something KVM should try to
fix.

For #DB, I suspect it's a non-issue.  The exit is synchronous, so unless userspace
is deferring the reflection, which would be architecturally wrong in and of itself,
there can never be another pending exception. 

For #MC, I think the correct behavior would be to defer the synthesized #MC if there's
a pending exception and resume the guest until the exception is injected.  E.g. if a
different task encounters the real #MC, the synthesized #MC will be fully asynchronous
and may be coincident with a pending exception that is unrelated to the #MC.  That
would require to userspace to enable KVM_CAP_EXCEPTION_PAYLOAD, otherwise userspace
won't be able to differentiate between a pending and injected exception, e.g. if the
#MC occurs during exception vectoring, userspace should override the injected exception
and synthesize #MC, otherwise it would likely soft hang the guest.

