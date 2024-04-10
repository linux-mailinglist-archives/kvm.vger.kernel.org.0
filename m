Return-Path: <kvm+bounces-14063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1471D89E8DD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 06:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C439628797E
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 04:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5FFC8DE;
	Wed, 10 Apr 2024 04:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VbHBsis7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691EDC13B;
	Wed, 10 Apr 2024 04:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712723321; cv=none; b=ACSJqsc0Vdg0MY7AQOgXZknh7w5eXvb1+l9ZMRhKV2O3W/pN5zOsQOrzXlq/hEN5hsKctYWEULNXsZcvxFBavguJusIuNN4TvRRzjzF+VL4Xkb7KKedFD0KSTvEpRdJ74VM0BDOlphJgj2GC/FdH0Z0Q6NAtMd2daQkkSc4s8gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712723321; c=relaxed/simple;
	bh=2u+70epJjW00+Aasor34vmJ+f/znX0w0jA47UJBKtDg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=XC5/4QbxQmgTcOWyt4f+ZtIZzPwG8SJqizNHj5W1eezIFhPXbV3PotzxWxB6fGn+jm9AhYGc3vlJpmu+z7lc8SyFB3Wa2pw9Xm/CZJlGd3Qgc0PT58tTZKhPXwC7gxe+e7jB4a7do98mkpO10fV/JdNByNgqBXW9nfhyOisnX54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VbHBsis7; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e4f341330fso1853465ad.0;
        Tue, 09 Apr 2024 21:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712723320; x=1713328120; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2u+70epJjW00+Aasor34vmJ+f/znX0w0jA47UJBKtDg=;
        b=VbHBsis7p5Kp+cefQQfEHLzJX85VtFKLfnDnHC+y05CuqutojyfsPpUY6+cZP1xkzi
         J5t++qufmQkP7vHnD9iCpLvZLvY83R/2Ts85yF0XbzLh3egm1h6HEJPtX8otGKEEugcm
         WrWUJ55B8qBCmHBNc7l1YaFbxDgebNS4MvAT9n2RAJdifNalpmhUjdlSi5rxq10T6R+Q
         Hh7Qhv3UTOwmYLZo8JBut8ISTvEYpRXGvArWu8j3HrKm+JtN2+KGdI+VISGZ/EAy6dyW
         QOyoZQ7qhUnHwA8DMxwW7PGDs75EJfSmeI9mtdUh54NwyQbefIEB/xCBi3ScytusMxQm
         sjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712723320; x=1713328120;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2u+70epJjW00+Aasor34vmJ+f/znX0w0jA47UJBKtDg=;
        b=Gna5+ZwVbkmps48yPlB44hzlOB3Qor4AHoj0EpYOigsNXeDHngTf88O9AFDr6U4YTx
         tkowg8XSqxrWQYI5igsghb1biBO1wuh6NZlJbQYGW7FEHGNyz+PhK77zzockvNnHTHVY
         bsw5I8EmZNrOS7BijYbdp9N5KNQh7yr4lUGtRC6l9v5f0UVbAxlPFtkOLh569koJntdg
         odElkBpDw45pEssL/tOCj1TQx6COJfO0BIO0lUAgfQ5wIYndjcD+7Y/aRkuCuJlc1vIQ
         d6rw24+HUdkaimnKGAOkK4SS7/maZVRj4zEPI1kSjr0jzgpUkJLbbqH91gu5Rgy9AvfU
         1x6A==
X-Forwarded-Encrypted: i=1; AJvYcCVvFR512CB/+skAC0HBDLmgWwyCDLXcT2hK9ljb7eDydLobTeLqipzaa57UZ6L1XhbZwO2m709e2/xS+E6B55Rnn6BfTRp2CR2ZEHLdoK+L9iEJQuaMaERcSrXbEg==
X-Gm-Message-State: AOJu0YyanPxCZjbMTO6jKZcDHT7dY1MHNDS02UViZRmKTtgmx6BfVYB1
	+Og2wAqvpyLbE5GkUruQ5ErFNQhE+OS6g5Zgooq/xD6NfXjwhRJN8NwPYlEM
X-Google-Smtp-Source: AGHT+IEe7rAnY9uQDbz0Y7OlDS91jLim4bdEpY9FTdShRZXCnoeQFpggWylXUmXRifVvfewT7s5iJQ==
X-Received: by 2002:a17:903:228a:b0:1e4:c75e:aace with SMTP id b10-20020a170903228a00b001e4c75eaacemr1883931plh.29.1712723319585;
        Tue, 09 Apr 2024 21:28:39 -0700 (PDT)
Received: from localhost ([1.146.50.27])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902ea0100b001e042dc5202sm9721472plg.80.2024.04.09.21.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 21:28:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Apr 2024 14:28:07 +1000
Message-Id: <D0G5QG4M991A.1QAWDKSYM6A89@gmail.com>
Cc: "Jordan Niethe" <jniethe5@gmail.com>, "Vaidyanathan Srinivasan"
 <svaidy@linux.vnet.ibm.com>, <mikey@neuling.org>, <paulus@ozlabs.org>,
 <sbhat@linux.ibm.com>, <gautam@linux.ibm.com>,
 <kconsul@linux.vnet.ibm.com>, <amachhiw@linux.vnet.ibm.com>,
 <David.Laight@ACULAB.COM>, "Linux kernel regressions list"
 <regressions@lists.linux.dev>
Subject: Re: [PATCH] KVM: PPC: Book3S HV nestedv2: Cancel pending HDEC
 exception
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Michael Ellerman" <mpe@ellerman.id.au>, "Thorsten Leemhuis"
 <regressions@leemhuis.info>, "Vaibhav Jain" <vaibhav@linux.ibm.com>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
 <kvm-ppc@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240313072625.76804-1-vaibhav@linux.ibm.com>
 <CZYME80BW9P7.3SC4GLHWCDQ9K@wheely>
 <a4f022e8-1f84-4bbb-b00d-00f1eba1f877@leemhuis.info>
 <87sf007ax6.fsf@mail.lhotse>
 <cb038940-63fd-4348-bed2-13e1b2844b92@leemhuis.info>
 <87y19obfck.fsf@mail.lhotse>
In-Reply-To: <87y19obfck.fsf@mail.lhotse>

On Mon Apr 8, 2024 at 3:20 PM AEST, Michael Ellerman wrote:
> Thorsten Leemhuis <regressions@leemhuis.info> writes:
> > On 05.04.24 05:20, Michael Ellerman wrote:
> >> "Linux regression tracking (Thorsten Leemhuis)"
> >> <regressions@leemhuis.info> writes:
> >>> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
> >>> for once, to make this easily accessible to everyone.
> >>>
> >>> Was this regression ever resolved? Doesn't look like it, but maybe I
> >>> just missed something.
> >>=20
> >> I'm not sure how it ended up on the regression list.
> >
> > That is easy to explain: I let lei search for mails containing words
> > like regress, bisect, and revert to become aware of regressions that
> > might need tracking. And...
> >
> >> IMHO it's not really a regression.
> >
> > ...sometimes I misjudge or misinterpret something and add it to the
> > regression tracking. Looks like that happened here.
> >
> > Sorry for that and the noise it caused!
>
> No worries.

It is actually a regression. It only really affects performance,
but the logic is broken (my fault). We were going to revert it, and
solve the initial regression a better way.

Thanks,
Nick

