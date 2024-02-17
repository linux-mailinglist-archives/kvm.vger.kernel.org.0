Return-Path: <kvm+bounces-8957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E05C858ECA
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 11:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39E26282C98
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 10:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8024E1D3;
	Sat, 17 Feb 2024 10:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F8Y0xXOC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A498C4CE02
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 10:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708166629; cv=none; b=EEjAAJmuxaH4V63tnQ38Xlk7Lr98e1PQkCQxzKmWZPix4v0p1xPI4qd5wTtGD3/c2FZzS0pTrk8fmXlt7uzg31dj/Gf38s0sdHP/sAn6GVQ1+J6lDTc1pDpeRvTeTftUO7irT0wuUTa3/2nX7VAO03CT947pUrWEf2xUnkFj5a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708166629; c=relaxed/simple;
	bh=pueJuBjvdty/exNX+JTCxpqDqsWosCNdOPaeLoPKiT4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=k5MusGmMKhLwj0IpaGsc3Po5rhUqMruF+9Uh5MTmgTwfkkWBYOwqzJ3LkOl+xP7iDGwwx3ohNVb7Uw5PxLXTSNarziFgCxe/4gKew/kMXy1v0WwHRYDl2Xm9cG34pzHnkfACnPGmviOg8oSsYsYCvWBzdCOnATWlTSpqykWId1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F8Y0xXOC; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3c0485fc8b8so2463687b6e.3
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 02:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708166626; x=1708771426; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZfe2MKb984rLMd7yvUTT/B2xvgJx56CObl73IQLbW8=;
        b=F8Y0xXOC3IhbJicgsZvVppeqkA36qLMUFuhFWEbu0Dpnvg+6VH5M8jj9sUQ0v+TLPx
         MWhQbe1v885wQeYAECClhyo/g+aT5ByPdip1LMU2FXe1cTcM7BOpBB35Gf/MwRbMi2j0
         Qsh4e6XIVmLmwJvf/gsLU3ST19RVepSmE/WufL8WxpFnjvHYDwsWsltsDc8jfd7jRTFS
         oinCTrwxFg3V+Vc3Ds/ApdXiyYHVrq1rg5G1ZHJ9InBGIcJpcC/3HhfeqlSor5NBadnJ
         Huj7ncHXy8L3Oss7QcxL90yFHEI2tgLmDeh1Lit0Avq/zLsBfY1fc+XYxJDUFQ95MloM
         8DyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708166626; x=1708771426;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QZfe2MKb984rLMd7yvUTT/B2xvgJx56CObl73IQLbW8=;
        b=RcJVplJM1RBlnISz+2cljwwPZDdX4yuisx2eLo/I5jlmD6+gRSkkA4HKD8WgVIt2td
         8FkhWydk97f4rrHzhzuD4wUin5lVNwdJZHY2/YlvFmLnShizUd8DrdBD1kSEc3Sj0Xdt
         yCZwOln2tlfnR3VesAuTwhXc9IIziYXu7bJmtt4Gttf6bTTSCmbofzY0LlyBWskYIWO9
         SMTbniRf4p+p+o+rstrbtzkD0m3MtkDYEcvW1v/4ki3NI1LZ1oPCvHgjtcoZSDheD+xM
         skdEx9Qxm5449+Z+opaFXvKPGD/qtL2yUYwwg7KZMIAsKM9bJlSVujVK3doTKk6mExBn
         t/4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUrevavVC4YxBv5sU2yPpync5X+HMwQh9osA6CsMy+QNTa3NEsUu1H9Xd2HGs5GeDMFxwutxGQWfe2En+q1qKmZ3ZYq
X-Gm-Message-State: AOJu0YzJButbX/hrH2950nsKhFWFeWh0u04uWKNjMBM6rntUm3zfLbnw
	dWIV1Bms+OGlZDC6hv5+9L/NMBtZpOjgC2CZozlXeBTZFy4JylzG
X-Google-Smtp-Source: AGHT+IE/vMvcYy5KXfjptEtql1xt08TOeqPgYYDYiMrarXVweeKxNps8OyFxTOWhvz2nM6XxuQOjZA==
X-Received: by 2002:a54:4603:0:b0:3c0:30c0:e6f6 with SMTP id p3-20020a544603000000b003c030c0e6f6mr7099723oip.19.1708166626642;
        Sat, 17 Feb 2024 02:43:46 -0800 (PST)
Received: from localhost (123-243-155-241.static.tpgi.com.au. [123.243.155.241])
        by smtp.gmail.com with ESMTPSA id u12-20020a6540cc000000b005df41b00ee9sm907578pgp.68.2024.02.17.02.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Feb 2024 02:43:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Feb 2024 20:43:41 +1000
Message-Id: <CZ7AJ4JK5805.2N5QS85IP42QZ@wheely>
Subject: Re: [kvm-unit-tests PATCH] lib/arm/io: Fix calling getchar()
 multiple times
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Alexandru Elisei" <alexandru.elisei@arm.com>,
 "Eric Auger" <eric.auger@redhat.com>, <kvm@vger.kernel.org>
Cc: <kvmarm@lists.linux.dev>
X-Mailer: aerc 0.15.2
References: <20240216140210.70280-1-thuth@redhat.com>
In-Reply-To: <20240216140210.70280-1-thuth@redhat.com>

On Sat Feb 17, 2024 at 12:02 AM AEST, Thomas Huth wrote:
> getchar() can currently only be called once on arm since the implementati=
on
> is a little bit too  na=C3=AFve: After the first character has arrived, t=
he
> data register never gets set to zero again. To properly check whether a
> byte is available, we need to check the "RX fifo empty" on the pl011 UART
> or the "RX data ready" bit on the ns16550a UART instead.
>
> With this proper check in place, we can finally also get rid of the
> ugly assert(count < 16) statement here.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Nice, thanks for fixing this up.

I see what you mean about multi-migration not waiting. It seems
to be an arm issue, ppc works properly. This patch changed things
so it works a bit better (or at least differently) now, but
still has some bugs. Maybe buggy uart migration?

Thanks,
Nick

