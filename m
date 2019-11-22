Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8FF1079EC
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 22:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKVVZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 16:25:07 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46961 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVVZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 16:25:07 -0500
Received: by mail-io1-f65.google.com with SMTP id i11so9637944iol.13
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 13:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I7yg0PBij1Gu4A8MxKvAg8F8c70Xn+B77WiBntt5gZQ=;
        b=KhwpE+f2MhltoTk9chiA+cLXOlJ54e9IBT8Qm783kWNf6gIX4o+Yow9U7ZLhtSrPzi
         gVKnFoloKXViF5JVVKZmPeSQOP2cScS5VtKNcZfGIFY86gXA4X70P4IvslRZKTP88f7d
         I9doPvYHsfcHjjdUyCsz4GpjJrHHRkn+d/gvQUY3wtLeoVp9aAyzvmWwELkuth0UHhRV
         XveI2zIMmpK0evhIG2hCYfrBRwquLQUvIWFOknlroVz7mcrK9icG4DxswiCtTV8tVuna
         +EmbcBd/0bq+W2/ln7h7S+BAmWQx4jliOZhQTAiMsNmYiDPZQ9m5fSm0d8seGRqqmvDK
         Y/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I7yg0PBij1Gu4A8MxKvAg8F8c70Xn+B77WiBntt5gZQ=;
        b=bVDNBNxSjFtqeVIG71rwIIs2KcQprrW0hyOwNISskeHsZG6mSDFQqnKg51r6izTN6k
         B/QxNQIGAmYB47Y6BOFEzgs/b2yTomj+MW6IT0gHTQbwlx9Ocd7JM3BfdEINTZoKlrLn
         KtMAIQwujkYTwuOwwoHtwpzXke8Y+7Izw9t5YaJRn20pNMNzIGEoNNh6XtNsXxwjmbjE
         FxuIdnMoGHcxYZmSU8C+T8gBy3GNRDQpw2wyVZeieYpncTSIRjs3vtM6JFakJIkHmTqH
         jrmLq14IKJ+K3kLxcVKUkig3YUZVtf8TzRjLr2ooKxm1nNbuPEEQkjbfu4D4U4qPbY4X
         7m6Q==
X-Gm-Message-State: APjAAAVZk1cSOxse3grq3jgrkCADS1ooxZ/rs/to8SDq5PKiIYhf41uP
        V1U7yXmqOrG2FPyXAarFSpyBhVBH5TYRuin5PYROB7NCYjM=
X-Google-Smtp-Source: APXvYqybR/I5dA1DgOXjH7reiExEvUHdK3faVPXAwtzOOhZvITWk4EZDiVUPIldzTSTEBrrCEEKi9ISGcJYvJ26mDbY=
X-Received: by 2002:a6b:e016:: with SMTP id z22mr15202542iog.296.1574457905643;
 Fri, 22 Nov 2019 13:25:05 -0800 (PST)
MIME-Version: 1.0
References: <20191121203344.156835-1-pgonda@google.com> <20191121203344.156835-3-pgonda@google.com>
 <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com> <CALMp9eRVNDvy65AFDz=KjUT0M0rCtgCECuMS0nUZqAhy2S=MsA@mail.gmail.com>
 <CAMkAt6paein2dHHD-wZ8Eke4tUb_8GNuiH_3-RHkiBHx=jjwUg@mail.gmail.com> <c423d85d-b7d4-7f1c-0b5b-d3f62b35b6da@amd.com>
In-Reply-To: <c423d85d-b7d4-7f1c-0b5b-d3f62b35b6da@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Nov 2019 13:24:54 -0800
Message-ID: <CALMp9eTL=j_c7HYhp2rX+1w-SKXa1zr+wAJM=GAnJjKFtuYt-Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 1:22 PM Brijesh Singh <brijesh.singh@amd.com> wrote=
:
>
> Ah, I missed the fact that we don't need to pass the SevES
> bit to the guest because guest actually does not need it.
> It just needs the SevBit to make decision whether its
> safe to call the RDMSR for SEV_STATUS. The SEV_STATUS
> MSR will give information which SEV feature is enabled.

Why does it have to be safe to read the SEV_STATUS MSR? We read
nonexistent MSRs all the time.

> thanks
>
> On 11/22/19 1:52 PM, Peter Gonda wrote:
> > I am not sure that the SevEs CPUID bit has the same problem as the Sev
> > bit. It seems the reason the Sev bit was to be passed to the guest was
> > to prevent the guest from reading the SEV MSR if it did not exist. If
> > the guest is running with SevEs it must be also running with Sev. So
> > the guest  can safely read the SevStatus MSR to check the SevEsEnabled
> > bit because the Sev CPUID bit will be set.
> >
> > If I look at the AMD patches for ES. I see just that,
> > https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
hub.com%2FAMDESE%2Flinux%2Fcommit%2Fc19d84b803caf8e3130b1498868d0fcafc755da=
7&amp;data=3D02%7C01%7Cbrijesh.singh%40amd.com%7Cfe5a46e348a5464ea52b08d76f=
85909b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637100491764446005&amp;=
sdata=3DR6RrRO0TpcfM7uzpBbsGhVp47bA%2BVoz624IBQif%2BxjA%3D&amp;reserved=3D0=
,
> > it doesn't look for the SevEs CPUID bit.
> >
> > } else {
> >    /* For SEV, check the SEV MSR */
> >    msr =3D __rdmsr(MSR_AMD64_SEV);
> >    if (!(msr & MSR_AMD64_SEV_ENABLED))
> >      return;
> >    /* SEV state cannot be controlled by a command line option */
> >    sme_me_mask =3D me_mask;
> >    sme_me_status |=3D SEV_ACTIVE;
> >    physical_mask &=3D ~sme_me_mask;
> > +
> > +  if (!(msr & MSR_AMD64_SEV_ES_ENABLED))
> > +    return;
> > +
> > +  sme_me_status |=3D SEV_ES_ACTIVE;
> >    return;
> > }
> >
> > }
> >
> >
> > On Fri, Nov 22, 2019 at 9:18 AM Jim Mattson <jmattson@google.com> wrote=
:
> >>
> >> Does SEV-ES indicate that SEV-ES guests are supported, or that the
> >> current (v)CPU is running with SEV-ES enabled, or both?
> >>
> >> On Fri, Nov 22, 2019 at 5:01 AM Brijesh Singh <brijesh.singh@amd.com> =
wrote:
> >>>
> >>>
> >>> On 11/21/19 2:33 PM, Peter Gonda wrote:
> >>>> Only pass through guest relevant CPUID information: Cbit location an=
d
> >>>> SEV bit. The kernel does not support nested SEV guests so the other =
data
> >>>> in this CPUID leaf is unneeded by the guest.
> >>>>
> >>>> Suggested-by: Jim Mattson <jmattson@google.com>
> >>>> Signed-off-by: Peter Gonda <pgonda@google.com>
> >>>> Reviewed-by: Jim Mattson <jmattson@google.com>
> >>>> ---
> >>>>   arch/x86/kvm/cpuid.c | 8 +++++++-
> >>>>   1 file changed, 7 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >>>> index 946fa9cb9dd6..6439fb1dbe76 100644
> >>>> --- a/arch/x86/kvm/cpuid.c
> >>>> +++ b/arch/x86/kvm/cpuid.c
> >>>> @@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_cp=
uid_entry2 *entry, u32 function,
> >>>>                break;
> >>>>        /* Support memory encryption cpuid if host supports it */
> >>>>        case 0x8000001F:
> >>>> -             if (!boot_cpu_has(X86_FEATURE_SEV))
> >>>> +             if (boot_cpu_has(X86_FEATURE_SEV)) {
> >>>> +                     /* Expose only SEV bit and CBit location */
> >>>> +                     entry->eax &=3D F(SEV);
> >>>
> >>>
> >>> I know SEV-ES patches are not accepted yet, but can I ask to pass the
> >>> SEV-ES bit in eax?
> >>>
> >>>
> >>>> +                     entry->ebx &=3D GENMASK(5, 0);
> >>>> +                     entry->edx =3D entry->ecx =3D 0;
> >>>> +             } else {
> >>>>                        entry->eax =3D entry->ebx =3D entry->ecx =3D =
entry->edx =3D 0;
> >>>> +             }
> >>>>                break;
> >>>>        /*Add support for Centaur's CPUID instruction*/
> >>>>        case 0xC0000000:
