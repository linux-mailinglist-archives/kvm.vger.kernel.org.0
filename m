Return-Path: <kvm+bounces-31668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A12639C62C9
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 319AD1F24AB5
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 20:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987C721A4A0;
	Tue, 12 Nov 2024 20:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TTnoRsf6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1CF218D85
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 20:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731444265; cv=none; b=JUNfMdXg6uhmqubIswXa0V1rIsJ58c4e9buH5spEBmcYd4n3wOZfy8QfuTdDHnOf60VOEaAgSGIeR0JDbFUj5v/wepW9q37X/YWrokS2Pfb3GZ7jLTrgO5UDAz/8nIevs0LpGptOur8+EtnLQxt2n6yvzAxabzOKg+zrKE9b2rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731444265; c=relaxed/simple;
	bh=el0r2bRkdPPBOR4oInIoihU80U4XbTLMYSnoHJA5iSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Roedcx/DkbXlsazhyU8r/ubKSQNXBMQxzAL9Z5nEhLeo5SSqVoJUp5Y2U0CKOtVaXyXYH/41ejsuO0qqgWYWWMfVX51S6eLezoq1odPHsIHZrXyEDaMeKUPRu6q6dDn/4Tne7JEroBNXDhZOzYLh9OxN1BpUkY2xbeMKd3C/7pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=TTnoRsf6; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a9e71401844so773703966b.3
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 12:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1731444262; x=1732049062; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ci3AOpKOMh+qQE+IxW9xvHQ5UYC3MnDiR3fLpgFFWsw=;
        b=TTnoRsf6X1BY6CnHKXgJ/LclxkBauOXAkypLruREgbk9JxKJpbK0LVh1B1nOh5W97y
         IkMoAfsaOFWWdBmGpDshaRqfhE9ZFlam8aFdk03J/3lRlPwzbZu+1U9yqjpE9t3NP/5S
         yGzJM6uF8alxMRZNeJFmMKvexmtsWkYKigwg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731444262; x=1732049062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ci3AOpKOMh+qQE+IxW9xvHQ5UYC3MnDiR3fLpgFFWsw=;
        b=TQx0xh3Ii7XjYzneZoCjsv+ohYmKCf/m8Ru053ADz72ucGrN453oFDfVPVXArt9rIr
         E6PBxf+80aCKahfzt13CuVnkp9/kJkHYSpXp5GaEWNmwwcqNzJo0Bf47nBLQ1wyBF+vY
         X7/wNrc0sfb3LfycCua/X0hCmrfG00xiJBi9/zIZxWQI8iCC2bC2LNOx/ht+/X2BAcah
         mvJAi+Mq7kTdPkA2qe0CmMnJCazSWqbAdy7qH8+vHZue8TSNhPoPRalM352g6aNMpKre
         RAkM8xWJnc0Z8OZMkBcUZvFfDAL7iVv5hBrnDit4ySnNL5E3pOFiO2IOhg5rNK2n22Ft
         RQtw==
X-Forwarded-Encrypted: i=1; AJvYcCVcVmXRv23whFRxG1+ZGHcTTaAykxyqd6/uxkEGn/Wi2eaBP22SxROzWHl3EVYjTUFkn7s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrlSfvvI/dxt3IrCSi1xJupx+MJgUnUQrJN4xe7oH0B3hORBKK
	m0b6/y0VF5Xt5OlJmzkCvZok4EfrwsgE06ZwFAHdG1sgMHdOE/3oO7xPJ25++FWA4pDddMxDBgV
	8/Ac6uktr2XLuiMI64i0k8WvKfssHsvWZQv8imOtQ51VkDOnMd3dtf5nmL7dzW34eITHw4OGay+
	rvN/Y43jFZSSz+2w==
X-Google-Smtp-Source: AGHT+IG740NFxkx0vp+a1R5LySlw7AKNXAm4MBS09Ocb5RmGWJM/vc/T05dI8LgZ/LVvJavNohmip80HjcmCjvFy7Hk=
X-Received: by 2002:a17:906:c14e:b0:a9a:5d15:26c2 with SMTP id
 a640c23a62f3a-aa1f80f60d7mr30502366b.45.1731444262225; Tue, 12 Nov 2024
 12:44:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030033514.1728937-1-zack.rusin@broadcom.com>
 <20241030033514.1728937-3-zack.rusin@broadcom.com> <CABgObfaRP6zKNhrO8_atGDLcHs=uvE0aT8cPKnt_vNHHM+8Nxg@mail.gmail.com>
 <CABQX2QMR=Nsn23zojFdhemR7tvGUz6_UM8Rgf6WLsxwDqoFtxg@mail.gmail.com>
 <Zy0__5YB9F5d0eZn@google.com> <CABQX2QNxFDhH1frsGpSQjSs3AWSdTibkxPrjq1QC7FGZC8Go-Q@mail.gmail.com>
 <e3f943a7-a40a-45cb-b0d9-e3ed58344d8b@redhat.com> <CADH9ctD1uf_yBA3NXNQu7TJa_TPhLRN=0YZ3j2gGhgmaFRdCFg@mail.gmail.com>
 <c3026876-8061-4ab2-9321-97cc05bad510@redhat.com> <CADH9ctBivnvP1tNcatLKzd8EDz8Oo6X65660j8ccxYzk3aFzCA@mail.gmail.com>
 <CABgObfZEyCQMiq6CKBOE7pAVzUDkWjqT2cgfbwjW-RseH8VkLw@mail.gmail.com>
In-Reply-To: <CABgObfZEyCQMiq6CKBOE7pAVzUDkWjqT2cgfbwjW-RseH8VkLw@mail.gmail.com>
From: Doug Covelli <doug.covelli@broadcom.com>
Date: Tue, 12 Nov 2024 15:44:11 -0500
Message-ID: <CADH9ctA_C1dAOus1K+wOH_SOKTb=-X1sVawt5R=dkH1iGt8QUg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Add support for VMware guest specific hypercalls
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Zack Rusin <zack.rusin@broadcom.com>, Sean Christopherson <seanjc@google.com>, 
	kvm <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Joel Stanley <joel@jms.id.au>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, 
	linux-kselftest <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 12:44=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com=
> wrote:
>
> Il lun 11 nov 2024, 21:55 Doug Covelli <doug.covelli@broadcom.com> ha scr=
itto:
> >
> > BDOOR_CMD_VCPU_MMIO_HONORS_PAT and BDOOR_CMD_VCPU_LEGACY_X2APIC_OK are =
not
> > actually backdoor calls - they are flags returned by BDOOR_CMD_GET_VCPU=
_INFO.
> >
> > BDOOR_CMD_VCPU_MMIO_HONORS_PAT is only ever set to 1 on ESX as it is on=
ly
> > relevant for PCI passthru which is not supported on Linux/Windows/macOS=
.  IIRC
> > this was added over 10 years ago for some Infiniband device vendor to u=
se in
> > their driver although I'm not sure that ever materialized.
>
> Ok. So I guess false is safe.
>
> > BDOOR_CMD_VCPU_LEGACY_X2APIC_OK indicates if it is OK to use x2APIC w/o
> > interrupt remapping (e.g a virtual IOMMU).  I'm not sure if KVM support=
s this
> > but I think this one can be set to TRUE unconditionally as we have no p=
lans to
> > use KVM_CREATE_IRQCHIP - if anything we would use KVM_CAP_SPLIT_IRQCHIP=
 although
> > my preference would be to handle all APIC/IOAPIC/PIC emulation ourselve=
s
> > provided we can avoid CR8 exits but that is another discussion.
>
> Split irqchip should be the best tradeoff. Without it, moves from cr8
> stay in the kernel, but moves to cr8 always go to userspace with a
> KVM_EXIT_SET_TPR exit. You also won't be able to use Intel
> flexpriority (in-processor accelerated TPR) because KVM does not know
> which bits are set in IRR. So it will be *really* every move to cr8
> that goes to userspace.

Sorry to hijack this thread but is there a technical reason not to allow CR=
8
based accesses to the TPR (not MMIO accesses) when the in-kernel local APIC=
 is
not in use?  Both MSFT's WHP and Apple's hypervisor framework allow this an=
d it
seems like it would be generally useful for any Hypervisor that does not wa=
nt to
use the in-kernel APIC but still want to run Windows guests with decent
performance.

When we switched to WHP the biggest source of problems by far was from tryi=
ng
to integrate our monitor with MSFT's APIC emulation code.  Even if we do wa=
nt
to use the KVM in-kernel APIC at some point in the future it is still nice =
to
be able to fall back on our own APIC emulation code if necessary.

Also I could not find these documented anywhere but with MSFT's APIC our mo=
nitor
relies on extensions for trapping certain events such as INIT/SIPI plus LIN=
T0
and SVR writes:

UINT64 X64ApicInitSipiExitTrap    : 1; // WHvRunVpExitReasonX64ApicInitSipi=
Trap
UINT64 X64ApicWriteLint0ExitTrap  : 1; // WHvRunVpExitReasonX64ApicWriteTra=
p
UINT64 X64ApicWriteLint1ExitTrap  : 1; // WHvRunVpExitReasonX64ApicWriteTra=
p
UINT64 X64ApicWriteSvrExitTrap    : 1; // WHvRunVpExitReasonX64ApicWriteTra=
p

I did not see any similar functionality for KVM.  Does anything like that e=
xist?
In any case we would be happy to add support for handling CR8 accesses w/o
exiting w/o the in-kernel APIC along with some sort of a way to configure t=
he
TPR threshold if folks are not opposed to that.

Doug

> > For now I think it makes sense to handle BDOOR_CMD_GET_VCPU_INFO at use=
rlevel
> > like we do on Windows and macOS.
> >
> > BDOOR_CMD_GETTIME/BDOOR_CMD_GETTIMEFULL are similar with the former bei=
ng
> > deprecated in favor of the latter.  Both do essentially the same thing =
which is
> > to return the host OS's time - on Linux this is obtained via gettimeofd=
ay.  I
> > believe this is mainly used by tools to fix up the VM's time when resum=
ing from
> > suspend.  I think it is fine to continue handling these at userlevel.
>
> As long as the TSC is not involved it should be okay.
>
> Paolo
>
> > > >> Anyway, one question apart from this: is the API the same for the =
I/O
> > > >> port and hypercall backdoors?
> > > >
> > > > Yeah the calls and arguments are the same.  The hypercall based
> > > > interface is an attempt to modernize the backdoor since as you poin=
ted
> > > > out the I/O based interface is kind of hacky as it bypasses the nor=
mal
> > > > checks for an I/O port access at CPL3.  It would be nice to get rid=
 of
> > > > it but unfortunately I don't think that will happen in the foreseea=
ble
> > > > future as there are a lot of existing VMs out there with older SW t=
hat
> > > > still uses this interface.
> > >
> > > Yeah, but I think it still justifies that the KVM_ENABLE_CAP API can
> > > enable the hypercall but not the I/O port.
> > >
> > > Paolo
>

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

