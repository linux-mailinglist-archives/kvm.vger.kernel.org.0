Return-Path: <kvm+bounces-59397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9A3BB3437
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10A2D19C686C
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2BB2FBE12;
	Thu,  2 Oct 2025 08:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iRdOilsU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614B92FBE09
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759393877; cv=none; b=BUYWh7cZJ1o11UYTSDrY0tsK2UDN4aeUw0cj3suonzZTtOc2jmTywxUGneqGOw1iy1m9W/VVwBDOR9a+Bnf3AzwxT1h8iIT1uPx2nEyPIaZCCM2A9inlhotnZElezGAY2rVxHhQPmnfMcErnda+ow+OrOjH9bQAgoLxxQT39Jm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759393877; c=relaxed/simple;
	bh=LlCdaygwrUvzX2YZIhjAX6Rm7I2mOy8eQoO6gOJXTUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LSmHPsQ+Hai18dt+5q7ikxcnBL86aelSJeQatIT1lvlIb8oxT40rNE8CjSrXm4IgiJm+n3bsYRiF8gdjVD7f5T68wrKl2TdvkJVnLdP2hjKIX7VJs5QB1Ws1yBOLs5n7Egnz5/shTvZR12nxyyr8p09yAfGWE/ZsVVbSgfLIeZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iRdOilsU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759393872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CiQeq7LBJMi00PqpAzdN+6dUnE4tov5qZ2FmmHPUbAI=;
	b=iRdOilsUOvX8Y/OjlTiB6ddk4OONriPWFKGUiRAhMf0JfpDye9YaidwcN3A7zXU+HH+DdV
	dpnwQZs3xGfb5cxujJNV60QaaFpmMgZle7tjZTPemClfbczsscn2PjD7NW6p1sWtmS0jpF
	OvDKdZWPOsgTv7kqYPeK5GdneNJis5M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-U7xk16slMC2sfM_sF0MbQw-1; Thu, 02 Oct 2025 04:31:06 -0400
X-MC-Unique: U7xk16slMC2sfM_sF0MbQw-1
X-Mimecast-MFC-AGG-ID: U7xk16slMC2sfM_sF0MbQw_1759393864
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee10a24246so479965f8f.3
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759393864; x=1759998664;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CiQeq7LBJMi00PqpAzdN+6dUnE4tov5qZ2FmmHPUbAI=;
        b=Vez8j2zZPr0K+d1LcWYVOpGShZdGRE1WyuLQXDEbdBsTvOTpzUyZ+2XK9gURhR7bEi
         R5RFcjhA2FAcmuzcMjss9fubFqs2kiwpgEONEnmMdEs/9PtKLoA/kwgs1ZQk09HjYq7I
         z9SopjYGWagci22GMYsFsdczzuhV8PeN07R67lfxeBbfP9iujeNpqOkA/KeKg6jDvThW
         OQSB1Xs5Ky7623zwsmBkpQvBDxap6gl9MvObJSrbpag4l5bd+j5iOFvmcNQ8skPZOGBG
         h+hUZ5RDpGl15T/BK4VvEriPSKplXZnPB/T6H4LNWIo1YejQ8t9udJ3WiY1poTr/Z2SY
         EMeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWd2PtnlRNYUhZLOAFnAvi5ZrLXQ24fOtxB9CSsov/DQq5HZe68Uxwg2WUE1kyxpD/0JK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNVOKWZyXOX1ivm1H/HlA0eTspLF5srJqFaNRVpueS95VGTkP2
	Y9XrrBoBblbORihJFfEAED0eTDwyQpf9SSZOQZWPEtc6okYliGUfAM0nkLuV3IBoZrSa91tvVxF
	XKWzzbjxdcfXeD8O+aJQD4FLay1y5v3J9zm8jKqlIEUJkydgheFoC0Q==
X-Gm-Gg: ASbGncugzUkFxEQ0YXoB4U/hINFPufXEZ+qHPkl1f1PWl2CMfe7OU2Vv9TG8RmwtAwZ
	76MRR2e+OpS0GLQU623rlfd4mXupCSa4Us/IO5tlYVgc3qM79h0AhPAgzGPjTM5hgkJRl0gcPTQ
	hyg1WmjzJkEy5H9ZSPKa92fDUnKmaKMqARoWhQGdY12X+p301qpmU7sGeJ8QG9CmS8FvhXKCDXV
	Gk5d09UcvoLKsnApIv75JEsj+mEToaiwmF0pb3lwpVfMa/AF9PHaPKxhOsiNoeBS5lGk5z9RpsA
	U/0l0oXutSWkfoJjhMRi1q7KvORaRcq7MOlA7/5RVtghs19cWkxfZh38/28xs2Gy1tNREKxP9k+
	tlt6hpOqB
X-Received: by 2002:a05:6000:2890:b0:413:473f:5515 with SMTP id ffacd0b85a97d-4255781b8c5mr4654232f8f.48.1759393864264;
        Thu, 02 Oct 2025 01:31:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4ucZ1fOA/YMiqmosZzRgjQwRAEjyV4n8kJLFGDWQ8ZgUtW3qOXBDy4pMckTJyp2VPL7ndHA==
X-Received: by 2002:a05:6000:2890:b0:413:473f:5515 with SMTP id ffacd0b85a97d-4255781b8c5mr4654214f8f.48.1759393863857;
        Thu, 02 Oct 2025 01:31:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f45e9sm2646658f8f.51.2025.10.02.01.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 01:31:03 -0700 (PDT)
Message-ID: <0b42d6a6-0b9d-478a-81d7-9e8203b02b8a@redhat.com>
Date: Thu, 2 Oct 2025 10:31:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/18] hw/vfio/listener: Include missing
 'exec/target_page.h' header
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Jagannathan Raman <jag.raman@oracle.com>, qemu-ppc@nongnu.org,
 Ilya Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Jason Herne <jjherne@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 kvm@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Fabiano Rosas <farosas@suse.de>,
 Eric Farman <farman@linux.ibm.com>, qemu-arm@nongnu.org,
 qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>
References: <20251001175448.18933-1-philmd@linaro.org>
 <20251001175448.18933-5-philmd@linaro.org>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Language: en-US, fr
Autocrypt: addr=clg@redhat.com; keydata=
 xsFNBFu8o3UBEADP+oJVJaWm5vzZa/iLgpBAuzxSmNYhURZH+guITvSySk30YWfLYGBWQgeo
 8NzNXBY3cH7JX3/a0jzmhDc0U61qFxVgrPqs1PQOjp7yRSFuDAnjtRqNvWkvlnRWLFq4+U5t
 yzYe4SFMjFb6Oc0xkQmaK2flmiJNnnxPttYwKBPd98WfXMmjwAv7QfwW+OL3VlTPADgzkcqj
 53bfZ4VblAQrq6Ctbtu7JuUGAxSIL3XqeQlAwwLTfFGrmpY7MroE7n9Rl+hy/kuIrb/TO8n0
 ZxYXvvhT7OmRKvbYuc5Jze6o7op/bJHlufY+AquYQ4dPxjPPVUT/DLiUYJ3oVBWFYNbzfOrV
 RxEwNuRbycttMiZWxgflsQoHF06q/2l4ttS3zsV4TDZudMq0TbCH/uJFPFsbHUN91qwwaN/+
 gy1j7o6aWMz+Ib3O9dK2M/j/O/Ube95mdCqN4N/uSnDlca3YDEWrV9jO1mUS/ndOkjxa34ia
 70FjwiSQAsyIwqbRO3CGmiOJqDa9qNvd2TJgAaS2WCw/TlBALjVQ7AyoPEoBPj31K74Wc4GS
 Rm+FSch32ei61yFu6ACdZ12i5Edt+To+hkElzjt6db/UgRUeKfzlMB7PodK7o8NBD8outJGS
 tsL2GRX24QvvBuusJdMiLGpNz3uqyqwzC5w0Fd34E6G94806fwARAQABzSJDw6lkcmljIExl
 IEdvYXRlciA8Y2xnQHJlZGhhdC5jb20+wsGRBBMBCAA7FiEEoPZlSPBIlev+awtgUaNDx8/7
 7KEFAmTLlVECGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQUaNDx8/77KG0eg//
 S0zIzTcxkrwJ/9XgdcvVTnXLVF9V4/tZPfB7sCp8rpDCEseU6O0TkOVFoGWM39sEMiQBSvyY
 lHrP7p7E/JYQNNLh441MfaX8RJ5Ul3btluLapm8oHp/vbHKV2IhLcpNCfAqaQKdfk8yazYhh
 EdxTBlzxPcu+78uE5fF4wusmtutK0JG0sAgq0mHFZX7qKG6LIbdLdaQalZ8CCFMKUhLptW71
 xe+aNrn7hScBoOj2kTDRgf9CE7svmjGToJzUxgeh9mIkxAxTu7XU+8lmL28j2L5uNuDOq9vl
 hM30OT+pfHmyPLtLK8+GXfFDxjea5hZLF+2yolE/ATQFt9AmOmXC+YayrcO2ZvdnKExZS1o8
 VUKpZgRnkwMUUReaF/mTauRQGLuS4lDcI4DrARPyLGNbvYlpmJWnGRWCDguQ/LBPpbG7djoy
 k3NlvoeA757c4DgCzggViqLm0Bae320qEc6z9o0X0ePqSU2f7vcuWN49Uhox5kM5L86DzjEQ
 RHXndoJkeL8LmHx8DM+kx4aZt0zVfCHwmKTkSTQoAQakLpLte7tWXIio9ZKhUGPv/eHxXEoS
 0rOOAZ6np1U/xNR82QbF9qr9TrTVI3GtVe7Vxmff+qoSAxJiZQCo5kt0YlWwti2fFI4xvkOi
 V7lyhOA3+/3oRKpZYQ86Frlo61HU3r6d9wzOwU0EW7yjdQEQALyDNNMw/08/fsyWEWjfqVhW
 pOOrX2h+z4q0lOHkjxi/FRIRLfXeZjFfNQNLSoL8j1y2rQOs1j1g+NV3K5hrZYYcMs0xhmrZ
 KXAHjjDx7FW3sG3jcGjFW5Xk4olTrZwFsZVUcP8XZlArLmkAX3UyrrXEWPSBJCXxDIW1hzwp
 bV/nVbo/K9XBptT/wPd+RPiOTIIRptjypGY+S23HYBDND3mtfTz/uY0Jytaio9GETj+fFis6
 TxFjjbZNUxKpwftu/4RimZ7qL+uM1rG1lLWc9SPtFxRQ8uLvLOUFB1AqHixBcx7LIXSKZEFU
 CSLB2AE4wXQkJbApye48qnZ09zc929df5gU6hjgqV9Gk1rIfHxvTsYltA1jWalySEScmr0iS
 YBZjw8Nbd7SxeomAxzBv2l1Fk8fPzR7M616dtb3Z3HLjyvwAwxtfGD7VnvINPbzyibbe9c6g
 LxYCr23c2Ry0UfFXh6UKD83d5ybqnXrEJ5n/t1+TLGCYGzF2erVYGkQrReJe8Mld3iGVldB7
 JhuAU1+d88NS3aBpNF6TbGXqlXGF6Yua6n1cOY2Yb4lO/mDKgjXd3aviqlwVlodC8AwI0Sdu
 jWryzL5/AGEU2sIDQCHuv1QgzmKwhE58d475KdVX/3Vt5I9kTXpvEpfW18TjlFkdHGESM/Jx
 IqVsqvhAJkalABEBAAHCwV8EGAECAAkFAlu8o3UCGwwACgkQUaNDx8/77KEhwg//WqVopd5k
 8hQb9VVdk6RQOCTfo6wHhEqgjbXQGlaxKHoXywEQBi8eULbeMQf5l4+tHJWBxswQ93IHBQjK
 yKyNr4FXseUI5O20XVNYDJZUrhA4yn0e/Af0IX25d94HXQ5sMTWr1qlSK6Zu79lbH3R57w9j
 hQm9emQEp785ui3A5U2Lqp6nWYWXz0eUZ0Tad2zC71Gg9VazU9MXyWn749s0nXbVLcLS0yop
 s302Gf3ZmtgfXTX/W+M25hiVRRKCH88yr6it+OMJBUndQVAA/fE9hYom6t/zqA248j0QAV/p
 LHH3hSirE1mv+7jpQnhMvatrwUpeXrOiEw1nHzWCqOJUZ4SY+HmGFW0YirWV2mYKoaGO2YBU
 wYF7O9TI3GEEgRMBIRT98fHa0NPwtlTktVISl73LpgVscdW8yg9Gc82oe8FzU1uHjU8b10lU
 XOMHpqDDEV9//r4ZhkKZ9C4O+YZcTFu+mvAY3GlqivBNkmYsHYSlFsbxc37E1HpTEaSWsGfA
 HQoPn9qrDJgsgcbBVc1gkUT6hnxShKPp4PlsZVMNjvPAnr5TEBgHkk54HQRhhwcYv1T2QumQ
 izDiU6iOrUzBThaMhZO3i927SG2DwWDVzZltKrCMD1aMPvb3NU8FOYRhNmIFR3fcalYr+9gD
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20251001175448.18933-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/1/25 19:54, Philippe Mathieu-Daudé wrote:
> The "exec/target_page.h" header is indirectly pulled from
> "system/ram_addr.h". Include it explicitly, in order to
> avoid unrelated issues when refactoring "system/ram_addr.h":
> 
>    hw/vfio/listener.c: In function ‘vfio_ram_discard_register_listener’:
>    hw/vfio/listener.c:258:28: error: implicit declaration of function ‘qemu_target_page_size’; did you mean ‘qemu_ram_pagesize’?
>      258 |     int target_page_size = qemu_target_page_size();
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>          |                            qemu_ram_pagesize
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   hw/vfio/listener.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/hw/vfio/listener.c b/hw/vfio/listener.c
> index a2c19a3cec1..b5cefc9395c 100644
> --- a/hw/vfio/listener.c
> +++ b/hw/vfio/listener.c
> @@ -25,6 +25,7 @@
>   #endif
>   #include <linux/vfio.h>
>   
> +#include "exec/target_page.h"
>   #include "hw/vfio/vfio-device.h"
>   #include "hw/vfio/pci.h"
>   #include "system/address-spaces.h"


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.



