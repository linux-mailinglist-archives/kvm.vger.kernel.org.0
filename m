Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9C61A615E
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 03:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgDMBoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Apr 2020 21:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgDMBoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Apr 2020 21:44:09 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D39EC0A3BE0;
        Sun, 12 Apr 2020 18:44:09 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id d7so1314951oif.9;
        Sun, 12 Apr 2020 18:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rwti06vb5lRdBtad4E0/CyJvrpAjoH4RrByLU2L2iPE=;
        b=pxCNhvJQxN6aAvubqK2fcAbaftKWB5O28XIL1wZd9BEF10RVq0W+j5YDWgkz2Al8+l
         Ioz/YDBrrR9Hs7b7D3dh+Evyroz1bQxy83mm/gl0qVEManEfQXHRqLhUbBwkFZLi1ffm
         EDuv0qkPud2VwC5QJfcfT4RoXpwbp5A172tCm/77ZB/hiZUDQVS2Y6jvSCHZ6qjb4i0e
         4q4SJgxJ38iBybKqJo94aLHzcjAs+NZ1STCSh3QypvlrhgPscsp4cI0UR3IX4qpi94dF
         vm/vhxXnPRqQkMz9/xoe5PVOrzr7Ekn68BfoZdLZ1TrXIlF3barxblo7ox2U8q5a41wv
         ENag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rwti06vb5lRdBtad4E0/CyJvrpAjoH4RrByLU2L2iPE=;
        b=mzjA/IAy6OTEa/3Ryg9hEMWf1ytB0vWUH6Iw5pm8UQlJPSObNyFAji753c44XqgOh1
         SVt4uHxnDdN+OMbJrz8c1ynb0/e4K1yqBmw0JX2W5UsGhOWK8gR+KnkI5pSAXZhPEniU
         EwBKPTCCIB1inaHeeKRd/cljAHq75tzSvVwm0yBGcHBkDHoUisASPaHumwY3dC/L+ACy
         nNaRtmSh622WKNLlmSn9K9ZvS3lUQDAq3G98yJfUA3Z8xMMT8h26sK7mme+f9LdYBi9u
         oickyXdxTXCRYj1Ck8P5SOihxYand5LygFAycqdHwA0U4QKJypfv+DpEPZ7zpsMV2OeV
         Xaew==
X-Gm-Message-State: AGi0PuYPePh72Mzp0JEkfub8FP9DJlEzKRJymtnB5iK85B0ol5/WyUyR
        03gRQRNtlcUewgGYhc0ThI6DggLAPLansX2Y7yM=
X-Google-Smtp-Source: APiQypJYK7M4cNTwjnnBOSVwrcS1AmfI9ZLNIr/LCaNeENPvXPZ4HOAie8bEQVuECe5f+Ebi8ShBQqmed/NZWzW1aqw=
X-Received: by 2002:aca:f1c6:: with SMTP id p189mr8985141oih.5.1586742248324;
 Sun, 12 Apr 2020 18:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <1586480607-5408-1-git-send-email-wanpengli@tencent.com> <e639e0f6-9393-7a32-9e2d-13725d7d96f8@redhat.com>
In-Reply-To: <e639e0f6-9393-7a32-9e2d-13725d7d96f8@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 13 Apr 2020 09:43:57 +0800
Message-ID: <CANRm+CwfLuzCTBd9TdDVqrmaEFFxDLVdNbaLHcq_ejQaMUaqKA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: X86: Ultra fast single target IPI fastpath
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Apr 2020 at 23:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/04/20 03:03, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > IPI and Timer cause the main MSRs write vmexits in cloud environment
> > observation, let's optimize virtual IPI latency more aggressively to
> > inject target IPI as soon as possible.
> >
> > Running kvm-unit-tests/vmexit.flat IPI testing on SKX server, disable
> > adaptive advance lapic timer and adaptive halt-polling to avoid the
> > interference, this patch can give another 7% improvement.
> >
> > w/o fastpath -> fastpath            4238 -> 3543  16.4%
> > fastpath     -> ultra fastpath      3543 -> 3293     7%
> > w/o fastpath -> ultra fastpath      4238 -> 3293  22.3%
> >
> > This also revises the performance data in commit 1e9e2622a1 (KVM: VMX:
> > FIXED+PHYSICAL mode single target IPI fastpath), that testing adds
> > --overcommit cpu-pm=on to kvm-unit-tests guest which is unnecessary.
> >
> > Tested-by: Haiwei Li <lihaiwei@tencent.com>
> > Cc: Haiwei Li <lihaiwei@tencent.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v1 -> v2:
> >  * rebase on latest kvm/queue
> >  * update patch description
> >
> >  arch/x86/include/asm/kvm_host.h |  6 +++---
> >  arch/x86/kvm/svm/svm.c          | 21 ++++++++++++++-------
> >  arch/x86/kvm/vmx/vmx.c          | 19 +++++++++++++------
> >  arch/x86/kvm/x86.c              |  4 ++--
> >  4 files changed, 32 insertions(+), 18 deletions(-)
>
> That's less ugly than I expected. :D  I'll queue it in the next week or
> so.  But even though the commit subject is cool, I'll change it to "KVM:
> x86: move IPI fastpath inside kvm_x86_ops.run".

Thanks.

    Wanpeng
