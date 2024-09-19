Return-Path: <kvm+bounces-27180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48DDF97CB55
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 17:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91869B2393A
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 15:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A62F1A0BC4;
	Thu, 19 Sep 2024 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C6MHDpmP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AB81A072A
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726758461; cv=none; b=WJgvx4997iggUIHpJu1rp4/y7nJ620XqEWDe8e3S1Cd9gZJgQRh36w72b3kDwuCCw5t4e+ZKnRO7tJI6kxvsy8vDgEuEU9AFvJuu0g8DdaQTeSKe7O95/0C2JNIa3Wrcgd29JYsG6vyrC8fa5G8cLI3kjYeAvl1B/WE4pvN3Ybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726758461; c=relaxed/simple;
	bh=zTX2cg50iHlLd3llr0TXiQMRYPkIqgvqhdCjB4ltTqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WE7Y2ON8VFf07hfprGgPokmTpngojZ5mZZtD4ONvgLE9tN+bBm/YSCZb8f+cqYvgpR+/1iU5fo0GZtvIV2DQl8f2ghlwZx+cE/MHLjlafhgGjLSbg3g5dZyQTcopHbiCKo2AReSt9nn7mr8pAf74BqPyGdSVSuScUPADWXmzkcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C6MHDpmP; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7d4f9e39c55so704394a12.2
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 08:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726758433; x=1727363233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTX2cg50iHlLd3llr0TXiQMRYPkIqgvqhdCjB4ltTqA=;
        b=C6MHDpmPWg6ImVSVupcCqwJebcrhRBPQJsjY/gZWCKQM36RTV5wq2o0ubhUWDTX1pN
         igLLtZWOunn1QWNZgDjNq+EndpWl7opLUk0Z6RuYS5EHtxHlp7ZGwC4DkElflbhgXWeu
         QuTGD92CT/yA5l0JXvFTk2PTglL2+AOYwn3Wrxu8eSu8hOQX4sIpOixCCaDctjSpRT3G
         xoFD4Z5Mra9xtAf6z9LPTf70idZ16J/TQJbr9iioKG9R09UQKrTGA2b45WH0K7gbS37d
         7VcSf6Xb4jeKHdIuGmRbm9NAzfo+cgrrsRJao5hPkiflbdgBc5Huqe8xH9SEbhR1T4yc
         8Sfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726758433; x=1727363233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTX2cg50iHlLd3llr0TXiQMRYPkIqgvqhdCjB4ltTqA=;
        b=n++kHar80YbLLKqph46aqdwJgFNVGXvcKA9dv3DW/bv3cNzq2c46y6YvLHIQclsTbZ
         NpCEYMV7XZ9KezBZwMUGlkTHh0Sm2hdHV5ynZkp3y6ZoRfyvhOmHN8W7nps+FVdxlxDW
         ejhsW63s0Ck569wZ00WGOuNv3bZZ3MhtQOLi+OCkasb316yDacClkY9wI45aVjT6nzVl
         Y/iOrdG1NkDsIkv02u/DU9kBArV8YFYHqkreN/nZdXAn+ILJp/x0HDyqhGhH9+LtXPEB
         lbKPGP2PWrjgcQdj4E4dMVbrlJ3AgVJeoCl81/yJp49dILWyRfQO3Wst2stnQO+IZKFc
         u8Ng==
X-Forwarded-Encrypted: i=1; AJvYcCX2U5Gme/rUj39bhrgd25pAsEUmKWNK/+bZRrNyXoCerMPOl7t6DmWtzF/wLxH60Y4sQdU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyu4fa8BZw7tqDcprhdmHkAi679Tg0insV55HQpkX3WDz6XION4
	CXXFwWyTl69+LE0Nk2yVKi1f/9kvndVrCMeiHGO9GTGRJ4A+An0TWH4785WCxf5I7ryZTAhQhj3
	MlA70EMjlhhkfSSTCBJElx59RHEHmC3TZkVf9V1lMV5+aeWNdVjOpzKw=
X-Google-Smtp-Source: AGHT+IH5KdWmVYdVGhH1YJwTT9BeiFn9LnB6HS47xkZ4yRuON9VoQ2KHUIf+6fZMyNC/5O3cZX2xrGxHoy1y3uidUWk=
X-Received: by 2002:a05:6a20:ac43:b0:1cf:476f:2cef with SMTP id
 adf61e73a8af0-1cf7624b4bamr32388167637.49.1726758433158; Thu, 19 Sep 2024
 08:07:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZuK30-Ug790Vbhck@8bytes.org> <FD656EE6-DC11-46E5-B9BE-7A7647316581@8bytes.org>
In-Reply-To: <FD656EE6-DC11-46E5-B9BE-7A7647316581@8bytes.org>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Thu, 19 Sep 2024 08:06:57 -0700
Message-ID: <CAAH4kHZoLEjhHv8wD_Oj3qjQs89dB2Q17O5T3sLnAa6gFia4AQ@mail.gmail.com>
Subject: Re: [svsm-devel] Invitation to COCONUT-SVSM BoF at Linux Plumbers Conference
To: =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: svsm-devel@coconut-svsm.dev, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The livestreams don't appear to be named with "hackroom". Do you know
which to watch from this page?
https://www.youtube.com/@LinuxPlumbersConference/streams?app=3Ddesktop

On Thu, Sep 19, 2024 at 7:57=E2=80=AFAM J=C3=B6rg R=C3=B6del <joro@8bytes.o=
rg> wrote:
>
> The session is broadcasted via LPC Hackroom #1.
>
> > Am 12.09.2024 um 11:43 schrieb J=C3=B6rg R=C3=B6del <joro@8bytes.org>:
> >
> > Hi,
> >
> > The COCONUT-SVSM community wants to invite the Linux, virtualisation, a=
nd
> > confidential computing communities to our BoF at the Linux Plumbers
> > Conference next week in Vienna.
> >
> > We hope to gather ideas, discuss problems and get input for the next
> > year of development. It is scheduled for Thursday, September 19th at 5p=
m
> > in Room 1.14. Details are at this link:
> >
> > https://lpc.events/event/18/contributions/1980/
> >
> > Hope to see you all there!
> >
> > Regards,
> >
> > J=C3=B6rg
> >
>
> --
> Svsm-devel mailing list
> Svsm-devel@coconut-svsm.dev
> https://mail.8bytes.org/cgi-bin/mailman/listinfo/svsm-devel



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

