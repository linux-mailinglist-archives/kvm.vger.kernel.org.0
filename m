Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760E8783166
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 21:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjHUT02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 15:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjHUT01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 15:26:27 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA32D9
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 12:26:25 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-529fa243739so3010a12.0
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 12:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692645984; x=1693250784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNjhVvrEQg8GonkhyW8XalC7qWWsc9W4khrMuBFsz9E=;
        b=JgzqeI9lv3u3IFyiAjON2GheNsIJ6/VZuMa2fEeT7/6hvC93mF2FQGNL6tyHCaEMpX
         BeV1tUaiFZPqPGlQ5+lvV/VE/lOkDlAvzLkx3M+E+zXe8TJzCuiqyDFrZ8lKPO84oZzW
         /0HFC8JIthdllTtbFBfPsUaKnh51eHNJkjzRUXUSqVy9XrSKAhpefeOSXZr5vnxUHGKA
         zK2Y/iSg8bRnPuDDNsIaQaxShCsAdRFccNd35jHJXQGB8G9hV90DKiBzwIJa1J+t7911
         8KoLasgDQjKWrIY5pN57q0aPfw6d2Z/1XNgwrzGFSWqO+PlOQ5G6AhynE16PkL/v7NzE
         Z7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692645984; x=1693250784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BNjhVvrEQg8GonkhyW8XalC7qWWsc9W4khrMuBFsz9E=;
        b=S3lyT9Z2BmmVcQ08hXuhpBIet6EWdFC32Cb2cGt1g+gG9AJSdVk9lghc+23ykgnYyO
         JMuKMV/rm2GLBV0di9wjqX8o9hn0Yv/PEx4Q+njVnxftHMvjziKb/8VwMFjNCsTU7OZH
         O3ZFwPNizSspOmzJxXxkhc3e1xK615Eb7Xqs9vOed/HvqaBYqpfzaWmBEIW1shpU2muW
         2+IsHEaLQ/Mf+weTWcDeoswzrkIkqLopLsjWhk7jh6Z+WvE+IReOatTmBA9Q7EBOWCw6
         cPfianBh3HGrt3jGxhB4zAHQwLdJdT/lIrsWMfD73ZtLF311tl0DMzbPWaoKwEJivUSF
         p50g==
X-Gm-Message-State: AOJu0Yx8NBtCuFohplrr+c4l/sK5+inwe5qI05SqS59jc+ZgiDJ7N3RX
        xqOKeKbC9pGyIO364lAvabos8MNxhQu+G/1o1F1VLA==
X-Google-Smtp-Source: AGHT+IG2SYWw0/gEIzO3YykIw9nP9jvRJc6MtYtXIUNdBQNCqUSwkzeLDmmU7f78DJ+NHE7Ph0Us4aNzl9WgOWOKC00=
X-Received: by 2002:a50:d50b:0:b0:522:4741:d992 with SMTP id
 u11-20020a50d50b000000b005224741d992mr26306edi.4.1692645984073; Mon, 21 Aug
 2023 12:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230818233451.3615464-1-srutherford@google.com>
 <08418fc0-839a-f2fb-1c2e-b4f077d2647b@amd.com> <CABayD+cw3s1UDSN7oR4gWfRT4-snWEqOgAN-y4rzOpe-8D=KdA@mail.gmail.com>
 <2a391d50-d474-eec5-76ea-e5dc5590609c@amd.com>
In-Reply-To: <2a391d50-d474-eec5-76ea-e5dc5590609c@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 21 Aug 2023 12:25:47 -0700
Message-ID: <CABayD+f3BLjg4ekO=b4yweqsV4-kA3nfDjKh7MieMh+=zvkA=Q@mail.gmail.com>
Subject: Re: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page aligned
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023 at 11:54=E2=80=AFAM Tom Lendacky <thomas.lendacky@amd.=
com> wrote:
>
> On 8/21/23 13:15, Steve Rutherford wrote:
> > On Mon, Aug 21, 2023 at 6:10=E2=80=AFAM Tom Lendacky <thomas.lendacky@a=
md.com> wrote:
> >>
> >> On 8/18/23 18:34, Steve Rutherford wrote:
> >>> early_set_memory_decrypted() assumes its parameters are page aligned.
> >>> Non-page aligned calls result in additional pages being marked as
> >>> decrypted via the encryption status hypercall, which results in
> >>> consistent corruption of pages during live migration. Live
> >>> migration requires accurate encryption status information to avoid
> >>> migrating pages from the wrong perspective.
> >>
> >> Hmmm... I'm not sure this is the proper fix. The code is actually doin=
g
> >> the right thing from a encyrption/decryption point of view by checking=
 the
> >> c-bit for the PTE associated with the virtual address and the size
> >> (possibly crossing page boundaries).
> >>
> >> I think the problem is on the call to early_set_mem_enc_dec_hypercall(=
)
> >> where it doesn't take into account the possible crossing of page
> >> boundaries and so can under-count the number of pages, right?
> >
> > Right now, if you request decryption of e.g. a non-page aligned 0x40
> > byte structure, it rounds the 0x40 bytes up to one page, and then
> > hypercalls to mark both the page it's on and the subsequent page as
> > decrypted (since the rounding stretches the structure onto the next
> > page spuriously). The arithmetic in the combination of
> > early_set_memory_enc_dec() and early_set_mem_enc_dec_hypercall() are
> > correct if they are called with page aligned vaddrs (non-page-aligned
> > sizes are fine iiuc).
>
> Ah, right, correct. It is still related to how the page count is
> calculated for the hypercall, though, right? The encryption/decryption
> operations function properly.

Yep! It's just the hypercall that behaves poorly in this situation.
>
> If another caller of early_set_memory_decrypted() gets added, it would
> need to know to do the same thing. So I just wonder if this wouldn't be
> better fixed in early_set_memory_enc_dec() by using a page aligned addres=
s
> and proper number of pages when calling early_set_mem_enc_dec_hypercall()
> or in early_set_mem_enc_dec_hypercall() where it would take a size
> argument instead of a page count and does the proper work to get a page
> aligned address and proper page count.
>
> Also, if it is the hypercall that is causing the issue, should the Fixes
> tag be 064ce6c550a0 ("mm: x86: Invoke hypercall when page encryption
> status is changed") since the problem is around the hypercall.

Fair question. I was torn about where to point this, since either
fixing up the value inside early_set_memory_enc_dec() or fixing up the
per-cpu callers is correct. The non-early version
(__set_memory_enc_pgtable()) calls WARN_ONCE for misaligned addresses
under the hood, so I thought the early version should have the same
contract (though, obviously, this lacks the actual WARN_ONCE). I can
re-upload with a WARN_ONCE or with the masking moved into
early_set_memory_enc_dec().
Thanks,
Steve

>
> Thanks,
> Tom
>
> >
> > Thanks,
> > Steve
> >>
> >> Thanks,
> >> Tom
> >>
> >>>
> >>> Fixes: 4716276184ec ("X86/KVM: Decrypt shared per-cpu variables when =
SEV is active")
> >>> Signed-off-by: Steve Rutherford <srutherford@google.com>
> >>> ---
> >>>    arch/x86/kernel/kvm.c | 14 +++++++++++++-
> >>>    1 file changed, 13 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> >>> index 6a36db4f79fd..a0c072d3103c 100644
> >>> --- a/arch/x86/kernel/kvm.c
> >>> +++ b/arch/x86/kernel/kvm.c
> >>> @@ -419,7 +419,14 @@ static u64 kvm_steal_clock(int cpu)
> >>>
> >>>    static inline void __set_percpu_decrypted(void *ptr, unsigned long=
 size)
> >>>    {
> >>> -     early_set_memory_decrypted((unsigned long) ptr, size);
> >>> +     /*
> >>> +      * early_set_memory_decrypted() requires page aligned parameter=
s, but
> >>> +      * this function needs to handle ptrs offset into a page.
> >>> +      */
> >>> +     unsigned long start =3D PAGE_ALIGN_DOWN((unsigned long) ptr);
> >>> +     unsigned long end =3D (unsigned long) ptr + size;
> >>> +
> >>> +     early_set_memory_decrypted(start, end - start);
> >>>    }
> >>>
> >>>    /*
> >>> @@ -438,6 +445,11 @@ static void __init sev_map_percpu_data(void)
> >>>                return;
> >>>
> >>>        for_each_possible_cpu(cpu) {
> >>> +             /*
> >>> +              * Calling __set_percpu_decrypted() for each per-cpu va=
riable is
> >>> +              * inefficent, since it may decrypt the same page multi=
ple times.
> >>> +              * That said, it avoids the need for more complicated l=
ogic.
> >>> +              */
> >>>                __set_percpu_decrypted(&per_cpu(apf_reason, cpu), size=
of(apf_reason));
> >>>                __set_percpu_decrypted(&per_cpu(steal_time, cpu), size=
of(steal_time));
> >>>                __set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), si=
zeof(kvm_apic_eoi));
