Return-Path: <kvm+bounces-11636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 354F1878E33
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 06:40:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62DC61C21FBA
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 05:40:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257B41804C;
	Tue, 12 Mar 2024 05:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YYin5Bi7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C108BE8;
	Tue, 12 Mar 2024 05:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710222004; cv=none; b=LM809J3zMRJ4T7M7xcOV+GUjMoFougky8OCxzWuiTr+MCv0uhCYL1MW0vEWDVAFSICq8rlsps/yp6qpfHMteq45Qb/RKOwKBwU2uhVaA2kAti5vCb9BSX8ULBZT1DvuIpk4Z5zRS3G6ZT0c+0LKn/K/PuQSMP/6IiTLbxJYT+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710222004; c=relaxed/simple;
	bh=MyR5SZ6Qdv2397G2tIiBKtYqWScOGbdaEX8EEBNOk34=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=HO4/arX3o32mSGfSQA90KzWlb5d2WKsAdYDLppRtZ1savMuyo7V7/GRI7tOxpzG+ghK2srfrFE9RbwcqbB3217tjp+Xwe35gq+X3VTYZv14Hu8fIosyV2PoIq0Pv7aU9CgEguZoKnxBw1uYfkjN9Xrpzx+bAl2P7wWmsQ0fjWNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YYin5Bi7; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-53fa455cd94so4420723a12.2;
        Mon, 11 Mar 2024 22:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710222002; x=1710826802; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MeBpnbK0DvHBH0dxfOexxIi1maP8eZLnEL1BqVP6aUg=;
        b=YYin5Bi7oQh8c+yQMsJJm8Cl9VfCkfYq2lOLBacB1gTunBu08c54xLTM9/+Gfq9Sle
         lojrM1kcwaZ/aAG1lW6erPgxoXNNYiRMf7AbGj7gEysfnPeTM2oBvPX5JFg7zmrtddUU
         m2L0GxLnjGOpdYv7TxlNNkmIanl3ZJKQudlIBqEuHAHsjtp5DQO6B08ea4LaPyN6RcCf
         3G9PY7l1BLHd10gLywVHaKsadW6WOdkUgzav7Vmo4orz2I5rzu/OW7R/zCgPgIRHtTXn
         ivmU6OqF4pLqqMxz0RNzTU3/Ep5p8pPQnCRUfZeW2WcbARCLvg3M5789LDqccQ4hvGMZ
         O7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710222002; x=1710826802;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MeBpnbK0DvHBH0dxfOexxIi1maP8eZLnEL1BqVP6aUg=;
        b=YSbwaEB6f8J2edR2pf2lC2qA+y752QBizc3alnTlFMmav2Sd5ptOrAeL2R1hGrfBcE
         AFZ/aSouR7KTgZRMKTbE1oQo9yyUo7TLfJQJSQjrg1jPe9b4Fl5wXRm7Y5i04Ezz6Q8/
         cFqZB0jqF/5h1QLaekw5QIqPMpUEYVz7zeexm85GD4RJDuchcDt5X/XtEFbdjAhgBMre
         SKVAmMq/AlH8ac/scWFOrmrUPBqOqY8p8WchbYtLKG5N6D0idj2iSkwlEhwqQpXWpBiM
         qoKRQGPcEcqMu0aZRktkvdeiNn8nhzaviDAYQYywiyBl38Rt7IN9VcXYBNzKLxeh7Tzf
         16WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWCaAVpzk9EJtxUudwgNFjhaQcEER0EndOLlQFWDkI+DqTZRBgXvwpRgHrzHYpa1n5MxpV/dU+DkEC1ZFsk2IYHxeODQNFdjggTw==
X-Gm-Message-State: AOJu0Ywl0Wx0Rf/1A4Q7IwKDoWxJA0C+lkQcjVjfTf66iTvEppjZ/A3x
	WSJy2B3rPfdHRZK/V/BrITSRvwJwuJvT4gNs07jjjaWf2Rg5y1Zh
X-Google-Smtp-Source: AGHT+IEfWhr7gOrWQGM2j8IlK3aPvS8xBhmwURHugULmmR1T38gPS00vcgyHFnvxEwxEo9MERUoypA==
X-Received: by 2002:a17:902:7084:b0:1dd:7de5:88fd with SMTP id z4-20020a170902708400b001dd7de588fdmr626637plk.66.1710222002099;
        Mon, 11 Mar 2024 22:40:02 -0700 (PDT)
Received: from localhost ([1.146.55.44])
        by smtp.gmail.com with ESMTPSA id kq8-20020a170903284800b001dcb4ae9563sm5725703plb.33.2024.03.11.22.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 22:40:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Mar 2024 15:39:56 +1000
Message-Id: <CZRJ3MUT6HWP.11KK3F4QNKUGH@wheely>
Subject: Re: [kvm-unit-tests PATCH v1] arch-run: Wait for incoming socket
 being removed
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nico Boehr" <nrb@linux.ibm.com>, "Marc Hartmayer"
 <mhartmay@linux.ibm.com>, <frankja@linux.ibm.com>,
 <imbrenda@linux.ibm.com>, <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20240305141214.707046-1-nrb@linux.ibm.com>
 <87il20lf9b.fsf@linux.ibm.com>
 <170973018238.31923.4497119683216363940@t14-nrb>
In-Reply-To: <170973018238.31923.4497119683216363940@t14-nrb>

On Wed Mar 6, 2024 at 11:03 PM AEST, Nico Boehr wrote:
> Quoting Marc Hartmayer (2024-03-05 19:12:16)
> [...]
> > > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > > index 2214d940cf7d..413f3eda8cb8 100644
> > > --- a/scripts/arch-run.bash
> > > +++ b/scripts/arch-run.bash
> > > @@ -237,12 +237,8 @@ do_migration ()
> > >       echo > ${dst_infifo}
> > >       rm ${dst_infifo}
> > > =20
> > > -     # Ensure the incoming socket is removed, ready for next destina=
tion
> > > -     if [ -S ${dst_incoming} ] ; then
> > > -             echo "ERROR: Incoming migration socket not removed afte=
r migration." >& 2
> > > -             qmp ${dst_qmp} '"quit"'> ${dst_qmpout} 2>/dev/null
> > > -             return 2
> > > -     fi
> > > +     # Wait for the incoming socket being removed, ready for next de=
stination
> > > +     while [ -S ${dst_incoming} ] ; do sleep 0.1 ; done
> >=20
> > But now, you have removed the erroring out path completely. Maybe wait
> > max. 3s and then bail out?
>
> Well, I was considering that, but:
> - I'm not a huge fan of fine-grained timeouts. Fine-tuning a gazillion
>   timeouts is not a fun task, I think you know what I'm talking about :)
> - a number of other places that can potentially get stuck also don't have
>   proper timeouts (like waiting for the QMP socket or the migration
>   socket), so for a proper solution we'd need to touch a lot of other
>   places...
>
> What I think we really want is a migration timeout. That isn't quite simp=
le
> since we can't easily pull $(timeout_cmd) before $(panic_cmd) and
> $(migration_cmd) in run-scripts...
>
> My suggestion: let's fix this issue and work on the timeout as a seperate
> fix.

The migration tests as a whole have big trouble with timeouts already.
The problem is timeouts are implemented with the 'timeout' command but
that is specific to the QEMU process so especially the migration harness
with lots of loops can easily hang.

I tried a few ways to address this like starting a background 'sleep ;
kill' shell, but that gets very complicated to handle interrupts properly
that kill the stuck bits and having the harness report the error
sanely. I'm thinking a subshell that runs the entire test case and start
*that* with 'timeout' might be a better approach.

So I agree, let's take patches that fix behaviour when there are no
timeouts, and address the timeout problem as a whole as a separate
effort rather than worrying too much about individual loops just yet.
(It's a fair review comment to ask though).

Thanks,
Nick


