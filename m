Return-Path: <kvm+bounces-30014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CAEE9B628C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 13:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114D6282976
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 12:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD2D1E8856;
	Wed, 30 Oct 2024 12:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N/q3N7ou"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A7C1E7C12
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730289935; cv=none; b=L4rkfuoI3flF6Z2OnyG3kbxTLDpO8K9YhZcAJr9/rPG7/L86pgkGBPL8qsZyX1AONEeZ1zcCIx10rZ5TbQ88NC9Kx1uQg+V861dDlzSvaCY6wpcAILLChroMWSKRFSnZkWEcZuINV7ucIZ3Rtr0wbw69DkqRpIQMS/8mcgwr58k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730289935; c=relaxed/simple;
	bh=s2jIZKjVASSagWv7J8y2mCoPBBGL1TgH2aw6o/mzsms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sk/RXOO6YwKhsqfi+g8MWplUXBdl0ixkyxFLEY2+kZ69Flg+72hz+xpYY0jVentdIgWEiEJxfQ8qsfJzBrFxCEKfFF3pLjc7Ol/+s0KjifwCi93F/0Wtf7YVCKS/wzEDDUyitSizZTyUnoZkxZA6/9Iiw2uUBgQXfItgXfp+Owk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N/q3N7ou; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730289930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zN9Omir7RGktU56FM49D9j8ooMAVlCcEhdMTzZ3iJDM=;
	b=N/q3N7ous+sZt/NqO/3gLq7xes7a6VYv+yopqr0uPd1DiStCc66ha5UKxKVWc+Ol0prHlh
	l9BhNqoe1aQo744z+IL6ANhFpR/c5bC7RDgYvCjTxjBtTLRF+T0JAxsYdhyyI4I5N15OH0
	NOcr9UA3S3dDk/e2JAL0MSkviC5MrJ4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-PgCCozAkOmmbEL-LCQTfWQ-1; Wed, 30 Oct 2024 08:05:29 -0400
X-MC-Unique: PgCCozAkOmmbEL-LCQTfWQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4314f023f55so48931075e9.2
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 05:05:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730289928; x=1730894728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zN9Omir7RGktU56FM49D9j8ooMAVlCcEhdMTzZ3iJDM=;
        b=OZQwfXgrbCELkwv1kcYh7aw57iQFL2xWFnbk4fCrac+Ehg6qAdcL63LCvF0NF2C6u+
         YWNHF1A0hMtnQAtufALEvuhnPrYGBghh5DcimtesS1NsoNAIbKTAR1MdZWiXPF0pmSqO
         Ap6fQZOEpUwhquKyUdJ6siZNAp2SMED9VeDaQaE6/2BcJf52iGfYGL7lTNhYEZYkidMa
         awOkPrhNotEWGziUOSEJvGwCDM0mW+bMk7OrkOhVLcSne46lxuDcrGr99M1OPS2xk88Q
         eenKNqKdd4VHZy1SCI0PPCgGi8NCIRdsfM251l/zE5fGoBG8aW3n8OkXOmO+7pSy6ll0
         1NBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMdrcwVGa5Xl7heIVGodbDtihgPM48pNG7cFfJrcE7uAgeHq+6/sp1WHXfcWL7I0+6mAA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVTfwuAjnCDHi6Ag19VW8VqJATf6+gsYKW6T0XP3gW91CZNvtp
	5s7KFN7E+rY/uJi8X8ypbzT60AkMEY7SxYIJZ7JZRdqt9l+4qFRD6GVOF8Co2PZ/JxVhAVc4+LW
	2hNLnEDuDG5hIO3j2xpitqJF6Kh8YQ1UF0vujJ7JKPCfkoYkC5IkAs7StVTcZSNkEO1grCbmIDZ
	w9isHpUu4iFCYqoAfeCfJC2iHm
X-Received: by 2002:a05:600c:4f03:b0:42c:ba83:3f0e with SMTP id 5b1f17b1804b1-4319ac7078dmr138182475e9.7.1730289928261;
        Wed, 30 Oct 2024 05:05:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPOcTvI2OpHfBdeRHGM/CwVAnnPo4nT0ZvRaeeOvD/HvCljKuLnaVP9aPLTQINmXKlAk/UDwLwIy9SKX5EhrI=
X-Received: by 2002:a05:600c:4f03:b0:42c:ba83:3f0e with SMTP id
 5b1f17b1804b1-4319ac7078dmr138182275e9.7.1730289927895; Wed, 30 Oct 2024
 05:05:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZyAnSAw34jwWicJl@slm.duckdns.org> <1998a069-50a0-46a2-8420-ebdce7725720@redhat.com>
 <ZyF858Ruj-jgdLLw@slm.duckdns.org>
In-Reply-To: <ZyF858Ruj-jgdLLw@slm.duckdns.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 30 Oct 2024 13:05:16 +0100
Message-ID: <CABgObfYR6e0XV94USugVOO5XcOfyctr1rAm+ZWJwfu9AHYPtiA@mail.gmail.com>
Subject: Re: cgroup2 freezer and kvm_vm_worker_thread()
To: Tejun Heo <tj@kernel.org>
Cc: Luca Boccassi <bluca@debian.org>, Roman Gushchin <roman.gushchin@linux.dev>, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 1:25=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
> > I'm not sure if the KVM worker thread should process signals.  We want =
it
> > to take the CPU time it uses from the guest, but otherwise it's not run=
ning
> > on behalf of userspace in the way that io_wq_worker() is.
>
> I see, so io_wq_worker()'s handle signals only partially. It sets
> PF_USER_WORKER which ignores fatal signals, so the only signals which tak=
e
> effect are STOP/CONT (and friends) which is handled in do_signal_stop()
> which is also where the cgroup2 freezer is implemented.

What about SIGKILL? That's the one that I don't want to have for KVM
workers, because they should only stop when the file descriptor is
closed.

(Replying to Luca: the kthreads are dropping some internal data
structures that KVM had to "de-optimize" to deal with processor bugs.
They allow the data structures to be rebuilt in the optimal way using
large pages).

> Given that the kthreads are tied to user processes, I think it'd be bette=
r
> to behave similarly to user tasks as possible in this regard if userspace
> being able to stop/cont these kthreads are okay.

Yes, I totally agree with you on that, I'm just not sure of the best
way to do it.

I will try keeping the kthread and adding allow_signal(SIGSTOP).  That
should allow me to process the SIGSTOP via get_signal().

Paolo


