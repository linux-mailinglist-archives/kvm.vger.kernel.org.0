Return-Path: <kvm+bounces-9614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F0248669AD
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 06:26:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B9441C21586
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 05:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F041BC20;
	Mon, 26 Feb 2024 05:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="VwgvDp6S"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1F61B7E5;
	Mon, 26 Feb 2024 05:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708925158; cv=none; b=P8E0QzGNQXcc7nieGAtkt+V0wRxNEs0hvpm3Xv92ZupdoYj2Q3bQSgroxu9PdvPXNVYdcJa9xGVUjkwmGisi7WX4tf2FQ90bG7Qd9svPv++Hv/yTQZET5KwKsDRjAFogQexmgD7v1hLBf776EB7n6eHkWhq/fWguOtiuhQVpC4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708925158; c=relaxed/simple;
	bh=unQ2LQsYSP+PhMQIlc9dBDKLvTxY8sUnH0tFh+ISuH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tbka5yPIv93mCf6sa5J0fdKJvISoIoU4e5pFfaDmbbPXDoKXapjFNyN/ZZLXaPtmRreZkT1KJJqLj+qUGxPmBvAUodgbmqqLarFnn/32Y1o4PvXxgNgegYoAxb7YQLnRGXZapBFx2bB2lcQprdNa6v6kdHJALtK2ErbSg31N8ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=VwgvDp6S; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708925147; bh=unQ2LQsYSP+PhMQIlc9dBDKLvTxY8sUnH0tFh+ISuH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VwgvDp6SUHfPOigpuhE1gpc9zmD7L8Ki4mPHj0Aa6Fk6HhSyNB+aF4vyQP2c629Lc
	 DqaOuHpjb3R4vLU7nPILjQgz3zVoi04gxYQ2m0t3LBQhvJrWezX32liQzCeITwrB4d
	 /3PMn1gvzMwvq1zEWUCp69t/bdu8qmT3ZSH6B+uQ=
Received: from [IPV6:240e:388:8d00:6500:68e:73ae:46e1:716] (unknown [IPv6:240e:388:8d00:6500:68e:73ae:46e1:716])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 7EDB26006F;
	Mon, 26 Feb 2024 13:25:47 +0800 (CST)
Message-ID: <d8994f0f-d789-46d2-bc4d-f9b37fb396ff@xen0n.name>
Date: Mon, 26 Feb 2024 13:25:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
Content-Language: en-US
To: maobibo <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
From: WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2/26/24 10:04, maobibo wrote:
> On 2024/2/24 下午5:13, Huacai Chen wrote:
>> Hi, Bibo,
>>
>> On Thu, Feb 22, 2024 at 11:28 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>
>>> Instruction cpucfg can be used to get processor features. And there
>>> is trap exception when it is executed in VM mode, and also it is
>>> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
>>> for KVM hypervisor to privide PV features, and the area can be extended
>>> for other hypervisors in future. This area will never be used for
>>> real HW, it is only used by software.
>> After reading and thinking, I find that the hypercall method which is
>> used in our productive kernel is better than this cpucfg method.
>> Because hypercall is more simple and straightforward, plus we don't
>> worry about conflicting with the real hardware.
> No, I do not think so. cpucfg is simper than hypercall, hypercall can
> be in effect when system runs in guest mode. In some scenario like TCG 
> mode, hypercall is illegal intruction, however cpucfg can work.

While the CPUCFG instruction is universally available, it's also 
unprivileged, so any additional CPUCFG behavior also automatically 
becomes UAPI, which likely isn't what you expect. Hypervisor 
implementation details shouldn't be leaked to userland because it has no 
reason to care -- even though userland learns about the capabilities, it 
cannot actually access the resources, because relevant CSRs and/or 
instructions are privileged. Worse, the unnecessary exposure of 
information could be a problem security-wise.

A possible way to preserve the unprivileged CPUCFG behavior would be 
acting differently based on guest CSR.CRMD.PLV: only returning data for 
the new configuration space when guest is not in PLV3. But this behavior 
isn't explicitly allowed nor disallowed in the LoongArch manuals, and is 
in my opinion unnecessarily complex.

And regarding the lack of hypcall support from QEMU system mode 
emulation on TCG, I'd argue it's simply a matter of adding support in 
target/loongarch64. This would be attractive because it will enable easy 
development and testing of hypervisor software with QEMU -- both locally 
and in CI.

> Extioi virtualization extension will be added later, cpucfg can be 
> used to get extioi features. It is unlikely that extioi driver depends 
> on PARA_VIRT macro if hypercall is used to get features.
And the EXTIOI feature too isn't something usable from unprivileged 
code, so I don't think it will affect the conclusions above.

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/


