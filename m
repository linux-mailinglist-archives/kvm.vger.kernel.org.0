Return-Path: <kvm+bounces-40611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 832F7A58E3F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97ECD16B703
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EBF4223702;
	Mon, 10 Mar 2025 08:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sx1ZGG5g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9277E223311
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741595725; cv=none; b=gJrz8DliYNYND19w++7CrAgXGP20H/T92Cv7Zj+rSo5+HKONzqccAMIRQROK4RF9rQr8JLvqZp3S92jsboyGcGY2w7kNUCo4fO9lBlvA7oH+F/Mhn+dmtOY80x1oHBly8yAXeottNsYJE5G6p6PakwhYBAxccRF/Ygrxt8Nnb9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741595725; c=relaxed/simple;
	bh=WvaRBSfjpLJYvNbW0blQypGRf7xjue3S2PyQ/eWidkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V/F7c/RF6Xp/boe6z7NoPZb3t69rYsiptEOwiiH59nelTMgadrGiFU7U2Q6Jd8oCyfWVb67L3BEJgzPgrPvKMqczuaukudPUcw/fFNcDy52SCxCWgB8f1WJv6dZQy0X7nl26UWuWCw7hBvoY6i99v10qtdAASedoo9J060sgi0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sx1ZGG5g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741595722;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=daC4BU5S0mC+i0VzydxElRDB4WtBtTcNIF2KtY/I+mA=;
	b=Sx1ZGG5gDZb5G8ZRvxFs5VARm6OKBgF+wWA8xxyZWx79QcBtUga2SnH2c5ELTFz7cnnwpi
	I+xp6jRQTcfCJfInu91buBELNKjHg5U4UtmVZ1A+f3jrJxZIVSmu4APVUwE7kCvflHHxDc
	JtK99y8YN+2AZvfx9ovY9POdwu4ACXY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-TdM0J-C9Pf6OHn-T8O1trw-1; Mon, 10 Mar 2025 04:35:20 -0400
X-MC-Unique: TdM0J-C9Pf6OHn-T8O1trw-1
X-Mimecast-MFC-AGG-ID: TdM0J-C9Pf6OHn-T8O1trw_1741595719
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3912d5f6689so2433149f8f.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 01:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741595719; x=1742200519;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=daC4BU5S0mC+i0VzydxElRDB4WtBtTcNIF2KtY/I+mA=;
        b=WOG/gCIL+uQ5+y29tb9mmzaJcVofyFyqp3zHLfYkJCKSlKrWfrG8GwFD0vdAKv3Qb1
         DWSexhQV+9aS/R/pAjkCzA6MURheZFgSn0EJp39trbrtzr7ZkztbX4Ud02QdcJWhA9ki
         5BQFJIg5kcQiHUQHIa6IeygUVO4OGDBCod7GwP+jdGGdB0/W0ksYrS+2DHMMUMzIbL6Q
         3d0xd3xHhI2O6GIPy43hLQTa7tID20eErJG62leEkvEjo8Ri3OmOaEoAKZYCpPQDqLRi
         tcPeKLMHzIW+X/YkSaPaN8ncQLrAiwgvUUzC+i9CfSSIP1J3ovHtSfOpydNOFShgbqRs
         FhyA==
X-Forwarded-Encrypted: i=1; AJvYcCVMK6VMA5OjZtnpaV1/EmOHQcNVFV1lV95rxlQ+YVX5KDSYFbBTiQRPitvdc2aS6tfxF1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YynYSLyaxFZjETJ749FCbSm4ud8RQOS3F6b8Vr5+GTy+Sg1fQAG
	wr/8ZCOxhV9rGvvmdjd/WBQ+aWBLp7o4Rt/sgpsFgXr+ouDvVb4mALuTmRZR5Jky1WXgKW7F6re
	baxJ/JNMzgQm1A6HHfx6dCC2rBTAeDosNU6g5RMm6TLk3y7rqnw==
X-Gm-Gg: ASbGncua9KAA555+mcHnrvbzChDd1qfnXYe99uEeyd/IKmetVo3F5/U12H+Iu3I0mur
	+XBR1M2QXOzCzdpxgghjaS0gxvqBH/hdITbLWOa6gqKg5dAayYyx9bBOsRYSKEplidEGquNr+Rp
	e4MjsJS46BdOcrxhnUwyNMOgyfZCwakhC4JxW+NZOmda05L93Wtsi9T0v/ZF8aJVDPY8d4a3LAQ
	jfOCH+A6Y5lGmjvt0/2AE5rijdNPWMmKjAPb1/42bpKBKXPnohSf5a4Ip+Xxmvdx6+QM0MEJnTw
	lyTlCsSEjXJErjo9WLuNGdqrk8yGH4EIUgON5Xh9J9Me1I3bURa92//ePaMul7k=
X-Received: by 2002:adf:8b1d:0:b0:391:1652:f0bf with SMTP id ffacd0b85a97d-39132d8dc66mr6182053f8f.33.1741595719550;
        Mon, 10 Mar 2025 01:35:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZyunp2JiW/VAYGxEAGq3xNyc98fyx68X0URgkyxZeEIJwmAoKmRZHq0cEsAUn2egUeBreWQ==
X-Received: by 2002:adf:8b1d:0:b0:391:1652:f0bf with SMTP id ffacd0b85a97d-39132d8dc66mr6182028f8f.33.1741595719133;
        Mon, 10 Mar 2025 01:35:19 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c019557sm14552470f8f.50.2025.03.10.01.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 01:35:18 -0700 (PDT)
Message-ID: <b2e6da22-28a5-4430-8e97-851320b38f0e@redhat.com>
Date: Mon, 10 Mar 2025 09:35:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 08/21] system/kvm: Expose
 kvm_irqchip_[add,remove]_change_notifier()
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-9-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-9-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
> Currently kvm_irqchip_add_irqfd_notifier() and
> kvm_irqchip_remove_irqfd_notifier() are only declared on
> target specific code. There is not particular reason to,
> as their prototypes don't use anything target related.
>
> Move their declaration with common prototypes, otherwise
> the next commit would trigger:
>
>   hw/vfio/pci.c: In function ‘vfio_realize’:
>   hw/vfio/pci.c:3178:9: error: implicit declaration of function ‘kvm_irqchip_add_change_notifier’
>    3178 |         kvm_irqchip_add_change_notifier(&vdev->irqchip_change_notifier);
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |         kvm_irqchip_add_irqfd_notifier
>   hw/vfio/pci.c:3236:9: error: implicit declaration of function ‘kvm_irqchip_remove_change_notifier’
>    3236 |         kvm_irqchip_remove_change_notifier(&vdev->irqchip_change_notifier);
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |         kvm_irqchip_remove_irqfd_notifier
>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  include/system/kvm.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/system/kvm.h b/include/system/kvm.h
> index ab17c09a551..75673fb794e 100644
> --- a/include/system/kvm.h
> +++ b/include/system/kvm.h
> @@ -412,10 +412,6 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg);
>  
>  void kvm_irqchip_add_irq_route(KVMState *s, int gsi, int irqchip, int pin);
>  
> -void kvm_irqchip_add_change_notifier(Notifier *n);
> -void kvm_irqchip_remove_change_notifier(Notifier *n);
> -void kvm_irqchip_change_notify(void);
> -
>  struct kvm_guest_debug;
>  struct kvm_debug_exit_arch;
>  
> @@ -517,6 +513,10 @@ void kvm_irqchip_release_virq(KVMState *s, int virq);
>  void kvm_add_routing_entry(KVMState *s,
>                             struct kvm_irq_routing_entry *entry);
>  
> +void kvm_irqchip_add_change_notifier(Notifier *n);
> +void kvm_irqchip_remove_change_notifier(Notifier *n);
> +void kvm_irqchip_change_notify(void);
> +
>  int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
>                                         EventNotifier *rn, int virq);
>  int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,


