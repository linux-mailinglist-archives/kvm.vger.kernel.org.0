Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70E93C7FD
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 12:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404861AbfFKKBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 06:01:42 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44356 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727726AbfFKKBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 06:01:42 -0400
Received: by mail-ot1-f67.google.com with SMTP id b7so11243163otl.11;
        Tue, 11 Jun 2019 03:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cKHtlBUkMzjdH3r39CqknbOU+dh9l7ghGjhob+cHQvc=;
        b=TAOJjUVoZBLoEepo69mKURKgJxIdic5W/v1b1jbZ9oRluEz6pU6mqurQzDLfzYlVp0
         OlkC9Pun9ZN5ncordE+w5RYupYNJN4VTPzMIPBblgPLNHbQ4AeMjiz7TSfwfHdh/J2cW
         D8RiYlRjEJi/1MKWS9oa9aGDXRBBlhCnSVOfSDwY4kT7XhWLgrjqwuMo7tdmKZTWjgn8
         dUMI/UtDSOdnycaVhW6vWSaUhgCLUPISOIKvvZCwNx7VFXecEAreom7uT9QBIKRBydQr
         pa3+ePq5te0zQ0iJqu6XPgGChiryPEpPHKwUZaJ+FgGIkdtUfOnLfHnr+gQM81s0nR/k
         lgLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cKHtlBUkMzjdH3r39CqknbOU+dh9l7ghGjhob+cHQvc=;
        b=Ri97DmgR/StqQxiFhlZHnXqFjqEHhimorLtXCTJGvFdTHc1CzBdKnMOBengv1Luu+B
         TcG9ibURNAcYW2AcBDZjXZW93qJJJRNOIetcVq+onzcNSqD45HlMZfECXBM4vMpKHztw
         wabfZQ7fXdengqLgX06o+c9RPt5zFmKqEPWjk4kB+6H9dd2x3GTW7Mwn3t8RQy0oLMU8
         XQ1Yug1d01T5zfVqO5WVjB9wCJKtfSelwUH+R87M5htEMxv55aveQHIyNW893LVrDiuJ
         M/tijse6G6uIYobT0R3V9l8UCs9O09jJjspDQ2kHiAoxUD3K++bOV4HNYGXK1Nz325/u
         yXNg==
X-Gm-Message-State: APjAAAWz4C2t6GJ//sJ+7Qcbqs4QpXA8QqTeFkGErKwoTkiIHQ0edfBe
        /emedNeEIMdV3ama/BItvZ2LlPW7weOyB3u1QdU=
X-Google-Smtp-Source: APXvYqxhkV+gvHla0N2YZgkW9d9FAdVI0LqmBRTy/1sioItcPZ602wJTcdJjOuPTo6CYxmRjnHa1uyPJuu56IMPtWxg=
X-Received: by 2002:a9d:6959:: with SMTP id p25mr11883571oto.118.1560247301404;
 Tue, 11 Jun 2019 03:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <20190610143420.GA6594@flask> <20190611011100.GB24835@linux.intel.com>
 <CANRm+Cwv5jqxBW=Ss5nkX7kZM3_Y-Ucs66yx5+wN09=W4pUdzA@mail.gmail.com> <F136E492-5350-49EE-A856-FBAEDB12FF99@gmail.com>
In-Reply-To: <F136E492-5350-49EE-A856-FBAEDB12FF99@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 11 Jun 2019 18:02:25 +0800
Message-ID: <CANRm+CyZcvuT80ixp9f0FNmjN+rTUtw8MshtBG0Uk4L1B1UjDw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 at 09:48, Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Jun 10, 2019, at 6:45 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > On Tue, 11 Jun 2019 at 09:11, Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> >> On Mon, Jun 10, 2019 at 04:34:20PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99 =
wrote:
> >>> 2019-05-30 09:05+0800, Wanpeng Li:
> >>>> The idea is from Xen, when sending a call-function IPI-many to vCPUs=
,
> >>>> yield if any of the IPI target vCPUs was preempted. 17% performance
> >>>> increasement of ebizzy benchmark can be observed in an over-subscrib=
e
> >>>> environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-functio=
n
> >>>> IPI-many since call-function is not easy to be trigged by userspace
> >>>> workload).
> >>>
> >>> Have you checked if we could gain performance by having the yield as =
an
> >>> extension to our PV IPI call?
> >>>
> >>> It would allow us to skip the VM entry/exit overhead on the caller.
> >>> (The benefit of that might be negligible and it also poses a
> >>> complication when splitting the target mask into several PV IPI
> >>> hypercalls.)
> >>
> >> Tangetially related to splitting PV IPI hypercalls, are there any majo=
r
> >> hurdles to supporting shorthand?  Not having to generate the mask for
> >> ->send_IPI_allbutself and ->kvm_send_ipi_all seems like an easy to way
> >> shave cycles for affected flows.
> >
> > Not sure why shorthand is not used for native x2apic mode.
>
> Why do you say so? native_send_call_func_ipi() checks if allbutself
> shorthand should be used and does so (even though the check can be more
> efficient - I=E2=80=99m looking at that code right now=E2=80=A6)

Please continue to follow the apic/x2apic driver. Just apic_flat set
APIC_DEST_ALLBUT/APIC_DEST_ALLINC to ICR.

Regards,
Wanpeng Li
