Return-Path: <kvm+bounces-45120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18EEEAA60AE
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F0A21B67577
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782BA20B1FC;
	Thu,  1 May 2025 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RqqwQegs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC485202C52
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112980; cv=none; b=BY/c2HhGU4Z5DQ8RSsIpYjCyJceuWuRCxP394YdHosL/gkLrzDxweyvDvuCMdT2mFWCNBTqHtp/vZOsj2HoGfr3/VmdlDh3ChO4Y7HqI9mL0hQd76z0syLTjG27k4VVXA3UrW6KCFwlj4SJMjn0F9ABfcwi+cPAcqOxoy7P8HvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112980; c=relaxed/simple;
	bh=GnwsPoOxW8mCGc7CAgjoDtFw8dTWra4gUIbWL5YCLUs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i5+XVT26ILzqqpxUuwW5B+/9ZfXU1dorNV3q9MZmnScFOZP51wSpVQb3BFc4rBpM7UgQ4yJ6l4fg1+w4k/hnlXDVGnNLbx0A8jD692sYguMyktp0DSGKRbJoVVaQZPe7tz4TrA0vQOxlCDGBun7o7cUn2oWxfVhLnSyWDKwQQuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RqqwQegs; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43f405810b4so4944255e9.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746112977; x=1746717777; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wm8HDKzWcPs/ZOJ7u1MGp3oUtkY4RQR0TPLRQCBj5DQ=;
        b=RqqwQegsrWLsB1Yvk3XF6QMZObcZSJzZhmHOuynYxfAjO0oGplp27iKhLgAVcrPz0j
         eWMVzCG9CejZi9x3NWPUhr1TIByngtnippTREg9TBe5WYJhV3hDngP2L9u/C0y4L+KM4
         6ze5N6b7zDXBq/JS27TtKUGHyfcbNWTSmaEekY8HKP6pJFEwbRZsR/kH6YXFGC/5IjH3
         e4vPZeITPxnOaDhMNWzPBrX1Dg0AwW+aEKY1dKZXOvoGEdTtmtU4GGb86piX/Aad55Da
         /uynSSrFWN5ORTZPS8H/O00MqgO+KM9d5s2rBmL1yeW0ZzXXRC2PVlV1F/jK3ifRzbqF
         xs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112977; x=1746717777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wm8HDKzWcPs/ZOJ7u1MGp3oUtkY4RQR0TPLRQCBj5DQ=;
        b=wn1sjNztzuFAqS4OgSMgVoSmM/I7d/HP16L3b+1Opq5Fjn03IymxJFas/u6Kljugbs
         KlPPiwL7Zpep0h/dD2mvT4MLbF1hoQqe8LOpaadKMzJPPpn6AmdxV9XFux/Ec0cHZ/8K
         4gWvyUH8DE1NbC9HvRH/Po57SINUhWc9U4R54dTjHFk1cZJ/DcsedWO3ns1ZYzpx8IL+
         fHVeH640xlDR2XecxQl8iL/cGLRvLQY24CHrWptegbmF/ZWxRJ1zytoJM4WtN2+vVWfy
         xyhHCLpdaGr0XUUouqEDbaXm76Ds2G16GhO/e/YTXsOI1cjpp8MP8Zkrg5Qg10C+rAXB
         Gggg==
X-Forwarded-Encrypted: i=1; AJvYcCUaD4iMYTFhtALKNJIrd+ju5lL/g9icQmx4MkoexDe/19q1RMUX5EoiUg5LxUKK4270wds=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmHZqzPFcxGyN6AczZPgigPIUJkRxupnYSJ79LvmAMWIppHXlN
	7vnJdhqgN5s4heAv9b1bVju5VRRnMLQIMXqOgJi1if6XiuqlaLR0TseIsYnP8Qzj4PFjJsYBCdj
	trS4VVK/5VQ==
X-Google-Smtp-Source: AGHT+IG1H8EWFmTdy9mXUfcCJxQBprr6abVa1X9treBvRrD020Cub+yFF9voa0K8UUVl5WCrL4gH+SDc7+SKLQ==
X-Received: from wmbel14.prod.google.com ([2002:a05:600c:3e0e:b0:440:5f8a:667c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4ec6:b0:43d:a90:9f1 with SMTP id 5b1f17b1804b1-441b2635482mr61130455e9.6.1746112976936;
 Thu, 01 May 2025 08:22:56 -0700 (PDT)
Date: Thu, 01 May 2025 15:22:55 +0000
In-Reply-To: <20250501150229.GU4439@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
 <20250429123504.GA13093@lst.de> <D9KW1QQR88EY.2TOSTVYZZH5KN@google.com> <20250501150229.GU4439@noisy.programming.kicks-ass.net>
X-Mailer: aerc 0.20.0
Message-ID: <D9KXE2YX8R2M.3L7Q6NVIXKPE9@google.com>
Subject: Re: [PATCH RFC v3 0/8] kernel-hacking: introduce CONFIG_NO_AUTO_INLINE
From: Brendan Jackman <jackmanb@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, <chenlinxuan@uniontech.com>, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, 
	Andrew Morton <akpm@linux-foundation.org>, Yishai Hadas <yishaih@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas.schier@linux.dev>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Juergen Gross <jgross@suse.com>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, <linux-nvme@lists.infradead.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <kvm@vger.kernel.org>, 
	<virtualization@lists.linux.dev>, <linux-integrity@vger.kernel.org>, 
	<linux-kbuild@vger.kernel.org>, <llvm@lists.linux.dev>, 
	Winston Wen <wentao@uniontech.com>, <kasan-dev@googlegroups.com>, 
	<xen-devel@lists.xenproject.org>, Changbin Du <changbin.du@intel.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Thu May 1, 2025 at 3:02 PM UTC, Peter Zijlstra wrote:
> On Thu, May 01, 2025 at 02:19:47PM +0000, Brendan Jackman wrote:
>> On Tue Apr 29, 2025 at 12:35 PM UTC, Christoph Hellwig wrote:
>> > On Tue, Apr 29, 2025 at 12:06:04PM +0800, Chen Linxuan via B4 Relay wrote:
>> >> This series introduces a new kernel configuration option NO_AUTO_INLINE,
>> >> which can be used to disable the automatic inlining of functions.
>> >> 
>> >> This will allow the function tracer to trace more functions
>> >> because it only traces functions that the compiler has not inlined.
>> >
>> > This still feels like a bad idea because it is extremely fragile.
>> 
>> Can you elaborate on that - does it introduce new fragility?
>
> given it needs to sprinkle __always_inline around where it wasn't needed
> before, yeah.

Right, I guess I just wouldn't have associated that with the word
"fragility", but that's a reasonable complaint!

> Also, why would you want this? function tracer is already too much
> output. Why would you want even more?

Yes, tracing every function is already too noisy, this would make it
even more too-noisy, not sure "too noisy" -> "way too noisy" is a
particularly meaningful degradation.

Whereas enlarging the pool of functions that you can _optionally target_
for tracing, or nice reliable breakpoints in GDB, and disasm that's
easier to mentally map back to C, seems like a helpful improvement for
test builds. Personally I sometimes spam a bunch of `noinline` into code
I'm debugging so this seems like a way to just slap that same thing on
the whole tree without dirtying the code, right?

Not that I have a strong opinion on the cost/benefit here, but the
benefit seems nonzero to me.

