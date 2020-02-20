Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D771655A4
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 04:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgBTD3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 22:29:41 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43165 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbgBTD3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 22:29:40 -0500
Received: by mail-lj1-f194.google.com with SMTP id a13so2608065ljm.10
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 19:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zQzKM3EWlegYhIhG2vsY/POL8dqhlVMAf2W///2/x1o=;
        b=qB9aPXppTTKV60rpaUzPdqGseteuOVaug0J72YAqsarKZrI7gNyEDpwuazj6fU3aWK
         DNQwi0MqTcXHe9WtgHCG3x3f6sMi44RVnvt+b7u4G6Q+2t/WYco5A9gjG6gG8a2TuL0o
         BFcSH8nh4n3BxglY56Ga77T1dskxvd2psR2Jrdme+9F8SfyLhYNNpbE5qiB56KjwGnVl
         EgL49uSWkdesaHTRB1oCynMwbvqA9nxCC9rIeD+1KsruL1Mg9xYtRi4pZqNTzQ+rSkcG
         sz+Vt7CN5Sn9m4aBFv5ZNeV7nNe7RZvu+RLK896bmID+o8eTaU8TOT9h+NR4wCEw9Xl5
         3s7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zQzKM3EWlegYhIhG2vsY/POL8dqhlVMAf2W///2/x1o=;
        b=B9LFkZvAsvPEuhXGOfvcJdTRkVp/puiicTqvUT/cCcO4PyBxwgXJ2sGcQ2rkdq17xP
         pc5YdFx41UXQAd6trUXcDQG0AGUvWrIf99/9JSqyTKGn+pKMsXS47fOUdOb0sbPIthMu
         RuVjdNyYQOGann0guYcFsq31iYL5vIrS0Sxl5Ku4SoQFckwRidmAD+sV28uKZI0qEjEw
         maBZ1UwPg+oILEDhMGq8ciWYomLvtV8/nZ/yB4H3Xl/fnriWiaJqQ6w8PFEF8wIrOAxb
         Cruq/svH/9/RfdF9IbK98swvwonAbX022tKsVyyb0i24+4+ZAetsLrktsxJUBmes9gCe
         4Lbw==
X-Gm-Message-State: APjAAAXx5FzhIMqWI5UuzJQPGTmxgq14rGhH2rWPMCxD8CCwRAlRSL0K
        wXjmIggFLbjv1eqj1G4kj/fBdJamzUAWdn2XOd8D6g==
X-Google-Smtp-Source: APXvYqzXMyzsrKWTqzpK+/08jWLPSUYdXNhcS0b3gFs33w89sq7KXEGLQ27/pBh8Q0PdsMk5UILaF2JuEbHRuCsP/Qw=
X-Received: by 2002:a2e:580c:: with SMTP id m12mr17723911ljb.150.1582169378127;
 Wed, 19 Feb 2020 19:29:38 -0800 (PST)
MIME-Version: 1.0
References: <CABayD+ch3XBvJgJc+uoF6JSP0qZGq2zKHN-hTc0Vode-pi80KA@mail.gmail.com>
 <52450536-AF7B-4206-8F05-CF387A216031@amacapital.net>
In-Reply-To: <52450536-AF7B-4206-8F05-CF387A216031@amacapital.net>
From:   Steve Rutherford <srutherford@google.com>
Date:   Wed, 19 Feb 2020 19:29:01 -0800
Message-ID: <CABayD+f1tBoWefdkRqjG0YLojJNsgKtEvPCD-mG6xs0hk1EZNg@mail.gmail.com>
Subject: Re: [PATCH 10/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, x86@kernel.org,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 6:12 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
>
>
> > On Feb 19, 2020, at 5:58 PM, Steve Rutherford <srutherford@google.com> =
wrote:
> >
> > =EF=BB=BFOn Wed, Feb 12, 2020 at 5:18 PM Ashish Kalra <Ashish.Kalra@amd=
.com> wrote:
> >>
> >> From: Brijesh Singh <brijesh.singh@amd.com>
> >>
> >> Invoke a hypercall when a memory region is changed from encrypted ->
> >> decrypted and vice versa. Hypervisor need to know the page encryption
> >> status during the guest migration.
> >
> > One messy aspect, which I think is fine in practice, is that this
> > presumes that pages are either treated as encrypted or decrypted. If
> > also done on SEV, the in-place re-encryption supported by SME would
> > break SEV migration. Linux doesn't do this now on SEV, and I don't
> > have an intuition for why Linux might want this, but we will need to
> > ensure it is never done in order to ensure that migration works down
> > the line. I don't believe the AMD manual promises this will work
> > anyway.
> >
> > Something feels a bit wasteful about having all future kernels
> > universally announce c-bit status when SEV is enabled, even if KVM
> > isn't listening, since it may be too old (or just not want to know).
> > Might be worth eliding the hypercalls if you get ENOSYS back? There
> > might be a better way of passing paravirt config metadata across than
> > just trying and seeing if the hypercall succeeds, but I'm not super
> > familiar with it.
>
> I actually think this should be a hard requirement to merge this. The hos=
t needs to tell the guest that it supports this particular migration strate=
gy and the guest needs to tell the host that it is using it.  And the guest=
 needs a way to tell the host that it=E2=80=99s *not* using it right now du=
e to kexec, for example.
>
> I=E2=80=99m still uneasy about a guest being migrated in the window where=
 the hypercall tracking and the page encryption bit don=E2=80=99t match.  I=
 guess maybe corruption in this window doesn=E2=80=99t matter?
It does matter, since you don't want to accidentally clear the dirty
bit when you are migrating the page from the wrong perspective.
Treating pages with dirty c-bits as dirty pages should solve this
problem. It's probably reasonable to expect userspace to handle this?
Downside is that you would then need ~3 copies of the c-bit tracking
buffer: one as the kernel version, one as the "old" usermode version,
and one as the "current" usermode version (which is smaller, since you
can fetch smaller sections than the full buffer). The kernel could
probably directly twiddle the dirty tracking bits and avoid the extra
userspace version, but this doesn't seem required.

That said, this does balloon the c-bit tracking overhead. Tracking
100GB of guest pages requires 3MB per instance of these buffers, which
isn't that bad but also isn't free (assuming my back of the envelope
math is right).
