Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43AE285B8D
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 09:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731479AbfHHH2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 03:28:33 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39376 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730887AbfHHH2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 03:28:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so1327215wmc.4
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 00:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xiVY9iuP5vAlkyRcgL+U1nX4ToWVpN5pmtcBsDNGHgo=;
        b=LBiiPips/GL+hvZVGwEOhPUTCiBh7ax4ZcAdbWcpjr22TF9G0imRJwaNsZsxOs/92q
         4o19iz9fxXALkbaOC2n5234gpd0Fkr8YYOxdgZvf2ih6CvbsFG68q1iQgnlJf3Xt5HAS
         DBPGycmYe+gKc1Ot87GMk+OS8XFK/13LOSZoTBHsAQyvqSOsdq5roI0vFThuPtXEYfze
         eQfv0kJsNK6Mz2LaXe6Z9DbNB0KSNCkjcfTIkLLyiE8uE+NE9Pnut7kuBeyTJO8CDygR
         hdRX26Q6Z5C8wCcpqSBfaBmWyiWVrBByhlCIUqyyYs4Wcta4vfbPuii0iyJmMFfnU0jm
         /3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xiVY9iuP5vAlkyRcgL+U1nX4ToWVpN5pmtcBsDNGHgo=;
        b=tC2tLv5xLqb5L1m65HHOkB4Pcw5KhaUWX/k+6YwoWDuzE6x7vwOUcH8DeLi/ybMbAl
         BC3Rt6lcr6iZkhiUxLSMdoiXdWECz55qttegJ1g4uKhX+Ml8kNevzLPTvUY8lrgYhdt/
         flX4DozcN7QsnXgF54Z7eP2FfMxnK+QjGohVHoH8g4/tYG1A6laLtc0v3RtHHYhnB4oD
         tpSMRZPf9AdF5x08wZb2FXfIRJ08TbEuegZkxvByzd+oTEntWjZ6qyq1cJz3dFnAXcib
         TGKF1jEYA81J1OZynW8oPGGBkq1tfHW7whjBSq54qEn7Xg3A4qf1SGGiPH+xEY/hNnKS
         A2yg==
X-Gm-Message-State: APjAAAXiM6+imYOpzM4viR73kj1zSyc6PwCGJp0l8AWVA2xdEDXlOBZL
        e18VYGz2oH+qM1i4z3s48GZwUWZavAfeK5/y1SM=
X-Google-Smtp-Source: APXvYqwXKcwm73bXJS3p0UnD3Cp3VfoNcDWrs7jEQs2dkcx16BsXlw0N6wkACgz5uwGE2Pa3RX1yZF4TQZfaDWY6V3E=
X-Received: by 2002:a1c:345:: with SMTP id 66mr2642236wmd.8.1565249310451;
 Thu, 08 Aug 2019 00:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAHyh4xhDZdr0gOJCrSBB5rXYXw7Kpxsw_Oe=tSHMCgi_2G3ouQ@mail.gmail.com>
 <20190807235423.GD16491@linux.intel.com>
In-Reply-To: <20190807235423.GD16491@linux.intel.com>
From:   Jintack Lim <incredible.tack@gmail.com>
Date:   Thu, 8 Aug 2019 00:28:19 -0700
Message-ID: <CAHyh4xgY79eD+M_a19hqcJ84EDo6tjFJScKrO_JPVsRpZ4E_JA@mail.gmail.com>
Subject: Re: Why are we using preemption timer on x86?
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     KVM General <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 7, 2019 at 4:54 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Aug 07, 2019 at 02:52:19PM -0700, Jintack Lim wrote:
> > Hi,
> >
> > I'm just wondering what's the reason why we use the preemption timer
> > instead of emulating VM's timer using hrtimer in software? Is there
> > anything the the preemption timer can do that can't be done with
> > hrtimer?
> >
> > I guess the x86 architecture provides the preemption timer for *some*
> > reason, but I'm not sure what they are.
>
> Assuming you're referring to Intel/VMX's preemption timer, programming
> the preemption timer and servicing its VM-Exits both have lower overhead
> than going through hrtimer.

Yes, I was referring to the VMX preemption timer. Thanks for the
pointer. It's very nice to know!

Thanks,
Jintack

>
> commit ce7a058a2117f0bca2f42f2870a97bfa9aa8e099
> Author: Yunhong Jiang <yunhong.jiang@gmail.com>
> Date:   Mon Jun 13 14:20:01 2016 -0700
>
>     KVM: x86: support using the vmx preemption timer for tsc deadline timer
>
>     The VMX preemption timer can be used to virtualize the TSC deadline timer.
>     The VMX preemption timer is armed when the vCPU is running, and a VMExit
>     will happen if the virtual TSC deadline timer expires.
>
>     When the vCPU thread is blocked because of HLT, KVM will switch to use
>     an hrtimer, and then go back to the VMX preemption timer when the vCPU
>     thread is unblocked.
>
>     This solution avoids the complex OS's hrtimer system, and the host
>     timer interrupt handling cost, replacing them with a little math
>     (for guest->host TSC and host TSC->preemption timer conversion)
>     and a cheaper VMexit.  This benefits latency for isolated pCPUs.
>
>     [A word about performance... Yunhong reported a 30% reduction in average
>      latency from cyclictest.  I made a similar test with tscdeadline_latency
>      from kvm-unit-tests, and measured
>
>      - ~20 clock cycles loss (out of ~3200, so less than 1% but still
>        statistically significant) in the worst case where the test halts
>        just after programming the TSC deadline timer
>
>      - ~800 clock cycles gain (25% reduction in latency) in the best case
>        where the test busy waits.
>
>      I removed the VMX bits from Yunhong's patch, to concentrate them in the
>      next patch - Paolo]
>
>     Signed-off-by: Yunhong Jiang <yunhong.jiang@intel.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
