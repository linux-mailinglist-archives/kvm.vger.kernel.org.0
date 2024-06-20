Return-Path: <kvm+bounces-20167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4686591130E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 22:21:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED4EF282C6C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 20:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4EB1BBBDD;
	Thu, 20 Jun 2024 20:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HBMuCvVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A551B4C54;
	Thu, 20 Jun 2024 20:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718914826; cv=none; b=KXhjOUACSRHOo0SLIXvIvwXm6XBTu8GdZV55R8xl+me1nEnAJI6ztMaEPQMiIbVZcMZVldSLpwoDOtegmhZeNKf+QH+8oXaY1gCkIaFpScrE+yRUFpJhnEZvABbPZtNh1dtwNJ2AWWxzuvo4AZ5kRz48SNRHfRbl5YBPHyLNsiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718914826; c=relaxed/simple;
	bh=rBq7IdJM+K+0+xUcWM1SpeYU9dZrL3Z/PWGHq/TQFvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snMsX1jgiY3iUyj9+41db7jBSGodN5ZMkPVlSoJJM0/Zdt05o4z/EVS3djpLxBe2qaoOPRdP3CvFz0XzKkCE2XNS5heJCfnTcODSmzMImpGvT7KDA6Gbtouq+Dh8rNt1sB2Hs9Gg04Zz20m3PtC5HWGNRKZOm+1Npqv6ty7buwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HBMuCvVm; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-6bfd4b88608so1011082a12.1;
        Thu, 20 Jun 2024 13:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718914823; x=1719519623; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xyF3zFimLRvnxw2fNLWvvt4TaZ4/tRThw/CSNxiuI4k=;
        b=HBMuCvVmdb4Sc/t5rLWkeQINLK/S2PhdlyS9BiF/RITKFgL139MVpyJ4p46Vw0LLfl
         WwUWKzSnRhmr7ELk1WAvvN2+7sYVpWV7RFKU3ZgTVY37Ktg/G7e0I+hsEe/8lbXgnevh
         HK7YsZGQkUdsfQyOzNKW+GiqIjpWfhkVwwSNWv2pwLIzUVSqzoXsrZ5G2xMFHhrmY67e
         Mjb/Doq0dWWph1BGEKHrxKfOgwuLoGtgRgjomPkxBB7gOhfk726CcCyr6shZYV0ZBlEs
         4K4GGGtVeTm3ozCUNWYLaw5TkeRFmt0QWDB375xRvIiS6M34Qmve5LgWMgnii27ymsUm
         G2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718914823; x=1719519623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyF3zFimLRvnxw2fNLWvvt4TaZ4/tRThw/CSNxiuI4k=;
        b=IZN/h+Y+JwDlXLfCuuejad1DNQiH6Yf7rWw6y8ELQjs9cmos9rUHZKQ8YZuNLFnvgm
         A2wh0u7ZnHI/wxhRoKokw+KsoDjBAarKg1mLd/AocaC1RLOdE9yMJAWis6xMSzCIBE6S
         LqJ8n/t+bWh7O2p5tTIhMRnbXpUWoPfhsjt5LkMO5mQ5KV76EtEIphwbd2xh8fv/HgJ8
         TcFXUObAyqfwZZZSnm23pMmHmIWyYo1a6jtV635CCIEPT2fIvj+WZdJzzBISTNOZyRQV
         FZsJBSH4yX1gnQ8lQs4q7fCFbdN8kH1b64+ldvdqLEMnUyqqEc3fkY8fuh/MS7B3TCCo
         HtnA==
X-Forwarded-Encrypted: i=1; AJvYcCXb3mc+CIjr5uFZ4jTT/Tjtwe/pUoriQmYfDVS0Jdn9qYyKLFy0Ng/N/cdiQ11KIcFNENQnkdc8EX8lDt9s/5qAPiSQhV/WB3Tn9lKnEJhO8yOeUl0m9ga1W86/wCTEdUz6akS6Iry5wSRyIVVN7R5APGqIwcQZl7/RFLTgpAhxeRSGiS9ya1aDfp8rJko/4p60kPCHh4LXdECJGdcTPwBqtPxuzZGzc2qGD54ZqTzdxj4ooGHmZT2cTeyb7p750Gp9MsPrJ7g1S6WrQCV5mUrTnYHrjlCpaaNz3G+lU5AwRb0whwLlshRJim+So8j2RgUenhKTq1gU/FeXUJQkl88wCGvVByeCPCynbKv9arA4oCiC1BB15Nec8dJrLQQQ//gGRVF+aIa00YP1WyNlS1zN6oX8WNWAhHkr37RejNnJIuW/o4Td5x+weTUtwphu3ZZYfSOCfnIpQWWPpO9o5uKoKgvxPACZgRhCaVMkdwnf179j1yMzpjKagsf8cYYpPHRvRr6Fc10sZCwsN2AYn4tw6upgLF09s3z05imWw9p0GrX+Ak25mLScP7lK+2PbMm9uPHQ6fr0gDWiJwjY+1xnzycu8d6OaavcbOy9QBrvwj2vnSdkZyzvy+M6U9FI4aJGOv4mXbBxXi1TDikNabyopHFYJHZzfoXn4yt8RDOLSqesHxsLdUqD/wwnEOW6tuuABE2vOTRneo2NyKPa/ASJxAKSsguNJC0yiIS2a6hLSU4Y52b+9fvlMILkucGXT1GfHX+6brA==
X-Gm-Message-State: AOJu0Yw/tXaU1CSmszMcZ0JWNyyRBNC/eG91ZODIVeeavqpzNxhwc3Cg
	aYZZj7q4pNMKhvV5LOzCch14TrrcvcpEcBOKl881sCYyQbBiGfDe
X-Google-Smtp-Source: AGHT+IHgTaUdNjnFlceuqDZQb86IcFDSmpZVDJyq9iZqJozpl3uONt9e5qvEXl/03kBUwqlpGmD+xQ==
X-Received: by 2002:a17:90b:3ec6:b0:2c7:e420:a0ec with SMTP id 98e67ed59e1d1-2c7e420a3f5mr3603638a91.0.1718914823251;
        Thu, 20 Jun 2024 13:20:23 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c819dcc704sm81988a91.47.2024.06.20.13.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 13:20:22 -0700 (PDT)
Date: Thu, 20 Jun 2024 13:20:20 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Borislav Petkov <bp@alien8.de>, Chaitanya Kulkarni <kch@nvidia.com>,
	Christian Brauner <brauner@kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Disseldorp <ddiss@suse.de>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
	Jiri Pirko <jiri@resnulli.us>, Jiri Slaby <jirislaby@kernel.org>,
	Kalle Valo <kvalo@kernel.org>, Karsten Graul <kgraul@linux.ibm.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Kees Cook <keescook@chromium.org>,
	Leon Romanovsky <leon@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Nicholas Piggin <npiggin@gmail.com>,
	Oliver Neukum <oneukum@suse.com>, Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ping-Ke Shih <pkshih@realtek.com>, Rich Felker <dalias@libc.org>,
	Rob Herring <robh@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>, Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	GR-QLogic-Storage-Upstream@marvell.com, alsa-devel@alsa-project.org,
	ath10k@lists.infradead.org, dmaengine@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-net-drivers@amd.com, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-sound@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, mpi3mr-linuxdrv.pdl@broadcom.com,
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH v4 00/40] lib/find: add atomic find_bit() primitives
Message-ID: <ZnSPBFW5wL0D0b86@yury-ThinkPad>
References: <20240620175703.605111-1-yury.norov@gmail.com>
 <CAHk-=wiUTXC452qbypG3jW6XCZGfc8d-iehSavxn5JkQ=sv0zA@mail.gmail.com>
 <ZnR1tQN01kN97G_F@yury-ThinkPad>
 <CAHk-=wjv-DkukaKb7f04WezyPjRERp=xfxv34j5fA8cDQ_JudA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjv-DkukaKb7f04WezyPjRERp=xfxv34j5fA8cDQ_JudA@mail.gmail.com>

On Thu, Jun 20, 2024 at 12:26:18PM -0700, Linus Torvalds wrote:
> On Thu, 20 Jun 2024 at 11:32, Yury Norov <yury.norov@gmail.com> wrote:
> >
> > Is that in master already? I didn't get any email, and I can't find
> > anything related in the master branch.
> 
> It's 5d272dd1b343 ("cpumask: limit FORCE_NR_CPUS to just the UP case").

FORCE_NR_CPUS helped to generate a better code for me back then. I'll
check again against the current kernel.

The 5d272dd1b343 is wrong. Limiting FORCE_NR_CPUS to UP case makes no
sense because in UP case nr_cpu_ids is already a compile-time macro:

#if (NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)
#define nr_cpu_ids ((unsigned int)NR_CPUS)
#else
extern unsigned int nr_cpu_ids;
#endif

I use FORCE_NR_CPUS for my Rpi. (used, until I burnt it)

> > > New rule: before you send some optimization, you need to have NUMBERS.
> >
> > I tried to underline that it's not a performance optimization at my
> > best.
> 
> If it's not about performance, then it damn well shouldn't be 90%
> inline functions in a header file.
> 
> If it's a helper function, it needs to be a real function elsewhere. Not this:
> 
>  include/linux/find_atomic.h                  | 324 +++++++++++++++++++
> 
> because either performance really matters, in which case you need to
> show profiles, or performance doesn't matter, in which case it damn
> well shouldn't have special cases for small bitsets that double the
> size of the code.

This small_const_nbits() thing is a compile-time optimization for a
single-word bitmap with a compile-time length.

If the bitmap is longer, or nbits is not known at compile time, the
inline part goes away entirely at compile time.

In the other case, outline part goes away. So those converting from
find_bit() + test_and_set_bit() will see no new outline function
calls.

This inline + outline implementation is traditional for bitmaps, and
for some people it's important. For example, Sean Christopherson
explicitly asked to add a notice that converting to the new API will
still generate inline code. See patch #13.

