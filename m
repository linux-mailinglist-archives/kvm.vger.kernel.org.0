Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0296A3C10A
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 03:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390786AbfFKBos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 21:44:48 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38138 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389168AbfFKBos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 21:44:48 -0400
Received: by mail-oi1-f193.google.com with SMTP id v186so7730366oie.5;
        Mon, 10 Jun 2019 18:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EBarjJh8uVzKHhlG9hBvipdn1U2btzfvAG+mGnyJE/s=;
        b=IcS7ZWjy7l1IhNBfOmuDgIBqPeFMKztzk14fOpvzbgBf5LhncMCWPT2npZhKCYCVLL
         3h13e/9i+DqPpCi03FquEfMzkMGpP/zNuNImWpQMEsqwazGc9pv7g79XPGc3wcXK5dSO
         LQoxUixsgbsUj/VkiGeORK6dNHGpQ/w/1z0QAtTv7ytVGa5GpXHZX6hzsG/KASt17NWw
         TlMbfLKSBCN3X3bjLK6FitH6cmxkzN7I+RBBz4cbjiALZoPIbl3ycDfp3Wm7+3+SxTay
         dgZWHQ7jqx+2Uv7Q1uOrs8sx3iybsFaaKSUx54bosbVpWfZ7r03kcTOTEiE4ZTXalCVM
         XlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EBarjJh8uVzKHhlG9hBvipdn1U2btzfvAG+mGnyJE/s=;
        b=DYsTFITnRtnnJaxxA0Oe696fLNP8bV3U0EO/dyCCqIQfZLYvCzNYsVEolir7hcgjse
         Q0n9Fl1+8awg0fjSU3DL34TqsynhOyeNhJ2cR1zUr+Nsx98MvYWXrzNrJ2Vvn7vfm8lD
         HVIddlx3+SS0oRc0ayd8yK+0ycvy8ephuv8sywVX0CcD0gSbVPKhbH4L6qLbCNFwxiPx
         NLfOWdi9MOYZJ5ElYv9w4d4uy6dVWVPbufCvBWOFU+e1EB9KDw9zrW4XOXNFX8G6l9WY
         WB8tpC0YlKptzDAENDtq/HsxRzGJhffHqG8XKja+yBhB1vzwfMUjkdSc2INcGFbtPq+C
         Bsnw==
X-Gm-Message-State: APjAAAVQZayVnxQW4McRhK2w+Dz3is0kbsWEFQ4VcQJIMb2+Vz9lYimf
        RyjEF9zPEKElOQs4iHMTDE8vTfAddD9MdzdgBni3Dg==
X-Google-Smtp-Source: APXvYqzcJQ2Z3nZGwdn7NENHQRJ8Bko2OUwuqEYzWSjSSj+06tibhTjEhGokdsLZpxVLPbk8vDf4jxpQfwBiVBC+QUY=
X-Received: by 2002:aca:3305:: with SMTP id z5mr11896170oiz.141.1560217487769;
 Mon, 10 Jun 2019 18:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <20190610143420.GA6594@flask> <20190611011100.GB24835@linux.intel.com>
In-Reply-To: <20190611011100.GB24835@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Jun 2019 09:45:33 +0800
Message-ID: <CANRm+Cwv5jqxBW=Ss5nkX7kZM3_Y-Ucs66yx5+wN09=W4pUdzA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 at 09:11, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Jun 10, 2019 at 04:34:20PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99 wro=
te:
> > 2019-05-30 09:05+0800, Wanpeng Li:
> > > The idea is from Xen, when sending a call-function IPI-many to vCPUs,
> > > yield if any of the IPI target vCPUs was preempted. 17% performance
> > > increasement of ebizzy benchmark can be observed in an over-subscribe
> > > environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function
> > > IPI-many since call-function is not easy to be trigged by userspace
> > > workload).
> >
> > Have you checked if we could gain performance by having the yield as an
> > extension to our PV IPI call?
> >
> > It would allow us to skip the VM entry/exit overhead on the caller.
> > (The benefit of that might be negligible and it also poses a
> >  complication when splitting the target mask into several PV IPI
> >  hypercalls.)
>
> Tangetially related to splitting PV IPI hypercalls, are there any major
> hurdles to supporting shorthand?  Not having to generate the mask for
> ->send_IPI_allbutself and ->kvm_send_ipi_all seems like an easy to way
> shave cycles for affected flows.

Not sure why shorthand is not used for native x2apic mode.

Regards,
Wanpeng Li
