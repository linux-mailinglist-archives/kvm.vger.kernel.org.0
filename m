Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ACF21A70D
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 20:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgGIS2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 14:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgGIS2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 14:28:37 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846B0C08C5DC
        for <kvm@vger.kernel.org>; Thu,  9 Jul 2020 11:28:37 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v8so3391094iox.2
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 11:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5zjs+rIBBj6MrxntmJxcLKegx38dFb1Uyu8eE1it5wg=;
        b=gwaWKxJvSK5tHnvv6KDqfs/WIspheIA1bzQ3YgabM9QKy2rzT4HNP1lPPS/H1qS4xt
         FNYPUI0Fd6nh2BOqEDkNIRjhg68UOxU6LLjqet3IruG8ax/fcivVw+UOiE0A8M43gHpZ
         Ey+aea76o+UfwUlN/OyVdWgxT4oqcJAyXiEFBdV3P57YO3kEpJ/RS4/OSlaVcI1iir2o
         wcaMut+gck89mop3SCn1LvFENY/PTVZhsCdFUiIUSuqhKskucMCYeqU4LFI4tY9HlUC3
         Kh/ZQiXHJvffMoMC1zYo+N31cqd7MhypUazR4kBwZOBGW2CuX0AN2Q9FABALvRAKFd64
         y7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5zjs+rIBBj6MrxntmJxcLKegx38dFb1Uyu8eE1it5wg=;
        b=UvxEoZd7wG47WSuUWvZAItMhkOfwdsTtT3uMybrb1yVSOqIuUKuzymLurrFblmg+GL
         oc8V2IfrPnLLF26g9NML+aP7M/Xa+6kvOyL1QAxngQ1F38y6Kayu75nbi9IcOxlcwMMW
         G1pRAR1SqMcWZFnc+WFDdjRbzYXtFf1I/TQlz7OHRRO/us1A6joEsj1MEb0tmIQ3wgfi
         9nmYi97DYbWUPQexqd183i28hDldvhqp6JzBnNNImqN/ZK6/rqiC5v6v1A8iR7CGwz1S
         qGamQ5MxdGcRkTSJFbY040YeJuJIoKGg5kMfbXqE3JCWYNW00Ils9TAvuNlbb8HSzQXx
         coDw==
X-Gm-Message-State: AOAM5331JAdNfAW3yS7tsWoWevosnunVG63lGrSo3dtr58Mx12YmsXfY
        JeXj8nM35+0IdAXL3cd7RuDEqI14EOA7hc7z44CNtg==
X-Google-Smtp-Source: ABdhPJyR8OKtUqECdG1gGuhcnIRkURaY1y6wimMMYrouaPEN+AintJIUGjyWo4+P2h/irUAQmQb2QC2/MfGpAbcghys=
X-Received: by 2002:a5e:c311:: with SMTP id a17mr14217665iok.12.1594319316616;
 Thu, 09 Jul 2020 11:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200709095525.907771-1-pbonzini@redhat.com> <CALMp9eREY4e7kb22CxReNV83HwR7D_tBkn2i5LUbGLGe_yw5nQ@mail.gmail.com>
 <782fdf92-38f8-c081-9796-5344ab3050d5@redhat.com>
In-Reply-To: <782fdf92-38f8-c081-9796-5344ab3050d5@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 9 Jul 2020 11:28:25 -0700
Message-ID: <CALMp9eRSvdx+UHggLbvFPms3Li2KY-RjZhjGjcQ3=GbSB1YyyA@mail.gmail.com>
Subject: Re: [PATCH] KVM: nSVM: vmentry ignores EFER.LMA and possibly RFLAGS.VM
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 9, 2020 at 10:25 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/07/20 19:12, Jim Mattson wrote:
> >> +
> >> +       /* The processor ignores EFER.LMA, but svm_set_efer needs it.  */
> >> +       efer &= ~EFER_LMA;
> >> +       if ((nested_vmcb->save.cr0 & X86_CR0_PG)
> >> +           && (nested_vmcb->save.cr4 & X86_CR4_PAE)
> >> +           && (efer & EFER_LME))
> >> +               efer |= EFER_LMA;
> > The CR4.PAE check is unnecessary, isn't it? The combination CR0.PG=1,
> > EFER.LMA=1, and CR4.PAE=0 is not a legal processor state.

Oops, I meant EFER.LME above.

Krish pointed out that I was quoting from Intel's documentation. The
same constraints are covered in Table 14-5 of AMD's APM, volume 2.

> Yeah, I was being a bit cautious because this is the nested VMCB and it
> can be filled in with invalid state, but indeed that condition was added
> just yesterday by myself in nested_vmcb_checks (while reviewing Krish's
> CR0/CR3/CR4 reserved bit check series).

From Canonicalization and Consistency Checks of section 15.5 in AMD's
APM, volume 2:

The following conditions are considered illegal state combinations:
...
EFER.LME and CR0.PG are both set and CR4.PAE is zero.

This VMCB state should result in an immediate #VMEXIT with exit code -1.

> That said, the VMCB here is guest memory and it can change under our
> feet between nested_vmcb_checks and nested_prepare_vmcb_save.  Copying
> the whole save area is overkill, but we probably should copy at least
> EFER/CR0/CR3/CR4 in a struct at the beginning of nested_svm_vmrun; this
> way there'd be no TOC/TOU issues between nested_vmcb_checks and
> nested_svm_vmrun.  This would also make it easier to reuse the checks in
> svm_set_nested_state.  Maybe Maxim can look at it while I'm on vacation,
> as he's eager to do more nSVM stuff. :D

I fear that nested SVM is rife with TOCTTOU issues.
