Return-Path: <kvm+bounces-44009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 982E5A9991C
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 22:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B05871889FDE
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 20:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A7026983E;
	Wed, 23 Apr 2025 20:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FuiNYCc5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE55223DFB
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 20:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745438489; cv=none; b=FYssseB7cYuTHNQSE2l3Yj8hUNsJZnqsx4FdscIMH6nTPo01iySnl6+5iqnae3Ag1/1moyLm4hhXHVmR25TGg4Cq1Gmi4j9ycvaWTnoDpqfdnMhTw4Rc2WUGjNl8YbczZYexxaB6QT7K8ebOLghPSx3OvYT/Sbihu6vthD8/EDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745438489; c=relaxed/simple;
	bh=DN9iq5vcqahJ1O2gZb8ZWq+HqGd5Lb3ZftTphwqa4II=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mdw8nYaSvI6/Myl5XZ4DmTbiSyzFkv7KqRxjbKJr/DJe5GlB3naIdgdN9o3QfvV2asy98l3FRbrWfeM8ZGdTeF0zGGpXQKzwxwr7IxDcWuQkdtlN0Eu3mbcruqic6J3dCFnxbVGxhYNc8+ZxZbCFn1GN3HVH3evVq5KDa553c8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=FuiNYCc5; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6ff0c9d1761so3537567b3.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 13:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1745438486; x=1746043286; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1AJ2u/BMzae2dxGQPQcuJAWKmCJ+u08r2UbsBZ+UbHs=;
        b=FuiNYCc5x3ltxiEy4subROCjX3BsTpq+HzbZW6no9ez8NXQAehU+3cQAq6cN1MhZ8q
         6E1+yYttURMoRUrFwd8/VhVHKR3f3jIWt3WjrjVld8FpFOW6kPgYl9OHPN5W3P4Gr3Sc
         cPn9OcvDmX3/c7qWGf3xuJwXOelRFQ5zmndKI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745438486; x=1746043286;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1AJ2u/BMzae2dxGQPQcuJAWKmCJ+u08r2UbsBZ+UbHs=;
        b=fOe3LEAV5Z28i70qfCQFbomxIafNvSyMHzVFU1Ptd2P7K/9lcfA8+HbWr96Zc0I6Kn
         N/cCptmrz9k0m+xULnglvmoWmEacPRzB//IKOwTxCFU1+jMW4aNuWjbH0McWwEO510eO
         zyS2EguBWU+dXsxSRKrlJtARfxFdfEGGreeFZxKqUgKTKyeqKrZJfD9MTIcAJ0jlbEu2
         GEZGMZt2KceBPY+DyOs6w/c1SLUUtpWntGz4RdXnEfFwdLpgU8VrJOObC8phJd3DPXd2
         GLMrhMSFhfRnXWLcyyUOFbczedfrNi1bPP+7fjcV0O8z/yYoLbYnJavuxrX2LME81KrU
         N0Qw==
X-Forwarded-Encrypted: i=1; AJvYcCWhf6R5tprv9kF+oYklOT+Osh00Qd4bB25cua4m0jSnZRTBm3z0mzH2tBleh5c9reyP90E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL6sUMO1qht1V7vSTjSI1QDjU+DGa8RjiI0nf+HUNvGXZI81Mw
	wz6CpNUydQGhReRgog73RDP3M+PwP4jIHaBYMDaaePfjXF0/qsd1KsfBbs6NTmIDTr3/zSc+C+x
	PPhAjjpAHDDMoXM2WMFi8nIf8R9S1LIJvWba6
X-Gm-Gg: ASbGncuqpl5urn2sRUflm6AYwaPqvzhuetxjkN5yYeRDOJH4bBIioVu9lua3Ud5DcuR
	y/NebV5gxAMOFsxD8K/R6E7866gpXDdKDx7ZspFI9Si/M59KtXLROPXOawBkdLa4ziZU6EJXmbB
	Dw4p3Wnbm8xaPTpZIFhIbLof8=
X-Google-Smtp-Source: AGHT+IFTaaEAFkSk2OUOfnE7prhFjZRcw6Xj+AHO9EacC0CkRVzJP9fCnED1VdKiqWkfHtG88PlRHuVVKfT1uOzaKmk=
X-Received: by 2002:a05:6902:2745:b0:e6d:fc1f:3c9a with SMTP id
 3f1490d57ef6-e73035856d3mr278335276.20.1745438486523; Wed, 23 Apr 2025
 13:01:26 -0700 (PDT)
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
 <aAkNN029DIxYay-j@google.com> <CABQX2QPUsKfkKYKnXG01A-jEu_7dbY7qBnEHyhYJnsSXD-jqng@mail.gmail.com>
 <aAkgV3ja9NbDsrju@google.com> <CABQX2QMtQes5yiG4VBvQgWkuAoSWgcP8R+X7MeuV_xHeLfpznw@mail.gmail.com>
 <aAk4N0wYQeeYPLVM@google.com>
In-Reply-To: <aAk4N0wYQeeYPLVM@google.com>
From: Zack Rusin <zack.rusin@broadcom.com>
Date: Wed, 23 Apr 2025 16:01:14 -0400
X-Gm-Features: ATxdqUGnvzkIgWeVZ94hh4GEaEXA82IE2WiBQ-hQ1raIy2xwneNhKclMcXIEsQg
Message-ID: <CABQX2QMusDD09_igqdggs7-Ta=Ozj672wWcSR5k0=LpeuZuGJw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: x86: Add support for legacy VMware backdoors
 in nested setups
To: Sean Christopherson <seanjc@google.com>
Cc: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000fe78ad063377901b"

--000000000000fe78ad063377901b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025 at 2:58=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Apr 23, 2025, Zack Rusin wrote:
> > On Wed, Apr 23, 2025 at 1:16=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Wed, Apr 23, 2025, Zack Rusin wrote:
> > > > On Wed, Apr 23, 2025 at 11:54=E2=80=AFAM Sean Christopherson <seanj=
c@google.com> wrote:
> > > > > > I'd say that if we desperately want to use a single cap for all=
 of
> > > > > > these then I'd probably prefer a different approach because thi=
s would
> > > > > > make vmware_backdoor_enabled behavior really wacky.
> > > > >
> > > > > How so?  If kvm.enable_vmware_backdoor is true, then the backdoor=
 is enabled
> > > > > for all VMs, else it's disabled by default but can be enabled on =
a per-VM basis
> > > > > by the new capability.
> > > >
> > > > Like you said if  kvm.enable_vmware_backdoor is true, then it's
> > > > enabled for all VMs, so it'd make sense to allow disabling it on a
> > > > per-vm basis on those systems.
> > > > Just like when the kvm.enable_vmware_backdoor is false, the cap can=
 be
> > > > used to enable it on a per-vm basis.
> > >
> > > Why?  What use case does that serve?
> >
> > Testing purposes?
>
> Heh, testing what?

Running VMware and non-VMware guests on the same system... I'm in a
weird spot where I'm defending not my own code, so I'd prefer not
having to do that. We don't use kvm.vmware_backdoor_enabled as a boot
flag, we haven't written that code, so I don't want to be arguing on
behalf of it either way. I was just trying to make sure this nicely
works with the new cap's. In this case having it just work is actually
less effort than making it not work so it just seemed like a nice and
proper thing to do.

> > > > > > It's the one that currently can only be set via kernel boot fla=
gs, so having
> > > > > > systems where the boot flag is on and disabling it on a per-vm =
basis makes
> > > > > > sense and breaks with this.
> > > > >
> > > > > We could go this route, e.g. KVM does something similar for PMU v=
irtualization.
> > > > > But the key difference is that enable_pmu is enabled by default, =
whereas
> > > > > enable_vmware_backdoor is disabled by default.  I.e. it makes far=
 more sense for
> > > > > the capability to let userspace opt-in, as opposed to opt-out.
> > > > >
> > > > > > I'd probably still write the code to be able to disable/enable =
all of them
> > > > > > because it makes sense for vmware_backdoor_enabled.
> > > > >
> > > > > Again, that's not KVM's default, and it will never be KVM's defau=
lt.
> > > >
> > > > All I'm saying is that you can enable it on a whole system via the
> > > > boot flags and on the systems on which it has been turned on it'd m=
ake
> > > > sense to allow disabling it on a per-vm basis.
> > >
> > > Again, why would anyone do that?  If you *know* you're going to run s=
ome VMs
> > > with VMware emulation and some without, the sane approach is to not t=
ouch the
> > > module param and rely entirely on the capability.  Otherwise the VMM =
must be
> > > able to opt-out, which means that running an older userspace that doe=
sn't know
> > > about the new capability *can't* opt-out.
> > >
> > > The only reason to even keep the module param is to not break existin=
g users,
> > > e.g. to be able to run VMs that want VMware functionality using an ex=
isting VMM.
> > >
> > > > Anyway, I'm sure I can make it work correctly under any constraints=
, so let
> > > > me try to understand the issue because I'm not sure what we're solv=
ing here.
> > > > Is the problem the fact that we have three caps and instead want to=
 squeeze
> > > > all of the functionality under one cap?
> > >
> > > The "problem" is that I don't want to add complexity and create ABI f=
or a use
> > > case that doesn't exist.
> >
> > Would you like to see a v3 where I specifically do not allow disabling
> > those caps?
>
> Yes.  Though I recommend waiting to send a v3 until I (and others) have h=
ad a
> change to review the rest of the patches, e.g. to avoid wasting your time=
.

Sounds good.

z

--000000000000fe78ad063377901b
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
QSAyMDIzAgxhPxw+eieHWB40hPkwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIOAr
zfuKMuPhnWyvT8hFe6LNAcEhhotwPItY/wA7oXIuMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTI1MDQyMzIwMDEyNlowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQME
ASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBADbSu33TnDvwl5yNeyU5WCjvbEB6FXh2hO4SuiyK
ETNvl1iKP1c/s4dt47CLbkOcpZC3xY3ISNyQW20ADLbvEEyT0UB7GzIy5ycXE05JdthlKjgJMdkx
iZfAwe5YqtJ3VDweHxFyVfsBcevB7um4iKoVLWwwU90ZeL/Dz+JSpwT8b6B4Is74zPLPFZnXv01k
mw2vmb8ReClkJy1GsvkUwIp5hv+3do8n6Xhudz4bdYColO0S6IMsHoVQk2BHo9blcSYbTJ6ovIiD
I39ey7VgO95D5LiiPjMv76BG4V64b9EYslZVfgHQz8uOZh/by7WVHKwEP9JPsEKBXmvBGw58ZjY=
--000000000000fe78ad063377901b--

