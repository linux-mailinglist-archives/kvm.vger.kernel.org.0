Return-Path: <kvm+bounces-19858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D8690CBB3
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 14:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 650711C21E8F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 12:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFA413A3F6;
	Tue, 18 Jun 2024 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KBjBZZSp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EEA132492
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718713733; cv=none; b=NSKtq50gMgpAbNCLqVpoMmpKReBnu38zO2IuzCyYxG56vHOUgtGRHoEkA+686SJcALg2P0YuS1it+WTeV8kVLnIDxFyyOjL8B57K3eQFOli2NuLzfLIB/Wu+poDCqWJPZL6Nai2978Ws+u3kb209+2sjmrhuFxbYTL4lBE2lXwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718713733; c=relaxed/simple;
	bh=59k1eVPPNbUMHgUvagtmlcypZxF8T5i8OLolmJA2xfI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Erx7AFEDeHGKtY8ZSbx6c9mAradCH2YC79HSirWCcjo84BUaBWi4SUzC7zIO3atG/jCSZJwrKaiX0RBERY8xohyB43JvXtGpgby0/qYvNfZVdSt2Sj3LkwPCX0oaB9LO7ZPVItrO8iB/fMhtSYj6fQXgHUlmuaWw9HGuWPNOL5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KBjBZZSp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718713730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utFm1SB1+eNq6POAWEcWhhC7RWyydhXQ88o1CCnb7PM=;
	b=KBjBZZSpAfrXmmXOyCxW3nYXAoukddA7IrYHnNccO6SKj8GnF+NgItkNxzDHiFPDtqw76Y
	AZDp7yeLDnImWgCURCGcL+RG9ond6NPyYt6tVJTicgH7i7zZkQ0hKsExfJ1ke5FaxpYfh8
	DbWdbpUsY7XZFgydV9TvM0bqttW+6+E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-4atSgld-NUay-_qR2h-wMg-1; Tue, 18 Jun 2024 08:28:48 -0400
X-MC-Unique: 4atSgld-NUay-_qR2h-wMg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3625503233eso265556f8f.0
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 05:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718713727; x=1719318527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=utFm1SB1+eNq6POAWEcWhhC7RWyydhXQ88o1CCnb7PM=;
        b=wpKnxEKLded9uaChMLjYyyjeNNIvzk2R3O+2vKYtfHg8Q3MLAmQ+b2zAXWdagL4biN
         iP5NZI3fCTKPDIn3AnOIRvEygJOTSkOI50DmMoXlFOk0gfbad3Y//K6jZBz5YUDecCl3
         0rOfetEsHYo2Igz3xNzK47KipBj0xCyodXjFA6LBLmqz2iA6Y1pxotFvn3FaFmAN39Tw
         SXLG/ry8Ax4kImYY63mluO48CSO98ZNSCJyHReSJ6QsW31O2BrXrrUT8nZERweLUUwg6
         0pE/+E0UpjLyVNlceAq12TogzeuK4kmDygaNxfsV3AFARyGJ8B7axBF15caIuTiFt4hq
         Se6g==
X-Forwarded-Encrypted: i=1; AJvYcCUyqNRQFfjCkqdcpqCd7BcPgFIpevWXKVsVDvZ/XWRbF1UTHQmcjmzjpjCnumgOo1wrw/f9G2WjxZtvTrLcjgFOG3+p
X-Gm-Message-State: AOJu0Yz53Ew38P9WlEJoMOl4idaVaarjOn2q1lEMcYuOLXB9ByNjb7si
	imZDNvFUGuOdjSPAKJaiSVGxb9AEo77omP07tSxIP94NzOKWUV2jv6lUwASPJJwAX2hxhosz6jD
	InmYFeA5X8ggr+gkqXN/HxRcYOdRazuZVX2iHbdrvL3+5zCE+1A==
X-Received: by 2002:a5d:4412:0:b0:35f:105c:50dd with SMTP id ffacd0b85a97d-3609ea6155fmr2275332f8f.12.1718713727748;
        Tue, 18 Jun 2024 05:28:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsgRr1Yq8bIeFVs1TcoHGfRbVOTFjV7hrI8nHmrT2KhJ3GpaAJCryVzg/OrwKZri4CQIFYkg==
X-Received: by 2002:a5d:4412:0:b0:35f:105c:50dd with SMTP id ffacd0b85a97d-3609ea6155fmr2275319f8f.12.1718713727414;
        Tue, 18 Jun 2024 05:28:47 -0700 (PDT)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36075104b8bsm14062230f8f.105.2024.06.18.05.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 05:28:47 -0700 (PDT)
Date: Tue, 18 Jun 2024 14:28:46 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, yc-core@yandex-team.ru, Sean Christopherson
 <seanjc@google.com>
Subject: Re: [PATCH] kvm_host: bump KVM_MAX_IRQ_ROUTE to 128k
Message-ID: <20240618142846.4138b349@imammedo.users.ipa.redhat.com>
In-Reply-To: <20240321082442.195631-1-d-tatianin@yandex-team.ru>
References: <20240321082442.195631-1-d-tatianin@yandex-team.ru>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 21 Mar 2024 11:24:42 +0300
Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:

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

LGTM

Acked-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  include/linux/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 48f31dcd318a..10a141add2a8 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2093,7 +2093,7 @@ static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
>  
>  #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
>  
> -#define KVM_MAX_IRQ_ROUTES 4096 /* might need extension/rework in the future */
> +#define KVM_MAX_IRQ_ROUTES 131072 /* might need extension/rework in the future */
>  
>  bool kvm_arch_can_set_irq_routing(struct kvm *kvm);
>  int kvm_set_irq_routing(struct kvm *kvm,


