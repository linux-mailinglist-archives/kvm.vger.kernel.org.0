Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E806F5234DC
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 15:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243059AbiEKN7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 09:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244257AbiEKN7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 09:59:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722D85B892
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 06:59:19 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s14so1959342plk.8
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 06:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZjjX/D7+e1CU0soxhtpqFh9Eg4y/Y1Z0qCVDda3ER7I=;
        b=l5vtfPE5w/vFTxxW2PLFbwnIjQyYCOhrLMonKHJNyILwanFVcK4dgjiTQfB99410KT
         PMTMR+97aIOmOxzle4CgWx4i0bmNMOznOyBYCPsEad95f+NteMTLG+dLQIRREizPz27i
         4cMUlNqrx8gIKpQqc4hHP1oNQ0/X/msdz6/gWlq8uVb15HWVNyLG3xknkX2pD/mp1fRx
         femwFw68cRHyk7gDWrEkEOslsYFNTiGZWqk9ddydfaKSRnYrkQezDx6FFmdR5gQRNkbw
         B/wEN+oA/9mVGjExXLOYAYx2LbwAz1NLR+a4QmA5Fwt5/EcCUPn4TduCtoxrgZtA55vD
         4y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZjjX/D7+e1CU0soxhtpqFh9Eg4y/Y1Z0qCVDda3ER7I=;
        b=wrnq/hVqCl3VbnwWUI5nnvtU3IktSz1xocolI8oZM/C9EIXX63XhIr0G8anWELA7ly
         eCDWsglYGfnGNOI89Jp4EEp9msJJ5t3VZjEVJPo3UG2tXCUQcUP5V6+Alj1Ek4Jhm9+m
         GJCujCdMnL0lkw8WiofhfJZ9lp0/zSNQazpRJayBQ/s33nmheMO+i7yBaq6jpgToJEiX
         xT4vT97N91FUiKeYhMagRlCfTQmwZkZ61RAVjccyK0UVF1bsq8SuKlAwhW9xP5ycGH91
         d6hOTjVlk/cXoLJIy02yccoTf8zHALyxGKYYOzGUyQ1HLpYDFxHEhexhdR5Xrzsd/iWP
         yGLg==
X-Gm-Message-State: AOAM530T3Mfk7rmYnBUEtL0NV7rO3TxpJnPHi9kqlBqijaEXSzEEPDx6
        hK30smLpCwiRgMjXlzsB9Mgzl4A0zchXug==
X-Google-Smtp-Source: ABdhPJz8n4abpGdrwPWzRKWsDr5A7bKb5JLCXUOL06OrQeQgDMFGxKlOM3jspnHzcsZCvMyXtm6p6A==
X-Received: by 2002:a17:902:f710:b0:15f:165f:b50b with SMTP id h16-20020a170902f71000b0015f165fb50bmr13252701plo.158.1652277558633;
        Wed, 11 May 2022 06:59:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lb1-20020a17090b4a4100b001cd4989ff64sm1880064pjb.43.2022.05.11.06.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 06:59:17 -0700 (PDT)
Date:   Wed, 11 May 2022 13:59:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>, kvm@vger.kernel.org
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
Message-ID: <YnvBMnD6fuh+pAQ6@google.com>
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com>
 <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
 <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
 <CALMp9eT3FeDa735Mo_9sZVPfovGQbcqXAygLnz61-acHV-L7+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eT3FeDa735Mo_9sZVPfovGQbcqXAygLnz61-acHV-L7+w@mail.gmail.com>
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

On Wed, May 11, 2022, Jim Mattson wrote:
> On Fri, May 6, 2022 at 11:31 PM Arnabjyoti Kalita
> <akalita@cs.stonybrook.edu> wrote:
> >
> > Dear Sean and all,
> >
> > When a VMEXIT happens of type "KVM_EXIT_DEBUG" because a hardware
> > breakpoint was triggered when an instruction was about to be executed,
> > does the instruction where the breakpoint was placed actually execute
> > before the VMEXIT happens?
> >
> > I am attempting to record the occurrence of the debug exception in
> > userspace. I do not want to do anything extra with the debug
> > exception. I have modified the kernel code (handle_exception_nmi) to
> > do something like this -
> >
> > case BP_VECTOR:
> >     /*
> >      * Update instruction length as we may reinject #BP from
> >      * user space while in guest debugging mode. Reading it for
> >      * #DB as well causes no harm, it is not used in that case.
> >      */
> >       vmx->vcpu.arch.event_exit_inst_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
> >       kvm_run->exit_reason = KVM_EXIT_DEBUG;
> >       ......
> >       kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
> >       kvm_run->debug.arch.exception = ex_no;
> >       kvm_rip_write(vcpu, rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
> >    <---Change : update RIP here
> >       break;
> >
> > This allows the guest to proceed after the hardware breakpoint
> > exception was triggered. However, the guest kernel keeps running into
> > page fault at arbitrary points in time. So, I'm not sure if I need to
> > handle something else too.
> >
> > I have modified the userspace code to not trigger any exception, it
> > just records the occurence of this VMEXIT and lets the guest continue.
> >
> > Is this the right approach?
> 
> Probably not. I'm not sure how kprobes work, but the tracepoint hooks
> at function entry are multi-byte nopl instructions. The int3
> instruction that raises a #BP fault is only one byte. If you advance
> past that byte, you will try to execute the remaining bytes of the
> original nopl. You want to skip past the entire nopl.

And kprobes aren't the only thing that will generate #BP, e.g. the kernel uses
INT3 for patching, userspace debuggers in the guest can insert INT3, etc...  The
correct thing to do is to re-inject the #BP back into the guest without touching
RIP.
