Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9653B94E1
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 18:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhGAQxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 12:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhGAQxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 12:53:54 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CB0C061762
        for <kvm@vger.kernel.org>; Thu,  1 Jul 2021 09:51:22 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id a11so12935886lfg.11
        for <kvm@vger.kernel.org>; Thu, 01 Jul 2021 09:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u/hjpLVuaEGZlBnwx66V+m10vVt/P55zQuMmba4vINk=;
        b=FX+qn8otateyP9ykbIaQwiEdLNrowoqGjwt1nyavSmCYGKyU/Fv5ZZRTEEubA6Sn7/
         xnJNVvnRKZ9hwdvdi8/zyPn+HR6+vUzaMYvBPZDf0iU/2zgXmoChqk5gFUTuHU+7hgS8
         HS/iULSldQ+0yo7rcUePbWfTqf8q7CywLbX/jL7ol4cQtLwxgsDijoPqyybEDpgUc351
         PQiG+1tbJZ9Enm/44EHpg6UbWIT92gH0ID3nhOOFe4YLxfIHAJbnYMz/FCRYhvc4Z784
         /NkfgMz1D0gxUWCznDaG15w7hRtD4yHC/MeAtDZ03P3fCu6ptihLEpDcBuWm98IMGtQx
         YTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u/hjpLVuaEGZlBnwx66V+m10vVt/P55zQuMmba4vINk=;
        b=l5Die4WI6wpkc9DJ8MyYjmHQozTguP4fBiVVcUCBWmzKtH38ve71EmcMzktRw7Uycn
         OOHQdABPY1dodLA2tmpITi/wrAbsovbepwtyD3xe7Q+nQuroPl4V5Pdp7qSsw2Pjk5FK
         aqEXjaFZ8ONtYWFm04/HuYfiNdA7aoaHlavQ/GFhRZk+JmI8m+8BUWdbWdH8o2ZUc5Vb
         08B0QxDAcIgWjQfh1P32l2Y/MW+sFzoMdWuPm10PsPfg8YP/z/PH7JbnLX8MOOp6s7d+
         7MxXomvlPVmYACyCApBR/E14x9c7e4h76Vc5/G0mbYUzR3Q58bldkLhD/DZE18d9EUae
         B+7A==
X-Gm-Message-State: AOAM531n0ks79lCTdTHD6QoM5hMsg7vbO1F0RE3hEA30PX1UQpUvHAbC
        G2IwUbtw+lWEsWlTGmFsCClr5CLCuyzeUo7i8wWgCg==
X-Google-Smtp-Source: ABdhPJzuaM7t1ejwWkbjogz84j+yGhIL9YJPpxK0n7LeHHZKaYhSVAT18rwmZS4cVMLd63Lcic86m/YKjsY96TmT9cg=
X-Received: by 2002:a05:6512:3f17:: with SMTP id y23mr420528lfa.406.1625158280652;
 Thu, 01 Jul 2021 09:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210630214802.1902448-1-dmatlack@google.com> <YN0XRZvCrvroItQQ@casper.infradead.org>
 <CABgObfZUFWCAvKoxDzGjmksFnwZgbnpX9GuC+nhiVLa-Fhwj6A@mail.gmail.com> <YN2wLHWpNkLXvDEB@casper.infradead.org>
In-Reply-To: <YN2wLHWpNkLXvDEB@casper.infradead.org>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 1 Jul 2021 09:50:54 -0700
Message-ID: <CALzav=f6acVN8kKctWDDQsjjSb2yHk9gdXkeQBSv+YakR=_Niw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] KVM: x86/mmu: Fast page fault support for the TDP MMU
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>, Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 1, 2021 at 5:08 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> Now I'm really confused, and I don't understand why I was cc'd at all.
> get_maintainer.pl going wild?

Apologies for the confusion. I could have made it more clear why I
cc'd you in the cover letter.

I cc'd you, Yu, David, and Andrew (Morton) since this series
introduces a new selftest that uses on page_idle and you recently
discussed removing page_idle. See the second paragraph of the cover
letter with the link to your page_idle patch, and patch 6 which
introduces the selftest.

I will make it more explicit in the future when cc'ing non-KVM
developers on my KVM patches.
