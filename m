Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FA51B3A75
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 10:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgDVIq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 04:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725786AbgDVIqZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 04:46:25 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA32DC03C1A6;
        Wed, 22 Apr 2020 01:46:23 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id z25so1354415otq.13;
        Wed, 22 Apr 2020 01:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gk3jUrPPgiabi11RgXy0xB2HBn4aEvGFqZHs77mW7WY=;
        b=kS1JaR9QP8Tkhg4LQaRaHyqUTveqVBEASqAUgjy4Nye94tP4sbTE9GuLtyvAmRXgA5
         6V569Hh9V8Av43gyDtUOvOzSs+6F1BgvrONljYlSZ9qsH1Yl4El+rKsWFki636j6Ydrp
         UYJIzlZxiguN52o7Sf6pqmH07vGdP+XDZW71K/OuzsrkbUwvO4En7WuCIdTACCWOFNzo
         YIYiDo62p4TK1UfFcOYVFSirXYHFfVW3+tmcnTT7Bt6K/QDgD2s+3vQ/WZI8Eg3HLrg6
         2JisLQabs6BsW2avtWiIA1N+x8JgtzVKoiv5ufD/X4fLZ/SeOVRepSvyLN6w0Z6UoHvY
         R7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gk3jUrPPgiabi11RgXy0xB2HBn4aEvGFqZHs77mW7WY=;
        b=qAvrcPl9y+sIR+fTMTbZ+i4z+26bsEl3zDrU6srmVRxNKOukGZP/KT2dRQOX444RLC
         8Czg6Ce5TvImfmo4LRWvHQ4BOvTjAJE5Kkyv4JoImtp2CJh1o7bcj4gqBeELF6UkSOK0
         EvtxcemeLB8zrxTqT7yRxm1toPAIQvo2DeIcbAMULcaAT5Rrmx+lok+xF70skcPe4p1A
         mfVm/LD+3w5t3gP2ghYEkB0r7CVSyYBYSiAUcJE5kdkJFiv5/lqiKcpJIBTsbYdNljWZ
         B4WH+dG9w+mW7o2ADeGrfFJWBHEARXIZH8325ggWUykCycSuHbC0+ksHhpmDpYXj1UHE
         ROUA==
X-Gm-Message-State: AGi0PuZyKBT1ckeHdHlcs02hgEGqxPM8c/bEwRkYioT9wKRoT9uk06E+
        FEaJHqJKx03Atipk5oh8xu9PNAbWL1o/MtDqAufjhg==
X-Google-Smtp-Source: APiQypJGrqPe4fG5yPHm9nFF0EHD8wbppHXaiAQiNwh+5bmx3czFrpGf8oUxh7euTJIORpslW3WFyzh1qcbF7OVd2RU=
X-Received: by 2002:a9d:2207:: with SMTP id o7mr14765153ota.254.1587545182984;
 Wed, 22 Apr 2020 01:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <1587468026-15753-1-git-send-email-wanpengli@tencent.com>
 <1587468026-15753-2-git-send-email-wanpengli@tencent.com> <ed968729-5d2a-a318-1d8f-db39e6ee72cb@redhat.com>
 <CANRm+CxzROx=eawemmzh==2Mz-DxKSyYFSxHqLxUiGFFnWkAYw@mail.gmail.com> <d87e0a4b-608a-451b-e3f0-968d46b6cc26@redhat.com>
In-Reply-To: <d87e0a4b-608a-451b-e3f0-968d46b6cc26@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 22 Apr 2020 16:46:12 +0800
Message-ID: <CANRm+CznaiShdq_h1uUnZ_t7k1LX5=cHQwiYOd8632cPnUNHsw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: X86: TSCDEADLINE MSR emulation fastpath
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

On Wed, 22 Apr 2020 at 16:38, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/04/20 02:48, Wanpeng Li wrote:
> > On Tue, 21 Apr 2020 at 19:37, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >> On 21/04/20 13:20, Wanpeng Li wrote:
> >>> +     case MSR_IA32_TSCDEADLINE:
> >>> +             if (!kvm_x86_ops.event_needs_reinjection(vcpu)) {
> >>> +                     data = kvm_read_edx_eax(vcpu);
> >>> +                     if (!handle_fastpath_set_tscdeadline(vcpu, data))
> >>> +                             ret = EXIT_FASTPATH_CONT_RUN;
> >>> +             }
> >>>               break;
> >> Can you explain the event_needs_reinjection case?  Also, does this break
> > This is used to catch the case vmexit occurred while another event was
> > being delivered to guest software, I move the
> > vmx_exit_handlers_fastpath() call after vmx_complete_interrupts()
> > which will decode such event and make kvm_event_needs_reinjection
> > return true.
>
> This doesn't need a callback, kvm_event_needs_reinjection should be enough.
>
> You should also check other conditions such as
>
>         vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
>             || need_resched() || signal_pending(current)
>
> before doing CONT_RUN.

Agreed.

>
> >> AMD which does not implement the callback?
> > Now I add the tscdeadline msr emulation and vmx-preemption timer
> > fastpath pair for Intel platform.
>
> But this would cause a crash if you run on AMD.

Yes. :)

    Wanpeng
