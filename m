Return-Path: <kvm+bounces-23814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B3894DE95
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 22:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D281B21038
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 20:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3D513DBA4;
	Sat, 10 Aug 2024 20:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="SYzN/+gm";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="luYSufYO"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1806F381BA;
	Sat, 10 Aug 2024 20:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723322803; cv=none; b=ReSuaVtZofE5utdgpXgtEV+AyF7oKhF6snVqJiz426T1Jqvu6iQ9eaHlhrjmk6HIeNuVPGZV9x4Jw04cOCD9oZvX2TUcoE94BHf6nqmAkzU2gfBxZ3cLttFk98FnKc1gB4Eiv3tkDpoApkOczPg67/gQUo3/SKjKuWHAN0D7j5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723322803; c=relaxed/simple;
	bh=KKatjUDfUDh3394abB3/k7FYraV6vbUqJI+NfUHQpFs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eem9tSbL5M+OnhJ0EKvLP88w5hutYT9OKbF9CzecbBTcJqKjhFUYorHoF992/XDz5jvm0G0EJL+GAutl8b0VUdyw7cav64djztW2e98Op/0ena1oQ39dXDMaqXbQcH8BFwf6r/EDhXPJUqcAxIGx0eywjG+IWTjX8XUrDSLva8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=SYzN/+gm; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=luYSufYO; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723322800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4EB6G605UpqViWz3uTt7qqaR1ty9Iaba8hEW5CoDrxE=;
	b=SYzN/+gmwiSt8zjP5e320hPbBMJJpemWcEOV/C61HAH+KNL9nsWIox8NbYP2pgPBu/3Xz0
	yQL8Z8FSMjkgq5HqSuP3gglZpwJZJxIfnWtlHXDOTcatRP1ge7bHqk2O+5jYypO4nKQ/ie
	Y5cm2q2/hr3uG9ha5MFfXl6J6BBW4gQrUxg75QKpAy+135p/m1Kd+Jstf+lgMCdSUk8MXH
	pu0y/bELyEwu9AzPBifUCklSNog2tdhdovqPMzyMx8swps0UV/6FVWNTC0VTEh9ekXSO7e
	Qd14+TnDIrnYJw/OwzlPX2Gp8eipcnz9IzOivrr1ZiQS5ZXyNK++cAFXZz/uxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723322800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4EB6G605UpqViWz3uTt7qqaR1ty9Iaba8hEW5CoDrxE=;
	b=luYSufYOE9iMYEfrZDBXG+F6zYOlckEFvz6toHP8i6rE/EeatF5aAnFxWLQz2Qdz7uhNAW
	T3FJE0uaRdpNJgDA==
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, x86@kernel.org, Song Gao
 <gaosong@loongson.cn>
Subject: Re: [PATCH v5 3/3] irqchip/loongson-eiointc: Add extioi virt
 extension support
In-Reply-To: <20240805073546.668475-4-maobibo@loongson.cn>
References: <20240805073546.668475-1-maobibo@loongson.cn>
 <20240805073546.668475-4-maobibo@loongson.cn>
Date: Sat, 10 Aug 2024 22:46:39 +0200
Message-ID: <87wmkortqo.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Aug 05 2024 at 15:35, Bibo Mao wrote:

> Interrupts can be routed to maximal four virtual CPUs with one external
> hardware interrupt. Add the extioi virt extension support so that
> Interrupts can be routed to 256 vcpus on hypervisor mode.

interrupts .... 256 vCPUs in hypervisor mode.

>  static int cpu_to_eio_node(int cpu)
>  {
> -	return cpu_logical_map(cpu) / CORES_PER_EIO_NODE;
> +	int cores;
> +
> +	if (kvm_para_available() && kvm_para_has_feature(KVM_FEATURE_VIRT_EXTIOI))

Why isn't that kvm_para_available() check inside of
kvm_para_has_feature() instead of inflicting it on every usage site?
That's just error prone.

> +		cores = CORES_PER_VEIO_NODE;
> +	else
> +		cores = CORES_PER_EIO_NODE;
> +	return cpu_logical_map(cpu) / cores;
>  }

> @@ -105,18 +144,24 @@ static int eiointc_set_irq_affinity(struct irq_data *d, const struct cpumask *af
> @@ -140,17 +185,23 @@ static int eiointc_index(int node)
>  
>  static int eiointc_router_init(unsigned int cpu)
>  {
> -	int i, bit;
> -	uint32_t data;
> -	uint32_t node = cpu_to_eio_node(cpu);
> -	int index = eiointc_index(node);
> +	uint32_t data, node;
> +	int i, bit, cores, index;

Is it so hard to follow:

  https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#variable-declarations

?

Thanks,

        tglx

