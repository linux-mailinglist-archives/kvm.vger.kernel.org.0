Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC987C53FD
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 14:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346768AbjJKM2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 08:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346827AbjJKM2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 08:28:13 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F44E8
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:28:07 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2c124adf469so78903331fa.0
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philjordan-eu.20230601.gappssmtp.com; s=20230601; t=1697027286; x=1697632086; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJXJz/R1LdTU6nV53gSCaf04TkZrngzuySLoN5TykJg=;
        b=agquRieSmtbDWBK1KGZ6Ievxh0V8YThvohxILOP2fm8amns+GeCeNHSUD14jJy8rHE
         A8MSYdL3h1wvrZGtCVM7IRPyVHCJPFHTQtyiId4YjgIVXthzJl7N6Fe+6Jlu0BSL1iSY
         SOZLccQhhqA9If/fUTw+1f4Ha8sEm05E+9S2f8HPl5HjVJETSXqXB6Z6pLlGrKzotTnz
         4VoJKtuJeo+Mnd6Ii0pmCYIJAakqge1SHftrXrwqfvh7FXlcXaVrTtUkYcFnTkJGr5LZ
         scfu4uwolo29YzwJYdn8WlGNoadyvjpVPSFJaOkRf4gYt9C0fCIY6nrcuDZPlGOi40X1
         8xQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697027286; x=1697632086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJXJz/R1LdTU6nV53gSCaf04TkZrngzuySLoN5TykJg=;
        b=suZ9A+IrQyUBHxuDS8unATY+gS5xmfOYo9k0uSXr7cPG+0sJNoykEZYskADYGYZodZ
         mkY6RzIHIBwCJpX4L4owhZkhafkbtGbz2LAg4FqHnZQz4pQG2D1ywHQlYYysE77Y+STi
         FBkkIFNnKL+cpQNzFmSng5NPXHcx/Z7Bqvt+UWAVDTyANFVm6BqHwlNm7h1TxPulXQly
         OUCCCPoi3UqLZ4nAjgIJspzWWqCfx7jl2K9lJSRioNYAC5dbs/t2YDMjbxMMuN8Tw9pp
         9jFF7jwQVlxwcAq5Cc9SarZ6eNK9SuOle141pDGQNWu3nrvOAfakROlOaCqOIwFCDxcr
         zH6Q==
X-Gm-Message-State: AOJu0YzXJB7aj5k8pTVWd8M61gMVgveVl+5H0F9nB51HL5ryd4GbdAux
        /Ps/4kRZV5iLvTNicolp0A5ZRAuaBv1No5VuRiOHbg==
X-Google-Smtp-Source: AGHT+IFAWQRLyXJheZtDXMni88vD1awQjaMgwsOG/ZIhYmyFJwYpipBbrS6veKjaFx2XgZdUcmSNj8wrOUwKRdFwp1c=
X-Received: by 2002:ac2:5d31:0:b0:503:778:9ad2 with SMTP id
 i17-20020ac25d31000000b0050307789ad2mr15795510lfb.19.1697027285851; Wed, 11
 Oct 2023 05:28:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230923102019.29444-1-phil@philjordan.eu> <ZRGkqY+2QQgt2cVq@google.com>
 <CAGCz3vve7RJ+HE8sHOvq1p5-Wc4RpgZwqp0DiCXiSWq0vUpEVw@mail.gmail.com>
 <ZRMB9HUIBcWWHtwK@google.com> <CAGCz3vuieUoD0UombFzxKYygm8uS4Gr=qkUAKR7oR0Tg+mEnYQ@mail.gmail.com>
 <ZRQ5r0kn5RzDpf0C@google.com> <CAGCz3vsQ9hUkgX5dyy9er8y4_y1rM2eWrfLHkWV0xv6aJwNzeQ@mail.gmail.com>
In-Reply-To: <CAGCz3vsQ9hUkgX5dyy9er8y4_y1rM2eWrfLHkWV0xv6aJwNzeQ@mail.gmail.com>
From:   Phil Dennis-Jordan <lists@philjordan.eu>
Date:   Wed, 11 Oct 2023 14:27:52 +0200
Message-ID: <CAGCz3vu6o8yv6YxkVFnYr_BTwccrUuqu1hRGVrzvMuwEV5-+Vg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Gates test_pv_ipi on KVM cpuid,
 not test device
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've now got around to testing this patch on Linux/KVM.

The thing I was worried about, my <linux/types.h> wrapper, appears to
work exactly as intended, everything builds nicely on Linux. So that
aspect of the patch is now a matter of taste.

However, I *have* run into a minor snag with this proposed change: the
X86_FEATURE_KVM_PV_SEND_IPI bit isn't actually enabled by default. It
looks like it needs to be specified explicitly as a +kvm-pv-ipi flag
in the -cpu option on the Qemu command line. KVM itself still handles
the IPI hypercall either way, as there's another flag you'd have to
opt into for only handling advertised hypercalls.

I think the cleanest way to fix this is probably to add +kvm-pv-ipi to
the apic-split, x2apic, and xapic test suites in x86/unittests.cfg and
keep the strict feature flag check in the test code. As I understand
it, Qemu will filter the feature bit if the underlying KVM
implementation doesn't support it, so that would appear to give us the
best compatibility, except perhaps for Qemu versions that predate this
flag, which will presumably fail to run the test suites altogether.

Alternatively, we could simply check whether we're running on KVM and
skip the feature bit check entirely - it certainly wouldn't make any
additional assumptions; as of right now, the master branch already
assumes we're running on KVM *and* the KVM implementation supports the
IPI HC. Dropping the feature bit check doesn't make the patch tangibly
smaller though.

I'll wait a couple of days for any other suggestions or objections,
and in the absence of such I'll roll your draft patch, my
modifications, and the x86/unittests.cfg tweaks into a v2 patch and
re-submit. (And I'll tag it with you, Sean, as Co-authored-by:)

Thanks,
Phil

On Thu, 5 Oct 2023 at 22:19, Phil Dennis-Jordan <lists@philjordan.eu> wrote=
:
>
> On Wed, Sep 27, 2023 at 4:18=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > Gah, sorry.  This is why I usually inline patches, I forget to actually=
 att=3D
> > ach
> > the darn things 50% of the time.
>
> Thanks for that, and apologies for only just getting around to taking
> a closer look. Out of the box, this doesn't build on macOS at least,
> as that's missing <linux/types.h>. I tried going down the rabbit hole
> of pulling that header and its various transitive dependencies in from
> the Linux tree, but ended up in a horrible mess where those headers
> try to define things like bool, which libcflat has already pulled in
> from the standard system headers (on Linux I suspect the libc #include
> guards match up with the stuff in <linux/*>, so there's no issue).
> On macOS, the problem is easy to resolve via a cut-down types.h with a
> minimal set of definitions:
>
> #include <libcflat.h>
> typedef u8  __u8;
> typedef u32 __u32;
> typedef u64 __u64;
> typedef s64 __s64;
>
> =E2=80=A6but I assume that breaks things on Linux. I'm thinking something=
 like
> this might work:
>
> #if __LINUX__
> #include_next <linux/types.h>
> #else
> [minimal types.h definitions]
> #endif
>
> But I'm unsure if that's really the direction you'd want to go with
> this? (And I still need to set myself up with a dev environment on a
> physical Linux box that I can test this all on.)
>
> Another option might be a symlinked linux/types.h created by
> ./configure if not running on Linux?
>
>
> On the substance of the patch itself:
>
> >         unsigned long a0 =3D 0xFFFFFFFF, a1 =3D 0, a2 =3D 0xFFFFFFFF, a=
3 =3D 0x0;
> > -       if (!test_device_enabled())
> > +       if (!this_cpu_has(X86_FEATURE_KVM_PV_SEND_IPI))
>
> So this check will (erroneously IMO) succeed if we're running on a
> non-KVM hypervisor which happens to expose a flag at bit 11 of ecx on
> CPUID leaf 0x40000001 page 0, right? With this in mind, your earlier
> idea seems better:
>
>         if (!is_hypervisor_kvm() ||
> !this_cpu_has(X86_FEATURE_KVM_PV_SEND_IPI)) {
>
> So I've gone ahead and made an attempt at fixing up your draft
> implementation of is_hypervisor_kvm() below.
>
> The partial struct memcmp in get_hypervisor_cpuid_base is a bit icky;
> I'm not sure if that's worth fixing up at the cost of readability.
>
>
> Thoughts?
>
> (I've attached the full set of WIP changes on top of yours as another
> patch. Feel free to squash it all into one if you decide to run with
> it.)
>
> Thanks,
> Phil
>
>
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 7a7048f9..3d3930c8 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -240,6 +240,7 @@ static inline bool is_intel(void)
>  #define    X86_FEATURE_XSAVE        (CPUID(0x1, 0, ECX, 26))
>  #define    X86_FEATURE_OSXSAVE        (CPUID(0x1, 0, ECX, 27))
>  #define    X86_FEATURE_RDRAND        (CPUID(0x1, 0, ECX, 30))
> +#define    X86_FEATURE_HYPERVISOR        (CPUID(0x1, 0, ECX, 31))
>  #define    X86_FEATURE_MCE            (CPUID(0x1, 0, EDX, 7))
>  #define    X86_FEATURE_APIC        (CPUID(0x1, 0, EDX, 9))
>  #define    X86_FEATURE_CLFLUSH        (CPUID(0x1, 0, EDX, 19))
> @@ -286,7 +287,8 @@ static inline bool is_intel(void)
>  #define X86_FEATURE_VNMI        (CPUID(0x8000000A, 0, EDX, 25))
>  #define    X86_FEATURE_AMD_PMU_V2        (CPUID(0x80000022, 0, EAX, 0))
>
> -#define X86_FEATURE_KVM_PV_SEND_IPI    (CPUID(KVM_CPUID_FEATURES, 0,
> EAX, KVM_FEATURE_PV_SEND_IPI))
> +#define X86_FEATURE_KVM_PV_SEND_IPI \
> +    (CPUID(KVM_CPUID_FEATURES, 0, EAX, KVM_FEATURE_PV_SEND_IPI))
>
>  static inline bool this_cpu_has(u64 feature)
>  {
> @@ -303,6 +305,40 @@ static inline bool this_cpu_has(u64 feature)
>      return ((*(tmp + (output_reg % 32))) & (1 << bit));
>  }
>
> +static inline u32 get_hypervisor_cpuid_base(const char *sig)
> +{
> +    u32 base;
> +    struct cpuid signature;
> +
> +    if (!this_cpu_has(X86_FEATURE_HYPERVISOR))
> +        return 0;
> +
> +    for (base =3D 0x40000000; base < 0x40010000; base +=3D 0x100) {
> +        signature =3D cpuid(base);
> +
> +        if (!memcmp(sig, &signature.b, 12))
> +            return base;
> +    }
> +
> +    return 0;
> +}
> +
> +static inline bool is_hypervisor_kvm(void)
> +{
> +    u32 base =3D get_hypervisor_cpuid_base(KVM_SIGNATURE);
> +
> +    if (!base)
> +        return false;
> +
> +    /*
> +     * Require that KVM be placed at its default base so that macros can=
 be
> +     * used to query individual KVM feature bits.
> +     */
> +    assert_msg(base =3D=3D KVM_CPUID_SIGNATURE,
> +           "Expect KVM at its default cpuid base (now at: 0x%x)", base);
> +    return true;
> +}
> +
>  struct far_pointer32 {
>      u32 offset;
>      u16 selector;
