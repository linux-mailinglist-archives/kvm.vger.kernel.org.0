Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F62744C90F
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 20:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhKJTmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 14:42:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbhKJTmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 14:42:04 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C30C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 11:39:16 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id c3so4151390iob.6
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 11:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3SMO6CvmxSEBfAp8KRqD5IqUtmLkFi+eG/hFeuiApP8=;
        b=iWKXYgP9R3gSr4gDRcARv/crjntS2rM0iP2PE/LljM8uKwf0j1yR5MlUvbJg8d/xTD
         +9yLepHT95qJ7Fwacjeek0WliLgYmr2VKtLQ9ZcbooDP5LgbMBUO2sBAdfbyeYUaa+LK
         ingTWUTI0t/8h1OB4pQs1fkjtOkwdO5dPDRUS0BRal0usDL3P7Egah95an25GExQxmWj
         99AZ1yLqaRMP4vpmsqNt+sonVhYvyYt+INZQeGJyoLrjVxOhMSiLA6yFPqTp6lzYqPm3
         ZX2x5WB/AeJtabBly0XYS9Czdz1mB3cQsbTKS6XVMHzJFgRngnen5+dosoWpYFSOIre8
         EAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3SMO6CvmxSEBfAp8KRqD5IqUtmLkFi+eG/hFeuiApP8=;
        b=XVVoPugEgi4kYybMr//SWJTftFupZuUoOkaWtVkvKzp7CLZkKaCYPPvfOOxa/KlY/J
         Sa0DXSZhHTNlr1Fmzb8Yp4CNVCYyikrnMpFwynToi0yq91UlB0oja7TWjKY6S88k1OiE
         p/f1Ps21xh7uHSwl47i5chfS8AcG5SMdzZU/y0/oqFq4p/kRyZgCiSy95bXmTtvt5LW9
         2KtOLiQQubA/r+s14lAxX3rwpIr3OJPlQaLaoifT+SS9BjfUKmw27thg5CgiRDB9NThT
         PzkcT5pl7TnIjyjl0+gurk+jwWTTTC4IIKkR2olJfKektdXR6nC7lKIxiBGgskekcsJ/
         mzpw==
X-Gm-Message-State: AOAM531XB/Zfc/DrrDPEzPQRhAWUVF5zgKqEvRxgqp+0aESZ5jBkZJrd
        yRUsyhOtHcIFHNvyO4jeom4nmbsNWJLt1YPgkqe4Cg==
X-Google-Smtp-Source: ABdhPJwVnD0vAGqngGi1Bc5alFWYVWNyYEvf9pOTUc2f5EnygsxhdxmMwhBXDb8EVLNsL6FIhsyRL5X672qOA8Iglpo=
X-Received: by 2002:a6b:2cc5:: with SMTP id s188mr1078380ios.218.1636573155950;
 Wed, 10 Nov 2021 11:39:15 -0800 (PST)
MIME-Version: 1.0
References: <YUixqL+SRVaVNF07@google.com> <20210921095838.GA17357@ashkalra_ubuntu_server>
 <YUnjEU+1icuihmbR@google.com> <YUnxa2gy4DzEI2uY@zn.tnic> <YUoDJxfNZgNjY8zh@google.com>
 <YUr5gCgNe7tT0U/+@zn.tnic> <20210922121008.GA18744@ashkalra_ubuntu_server>
 <YUs1ejsDB4W4wKGF@zn.tnic> <CABayD+eFeu1mWG-UGXC0QZuYu68B9wJNWJhjUo=HHgc_jsfBag@mail.gmail.com>
 <2213EC9B-E3EC-4F23-BC1A-B11DF6288EE3@amd.com> <YVRRsEgjID4CbbRS@zn.tnic>
In-Reply-To: <YVRRsEgjID4CbbRS@zn.tnic>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 10 Nov 2021 11:38:39 -0800
Message-ID: <CABayD+dM8OafXkw6_Af17uvthnNG+k3majitc3uGwsm+Lr8DAQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@linux.ibm.com" <tobin@linux.ibm.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 4:44 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Sep 28, 2021 at 07:26:32PM +0000, Kalra, Ashish wrote:
> > Yes that=E2=80=99s what I mentioned to Boris.
>
> Right, and as far as I'm concerned, the x86 bits look ok to me and I'm
> fine with this going through the kvm tree.
>
> There will be a conflict with this:
>
> https://lkml.kernel.org/r/20210928191009.32551-1-bp@alien8.de
>
> resulting in:
>
> arch/x86/kernel/kvm.c: In function =E2=80=98setup_efi_kvm_sev_migration=
=E2=80=99:
> arch/x86/kernel/kvm.c:563:7: error: implicit declaration of function =E2=
=80=98sev_active=E2=80=99; did you mean =E2=80=98cpu_active=E2=80=99? [-Wer=
ror=3Dimplicit-function-declaration]
>   563 |  if (!sev_active() ||
>       |       ^~~~~~~~~~
>       |       cpu_active
> cc1: some warnings being treated as errors
> make[2]: *** [scripts/Makefile.build:277: arch/x86/kernel/kvm.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [scripts/Makefile.build:540: arch/x86/kernel] Error 2
> make: *** [Makefile:1868: arch/x86] Error 2
> make: *** Waiting for unfinished jobs....
>
> but Paolo and I will figure out what to do - I'll likely have a separate
> branch out which he can merge and that sev_active() will need to be
> converted to
>
>         if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
>
> which is trivial.
>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

Hey All,

Bumping this thread again, since I believe these patches are good to go.

Let me know if there is anything I can do to help here,
Thanks,
Steve
