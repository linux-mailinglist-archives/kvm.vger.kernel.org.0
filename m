Return-Path: <kvm+bounces-67157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C335DCF9BFC
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 18:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2350E312D5B5
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 17:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71943559E9;
	Tue,  6 Jan 2026 17:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TcP9BVfR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD7C3559DB
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 17:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720580; cv=none; b=VzoI3Ci+dSBLuX/uVt+DH2i8lkZIv297oSZdIoEfu1Ftgdzl1JHMe0YzzNDMffDl7HXsW2ChFEl7nI0Cf1xHAYHbxcNUFn/Y6xBQQZC2h8dKRYQohDNtqI2rIStAi+zLkeGDr7MSv7QcE4ssZN1HJJ+j9ASFaT+IiOpB0k4h7mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720580; c=relaxed/simple;
	bh=lZGEKdFUb9AcB7WNwQ+ORABBKfepwE38XMx2EGdcaLA=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=DUo4nGRH+Ja4s15uXzXx716O2+FJVVPOPFn8iimeCPUx9ULoFw9/mlsL2uTvRvxnmE6tIQFkXXi78299Kq90fzJMo3bCdxe5+CDFruJH7u6ysHVCv4A6DafOM4v1cfcu1ijmXpmkbjHPFVeZdj/zQTP700kzKDR7UNOKA0mT7kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TcP9BVfR; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso12588341cf.0
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 09:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767720577; x=1768325377; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ev2z+ugntRfBhi0MLQnaloAEfBXhuJAFXxFLLDkUT7I=;
        b=TcP9BVfRMqa0Lj2ijIpH3GwnUheka7mfmy7mb1pZiOidSvlAgzVvCqXrmoR3X1ZbKe
         7yDVpsgcug5kMvFRWN8MEGzYLllXUlQCLZ+xgxTAqmrq4HsKCo/+TE1LM+1s8+2kMAIK
         /U6UnItDHlh/1sA7yijRYVHAViEPLMphEHRvw5NGmluZyxog1vOq2Gl2QtjCcX/XncNU
         HG2ijQMR/8sQeV/vLGmyBFxhubrQUGYRIkhTmRmo3N3k88lBncVEZrzqigwPcyTCNxb3
         RkWjjVaogUH05zZ+SOce6X5UjUF3FZgofFlWeKDbata7Lc8UikHgMNJXdXW1N0V5G09w
         Sd9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767720577; x=1768325377;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ev2z+ugntRfBhi0MLQnaloAEfBXhuJAFXxFLLDkUT7I=;
        b=czokwhC+awaC27ZRHcw4ZkicdZQqLKZTyz9uJ5UTkMk8+MsNcBzaZJqZcrNHeMY2zO
         GWnIQwGd9iZnNPV01cTpmb0GTDgdEjh6OYlWugcMlIlPTO5aK0sildlz/+NindfLNS3F
         nedBnlDKtoGCk+X7vmP/gTpLHlRBvwWo9QFeqxlK6JR5QWI7Fo9WPomXCsgf+3v6ivFY
         +iO3scVDSG+r7rOrnuLBxf2UxqMCuSfKgnD9aygO+rAzvGVJe5BBvxgcPABlKZqnVWH3
         GHPzSVlCYQUfVCzckrW8DInUU9DNqQgg1B6syI4be8ahZLUiUvPY7nfu49EkB3pCS6XA
         rvOw==
X-Forwarded-Encrypted: i=1; AJvYcCW+g+UdKem6dLCd6NIlQry1HYHqyjB5hd/j/wXC+pk+I2QLlEW/J7wcpPmYTF2OW3uAcKY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLPZ15Ihh0qjk5VvcqXHWM9LayY3kVpmhcvXVDgO0HBC8xv7It
	mKwBukFzjkePOn6akHiP8vlDK8oalNLXAqCy7oMQufKCv4m4PFzZj44rHsbiaPSE
X-Gm-Gg: AY/fxX793IbETqDWD+bMccxNY3sf6OOm+GR9tIi55mPp5E3CFTSRB/LTH6/K/Vu0CnE
	S1mFKsV8EzbaF4ooCiDcgNCNkRJbleNBJq9QnGcuAfTmlchv/fWcG011XjatjnOy56/0VmSwSI1
	RkCIy20PxIR5pV8As0/7JKbI3W3tf74Afq+awcCNuxQElulCyYTAR7WxjjQbwqbwJp0KM5AZPi8
	HPWM3+P4c4NbkBzYHH48Zb0wSpnJQgPe23LIf2Znywsclcs4TdsNMrM+GP3qy2ATSF/FXEBOU8G
	9EjeOKX/e+NdGrgorx9VfwujFR+P1Idpy/7Vu8HjGpypO9NcnzGVMxxqdattw1Ei2YPKNuWJDtq
	efP1Zxf8Qj/o0IFP3X01n2qA1W9KwXGzxTv+rFgWEvJvYj9ft0gXWcy9fpr6I3UJszedokNMsQ6
	yvPVDeFeTnMJrzdnXIPEjT0FKYqA56FE+FXoImyaorOMRdNa6+8OVLRg==
X-Google-Smtp-Source: AGHT+IHJ1nl1mxcz6HJDOIFhwyOzQJmst8hsU57AC7I4tqS/qzt3tqz13wKOdTI+77LEYoHxCPbCzw==
X-Received: by 2002:ac8:7dc1:0:b0:4f0:2f0c:e91d with SMTP id d75a77b69052e-4ffa782419dmr51056441cf.73.1767720576676;
        Tue, 06 Jan 2026 09:29:36 -0800 (PST)
Received: from smtpclient.apple ([2600:4041:45af:2c00:7ce3:4443:846c:ff7c])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8d38e12sm15016421cf.3.2026.01.06.09.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 09:29:36 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Patrick Bianchi <patrick.w.bianchi@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: PCI Quirk - UGreen DXP8800 Plus
Date: Tue, 6 Jan 2026 12:29:25 -0500
Message-Id: <7415E3FF-6A70-4836-B609-29F88747D0F8@gmail.com>
References: <20260106102354.4b84b4a7.alex@shazbot.org>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
 Bjorn Helgaas <bhelgaas@google.com>
In-Reply-To: <20260106102354.4b84b4a7.alex@shazbot.org>
To: Alex Williamson <alex@shazbot.org>
X-Mailer: iPhone Mail (23C55)

Yes. I used the exact code from Post #12 in that thread and it has been runn=
ing stably for 3 weeks and through multiple reboots of host and VM.

-Patrick Bianchi

Sent from my iPhone

> On Jan 6, 2026, at 12:23=E2=80=AFPM, Alex Williamson <alex@shazbot.org> wr=
ote:
>=20
> =EF=BB=BFOn Mon, 22 Dec 2025 18:37:32 -0500
> Patrick Bianchi <patrick.w.bianchi@gmail.com> wrote:
>=20
>> Hello everyone.  At the advice of Bjorn Helgaas, I=E2=80=99m forwarding t=
his
>> message to all of you.  Hope it=E2=80=99s helpful for future kernel revis=
ions!
>=20
> I'm not sure what the proposed change is, but the comment at the end of
> the previous message seems to be leading to the quirk_no_bus_reset
> patch proposed here:
>=20
> https://forum.proxmox.com/threads/problems-with-pcie-passthrough-with-two-=
identical-devices.149003/#post-803149
>=20
> IIRC QEMU will favor the bus reset if the device otherwise only
> supports PM reset and interfaces like reset_method only influence the
> reset-function path rather than the bus/slot reset interface available
> through the vfio-pci hot reset ioctl.
>=20
> Disabling bus reset appears reasonable given the corroboration in the
> thread and the fact that the device still seems to support PM reset.
>=20
> Do you confirm the quirk you were testing is:
>=20
> DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1164, quirk_no_bus_reset=
);
>=20
> ie. vendor:device ID 1b21:1164?
>=20
> Thanks,
> Alex
>=20
>> Begin forwarded message:
>>=20
>> From: Patrick Bianchi <patrick.w.bianchi@gmail.com>
>> Subject: PCI Quirk - UGreen DXP8800 Plus
>> Date: December 20, 2025 at 9:56:10=E2=80=AFPM EST
>> To: bhelgaas@google.com
>>=20
>> Hello!
>>=20
>> Let me start this off by saying that I=E2=80=99ve never submitted anythin=
g
>> like this before and I am not 100% sure I=E2=80=99m even in the right pla=
ce.
>> I was advised by a member on the Proxmox community forums to submit
>> my findings/request to the PCI subsystem maintainer and they gave me
>> a link to this e-mail.  If I=E2=80=99m in the wrong place, please feel fr=
ee
>> to redirect me.
>>=20
>> I stumbled upon this thread
>> (https://forum.proxmox.com/threads/problems-with-pcie-passthrough-with-tw=
o-identical-devices.149003/)
>> when looking for solutions to passing through the SATA controllers in
>> my UGreen DXP8800 Plus NAS to a Proxmox VM.  In post #12 by user
>> =E2=80=9Ccelemine1gig=E2=80=9D they explain that adding a PCI quirk and b=
uilding a
>> test kernel, which I did - over the course of three days and with a
>> lot of help from Google Gemini!  I=E2=80=99m not very fluent in Linux or t=
his
>> type of thing at all, but I=E2=80=99m also not afraid to try by following=

>> some directions.  Thankfully, the proposed solution did work and now
>> both of the NAS=E2=80=99s SATA controllers stay awake and are passed thro=
ugh
>> to the VM.  I=E2=80=99ve pasted the quirk below.
>>=20
>> I guess the end goal would be to have this added to future kernels so
>> that people with this particular hardware combination don=E2=80=99t run i=
nto
>> PCI reset problems and don=E2=80=99t have to build their own kernels at e=
ver
>> update.  Or at least that=E2=80=99s how I understand it from reading thro=
ugh
>> that thread a few times.
>>=20
>> I hope this was the right procedure for making this request.  Please
>> let me know if there=E2=80=99s anything else you need from me.  Thank you=
!
>>=20
>> -Patrick Bianchi
>>=20
>>=20
>>=20
>> C:
>> /*
>> * Test patch for Asmedia SATA controller issues with PCI-pass-through
>> * Some Asmedia ASM1164 controllers do not seem to successfully
>> * complete a bus reset.
>> */
>>=20
>=20

