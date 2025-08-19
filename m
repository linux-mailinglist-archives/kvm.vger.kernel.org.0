Return-Path: <kvm+bounces-54933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A910B2B546
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 02:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E577622A98
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 00:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B7B15665C;
	Tue, 19 Aug 2025 00:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="WmcTXBzW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C207FBAC
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 00:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755562818; cv=none; b=ViqoN2PYvl2tOsv4+Q3BjtgdjKax9ael2S1rnMfjwn1qIK8gJZsrQ92lGKlGYWOLA+zrQPq3iE5fpxSDGzQBCgT4PSLEVx/yz7XPOPbpEBfyc+IhojxuC/PlhExLy3A69ERY0/v0op5jrQ4qxs3jylS7xtywAS3JauggUMjNuds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755562818; c=relaxed/simple;
	bh=mZMZhGaVq/vWI5oXFpI0Xm6xIG/9/Nt2UIqIzXiWNdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6qNUOn0Y5a3R7uYUpNCH577st3Xwnjg8/ocmADdC7PiY9JclJI8VuXc9IdmRP+CbqCWY26CJqEUu6uWTAdzW7RHOaf/epYHCEHUfOsxej6vy9xkNoBdBb5S2Fnz+FOv3D2ENMCmpTzUBqjoO1AlUQiwvjkgjD8ogn3Gr/VW1T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=WmcTXBzW; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7e86f90d162so479361385a.0
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 17:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755562814; x=1756167614; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CAPvksbcJ/XXOJoTp6wZAG7UHW44uE+Uh92CsDXqVTw=;
        b=WmcTXBzWtGEdMWYodoW1DMygb+yx0dpeCdNVCV6YdAoG+NUysl0FIkIk4FbXFaqWKm
         6/qnW4JZjSYIXm8NydiH+AzDYsdizt1TElRgYdlBG6FulECeFxbbfzGZVYSTaq/OjEgL
         LP1Y8A4/fX6njVw6zlgwDL2B7cAz6vN5nti4Adp+nucHPlWQVJcBKnYLl/Dwl3ivvG6W
         0HmZ9494YF+i57UTbBLWwJgY0tI1AxqKZjdsvJ/hiaHetAOO3wRwgISJ5aDYjGrelWud
         Tvmtwh10w1XSOxcknHq5mE+Vi9eWIbjWPO25TihANiAfZIoMr4xCEfkSgViotgkUvpnj
         c0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755562814; x=1756167614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAPvksbcJ/XXOJoTp6wZAG7UHW44uE+Uh92CsDXqVTw=;
        b=arpmomqI2M2tM/YNqBsx41Db0sqIqnIuyK2zIYh5ApS1M/6XAOkVkBJ9pcBfsROe8/
         qrZTmiR/1f+jYWAeJVLEC181/hvoALgLHhrpRy/3wMVZqkhdYC1Vn7L2JsPmeyCJewa8
         GEA56UZ0RFalBLbAFr5hMiSAoA7xXKQoKmQNOziyYkjvDEgfB6vZkVsUKbxVl0BOyC8z
         3UgwPS5eTXvCs0+jAaaZSVlIn52sHa4/WDclGeKXDuFu18UzvdBazq3wGyjZB+N5hvxN
         Z1n/hdCMGPPaJyBjX1lU9+Ydn7zD/X0MP6ZiWLHf1kF/BAnyAlC3NW8YZhvJhjMBP54B
         0eEg==
X-Gm-Message-State: AOJu0YyVsKXlxQ5LAmSOLN+8HwO6gS8fcc4k4FKjFhyHH9cWJUONeNcg
	h/kkrLljOBoEiUMZercL2Fuje28Wku1AmH/3gRWNtu7vVOgxKhpbHcM22TpI8Yu42KtbwGmMQ7Q
	0DkxfXkA=
X-Gm-Gg: ASbGncuXuPjCrAArbqjkwmido0pJl0nA05aTCVnEE3Drqh2kMqGsGDLaUITYN7awaag
	+LByLwdPDp/JDs7LG0nUPc3SuCouf1A5JVS81GiFkPr/zy97smMS3rNUdINqcBaGcPEG43V0yI3
	mlI1LxDLxkIJDcmXRZNWNUTz7fKOlGDVlCa7G9+fsfnVbL4BPSV5/zjGzq9YAB5ObtwbUJwRMKi
	QdbQ5Iqi8Zuwpis6+RdmIbJtCHyjGTjArmd0aCXt8iDcGEho6XUfqXj8Hirx9fS9T96JzrIrGiH
	ZnZ3NuiTV3mZVb7X5wHyFTz3yO2HZRmqMOAjLmBkj8/kTf3iDpX/tNeoMytYSWt9sXJjciryvaF
	82yEFWolf3I1YVMsB4ilwpDGAHELevNZrRQ==
X-Google-Smtp-Source: AGHT+IEHUvZuJexFz6BBeX3fk5mL3wBIkel2sx8apDNHbc6BvCRU44PVFegJAXdrEJBt21NGRDXlng==
X-Received: by 2002:a05:620a:7205:b0:7e8:8f35:1d2b with SMTP id af79cd13be357-7e9f43067b8mr62262585a.2.1755562814479;
        Mon, 18 Aug 2025 17:20:14 -0700 (PDT)
Received: from localhost ([173.23.183.85])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e87e05477fsm685766085a.22.2025.08.18.17.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 17:20:13 -0700 (PDT)
Date: Mon, 18 Aug 2025 19:20:12 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: dayss1224@gmail.com
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Quan Zhou <zhouquan@iscas.ac.cn>
Subject: Re: [PATCH v2 1/3] KVM: riscv: selftests: Add common supported test
 cases
Message-ID: <20250818-59fc63b56f8f2da1acb7d9f6@orel>
References: <cover.1754308799.git.dayss1224@gmail.com>
 <09544c24d724a0e9d01c34b3d7599d860919ccb6.1754308799.git.dayss1224@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09544c24d724a0e9d01c34b3d7599d860919ccb6.1754308799.git.dayss1224@gmail.com>

On Thu, Aug 07, 2025 at 10:59:28PM +0800, dayss1224@gmail.com wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Some common KVM test cases are supported on riscv now as following:
> 
>     access_tracking_perf_test
>     dirty_log_perf_test
>     memslot_modification_stress_test
>     memslot_perf_test
>     mmu_stress_test
>     rseq_test

I gave these a light testing after pulling together an appropriate config
(we should probably better document needed config symbols...) The tests
seemed to mostly work for me, so ack for including them.

> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> Signed-off-by: Dong Yang <dayss1224@gmail.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 38b95998e..3a7186551 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -197,6 +197,12 @@ TEST_GEN_PROGS_riscv += arch_timer
>  TEST_GEN_PROGS_riscv += coalesced_io_test
>  TEST_GEN_PROGS_riscv += get-reg-list
>  TEST_GEN_PROGS_riscv += steal_time
> +TEST_GEN_PROGS_riscv += access_tracking_perf_test
> +TEST_GEN_PROGS_riscv += dirty_log_perf_test
> +TEST_GEN_PROGS_riscv += memslot_modification_stress_test
> +TEST_GEN_PROGS_riscv += memslot_perf_test
> +TEST_GEN_PROGS_riscv += mmu_stress_test
> +TEST_GEN_PROGS_riscv += rseq_test

Please integrate into the current list in alphabetical order.

Thanks,
drew

>  
>  TEST_GEN_PROGS_loongarch += coalesced_io_test
>  TEST_GEN_PROGS_loongarch += demand_paging_test
> -- 
> 2.34.1
> 
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv

