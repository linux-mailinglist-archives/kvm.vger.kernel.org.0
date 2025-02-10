Return-Path: <kvm+bounces-37697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DECAA2F234
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 16:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E3BA3A451C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 15:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A55A241CA6;
	Mon, 10 Feb 2025 15:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTUeEBvq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F89225A25
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739202897; cv=none; b=YC1LNPvn5gwSPPbz9fZIBggNph/z6lG4fgPKCCNIsMFYDJtZnbQ3FFufgJT3x2L+7qEOWcZGbxDCkz9a+SLiK0nUKuaFIplTpiSbvx/+tKEY1pGca3UXaLVkaSADfFDX2tJ66aV3/utif57gBMPSQwyBfNPj9wp45V2Mph1pE7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739202897; c=relaxed/simple;
	bh=j29WKxGUSTi+izgr39H82JynKI6CzNJl8GDB3M9pquI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kLBUYsgEUkoEAUP76aQtvawNDmhKVX7lnDTEOdT046nbw9o4fLTwS43F/9HEf1LGuo2j8PHoE5mzEQkT+qrt+9THMkH6NWICdXkCF2LG2FAwbDvJIBJYj4oycLFX6Oboe1gdi4f/8x2xaKPznpKX5KjbS+uL/JjBAjjSZRVz3KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TTUeEBvq; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5de5e3729ecso4124309a12.0
        for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 07:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739202893; x=1739807693; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j29WKxGUSTi+izgr39H82JynKI6CzNJl8GDB3M9pquI=;
        b=TTUeEBvqBsuRKRQFA3MZiVItyrvhJrB3z6FReQXm7tG/ohzzZv3OjN4rE113DoxU40
         NSRdwMhhe0ATkZRhX6blALR0kNJZqkHXMhDUZPui7dqx19bL0yMu283+5k/jpou0w6P/
         6tNlGnqqdNXncWzOzAKxeEW07eYQe6FNPEcLDCtyjUCCpzTsJMIMpcqQ2SnQD3OseR5H
         25qpdA0BUxYgJzbp/wlLtUUngyq9H3nOQ1WL8A0xblN7dL4E3JRxJ0z1A98SrufZPIff
         LhCIA4RKd0G6PZ7jPcDR7hf6a9tYUsBpjf5b+555jJ6VqxInv607MMr2zj7cCcGBHXtq
         Jn4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739202893; x=1739807693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j29WKxGUSTi+izgr39H82JynKI6CzNJl8GDB3M9pquI=;
        b=eoR2nM6gYVXa6iDDgY3BQokHR5uoFl7H3s5ELMq0iyK8YY7TxeXHfoWXCwRVO3+A/l
         Q9q5F9Xpd8iHoooCmWeh1E1brZ6S6/6OxRfooeUyr9mzPNqKfEHDoJo1d0ysliWPwIkr
         HzNQe5DjKzyYh5LXJf0wuv9qRntCLsnQ6z51T5LVR0h/4ie2BkVWL33ULcY7nWyYlUZs
         Y+T3fBaI9G6FVo69Cd+RKWXRACqrFH8y1dItesWLKRFL4REVldSpgllBgYqpPODmhQ/i
         4kFZ6UmSe16aI/4LsNnZF8NYcfebN5F4wGqmkXRI5pvg09IgpczeV8aR1x35tZlpnTj8
         rmSA==
X-Forwarded-Encrypted: i=1; AJvYcCUmwF2FB9Tu0ZkH+x5nD7H7mPeDegwl3WYp5aQ6E1/4V2iHFrkxLBYZ5Sw/GRcrJf6Q7WA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw17SB5s1OPMKxt+JBRX+Xh8hTN1c7OmUFu0QAKN8/ZihIBiqm4
	onBbTYflad7Rfz92yZ1s1e3xpFvLlFgLr8lq+sE21sQ9vZgZigRCSz5vaXE4pFzcVlZASZ5Vysj
	fH6Ns8axZW0fEspGrWfQ9MbtmXKY=
X-Gm-Gg: ASbGncvMCs3PMum0pPmBoa248SXw02JC9AVEA1znNVPfGCAfgs7vEugPSuxp0PaGARJ
	SC87P9SAwmHiMXFoR6alqhKTs0k/3+pkVY1RdQWdv5MrFHhLQOtYT83fMw4JJp0CVim1OZtI=
X-Google-Smtp-Source: AGHT+IEuSkXcqA2SsvtXCxftBph1pQnl3lFf73NWgB+2kAslrpAQ0hig1CmXBDZOeDQkUHH6BXIOgMuQdD3YJqZ72XM=
X-Received: by 2002:a05:6402:5250:b0:5db:f5e9:6745 with SMTP id
 4fb4d7f45d1cf-5de9a0a42ddmr317503a12.0.1739202892703; Mon, 10 Feb 2025
 07:54:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
 <CAGxU2F7oh+a7nZp9MLh67ghKtkwFvHRNqNvFqjgVhBhbe4HK2w@mail.gmail.com> <CAGxU2F6mP7KfytKUQSoqvbmLyR2DRDVdmT1Gtyq=gOFv69CDXw@mail.gmail.com>
In-Reply-To: <CAGxU2F6mP7KfytKUQSoqvbmLyR2DRDVdmT1Gtyq=gOFv69CDXw@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 10 Feb 2025 10:54:38 -0500
X-Gm-Features: AWEUYZlZD7RKi-lUeQwekm16l-wZ9Y3-YVmhsg0BWwkM0Md0SibiuJv4MopSzcU
Message-ID: <CAJSP0QVY2hM3T41Z+X2aOGzRFPMmYgdzpbhOH65a=RYF=0WQEA@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: German Maglione <gmaglione@redhat.com>, 
	Rust-VMM Mailing List <rust-vmm@lists.opendev.org>, qemu-devel <qemu-devel@nongnu.org>, 
	kvm <kvm@vger.kernel.org>, Richard Henderson <richard.henderson@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, Alex Bennee <alex.bennee@linaro.org>, 
	Akihiko Odaki <akihiko.odaki@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Bibo Mao <maobibo@loongson.cn>, Jamin Lin <jamin_lin@aspeedtech.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, 
	Fabiano Rosas <farosas@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Hanna Reitz <hreitz@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2025 at 9:55=E2=80=AFAM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
> =3D=3D=3D vhost-user devices in Rust on macOS and *BSD =3D=3D=3D
>
> '''Summary:''' Extend rust-vmm crates to support vhost-user devices
> running on POSIX system like macOS and *BSD

Thanks, I have added it to the wiki:
https://wiki.qemu.org/Google_Summer_of_Code_2025#vhost-user_devices_in_Rust=
_on_macOS_and_*BSD

Stefan

