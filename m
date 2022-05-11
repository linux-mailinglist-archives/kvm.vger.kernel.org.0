Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117075235B8
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 16:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244864AbiEKOiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 10:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244850AbiEKOiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 10:38:16 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDFF994E6
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 07:38:14 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-e5e433d66dso3049414fac.5
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 07:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ziYE0NkVrBjDXTGbPV1+2QDWsD4aVv6jXZDQq95ad9w=;
        b=junsLANyDStr+Kt8Qq2tXaSgowjJ7dSU/AKT/2LxWU8sCdeMzZBLfXjZMjsoV7aao/
         0iNWjJR2S7QTnYjJkEFmkj1yQoVwn6WFkUW+60qcK0RGVbG3RuO4ekCxNxMiw+WyNlDA
         iJWQ3Tv2lIbbXMVjAeQ9DBi2A9OEyDxTJ5Ezk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ziYE0NkVrBjDXTGbPV1+2QDWsD4aVv6jXZDQq95ad9w=;
        b=NL96ZUKUADF7wPsJ5hottq84+y38iEXgvk+QmBJRszm72m0e3ZxoBqyOS+hMF4thfq
         9xitIYrLuqFKGAMgEq2ABoWe8HqwD7+O4gH14pwUkwo+vOYwwX4hOW1SPT2cjn18aUyW
         ND79R13Q1AcJRe8WxwTLncs7QtVIXuwo0VjsFp8yAsQd9/Fj0nbGyKd1sGFqD00CZwIL
         OFeQwq5X/O97ql8ql3W/kB1srYz8zmcr8boIVSk0IINShlYtmVc1Er1GmkdnialyoUVx
         ygT5OK5jYbRN9RTZjrSe96usU390j3WyGr+vb47V2VTpMUBhR2J40jR8s6KxO/Z/NVBz
         8pbg==
X-Gm-Message-State: AOAM533mru3cse2jxx/MG8HwERGouLld1Z5DcKwU3+ECxHX5Wwsvuthk
        V5udFPSMX2wchErvVyQKnVbFjHWNEdBFzhMlcNtWYw==
X-Google-Smtp-Source: ABdhPJxNpNNIj4irIneC5fqKELT9Id1HxzpdjxSqhgtyCCRCm9G+y6nqFIXA9mpOScyXbLbJU4uCSNwKXmNkJJzdojI=
X-Received: by 2002:a05:6870:5818:b0:ee:e90:46cc with SMTP id
 r24-20020a056870581800b000ee0e9046ccmr2887037oap.37.1652279893906; Wed, 11
 May 2022 07:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com> <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
 <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
 <CALMp9eT3FeDa735Mo_9sZVPfovGQbcqXAygLnz61-acHV-L7+w@mail.gmail.com>
 <YnvBMnD6fuh+pAQ6@google.com> <CAJGDS+GMxG1gXMS1cW1+sS1V67h65iUpMGwQ=+-MVTE6DTOBjg@mail.gmail.com>
 <YnvFN7nT9DzfR8fq@google.com>
In-Reply-To: <YnvFN7nT9DzfR8fq@google.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Wed, 11 May 2022 20:08:02 +0530
Message-ID: <CAJGDS+G+z9S6QDEGRatR5u+q-5X_MAiWqnTsjf4L=4+PrThdsQ@mail.gmail.com>
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

Thank you for your answer. It might be easier and my code might be
more "portable" if I allow the guest to handle the #BP themselves.

When a VMEXIT happens, if I allow KVM to inject the #BP, cause a
VMEXIT to userspace, do what I want when that happens and then, allow
KVM to restart the guest via KVM_VCPU_RUN, I understand that the guest
will handle the #BP and continue execution.

What could be the various ways a guest could handle #BP? Can we "make"
the guest skip the instruction that caused the #BP ?

Best Regards,
Arnabjyoti Kalita


On Wed, May 11, 2022 at 7:46 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 11, 2022, Arnabjyoti Kalita wrote:
> > Hello Jim and Sean,
> >
> > Thank you for your answers.
> >
> > If I re-inject the #BP back into the guest, does it automatically take
> > care of updating the RIP and continuing execution?
>
> Yes, the guest "automatically" handles the #BP.  What the appropriate handling may
> be is up to the guest, i.e. skipping an instruction may or may not be the correct
> thing to do.  Injecting the #BP after VM-Exit is simply emulating what would happen
> from the guest's perspective if KVM had never intercepted the #BP in the first place.
>
> Note, KVM doesn't have to initiate the injection, you can handle that from userspace
> via KVM_SET_VCPU_EVENTS.  But if it's just as easy to hack KVM, that's totally fine
> too, so long as userspace doesn't double inject.
