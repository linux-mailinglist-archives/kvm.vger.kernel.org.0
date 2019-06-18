Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886EB4A3A7
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 16:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfFROQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 10:16:07 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43907 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfFROQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 10:16:06 -0400
Received: by mail-lf1-f66.google.com with SMTP id j29so9404779lfk.10
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 07:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wd5FCsdf/yyWe8BwFl2FWSnHLz/m/HZuBW81us1Gqao=;
        b=KlLi6tt6g2EoWQhVF9mPw5UDZ93LXSIgqMKpQrckdXEvDB0OryZsf7PUidYd59DKb1
         uSEMtaQCL8pnSKbzrbWoz6SK/hdPjpAboGQNZawe1hzmQNK1eoxAjlSmqs2/tRaqxvr6
         3qVoBOm1ydGjrxJ20z5OzwO+MnZwwLfv+XS9so8M3IqOI1fOqLbAQbtoFdoWrbCdF4l/
         GwuabuUkZyUDrAipQRwSxWQuAfllBUmw+NbQxUWAm9WJLs0bbejiN/rBAko19louscah
         GjjChC+GzhFWAGvEBhImUrsPszanyk88xI5zHm9IqIIsO/ESA/kDaT6KJnN/qH5toTsA
         pu/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wd5FCsdf/yyWe8BwFl2FWSnHLz/m/HZuBW81us1Gqao=;
        b=O1pLVs6n+o2hy5li0vNPfROR6oDF7YcLpFA1EU9O9S8iYOFhiGMc3DNLrqgZb/S/9N
         8zqzUrFYxscy9E/WrB7KNYFExevXooJY5aW1/7bghmiJUNbWU8PWNLqcoiGioiRMb00Y
         nBkVnt7MCkYP+cci3MLsYQJ3yUug/bS31nAYmHQIY0B42fsdzkm2wh2VRKhWToKSAwTZ
         q54mtKWOXrI2Z9pSo52YNagH7ojxSvv/docpNv/pQmDazqsYgr7z1/TEYZ0tYQYgP6c3
         QOjlbiZ7GqeEDd537+cQD6TN7FFqMHI/R/Y96f9bUYXKQl5dtf6qQtfdP2e7yb8uayjo
         JyWg==
X-Gm-Message-State: APjAAAVF3u0kg3usPDt/Hl0+RaWBkeXwGIhtQoxP9kuaqkPAGcAIgHLv
        QZN9+xkexRK7kCBRqiQAtFPeP3EqpU0TciFoK+yTag==
X-Google-Smtp-Source: APXvYqzRxBHVZO4Eg1QZNmoaiBXqg44mVxhahfbFgdUhc1VBLqO9kA4ZF41fUp0faBJjm/6tB0bBfxt35yql5oWibRo=
X-Received: by 2002:ac2:5231:: with SMTP id i17mr59395022lfl.39.1560867364264;
 Tue, 18 Jun 2019 07:16:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190531184159.260151-1-aaronlewis@google.com> <4b50c550-308e-2b88-053e-c6933f9ed320@oracle.com>
In-Reply-To: <4b50c550-308e-2b88-053e-c6933f9ed320@oracle.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 18 Jun 2019 07:15:53 -0700
Message-ID: <CAAAPnDGbyVcxwGYcvZG2PJKxWSgJzHXV+q3uvH3mg6dmggBFyA@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: nVMX: Enforce must-be-zero bits in the
 IA32_VMX_VMCS_ENUM MSR
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 4, 2019 at 10:52 AM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 5/31/19 11:41 AM, Aaron Lewis wrote:
> > According to the SDM, bit 0 and bits 63:10 of the IA32_VMX_VMCS_ENUM
> > MSR are reserved and are read as 0.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > ---
> >   arch/x86/kvm/vmx/nested.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 6401eb7ef19c..3438279e76bb 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -1219,6 +1219,8 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
> >       case MSR_IA32_VMX_EPT_VPID_CAP:
> >               return vmx_restore_vmx_ept_vpid_cap(vmx, data);
> >       case MSR_IA32_VMX_VMCS_ENUM:
> > +             if (data & (GENMASK_ULL(63, 10) | BIT_ULL(0)))
> > +                     return -EINVAL;
> >               vmx->nested.msrs.vmcs_enum = data;
> >               return 0;
> >       default:
>
>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>

ping
