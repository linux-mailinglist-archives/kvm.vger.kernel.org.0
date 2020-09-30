Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC3727F16C
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgI3ShL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729484AbgI3ShL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:37:11 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31647C061755
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 11:37:10 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id m17so3074391ioo.1
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 11:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=siO3Ww0UuN5awZ2/4Q5j7OZO9fAp8wT77tzaQkVz9ls=;
        b=T8SfNyHQgRssrwuMGSNe1Hy/76JeGn2jrPuT+PfCKTcMA+kHHXx4IEX5rcbeHKij7B
         oMn52MBkpnsqi1o4exKmNOUjzWgl7Lezy8pZ99oQicQynhRlyIy5aZ5F82im+qGqEgjp
         4nVSf5F66vWxWpvScXVvyiVKdKv/hGTHdQD+gBMNfX88OkQkJUnd6IBB3WLSl6U3pOSd
         iz1go36055uPNZQ9b58FWuDpUlqWl5hU/zwiqtX7K0npYdqjtB1rpnO1FXHa82awerZn
         qaV/44+3IrMo9sQcjBhq4cDXLwRTP5GGPXM+vaoz0Gq/f+UjWtk6q4iGPBXjrPBuyOC2
         vEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=siO3Ww0UuN5awZ2/4Q5j7OZO9fAp8wT77tzaQkVz9ls=;
        b=oy2pbJcVaqU1v+S0nqQrm9eXIwBE4Va6ekeKfh45+zeK0UhoVX+0RfJQev6fhJogfN
         26/LII4Merb5tbe2a6EfIK1dZDakLR7IrFwqK6RyEiqCIJyjieRxS8xTonAosrKN5JtS
         knT4rPeymTNHWHR0xl4MSfRYSjDC1xSAiZ7hsk+aB+QP+J3SX5ocuI7vCOVxUqfn+IPA
         kVgYh6EyRq1X9//l5PSLqKEllU2w/BL7KS6p/GRMPKM0XSW7PSGOfc7SgbOwbMxaNqSN
         TsXMQE8kvISG9+Om/pwYk1yoJYFoNTgslyAjG17KwG90X79whFsjfocunV00T2U0uN6M
         CzaA==
X-Gm-Message-State: AOAM530ToUr35OJOKep5d/UrfgUGeb0F53c1MmQTLjBYjSUtzBXhFYTl
        WTblm1vNsICN2NlcQTuOSKKgKlFVGQGn3JEU0Q5pmw==
X-Google-Smtp-Source: ABdhPJyrDW/AxccGOy65cPaYmmkijKPXeqYJQd2vflxz3Oebc2oWK2N+MGk2VZheSovYTphfB9JJpHAFymDelDyt1+A=
X-Received: by 2002:a05:6602:2d55:: with SMTP id d21mr2647330iow.134.1601491029262;
 Wed, 30 Sep 2020 11:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-4-bgardon@google.com>
 <20200930053430.GE29405@linux.intel.com>
In-Reply-To: <20200930053430.GE29405@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 30 Sep 2020 11:36:58 -0700
Message-ID: <CANgfPd-ErY5BgPooX0URYY1SFpLADJ9UfHKYQJsuE4JNh6dKRQ@mail.gmail.com>
Subject: Re: [PATCH 03/22] kvm: mmu: Init / Uninit the TDP MMU
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
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

On Tue, Sep 29, 2020 at 10:35 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Nit on all the shortlogs, can you use "KVM: x86/mmu" instead of "kvm: mmu"?

Will do.

>
> On Fri, Sep 25, 2020 at 02:22:43PM -0700, Ben Gardon wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > new file mode 100644
> > index 0000000000000..8241e18c111e6
> > --- /dev/null
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -0,0 +1,34 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#include "tdp_mmu.h"
> > +
> > +static bool __read_mostly tdp_mmu_enabled = true;
> > +module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
>
> Do y'all actually toggle tdp_mmu_enabled while VMs are running?  I can see
> having a per-VM capability, or a read-only module param, but a writable
> module param is... interesting.

We don't use this much, but it is useful when running tests to be able
to go back and forth between running with and without the TDP MMU. I
should have added a note that the module parameter is mostly for
development purposes.

>
> > +static bool is_tdp_mmu_enabled(void)
> > +{
> > +     if (!READ_ONCE(tdp_mmu_enabled))
> > +             return false;
> > +
> > +     if (WARN_ONCE(!tdp_enabled,
> > +                   "Creating a VM with TDP MMU enabled requires TDP."))
>
> This should be enforced, i.e. clear tdp_mmu_enabled if !tdp_enabled.  As is,
> it's a user triggerable WARN, which is not good, e.g. with PANIC_ON_WARN.

That's a good point.

>
> > +             return false;
> > +
> > +     return true;
> > +}
