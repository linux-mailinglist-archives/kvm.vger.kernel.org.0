Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A3D523A96
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 18:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344941AbiEKQqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 12:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344961AbiEKQqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 12:46:50 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1144A90B
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 09:46:49 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-d6e29fb3d7so3485146fac.7
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 09:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wsALrmg81reRYjusfhpQJi5XuwMynf7MqUJQVdaBvHw=;
        b=OiBTGgjVA2lJSpPdzWVWyduwfMWVgS3jcA03WIu9eLReYnjSMcZJlIyJKyeRgO5krA
         r9ea6y6JudBS7Kn3X87k0vglWNIeOU1ZbpxwzgRp0gPXMe2qk+Wr1WHDptWY8aW97bOB
         IHI5WravnVge1twk44jV/GaM4hH9tAS0QwyNt8gUcvXqPd46MNcfFFPcoN9dOozTheJr
         JIqgPTicoH6Qnb6gRUflB1wldcRQfY3LFJX6HsFfFfC13bxNc8W8c81R5yTBhkvhw4aR
         nxluWjLCGQEa5ps2SyESVR8UjmNJIV4X5NyoitNyD/7k/blHjjYdyIh4TqYkJk0i2oAW
         8dGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wsALrmg81reRYjusfhpQJi5XuwMynf7MqUJQVdaBvHw=;
        b=POhmNyZXTHFgvcWrsRx2uwTJ6KjucELlI57MtiVoJwp1U7H/bfI6L4ROhEdke0bgVX
         SZ/jkhf+EsYVMLtmY+tKWzPkDb1cA7i68GiFS/khTUfIZX4bo7boPhT4IkRmzTFecNIv
         QL60A+3J8L0B2rwXMvtDWyFBzp7jnr8hyc0FTrP9k0o/BQt0IbOXfxHpr+M1qgZhl62T
         /rqPwb0SLbARu0qTAPxrciwJtrmKmP68BJF0Yk1NWNzZmkdEVVXiOPThnTlcQr3hIZjf
         Oj0fJYIINof3qfFbRzHkfz4ggWGiclwvBP0pMfEjg0l9GT/AyKWkyjKt1Qj8ztq1f6pl
         uryQ==
X-Gm-Message-State: AOAM530nk4CD7wHU3ouJt4YDMEeB6+wZe4W7dlcZbkhn8LMszP+GnEGG
        Q89ATs9zolf+AT9t8/SKQFB5h500yGzXtLB204itIA==
X-Google-Smtp-Source: ABdhPJyWYH+3XpILMiqfUguaryFLVncf2b1K4SozxQE9uQLrNaRZ/XJUcnZx2EvNvynKBLmq1vEfBjt7k1rHfrXnVHY=
X-Received: by 2002:a05:6870:f719:b0:d6:e0c0:af42 with SMTP id
 ej25-20020a056870f71900b000d6e0c0af42mr3050194oab.165.1652287608355; Wed, 11
 May 2022 09:46:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220412195846.3692374-1-zhanwei@google.com> <20220412195846.3692374-2-zhanwei@google.com>
 <Ynmp2AEOQvWw+CYK@google.com>
In-Reply-To: <Ynmp2AEOQvWw+CYK@google.com>
From:   Wei Zhang <zhanwei@google.com>
Date:   Wed, 11 May 2022 18:45:00 +0200
Message-ID: <CAN86XOag4ROk30DWVdRDV6CKwj9jo+MWaVEoc0mLb13Y2uoVbw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: allow guest to send its _stext for kvm profiling
To:     Sean Christopherson <seanjc@google.com>
Cc:     Suleiman Souhlal <suleiman@google.com>,
        Sangwhan Moon <sxm@google.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Tue, May 10, 2022 at 1:55 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 12, 2022, Wei Zhang wrote:
> > The profiling buffer is indexed by (pc - _stext) in do_profile_hits(),
> > which doesn't work for KVM profiling because the pc represents an address
> > in the guest kernel. readprofile is broken in this case, unless the guest
> > kernel happens to have the same _stext as the host kernel.
> >
> > This patch adds a new hypercall so guests could send its _stext to the
> > host, which will then be used to adjust the calculation for KVM profiling.
>
> Disclaimer, I know nothing about using profiling.
>
> Why not just omit the _stext adjustment and profile the raw guest RIP?  It seems
> like userspace needs to know about the guest layout in order to make use of profling
> info, so why not report raw info and let host userspace do all adjustments?

It's hard to store raw IPs if we want to reuse the existing profiling
facility. The profiling function is initially used to store the
current IP at each clock tick for the host kernel.

The original design avoided the trouble of storing raw IPs by creating
a buffer array with a length of (_etext - _stext) and do buffer[IP -
_stext]++ at each clock tick. In the user space, the readprofile
command could read it from /proc/profile and tell us roughly how many
ticks occurred in each kernel function with a map file. (IP - _stext)
has a clear meaning here since it gives us an offset with respect to
the start of the text segment. This gets tricky after the profile=kvm
boot option was introduced
(https://github.com/torvalds/linux/commit/07031e14) because (IP -
_stext) is no longer meaningful.

I think raw guest IPs are easy to consume by userspace tools. But we
probably need to go with a different approach if we want to store raw
guest IPs.
