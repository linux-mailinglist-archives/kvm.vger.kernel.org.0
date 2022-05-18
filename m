Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191C352C2BC
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241593AbiERSs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 14:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241652AbiERSss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 14:48:48 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FD822A2D6
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 11:48:46 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2fee9fe48c2so34557597b3.3
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 11:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mQnZa4BfBeN84bM+mO65zMqgE6KowI162z9FKVzWCcw=;
        b=G5ClvUuaXnehM8iKJ7nNms3J09VxTK3ZGi06JuwlvAKROk2ifh+bU2jrj7L+osZVnr
         ip2vjNRZH+/Phajueu3xDyQpDoetzUodqYfYHM3HMQ884XvsKUFMNpZDE7NCyrD3xEwX
         iaRFfRoA+U5zbwTUeMOBmcMdYrDCazjoEjSw19Qu1VfVyAyc2KDwf6zF7TSaV+k75DuZ
         MEZNGX4ivammCZp+G7qdJED8mo90zTOqtGdA1JLrTrJ/1JdyQnCky4N7+jiyLwarv73S
         KFcmmZWDJWisZM7GQMM1m/Es9QEmqX/8fbfPkzP7WxgkzbMJcoX7a4Fvnr97ReBMtgDD
         tFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mQnZa4BfBeN84bM+mO65zMqgE6KowI162z9FKVzWCcw=;
        b=jHAEU3hVTr+yHsKRe3BBZb/g6A8L6TsZEUp8k6ZzWDaawqNOpST8CQu42veI/Adi4O
         uO0v4NHIa/721s0GSWF0iLl7aRgFU0sgdmDKyFmXFR/tokVC/HI7iIsHcvMbnfDClS0e
         vQyy1mfE4qJTZj6ggwdDRTpSha+SteyiM5AY8OhCTBGyiYtryC1n7QsHA2GhNoFvhAG5
         QFQO7BCgmcWTLjWg2n86evZvkMwB5YrzSbZuP00iAi0n4Rr8SaGJ8k5mnlI6gahloub5
         Ka/rcBmCvmyk9HGEg7shZZ4C4cQTijr8vLS+wSuU/6+AspIZlfIggWCDEjCCKCokPCnE
         Ty/A==
X-Gm-Message-State: AOAM531waRycfz2KDudkdzFaT4SOg1RrwpxkWzhDBKLGOT/RWkSN+vpO
        coTBVwJDQ1Q5uJvM4z1M04UeZak6Q7J1vQ0HBfBCtKYF
X-Google-Smtp-Source: ABdhPJywzn3sV4fVCAavh/IaWpNUOmu3IG0UrhcPQugA88sJtV+1c4oRSO9x8zLZST8SpIJWslc//5NeDzl7hJ/EY8M=
X-Received: by 2002:a81:3a4e:0:b0:2fe:c95a:c705 with SMTP id
 h75-20020a813a4e000000b002fec95ac705mr845738ywa.45.1652899726024; Wed, 18 May
 2022 11:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAPUGS=oTTzn+HjXMdSK7jsysCagfipmnj25ofNFKD03rq=3Brw@mail.gmail.com>
 <CALMp9eQbpxHpGXJjYesH=SJu_LiCmCVTXYwV+w7YfdGpfc_Yzw@mail.gmail.com>
In-Reply-To: <CALMp9eQbpxHpGXJjYesH=SJu_LiCmCVTXYwV+w7YfdGpfc_Yzw@mail.gmail.com>
From:   Brian Cowan <brcowan@gmail.com>
Date:   Wed, 18 May 2022 14:49:14 -0400
Message-ID: <CAPUGS=r2BGsCfS5HOourwJG90z_3_-bPqRu2yz7dJye43qqRfA@mail.gmail.com>
Subject: Re: A really weird guest crash, that ONLY happens on KVM, and ONLY on
 6th gen+ Intel Core CPU's
To:     Jim Mattson <jmattson@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest crash.. Which console? Would the vmcore-dmesg be of use? I used
"virsh --debug=0 rhel7.6 --console --force-boot" and got nothing on
the console.

This might be because this is running a GUI login. I found
http://libvirt.org/kbase/debuglogs.html

I set the debug to go to a file, then set the filters to use the "Less
verbose logging for QEMU VMs" on that page... I also tried a log
filter of "1:*".

I saw RESET events that then specify "guest-reset" but I don't see
anything other than startup messages in the domain logs...  Problem
is, of course, I have little or no idea what to look for, or whether I
should modify the domain log settings somehow... At least I admit I'm
clueless...

On Wed, May 18, 2022 at 1:30 PM Jim Mattson <jmattson@google.com> wrote:
> Guest crash or hypervisor crash? If the former, can you provide the
> guest's console output?
