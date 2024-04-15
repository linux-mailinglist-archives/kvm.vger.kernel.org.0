Return-Path: <kvm+bounces-14622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7CB8A4843
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2A6FB21E82
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 06:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D9A208C1;
	Mon, 15 Apr 2024 06:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="kKgb/aOp"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA031C6B9;
	Mon, 15 Apr 2024 06:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713163103; cv=none; b=EL/kwx+eTTh/rjUpDscgD7BBVHyEG4vdwn2t3ePFpldu4P9rwrt4L8bnIp5Qx7CAoe6o6Yo19tweH7DH1NR8mcU1jfh4rlqA1WZW0WvYxaa0PdNhNhLUhhWiL7RJKsOROAFmygV+wumFAHWYVFtmVR8P451xNjXOmdfJLtPGCz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713163103; c=relaxed/simple;
	bh=ke4GtrwiUaNd6EoLUT2zw42GFR+boZhwDst+k70ryFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNeAdAkxWzdDo3DSK5Xtxe6mogwAWeio2PTduVzVx+iyg+322eOeLcXsH+v1xVKbAKP+rLy4KTvRMybspdGMuIsoULNXtGbnrofLjPkb00A11cf4mCEj98TceZqzKI/SWJXJc5ecMd9V8fR0kFFqmLLtTYoHSVQr5kJzsJ+YoeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=kKgb/aOp; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:220a:0:640:7faf:0])
	by forwardcorp1c.mail.yandex.net (Yandex) with ESMTPS id BF6B860C5A;
	Mon, 15 Apr 2024 09:36:52 +0300 (MSK)
Received: from [IPV6:2a02:6b8:b081:b5ae::1:26] (unknown [2a02:6b8:b081:b5ae::1:26])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id paYKek1IaKo0-iypVP8rP;
	Mon, 15 Apr 2024 09:36:51 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1713163012;
	bh=ywwE6DRwLLT1SpVsnnbzNuGwJVoyApx9UB8DPg8vkco=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=kKgb/aOpknGh9USFJPoBvE7mZ7kudaNL2AT6eeDpofcnZ9suDthjcSDK6eqCA8wmY
	 jtU5OyAJf5RvFFh2GNfheqOEoNQOdHLSKXJ/0X7GUdhjaC55yGxYN48DkSDO9q7J07
	 b5kYaPZVRnbiHXCgkxsOLO5NticjCbVSqcvBrH3k=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <fbf1771d-d97c-488b-96ee-422d64016615@yandex-team.ru>
Date: Mon, 15 Apr 2024 09:36:51 +0300
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

ping :)

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

