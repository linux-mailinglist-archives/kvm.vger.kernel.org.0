Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343A652EF04
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 17:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349552AbiETPW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 11:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiETPWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 11:22:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC0E90CF6
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 08:22:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id i1so7632189plg.7
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X3IHiwJ5wNPFuRIjw/VX2fzWcO2GqNMg+EtMwnbtcCE=;
        b=Lw9XBrUO4xElFv3poICpOcWJu7FGnbiIqec8UL03MtLFgaxCtXdELyyU01GqXohLhG
         ShwFlWiXPeW6W8Q56lO3LDtvidFAo2yugJk9HsvO51es/ka1Jey05DtwFXvURpcBxfpc
         mDSYYNXPRkjUoUy0fmdipEdgQibnoNIEXsNzqeWm4OT9DxLKxxZJmaocxd7wQoW4VaNC
         96wPbMsKKeZmGgU3mKOKYQuiRCUHxBzf9VPs6ANwTfUo3tbyKcJUnmCYm4noTepL5bgG
         LJ/QLgGZnJoYH3RmYJTNOHkbissXm6C6k/G4lUOr467x5nxIzo2SMtkpg+mRdtjxEEKg
         9gOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X3IHiwJ5wNPFuRIjw/VX2fzWcO2GqNMg+EtMwnbtcCE=;
        b=N3kMqWzSV8Gk6Xm88dXiwYy3a+mfl8NaCTFiNTPLizNckN1tB2WJWzM5INK6gCKC36
         b6tYxb5fiY3HeYdceGSNT2AXplk4M3K17Ai/TTnbAmmjMAvkmdSsOWF3/Ajf0IFnQHZb
         Q4NU/xjZkZWtlGt425aLQgL4qS8KGnZZDy7MGK8GKQoyIwuwrSs5GVW9zaNXg4KWc1zd
         7ujhP2XpZD0c7MadJN2SlDrv+EKFn3LF9NSMnpkH+wuJu5/2scYp3YO0Vo5MpN5EyvCk
         HVwSoc+aEuLMOwJw9XDqGMGqm5tVrlNvBoZpEMnEYq4ujlc+SjATzFPRNA4mJRbSWb+e
         /jBg==
X-Gm-Message-State: AOAM533uQuT/13IYcur3juGpuuxYbYJxjhV3hQ4bJ4kCe8Nf0TM1E4vL
        Skh+vlRe2QtkvNInrUMeem0XIQ==
X-Google-Smtp-Source: ABdhPJwuvq1qttPnmoP+Ns3E7RUaVZkJpXBX26PbcqkQaKLv3r2ql2j3lVmm8sCHrFVsSaZoHLYVrQ==
X-Received: by 2002:a17:903:244d:b0:161:ac9e:60ce with SMTP id l13-20020a170903244d00b00161ac9e60cemr10626530pls.160.1653060170586;
        Fri, 20 May 2022 08:22:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x21-20020a62fb15000000b0050dc76281b8sm1990007pfm.146.2022.05.20.08.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 08:22:50 -0700 (PDT)
Date:   Fri, 20 May 2022 15:22:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Brian Cowan <brcowan@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: A really weird guest crash, that ONLY happens on KVM, and ONLY
 on 6th gen+ Intel Core CPU's
Message-ID: <YoeyRibqS3dzvku6@google.com>
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
 <YoVkkrXbGFz3PmVY@google.com>
 <CAPUGS=pK57C+yb7Pr5o-LFBWHE-jP8+6-zSrigxVm=hcOtqi=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPUGS=pK57C+yb7Pr5o-LFBWHE-jP8+6-zSrigxVm=hcOtqi=g@mail.gmail.com>
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

On Fri, May 20, 2022, Brian Cowan wrote:
> Disabling smap seems to fix the problem...

Mwhahaha, I should have found someone to bet me real money :-)

> Now for the hard question: WHY?

The most likely scenario it that there's a SMAP violation (#PF due to a kernel
access to user data without an override to tell the CPU that the access is intentional)
somewhere in the guest that crashes/panics the guest kernel.  Assuming that's the
case, there are three-ish possibilities:

  1. There's a bug your company's custom kernel driver.
  2. There's a SMAP violation somewhere else in RHEL 7.8, which is an 8+ year old
     frankenkernel...
  3. There's a bug in your version of KVM related to SMAP virtualization

#3 begs the question, does this fail on bare metal that supports SMAP?  If so,
then that rules out #3.

If the crash occurs only when doing stuff related to your custom driver, #1 is
most likely the culprit.

One way to try and debug further would be to disable EPT in KVM (load kvm_intel with
ept=0) and then use KVM tracepoints to see when the guest dies.  If it's a SMAP
violation, there should be an injected SMAP #PF shortly before the guest dies.
