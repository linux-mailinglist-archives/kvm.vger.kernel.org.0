Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9163517A6D9
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 14:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgCEN5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 08:57:38 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44672 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgCEN5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 08:57:38 -0500
Received: by mail-ed1-f65.google.com with SMTP id g19so6851016eds.11;
        Thu, 05 Mar 2020 05:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WhJ4pE7YT/8K7DLAuBZsqSy8ezvtqBo/PzgMhkpxs+Q=;
        b=QyjN+9MMqnzb4jt3OtGPpiXwoVHEnS/knESx6C5F7YNWDYJnamDCeXGQsTU3AHHMK8
         OSLgJOJdOM8A9N20lHwCowdV3zLlAIBMWjSDCmu8kxUoSqW3L83qWCE8NekdleoVrkqP
         zzW3BAwlt2t1qA2yVbZ5gSMyY1c42bC7Pa5zK8TCTxZFIKuuIeILVdoz+XwdBU8xj2x7
         jF1lyHvdWYfOklwM84AcxLZ6FYpGLuKoVKZlxO+TRFK7nsNg40lS2YvGVSAEJjEX4mxi
         q8BZfE27/ULf7kcV5glhteT/RpA1osQvJa5WG4fOwKwK0OBBGCpbc2iwNW0U3mysWsaG
         GEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WhJ4pE7YT/8K7DLAuBZsqSy8ezvtqBo/PzgMhkpxs+Q=;
        b=ISxUj4prsvuQ1CI8D+VigvhR//yWrrQALB0bebMnfJ5Ww6RrfpLF58bKB+6or77g2g
         8q0QwzPST/ntQHoydI+EySqgqogYvCsGz3hRAsM0+piUTKFp9V09lxlWzAjqj73g2RUn
         oVC0R9tVkVOugXSr4hsYA1zeI7yj+hmP/Aqt2lGnjV9IunNaHQtYEvgto4UAZyAASQGD
         4iYaCDJy7Ub2wasOL+Yh/DuE06lSygqyOY1vn5Ox2W+MktdlXzphKgbyiZ5XvtJphFCH
         nROFEUbc9VUJfhiPV+BFTtwvEKJ8Qi57TByft2b73Zm7le3Y2ME8mxOP37n/Ykf0QLfs
         /O4A==
X-Gm-Message-State: ANhLgQ0aEOdigbja4dOOebr+Pf4rZkFOIheKiGAN4FUIOVpaDYP7g+dA
        ZOZn4R8StmiHY+Whse3TNmhWCbPS+96CtP+8GZM=
X-Google-Smtp-Source: ADFU+vuH1LeKiDtbb1qlhq4T2k6ofNZFMwjWBanfcGTIhhH8mUphj6u2XUoYNZgtlbdb1/tBFQ7VUf+td2qanUevyI8=
X-Received: by 2002:a17:906:aacb:: with SMTP id kt11mr7901629ejb.24.1583416656273;
 Thu, 05 Mar 2020 05:57:36 -0800 (PST)
MIME-Version: 1.0
References: <20200303130356.50405-1-arilou@gmail.com> <20200303130356.50405-3-arilou@gmail.com>
 <87pndsdxxh.fsf@vitty.brq.redhat.com>
In-Reply-To: <87pndsdxxh.fsf@vitty.brq.redhat.com>
From:   Jon Doron <arilou@gmail.com>
Date:   Thu, 5 Mar 2020 15:57:34 +0200
Message-ID: <CAP7QCoi6UYsfxb2Ba=1rstwxkvsX0HwoF-UQxw6UDDZ2PqaqRQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] x86/kvm/hyper-v: enable hypercalls regardless of
 hypercall page
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 4, 2020 at 3:58 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Jon Doron <arilou@gmail.com> writes:
>
> > Microsoft's kdvm.dll dbgtransport module does not respect the hypercall
> > page and simply identifies the CPU being used (AMD/Intel) and according
> > to it simply makes hypercalls with the relevant instruction
> > (vmmcall/vmcall respectively).
> >
> > The relevant function in kdvm is KdHvConnectHypervisor which first checks
> > if the hypercall page has been enabled via HV_X64_MSR_HYPERCALL_ENABLE,
> > and in case it was not it simply sets the HV_X64_MSR_GUEST_OS_ID to
> > 0x1000101010001 which means:
> > build_number = 0x0001
> > service_version = 0x01
> > minor_version = 0x01
> > major_version = 0x01
> > os_id = 0x00 (Undefined)
> > vendor_id = 1 (Microsoft)
> > os_type = 0 (A value of 0 indicates a proprietary, closed source OS)
> >
> > and starts issuing the hypercall without setting the hypercall page.
> >
> > To resolve this issue simply enable hypercalls if the guest_os_id is
> > not 0.
> >
> > Signed-off-by: Jon Doron <arilou@gmail.com>
> > ---
> >  arch/x86/kvm/hyperv.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> > index 13176ec23496..7ec962d433af 100644
> > --- a/arch/x86/kvm/hyperv.c
> > +++ b/arch/x86/kvm/hyperv.c
> > @@ -1615,7 +1615,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 outgpa,
> >
> >  bool kvm_hv_hypercall_enabled(struct kvm *kvm)
> >  {
> > -     return READ_ONCE(kvm->arch.hyperv.hv_hypercall) & HV_X64_MSR_HYPERCALL_ENABLE;
> > +     return READ_ONCE(kvm->arch.hyperv.hv_guest_os_id) != 0;
> >  }
> >
> >  static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
>
> I would've enabled it in both cases,
>
> return (READ_ONCE(kvm->arch.hyperv.hv_hypercall) &
>  HV_X64_MSR_HYPERCALL_ENABLE) || (READ_ONCE(kvm->arch.hyperv.hv_guest_os_id) != 0);
>
> to be safe. We can also check what genuine Hyper-V does but I bet it has
> hypercalls always enabled. Also, the function can be made inline,
> there's a single caller.

I dont have any Hyper-V setup at the moment to validate this, i
believe your hunch is correct but ill do the
implementation you have suggested.

>
> --
> Vitaly
>
