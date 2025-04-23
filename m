Return-Path: <kvm+bounces-43981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCDEA995E6
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:58:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5995B1B6457E
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 16:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41ACB28A1D6;
	Wed, 23 Apr 2025 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AleemZ11"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD10F280A3A
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 16:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745427527; cv=none; b=Usne9ljmBUSSG+sgmt4g1gd40oEhhMIw0eTdMoErRrDmzgwr4R8vRTG150rO9FXZqMvNV5M/PH1sILjHNUt+HTIMgDB77TA3+aRTjYGE2Jwv8Ga/z4dyHJRN3ekKfc5BRygfF6foza+uqfEwnT5GeehH/eBYG9WRJPj7i+1QKoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745427527; c=relaxed/simple;
	bh=VdWUzKBbCPiBoPnpmvNfUHFYvZseqPBdmJp/LKt9lCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HK9YWd5QnHAaDvM/dUe6fBWBw22quWxZDJaEp8Ip1Zfid6ZHI3itKcPOoo10wSLIS+V+RBzYJJpmY7k+5gMvO1cjEu0jKmvbEUqkiIjM4xWzfQM7TvPxSz3msOL/y0UioXTOCwd7HC3FStvYvdLM9d52b5XjVBZZtd5AJoE96vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AleemZ11; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-70814384238so1683187b3.0
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 09:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745427524; x=1746032324; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vd3/XO0QgJqY5ocsHGyI61sNK0Odt7/twGlpcBpcnOE=;
        b=AleemZ11oYcYAnk51cgmUdFpMgF/OLAiKHY5yuPz4timcFKh3puHrX+ygL9APIVMKZ
         Xc4sjJlV43M0+3dJKNu1frDjgvD+CSTtVZtlC5Tjy6Ma9ejFRO/w5OKdSBYBCON5xLAT
         v6v0zWdmmjUX+2WiAaFDFAOGlP/2b5Ab3+tLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745427524; x=1746032324;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vd3/XO0QgJqY5ocsHGyI61sNK0Odt7/twGlpcBpcnOE=;
        b=II7tE9wnalsQ3bGNF5hmSpKvnR2/s8QKqwzCCaFKCIDhm7gOrzjY5tXrBpHH2I3f5+
         /vqIPR/OhaEMUTA7qS0ZO9JOawl+ff7wEH9HExthpeP1MMpyUlEZP/hvfMGQE5nWulu7
         LdigjeNflK0trExaLfeHmiPEGl9E7YSXd4NL3wh6S4WLQIUjifNELBLplqSbZWsi+d3E
         xF5X0WNa36srqUTlaOzzsrJwDeNaemQ7210NUICQS70RPHHmVQmDjc8oYOV0YkCypsqk
         RSr3FyD0UomQ0uxvpEc0eguzCT974RpFNZdTPb+edVKZE0hRJPn8SVJyaDhAiiMCd6Uh
         DFYw==
X-Forwarded-Encrypted: i=1; AJvYcCWgSmekmy/znIA9zaOE+bB7WYdlTG37SZwMfreOFjJwQODQSj5naF+0GTvjb5/U8cuxX5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTzaGVg48yYVa0rUWqSx3Dwf0ynBDDU4mOFkNDs2wPgmrJIxDn
	qXzNgV4cwKdvmMUk7Lx87TI3eyqyOKK2jLKcwtNGRNfCpjw8sOaFZAW7RCuKt44yqpFpkfMFXLl
	EvSIYp/rgkWoc7gtKcRy6NdQjRVXex633ixJU
X-Gm-Gg: ASbGncuVcoZgL5GYAJFct+26G7bx1B18vrZDmkGh5P18uAkd2VrFp6+2yhdOtr+Vwuw
	gwWqrc5dMvqKJCIAcvK+tqzRpsG3H1IyKwNz8Y62bEZpFUed0zJtJwwDzpB8OtfY1bxfSCZQrua
	8d1qBcSGzJOyVguhtm/Y4+px4=
X-Google-Smtp-Source: AGHT+IFZQyxjqYrUesRt8QUNMGHcWI9NzYMj3bs8zwAjQkhD5HAZhlgsNyXFxQ0aKndetcIyLanDkuaC36kyR2JtHyA=
X-Received: by 2002:a05:690c:968c:b0:6f9:7b99:8a29 with SMTP id
 00721157ae682-706cdbbc6eamr252873387b3.34.1745427524473; Wed, 23 Apr 2025
 09:58:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
 <20250422161304.579394-5-zack.rusin@broadcom.com> <a803c925-b682-490f-8cd9-ca8d4cc599aa@zytor.com>
 <CABQX2QMznYZiVm40Ligq+pFKmEkVpScW+zcKYbPpGgm0=S2Xkg@mail.gmail.com>
 <aAjrOgsooR4RYIJr@google.com> <CABQX2QNDmXizUDP_sckvfaM9OBTxHSr0ESgJ_=Z_5RiODfOGsg@mail.gmail.com>
 <aAkNN029DIxYay-j@google.com>
In-Reply-To: <aAkNN029DIxYay-j@google.com>
From: Zack Rusin <zack.rusin@broadcom.com>
Date: Wed, 23 Apr 2025 12:58:32 -0400
X-Gm-Features: ATxdqUGPIdiMBMGwq_SanvxlI7YJq-9AUJAWEGcxqONPSX-FHzSK8-WHCUeDg8A
Message-ID: <CABQX2QPUsKfkKYKnXG01A-jEu_7dbY7qBnEHyhYJnsSXD-jqng@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: x86: Add support for legacy VMware backdoors
 in nested setups
To: Sean Christopherson <seanjc@google.com>
Cc: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000009aa16806337503b8"

--0000000000009aa16806337503b8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 11:54=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, Apr 23, 2025, Zack Rusin wrote:
> > On Wed, Apr 23, 2025 at 9:31=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > Heh, KVM_CAP_EXIT_ON_EMULATION_FAILURE is the odd one out.  Even if t=
hat weren't
> > > the case, this is one of the situations where diverging from the exis=
ting code is
> > > desirable, because the existing code is garbage.
> > >
> > > arch/x86/kvm/x86.c:             if (cap->args[0] & ~kvm_caps.supporte=
d_quirks)
> > > arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_X2APIC_API_VA=
LID_FLAGS)
> > > arch/x86/kvm/x86.c:             if (cap->args[0] & ~kvm_get_allowed_d=
isable_exits())
> > > arch/x86/kvm/x86.c:                 (cap->args[0] & ~KVM_X86_DISABLE_=
EXITS_PAUSE))
> > > arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_MSR_EXIT_REAS=
ON_VALID_MASK)
> > > arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_BUS_LOCK_DETE=
CTION_VALID_MODE)
> > > arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_EXIT_HYPERCAL=
L_VALID_MASK) {
> > > arch/x86/kvm/x86.c:             if (cap->args[0] & ~1)
> > > arch/x86/kvm/x86.c:             if (!enable_pmu || (cap->args[0] & ~K=
VM_CAP_PMU_VALID_MASK))
> > > arch/x86/kvm/x86.c:             if ((u32)cap->args[0] & ~KVM_X86_NOTI=
FY_VMEXIT_VALID_BITS)
> > > virt/kvm/kvm_main.c:            if (cap->flags || (cap->args[0] & ~al=
lowed_options))
> >
> > That's because none of those other options are boolean, right? I
> > assumed that the options that have valid masks use defines but
> > booleans use ~1 because (val & ~1) makes it obvious to the reader that
> > the option is in fact a boolean in a way that (val &
> > ~KVM_SOME_VALID_BITS) can not.
>
> The entire reason when KVM checks and enforces cap->args[0] is so that KV=
M can
> expand the capability's functionality in the future.  Whether or not a ca=
pability
> is *currently* a boolean, i.e. only has one supported flag, is completely=
 irrelevant.
>
> KVM has burned itself many times over by not performing checks, e.g. is h=
ow we
> ended up with things like KVM_CAP_DISABLE_QUIRKS2.
>
> > > > Or are you saying that since I'm already there you'd like to see a
> > > > completely separate patch that defines some kind of IS_ZERO_OR_ONE
> > > > macro for KVM, use it for KVM_CAP_EXIT_ON_EMULATION_FAILURE and, on=
ce
> > > > that lands then I can make use of it in this series?
> > >
> > > Xin is suggesting that you add a macro in arch/x86/include/uapi/asm/k=
vm.h to
> > > #define which bits are valid and which bits are reserved.
> > >
> > > At a glance, you can kill multiple birds with one stone.  Rather than=
 add three
> > > separate capabilities, add one capability and then a variety of flags=
.  E.g.
> > >
> > > #define KVM_X86_VMWARE_HYPERCALL        _BITUL(0)
> > > #define KVM_X86_VMWARE_BACKDOOR         _BITUL(1)
> > > #define KVM_X86_VMWARE_NESTED_BACKDOOR  _BITUL(2)
> > > #define KVM_X86_VMWARE_VALID_FLAGS      (KVM_X86_VMWARE_HYPERCALL |
> > >                                          KVM_X86_VMWARE_BACKDOOR |
> > >                                          KVM_X86_VMWARE_NESTED_BACKDO=
OR)
> > >
> > >         case KVM_CAP_X86_VMWARE_EMULATION:
> > >                 r =3D -EINVAL;
> > >                 if (cap->args[0] & ~KVM_X86_VMWARE_VALID_FLAGS)
> > >                         break;
> > >
> > >                 mutex_lock(&kvm->lock);
> > >                 if (!kvm->created_vcpus) {
> > >                         if (cap->args[0] & KVM_X86_VMWARE_HYPERCALL)
> > >                                 kvm->arch.vmware.hypercall_enabled =
=3D true;
> > >                         if (cap->args[0] & KVM_X86_VMWARE_BACKDOOR)
> > >                                 kvm->arch.vmware.backdoor_enabled;
> > >                         if (cap->args[0] & KVM_X86_VMWARE_NESTED_BACK=
DOOR)
> > >                                 kvm->arch.vmware.nested_backdoor_enab=
led =3D true;
> > >                         r =3D 0;
> > >                 }
> > >                 mutex_unlock(&kvm->lock);
> > >                 break;
> > >
> > > That approach wouldn't let userspace disable previously enabled VMwar=
e capabilities,
> > > but unless there's a use case for doing so, that should be a non-issu=
e.
> >
> > I'd say that if we desperately want to use a single cap for all of
> > these then I'd probably prefer a different approach because this would
> > make vmware_backdoor_enabled behavior really wacky.
>
> How so?  If kvm.enable_vmware_backdoor is true, then the backdoor is enab=
led
> for all VMs, else it's disabled by default but can be enabled on a per-VM=
 basis
> by the new capability.

Like you said if  kvm.enable_vmware_backdoor is true, then it's
enabled for all VMs, so it'd make sense to allow disabling it on a
per-vm basis on those systems.
Just like when the kvm.enable_vmware_backdoor is false, the cap can be
used to enable it on a per-vm basis.

> > It's the one that currently can only be set via kernel boot flags, so h=
aving
> > systems where the boot flag is on and disabling it on a per-vm basis ma=
kes
> > sense and breaks with this.
>
> We could go this route, e.g. KVM does something similar for PMU virtualiz=
ation.
> But the key difference is that enable_pmu is enabled by default, whereas
> enable_vmware_backdoor is disabled by default.  I.e. it makes far more se=
nse for
> the capability to let userspace opt-in, as opposed to opt-out.
>
> > I'd probably still write the code to be able to disable/enable all of t=
hem
> > because it makes sense for vmware_backdoor_enabled.
>
> Again, that's not KVM's default, and it will never be KVM's default.

All I'm saying is that you can enable it on a whole system via the
boot flags and on the systems on which it has been turned on it'd make
sense to allow disabling it on a per-vm basis. Anyway, I'm sure I can
make it work correctly under any constraints, so let me try to
understand the issue because I'm not sure what we're solving here. Is
the problem the fact that we have three caps and instead want to
squeeze all of the functionality under one cap?

z

--0000000000009aa16806337503b8
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
QSAyMDIzAgxhPxw+eieHWB40hPkwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIM3+
B6y9H07cql6H2MO/+8zIstEbCeb6doynR2O1+dfAMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTI1MDQyMzE2NTg0NFowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQME
ASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJI2IbdGvdut20sP8kf1taobvEKIFoqcKfXG5AFB
iP22g5WGY+ZGP/YVYSnGeSw2ZxoGOYjQ0iEgAtf/7XNRRyk4sdtQx1mQynuGiFJpg+GNUBwpaIfD
ONXQ/8UVEQnTwudt9j/fVQqlacmRHmj/zTmgKoPgAgrNTpYsY9FiaYnxVewcQRBcjmMNXqlFh3x/
Ztcpkj8uF8xGtaLnTKP4D+UVOKRYTH+a48zQ6TMj9O0BGvaTq/jBMeJXLGALmDrernABBVyFG2i7
dfa+s8pPTORQgupt3v1k/h14yXnoZt66KYIV+3L6oN3WEYLLNLLKZhB/InjXmXfyHGQ+IYSnawc=
--0000000000009aa16806337503b8--

