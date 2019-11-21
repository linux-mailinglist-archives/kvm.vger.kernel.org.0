Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE931047AF
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 01:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKUAn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 19:43:58 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42194 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfKUAn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 19:43:58 -0500
Received: by mail-oi1-f195.google.com with SMTP id o12so1582749oic.9;
        Wed, 20 Nov 2019 16:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5duga5hStByFIxQLF43Hvhp6L3zIT7bydBtcmTR/tNg=;
        b=Z2jQgMmagOSywgBB1g5iBKgaB62SxXVn9HvxA4TtxuZrKXbOMqZUqr3DtxauiYDSlN
         BYkT35Hc+jUN9XLFQn6JWhbNUelrm62kG2i9tIE4VXXY5kXS5B+TFmxplGVgOg5WZGxL
         hrhs32e18U6DV8jaGp+0X2katGRzjXEB2RWmeCW3y1ihWRGaavq4um+cydwKTDxfSTDC
         nrS79UORkjT9JA9140folZWP1QAh3sH9nR4t+jaOPo3QK/mRMh8/AagzcCiExuSddsS4
         IxtLM8X4ZR6KJnCbn422LRGaOLR/BQ+r27/kTPnFjP3K3Pd2itpCq67taR3Qk0/QG23I
         BRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5duga5hStByFIxQLF43Hvhp6L3zIT7bydBtcmTR/tNg=;
        b=KPGV3prKDTWIP295tLh7FQhb76Qwf0PKxfOb2sIXuzROyK7JXgJW8DSXrDA7KdgVik
         ePpweVIAMz5fNzFN+WTpi6vrnrZDUwDVn+7RAGFMOOkwEejIOlpDGhbEhITstxq/Yzke
         313AOp+pTkMWJ7bMSE1ySNHtIdIGgOuq663KpgEaqJlc9+/NsFj0I2PmWvhDOCjBrNw1
         VNC8gVRUEJGlpdDS0rPODc3mfmgGi/Qyr32MYOliRekXmsDn07Y4Sk7xUAmxCdYCr9mf
         XbibNe1SiEjxum65DHWYh7sUEuTrR5LcBPtenMAlB80rIQAdrMJS7WAJhEzF0+Iomemv
         X79w==
X-Gm-Message-State: APjAAAU4zyDbWyFw69R3JG51w83P1pZhBS/Edq/dgiMYaX2sZbGv6Qza
        Nx7IXg2t74FGDjKOSK8CR08j/xA48rDIvniR1jI=
X-Google-Smtp-Source: APXvYqyIgj3f6exokWOiCedzvm8QAgFFlxitYlAX6t3TqpDAeoum3Jhy9OJKkCMSSCSK5Pl1VJ8UKJI5Jx1z5wjzZhI=
X-Received: by 2002:aca:c50f:: with SMTP id v15mr5503455oif.5.1574297037472;
 Wed, 20 Nov 2019 16:43:57 -0800 (PST)
MIME-Version: 1.0
References: <1574221329-12370-1-git-send-email-wanpengli@tencent.com>
 <61E34902-0743-4DAF-A7DF-94C0E51CDA08@oracle.com> <CA11DF59-9969-4E1C-AF8A-8102D2D9D8A9@oracle.com>
In-Reply-To: <CA11DF59-9969-4E1C-AF8A-8102D2D9D8A9@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 21 Nov 2019 08:43:49 +0800
Message-ID: <CANRm+CzCyauiJ9TGYxkLw61--WVT2L2ARj8JhedJN+ZhD64uKg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI fastpath
To:     Liran Alon <liran.alon@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Nov 2019 at 07:55, Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 21 Nov 2019, at 1:36, Liran Alon <liran.alon@oracle.com> wrote:
> >
> >
> >
> >> On 20 Nov 2019, at 5:42, Wanpeng Li <kernellwp@gmail.com> wrote:
> >>
> >> From: Wanpeng Li <wanpengli@tencent.com>
> >>
> >> ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in
> >> our product observation, multicast IPIs are not as common as unicast
> >> IPI like RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
> >
> > Have you also had the chance to measure non-Linux workloads. Such as Wi=
ndows?
> >
> >>
> >> This patch tries to optimize x2apic physical destination mode, fixed
> >> delivery mode single target IPI. The fast path is invoked at
> >> ->handle_exit_irqoff() to emulate only the effect of the ICR write
> >> itself, i.e. the sending of IPIs.  Sending IPIs early in the VM-Exit
> >> flow reduces the latency of virtual IPIs by avoiding the expensive bit=
s
> >> of transitioning from guest to host, e.g. reacquiring KVM's SRCU lock.
> >> Especially when running guest w/ KVM_CAP_X86_DISABLE_EXITS capability
> >> enabled or guest can keep running, IPI can be injected to target vCPU
> >> by posted-interrupt immediately.
> >
> > May I suggest an alternative phrasing? Something such as:
> >
> > =E2=80=9C=E2=80=9D=E2=80=9D
> > This patch introduce a mechanism to handle certain performance-critical=
 WRMSRs
> > in a very early stage of KVM VMExit handler.
> >
> > This mechanism is specifically used for accelerating writes to x2APIC I=
CR that
> > attempt to send a virtual IPI with physical destination-mode, fixed del=
ivery-mode
> > and single target. Which was found as one of the main causes of VMExits=
 for
> > Linux workloads.
> >
> > The reason this mechanism significantly reduce the latency of such virt=
ual IPIs
> > is by sending the physical IPI to the target vCPU in a very early stage=
 of KVM
> > VMExit handler, before host interrupts are enabled and before expensive
> > operations such as reacquiring KVM=E2=80=99s SRCU lock.
> > Latency is reduced even more when KVM is able to use APICv posted-inter=
rupt
> > mechanism (which allows to deliver the virtual IPI directly to target v=
CPU without
> > the need to kick it to host).
> > =E2=80=9C=E2=80=9D=E2=80=9D
> >
> >>
> >> Testing on Xeon Skylake server:
> >>
> >> The virtual IPI latency from sender send to receiver receive reduces
> >> more than 200+ cpu cycles.
> >>
> >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> >> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> >> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> Cc: Liran Alon <liran.alon@oracle.com>
> >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> >
> > I see you used the code I provided my reply to v2. :)
> > I had only some very minor comments inline below. Therefore:
> > Reviewed-by: Liran Alon <liran.alon@oracle.com>
>
> Oh there is a small thing pointed by Sean I agree with (and missed in my =
review) before this Reviewed-by can be given.
> You should avoid performing accelerated WRMSR handling in case vCPU is in=
 guest-mode.
> (From obvious reasons as L1 for example could intercept this WRMSR=E2=80=
=A6)

Yes, I add !is_guest_mode(vcpu) checking in v1, but careless lose it
in further versions.

    Wanpeng
