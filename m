Return-Path: <kvm+bounces-19848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D646990C801
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 12:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEBCB1C22A1B
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 10:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689211CFD7B;
	Tue, 18 Jun 2024 09:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIpt+Wmi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFFE13C9CA;
	Tue, 18 Jun 2024 09:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718703069; cv=none; b=CqD91REVcIjqygnTcB0rHKlnwJgs6HNImzwkPsvf9nE0NNwXM0wfPTIk9rlW+TeH4EXw5qrKpHllHomN2nFSNYvYKMi4jRTQpnO9jlbEg0rYqjsJ5nnin8JfohC/cQgylc6mNeEBELnWEt/JsXNV29Sc/xbIjK3j8+zRyG5Ao+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718703069; c=relaxed/simple;
	bh=g0uSCj3d+UUUWfZz4wBc8kGDKF4ITFgP+uzc7Zk6jo4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rISXf7waFZSJA+bHlFek4ni+Hfv9Enm7AZwg5zWA0cOu1SCmiCcxQpq10sSPyefb6Pgcpe8Uofu4SO3EqV3bW1POCjA9MqE6CMcWJ/SCB7LC8B2JRQu0sctvuvWdD3aXPuPN9squ5lHvS2Px2TouNNsn6GY5sjj8bP7u7w5QOCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LIpt+Wmi; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2eabd22d3f4so62200911fa.1;
        Tue, 18 Jun 2024 02:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718703065; x=1719307865; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gd0sb+wrja9GmMiLQT0DMWUWixEF5baH+EtRGLOjO0I=;
        b=LIpt+WmiKKBJu4qn8g4Uc6VDK+8ixmT9RVeibZKhUQIbF4jdil0q03BXF8HjxBp/Ws
         Qw3wy9HVV2Y6m0mywjBMkLDiBoDYIgXWyOQpBHcY5/X5UcA0DKv2XxOFjdWZ6XoikQP8
         iOd50DLVsFJd/a6tMa+JaO3A84DuoMxFTZYAfeHLwB6yjernB1RAe4c3HzqtQqz4Y1tc
         Xsd9Vgkkl3vH4kVl/GQMjfA6nyziRXGVljh8zAQuN479Llcp9YFtbSpAVXyuORSVuwBh
         gNgr/ZCs5N2BaSYW0dqMOtSxBTLyKaiMQiV1839VZ1uIhLNxQcL6WR3z92jUxe5y9EaF
         C4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718703065; x=1719307865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gd0sb+wrja9GmMiLQT0DMWUWixEF5baH+EtRGLOjO0I=;
        b=CT61gQHjC8l993yT3OL2eHcEdqF8Yr+3QwzjhLz2z7zhp8rdzM4CLjJuA+71m9ZFHv
         WQZH3A9gNiU4IvOi2YSA7QAqCwt+i1PcUUavHTyKyCURtfWrVKxqbGnDwZh7jeoDvnRP
         E2Ns4f5ktCH2TvU4nGBuHB216zW0CGGg5F0j6kLBzSnjrNeeemqr7U+tI5iorAmXaV79
         tEOpWRPemCkhbvDVxYmtWrk2OgZrqT7yvyqHcnlOHxqVnidMSue53CpBlym5LkVykbQN
         1ap0nG6ELzUZvIFlN405A+ehJ3f2w+tKRO8XQHtk8nLi/vH7pyiKZjuw4tJnz2l60TVS
         F+ag==
X-Forwarded-Encrypted: i=1; AJvYcCWGvIrOHutgLbQxdPAX4h9vAoou0ebHDKKoFbGQUVpRMuqq9UWM104AmSA6vyKRSe4bO0yuBzMm+Fe8xGAxnWQQgrK7PnilcbPpn9tJUAIPl4+CgS5NoHYPd2Is/PfpFrKLMZiWR46l1ioPkEpQlkqCyvpCyV7ZU78sCAkGky5hcwZRgWHwjwq1b9tRaNVSSIFgmMjVqoIMBk+80/Di5Yn8X4WkY6p5v+nLsp2/OvhSvHJBjCt38+p0ettlME3QGRj90sBitCrfCFMwFCxzJQgZzx/LosYTjKxLlP5H1ScjjaFDFCVJwMypPIXrxdBHfnrgh+ESc7gda9UnWx/QVrht62e9ZhRX9uXq38s2/CdknOloLFzjfR8nUVpF8uKkv4vu8VlIB5EkS5A6K9kRAIP+vb0St8ZEMjf82zUMLFaNI+nAgY0REDEdPMff/g==
X-Gm-Message-State: AOJu0Yyx8se2x2e7S9Z9AtRF44QC1WMpEDQ3+PIIn/qJnNACJbGNS7N5
	ZIqOz2uVvcX8zYV9Qg7NC3ji4wJVwZYKWsxmUxo8bkgpt7J57Kh+
X-Google-Smtp-Source: AGHT+IEirA7ZfcWMvk+A5QKOFGiN5irQ5RBB6sZAAJ03RtbeHM09p7vDGOoZf2DqBzAK5fdSSuz/pQ==
X-Received: by 2002:a19:9141:0:b0:52c:81d5:cf96 with SMTP id 2adb3069b0e04-52ca6e659demr6468892e87.28.1718703065080;
        Tue, 18 Jun 2024 02:31:05 -0700 (PDT)
Received: from pc636 (host-90-233-216-238.mobileonline.telia.com. [90.233.216.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca2825b38sm1445362e87.24.2024.06.18.02.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 02:31:04 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 18 Jun 2024 11:31:00 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Uladzislau Rezki <urezki@gmail.com>, paulmck@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Julia Lawall <Julia.Lawall@inria.fr>, linux-block@vger.kernel.org,
	kernel-janitors@vger.kernel.org, bridge@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nicholas Piggin <npiggin@gmail.com>, netdev@vger.kernel.org,
	wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
	ecryptfs@vger.kernel.org, Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>, linux-nfs@vger.kernel.org,
	linux-can@vger.kernel.org, Lai Jiangshan <jiangshanlai@gmail.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <ZnFT1Czb8oRb0SE7@pc636>
References: <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <Zmov7ZaL-54T9GiM@zx2c4.com>
 <Zmo9-YGraiCj5-MI@zx2c4.com>
 <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
 <Zmrkkel0Fo4_g75a@zx2c4.com>
 <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
 <3b6fe525-626c-41fb-8625-3925ca820d8e@paulmck-laptop>
 <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz>
 <ZnCDgdg1EH6V7w5d@pc636>
 <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz>

> On 6/17/24 8:42 PM, Uladzislau Rezki wrote:
> >> +
> >> +	s = container_of(work, struct kmem_cache, async_destroy_work);
> >> +
> >> +	// XXX use the real kmem_cache_free_barrier() or similar thing here
> > It implies that we need to introduce kfree_rcu_barrier(), a new API, which i
> > wanted to avoid initially.
> 
> I wanted to avoid new API or flags for kfree_rcu() users and this would
> be achieved. The barrier is used internally so I don't consider that an
> API to avoid. How difficult is the implementation is another question,
> depending on how the current batching works. Once (if) we have sheaves
> proven to work and move kfree_rcu() fully into SLUB, the barrier might
> also look different and hopefully easier. So maybe it's not worth to
> invest too much into that barrier and just go for the potentially
> longer, but easier to implement?
> 
Right. I agree here. If the cache is not empty, OK, we just defer the
work, even we can use a big 21 seconds delay, after that we just "warn"
if it is still not empty and leave it as it is, i.e. emit a warning and
we are done.

Destroying the cache is not something that must happen right away. 

> > Since you do it asynchronous can we just repeat
> > and wait until it a cache is furry freed?
> 
> The problem is we want to detect the cases when it's not fully freed
> because there was an actual read. So at some point we'd need to stop the
> repeats because we know there can no longer be any kfree_rcu()'s in
> flight since the kmem_cache_destroy() was called.
> 
Agree. As noted above, we can go with 21 seconds(as an example) interval
and just perform destroy(without repeating).

--
Uladzislau Rezki

