Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C3C3DF1E7
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 17:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhHCP5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 11:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbhHCP5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 11:57:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E75C06175F
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 08:57:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so5324318pjb.2
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 08:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PUbLeF6P+RfV2ZMxgILEyWJ1iWI9JJBoF3+HQdIEp0o=;
        b=uEOqguzLfN7sxpk0hpNOYoi9naF81pEJsvlwL2+Hzf9X4jF3wJu7wk9ZTlzyX6qWI+
         qfV6C+nj8EL/HvTpF0FgN6WzgJiduGzthDy5w5YBvhVLdmtdzgfDWteklLMP5gukp2TV
         gWwhSTtlL1ZjU8HvVso6A+ozmA+KQ74GVJQg3y7FjwhjMzdkoiVcBQhcCas1PTRL/Cs1
         u8gUEdYB4L+Eg86K6hrdHnu8w8rY/sFkr3CyghJVfGH35hAMG85XbJk0lSlIB+AVFR4A
         bJIREME8V/XhMCh/mWv9IMenXWihHo2scEnXQGND/ztC/fzn+R9IWsCQSALCrBnf0x5v
         7wVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PUbLeF6P+RfV2ZMxgILEyWJ1iWI9JJBoF3+HQdIEp0o=;
        b=sfT8M3IzufOqe0OX6gUDkZnKS+SheAaaiNWcmeab8dv8rFO8zzSnLYrjjBsWPuxDfA
         OKDh4AjFtZxZKvea4M9E2FNAL2BIIzryjQRxB0N6xX3hQM5YfBriWDhxZoWsGE0NyQdX
         815J/uGrx4PLWZf93LtT+BHmhCZil88H9ak+IVKav0sPsTPaVKimm/Hok0No5gyHnZjM
         KqwgAglZlrHZMkx2vgqzjU7yfvCi0XPxNAR9bmbBca+tbFXMH9/pJFDFHFdR7Squ+1EA
         du8GqmzZ+AarUTkvvsXQlaIhpIKu/9/8exoK3KS+/GgpTEmFo5TUzgB8xfxgFBTRukQC
         guCA==
X-Gm-Message-State: AOAM532ly0306Ynl3JBT4stCUUfrdLsnyXUmUYgcZW/w4+eQ55SmsXwC
        gFngMe3EFjPRTAhXhuYfgaKF+f4kOcl1aA==
X-Google-Smtp-Source: ABdhPJyCNNlnYJSNBk0rXf5Z1I+OpS/E5ZuAiTayefhIQ6JoKww4ArLbVfGJBQvXyAavllg6CDngrg==
X-Received: by 2002:aa7:9470:0:b029:3c4:d63d:38bf with SMTP id t16-20020aa794700000b02903c4d63d38bfmr371218pfq.24.1628006242332;
        Tue, 03 Aug 2021 08:57:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b7sm15773399pfl.195.2021.08.03.08.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:57:21 -0700 (PDT)
Date:   Tue, 3 Aug 2021 15:57:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH] kvm/x86: Keep root hpa in prev_roots as much as
 possible
Message-ID: <YQlnXlmt9JvzRn+f@google.com>
References: <20210525213920.3340-1-jiangshanlai@gmail.com>
 <YQLuBDZ2MlNlIoH4@google.com>
 <CAJhGHyCU-Om3NWLVg-kbUE7FZD1nNZft8+KeCDH3cr_FDaitXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyCU-Om3NWLVg-kbUE7FZD1nNZft8+KeCDH3cr_FDaitXQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03, 2021, Lai Jiangshan wrote:
> On Fri, Jul 30, 2021 at 2:06 AM Sean Christopherson <seanjc@google.com> wrote:
> > Ha, we can do this without increasing the memory footprint and without co-opting
> > a bit from pgd or hpa.  Because of compiler alignment/padding, the u8s and bools
> > between mmu_role and prev_roots already occupy 8 bytes, even though the actual
> > size is 4 bytes.  In total, we need room for 4 roots (3 previous + current), i.e.
> > 4 bytes.  If a separate array is used, no additional memory is consumed and no
> > masking is needed when reading/writing e.g. pgd.
> >
> > The cost is an extra swap() when updating the prev_roots LRU, but that's peanuts
> > and would likely be offset by masking anyways.
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 99f37781a6fc..13bb3c3a60b4 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -424,10 +424,12 @@ struct kvm_mmu {
> >         hpa_t root_hpa;
> >         gpa_t root_pgd;
> >         union kvm_mmu_role mmu_role;
> > +       bool root_unsync;
> >         u8 root_level;
> >         u8 shadow_root_level;
> >         u8 ept_ad;
> >         bool direct_map;
> > +       bool unsync_roots[KVM_MMU_NUM_PREV_ROOTS];
> >         struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];
> >
> 
> Hello
> 
> I think it is too complicated.  And it is hard to accept to put "unsync"
> out of struct kvm_mmu_root_info when they should be bound to each other.

I agree it's a bit ugly to have the separate unsync_roots array, but I don't see
how it's any more complex.  It's literally a single swap() call.

> How about this:
> - KVM_MMU_NUM_PREV_ROOTS
> + KVM_MMU_NUM_CACHED_ROOTS
> - mmu->prev_roots[KVM_MMU_NUM_PREV_ROOTS]
> + mmu->cached_roots[KVM_MMU_NUM_CACHED_ROOTS]

I don't have a strong preference on PREV vs CACHED.  CACHED is probably more
intuitive, but KVM isn't truly caching the root, it's just tracking the HPA (and
PGD for indirect MMUs), e.g. the root may no longer exist if the backing shadow
page was zapped.  On the other hand, the main helper is cached_root_available()...

> - mmu->root_hpa
> + mmu->cached_roots[0].hpa
> - mmu->root_pgd
> + mmu->cached_roots[0].pgd
> 
> And using the bit63 in @pgd as the information that it is not requested

FWIW, using bit 0 will likely generate more efficient code.

> to sync since the last sync.

Again, I don't have a super strong preference.  I don't hate or love either one :-)

Vitaly, Paolo, any preferences on names and approaches for tracking if a "cached"
root is unsync?
