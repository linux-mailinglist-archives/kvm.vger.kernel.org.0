Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158DCB24D6
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 20:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388358AbfIMSCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 14:02:53 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:43599 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387935AbfIMSCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 14:02:53 -0400
Received: by mail-wr1-f45.google.com with SMTP id q17so28264614wrx.10
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2019 11:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m15sb4A6UajFPQGIEgWAJKQruSeIdQgRw7nnferfoo8=;
        b=Jh2AeFV0MevLLaWU95RaEQvEWxHdr10UrxXS22CrDrUg2xvlhiJB7704Uhji0uiX1I
         SI9O3OcSoJhyX40nsz7PNQW9xRHAxhwSLo7f+v43f/cAnKKpxkPXYQ+da0TtPDb3mBTk
         oFnD4DOd1ZwfL3JFjn5dS+mteVcwZPTXogwSgvqEz9S7LgMpVLOfMgFweXQ6OXqGgNaZ
         oLQTFQ+xDmof/B0hmZiKD/XNCi/NdE7hPA4BGJuiBcL7hAgJB9cZJpbvqaJMdZtkeHWR
         Fxldhnus0xn/Lg+DdAUiZZBY3vCq4SyGYT7TvNAQRUuwazycD3+89AG2v4JhTh1qDjAm
         mvLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m15sb4A6UajFPQGIEgWAJKQruSeIdQgRw7nnferfoo8=;
        b=kMDtzLqyRpsU8OKg4Y60/HkvW6zNHERxW3FeVraBiISp5cVj/an+ryGyhov6q8QS4T
         qKJmQIitbLDbIHWjmubZEzYTHDcX7NLF/x+QzVuoP77FgIrPwtQlSSdioRdrcKrlM+hF
         xjTeOS6rfWWDxrItJyvVMvexDprmgC9hllqBbTxuR2RGoW0lAVM8zMCNcUfg6vVlPtAq
         dmmo8vYcKx4hnKopF2Ch3VvnMsMY/hjVuazNNKRhD/TEgSC9QkCEJEilQO45/xvlW0gS
         ZePf9BZu7/FMVmY4izozXkh/HEUFBKQk8dDU5i3op14bnfNSwZNZFbJXdiROB1hBH+vD
         Jzmg==
X-Gm-Message-State: APjAAAVh0UrSMXf7/tSzz+wD92hjKuPOTMWtzdh6FACG7giYuvOBp7e2
        P0UcdxT8NKfyhdO/rbmzZntkfB940Ah6gfB8VOlbyA==
X-Google-Smtp-Source: APXvYqyg70VXTDA3aH8pfE5YeGZPr4kz71H6gTkyLfiXKD7iqCX9t3hyMUqaNyfoJ70niAvqO34Axt/jAV9ud0yUQ1I=
X-Received: by 2002:adf:e9ce:: with SMTP id l14mr17972255wrn.264.1568397770754;
 Fri, 13 Sep 2019 11:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190912180928.123660-1-marcorr@google.com> <20190913152442.GC31125@linux.intel.com>
In-Reply-To: <20190913152442.GC31125@linux.intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 13 Sep 2019 11:02:39 -0700
Message-ID: <CAA03e5F3SNxcYxdeOg6ZUfxRA5gBe7qaMxSATL13sq1cUL63KQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nvmx: test max atomic switch MSRs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > +static void *alloc_2m_page(void)
> > +{
> > +     return alloc_pages(PAGE_2M_ORDER);
> > +}
>
> Allocating 2mb pages is complete overkill.  The absolute theoretical max
> for the number of MSRs is (8 * 512) = 4096, for a total of 32kb per list.
> We can even show the math so that it's obvious how the size is calculated.
> Plus one order so we can test overrun.
> /*
>  * The max number of MSRs is specified in 3 bits bits, plus 1. I.e. 7+1==8.
>  * Allocate 64k bytes of data to cover max_msr_list_size and then some.
>  */
> static const u32 msr_list_page_order = 4;

8 * 512 should be 16 * 512, right [1]? Therefore, the maximum
theoretical is 64 kB.

I'll happily apply what you've suggested in v2. But I don't see why
it's so terrible to over-allocate here. Leveraging a generic 2 MB page
allocator can be reused going forward, and encourages uniformity
across tests.

[1]
struct vmx_msr_entry {
  u32 index;
  u32 reserved;
  u64 value;
} __aligned(16);

> > +static void populate_msr_list(struct vmx_msr_entry *msr_list, int count)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < count; i++) {
> > +             msr_list[i].index = MSR_IA32_TSC;
> > +             msr_list[i].reserved = 0;
> > +             msr_list[i].value = 0x1234567890abcdef;
>
> Maybe overkill, but we can use a fast string op for this.  I think
> I got the union right?
>
> static void populate_msr_list(struct vmx_msr_entry *msr_list, int count)
> {
>         union {
>                 struct vmx_msr_entry msr;
>                 u64 val;
>         } tmp;
>
>         tmp.msr.index = MSR_IA32_TSC;
>         tmp.msr.reserved = 0;
>         tmp.msr.value = 0x1234567890abcdef;
>
>         asm volatile (
>                 "rep stosq\n\t"
>                 : "=c"(count), "=D"(msr_list)
>                 : "a"(tmp.val), "c"(count), "D"(msr_list)
>                 : "memory"
>         );
> }

:-). I do think it's overkill. However, I'm OK to apply this
suggestion in v2 if everyone is OK with me adding a comment that
explains it in terms of the original code, so that x86 noobs, like
myself, can understand what's going on.

> This is a misleading name, e.g. it took me quite a while to realize this
> is testing only the passing scenario.  For me, "limit test" implies that
> it'd be deliberately exceeding the limit, or at least testing both the
> passing and failing cases.  I suppose we can't easily test the VMX abort
> cases, but we can at least test VM_ENTER_LOAD.
>
> Distilling things down to the bare minimum yields something like the
> following.

Looks excellent overall. Still not clear what the consensus is on
whether or not to test the VM-entry failure. I think a flag seems like
a reasonable compromise. I've never added a flag to a kvm-unit-test,
so I'll see if I can figure that out.
