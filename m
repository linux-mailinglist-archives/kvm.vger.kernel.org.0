Return-Path: <kvm+bounces-40483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C00CDA57C7B
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 18:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AA69188FC57
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 17:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEF61DE4E7;
	Sat,  8 Mar 2025 17:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YLQZGxo6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C89382
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 17:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741455999; cv=none; b=ZyAUHWUYj0zVu5xm+11BwcYMrzT0YAK3XBHK1rKivZpMiT1mmV2lH0cuqnjamwIN3/tfLSZMa66HaRhHFTUlH5Y2Ckfqe8BRe24KIXfiWI9+gB6rRMhjPIzJCapWRFg4iO0tjXaNvxb6CVIEqE69trGPBOW5jaxJms8RTIJ8Xo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741455999; c=relaxed/simple;
	bh=PYEnb38HiakEYtg74oyO3vxM2z63FaH5GHZYTi7pIeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uLGlBk24xIMvncxpInF0LDSmkJJFRzN2LVc2R+/Z5TxBvO+LFSsAtni5/FV24+Eu+pCIEnBmCIU2XxjRAvkCJeb2ZEk8sK4x+NpCTAS1Bohzq5Rosdyacj/pqXJezYY1ZLACeiLBmGQYVOuP6YE3/NxBjZ/gWHtlxSb9hQsKT9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YLQZGxo6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741455996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JFiuNU+eFFJHRrhW3V5tuq9L5rOEUcb+ufPXNixlpbQ=;
	b=YLQZGxo60vW+5Sd3uONEsFGMmDtVqHgfKww8jIOVXneDsFXX7rvdZgevSU0cb1L6p7XXwr
	7KrjVwp2/FEdYbdvVwNJam24RNHRqBoGl1rbZPNYbpZCUsjqTLDfL9TrjZ4o5JlSg9SR59
	XLeUe93twVgcRzwPfYiLP8gkbYCy6c0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-85Fm460rP4m6kC5yOrsGTw-1; Sat, 08 Mar 2025 12:46:35 -0500
X-MC-Unique: 85Fm460rP4m6kC5yOrsGTw-1
X-Mimecast-MFC-AGG-ID: 85Fm460rP4m6kC5yOrsGTw_1741455994
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43bbbb00891so11790575e9.1
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 09:46:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741455994; x=1742060794;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JFiuNU+eFFJHRrhW3V5tuq9L5rOEUcb+ufPXNixlpbQ=;
        b=P34ynS3kQ4gV+nuMnlw2qSsFGigLltCPNyuSPmc0q9T1/mQMDUB8hRWZaNXZZX/gj0
         fkrqz0hdu+o+J8MHVTRwYO+iKFXHRh9EQOMlIGbs4U+u27IXtRr4qT4wTh9mEz2yrmJl
         334HTVNC/TQsnFOuFgdYV7AyAZ//49fzOfGPu5h4R+wxdmhWeC7aQxty7DAv/4GOR6am
         NhoP4Lwm7FL/ZpwPiHrJOGao/IBBD6Nk4sSYUBjDsPtSSGvEzMc5Ww1RQSm787WeVk3a
         KJSwQgq2Prn7q08Xb/x2GtWn7su9UTE9v6FWhyRuRbTGVVuIj24y4S+XdtN7e5hKtcRn
         qMjA==
X-Forwarded-Encrypted: i=1; AJvYcCXWt1Ljdas9zhEQuzA9A2X90DxQ4mryaCXFWPmvtvSXp+OoSey6Pd1ypL1GLrtxOtPkysU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZO8nkJv821AlBKqjNcJDQzjOzRC2Zte4zPssM67jNVo3rIB4s
	TwpZLu52OXN6E9B+DbnwcenVc7B9fB8HND7Gr0p1f1KygW9l8Oy/hKKxUdT2cc8laNUAed+lh8F
	zr/uCN2Gk4RCnbEyA2l7TKv4ZHWJVehVOMaDApxhIBlevMFDYCg==
X-Gm-Gg: ASbGncuZVXQuQV0znEu0vNUWfhv/7yx60f9taq/DAMab3iO0LdCjenpvxl20oaZC4QZ
	QjQElxw2wmJ85h9dJ5W53fCmhIp9jm8q4SdeJZPkhqmWMHpzZzO6LfiXxEEcsqrkEPaINH9ZrdJ
	YUa7CV3f3XwaazhWZgSAfM5U0/qUvOklUtPb1w8ZXf9tzj+dMSo7m/WOT123aGAhpdoMdk6MfTx
	39eawco2xib6WBVf6qhdf/U4khmeo4Jz7adKv5zWgJuwYB6fqDVrThnU4lMvQuwk4oODHhAJhsi
	b60MH03xORLD0uEf74WOC/5xLxU+qA3WIsobKAI3ZppV/hoBjrWycg==
X-Received: by 2002:a05:600c:4f8b:b0:43b:d12a:40e1 with SMTP id 5b1f17b1804b1-43c5a611738mr51923835e9.18.1741455994260;
        Sat, 08 Mar 2025 09:46:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXDdIfMBPv93iu+e/Gkd6YEnybDD7pp3B6hlmvFzVaN+tQm4DgzwwuQp9HBP2ikgS2EWK0JQ==
X-Received: by 2002:a05:600c:4f8b:b0:43b:d12a:40e1 with SMTP id 5b1f17b1804b1-43c5a611738mr51923515e9.18.1741455993852;
        Sat, 08 Mar 2025 09:46:33 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e2f10sm9437703f8f.65.2025.03.08.09.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Mar 2025 09:46:32 -0800 (PST)
Message-ID: <870c603c-ead4-4100-a671-0e9c28ab3712@redhat.com>
Date: Sat, 8 Mar 2025 18:46:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/14] hw/vfio: Compile display.c once
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
 <20250307180337.14811-8-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250307180337.14811-8-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 19:03, Philippe Mathieu-Daudé wrote:
> display.c doesn't rely on target specific definitions,
> move it to system_ss[] to build it once.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   hw/vfio/meson.build | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index fea6dbe88cd..96e342aa8cb 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -5,7 +5,6 @@ vfio_ss.add(files(
>   ))
>   vfio_ss.add(when: 'CONFIG_PSERIES', if_true: files('spapr.c'))
>   vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
> -  'display.c',
>     'pci-quirks.c',
>     'pci.c',
>   ))
> @@ -28,3 +27,6 @@ system_ss.add(when: 'CONFIG_VFIO', if_true: files(
>   system_ss.add(when: ['CONFIG_VFIO', 'CONFIG_IOMMUFD'], if_true: files(
>     'iommufd.c',
>   ))
> +system_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
> +  'display.c',
> +))


