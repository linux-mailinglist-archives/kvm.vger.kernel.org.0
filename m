Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75041575803
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 01:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240650AbiGNXYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 19:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiGNXYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 19:24:13 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31FC1B79B
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 16:24:12 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j12so1758023plj.8
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 16:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UQQRlisvFE3qG/84+NRCdXjem1ls49Nbap0O2VwH2yc=;
        b=TNBzixoP59o3WHWGhZl5d/VsYSnIKUF/lAF9WOfPsikfhkXxb0q4YPNskb73BHZppV
         ZHHcIYzmUTM/ncVFvqz2/zymIzBT5yec5sV6dEkO+bipYDTRR6COCoZH1OhNd0SjaHH5
         qaZ3qjS9AcDCOYsxhvnpxpLzlrE2j/318AbTqypY4SUwtYl7VPB7SWNRyjr9BG+gImhC
         VncFnSEWPfHAlda71miShnDzVTt2Yovdi8pK6xDFFk/UC+GiPpcxpjUI6I7tLPJrhFet
         jHovKEcJvEeAzN8VM1xBOpaQTPOTeO4ZkwD8hJwYgIaTryLzztJDmWjytV0/TfbeWHOx
         PVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UQQRlisvFE3qG/84+NRCdXjem1ls49Nbap0O2VwH2yc=;
        b=t8bSBX+kdijRizf80s50PfiOBcXw8Wpxx9tOvnxVgQU26fuQRrs8GbYzZnKYftLIIm
         ivm5KmMqbKsUitaY5pdP4B2xgp1ewGEcoepMvc3FwiJ1LVSXb7LPyGzqN0MECuaxD/0R
         A1vRXlPqt8dJKBlP2Exv5eA3n9TYeNGSZkF3ENfXQqxGtnZXH8A9tjRg8sUoDPaRVnsE
         08+93rr9G/n2eKqTDYqcgdaYzLB43+Fh32BcHlJkv2SeyLVfesiyXrv7t7bMtBRpXSqs
         D4vYG5FGwTYgIKdAsBye9p7jElrNzop5UpXAZ/k5trGwT8d6/V610afGR4mEQUrVg/kX
         84/w==
X-Gm-Message-State: AJIora9xFZDmUGD9XBFoJ8mPXQRQWhlUnjDtCPwTb/iyRA//YWaqspJ1
        VwePuuyOjF6hIaFgK/f7PKiGIg==
X-Google-Smtp-Source: AGRyM1v+vSmFPCtaJggJ9KHGPCzSWosF1qcKTEvIB7Fd1YQEXcYkb0/o0zbOUASnWtBnRig0gR+Byw==
X-Received: by 2002:a17:902:d2cf:b0:16c:223e:a3e8 with SMTP id n15-20020a170902d2cf00b0016c223ea3e8mr10635200plc.125.1657841052184;
        Thu, 14 Jul 2022 16:24:12 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902ec8e00b0016b8746132esm2054067plg.105.2022.07.14.16.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 16:24:11 -0700 (PDT)
Date:   Thu, 14 Jul 2022 23:24:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix task switch emulation on INTn instruction.
Message-ID: <YtClmOgBV8j3eDkG@google.com>
References: <20220714124453.188655-1-mlevitsk@redhat.com>
 <52d44630-21ad-1291-4185-40d5728eaea6@maciej.szmigiero.name>
 <034401953bc935d997c143153938edb1034b52cd.camel@redhat.com>
 <84646f56-dcb0-b0f8-f485-eb0d69a84c9c@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84646f56-dcb0-b0f8-f485-eb0d69a84c9c@maciej.szmigiero.name>
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

On Fri, Jul 15, 2022, Maciej S. Szmigiero wrote:
> On 14.07.2022 15:57, Maxim Levitsky wrote:
> > On Thu, 2022-07-14 at 15:50 +0200, Maciej S. Szmigiero wrote:
> > > On 14.07.2022 14:44, Maxim Levitsky wrote:
> > > > Recently KVM's SVM code switched to re-injecting software interrupt events,
> > > > if something prevented their delivery.
> > > > 
> > > > Task switch due to task gate in the IDT, however is an exception
> > > > to this rule, because in this case, INTn instruction causes
> > > > a task switch intercept and its emulation completes the INTn
> > > > emulation as well.
> > > > 
> > > > Add a missing case to task_switch_interception for that.
> > > > 
> > > > This fixes 32 bit kvm unit test taskswitch2.
> > > > 
> > > > Fixes: 7e5b5ef8dca322 ("KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"")
> > > > 
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > ---
> > > 
> > > That's a good catch, your patch looks totally sensible to me.
> > > People running Win 3.x or OS/2 on top of KVM will surely be grateful for it :)
> > 
> > Yes and also people who run 32 bit kvm unit tests :)
> 
> It looks like more people need to do this regularly :)

I do run KUT on 32-bit KVM, but until I hadn't done so on AMD for a long time and
so didn't realize the taskswitch2 failure was a regression.  My goal/hope is to
we'll get to a state where we're able to run the full gamut of tests before things
hit kvm/queue, but the number of permutations of configs and module params means
that's easier said than done.

Honestly, it'd be a waste of people's time to expect anyone else beyond us few
(and CI if we can get there) to test 32-bit KVM.  We do want to keep it healthy
for a variety of reasons, but I'm quite convinced that outside of us developers,
there's literally no one running 32-bit KVM.
