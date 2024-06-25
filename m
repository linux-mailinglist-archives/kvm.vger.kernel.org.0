Return-Path: <kvm+bounces-20509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C825C917504
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 01:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 556C21F22157
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 23:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99C317FAA9;
	Tue, 25 Jun 2024 23:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CzpqtShC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A85143C6A;
	Tue, 25 Jun 2024 23:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719359551; cv=none; b=hMMXuSHCG1E7aQjR1/VTcgOqDOSSrGfHK+IPmBwE0IhqM7OLpuAP2LuderNFiwizRYwqdH3tKxBzfQRmQto82lPEy9FQeVPupNoqh3JCx8ln0ckdfVpIZz+x5A0TfY1y2hyLcJJyze5Mfp1QEAsPuxh3GUj8S5gPAKOv0e0GEG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719359551; c=relaxed/simple;
	bh=Ay7DJYQ7Tmtp/f6GrUdU9p/sV8YlUw/3+whusWJoZPk=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=IkyI8Y/3m96BJN6qJa61MfUy1DRCk6tLFa1CjDyeF0/rp0JDFhWcxgOo1yqqLpvkMU1vY+TS2TA+LzZJo5hb77nAhR0XZ/C73jFTsyoADrejwXP6MmsVXGh7Xyy3oWy4GcS1keywwxN43kPz6YYuocqlq9T80fzJ7rKa5cHJy6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CzpqtShC; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f4a5344ec7so71885ad.1;
        Tue, 25 Jun 2024 16:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719359549; x=1719964349; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jWc/RXEJMf2Bku5JAdOoiukJGhfAU2IMPKdHGjfvAVs=;
        b=CzpqtShC4Lz188QHw6mlai8SeMxqi10COSYZxAVepuBL9A5ZFrcYGdAoMnIb74LFXK
         xpGfpmtXMeKwTdxTnWhdDR0jpi8cDgVAl2GhIre2oLEXKBu7HC6VgndXb2/39IMS4qoc
         8BC9LMiNn3GQI+c3yxzLcX0b5SgfmvlFEdLkiMv6Ks7c2s46pBWlNfPVh0txZTqW8pXa
         +7lyGi+i/ujo75X1JHTstX6cv2y3/u9xVrx7sWKGQsbdTYmPVv4Hi9v/ZPRiGq6I65Hz
         ljH+qcg0ool01kzF/pjpaYh5aIDRqXI2V3BD5A3MEN+WPifHvaozfvEkgbaKGZJTa4no
         fegQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719359549; x=1719964349;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jWc/RXEJMf2Bku5JAdOoiukJGhfAU2IMPKdHGjfvAVs=;
        b=dosnWYLuHLfD/m5Hymb6nv5rrqmCGZDzDXBziMQrQ2CoozC5SSJQ4L4gV0AVtlQmU9
         62l6/Ko65AGs/IbbXt1Y23w4SUuNwkM8jhpZTD3Ak6H6/9oDzBzEuY2iQSt+VugnAZlV
         xiz/B6LXoq95N7P+YX7UENOH6NCDatUMIvNTE4845bG8tFEDqhygf7HvMnBiKG14jZI/
         ANIthdUP3aJwZ/6jL6qi58bu619mfXsbmVtsisTlgOO//Td3mXuk+t57k7V3NGU/pFKU
         tAN3AgbU5R4G43tc7HKOxn7RbZwWERDWe1y1kb2LXfUca0XTAbOkW3AyFiQfJkzrXMk1
         crCA==
X-Forwarded-Encrypted: i=1; AJvYcCXjmqinIWX+TD1llOJgvYoyUkjAOlJCEgwOA6CgeRuynfi7xRQKR/wqsEE31llM2yi0k2C12A29hkUog1A9UB7GbZcnf8oj8VvoE5HogDPwjdsjmkhelR7qmxeO0lIzfw==
X-Gm-Message-State: AOJu0Yz9boUpO4ECJXsfbnJ1R8bNkxZBwm18J1dl1NhKelZLKJ7fxOqr
	9ark8bSxLoPf+XWt0P7nbAQ7EaR+THrS8tW0MEDRT4XrYovkpX7M
X-Google-Smtp-Source: AGHT+IGYnNJixVj4gKm3j0CDWP/mg3wulVX6+NDUmsk3hW7cBwhzoaAgmNsrpRj9sF5jZrzG02aZ+Q==
X-Received: by 2002:a17:902:f548:b0:1f9:d577:f532 with SMTP id d9443c01a7336-1fa0fb4980bmr141671685ad.28.1719359548754;
        Tue, 25 Jun 2024 16:52:28 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c644fsm87268585ad.145.2024.06.25.16.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 16:52:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 26 Jun 2024 09:52:22 +1000
Message-Id: <D29I39HGFVVG.3IRU89PEXG7YM@gmail.com>
To: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "Janosch Frank" <frankja@linux.ibm.com>
Cc: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "David Hildenbrand" <david@redhat.com>,
 <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 4/7] s390x: Add function for checking
 diagnose intercepts
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-5-nsg@linux.ibm.com>
 <D28QHQGLKAKJ.NZ0V3NUSSFP8@gmail.com>
 <12c7ba9be7804d31f4aaa4bd804716732add1561.camel@linux.ibm.com>
In-Reply-To: <12c7ba9be7804d31f4aaa4bd804716732add1561.camel@linux.ibm.com>

On Tue Jun 25, 2024 at 6:11 PM AEST, Nina Schoetterl-Glausch wrote:
> On Tue, 2024-06-25 at 12:14 +1000, Nicholas Piggin wrote:
> > On Fri Jun 21, 2024 at 12:16 AM AEST, Nina Schoetterl-Glausch wrote:
> > > sie_is_diag_icpt() checks if the intercept is due to an expected
> > > diagnose call and is valid.
> > > It subsumes pv_icptdata_check_diag.
> > >=20
> > > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > > ---
> > >  lib/s390x/pv_icptdata.h | 42 --------------------------------
> > >  lib/s390x/sie.h         | 12 ++++++++++
> > >  lib/s390x/sie.c         | 53 +++++++++++++++++++++++++++++++++++++++=
++
> > >  s390x/pv-diags.c        |  8 +++----
> > >  s390x/pv-icptcode.c     | 11 ++++-----
> > >  s390x/pv-ipl.c          |  7 +++---
> > >  6 files changed, 76 insertions(+), 57 deletions(-)
> > >  delete mode 100644 lib/s390x/pv_icptdata.h
>
> [...]
>
> > > +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
> > > +{
> > > +	union {
> > > +		struct {
> > > +			uint64_t     : 16;
> > > +			uint64_t ipa : 16;
> > > +			uint64_t ipb : 32;
> > > +		};
> > > +		struct {
> > > +			uint64_t          : 16;
> > > +			uint64_t opcode   :  8;
> > > +			uint64_t r_1      :  4;
> > > +			uint64_t r_2      :  4;
> > > +			uint64_t r_base   :  4;
> > > +			uint64_t displace : 12;
> > > +			uint64_t zero     : 16;
> > > +		};
> > > +	} instr =3D { .ipa =3D vm->sblk->ipa, .ipb =3D vm->sblk->ipb };
> > > +	uint8_t icptcode;
> > > +	uint64_t code;
> > > +
> > > +	switch (diag) {
> > > +	case 0x44:
> > > +	case 0x9c:
> > > +	case 0x288:
> > > +	case 0x308:
> > > +		icptcode =3D ICPT_PV_NOTIFY;
> > > +		break;
> > > +	case 0x500:
> > > +		icptcode =3D ICPT_PV_INSTR;
> > > +		break;
> > > +	default:
> > > +		/* If a new diag is introduced add it to the cases above! */
> > > +		assert_msg(false, "unknown diag");
> > > +	}
> > > +
> > > +	if (sie_is_pv(vm)) {
> > > +		if (instr.r_1 !=3D 0 || instr.r_2 !=3D 2 || instr.r_base !=3D 5)
> > > +			return false;
> > > +		if (instr.displace)
> > > +			return false;
> > > +	} else {
> > > +		icptcode =3D ICPT_INST;
> > > +	}
> > > +	if (vm->sblk->icptcode !=3D icptcode)
> > > +		return false;
> > > +	if (instr.opcode !=3D 0x83 || instr.zero)
> > > +		return false;
> > > +	code =3D instr.r_base ? vm->save_area.guest.grs[instr.r_base] : 0;
> > > +	code =3D (code + instr.displace) & 0xffff;
> > > +	return code =3D=3D diag;
> > > +}
> >=20
> > It looks like this transformation is equivalent for the PV case.
>
> Yes, the PV case just has hardcoded values that we want to check.
>
> > You
> > could put the switch into the sie_is_pv() branch? Otherwise looks okay.
>
> I want to validate diag for both PV and non PV.

To make sure it is one of listed cases, okay I missed that
point. All those same diag numbers are valid for !PV?
In that case it's fine.

Thanks,
Nick

