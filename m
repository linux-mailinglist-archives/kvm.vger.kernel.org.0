Return-Path: <kvm+bounces-40478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 806B4A57C6D
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 18:39:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C69E0188EF44
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 17:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025681E51F9;
	Sat,  8 Mar 2025 17:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJX9GENf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A222A8C1
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 17:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741455560; cv=none; b=Yn5Wb/p4GnT5p5ImBUvQotnzm4Vc+XeDwm/Mg5/DGohrmD6wF1Ih6N988k0a0zkQo+WknNMFkocMhZg998HrM8KmUD87YLAmDBe5XtLbAh7J4BgkO+u1ERk0YSUbxHSAra5E2YEN8O7gz1BvFblLjRTDPHFamDw1RkQ2vsvJuJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741455560; c=relaxed/simple;
	bh=VQnU7dJzBnUZRf28uckKpUK7phY+V7ZaZK+0dicn8A8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BCExZ69nZzdyBNNYbQUkeDF4Iqqpf6inEgyau7rod9CCnqbyqVuwjW7tJ1UZzWj+RoQm4gLwgjFogoRnUeY5KkSV12c9iZWhpDeKMeeX7YrQp3Qj8rTXc74vOQBzo86jdVC8+gbYTvQApL4PmKnTSVFl5+tDWxB7YMTXEv5JZWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJX9GENf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741455556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w8YM9fPp4ts3fRlG+HIlsApkFk9YEsqNKUoPa57u2OE=;
	b=EJX9GENfYdwhycIW8Dd2ms4tXQvUBhoBcEdHr/rNv9sy68wChdJqfhuwEIrpBWNjJCvUnn
	cbGHcTSFbXI98oniVZpxlE548YQtJVitHb+K1nKxYRmaXIj4gcV0r783dXNK9Fn2BgQv+C
	Ro2kjhC/ncHCfxu6axvCf048IPKqS9I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-f3g93qE8OBO6oQa-mAUu5Q-1; Sat, 08 Mar 2025 12:39:15 -0500
X-MC-Unique: f3g93qE8OBO6oQa-mAUu5Q-1
X-Mimecast-MFC-AGG-ID: f3g93qE8OBO6oQa-mAUu5Q_1741455554
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4394c747c72so11185305e9.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 09:39:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741455554; x=1742060354;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8YM9fPp4ts3fRlG+HIlsApkFk9YEsqNKUoPa57u2OE=;
        b=BBTz0/VRJZT4KuzE6fzxsJrYC5IPvSfNhjv6NeCipIvL6CJK0caWhqu/X7WmUtLKNE
         xeg5F+afWBaLDO4FY1GZODxxWULXm0dfDIKlIDovPvMD8MO+JVb6AA2i0pLKHV4ijpqG
         bmxQgGfA8b0jEfRfFZcYyzGhxqmfZ9RdO2o8Q6AUwyiKIOGdTo8vM9zZxcorS5qDao1u
         gndUGNOZv7EIybTQWmKhN8wAU5iDkQSIqX14U06pqjO1w+F6kLhssb1LPZotcAxgz4zV
         ib2rSp6xTP6F1VU4pRwFH39EDaVKJDeZ4vd1cHL51aPvDhiPBpIMGmT1usywQiCaqMVw
         j3lA==
X-Forwarded-Encrypted: i=1; AJvYcCUCy2C42ZRrRaNKX1EXck+uol1pNCxP0GM0SuPlQWosq11Ik+QUF3ItK4L0pXdxlcPLbBA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9ctVmrnXHuNG5uNkcAERd/ajB0eRoB+nirU9EF7ETprRfCSTg
	gsEiaQ6XQwCMZUBl2Cix8gP52s41K6U8067hgVLcY8ofGAY5j+JCA141qZuCvqHjjMq9caVuUcQ
	TvX7g2hnmMO/XC/O8Ck5Lorvio6/J3BBDpOCOFj3NlqjrokwomA==
X-Gm-Gg: ASbGncv7b/2FvVq71lQxF9W/kPqEdkLPqvnW8pzFi//9fk4C61FeDWXsV/l2RLOg97B
	5L/ZbueJnd3wN3xgMSV1MAfP/tvOr1XHT1Ze+LwImpXvVUznUusXbkJy+xusmPl7Flx+zxAuTiV
	Q/7IMt8HzfOEN8RXEosjqnJZTUDoBOHVpVag8+b+fgEQOgV1xy7VrNA2B5DI73KgW90Wua8MMUG
	jPVlmn5tBNVyVn9QjpLdgU7pprLqEWO6t/VNmeVNrL/EVIme5uXkR1R7svPwgAqwEYnyZ0VZMyK
	HbbYa88pkJU0ikXvT/b47l6w+6M0QRuABe8ODAmScmY9D0Qp00vXZg==
X-Received: by 2002:a05:600c:4e8e:b0:43b:cc3c:60bc with SMTP id 5b1f17b1804b1-43c5a60ed21mr53156115e9.15.1741455554315;
        Sat, 08 Mar 2025 09:39:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF47QDhuxjyHftpNunfOjzBIRm6suf++FDxWASnPHa14C5l2dbw/7i8aUc7jhB9YLagZGfQwA==
X-Received: by 2002:a05:600c:4e8e:b0:43b:cc3c:60bc with SMTP id 5b1f17b1804b1-43c5a60ed21mr53155965e9.15.1741455553939;
        Sat, 08 Mar 2025 09:39:13 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ce3d5a0e2sm37253045e9.12.2025.03.08.09.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Mar 2025 09:39:13 -0800 (PST)
Message-ID: <a0531dac-2839-4aac-88f5-68abf3b2207b@redhat.com>
Date: Sat, 8 Mar 2025 18:39:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/14] hw/vfio/common: Include missing 'system/tcg.h'
 header
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, qemu-ppc@nongnu.org,
 Thomas Huth <thuth@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Zhenzhong Duan <zhenzhong.duan@intel.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Auger <eric.auger@redhat.com>, qemu-s390x@nongnu.org,
 Jason Herne <jjherne@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20250307180337.14811-1-philmd@linaro.org>
 <20250307180337.14811-2-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250307180337.14811-2-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 19:03, Philippe Mathieu-Daudé wrote:
> Always include necessary headers explicitly, to avoid
> when refactoring unrelated ones:
> 
>    hw/vfio/common.c:1176:45: error: implicit declaration of function ‘tcg_enabled’;
>     1176 |                                             tcg_enabled() ? DIRTY_CLIENTS_ALL :
>          |                                             ^~~~~~~~~~~
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   hw/vfio/common.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 7a4010ef4ee..b1596b6bf64 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -42,6 +42,7 @@
>   #include "migration/misc.h"
>   #include "migration/blocker.h"
>   #include "migration/qemu-file.h"
> +#include "system/tcg.h"
>   #include "system/tpm.h"
>   
>   VFIODeviceList vfio_device_list =


