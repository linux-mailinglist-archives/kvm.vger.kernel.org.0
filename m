Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED323E5011
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 01:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhHIXkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 19:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbhHIXkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 19:40:12 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C74FC0613D3
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 16:39:51 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id x192so32857081ybe.0
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 16:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z2sv71HcZIH8w7D7A/0VLfE0bixNsEfaj8nrBK5Ia/4=;
        b=F/alD07719E2mkeZgWEmK+Eo5daOtDtHehShv5eD43zAsP3Kb3G87QtYVLh5TnKP71
         pQHGPWoR1lrjlG0Y9Ic0OKDoGUFUZssu0u0K5e5z4gAI6Ko4rA1/3qGwVuzlpFdTDMZz
         ZKkooqURDu7lOA/XYwe+D8PnlayGmHmxKTF+m7QvalhOWL8UcEJLf9ASk3ZNU1X1MBws
         HjvABe5UzhplC0ye47QP2k9+pQqb9WgphG3YlKEUe/Xo+qSvCj7Bkn8U7mzZpHZmRS2z
         M3qhDBMQm99MehVHuC1snHxmRAWn70YepAxV+1c24mvFczpVl3+I3G2sCdp6uEiKA3X3
         lYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z2sv71HcZIH8w7D7A/0VLfE0bixNsEfaj8nrBK5Ia/4=;
        b=EFjjZ6NHKs5ONpYGe+Ts13+yWJkN9B4NtL4UW+hNaPvKKOmjQT8FvR+lXLCfOl3LU0
         rAGiICkdJj9IN9AMh1E3I+8EfMIoLmf/EtTg8HYG4T9sJRfnxJLagLBQ1w9HmELzCAvm
         Se2kHyJDffIbTVkXTZYGtNu7NGfpBbuFrhD+B4Y+24yzYRabjlQPe8H24ykbcntLulEX
         b0BARXAANevrw0p45ygNtc6fyCfgL6Scda5bQP0jlyjRPLrHZICy4S6yRYPo8uYz/Cak
         4nUpwLvtRFvdzn6un6ana0yXYN0IaRS8bM+cQNehWEcSbazssr55oiEZKwauHUqGbOzN
         eZHQ==
X-Gm-Message-State: AOAM5328ouFNaSpxYLvETrskqRGkLE/gLjZ5JptPSZsl7pjL/HWAvOpO
        bh6H7vqilqhffTSl6r7K0R4cWi+FxPxu2vEgDRJUbQ==
X-Google-Smtp-Source: ABdhPJxWYxhydUIWOD3ZzWBo89a1UYk5eGApGILG8emt1qHslvSuVQgxJHDMpMSrHMfszqLA3lthBo5TbtWQo4FKVtI=
X-Received: by 2002:a25:694a:: with SMTP id e71mr26414477ybc.114.1628552389863;
 Mon, 09 Aug 2021 16:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210803044607.599629-1-mizhang@google.com> <20210803044607.599629-4-mizhang@google.com>
 <CALMp9eR4AB0O7__VwGNbnm-99Pp7fNssr8XGHpq+6Pwkpo_oAw@mail.gmail.com>
In-Reply-To: <CALMp9eR4AB0O7__VwGNbnm-99Pp7fNssr8XGHpq+6Pwkpo_oAw@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 9 Aug 2021 16:39:38 -0700
Message-ID: <CAL715WJLfJc3dnLUcMRY=wNPX0XDuL9WzF-4VWMdS_OudShXHg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] KVM: x86/mmu: Add detailed page size stats
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim,

No, I don't think 512G is supported. So, I will remove the
'pages_512G' metric in my next version.

Thanks.
-Mingwei

On Mon, Aug 9, 2021 at 3:26 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Aug 2, 2021 at 9:46 PM Mingwei Zhang <mizhang@google.com> wrote:
> >
> > Existing KVM code tracks the number of large pages regardless of their
> > sizes. Therefore, when large page of 1GB (or larger) is adopted, the
> > information becomes less useful because lpages counts a mix of 1G and 2M
> > pages.
> >
> > So remove the lpages since it is easy for user space to aggregate the info.
> > Instead, provide a comprehensive page stats of all sizes from 4K to 512G.
>
> There is no such thing as a 512GiB page, is there? If this is an
> attempt at future-proofing, why not go to 256TiB?
