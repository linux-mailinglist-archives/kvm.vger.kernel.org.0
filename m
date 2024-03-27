Return-Path: <kvm+bounces-12884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A53088EB8D
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3188629EE6D
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0000514D285;
	Wed, 27 Mar 2024 16:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="FxXOZ+4m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC0C130AF0
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 16:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711557960; cv=none; b=i7t6zfGZzRQuq10elOW3rqt2rYtYgKhKxUqbAhT1X1ID3RzIrwxkTcoWOguYj82yH8ZXDVXG7v7/TXjvE5OA0VIq+ESod+J8PZOS6QR99KkpkQfCHnjtCtWRhcacx0WNxBWlIHgXhJdBEVFySXkJo4xmuKZH7QGvFQrehW2JLKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711557960; c=relaxed/simple;
	bh=K4pQ1jDhQThaxY1SDo7Uj4A6/0ATdvhq7v+igeYTNJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kW4hIuxOqDjBeja+UxalW0vvgX6nvsR/u6wqAJoWiNqvDjLiKly/0ud9o4GdGNHUTYQSgwCQfX347zyX/W4vMc7OlZsnPhQgTIzMnpFnol37BCwLBTkfGS5Pr9H+YMCrkOzeKptwHWufMQUoIsMPKIiCv0dMwz3UDWqIgKUNq/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=FxXOZ+4m; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-33ed7ef0ae8so4948872f8f.0
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 09:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1711557956; x=1712162756; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zBErRmkltSguH2d0/UJYPB7aHlGXWYjo+/5oLZJOopI=;
        b=FxXOZ+4meBTMWUllRrZLe6/4eqDW3VgMABq0MuG+EsPefIDoxiiUWdI5/SoPuc00zZ
         0VOS9MfiRnPuRpEeyYr1ROA+08AmVS8Ed73MiEwFdWd7PRN9yj8PAIarabLZlPX6l+Hn
         pJ3yXnoj3SPiYQ94KRRfbRhEGX5mZIFogaqBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711557956; x=1712162756;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBErRmkltSguH2d0/UJYPB7aHlGXWYjo+/5oLZJOopI=;
        b=Fg0jNAuyWleqFWAKS2AUtS8Rwx4GX0cVsksXVU/eiCxK/L2LEi0hxlYQAs8Ivpq/sw
         34h2dzFrcqxBbfIDH910tNp00XABYWrrN7TvODQgJYZJapCDKyl6pdBV8T6POxNRx8Fk
         /edsnKWjbt5S4jYWQ9M5vQhqeFmqq5KAbXWS5+sLTfmmk0Q3/uzcQ+yiXI5cciAvvMzh
         YBuH1cSVvQ3mqzZISt4Gn5P/qMkPrsp0eAu5KZsU3iFW+Ksu3sp/TN2HnKOJti1NciNI
         EVnhPH73ZH5jmKHHZYO2xNjsTEWyc8FL1o+teNAKcXKfcCQ6YD5PwY43LRzkip/aMXpB
         9aLg==
X-Forwarded-Encrypted: i=1; AJvYcCVdHxTAnyNUgEXfjYyVkmjy2OntkkOaVnvnSeNTJYtOTqI6Jl9CteE1ZeO9MpLAxcR0YROd6Mbsu3JmPCvWudERud6c
X-Gm-Message-State: AOJu0Yx5Lo6duLoLcP04tQhaHKFn44TaVZ0itvQqtKvR3+jdVPKMqcmH
	G4wK82gbbol+KK/I5kGlrxqEIFBUzrq/CQ8c+KZ2n5ZiAgTgC5zI1p8pj6JIBZ4=
X-Google-Smtp-Source: AGHT+IGpIy3vGf4ZXnW5ibtGUcB1DXYHc9NeWjaOzQq8JTFfd0ipLrHkEfSGQkvsU8UA2GxqISwyxw==
X-Received: by 2002:a05:6000:92c:b0:342:86e9:b3c7 with SMTP id cx12-20020a056000092c00b0034286e9b3c7mr76883wrb.37.1711557956127;
        Wed, 27 Mar 2024 09:45:56 -0700 (PDT)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id en7-20020a056000420700b0034174875850sm14015642wrb.70.2024.03.27.09.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 09:45:55 -0700 (PDT)
Date: Wed, 27 Mar 2024 16:45:54 +0000
From: Anthony PERARD <anthony.perard@cloud.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: David Woodhouse <dwmw@amazon.co.uk>, qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
	kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>
Subject: Re: [RFC PATCH-for-9.0 v2 13/19] hw/xen: Remove use of
 'target_ulong' in handle_ioreq()
Message-ID: <3a2da257-87f7-4d3f-9ef2-8450bc7b2742@perard>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-14-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231114143816.71079-14-philmd@linaro.org>

On Tue, Nov 14, 2023 at 03:38:09PM +0100, Philippe Mathieu-Daudé wrote:
> Per commit f17068c1c7 ("xen-hvm: reorganize xen-hvm and move common
> function to xen-hvm-common"), handle_ioreq() is expected to be
> target-agnostic. However it uses 'target_ulong', which is a target
> specific definition.
> 
> Per xen/include/public/hvm/ioreq.h header:
> 
>   struct ioreq {
>     uint64_t addr;          /* physical address */
>     uint64_t data;          /* data (or paddr of data) */
>     uint32_t count;         /* for rep prefixes */
>     uint32_t size;          /* size in bytes */
>     uint32_t vp_eport;      /* evtchn for notifications to/from device model */
>     uint16_t _pad0;
>     uint8_t state:4;
>     uint8_t data_is_ptr:1;  /* if 1, data above is the guest paddr
>                              * of the real data to use. */
>     uint8_t dir:1;          /* 1=read, 0=write */
>     uint8_t df:1;
>     uint8_t _pad1:1;
>     uint8_t type;           /* I/O type */
>   };
>   typedef struct ioreq ioreq_t;
> 
> If 'data' is not a pointer, it is a u64.
> 
> - In PIO / VMWARE_PORT modes, only 32-bit are used.
> 
> - In MMIO COPY mode, memory is accessed by chunks of 64-bit

Looks like it could also be 8, 16, or 32 as well, depending on
req->size.

> - In PCI_CONFIG mode, access is u8 or u16 or u32.
> 
> - None of TIMEOFFSET / INVALIDATE use 'req'.
> 
> - Fallback is only used in x86 for VMWARE_PORT.
> 
> Masking the upper bits of 'data' to keep 'req->size' low bits
> is irrelevant of the target word size. Remove the word size
> check and always extract the relevant bits.

When building QEMU for Xen, we tend to build the target "i386-softmmu",
which looks like to have target_ulong == uint32_t. So the `data`
clamping would only apply to size 8 and 16. The clamping with
target_ulong was introduce long time ago, here:
https://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=b4a663b87df3954557434a2d31bff7f6b2706ec1
and they were more IOREQ types.
So my guess is it isn't relevant anymore, but extending the clamping to
32-bits request should be fine, when using qemu-system-i386 that is, as
it is already be done if one use qemu-system-x86_64.

So I think the patch is fine, and the tests I've ran so far worked fine.

> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Reviewed-by: Anthony PERARD <anthony.perard@citrix.com>

Thanks,

-- 
Anthony PERARD

