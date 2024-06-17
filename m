Return-Path: <kvm+bounces-19763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F2F790A86E
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 10:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C6141F21C27
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 08:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29B1190484;
	Mon, 17 Jun 2024 08:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="m2OAOiqN"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EEE17F5;
	Mon, 17 Jun 2024 08:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718613090; cv=none; b=qiwwFhxCMNByhdB8tPMsLoF2BTNhe+vH0TeDERrDXrzTawP5Tnv+iOnUUt1Aq6FIJnmMFfKDk6Q4RzIDd3M9o5i534EC3g2byRkTFvdmj3uOpcoqJ7pEBuyk2BPwIG3Hv5di8C6VS1aBNVk9vP7ooRjtM9rax2Eu2hppwOXqbMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718613090; c=relaxed/simple;
	bh=fo8+q6y7vp83SD91IViTvJuTuFWMepK+ZtVvClCI+rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7YAjG4pnm6nuJ3gzY9vHwmpxxU01RHY9MKNguEO1FbVoOvX39gU12X/SloZa6vKJUrg61x6eZcT5pa2wcyAl6d4eAIjGyOnLBzfek1oVIrFYlPbIyLGE74UrX/vNNhaVfIlyklYXWjQSZJ4yefskqCoW11UJfQglS5j7BUXQ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=m2OAOiqN; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net [IPv6:2a02:6b8:c12:5596:0:640:c97:0])
	by forwardcorp1c.mail.yandex.net (Yandex) with ESMTPS id 2694F60C06;
	Mon, 17 Jun 2024 11:29:26 +0300 (MSK)
Received: from [IPV6:2a02:6b8:0:419:5239:4476:3612:5752] (unknown [2a02:6b8:0:419:5239:4476:3612:5752])
	by mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PTCqgn0IgGk0-EX9goApY;
	Mon, 17 Jun 2024 11:29:25 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1718612965;
	bh=d/UcAgfsknxBwZtrewP/zkDl2+waM35lFvwj9tC5SOs=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=m2OAOiqNdzlYnheAjY5GXMwmW/SfS+3pdvTf8JpyW8V/01YorAj/HU+nzLOt9bS4p
	 pdUGXz8kknUANCtdq63iryBU9hEhUEmVxVg5RSe9kHT4uBKhW6Wp2yAa+BvTsqzItR
	 xxgkoHkK4kAttlORRrybT3894lcf2My5dfKfb3nM=
Authentication-Results: mail-nwsmtp-smtp-corp-main-26.myt.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <a8b5ec32-ffac-496c-9813-23b57e2ca673@yandex-team.ru>
Date: Mon, 17 Jun 2024 11:29:24 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm_host: bump KVM_MAX_IRQ_ROUTE to 128k
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
References: <20240321082442.195631-1-d-tatianin@yandex-team.ru>
Content-Language: en-US
From: Daniil Tatianin <d-tatianin@yandex-team.ru>
In-Reply-To: <20240321082442.195631-1-d-tatianin@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Ping :)

Is anyone interested in this change?
Our internal testing has shown no problems with this, so I think it 
should be fine.

Thanks!

On 3/21/24 11:24 AM, Daniil Tatianin wrote:
> We would like to be able to create large VMs (up to 224 vCPUs atm) with
> up to 128 virtio-net cards, where each card needs a TX+RX queue per vCPU
> for optimal performance (as well as config & control interrupts per
> card). Adding in extra virtio-blk controllers with a queue per vCPU (up
> to 192 disks) yields a total of about ~100k IRQ routes, rounded up to
> 128k for extra headroom and flexibility.
>
> The current limit of 4096 was set in 2018 and is too low for modern
> demands. It also seems to be there for no good reason as routes are
> allocated lazily by the kernel anyway (depending on the largest GSI
> requested by the VM).
>
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
>   include/linux/kvm_host.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 48f31dcd318a..10a141add2a8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2093,7 +2093,7 @@ static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
>   
>   #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
>   
> -#define KVM_MAX_IRQ_ROUTES 4096 /* might need extension/rework in the future */
> +#define KVM_MAX_IRQ_ROUTES 131072 /* might need extension/rework in the future */
>   
>   bool kvm_arch_can_set_irq_routing(struct kvm *kvm);
>   int kvm_set_irq_routing(struct kvm *kvm,

