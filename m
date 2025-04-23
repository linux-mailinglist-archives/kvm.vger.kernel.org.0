Return-Path: <kvm+bounces-43971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2ED1A99310
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 394E17A7BFD
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273D328C5D1;
	Wed, 23 Apr 2025 15:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cwVfOiuC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B73283C87
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 15:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422627; cv=none; b=HMpLI4bA40VpNCr1HGuFECcE/Rbdf6ZvYzYUpSagKn0nZmF88GFKG1ZZVto4TZgSN3DoYXqq67roPB/L90kCXMK7GW7/5QIHHSnl9tcvdYtGnzi78h80Gk4siU27K4CUFAt/7ZWD/+6LP0zQ0fy3v86/QBM7+UvK+1CdxEq6DZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422627; c=relaxed/simple;
	bh=m5bUefd+iIWbR0Q917pboqlU1vXA+SQnzQy1GJ9Qzg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=maIwuagHtLUwy1HIQj2z1G9eytyvB5uTm/wcPHvLHpmsrisdXN4CUizNRbVMC2phRSK7PWldtKtKnkhiYVgscsamWj3mkdBCJ93CsvaGxL2HX8UPo/guQahrnCFxQa7CkxWpYu3a+y4j4iZmNW6MqENc3Dnw1CcKmgvUXYhWqYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cwVfOiuC; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e643f235a34so5057212276.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 08:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745422623; x=1746027423; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G5JxxWDG5gcJ94cp6HuR7YvaWli9rEyk5wlj9kmYJJE=;
        b=cwVfOiuCSx8RN821dLjeQfZhDdzHZRnlFsXlUmU2LqMEb2Vrzm2a/wjWq50LyCORSh
         X4J2TcqZ5kTW3PmQeNSFaUruY2dQRgLJ0U3XOBLBHCydfxqos1mqq5GFte3KN0kXFqFW
         GofDR4Gwz9nYd7DYM1O7OA8gIltqfISn07dFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745422623; x=1746027423;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G5JxxWDG5gcJ94cp6HuR7YvaWli9rEyk5wlj9kmYJJE=;
        b=En3XQg+yFHTA/KsNsVVWfwN8SSw1DiKlHIqqF2vPO7bcNfzFOCvJ1wSAuezukTFbZP
         7xFWFqwZhFITuCWYiLs0nJDK4fzrEdd/VpW3kJT/u8zMuqEXf+wMhgRsmM4dkjqf9Z2F
         rTXNNcZYU6KboBixBJHz9oFZKDjhnjXqs7TO6Qhon5bM8PtmXi1wLnsyYvVmtU+WDrZk
         hA/PtouvmdR53kP09Wi/GeACIWGrOhy0PGaO0EbM69LJ3NbF9ydWoaHUtNvVguAl7gF3
         kF1Zyze7Zm2hbt7FKBTnK+T22EJj8QeD2fPN0507JtGEGtsnVla+JeKI4zsDSX5Ol4MK
         nq6g==
X-Forwarded-Encrypted: i=1; AJvYcCUyBOXCGGv7XEAGc21ylWjVPhp/6O+hnF+ykSzYXAelQAgAmrsNuFknynq8WTXHep1QDko=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw10oNFevr20Ej+JPszZZsMPjGbriX4/UPMTuCRpzHk0CZefnod
	nDTWrG/Zm39iVOWEYNCpZujXDjnJoewvvaXO0FrxvcuG/alMv1ow5cNHyurEdxgnFkkqTutZc6w
	tXRmgeWzRVKQs10zlxF3CziSf2X0RgHYVdA0x
X-Gm-Gg: ASbGncs/fwxbCEGmbaP7iDe8oiAuKqirxkv5ZnmWsJEnlKl2L3GhA12lPVhgKJQGSnH
	h0g0MhlZlZA/J7VciCxMLpGSMsNLOM+d4lEeuCb497sL7IkAYfG1/Yv5KsSuuzjZi9AG2/suWDa
	9QW/Udn5VU61+dpZwTCyj5dyo=
X-Google-Smtp-Source: AGHT+IEV+HN17f59I2f5hBIqYl91lZVgctaUiirq9fPyVNZDNrIDArnpML/YFxpdbA3RrixDKH4riq3NZ7smC+yGHtA=
X-Received: by 2002:a05:6902:4804:b0:e6e:710:3427 with SMTP id
 3f1490d57ef6-e7297d9cfe6mr26174139276.8.1745422622769; Wed, 23 Apr 2025
 08:37:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
 <20250422161304.579394-5-zack.rusin@broadcom.com> <a803c925-b682-490f-8cd9-ca8d4cc599aa@zytor.com>
 <CABQX2QMznYZiVm40Ligq+pFKmEkVpScW+zcKYbPpGgm0=S2Xkg@mail.gmail.com> <aAjrOgsooR4RYIJr@google.com>
In-Reply-To: <aAjrOgsooR4RYIJr@google.com>
From: Zack Rusin <zack.rusin@broadcom.com>
Date: Wed, 23 Apr 2025 11:36:51 -0400
X-Gm-Features: ATxdqUFcLy0a7EiUcBCsXjdA0ggMYiiKyGOA84kPdE1qaS7HRB6HS5eEDbrdMCs
Message-ID: <CABQX2QNDmXizUDP_sckvfaM9OBTxHSr0ESgJ_=Z_5RiODfOGsg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: x86: Add support for legacy VMware backdoors
 in nested setups
To: Sean Christopherson <seanjc@google.com>
Cc: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000006f67ee063373df55"

--0000000000006f67ee063373df55
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 9:31=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Apr 23, 2025, Zack Rusin wrote:
> > On Wed, Apr 23, 2025 at 3:56=E2=80=AFAM Xin Li <xin@zytor.com> wrote:
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 300cef9a37e2..5dc57bc57851 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -4653,6 +4653,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *=
kvm, long ext)
> > > >   #ifdef CONFIG_KVM_VMWARE
> > > >       case KVM_CAP_X86_VMWARE_BACKDOOR:
> > > >       case KVM_CAP_X86_VMWARE_HYPERCALL:
> > > > +     case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
>
> I would probably omit the L0, because KVM could be running as L1.

Yea, that sounds good to me.

> > > >   #endif
> > > >               r =3D 1;
> > > >               break;
> > > > @@ -6754,6 +6755,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > > >               kvm->arch.vmware.hypercall_enabled =3D cap->args[0];
> > > >               r =3D 0;
> > > >               break;
> > > > +     case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
> > > > +             r =3D -EINVAL;
> > > > +             if (cap->args[0] & ~1)
> > >
> > > Replace ~1 with a macro for better readability please.
> >
> > Are you sure about that? This code is already used elsewhere in the
> > file  (for KVM_CAP_EXIT_ON_EMULATION_FAILURE) so, ignoring the fact
> > that it's arguable whether IS_ZERO_OR_ONE is more readable than & ~1,
> > if we use a macro for the vmware caps and not for
> > KVM_CAP_EXIT_ON_EMULATION_FAILURE then the code would be inconsistent
> > and that decreases the readability.
>
> Heh, KVM_CAP_EXIT_ON_EMULATION_FAILURE is the odd one out.  Even if that =
weren't
> the case, this is one of the situations where diverging from the existing=
 code is
> desirable, because the existing code is garbage.
>
> arch/x86/kvm/x86.c:             if (cap->args[0] & ~kvm_caps.supported_qu=
irks)
> arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_X2APIC_API_VALID_=
FLAGS)
> arch/x86/kvm/x86.c:             if (cap->args[0] & ~kvm_get_allowed_disab=
le_exits())
> arch/x86/kvm/x86.c:                 (cap->args[0] & ~KVM_X86_DISABLE_EXIT=
S_PAUSE))
> arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_MSR_EXIT_REASON_V=
ALID_MASK)
> arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_BUS_LOCK_DETECTIO=
N_VALID_MODE)
> arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_EXIT_HYPERCALL_VA=
LID_MASK) {
> arch/x86/kvm/x86.c:             if (cap->args[0] & ~1)
> arch/x86/kvm/x86.c:             if (!enable_pmu || (cap->args[0] & ~KVM_C=
AP_PMU_VALID_MASK))
> arch/x86/kvm/x86.c:             if ((u32)cap->args[0] & ~KVM_X86_NOTIFY_V=
MEXIT_VALID_BITS)
> virt/kvm/kvm_main.c:            if (cap->flags || (cap->args[0] & ~allowe=
d_options))

That's because none of those other options are boolean, right? I
assumed that the options that have valid masks use defines but
booleans use ~1 because (val & ~1) makes it obvious to the reader that
the option is in fact a boolean in a way that (val &
~KVM_SOME_VALID_BITS) can not.

I don't want to be defending the code in there, especially to its
maintainers :) I'm very happy to change it in any way you feel is more
readable to you, but I don't think it's crap :)

> > Or are you saying that since I'm already there you'd like to see a
> > completely separate patch that defines some kind of IS_ZERO_OR_ONE
> > macro for KVM, use it for KVM_CAP_EXIT_ON_EMULATION_FAILURE and, once
> > that lands then I can make use of it in this series?
>
> Xin is suggesting that you add a macro in arch/x86/include/uapi/asm/kvm.h=
 to
> #define which bits are valid and which bits are reserved.
>
> At a glance, you can kill multiple birds with one stone.  Rather than add=
 three
> separate capabilities, add one capability and then a variety of flags.  E=
.g.
>
> #define KVM_X86_VMWARE_HYPERCALL        _BITUL(0)
> #define KVM_X86_VMWARE_BACKDOOR         _BITUL(1)
> #define KVM_X86_VMWARE_NESTED_BACKDOOR  _BITUL(2)
> #define KVM_X86_VMWARE_VALID_FLAGS      (KVM_X86_VMWARE_HYPERCALL |
>                                          KVM_X86_VMWARE_BACKDOOR |
>                                          KVM_X86_VMWARE_NESTED_BACKDOOR)
>
>         case KVM_CAP_X86_VMWARE_EMULATION:
>                 r =3D -EINVAL;
>                 if (cap->args[0] & ~KVM_X86_VMWARE_VALID_FLAGS)
>                         break;
>
>                 mutex_lock(&kvm->lock);
>                 if (!kvm->created_vcpus) {
>                         if (cap->args[0] & KVM_X86_VMWARE_HYPERCALL)
>                                 kvm->arch.vmware.hypercall_enabled =3D tr=
ue;
>                         if (cap->args[0] & KVM_X86_VMWARE_BACKDOOR)
>                                 kvm->arch.vmware.backdoor_enabled;
>                         if (cap->args[0] & KVM_X86_VMWARE_NESTED_BACKDOOR=
)
>                                 kvm->arch.vmware.nested_backdoor_enabled =
=3D true;
>                         r =3D 0;
>                 }
>                 mutex_unlock(&kvm->lock);
>                 break;
>
> That approach wouldn't let userspace disable previously enabled VMware ca=
pabilities,
> but unless there's a use case for doing so, that should be a non-issue.

I'd say that if we desperately want to use a single cap for all of
these then I'd probably prefer a different approach because this would
make vmware_backdoor_enabled behavior really wacky. It's the one that
currently can only be set via kernel boot flags, so having systems
where the boot flag is on and disabling it on a per-vm basis makes
sense and breaks with this. I'd probably still write the code to be
able to disable/enable all of them because it makes sense for
vmware_backdoor_enabled. Of course, we want it on all the time, so I
also don't necessarily want to be arguing about being able to disable
those options ;)

z

--0000000000006f67ee063373df55
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
6U6qgI8F5eiKsQyE0HgYrQJx/sDs9LLVZlaNiA3U8M8CgEnb8VhuH3BN/yXphhEQdJXb1TyaJA60
SmHcZdEQZbl4EjwUcs3UIowmI/Mhi7ADQB7VNsO/BaOVBEQk53xH+4djY/cg7jvqTTeliY05j2Yx
uwwXcDC4mWjGzxAT5DVqC8fKQvon1uc2heorHb555+sLdwYxAgMBAAGjggHYMIIB1DAOBgNVHQ8B
Af8EBAMCBaAwgZMGCCsGAQUFBwEBBIGGMIGDMEYGCCsGAQUFBzAChjpodHRwOi8vc2VjdXJlLmds
b2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3I2c21pbWVjYTIwMjMuY3J0MDkGCCsGAQUFBzABhi1o
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3I2c21pbWVjYTIwMjMwZQYDVR0gBF4wXDAJ
BgdngQwBBQMBMAsGCSsGAQQBoDIBKDBCBgorBgEEAaAyCgMCMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwQQYDVR0fBDowODA2
oDSgMoYwaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3I2c21pbWVjYTIwMjMuY3JsMCIG
A1UdEQQbMBmBF3phY2sucnVzaW5AYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwMEMB8G
A1UdIwQYMBaAFAApNp5ceroPry1QLdugI4UYsKCSMB0GA1UdDgQWBBQNDn2m/OLuDx9YjEqPLCDB
s/VKNTANBgkqhkiG9w0BAQsFAAOCAgEAF463syOLTQkWZmEyyR60W1sM3J1cbnMRrBFUBt3S2NTY
SJ2NAvkTAxbPoOhK6IQdaTyrWi8xdg2tftr5FC1bOSUdxudY6dipq2txe7mEoUE6VlpJid/56Mo4
QJRb6YiykQeIfoJiYMKsyuXWsTB1rhQxlxfnaFxi8Xy3+xKAeX68DcsHG3ZU0h1beBURA44tXcz6
fFDNPQ2k6rWDFz+XNN2YOPqfse2wEm3DXpqNT79ycU7Uva7e51b8XdbmJ6XVzUFmWzhjXy5hvV8z
iF+DvP+KT1/bjO6aNL2/3PWiy1u6xjnWvobHuAYVrXxQ5wzk8aPOnED9Q8pt2nqk/UIzw2f67Cn9
3CxrVqXUKm93J+rupyKVTGgKO9T1ODVPo665aIbM72RxSI9Wsofatm2fo8DWOkrfs29pYfy6eECl
91qfFMl+IzIVfDgIrEX6gSngJ2ZLaG6L+/iNrUxHxxsaUmyDwBbTfjYwr10H6NKES3JaxVRslnpF
06HTTciJNx2wowbYF1c+BFY4r/19LHygijIVa+hZEgNuMrVLyAamaAKZ1AWxTdv8Q/eeNN3Myq61
b1ykTSPCXjBq/03CMF/wT1wly16jYjLDXZ6II/HYyJt34QeqnBENU9zXTc9RopqcuHD2g+ROT7lI
VLi5ffzC8rVliltTltbYPc7F0lAvGKAxggJXMIICUwIBATBiMFIxCzAJBgNVBAYTAkJFMRkwFwYD
VQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBD
QSAyMDIzAgxhPxw+eieHWB40hPkwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIJjT
MftN+gGJ/9KhN0MtUWSWnJRpOJtxiwoXYvwmRdbkMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTI1MDQyMzE1MzcwM1owXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQME
ASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAG9zOGZs1eXhHM+sGo7jRWOUv0XMmYpoF0JNhcko
RjrKI9UAGPMxx5LVkMnJYpJoTxDxThRXUbG4wxIekv7HIXWPn59WBGD7tcughxle/XpQYvaqFQTP
Xaj7C/wdyFLjWN0dst/+XVFDVKZgZjLsUEYBXNQcI+Lf+p+SQCLLf6SHGLXimzSwPTsNbqBkJYFZ
Sv4xBZn7u/k5s8XNuhk/Zb1kBLqOf6z8NmtloJ1LjO0SVSCSk2q3YWcTTLNSQ58HNM3zDESdpd1Y
JlOnbCYiRp/Z3W5lIFgnrKXzf1CdtE3n1tt9xJHMr+tHdreG7wBFAoZcJkwUh0df/YzQW0es+Y8=
--0000000000006f67ee063373df55--

