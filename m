Return-Path: <kvm+bounces-67482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D62D065CA
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 22:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8AD9530146C0
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 21:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5445F331216;
	Thu,  8 Jan 2026 21:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uMMHswjj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48918309F01
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 21:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767908873; cv=pass; b=jI6sUITvLICC8S2o3ofS2wHaOKrB4ZZl+oewjiWBVgh2j2/4Xcjf5toetRHzTKWmPnnQxl4C4hXCIvVIlJI7UXuxWIyZra5DFc/cgKgshvJWwjDXSfAMbsnhyYkgL4QpMsufA+Lfo/z6jWPwkeTDwS1UYufm0gjij3XNMOuWxZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767908873; c=relaxed/simple;
	bh=eszD4jbVmPReAXwHOeV1DQBPn10PZZ6xWs686rMtoxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iczePjoTaa5aiC93fzFc8rlaCgNr62RhAK0IfLMHiQCTUCaUpuJN+LclFMIG+W2hx1FJ0wh3upcG8VbrU75SXBQcV+5+StYHzwk9FHR66xB2rvM1nKhtZ7gjn2TFSq/fad3uM2kPWPLCr2gv1UnF7WcQw0Uitiyk9DW9LkTJbcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uMMHswjj; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4edb8d6e98aso155151cf.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 13:47:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767908871; cv=none;
        d=google.com; s=arc-20240605;
        b=EWBzNiznEqfi3ltTLXFYaRcBoKnnuW0t2XataxoPxFDsBB0C/boCGBPWjWan9aLzfs
         6nxqUMJlVslE+fHKxxZJOdN0A1mqVtCwM5JyZ9wHkIYdE5i7BUwjmSlai9UaMgzb7XMt
         cYMgACEUi4UBqMVs3ILyKIi+NZdc1kUICnROLgoUIqcRxL51a9YYemNl0qNfdq+KQpgm
         aj6w0bQzKdW0AmEzasKSUGRMY0YYNAbfezmMXEttlfRcG/XGAenIjbxVlqbTJXj1uuTl
         JCmuN42y/8PsKowLAUwxUgu1B3C9kUGbfnLIQ6L12AGJ50Nluy4ju4JdIOmywRaSiXb/
         LIxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uGpwy7ToECEJBJX6P2HnMyL5e5BPpbMb6as9Kn7mXIE=;
        fh=pFyuGI274nRa+CaNF5eGSVyD2KMxDRb2QoC76gbje9k=;
        b=IutZKm3oYGsUO4N0Fz922K2hG/Y9UsdeE8Gew/NXbnb/T0/o837qmQvZWDVgSqHEAJ
         m87pBjhM5+X/PGLFy+SWyehLL8xyDB5UTiHV/ufqcZ5f5E10eKMZK8zjw4XbXaB6kLow
         0KHEZYLoQOVr4BloNSUxmFC9GBWtyMfBg/7mUHVwhQFFM+SGFHqiuF/s7zGnJZfYkB9V
         faxfOmsfiRuszdi900QJFG1Oe69gbWidlnc9UEEgJX3lekkVngofmJx/EcdUZRhiMMUY
         AG/r/HRaafhhVR8XpxIh5Zh5rrig9nGN661vXr4KcJjIC1zSwXLIkraaZ4TxOsMvceEC
         /+sw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767908871; x=1768513671; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uGpwy7ToECEJBJX6P2HnMyL5e5BPpbMb6as9Kn7mXIE=;
        b=uMMHswjjpkTJiZYvMZ9UvdjgGjNYER3t75aj+p2d4suCUxUT8lWizdDZCNvbq7XwIM
         O+DUw5khVGn2upsIPC2fr0jAz6rEXj/ThsPAQc70Gvr10Uisr++35tEeKGXtld1j09YI
         KtJG+DiEhAoKnrSgqpxpg01EFEDN5OFy8sH4VQQZEnfvCaESGNzwwUW3BxwZ9LdqXMvE
         pdEPjMERhNvw/J+ZE49IoWRvLFViFI0gYiBsmg/VabakvYfvNMGwtb1U6wf6kAuOLB/a
         aDP9Cd/LO6SNzNzNCcXSQcb0aWn+38aND+l6rsP7euxA7foYBesP94xphsfCdvcs/LOs
         7XgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767908871; x=1768513671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uGpwy7ToECEJBJX6P2HnMyL5e5BPpbMb6as9Kn7mXIE=;
        b=pny6O5vWYdg2rEDZNqMjGA6pdQwzr9ckvd09jUDorVz8ri1q9aOK37ZNgM4dokX5xc
         5EwnzBFDf6wd9TCShCPtoUmrp1UGpiucAFEeHzvJbGe50O/Yz8v5Yipe+LtM+OVBwL4E
         2lbRR6BfgLlA0Dej54QNptqHaktqS7GI05DSut29GjHp1kNGqSCPtAmJ6VRTH2yz1a0x
         EIH2csyKXjJst1F9sMMy2am+r0Cnt17Rxf7xCwz2YlJkg2Ve8ood7eVzD96BpVI+OPg6
         9f/6Hj6U2PwozAqn8nXwLRIfRepi39YcUkGazTLEUMSCdJCnoGs6ami0E84TXHDFw9ev
         JcCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTHa/JHbvnZ/i0REAUBrnlioKJNH9Fmex7TZnfhAOi/nKipJmWt1NO3PQUP+rCWDAun+4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtklR4DdJF/sk2NuiTX9tfjtVwDeUcsIQKFg1qQDCDWsahCJ6t
	inoYlo9kRziPuU+BtesE8bNfntLkBRRsNDUJOW3zCzhzofuornAEgHCL558SqSagbzLS5TGqfF/
	fImvQEEf67OPbBuQEHj5h3LSoEVpEJFU1+yTQDLl6
X-Gm-Gg: AY/fxX65bXohEkBYn52Kch+HW0pEJ8rApNsoKT8gfX4tDukwkMJcg/mXLkdQ93tly5g
	ICfCVFwkwhgzdqz/REtO4EDTUF34TbFtDR6XAlKyYUM9k8d+P51WT1wKAFF/dkY42Uew9jUxGSq
	qFuBKK4zl1vXj2MP357GhnLHnfvWD4pqt7TfOGpJiFIfPYzOI1UIQ6H6yr9vpdMp2gfmu5Zc1cf
	jl0cB4TBDOuOmQowmEAFYbR8CJPVMJwt+9coARMyFDLIPFSiO3E6Y5o1wxDeVuHRz3zH95wrl73
	FWl5jEQ1DcpM6nyyiOdiZ6GjoQ==
X-Received: by 2002:a05:622a:164c:b0:4f4:bb86:504f with SMTP id
 d75a77b69052e-4ffca3a99e0mr3277861cf.16.1767908870888; Thu, 08 Jan 2026
 13:47:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210181417.3677674-1-rananta@google.com> <20251210181417.3677674-5-rananta@google.com>
 <aV7mwGtyAo7s5yuW@google.com>
In-Reply-To: <aV7mwGtyAo7s5yuW@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 8 Jan 2026 13:47:39 -0800
X-Gm-Features: AQt7F2qrc18Wu0lpNkZAb17gJ9Scw6K0G7cwQUlYN4hEorz60LJyyS_ny2Uvw7Q
Message-ID: <CAJHc60y4OiYX+CjOXphXraWYPXZMb-aHJ6WnbNJwGiNDje=8PA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] vfio: selftests: Export more vfio_pci functions
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 3:05=E2=80=AFPM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:
>
> > -static void vfio_device_bind_iommufd(int device_fd, int iommufd,
> > -                                  const char *vf_token)
> > +int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char =
*vf_token)
> >  {
> >       struct vfio_device_bind_iommufd args =3D {
> >               .argsz =3D sizeof(args),
> > @@ -314,7 +322,15 @@ static void vfio_device_bind_iommufd(int device_fd=
, int iommufd,
> >               args.token_uuid_ptr =3D (u64)token_uuid;
> >       }
> >
> > -     ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
> > +     return ioctl(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
>
> For ioctls that return 0 on success and -1 on error, let's follow the
> precedent set in iommu.c and return -errno on error from our library
> functions. i.e.
>
>        if (ioctl(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args))
>                return -errno;
>
>        return 0;

Sure, will take care of this in v3.

