Return-Path: <kvm+bounces-15945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 19CAE8B2686
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43D24B26C2D
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C6214D6F1;
	Thu, 25 Apr 2024 16:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oDJ537ID"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B70643AA8
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714062663; cv=none; b=ghrgLVIVeIXbmSv5LI/R298bSH1FPJJlF3D9U4dWOsxji4erUbh3GfI66RFNXpFxii2HJ3P/BrJOqpoAdkHxZy5jUefSe5Fe5k0LYTuT97/xOapnaKfuyZCf/+m3OJ1d33okckuHU3IN92g9YLXSGYZZ9CyPhjgCkq8W6XX7Ueg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714062663; c=relaxed/simple;
	bh=8QT4wCkiEvoE5CtKsOvw2EHV/0k7lOv71PaUreO/D44=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aSqpiNCBdbfKXhjW6hL9bFy04PXhoucLd09IjX2qapPoKzMgCdcpHNvQ6V66hpPqHLStzV5LfgN9vJL/jX9wWq2YS0BYvI1f2lhNAJuLJVyrUsw4fXqjkHid3sfhKpP9aQWFuLqKH+Ddt+grjJzcPW/MXi4LtrHD4ITbfwme9WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oDJ537ID; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61814249649so21185977b3.3
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 09:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714062661; x=1714667461; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wuEvZw0xsxqnkJCMkgLTL9fi/8XUYBdqC5QY5sOCErc=;
        b=oDJ537IDZtrd4cxe/XN9mbLvdn2CvO/sGQQOt/JZMAMXRh/sXUQRfA3hJbHyXd1fgR
         tQri3Pzvf2C1JJ/h/xziUwC8RyoV61f8F9R9RKo6SmuePNy77Wmq0iK/ln6xJ8gYeH2b
         eCAzty7Kbq4INSaYuZbKM4dJdcsMJrTQIMoJsJCEMPFPYhblKZJl6fcvlFXWfF44Lay7
         Z3uOd8fAN+zzoW0hbCOHhvbGNni42Ed99RQGAyIOqjqe0q7Tq+hnJCZTN9VGGfslPINm
         DGfKIxGkF809kvd5DGsHdtutKVRvab+TXsICwjb7MOmAFlP7q/HVIH7721MVUcICxPru
         qpQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714062661; x=1714667461;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wuEvZw0xsxqnkJCMkgLTL9fi/8XUYBdqC5QY5sOCErc=;
        b=fWwV/QiFBBijb0eYvA8hj0I/c9CF2vxnuz7neCnTOTBfaZ2+2G4WUaGohqHw+zSV5P
         cNZSPkBLWyFohkvMYo+rsqYYAqJeS5dsVjTYT4VeOcEyiyNL70NFDnFOlg1AgBaOxxn3
         q55KQDiXrMlrCKEbiwND7GhxzCx8Kjf7crevDuAPCumT7kE+JHUNPfc0lLE1DobQEgWl
         PCH7p4akchfE/tY3qQn9GI3+gkxwrGgYxssrN2RIbFZyiH9UqNIj98MWmZXyUVWnATz0
         wq87FQnaPPHy1NVN6z7C1xSN9zUCIdobq9MX7KhRdrei9XqesSeVj3gGPBNZbbgkxhbD
         Eu2w==
X-Forwarded-Encrypted: i=1; AJvYcCVifn5YZxWU0mrSL/4soITssy3IImDmR6UJn2EBS+K1YgMBiq1s2/42In0tsM9QXaRKUDZWUwL7GxSZjhw7fn9Sg73y
X-Gm-Message-State: AOJu0Yy2mxwpzkNFILxLwReKewmFPoFXGcunrJuVKQ89RRRttGZgeGgv
	vlMaC/Go44A80wFEbyxIDmZhZTNvOJPDWcMjkXPLxBQYK/xh57IJxkVGNELPOb6uDZoDFnQfzaK
	TTg==
X-Google-Smtp-Source: AGHT+IF7ewIFf4asaLVdd36tPhS/2ZhvyuhQ5JaF/1Gy7paYiH3nJdGJyIbHKj5e9VA3LCVIDmZCPxJhvX4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e386:0:b0:61a:b2d4:a3fb with SMTP id
 m128-20020a0de386000000b0061ab2d4a3fbmr1243077ywe.8.1714062661606; Thu, 25
 Apr 2024 09:31:01 -0700 (PDT)
Date: Thu, 25 Apr 2024 09:30:59 -0700
In-Reply-To: <9c6119dacac30750defb2b799f1a192c516ac79c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZiKoqMk-wZKdiar9@google.com> <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
 <ZiaWMpNm30DD1A-0@google.com> <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
 <Zib76LqLfWg3QkwB@google.com> <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
 <ZifQiCBPVeld-p8Y@google.com> <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
 <9c6119dacac30750defb2b799f1a192c516ac79c.camel@intel.com>
Message-ID: <ZiqFQ1OSFM4OER3g@google.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, 
	Bo2 Chen <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024, Kai Huang wrote:
> On Tue, 2024-04-23 at 22:59 +0000, Huang, Kai wrote:
> > > Right, but that doesn't say why the #UD occurred.=C2=A0 The macro dre=
sses it up in
> > > TDX_SW_ERROR so that KVM only needs a single parser, but at the end o=
f the day
> > > KVM is still only going to see that SEAMCALL hit a #UD.
> >=20
> > Right.=C2=A0 But is there any problem here?=C2=A0 I thought the point w=
as we can
> > just use the error code to tell what went wrong.
>=20
> Oh, I guess I was replying too quickly.  From the spec, #UD happens when
>=20
> 	IF not in VMX operation or inSMM or inSEAM or=C2=A0
> 			((IA32_EFER.LMA & CS.L) =3D=3D 0)
>  		THEN #UD;
>=20
> Are you worried about #UD was caused by other cases rather than "not in
> VMX operation"?

Yes.
=20
> But it's quite obvious the other 3 cases are not possible, correct?

The spec I'm looking at also has:

	If IA32_VMX_PROCBASED_CTLS3[5] is 0.

And anecdotally, I know of at least one crash in our production environment=
 where
a VMX instruction hit a seemingly spurious #UD, i.e. it's not impossible fo=
r a
ucode bug or hardware defect to cause problems.  That's obviously _extremel=
y_
unlikely, but that's why I emphasized that sanity checking CR4.VMXE is chea=
p.
Practically speaking it costs nothing, so IMO it's worth adding even if the=
 odds
of it ever being helpful are one-in-and-million.

