Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC022783017
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 20:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbjHUSQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 14:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbjHUSQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 14:16:03 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5223E130
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 11:15:55 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-521e046f6c7so1470a12.1
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 11:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692641754; x=1693246554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=keED6Cwr6vXOGPO+FVt/8foMxwHNt5N9e1feSYAJ4qE=;
        b=4/JnNL9mE2WWjBI2+VGUdxaB93kI5lNvksfm0FI/3pK2urV4dHfMcd/HUlgfMoRm0n
         G3M62ENtKI4X6H6s0tqdQzrhFzEj+XV0GO2mZwk7xUKhmiihQhljI8uKxrls4F3e5FQi
         6hm2GKxr7NE30AFcztUEFeRfatfcXabI0RBrFMWo5/YI66BHmOx1IgMFPlXRrO9uIW5M
         CXsHpDJGAO8Ev+/beRdGDdg1WGNRPezTq3DAnkcEB1GmWmMw7+Ov178oSZZJ5FpG5Epz
         XcQ6mEH6HycM24ol+NLP0KRXe3x+q8bK3DlYFSwtywy/KMLADOGc6M6ovv3n7iknpOmZ
         3Gsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692641754; x=1693246554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=keED6Cwr6vXOGPO+FVt/8foMxwHNt5N9e1feSYAJ4qE=;
        b=gAnZj6IBIZimxDh45Bm9/nAr84DaU7NrxKwq434F/+R50df6yk3aDOo+suj4GiSFWN
         RcqG6Rzdlx8vsbBwaAT+LkJm6/mkPX7vel7o9Aky6BcNBwE1Iz9cfflOfvzUq6owSRMT
         5CaQUPqdhEOvrCJM02k1ectRMesy8AYa2tZsXsFJ+ZBuqxs9cBd/vN16YsUtNy6JWeXu
         pHmCdSnzS3jIFrQiQ97TgIn8rGsKouufP22BZMZmWha+3ZPnlIk5RzwRJ/iFngrTe99P
         Z5qAADXz2MAZqIcv7G1PBWXOWe1AUX48Aysn0vVGsYNeTXuzgkyrJlnDA/X6ZTVm7B7i
         JRXg==
X-Gm-Message-State: AOJu0YxJcqTCEMVCSM/6ZlQ5/7HS4TVQ6MxyFWafC7d6TzpJ7/azVq9w
        DLxJgu6CFO5Kd7luLbul9dqwifQyAXZxX7IVe7XX8w==
X-Google-Smtp-Source: AGHT+IFfAQQQsSwTTg7CzNzDZU5E0GvFStAbwHVl6x7OXZrwdPCyepatuziq++QyBIYcwy88JBkOWAO6bc8wiKOdBDU=
X-Received: by 2002:a50:d4da:0:b0:51e:16c5:2004 with SMTP id
 e26-20020a50d4da000000b0051e16c52004mr14349edj.6.1692641753730; Mon, 21 Aug
 2023 11:15:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230818233451.3615464-1-srutherford@google.com> <08418fc0-839a-f2fb-1c2e-b4f077d2647b@amd.com>
In-Reply-To: <08418fc0-839a-f2fb-1c2e-b4f077d2647b@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 21 Aug 2023 11:15:17 -0700
Message-ID: <CABayD+cw3s1UDSN7oR4gWfRT4-snWEqOgAN-y4rzOpe-8D=KdA@mail.gmail.com>
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

On Mon, Aug 21, 2023 at 6:10=E2=80=AFAM Tom Lendacky <thomas.lendacky@amd.c=
om> wrote:
>
> On 8/18/23 18:34, Steve Rutherford wrote:
> > early_set_memory_decrypted() assumes its parameters are page aligned.
> > Non-page aligned calls result in additional pages being marked as
> > decrypted via the encryption status hypercall, which results in
> > consistent corruption of pages during live migration. Live
> > migration requires accurate encryption status information to avoid
> > migrating pages from the wrong perspective.
>
> Hmmm... I'm not sure this is the proper fix. The code is actually doing
> the right thing from a encyrption/decryption point of view by checking th=
e
> c-bit for the PTE associated with the virtual address and the size
> (possibly crossing page boundaries).
>
> I think the problem is on the call to early_set_mem_enc_dec_hypercall()
> where it doesn't take into account the possible crossing of page
> boundaries and so can under-count the number of pages, right?

Right now, if you request decryption of e.g. a non-page aligned 0x40
byte structure, it rounds the 0x40 bytes up to one page, and then
hypercalls to mark both the page it's on and the subsequent page as
decrypted (since the rounding stretches the structure onto the next
page spuriously). The arithmetic in the combination of
early_set_memory_enc_dec() and early_set_mem_enc_dec_hypercall() are
correct if they are called with page aligned vaddrs (non-page-aligned
sizes are fine iiuc).

Thanks,
Steve
>
> Thanks,
> Tom
>
> >
> > Fixes: 4716276184ec ("X86/KVM: Decrypt shared per-cpu variables when SE=
V is active")
> > Signed-off-by: Steve Rutherford <srutherford@google.com>
> > ---
> >   arch/x86/kernel/kvm.c | 14 +++++++++++++-
> >   1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 6a36db4f79fd..a0c072d3103c 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -419,7 +419,14 @@ static u64 kvm_steal_clock(int cpu)
> >
> >   static inline void __set_percpu_decrypted(void *ptr, unsigned long si=
ze)
> >   {
> > -     early_set_memory_decrypted((unsigned long) ptr, size);
> > +     /*
> > +      * early_set_memory_decrypted() requires page aligned parameters,=
 but
> > +      * this function needs to handle ptrs offset into a page.
> > +      */
> > +     unsigned long start =3D PAGE_ALIGN_DOWN((unsigned long) ptr);
> > +     unsigned long end =3D (unsigned long) ptr + size;
> > +
> > +     early_set_memory_decrypted(start, end - start);
> >   }
> >
> >   /*
> > @@ -438,6 +445,11 @@ static void __init sev_map_percpu_data(void)
> >               return;
> >
> >       for_each_possible_cpu(cpu) {
> > +             /*
> > +              * Calling __set_percpu_decrypted() for each per-cpu vari=
able is
> > +              * inefficent, since it may decrypt the same page multipl=
e times.
> > +              * That said, it avoids the need for more complicated log=
ic.
> > +              */
> >               __set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(=
apf_reason));
> >               __set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(=
steal_time));
> >               __set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeo=
f(kvm_apic_eoi));
