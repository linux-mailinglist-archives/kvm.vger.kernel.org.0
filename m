Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADA45236A8
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbiEKPEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 11:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbiEKPEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 11:04:31 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9503CA4C
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 08:04:30 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x23so2219695pff.9
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 08:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=misLRqD6Z1KZFxV0YhHevZiII/5rG3lAIypAsMxdr5k=;
        b=ekYbA+4S99HkzY/EMpHqH9a26hq8UfgCV3ivICySaoI8GBMmuc0ffzHOY7wLixftMx
         2PRgs2eIJv+M/rPyHzzkKhwQc73ejz2xHWsxeQEidoUzDcdxF7JTXDt/WziMPbVlkGdu
         2krqOz6gqzo/SD0/jFW3aJ77BzKio3tblQgFtTM6K3IFIGoNbd5NgvNNOx3uGoJAiZY6
         FJXzisf14+QJmEnNGuLvJ9WRdqPGbHiMNoW4PCtJBw0kRjoChIyrwScLCq3ZTxbYa82K
         IOX/k5ejObO4Xg+d4ZleccuSYgsc3h7JdyKr/dW+pcVajgoMhZdroE2G1ls0RDBPU+Ac
         hDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=misLRqD6Z1KZFxV0YhHevZiII/5rG3lAIypAsMxdr5k=;
        b=fjQcswqFEtUaUpl3dYg+Bl0fPmwgQ9pKDkSZ8ncSRNqvMwF3giGJw7HUfN5MwLrBIs
         BBZ7h+x8tFLIK3CKovhOrZta55y85vqFvpQ4ZUdCsDfCmBLk3ahqSrQ424oXMSxbUBE0
         dXIVpeE0tGiycStlAPvWkTDiVc/oUhWSr6heG7LECb07qDgeog1j6r508dd5gkR8FpZD
         qHceQO8fM6Fu20Nh4GcBJ7jU+kS/LSOiRoh6JYX1oycz6iWLr/NypojgJMgBkbbnbJzy
         w4xenWec8ZYKZHs/fa7QvHowAvW/WM1qEsIrbetm5pdE/m/HQBc3rcQM2cn5Vrur7wJF
         ZBiA==
X-Gm-Message-State: AOAM530PUDJVsWAJ4KJI4SwUTdOAnI1I8fju0Q9usms75iWcFF0J9e8u
        0Vgai/HIi2SV/eCIpbg8DAZ5nA==
X-Google-Smtp-Source: ABdhPJykrALHuj0r2nSZO25LLyPmd85Q9qhZlemQh91cCyXCszoozxihMoCzHa4sWrHgpuNGOWQ28w==
X-Received: by 2002:a62:d155:0:b0:50d:3c4e:37ec with SMTP id t21-20020a62d155000000b0050d3c4e37ecmr25519830pfl.60.1652281470218;
        Wed, 11 May 2022 08:04:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x189-20020a6286c6000000b0050dc762815dsm1870742pfd.55.2022.05.11.08.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 08:04:28 -0700 (PDT)
Date:   Wed, 11 May 2022 15:04:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
Message-ID: <YnvQd5zvDlop7oRK@google.com>
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com>
 <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
 <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
 <CALMp9eT3FeDa735Mo_9sZVPfovGQbcqXAygLnz61-acHV-L7+w@mail.gmail.com>
 <YnvBMnD6fuh+pAQ6@google.com>
 <CAJGDS+GMxG1gXMS1cW1+sS1V67h65iUpMGwQ=+-MVTE6DTOBjg@mail.gmail.com>
 <YnvFN7nT9DzfR8fq@google.com>
 <CAJGDS+G+z9S6QDEGRatR5u+q-5X_MAiWqnTsjf4L=4+PrThdsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJGDS+G+z9S6QDEGRatR5u+q-5X_MAiWqnTsjf4L=4+PrThdsQ@mail.gmail.com>
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

On Wed, May 11, 2022, Arnabjyoti Kalita wrote:
> What could be the various ways a guest could handle #BP?

The kernel uses INT3 to patch instructions/flows, e.g. for alternatives.  For those,
the INT3 handler will unwind to the original RIP and retry.  The #BP will keep
occurring until the patching completes.  See text_poke_bp_batch(), poke_int3_handler(),
etc...

Userspace debuggers will do something similar; after catching the #BP, the original
instruction is restored and restarted.

The reason INT3 is a single byte is so that software can "atomically" trap/patch an
instruction without having to worry about cache line splits.  CPUs are guaranteed
to either see the INT3 or the original instruction in its entirety, i.e. other CPUs
will never decode a half-baked instruction.

The kernel has even fancier uses for things like static_call(), e.g. emulating
CALL, RET, and JMP from the #BP handler.

> Can we "make" the guest skip the instruction that caused the #BP ?

Well, technically yes, that's effectively what would happen if the host skips the
INT3 and doesn't inject the #BP.  Can you do that and expect the guest not to
crash?  Nope.
