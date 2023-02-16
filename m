Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BBE698B59
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 05:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjBPEQX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 23:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPEQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 23:16:22 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3152C3CE2D;
        Wed, 15 Feb 2023 20:16:21 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s20so679127pfe.2;
        Wed, 15 Feb 2023 20:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Pv5vtFhC1/6mVNPYEr5ZDqdeCHty+f23VE56nzPwJAw=;
        b=cdNjE5wcxQbuw9IKIkHokysV/M+8uWE53aX5nXcRarfmyXvXTDwgJwyLKYn1BKaFSt
         79VHVPzsmWZx0UlDJpwkWJLNWtjvo4CxWLGgqhgfVsCExI/Ix0emDDKjvijWRvN2Wi2W
         W+7IEqoC6VT5ELnbpLEorDDVkK5kWupUHavC92viH6F/g4YB80cLtw0qYxH0hqTcH3Ks
         l+OuEk6LOCfJdf1pC6hZfT1kp/+5/4aIuzmrNKrn9U018fRqL1cA9zGs+bAfc0wppcBE
         Y7ELT0I2UQL1aTaiLV02t+T27m21JO/xn37jXSWsJPqRaZ2tXgi0vHZ4MTUPttPyRpYW
         XAzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pv5vtFhC1/6mVNPYEr5ZDqdeCHty+f23VE56nzPwJAw=;
        b=IMODo/L4zLFAfkP832OYg1SF+y3sqfGZv2A9tzA/aTq5tqMah61X9nyr6AZ1sUG1Tz
         1nivpeD81CQ4JyQBtmI65ZcPa2znAUedIKaXo+mdpHuxVtmco5gTErEgyPapR5e5IRZ3
         XLi2XEe7fhDN7u3PYxGjpL+eOI4DirNJHVGXgJWREbknOf22q6Pfzn/j1ZFR8mM4hrOr
         UpjTddP4Rauir6tBDPU0b0+FRZRKtOYYUNmznMbQsxOdZ7XdYXXSLBqFfpZ/TMigUPol
         OhiZgVCAi9RDKgoqyt1beyGyVmHDH2CtYNtS/abIxktBYn6P13Yopgmq58oXJf7KP9VZ
         8uVg==
X-Gm-Message-State: AO0yUKVbo6Ha3SNjtqQ3Rsdl1woC8zFyhTuC+qcy35QlRMVGZSfZ+92f
        Tcb5svCh11CFSwpyhdzjXIqx6aS3D3pbfoGR8z4=
X-Google-Smtp-Source: AK7set/GPwAClfXPGVN6ACUHYHmwE7KN249J7fT7QgaU+/B4NEyP/F+6Fbdu195NPVwC2ph1PgrUK8uAcW0oJxG27XQ=
X-Received: by 2002:a63:3507:0:b0:4ce:cb07:1d86 with SMTP id
 c7-20020a633507000000b004cecb071d86mr669795pga.2.1676520979707; Wed, 15 Feb
 2023 20:16:19 -0800 (PST)
MIME-Version: 1.0
References: <20230207155735.2845-1-jiangshanlai@gmail.com> <20230207155735.2845-7-jiangshanlai@gmail.com>
 <Y+WZoXYvacqx/+Yu@google.com>
In-Reply-To: <Y+WZoXYvacqx/+Yu@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 16 Feb 2023 12:16:07 +0800
Message-ID: <CAJhGHyDMdbJQVZnHC6nwPcous1kR2kfRH2c--LhuzHgjR4_mDQ@mail.gmail.com>
Subject: Re: [PATCH V2 6/8] kvm: x86/mmu: Remove FNAME(invlpg)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023 at 9:11 AM Sean Christopherson <seanjc@google.com> wrote:

>
> > +                     gfn_t gfn = kvm_mmu_page_get_gfn(sp, iterator.index);
> > +                     int ret = mmu->sync_spte(vcpu, sp, iterator.index);
> > +
> > +                     if (ret < 0)
> > +                             mmu_page_zap_pte(vcpu->kvm, sp, iterator.sptep, NULL);
> > +                     if (ret)
> > +                             kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
>
> Why open code kvm_flush_remote_tlbs_sptep()?  Does it actually shave enough
> cycles to be visible?


Although I have read the code of sync_page() many times,
I don't know why I had been having the assumption that it can possibly
change the sp->gfns[] (now sp->shadowed_translation[]).

I will add the following comments before calling kvm_mmu_page_get_gfn():

  Get the gfn beforehand for later flushing.  Although mmu->sync_spte()
  doesn't change it, but just avoid dependence.

Or I will use kvm_flush_remote_tlbs_sptep() with comments stating
that the gfn will not be changed.

>
> If open coding is really justified, can you rebase on one of the two branches?
> And then change this to kvm_flush_remote_tlbs_gfn().
>
>   https://github.com/kvm-x86/linux/tree/next
>   https://github.com/kvm-x86/linux/tree/mmu

The code was based on https://github.com/kvm-x86/linux/tree/mmu.

Thanks
Lai
