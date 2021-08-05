Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EE33E1EF7
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 00:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbhHEWln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 18:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbhHEWlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 18:41:42 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A46C061799
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 15:41:27 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id y18so9484590oiv.3
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 15:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W6BTOjcwKtKl0uQi0y8Ng/8QeGorP9K0iLhSOOFlArw=;
        b=QaHjuew+SIOlrssVbOYT0yWUXJGg0GXSpEcSq01oThCukuydoXGMNJ+aYOKtFOZZ8V
         0l+MJWKPubU4yWxEnDYYtIPrjvHBVapwuLp1lzuld7cFgQwLFVt0TjKjrKjjSYSMeN2s
         2a/j4uEILP+krg3gNJpyArZkXie5smI2nnc1WWY6Q75XCoxwof7qfNS6zE5q36tWL+g9
         Q4m5hE2BPofrCNQeHmmixvWevrtp2CZzOfKuIArb1oZC4s41LdokuitbV4mfBBq5k49e
         hkiUfanTbhpRFiUoY0PpCSEzwtNn6RP01EtZLjuQ8/IRFfeZOnmUqKbOezkadebBihE+
         3HGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W6BTOjcwKtKl0uQi0y8Ng/8QeGorP9K0iLhSOOFlArw=;
        b=lu9fBPhUxhrd6dbiPrM58zMkN7Nma/JwqAjdZIxm6ig6Ho98w9Htvb8E8Tq55EreBT
         xX2BL3DRTnPUC00aIxW14Pyu1dgZhMjihCL7f80WauzeGEmeTyvlWcC8gLG0h/F2Q/g4
         KqsrxErxLzW488yeFLHL24Q1fAolZsry0Ays8NerdrN4GpLLAzJM6064xTwWY3EfJkM9
         5EvymXxYajz5MMJa7y7oV7r6+JhNx1Yk2U0nhWg7uZPYr6ldCHg90/6B55Cp3SFC2XVL
         bdK70fUpMgG9+WJPKD/sglBi91NF82Q6WBw3/pZcKk+WrsLKsgev/D6YB6l7WzdEwqs9
         uQeA==
X-Gm-Message-State: AOAM533A8BDutvCLRZsy8ISz8Rg5KQY29bg4Gg8SGJV0FCy7yCStIwn7
        6vFNU+5UwS6469QUw+8m7Hv5R98qPkBpdkYNGs9/HQ==
X-Google-Smtp-Source: ABdhPJwvo6Dlk68BubLUOKlYbKPP4T0XkImWMs4hnKt+7rmO5CD9g6pn8afWlK1rdkN+6LKPiOgB6s1KlUGlJ8DtN/4=
X-Received: by 2002:aca:6704:: with SMTP id z4mr13052848oix.13.1628203286750;
 Thu, 05 Aug 2021 15:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210805151317.19054-1-guang.zeng@intel.com> <20210805151317.19054-4-guang.zeng@intel.com>
 <YQxns0wQ74d4X5VD@google.com>
In-Reply-To: <YQxns0wQ74d4X5VD@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Aug 2021 15:41:15 -0700
Message-ID: <CALMp9eQ-ZQQ36F9ffTL7Y=r_2k-wzFjade--3TKBwC2vomH2YQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] KVM: VMX: Detect Tertiary VM-Execution control
 when setup VMCS config
To:     Sean Christopherson <seanjc@google.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 5, 2021 at 3:35 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Aug 05, 2021, Zeng Guang wrote:
> > +u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
>
> Make this static and drop the declaration from vmx.h, there's no nested user (yet),

I assume that this feature isn't actually virtualizable, since it's
based on posted interrupts, which are not virtualizable.
