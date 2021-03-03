Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C6532B5C5
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449364AbhCCHT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241892AbhCCBPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 20:15:02 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14011C06178A;
        Tue,  2 Mar 2021 17:13:39 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id v12so20875367ott.10;
        Tue, 02 Mar 2021 17:13:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y54p/dpKPIzMufJOMByqkZMg0hSldch1m8scSHyXvP4=;
        b=XCqLfckpDOHLSA4PZVWEJdgH6OwCV6Iq1erGKikHDRf4tZtTNEsQuTV2DmwWoSJjnR
         bqMSuP5CE2icUXTH86yzUfoqSizD26p3iFTtaI/n1TMVwMpyfUxoSvm0kBrdan6+AJvk
         ao/ucPcOeGdajhLA1Ebl65YLICpxCMrKMN+B5Hvfhqu6p+WmVJ6kfXZICltspjIgHgnB
         rouPy9W0BfN2+Nmh12n3CasXXRnDsw6s+pmze4RjhEO4xhw1NQccLuDM/C1Pf7kxmQI5
         BGHOzq6hMXlJ3DZJyfDW+rAQ4ai477KOrnfBCG0fpIPfk4KcNonPAbHbuIOSyzydtemF
         6pgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y54p/dpKPIzMufJOMByqkZMg0hSldch1m8scSHyXvP4=;
        b=fyi8pVzJgcZodp6L4bjTkxdrnQ4LWL20kbHgj+IXFfkxUK2/JssOLfH+i9OtqzMPM2
         TfwCOJ8MB2eXn5v8dv6PeyfaDi/mRHu7a2wyhS5iLldfkiuGvs5oaauOlZcAO6rF0Gb2
         t7Bl6qeHPDNQfguvt0U4jPKwJIQNAdZBt22dz44c98O0gkU6CbJOaQjB3VeA89uyLZAh
         qjiBMR2fYIryjWewMTN8534BfEsBveRdkZMaUSw7EguZVtxiR+e9U5N+Y0zsRa13/7Ur
         tIhht3JOHzoLO3I6q8SinoQV+lErd527G6GPj+44Q6NbZC3hMvT68zAz8ZPH3HyuqZLp
         ltaw==
X-Gm-Message-State: AOAM531ndSww759ByJ72Pl4Y1NelXAwQSFL6JnxOTnY9r+Afdd51f9Mn
        ssvLb4h6AZwVSpfYaN0iQrAfKV5jPyyJ87W6iWQ=
X-Google-Smtp-Source: ABdhPJy69FER/IuOKFD5Gvana5EKf4iVtHxc0NZZL4MrZucHLzrHacAF0U+sI/rPLkIlFQgCiStvmz77II6jKOqnZ60=
X-Received: by 2002:a05:6830:10c1:: with SMTP id z1mr19648521oto.254.1614734018572;
 Tue, 02 Mar 2021 17:13:38 -0800 (PST)
MIME-Version: 1.0
References: <1614678202-10808-1-git-send-email-wanpengli@tencent.com> <YD5y+W2nqnZt5bRZ@google.com>
In-Reply-To: <YD5y+W2nqnZt5bRZ@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 3 Mar 2021 09:13:27 +0800
Message-ID: <CANRm+Cy_rNAai+u5pyBXKmQP_Qp=3e_hwi2g9bAFMiocCpru1A@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Advancing the timer expiration on guest
 initiated write
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Mar 2021 at 01:16, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Mar 02, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Advancing the timer expiration should only be necessary on guest initiated
> > writes. Now, we cancel the timer, clear .pending and clear expired_tscdeadline
> > at the same time during state restore.
>
> That last sentence is confusing.  kvm_apic_set_state() already clears .pending,
> by way of __start_apic_timer().  I think what you mean is:
>
>   When we cancel the timer and clear .pending during state restore, clear
>   expired_tscdeadline as well.

Good statement. :)

>
> With that,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>
>
> Side topic, I think there's a theoretical bug where KVM could inject a spurious
> timer interrupt.  If KVM is using hrtimer, the hrtimer expires early due to an
> overzealous timer_advance_ns, and the guest writes MSR_TSCDEADLINE after the
> hrtimer expires but before the vCPU is kicked, then KVM will inject a spurious
> timer IRQ since the premature expiration should have been canceled by the guest's
> WRMSR.
>
> It could also cause KVM to soft hang the guest if the new lapic_timer.tscdeadline
> is written before apic_timer_expired() captures it in expired_tscdeadline.  In
> that case, KVM will wait for the new deadline, which could be far in the future.

The hrtimer_cancel() before setting new lapic_timer.tscdeadline in
kvm_set_lapic_tscdeadline_msr() will wait for the hrtimer callback
function to finish. Could it solve this issue?

    Wanpeng
