Return-Path: <kvm+bounces-20155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF939110EF
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 20:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 970FCB2A018
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC661BD8E1;
	Thu, 20 Jun 2024 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V+wOkkYY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6BF1BD8E0
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906481; cv=none; b=BgvfYqdUyc0WeZu+ov0Bi53SZYviXDw6TGjdAchbtm++jYRbpXN1ZF8deCqk3nRNtes7EhTdfIZNEiAwif/SemC11zjzewT6T6bA2sT2FAM2qFuNhqoNMHpqbp4DLGAbGLzgWYz59ADvofE8nE/F0ns+1M8kHv3BJyLUIiZnaNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906481; c=relaxed/simple;
	bh=29OxgEL3l6wtk/wr9HSlAcydEGnms+qvS9bonjZCeq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bbX+L8jtmcG6zQPGeAg52mc8Vhz8WCy3cqCybOf2+5gtIUmjXLAWcdoYnN41jVLcMICPAKFZ7sFRfrqgww4Pi+v8p93JGt577uzM4UzWCK3sGmwjO1P7yTMwYTYqOFZwwhrSp9O9KYVGmr5f3+gumaLjCRqD+cAdcOngaab8/Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V+wOkkYY; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2eaae2a6dc1so23333031fa.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 11:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1718906477; x=1719511277; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fuatl8An2r1cXJScFESolD1f90VPFvdc9a3mKIi/oro=;
        b=V+wOkkYYR8Vr1ouUmxA3Rz1kx9u301U6NkRgSuN3yRAswX2FJyGU3pvUngiUunJRv6
         zgsUhdbIHal3pvOlYRw3IcZGg5d38PnlxHon172utGDFdgrJpl8ZX+eIi0p8XUI851JK
         ml2xzptai5M1N9BqvW1Yj+AYtd2x3/p6BaO04=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718906477; x=1719511277;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fuatl8An2r1cXJScFESolD1f90VPFvdc9a3mKIi/oro=;
        b=WWrlHx1kbz1ZQsJf1Juqjw7VuuHF3xIOgE0B26oeA5Ap1Key6J0bznfeuP5SNEe88p
         uuP6hSMTHqjbBRjFtV0X8EuaF0j38FqEayPxVIqCQTZBDRHR1g9FewsUnrqJev4dkuVh
         JwfF8W/ZtLj4mdojbkdoy9u0hqBhWCR7m2k5xDhd5Jd4bUKmzHtlUnma29U6ugzrLlN1
         b3Kf7A0klZ0w6MQ6SuPhaPbTWhwv0FTLdCxlvlg2dZJ/HyxDn/FE+IV6YkkiLY4BuKX0
         coudAusFNRhJ9b9xxV6BTxpw8WgAP2kam+5zaaYrNm94eQMAqJ8h/Ue9n5q4kcImx25o
         c+BA==
X-Forwarded-Encrypted: i=1; AJvYcCWGiXQxkgrhet65U40AX9lIKu4pdpXElusMn+RocWM4wKiBTVkjmcJaUa8cPtNRbP4Hitp8gO3AMmB1p0n8LWJ45ejS
X-Gm-Message-State: AOJu0YxQEx4BXHd7coBeiR9GBDQ4KMuQGcmrY/0cYJiERi5hGQH0jwV3
	WrnDFSuGnIq221PcYzTpy0m4uCFxFjYEEBo9l7Zxy1WxOWisXE85fCc1k4DI3vRUi1LwHiTPdOm
	WpIJWtRHC
X-Google-Smtp-Source: AGHT+IGMzFfJMZ/fo2Lb6xzeqBAww82teyK1SR9D3gd1OZsO9kFqOwgceC8X5ex3XeAQ5/720KDaZg==
X-Received: by 2002:a2e:8712:0:b0:2eb:ea6f:f2c2 with SMTP id 38308e7fff4ca-2ec3ced12f6mr49127811fa.24.1718906477215;
        Thu, 20 Jun 2024 11:01:17 -0700 (PDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56db61ebsm784651566b.56.2024.06.20.11.01.16
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 11:01:16 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4230366ad7bso13888255e9.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 11:01:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVe18+6iWoIyElZHsdDckS4X6+heKlxLtACOx6nPmQvgfnCOmtsVflXLmeI50yQT5lAMRpWWUp8k8ybeIoN1QHQaRVY
X-Received: by 2002:a50:96cf:0:b0:57c:5874:4f5c with SMTP id
 4fb4d7f45d1cf-57d07ea857fmr5124279a12.32.1718906455555; Thu, 20 Jun 2024
 11:00:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240620175703.605111-1-yury.norov@gmail.com>
In-Reply-To: <20240620175703.605111-1-yury.norov@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Jun 2024 11:00:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiUTXC452qbypG3jW6XCZGfc8d-iehSavxn5JkQ=sv0zA@mail.gmail.com>
Message-ID: <CAHk-=wiUTXC452qbypG3jW6XCZGfc8d-iehSavxn5JkQ=sv0zA@mail.gmail.com>
Subject: Re: [PATCH v4 00/40] lib/find: add atomic find_bit() primitives
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	"H. Peter Anvin" <hpa@zytor.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Andersson <andersson@kernel.org>, Borislav Petkov <bp@alien8.de>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Christian Brauner <brauner@kernel.org>, Damien Le Moal <damien.lemoal@opensource.wdc.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, David Disseldorp <ddiss@suse.de>, 
	Edward Cree <ecree.xilinx@gmail.com>, Eric Dumazet <edumazet@google.com>, 
	Fenghua Yu <fenghua.yu@intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gregory Greenman <gregory.greenman@intel.com>, 
	Hans Verkuil <hverkuil@xs4all.nl>, Hans de Goede <hdegoede@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	Jaroslav Kysela <perex@perex.cz>, Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>, 
	Jiri Pirko <jiri@resnulli.us>, Jiri Slaby <jirislaby@kernel.org>, Kalle Valo <kvalo@kernel.org>, 
	Karsten Graul <kgraul@linux.ibm.com>, Karsten Keil <isdn@linux-pingi.de>, 
	Kees Cook <keescook@chromium.org>, Leon Romanovsky <leon@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Martin Habets <habetsm.xilinx@gmail.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Michal Simek <monstr@monstr.eu>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Neukum <oneukum@suse.com>, Paolo Abeni <pabeni@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ping-Ke Shih <pkshih@realtek.com>, Rich Felker <dalias@libc.org>, Rob Herring <robh@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shuai Xue <xueshuai@linux.alibaba.com>, Stanislaw Gruszka <stf_xl@wp.pl>, 
	Steven Rostedt <rostedt@goodmis.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Valentin Schneider <vschneid@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wenjia Zhang <wenjia@linux.ibm.com>, 
	Will Deacon <will@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	GR-QLogic-Storage-Upstream@marvell.com, alsa-devel@alsa-project.org, 
	ath10k@lists.infradead.org, dmaengine@vger.kernel.org, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-media@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-net-drivers@amd.com, 
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	mpi3mr-linuxdrv.pdl@broadcom.com, netdev@vger.kernel.org, 
	sparclinux@vger.kernel.org, x86@kernel.org, 
	Alexey Klimov <alexey.klimov@linaro.org>, Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Sergey Shtylyov <s.shtylyov@omp.ru>
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Jun 2024 at 10:57, Yury Norov <yury.norov@gmail.com> wrote:
>
>
> The typical lock-protected bit allocation may look like this:

If it looks like this, then nobody cares. Clearly the user in question
never actually cared about performance, and you SHOULD NOT then say
"let's optimize this that nobody cares about":.

Yury, I spend an inordinate amount of time just double-checking your
patches. I ended up having to basically undo one of them just days
ago.

New rule: before you send some optimization, you need to have NUMBERS.

Some kind of "look, this code is visible in profiles, so we actually care".

Because without numbers, I'm just not going to pull anything from you.
These insane inlines for things that don't matter need to stop.

And if they *DO* matter, you need to show that they matter.

               Linus

