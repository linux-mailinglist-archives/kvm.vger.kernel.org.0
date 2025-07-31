Return-Path: <kvm+bounces-53790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87503B16EAE
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 11:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B77717DA21
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 09:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B1B2BD5A7;
	Thu, 31 Jul 2025 09:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jHmOE71w"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EAA1F416C
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 09:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753954267; cv=none; b=XiB1Adntt6XvQVcaqEHU9T2Y6GiDi8w6i/PwU2xGmvRqFLelxv4xmh4qugoHz2GvMZjMNMDDee7MqlJU2yKmDItVx0OPFrgjkUgrS1J7QXQX/vLZbvmUBaFIwMfSLOyAykU3WrTe0bY0YKb+Sh4gqskcyURD1JRfVMuIJDoePsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753954267; c=relaxed/simple;
	bh=4tE2WjY+0AeAp150zPfzh+nEP16nO0mT6tjtlWBbuqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FXzySiYQAl8nVccI8/HTxr+lhJy87crJFdK2A7Q+2WUJoc5AbKOlGWByVLHb1iyhikRvvINa2tSdrI6/B0yNgjG+vPwv3rEfQM0jSAx2cgQfFntyDLMh+Xr3joO0VvpMTXCHyXKd1jtlmHgflwNT0Z+gnS3nKqQQuofagQTgSN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jHmOE71w; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <3fdcce8e-dff6-4871-82b3-571144a26c51@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753954251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPrBl2r6pRDQ+LFfaDIU8edcuVYOLpK/ppfQY1GooFs=;
	b=jHmOE71wedMi8BDQij8w5hXeT5C4FB9qVB5UjhslTeYSKgwTjf7FcV+W+2DOt0Fla4szWV
	ZDqgIY0ut54YAYxh6ELEV3yeXYRk4M3xDJQ24NegYh1W8v1+Xq0CrgNImkOPI6rXe+XNAi
	zz6NfzW7iD16KekU5wq3uvWKSA9QvNs=
Date: Thu, 31 Jul 2025 17:30:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] LoongArch: KVM: Access mailbox directly in mail_send()
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250731075907.189847-1-maobibo@loongson.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yanteng Si <si.yanteng@linux.dev>
In-Reply-To: <20250731075907.189847-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 7/31/25 3:59 PM, Bibo Mao 写道:
> With function mail_send(), it is to write mailbox of other VCPUs.
> Existing simple APIs read_mailbox/write_mailbox can be used directly
> rather than send command on IOCSR address.
Hmm, that's indeed a feasible approach. However, I'm
curious: what is the purpose of designing IOCSR in
LoongArch? Is it merely to make things "complicated"?

Thanks,
Yanteng
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   arch/loongarch/kvm/intc/ipi.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
> index fe734dc062ed..832b2d4aa2ef 100644
> --- a/arch/loongarch/kvm/intc/ipi.c
> +++ b/arch/loongarch/kvm/intc/ipi.c
> @@ -134,7 +134,8 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
>   
>   static int mail_send(struct kvm *kvm, uint64_t data)
>   {
> -	int cpu, mailbox, offset;
> +	int i, cpu, mailbox, offset;
> +	uint32_t val = 0, mask = 0;
>   	struct kvm_vcpu *vcpu;
>   
>   	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
> @@ -144,9 +145,18 @@ static int mail_send(struct kvm *kvm, uint64_t data)
>   		return -EINVAL;
>   	}
>   	mailbox = ((data & 0xffffffff) >> 2) & 0x7;
> -	offset = IOCSR_IPI_BASE + IOCSR_IPI_BUF_20 + mailbox * 4;
> +	offset = IOCSR_IPI_BUF_20 + mailbox * 4;
> +	if ((data >> 27) & 0xf) {
> +		val = read_mailbox(vcpu, offset, 4);
> +		for (i = 0; i < 4; i++)
> +			if (data & (BIT(27 + i)))
> +				mask |= (0xff << (i * 8));
> +		val &= mask;
> +	}
>   
> -	return send_ipi_data(vcpu, offset, data);
> +	val |= ((uint32_t)(data >> 32) & ~mask);
> +	write_mailbox(vcpu, offset, val, 4);
> +	return 0;
>   }
>   
>   static int any_send(struct kvm *kvm, uint64_t data)
> 
> base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f


