Return-Path: <kvm+bounces-10852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5474A871391
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D69B11F242EE
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8615B18037;
	Tue,  5 Mar 2024 02:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bIRxuAml"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F70518032;
	Tue,  5 Mar 2024 02:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709605275; cv=none; b=rO2RT8vgz1e5xd8V2imjnzaQYBQnmyXFf2KS/ah/y5oKdi6pYBN9t6hDRSjSpmc52rtB5S2YCFOLjOKHwvkjlkRuBd5Z/3+tia8STppVgrOiLznCnNXaQgze8A/HnPutAH1d6NE2q/839G45FvoNfx9shMWxDwK8I8BDH8qxn5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709605275; c=relaxed/simple;
	bh=YIDccXGhBNqvU667/LYFdxg9pJxXwXqy5R1z7EMxJeM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=roTdEpHoBKG8KreHo8sOBGtldTa9lso0rx++jApPgnDtXB2bWHpGKsvEIk7z4KP13K4zShGN632V5RYV1LzCFNXLOrUdi12ILzlnRD0YxaUh5jI22QluxM+W3tVznFaxRQhKMzWYjjjYLSbeyLZ3D5sblPE0yo/2NGYs68Wm1Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bIRxuAml; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dc9222b337so51285605ad.2;
        Mon, 04 Mar 2024 18:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709605273; x=1710210073; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sMZOdoq6Dmbi4LnQtjTEVix7bF7RPhz5sddKIgU5EMs=;
        b=bIRxuAmlURm8Uu6qRDtCK0JpjpDn5MgY8/sQGM8eNfH7XSXDFEcf0xi5tFtK8axCDc
         /sFKWITGf+uMLwgy4KuwOjPWs1cp4TFQO3WG+LJ0bKvux2fCR4NmeyMWleIiIcLONzW2
         Cnt5BMbZlriDsGL6my+MY8vRhb8gXQUg9YEVu/weu0/p1dYii5ZVE6z8lrQ2D8NcZ74V
         utTDVYfUbMsj3J5DI/bhuLidQvU4JuxGhti8xubocNkfpQHuzge8q8nnLLRhsnzEcBoF
         R3a6Aio5+Htx4Z//57eFjbp+gPfy1e5sWmAgXG6SVt5QjZPOHJR4ULNb8NlARrjfyd/W
         SHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709605273; x=1710210073;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sMZOdoq6Dmbi4LnQtjTEVix7bF7RPhz5sddKIgU5EMs=;
        b=oy/dQKJLLNpIlEbJDMYqeu/kMRPVwaFUaVnWgT4gZbQxbyEXK35JqL7N+YZY39rsfS
         6PmGPrlv7ZosySei0r2KclBEXSJPG4tpBPqJO/hR6tIZ83arTP1kP1xoNQwS25+i4+Yk
         GyqrOINs3LFbVAXybb/yk+yqNhMmKHaGeknDGwsgFQedoeSV7lFLHc11BA5JMyFqmVf+
         NXO4pcj38lr+L+dYaXPF8/JkcJxjWuJxXdgmBioaGb4XzoXTCWuYp+Eyw/weO5gjU+ym
         KgfsGz8GQ2liJDH7nAIuDEs+l24mn+CgKmqRUkFG02TVy9vJX35b6ZJCZH1A3E8nAomv
         SI0g==
X-Forwarded-Encrypted: i=1; AJvYcCX2b1eEYxUxhNm18NEgHkrUY/+ryTd2JWbG7IQGumKhrOf6kuMkkGzLIjwwC17xH/TIEd1gAY9UAAU4WgF7C/P+iHGdvey7qBM5/Q==
X-Gm-Message-State: AOJu0Yx5aCLnbouAIogjxFioCSjx1swVLOK4EYYF3ItRBC9cj1DacwJk
	bNF4VT57887744oIXlIQSc9Q6VvHXlc2qszobdhjHkKbHd2+1Eh1
X-Google-Smtp-Source: AGHT+IHPKg+tkuJXSJcg4KkR+/5CA+1vAdrQ3XJqdc9bBtp6fXYAPq+C0dmymDHfd39CB8cmSSfPyg==
X-Received: by 2002:a17:902:ecc4:b0:1dd:8f6:69ee with SMTP id a4-20020a170902ecc400b001dd08f669eemr726916plh.20.1709605273623;
        Mon, 04 Mar 2024 18:21:13 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090264c900b001dcdfbad420sm8628918pli.149.2024.03.04.18.21.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:21:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:21:05 +1000
Message-Id: <CZLGHKHQ3FF0.2H7R39AIIFDY@wheely>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 1/7] arch-run: Keep infifo open
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240226093832.1468383-1-npiggin@gmail.com>
 <20240226093832.1468383-2-npiggin@gmail.com>
 <e802a3a4-5ab7-447f-b09b-75d710ba7bd6@redhat.com>
In-Reply-To: <e802a3a4-5ab7-447f-b09b-75d710ba7bd6@redhat.com>

On Fri Mar 1, 2024 at 11:32 PM AEST, Thomas Huth wrote:
> On 26/02/2024 10.38, Nicholas Piggin wrote:
> > The infifo fifo that is used to send characters to QEMU console is
> > only able to receive one character before the cat process exits.
> > Supporting interactions between test and harness involving multiple
> > characters requires the fifo to remain open.
> >=20
> > This also allows us to let the cat out of the bag, simplifying the
> > input pipeline.
>
> LOL, we rather let the cat out of the subshell now, but I like the play o=
n=20
> words :-)

It was a bit of a stretch, but I'm glad you liked it :) I may
incorporate your suggestion to improve it.

>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   scripts/arch-run.bash | 12 ++++++------
> >   1 file changed, 6 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 6daef3218..e5b36a07b 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -158,6 +158,11 @@ run_migration ()
> >   	mkfifo ${src_outfifo}
> >   	mkfifo ${dst_outfifo}
> >  =20
> > +	# Holding both ends of the input fifo open prevents opens from
> > +	# blocking and readers getting EOF when a writer closes it.
> > +	mkfifo ${dst_infifo}
> > +	exec {dst_infifo_fd}<>${dst_infifo}
> > +
> >   	eval "$migcmdline" \
> >   		-chardev socket,id=3Dmon,path=3D${src_qmp},server=3Don,wait=3Doff \
> >   		-mon chardev=3Dmon,mode=3Dcontrol > ${src_outfifo} &
> > @@ -191,14 +196,10 @@ run_migration ()
> >  =20
> >   do_migration ()
> >   {
> > -	# We have to use cat to open the named FIFO, because named FIFO's,
> > -	# unlike pipes, will block on open() until the other end is also
> > -	# opened, and that totally breaks QEMU...
> > -	mkfifo ${dst_infifo}
> >   	eval "$migcmdline" \
> >   		-chardev socket,id=3Dmon,path=3D${dst_qmp},server=3Don,wait=3Doff \
> >   		-mon chardev=3Dmon,mode=3Dcontrol -incoming unix:${dst_incoming} \
> > -		< <(cat ${dst_infifo}) > ${dst_outfifo} &
> > +		< ${dst_infifo} > ${dst_outfifo} &
> >   	incoming_pid=3D$!
> >   	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
> >  =20
> > @@ -245,7 +246,6 @@ do_migration ()
> >  =20
> >   	# keypress to dst so getchar completes and test continues
> >   	echo > ${dst_infifo}
> > -	rm ${dst_infifo}
>
> I assume it will not get deleted by the trap handler? ... sounds fine to =
me,=20
> so I dare to say:

Yep, deleted by trap handler.

>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks,
Nick

