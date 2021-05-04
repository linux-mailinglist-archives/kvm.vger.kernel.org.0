Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35576372EEC
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhEDR3f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhEDR3e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:29:34 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2FDC061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:28:38 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id di13so11401809edb.2
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nSjAAu8/uv2OHnvht3tsCA/NqO7UE0bjKWBDG7VyVvs=;
        b=fR+qBddIZH/jxUspHZqc2eSdJx08Os3neWEKcaxQHMt+9ypWw6vZq//LjxaT/Q6VAd
         1+u3o6EoIDeKvuQxbNTlCKOT9PT8CFxOPjUwEbCrAA9GC9Qiw7HxBW6AGlFF70RIc4Dz
         tLi2r65CF7MVh5bcUWd2RP5tqbKiQmlaV9lFgBwEKm3ShCg3dAUNU9fUa20lmv5czMtA
         jKzRNwpon3/Z5MC3oIwK8T+Q+UjRpzJK5raqx3e35nsa1Up+In/TiarYlMQc2AKNGtkW
         n9aDMkbRF8jG1sr6+IyDhwwmR9E/WcNl3yUx+xSSNsJF23vvqi7R2jrWFWKx890V8Ycj
         dWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nSjAAu8/uv2OHnvht3tsCA/NqO7UE0bjKWBDG7VyVvs=;
        b=UidJVwPtCgyBsmP1ZfiCXc1M4m+n3AjOb9V5Mc5NOOcgGPwYPMtuSs3I5oalGbS8kU
         oYkNKf1IH19pZJL2VGihF7k5ns67W/7ElaRZg+87KTbCGv0rZpx4yIjD+e+HO4OMRPIN
         s033B5LpIUGIzBiEB5+xy6Sofvv1bMSgJdtkkWxSRJjd/P8kdVdpBC7d+jVt7oZ5NiKd
         se6gsmq0hW3WVzdWu1R0B7QnMBIbf7S0Z69OCr56WD756ERV5LfVXSd3XLg3T9MWYRUG
         wdzfH5Ye6v9PDtrdbf6jycoXdjuQ5CmGJuPt6/4fdWzmeDq/JE98koVhbG9c+AWWKw1P
         T84g==
X-Gm-Message-State: AOAM530M6uDtFjLD1TwG4N2/7wZCUWeADk+6LPxu5MWvNP+D/XKIouHB
        0ZU2l3McnKXFPf3unbW9Y5gkUcxQMNMNaJDQ3NsQsQ==
X-Google-Smtp-Source: ABdhPJxy3F9kuj96l3542ArNSwjtRexrVmjr1qVyuHJmdi3SyQzBLcvCQ8hHf1Gq5IXKagI+jaqgkNTZfgtYHAsbpkI=
X-Received: by 2002:a05:6402:3090:: with SMTP id de16mr27183674edb.177.1620149317162;
 Tue, 04 May 2021 10:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210429211833.3361994-1-bgardon@google.com> <a3279647-fb30-4033-2a9d-75d473bd8f8e@redhat.com>
 <CANgfPd-fD33hJkQP_MVb2a4CadKQbkpwwtP9r5rMrC_Mripeqg@mail.gmail.com> <4d27e9d6-42db-3aa1-053a-552e1643f46d@redhat.com>
In-Reply-To: <4d27e9d6-42db-3aa1-053a-552e1643f46d@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 4 May 2021 10:28:24 -0700
Message-ID: <CANgfPd_EvGg2N19HJs0nEq_rbaDJQQ9cUWS9wEsJ5wajNW_s7Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Lazily allocate memslot rmaps
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 12:21 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 03/05/21 19:31, Ben Gardon wrote:
> > On Mon, May 3, 2021 at 6:45 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 29/04/21 23:18, Ben Gardon wrote:
> >>> This series enables KVM to save memory when using the TDP MMU by waiting
> >>> to allocate memslot rmaps until they are needed. To do this, KVM tracks
> >>> whether or not a shadow root has been allocated. In order to get away
> >>> with not allocating the rmaps, KVM must also be sure to skip operations
> >>> which iterate over the rmaps. If the TDP MMU is in use and we have not
> >>> allocated a shadow root, these operations would essentially be op-ops
> >>> anyway. Skipping the rmap operations has a secondary benefit of avoiding
> >>> acquiring the MMU lock in write mode in many cases, substantially
> >>> reducing MMU lock contention.
> >>>
> >>> This series was tested on an Intel Skylake machine. With the TDP MMU off
> >>> and on, this introduced no new failures on kvm-unit-tests or KVM selftests.
> >>
> >> Thanks, I only reported some technicalities in the ordering of loads
> >> (which matter since the loads happen with SRCU protection only).  Apart
> >> from this, this looks fine!
> >
> > Awesome to hear, thank you for the reviews. Should I send a v3
> > addressing those comments, or did you already make those changes when
> > applying to your tree?
>
> No, I didn't (I wanted some oversight, and this is 5.14 stuff anyway).

Ah, okay I'll send out a v3 soon, discussion on the other patches settles.

>
> Paolo
>
