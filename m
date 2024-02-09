Return-Path: <kvm+bounces-8406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF7DB84F155
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:27:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 843961F24C26
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D8F65BC4;
	Fri,  9 Feb 2024 08:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRBe+EIe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9B265BA6;
	Fri,  9 Feb 2024 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707467263; cv=none; b=JunRjWhlUt/HoPEtHDFXL3z54O80Qqt/PIdks11q7KAc1uGVDViydT3n6fKaW7noikmoqOTM3dR9riEVYWWzXH7iXoac+66x4Hvwd+ptJB7Km5ixihnjLyThi6lH2VZ5a6TRY89rKKrT5wlihgBbESraLoW7oY7RXwLsL+JHj5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707467263; c=relaxed/simple;
	bh=U8VJUtIod9p6s1XXmJezD1WyOaQkRBA6MsyQhUHRmn8=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=PG21BrvAO2VDx+nrx4c+DLkgejAehS+0ncrI4nX9+qMOgo8sdBHdvLWnlaLvGTim1TYqyqYAk1CkAtAgMnqy+TZiWQX0Vi5wyhv77DyEW6Z9t47QwDOLVLFOr7+/kG8rdJCoSh8aTGBaLin/tyheKhjKEIIQ37lukM8JZYs5fps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRBe+EIe; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d94b222a3aso5527225ad.2;
        Fri, 09 Feb 2024 00:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707467262; x=1708072062; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTTD1zUl6XbIoz3C+fDNL2dHgdo/Av/V6kztlCMET94=;
        b=BRBe+EIeihoP/dBiKynwVPaHaCFcg3bCgLqNyYLGfY8hEUkpnBBG8oOZewPatTSa5/
         DgPvBRRjrZJolMa27iHw6A72gNQbpT9TNtRe3QEedW/DxOZ5GmB0sixWYrlDACV1ohSQ
         pLD+Fcla6oWk5id4cl4CBuL9MOCjk5zkxReyVLBz5hE4e6M0vtJQ3gBHAj4qSGvB+8W+
         cpYkxt3I5H2FWbhQr8PjdSo5uifwvwLRzJuEUpzJ0WLRkRZS44ZBDVPk+pf4QVnRc+13
         zLhkBBpNVbg+3ui3TazR7cRNhhwCsJqJ2dZKo2K47poUqJ62o76bvqMkWXHYULMd7TYl
         YLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707467262; x=1708072062;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MTTD1zUl6XbIoz3C+fDNL2dHgdo/Av/V6kztlCMET94=;
        b=lxPDLk4mSVbPw21/OU6iUHWPQc7IZj4Wy9ZjrJvmGni4HesddcMmnepZSkvrDbf5SG
         ljoyBV4wKpfZJMabvHkxU/+GIqfhFF+L3DTAfwhf5iMlg7BcT7FR4RiDtHroB8bL9iyQ
         rbMX19h7K97ANGkdv43CrYmWK47L1e0f+Z0BS90fwMk9z/kiOn5uib3xT6i7+KMQyd2X
         b3OX8uyO4FpeH9LW7lAfuw7HSmo51cI6k6TS/1VKxrLxWO0M5xHf5GMJgDQPbWilwVW9
         /nXQWYHNAjk6r4+lUzP7/bo4DmoeoA53Y5iYrfgzfeadXsp9yUh8DvMovItzUIf6HrMW
         7oTw==
X-Gm-Message-State: AOJu0YwVJBUp+DNDYVpt5l1nt6nT5Fkn8DFxfK2TXMre23AuoKLVju5C
	stxAYhJq/08ycKEy38Zl4MoM7ZL3bfo/lyWuGtZ1XGie62dTjPtt
X-Google-Smtp-Source: AGHT+IG5BMthemltiiFcIr8v360fN9gt+99vayEmFyCcvEZHyJpxukdjW15W7pZ34jdmNysLP/78mg==
X-Received: by 2002:a17:902:f7cf:b0:1d9:93d2:5208 with SMTP id h15-20020a170902f7cf00b001d993d25208mr848603plw.49.1707467261671;
        Fri, 09 Feb 2024 00:27:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVf8VYvdZg1I9yYmtndJcECe7KBKpqawuTH71hxKTK10aCEzRGDcfp3x9IY0+mu45sKSfxMDCWOrm7OBeiIWjO8ccl1e/i7CzEyWzzRtpFkUwhl4kXYpMLRDcTNGBczKQG1R0+mRRS68AMbYgcHbyhRuTBvr46GlbLZovYZHTxRZ4DhLqtitlTUzfcxSR49t8OWGM6YDUh7XCxZtpsCc8VuoPfHjT0+rs5SVlVBwZuN/OeAhQ2MJlI8oE3bR8/55mwTUjleK8apXPQoAXDXhaolhb1P/oXRjLrAox/02p5e+POLA5rq5izQCWv+jBsnz1rtpokU0wN5cZrjiavgUUkNyTdxtwiIW9iLXityb25p3YcPAWe0bZs7KLkEXgYsfHjQEIPE8YL1yScD1T7MriDMFFouTvMeFpKkov+d+jNbRPZbS7+iqWptbJsiS9Vgo5BmatDLUAxRGIsXaP0bdS/okn8LIK4SvNr+T7OptWixdDpsjq5g7JPIJgD0FM1y2QCyqTq7IlNB02O1dFmmO8apGGvY
Received: from localhost ([118.208.150.76])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902edc200b001d91b617718sm1014472plk.98.2024.02.09.00.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 00:27:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Feb 2024 18:27:32 +1000
Message-Id: <CZ0EMJ56C8WS.1RRW73R6KWDEQ@wheely>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>
Subject: Re: [kvm-unit-tests PATCH v3 2/8] arch-run: Clean up initrd cleanup
X-Mailer: aerc 0.15.2
References: <20240209070141.421569-1-npiggin@gmail.com>
 <20240209070141.421569-3-npiggin@gmail.com>
 <9fb2f113-db36-41a6-a6f2-0499f28ace0a@redhat.com>
In-Reply-To: <9fb2f113-db36-41a6-a6f2-0499f28ace0a@redhat.com>

On Fri Feb 9, 2024 at 5:32 PM AEST, Thomas Huth wrote:
> On 09/02/2024 08.01, Nicholas Piggin wrote:
> > Rather than put a big script into the trap handler, have it call
> > a function.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   scripts/arch-run.bash | 13 ++++++++++++-
> >   1 file changed, 12 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 11d47a85..1e903e83 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -269,10 +269,21 @@ search_qemu_binary ()
> >   	export PATH=3D$save_path
> >   }
> >  =20
> > +initrd_cleanup ()
> > +{
> > +	rm -f $KVM_UNIT_TESTS_ENV
> > +	if [ "$KVM_UNIT_TESTS_ENV_OLD" ]; then
> > +		export KVM_UNIT_TESTS_ENV=3D"$KVM_UNIT_TESTS_ENV_OLD"
> > +	else
> > +		unset KVM_UNIT_TESTS_ENV
> > +		unset KVM_UNIT_TESTS_ENV_OLD
> > +	fi
> > +}
>
> Looking at the original code below, shouldn't this rather unset=20
> KVM_UNIT_TESTS_ENV_OLD after the "fi" statement?

Yes good catch.

Thanks,
Nick

