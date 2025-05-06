Return-Path: <kvm+bounces-45554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD8FAAB964
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2E8A463FBC
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7876628FA85;
	Tue,  6 May 2025 04:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="JPXukTQ7"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BB729AB03;
	Tue,  6 May 2025 02:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746499287; cv=none; b=ON7I4evRyOHLZZlHiythz9HJZJ2YhJPyMaqhOii9V7CfFoj0FOBdXXTBi7dbwsXWk7ZqdJS2EQZyFLiumW+vWe4ktXJnHquECPUCu5SAYmWgE09yFiKCwirzFbQwYyEZeE8uZWj8suwMiu5Jv7v0zWJgFrJDwkDB2AtcNkF3wew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746499287; c=relaxed/simple;
	bh=dDn4W5v9t6AyHBHxLWO7FuLjj98KbpZnLxWf1Zria3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uqy7immX9SlBa+q/jbrac1M/HGf8kIE7nUo+8YF4js0e+v4lf4C5iPSG5qhvPOX7C7gsc86iAXJYxr/Kwc1JCGUVJLVAY3XJlcMcu/JWfZIGQAZFdw3PPnU4fyHQpItlFszjBPAJNaHTHMrR8i/Zsdcdz0Obe4azKEfeeGa26Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=JPXukTQ7; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1746499279;
	bh=dDn4W5v9t6AyHBHxLWO7FuLjj98KbpZnLxWf1Zria3s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To;
	b=JPXukTQ7lcEdJZ6z+nfwNXkm5FYZ7C5fnLDNlf3sBvo/2VQJNN0P+t3gFdY6YiHR/
	 DvMdIKgh013hU6GOyOA5JqaScgApCAX87+DPo4khZLQ5SS9e4Bgv6qPkc7yuJeB036
	 je9bv17CCVvCO59o6LjqqVdCwK/3mLiHxhFSu+yY=
X-QQ-mid: zesmtpgz4t1746499273ta1f35d3e
X-QQ-Originating-IP: l24iImKHMNBQ9uisIlimcZxyg0yZaIgIQW6RYpyxGBs=
Received: from mail-yb1-f172.google.com ( [209.85.219.172])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 06 May 2025 10:41:11 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13454101743019331379
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e6e1cd3f1c5so4199376276.0;
        Mon, 05 May 2025 19:41:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUV8LyYHlq0nlDsI4XZmlJr3s76aR90jtwTRMNgzCvsrD/O9Sn6g+mJUMhurWDCNnCJpT4=@vger.kernel.org, AJvYcCWPaGxZ2Oh4ZqQ7q0ap/SWBBhMCo2k3LQnvXIGmluoBrzzZ7oAqfotTUsYkI1eJUSxp3ePut6QxRA/CUcLu@vger.kernel.org, AJvYcCXDcMqOSkeFP9h3blrWYXgp0u01gR7+fQtAMniawU5eKbKfYfStjQ2xLgaC6iazCgArNLkwIHtERiJpfZKr@vger.kernel.org, AJvYcCXPa5fv+QCNRlDogsrF3p2mXOSFYUfkCSib42z7S4ywPyQpIwmriEriF18d5tv2kArMiXGvnB+R20rVUGroY3EK@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc1Ibqj9Iok+qmarjs2vgJs5+txWB56miUWFGadRCndAKNDK/J
	kepnO5JJZ/jjdo8XjqqlyfE/c52CR0OhBRGmFToxFizwjcFFPqCo06Nt+0Dmj+NfHdfdeBUlbsf
	kXUuqeiEMB1M375UQu/yNgu6vtdU=
X-Google-Smtp-Source: AGHT+IFgFFlMacdloLtgDC8BYlif3b1M5uLk0pWcJg25Fujp9vccWuhfsfXobAggGBnTnNta+8cIxYeCcW4lzf1hqZQ=
X-Received: by 2002:a05:6902:1ac5:b0:e6d:f3ca:3e15 with SMTP id
 3f1490d57ef6-e75c08b698bmr1960395276.3.1746499270786; Mon, 05 May 2025
 19:41:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250429-noautoinline-v3-0-4c49f28ea5b5@uniontech.com>
 <20250429123504.GA13093@lst.de> <D9KW1QQR88EY.2TOSTVYZZH5KN@google.com>
 <20250501150229.GU4439@noisy.programming.kicks-ass.net> <D9KXE2YX8R2M.3L7Q6NVIXKPE9@google.com>
 <08163d8b-4056-4b84-82a1-3dd553ee6468@acm.org>
In-Reply-To: <08163d8b-4056-4b84-82a1-3dd553ee6468@acm.org>
From: Chen Linxuan <chenlinxuan@uniontech.com>
Date: Tue, 6 May 2025 10:40:59 +0800
X-Gmail-Original-Message-ID: <973B455678FC1BDD+CAC1kPDM2pUEwFRiUZFHKq_7sYpjARkFczJnp_FRu+r9-xYdgKg@mail.gmail.com>
X-Gm-Features: ATxdqUHhA0M6lhr1xavQzClQ8qzartLkG1qHh9aYbVlX-6LFgZ39KxjHPoTQnkI
Message-ID: <CAC1kPDM2pUEwFRiUZFHKq_7sYpjARkFczJnp_FRu+r9-xYdgKg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 0/8] kernel-hacking: introduce CONFIG_NO_AUTO_INLINE
To: Bart Van Assche <bvanassche@acm.org>
Cc: Brendan Jackman <jackmanb@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Christoph Hellwig <hch@lst.de>, chenlinxuan@uniontech.com, Keith Busch <kbusch@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, 
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
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-integrity@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, 
	Winston Wen <wentao@uniontech.com>, kasan-dev@googlegroups.com, 
	xen-devel@lists.xenproject.org, Changbin Du <changbin.du@intel.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-QQ-XMAILINFO: OTRn99tF6xIxu9Ld/4bLApMY6+iBc72zONdY674Kg0NAe1QsuDk1M4PR
	EZ/1uvu9h7uaFi4a62oAx7mSC7CSt3iFhjaQTebJaGEwk05awfFdGwpEPfOx+PLQv2RW/O3
	d8VqZeBb5/m2zlbm7/rcHVDJFrdW0JvwXbCSpQoE9TfyKu1NjiW3wmg6GH6yM7EmdTl9DsF
	J6FdLzLwxD297JmcqJoW0JP71eoOgPC4T2LZnlCkW3z3ODt7Zv8SpsvY8rOcwtg96jDyPo4
	/DV3q54mZ+s+er3vVqzqZ3VCA1MTQ/BqVvgC7J7dUg71NZXrGVyoli3bL3lE9orlDsgc+O6
	9sUZd19Hl+LVo4iCopqYb44fyOrkzuwF3UfxQIF/cl8D+q/IrrgojXJx5varFYJm5Q+FQO/
	PtxR/CRTNOloiVz3qjbSQ/4W6uEyneifXP/fK84y0ECyLanykGf1n52/jreb/+ENV9ZkIcx
	p3ywWYx01lJ2UJ+xURHcQqwjXC1jIYGdbA4fi0I0TbfnpuPocTL5EzlLmOJYo/u8JAT6HPm
	hIbrW6LfgntiQva0bpmy05arTcB0pJgwOcZXYtwrl3i2c5OaNWmRceJtxCalQTMlr7Ya6gl
	BuGneyFtbXdjthZlQr3UbqKNSEOuqx0cli9wBTlnodQrNou7l2tDQYJhZsG03xVLXRNMXMI
	/QXufTqxJIElWxVptsCMSXnqqiTn087oRMhbD4JgY+QY+bp8rHn6CPVpnZQf9q5tV8+/hpN
	JPwMENFQwK2KQTJA+qQ9rssSYXDl2b47wIZ/QmhK05iwyEk0Y9bZG2p6qJPrSvbIfRgn3Yj
	+tdVn81JTsQYE5k0/tBwRb19PB5+Vshe/e/iKexCSi57TPr/VypYrpk4TtoIcwPWB1bYBJs
	I3nuAeJgW/9S6e9KFz/FImOMK7Ukhpmv6tOBCYmYKle3K44qtYL6bz1Z/DHlLcpVEO0GRHi
	3KfnmnpAngaOKS5GYpgNyAPj0yE/ptSqAk5IFKMWkQsJ4MQZn9bxkm1IqNQN5LsORkaOaVS
	eWRfT+iBmAgqa9k7Az+thgGV/R/L+HyQyPBNaNskF3GmKKReav60DhPSkOrmZ6mKV4y4YMq
	g4UrWtMo0lB
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

On Sun, May 4, 2025 at 3:14=E2=80=AFAM Bart Van Assche <bvanassche@acm.org>=
 wrote:

> If this is for test builds only, has it been consider to add
> -fno-inline-functions as a local change in the top-level Makefile?

The issue here is that the current kernel cannot be compiled when
these compiler options that reduce inlining behavior are added.

