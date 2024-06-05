Return-Path: <kvm+bounces-18852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C8368FC518
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 09:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D9A81C2228A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 07:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D26318F2C7;
	Wed,  5 Jun 2024 07:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CWESh61V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B1018C350
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 07:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717573948; cv=none; b=h8PrgOJ9lNuH4WTTLDEZU1IsWEWi9XciZ1JY+4kqocayb7s9mh8LC9T14lkCGxY+TbCBlvguKB21AHszyjhCxhjC4KSCxgoqfLajSKTjvHtijmLmPKAffBTQti72LXNrtmyMyCWFueJs8fJqg03RE0GP5B5uzt38hhUP+q4UxIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717573948; c=relaxed/simple;
	bh=6lIh0cLxT50JftfUA2rP85KmtIiPU5OgAnjec/yxyuM=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=DACkcES10UKypjVxcJnxDzpPwxOOJukWleknUlSNuEiw0E5dm6vKakWUjjXJmj2G50S3WvcdHBtvOsKbDEpfh+24ErGu33f7oy3gTC9C4y3QZncbxJNee31VuEazWrGUDIRyb9YYAO2jv22AQb19k2k6x8zhdpqK6TSUeEoDZ68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CWESh61V; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-6c702226b0aso490877a12.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 00:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717573946; x=1718178746; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6lIh0cLxT50JftfUA2rP85KmtIiPU5OgAnjec/yxyuM=;
        b=CWESh61V5nAXS/Ca7kfTIO+dc3zH41gs2JkJPw7avsekKCeHeP3GrKZUO4ZMtqU2RL
         wcT/oC0tfskuiuKdxxzmvLjl2zDzQD6mxojcTcwgKZBrzxqMC0IwlwLJItNobbYeL9v4
         chQCBwksngt7Bl54GXM+MNazxL/S/0+xVHvd0sud5XK7orgPUE2xsfSRuyhihpxhK/iq
         F7uYPclXIgOSGXYgdGs7OGkAAe08gtgk8z8Y9D9gv8XRgtX5tTc69YrKxYdvS3JFzk3l
         URTDns0L+pQXM3qs8vn1Mf0HCsPvFE1cz1U3qiQe/c+ulqHFEzGFdBS3sPL2NC0agmXQ
         NETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717573946; x=1718178746;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6lIh0cLxT50JftfUA2rP85KmtIiPU5OgAnjec/yxyuM=;
        b=BfFSKUe/vVTkNSkJjFEJfLUhyYIUS9bSXZjtM/q0BXogfnUSPa3xREFHmNW9wCJ005
         XXrW8sGLzneAtDMCDf2d1DZUYln4iMh+d2roi+PXZu0pE7XK6H1PoJrMnHdMghJ1HHwI
         lSbjmJroKLAAvV8gZ/+lc8SaXzR7uPZRj1qlmT1FVE/bunzZjdOFCPZDhjmulmPhhw+m
         djeigx/zGytR9m46RcejRtoqBkZ37Jq9biVdbf/W2rmYkfH3Q4yboNvRN3qWowVEXNAY
         Nsb+30Cw3+yRp7opTi+3vqgmx34tJREY3lqF8z4VirmoNj60U8BrEMohFZDf2I//NiAb
         pYvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWd36Z7YRPJvzS+F555NfUigJnQxqJiRn/dy8DgYA4GHFCvp3AL5kCH1IZZALJpflqquc3K8W22OQaF05ZKUwSOEo9
X-Gm-Message-State: AOJu0Yz5cEhbCKqmXpFyfIBToS0WDEYZW8nhEPjTaG0q1kQiio7xMoZ1
	Qgsd4E9Of7cc4RxZCjtKZ9o4+k3692+jtVhVcxdIZ3Calryfg1kI
X-Google-Smtp-Source: AGHT+IGVXr6rfnVkKCl0GmHT+vD4oUSiqy+kJKn93c2WNj3b48AyYPWXn64ejBs975pM51aCZ89pow==
X-Received: by 2002:a17:90a:ca90:b0:2bf:e473:7045 with SMTP id 98e67ed59e1d1-2c2530ec9e1mr7144931a91.21.1717573946277;
        Wed, 05 Jun 2024 00:52:26 -0700 (PDT)
Received: from localhost ([1.146.96.134])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c2806398afsm798842a91.1.2024.06.05.00.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 00:52:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 17:52:19 +1000
Message-Id: <D1RX5B3PN2W3.26UX3M4SW8MLL@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>, "Thomas Huth"
 <thuth@redhat.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 29/31] powerpc: Remove remnants of
 ppc64 directory and build structure
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-30-npiggin@gmail.com>
 <15d6ae85-a46e-4a99-a3b9-6aa6420e0639@redhat.com>
 <20240604-92e3b6502a920717bec7d780@orel>
In-Reply-To: <20240604-92e3b6502a920717bec7d780@orel>

On Tue Jun 4, 2024 at 11:36 PM AEST, Andrew Jones wrote:
> On Tue, Jun 04, 2024 at 12:49:51PM GMT, Thomas Huth wrote:
> > On 04/05/2024 14.28, Nicholas Piggin wrote:
> > > This moves merges ppc64 directories and files into powerpc, and
> > > merges the 3 makefiles into one.
> > >=20
> > > The configure --arch=3Dpowerpc option is aliased to ppc64 for
> > > good measure.
> > >=20
> > > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > > ---
> > ...
> > > diff --git a/powerpc/Makefile b/powerpc/Makefile
> > > index 8a007ab54..e4b5312a2 100644
> > > --- a/powerpc/Makefile
> > > +++ b/powerpc/Makefile
> > > @@ -1 +1,111 @@
> > > -include $(SRCDIR)/$(TEST_DIR)/Makefile.$(ARCH)
> > > +#
> > > +# powerpc makefile
> > > +#
> > > +# Authors: Andrew Jones <drjones@redhat.com>
> >=20
> > I'd maybe drop that e-mail address now since it it not valid anymore.
> > Andrew, do want to see your new mail address here?
>
> No need to change to my new email address. We can either keep it as is fo=
r
> historical records, and as part of faithful code move, or just drop it.

I'll leave it, and leave it up to you to send an update email address
patch if and when you decide.

Thanks,
Nick

