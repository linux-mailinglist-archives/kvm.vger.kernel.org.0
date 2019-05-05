Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1466213C72
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 02:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfEEAmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 May 2019 20:42:42 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37902 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfEEAmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 May 2019 20:42:42 -0400
Received: by mail-ot1-f66.google.com with SMTP id b1so8538028otp.5
        for <kvm@vger.kernel.org>; Sat, 04 May 2019 17:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jeQ0HZPBCt2G/YlOyC7w06hA9OEWaOr8t0jhlCW28Uk=;
        b=Ph9PvZjqS5ZEvJQwjLwVpbLCwjyDwXns1oIO24T8CXwpImZa8If9RvZgqTxJ9EVyAT
         O6mctlsjywvjCmcz9ecQ4hiqmMoNkC5hul9v4FAv+u65IynNAXUTjDcTnBBwIDBWaBSt
         5jyd/6LqtClgb3KHm0eUMXHXbmcfJYq+A2dXnArPqtU3VFq531Rccsn3cNG+uFbipqje
         xz0MH2nZOxatpjiSdWqA0blBFHsmo607n7Xpt4kSO/GBOq0/JaiaNuF7+ADHeAjG2K8q
         ly0PTXJiGARy/KJtMYbJlXd07chhS/qD8AqI9vwrp96a9PxzP+S/whmyUvWrNY3M8O7h
         BpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jeQ0HZPBCt2G/YlOyC7w06hA9OEWaOr8t0jhlCW28Uk=;
        b=ZweSTzFfupUuZGastyjtNnMfqpDim56pAo93ypp+P054Ec0pY64JKqZ8/f3NRW0WDZ
         Ow/cZkTzB8yXdhl6eE0b2UrOH2iDKmeQHC0H2e/7T3hD+HqGTjkz2ZLkg4c3JKmiGFOa
         UKpZSE7ucfmGqiNPoB+29tmwsubF0W2aUWDMLqvw1JgmGsOGU2CSwRDK/bTZh+GwkCnR
         e2q7n9z2BC+WfVFBtbX0lWSn0VCFFHEgtJV/YKm6/oTMKmIVV/Enb5JgA7RpP1ubNfA3
         POo7+3NVY8tJ25rm5uUo1F1nr/sv++jPnEKWvYuchguDMDL03TEUv9sTwr8UVBmWcXxW
         6q7g==
X-Gm-Message-State: APjAAAVdFujr5omEiMdRve5fLBpecMkexX+e8hvj7L7B/uh45gABkbJG
        JHhxq9zDZJQr+hWRAJxJ1OW7FHPaDmKdS1RsQY4=
X-Google-Smtp-Source: APXvYqxMyi5OnlHeKlsFNSXNoHVn6A75E+mjycI9iKvAU1a1YxAgUeouvpuuuMnyTDcXk3OlNVhAypmAiid+d0q7+zI=
X-Received: by 2002:a9d:5882:: with SMTP id x2mr8513002otg.49.1557016961473;
 Sat, 04 May 2019 17:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190417171534.10385-1-sean.j.christopherson@intel.com>
 <CANRm+CxcmjzV_6q-nf59dZ+4nbifM389kqQy514XFDQSKjxZvg@mail.gmail.com> <20190430193102.GA4523@linux.intel.com>
In-Reply-To: <20190430193102.GA4523@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sun, 5 May 2019 08:43:24 +0800
Message-ID: <CANRm+CyUbJM8syuF1FGhrM4nSQgB_KUYsLNg3nr7RT2vzbuxfw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] KVM: lapic: Fix a variety of timer adv issues
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 May 2019 at 03:31, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sun, Apr 28, 2019 at 08:54:30AM +0800, Wanpeng Li wrote:
> > Hi Sean,
> > On Thu, 18 Apr 2019 at 01:18, Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > KVM's recently introduced adaptive tuning of lapic_timer_advance_ns has
> > > several critical flaws:
> > [.../...]
> > >
> > >   - TSC scaling is done on a per-vCPU basis, while the advancement value
> > >     is global.  This issue is also present without adaptive tuning, but
> > >     is now more pronounced.
> >
> > Did you test this against overcommit scenario? Your per-vCPU variable
> > can be a large number(yeah, below your 5000ns) when neighbour VMs on
> > the same host consume cpu heavily, however, kvm will wast a lot of
> > time to wait when the neighbour VMs are idle. My original patch
> > evaluate the conservative hypervisor overhead when the first VM is
> > deployed on the host. It doesn't matter whether or not the VMs on this
> > host alter their workload behaviors later. Unless you tune the
> > per-vCPU variable always, however, I think it will introduce more
> > overhead. So Liran's patch "Consider LAPIC TSC-Deadline Timer expired
> > if deadline too short" also can't depend on this.
>
> I didn't test it in overcommit scenarios.  I wasn't aware of how the

I think it should be considered.

> automatic adjustments were being used in real deployments.
>
> The best option I can think of is to expose a vCPU's advance time to
> userspace (not sure what mechanism would be best).  This would allow
> userspace to run a single vCPU VM with auto-tuning enabled, snapshot
> the final adjusted advancment, and then update KVM's parameter to set
> an explicit advancement and effectively disable auto-tuning.

This step is too complex to deploy in real environment, the same as
w/o auto-tuning. My auto-tuning patch evaluates the conservative
hypervisor overhead when the first VM is deployed on the host, and
auto-tuning it only once for the whole machine.

Regards,
Wanpeng Li
