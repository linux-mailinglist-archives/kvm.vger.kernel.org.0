Return-Path: <kvm+bounces-43931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 696A9A988C7
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 13:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EACD5A10CF
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB89270548;
	Wed, 23 Apr 2025 11:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ctgMsoDh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2D626D4F9
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 11:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745408632; cv=none; b=o/604FcUh1ID11whzpIyCpQBME7R+fyoGyXNhYR4z2saz8AgfRa2y6zgVFvEF51LpQk3bQqxB/o36QS2LK3M/XGScFE1SFfUDUk65+fskhkxXraW0+8qyB3+MaFr2MDCZj0EGP0SbSx0oltIbUIbOQbiWHsPZaIeibRbJndEebE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745408632; c=relaxed/simple;
	bh=DrUms3rxX/rd31+aF26PlrM0K4b7PN8i8RJgn4W6oZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j7V6fa2qTOhLn6uImZnfDVEy7T5iS68bWhD4Pb6MOcdI377r4jTVd9BTHQEpFyeYpbAGT8KT4kh1xkRX7vJpFhlX/inQAmNPSfu2TNfo7TONk3kmXMBP4IdXwjJVDCijA8DbgHYQJ9XupanI+NWB7gALxufjlKzP8HAz5ntuLZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ctgMsoDh; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-70825de932bso5834307b3.0
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 04:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745408629; x=1746013429; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o0pME4e8z4C50P8OJrh4+PPHrwCi4OYutIRm2j3DlNI=;
        b=ctgMsoDh+3FeMBaHxqKSQhwjt0sSUq4BQhUC2Wo11nTcx4OwIfzCibq+gBikpk9V6e
         4FyVfIKUSSZYqpqFTpSNhSVaWugapwC8rE9XyBQjt1wA3RcEzC5ZLk2TdDtPZgckdhVf
         9P58339U4YVthJfS3Gcc4QXmd4c0Rf3jVhduY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745408629; x=1746013429;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o0pME4e8z4C50P8OJrh4+PPHrwCi4OYutIRm2j3DlNI=;
        b=CBz0oN+0FzHPmzcjJPYW1UyI1NdpLxGLTGz1DGtQ1j4Huf/goHu3bhMi7U2ffXNcEs
         4HQpBFJi0dkVpaZ2IXFPsGkIDOi5K7ar5kKVCf5zQdqFx1Kz32JekaCXF1WT7i01yHAW
         Brzs0XU+GMjKQ66PUkYEjRyny3hq8pSBDyWvILgoCZpjfB9o6Pw7mjDxX9ThdNg+3qQu
         JslxRhiOMUXJQxhyfUcqyTjlgpUPP6opDL/PvSru9jSzQ7rK+8TcpN3719ayUr7kvH6u
         pIUF4vEpLZV7OrPG/IK9CC3lk99rEbYhxbkavLyFMRNRWHxHLEC4/R+z+9KYtniFLcuf
         sfXg==
X-Forwarded-Encrypted: i=1; AJvYcCUt1Za8GV2S4bFYICDbiJC0Y5d/3LeF4DKabJbJ6ahPXgaIe9rd5J5870rTZ/OK5rf/TmI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy95WNxRernTqjJndEU6ZBQWL79bvjVZu3HXabRzfp/g2zxa54D
	YJkTugc9cojYk50T+0GZjOoOdntxR47+0Zirh+a1CZILpIFFeWU6ciKalUKyGESd9RRm1VvFVuV
	HeAH7xl0Ds/0La6cpKQJvsvzRqTA1kVQEFMoT
X-Gm-Gg: ASbGnctEgpDlvEBbxMG0lO8nIW3Uy6xmj24rwho6KDf/gg9adcqAIVy733ovcrjWPYB
	s+7Zicsan35rH1LxY2ecLhJDdMkt0EvdllJrq0tsOsI/UV8EM8mKfxOWI5pGXy34+fhWvITa8By
	4E5/m4zAmhhT3ZJhDscH/D5IXvF19J/sBgiQ==
X-Google-Smtp-Source: AGHT+IHYYQIJDBLxM+xrIQQFlLdWbn/W1y6jVyaniIuu6etcEXgr2BDONC/8d70bN3XsrHwevCfS+LNWBYX5gRSA3QY=
X-Received: by 2002:a05:690c:b87:b0:705:6afe:4580 with SMTP id
 00721157ae682-70823f245f4mr30995067b3.19.1745408629559; Wed, 23 Apr 2025
 04:43:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
 <20250422161304.579394-5-zack.rusin@broadcom.com> <a803c925-b682-490f-8cd9-ca8d4cc599aa@zytor.com>
In-Reply-To: <a803c925-b682-490f-8cd9-ca8d4cc599aa@zytor.com>
From: Zack Rusin <zack.rusin@broadcom.com>
Date: Wed, 23 Apr 2025 07:43:38 -0400
X-Gm-Features: ATxdqUGoL409v7JXApk5wQQc2m0USD_kCTvkOpwzs01ZCx-WGqGP3vfxWdC_H-M
Message-ID: <CABQX2QMznYZiVm40Ligq+pFKmEkVpScW+zcKYbPpGgm0=S2Xkg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: x86: Add support for legacy VMware backdoors
 in nested setups
To: Xin Li <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, Doug Covelli <doug.covelli@broadcom.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000005ef8950633709d60"

--0000000000005ef8950633709d60
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 3:56=E2=80=AFAM Xin Li <xin@zytor.com> wrote:
>
> On 4/22/2025 9:12 AM, Zack Rusin wrote:
> > Allow handling VMware backdoors by the L0 monitor. This is required on
> > setups running Windows VBS, where the L1 will be running Hyper-V which
> > can't handle VMware backdoors. Thus on Windows VBS legacy VMware backdo=
or
> > calls issued by the userspace will end up in Hyper-V (L1) and endup
> > throwing an error.
> > Add a KVM cap that, in nested setups, allows the legacy VMware backdoor
> > to be handled by the L0 monitor. Thanks to this we can make sure that
> > VMware backdoor is always handled by the correct monitor.
> >
> > Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
> > Cc: Doug Covelli <doug.covelli@broadcom.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: x86@kernel.org
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Zack Rusin <zack.rusin@broadcom.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-doc@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >   Documentation/virt/kvm/api.rst  | 14 +++++++++++
> >   arch/x86/include/asm/kvm_host.h |  1 +
> >   arch/x86/kvm/Kconfig            |  1 +
> >   arch/x86/kvm/kvm_vmware.h       | 42 ++++++++++++++++++++++++++++++++=
+
> >   arch/x86/kvm/svm/nested.c       |  6 +++++
> >   arch/x86/kvm/svm/svm.c          |  3 ++-
> >   arch/x86/kvm/vmx/nested.c       |  6 +++++
> >   arch/x86/kvm/x86.c              |  8 +++++++
> >   include/uapi/linux/kvm.h        |  1 +
> >   9 files changed, 81 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/ap=
i.rst
> > index 6d3d2a509848..55bd464ebf95 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -8322,6 +8322,20 @@ userspace handling of hypercalls is discouraged.=
 To implement
> >   such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO
> >   (all except s390).
> >
> > +7.39 KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0
> > +------------------------------------------
> > +
> > +:Architectures: x86
> > +:Parameters: args[0] whether the feature should be enabled or not
> > +:Returns: 0 on success.
> > +
> > +Capability allows VMware backdoors to be handled by L0 when running
> > +on nested configurations. This is required when, for example
> > +running Windows guest with Hyper-V VBS enabled - in that configuration
> > +the VMware backdoor calls issued by VMware tools would endup in Hyper-=
V
> > +(L1) which doesn't handle VMware backdoor. Enable this option to have
> > +VMware backdoor sent to L0 monitor.
> > +
> >   8. Other capabilities.
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
>
> You're not basing the patch set on v6.15-rcX?

It was rebased on top of v6.14.

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 300cef9a37e2..5dc57bc57851 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4653,6 +4653,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
> >   #ifdef CONFIG_KVM_VMWARE
> >       case KVM_CAP_X86_VMWARE_BACKDOOR:
> >       case KVM_CAP_X86_VMWARE_HYPERCALL:
> > +     case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
> >   #endif
> >               r =3D 1;
> >               break;
> > @@ -6754,6 +6755,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >               kvm->arch.vmware.hypercall_enabled =3D cap->args[0];
> >               r =3D 0;
> >               break;
> > +     case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
> > +             r =3D -EINVAL;
> > +             if (cap->args[0] & ~1)
>
> Replace ~1 with a macro for better readability please.

Are you sure about that? This code is already used elsewhere in the
file  (for KVM_CAP_EXIT_ON_EMULATION_FAILURE) so, ignoring the fact
that it's arguable whether IS_ZERO_OR_ONE is more readable than & ~1,
if we use a macro for the vmware caps and not for
KVM_CAP_EXIT_ON_EMULATION_FAILURE then the code would be inconsistent
and that decreases the readability.

Or are you saying that since I'm already there you'd like to see a
completely separate patch that defines some kind of IS_ZERO_OR_ONE
macro for KVM, use it for KVM_CAP_EXIT_ON_EMULATION_FAILURE and, once
that lands then I can make use of it in this series?

z

--0000000000005ef8950633709d60
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
QSAyMDIzAgxhPxw+eieHWB40hPkwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIK/l
Ix4b9HecLXaeyIHa8rLy3yA4U30g0x2wzjO2hAciMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTI1MDQyMzExNDM0OVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQME
ASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAEunuJNhOTmg8l8DR2yQvJf8ASf7hECdTxIUOu+h
IXwIoRiMSE3zrCxi9la0SxeX1mBtvZ0yxX2QoIXbGzRRe1/FDcyLv48KY6epWmojdWo/tdSf3KAY
tTlvXClGLLND9piyu+RZMl97w9rqcRvvCHeSnoQmFSO28RNcq7QAkJNRT44nmDT3nTgWfcLIQyO/
PltgEGJdADg0hyVF7nKyHidTYmEPhmAPEChR1U/Ked8MPwWrEBihMLgdagmUTh3g3Ks0brC4imOW
b5ltRrzfsBjiYLUIwVG8UJJwUUchgsE6L+GpfhSRrlTRY7bCYcSRYLwkyux21pOYTgbpYte4REk=
--0000000000005ef8950633709d60--

