Return-Path: <kvm+bounces-45282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25AA1AA8250
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 21:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86B8C7A5469
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 19:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5947D27E7FF;
	Sat,  3 May 2025 19:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RKuStUz1"
X-Original-To: kvm@vger.kernel.org
Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E955F1E8847;
	Sat,  3 May 2025 19:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746299649; cv=none; b=SxCe/tr3HdMnr1lJmJk6+nJdKJaSMaH8ZCNm+6MpGNn9qziG2wrq9okUhkXZLLwITj0N786NhtHcxFLvYhmFaz93t0txHaqbrdRcmV5dAzd4DAWNe6otsDWohEHqriWDlAEoRubjihWIgLSJo5FNGxt1mAr6vpD0FLxanMpUDkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746299649; c=relaxed/simple;
	bh=INtqWdF1ttpcGxLYcmEEmkHcr1sBjwlLz2bhiN/ZlGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SvqMca0//DYrjQcxKLwFoQcOQFv4/Z14vWahmJPCIdAEWaQRvutl4rDDLTFL0T+pgkrr9bbXlRx9g7g0d25V/YYsVjljnpFQF5RKIzw2nDTGKEf2H8yDG/g05aUX/rVIRP3Ss8Ga25ORPwZzyB1T4mO4vlK2NAw3JIoqydxTQSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RKuStUz1; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZqcsV3dB1zm0yTv;
	Sat,  3 May 2025 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746299638; x=1748891639; bh=INtqWdF1ttpcGxLYcmEEmkHc
	r1sBjwlLz2bhiN/ZlGY=; b=RKuStUz1pg6Z4V5+H5A4kb2tpH0qoqhbIkzY5+Di
	0Mx4FqbPL+wKIdXv00tSUygKf7k37efg+NegA9USEA+BtS9sCBdNxuJsDmcEZkXo
	KGK//P45RgKzu8d8/alXy0VIGoamRPWPYuJuGoA+pRvHTZS5rvfZ8o0ph1X5HX6J
	iTP5Of7qhYNNVXT8DuQLC0J7+xnCouyLt/xHnb0fNLYt31jsZFJ6Oj4CRIgSwz0L
	IaOUfuFPOR6U+kODE48fdLjKvbhtxcv8R6c3Ms1Bh+fzGYiKJWiOfkB3GG1TY+aB
	jrLZOMGZ2glyEj1WRg+H+/FJlug51RvdD9ZeWxSGVVTS0g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DqXzoqknLYju; Sat,  3 May 2025 19:13:58 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZqcrR2bKbzm0yMS;
	Sat,  3 May 2025 19:13:09 +0000 (UTC)
Message-ID: <08163d8b-4056-4b84-82a1-3dd553ee6468@acm.org>
Date: Sat, 3 May 2025 12:13:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 0/8] kernel-hacking: introduce
 CONFIG_NO_AUTO_INLINE
To: Brendan Jackman <jackmanb@google.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, chenlinxuan@uniontech.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Sagi Grimberg <sagi@grimberg.me>, Andrew Morton <akpm@linux-foundation.org>,
 Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Peter Huewe
 <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor
 <nathan@kernel.org>, Nicolas Schier <nicolas.schier@linux.dev>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky
 <boris.ostrovsky@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-integrity@vger.kernel.org,
 linux-kbuild@vger.kernel.org, llvm@lists.linux.dev,
 Winston Wen <wentao@uniontech.com>, kasan-dev@googlegroups.com,
 xen-devel@lists.xenproject.org, Changbin Du <changbin.du@intel.com>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
 <20250429123504.GA13093@lst.de> <D9KW1QQR88EY.2TOSTVYZZH5KN@google.com>
 <20250501150229.GU4439@noisy.programming.kicks-ass.net>
 <D9KXE2YX8R2M.3L7Q6NVIXKPE9@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <D9KXE2YX8R2M.3L7Q6NVIXKPE9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 8:22 AM, Brendan Jackman wrote:
> Personally I sometimes spam a bunch of `noinline` into code
> I'm debugging so this seems like a way to just slap that same thing on
> the whole tree without dirtying the code, right?

If this is for test builds only, has it been consider to add
-fno-inline-functions as a local change in the top-level Makefile?

Bart.

