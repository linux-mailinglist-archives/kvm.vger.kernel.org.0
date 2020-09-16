Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57926BDBE
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 09:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgIPHQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Sep 2020 03:16:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32856 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbgIPHQH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Sep 2020 03:16:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600240565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=YeskkhZrdYRC30aRDkN1HB5+YtMrgEAue+Oyyc6RWmM=;
        b=eGF03HeHHQKZAo9UfCMxHm16ptshnReiMsbywJfrNHHfqUrJB19rVrwFNuS1MJeegidXZl
        4eLObK0dq7tigQPRqdRrdez17cRVV0OvEHBlB7DYNPFyrQNqim1ojXgIepzeTiIPOx3oaG
        4GtyLNxYUytZHe4hIJCdQhNxF0htApg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-xx22gtqBN8u6n5_VCb-9oQ-1; Wed, 16 Sep 2020 03:16:02 -0400
X-MC-Unique: xx22gtqBN8u6n5_VCb-9oQ-1
Received: by mail-wr1-f69.google.com with SMTP id a2so724206wrp.8
        for <kvm@vger.kernel.org>; Wed, 16 Sep 2020 00:16:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=YeskkhZrdYRC30aRDkN1HB5+YtMrgEAue+Oyyc6RWmM=;
        b=QGM+8qVpA5fo/YqGLaJdMoKuf/V/U2elzonq+gNyuWPktOxNpEAZDVK6sC4ffu0TX7
         YIULx7KYkW0O8rXfUDf3PK8IB1FSZrYbQQLxdjEsYHVCwvHB0I8XiTtRaPWdxwLG9bK+
         GjTGT0km/8IPhcpJRnk1jaSY7E9A9YFXEfiIbVAB4h+i18ZZ7MekPphvDT44nhcWw0CF
         XzmlTrO4HKUnR4QZp2lKGmcbYrsO5ZtAidwG+2jDv7C/JwIsNQNQbjPeJTF0CijNDG9y
         kJ6//uj0Wmb2zlZHLpLp1YkHku+gTNk0sQpfLbx1oVikOJYReV9iMStntIS7DpeBaSFg
         VHnw==
X-Gm-Message-State: AOAM531aYnoSuAi2deo5nKbD5UNS23UcX7MractFnJMFhkhBTgsArEyL
        NmMjgWkqwIlE2zbPJ4VIG1jD42obHX/deioWT+zKl/Ysb1Z0TJM+SI7beZI4sPqY3kcH1hdgETj
        YTWjGly2pFULn
X-Received: by 2002:a5d:568d:: with SMTP id f13mr24570466wrv.303.1600240561596;
        Wed, 16 Sep 2020 00:16:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq0noszoQVJzm1DolWidvEViQOZeYjUogYdFgbN9z6nyZ6FKwQGNCkB9JVIICEVejxkoml4w==
X-Received: by 2002:a5d:568d:: with SMTP id f13mr24570450wrv.303.1600240561426;
        Wed, 16 Sep 2020 00:16:01 -0700 (PDT)
Received: from [192.168.1.36] (65.red-83-57-170.dynamicip.rima-tde.net. [83.57.170.65])
        by smtp.gmail.com with ESMTPSA id t15sm24849685wrp.20.2020.09.16.00.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 00:16:00 -0700 (PDT)
Subject: Re: [PATCH v3 2/5] vfio: Create shared routine for scanning info
 capabilities
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com
Cc:     thuth@redhat.com, kvm@vger.kernel.org, pmorel@linux.ibm.com,
        david@redhat.com, schnelle@linux.ibm.com, qemu-devel@nongnu.org,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, qemu-s390x@nongnu.org,
        mst@redhat.com, pbonzini@redhat.com, rth@twiddle.net
References: <1600197283-25274-1-git-send-email-mjrosato@linux.ibm.com>
 <1600197283-25274-3-git-send-email-mjrosato@linux.ibm.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Autocrypt: addr=philmd@redhat.com; keydata=
 mQINBDXML8YBEADXCtUkDBKQvNsQA7sDpw6YLE/1tKHwm24A1au9Hfy/OFmkpzo+MD+dYc+7
 bvnqWAeGweq2SDq8zbzFZ1gJBd6+e5v1a/UrTxvwBk51yEkadrpRbi+r2bDpTJwXc/uEtYAB
 GvsTZMtiQVA4kRID1KCdgLa3zztPLCj5H1VZhqZsiGvXa/nMIlhvacRXdbgllPPJ72cLUkXf
 z1Zu4AkEKpccZaJspmLWGSzGu6UTZ7UfVeR2Hcc2KI9oZB1qthmZ1+PZyGZ/Dy+z+zklC0xl
 XIpQPmnfy9+/1hj1LzJ+pe3HzEodtlVA+rdttSvA6nmHKIt8Ul6b/h1DFTmUT1lN1WbAGxmg
 CH1O26cz5nTrzdjoqC/b8PpZiT0kO5MKKgiu5S4PRIxW2+RA4H9nq7nztNZ1Y39bDpzwE5Sp
 bDHzd5owmLxMLZAINtCtQuRbSOcMjZlg4zohA9TQP9krGIk+qTR+H4CV22sWldSkVtsoTaA2
 qNeSJhfHQY0TyQvFbqRsSNIe2gTDzzEQ8itsmdHHE/yzhcCVvlUzXhAT6pIN0OT+cdsTTfif
 MIcDboys92auTuJ7U+4jWF1+WUaJ8gDL69ThAsu7mGDBbm80P3vvUZ4fQM14NkxOnuGRrJxO
 qjWNJ2ZUxgyHAh5TCxMLKWZoL5hpnvx3dF3Ti9HW2dsUUWICSQARAQABtDJQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoUGhpbCkgPHBoaWxtZEByZWRoYXQuY29tPokCVQQTAQgAPwIbDwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4AWIQSJweePYB7obIZ0lcuio/1u3q3A3gUCXsfWwAUJ
 KtymWgAKCRCio/1u3q3A3ircD/9Vjh3aFNJ3uF3hddeoFg1H038wZr/xi8/rX27M1Vj2j9VH
 0B8Olp4KUQw/hyO6kUxqkoojmzRpmzvlpZ0cUiZJo2bQIWnvScyHxFCv33kHe+YEIqoJlaQc
 JfKYlbCoubz+02E2A6bFD9+BvCY0LBbEj5POwyKGiDMjHKCGuzSuDRbCn0Mz4kCa7nFMF5Jv
 piC+JemRdiBd6102ThqgIsyGEBXuf1sy0QIVyXgaqr9O2b/0VoXpQId7yY7OJuYYxs7kQoXI
 6WzSMpmuXGkmfxOgbc/L6YbzB0JOriX0iRClxu4dEUg8Bs2pNnr6huY2Ft+qb41RzCJvvMyu
 gS32LfN0bTZ6Qm2A8ayMtUQgnwZDSO23OKgQWZVglGliY3ezHZ6lVwC24Vjkmq/2yBSLakZE
 6DZUjZzCW1nvtRK05ebyK6tofRsx8xB8pL/kcBb9nCuh70aLR+5cmE41X4O+MVJbwfP5s/RW
 9BFSL3qgXuXso/3XuWTQjJJGgKhB6xXjMmb1J4q/h5IuVV4juv1Fem9sfmyrh+Wi5V1IzKI7
 RPJ3KVb937eBgSENk53P0gUorwzUcO+ASEo3Z1cBKkJSPigDbeEjVfXQMzNt0oDRzpQqH2vp
 apo2jHnidWt8BsckuWZpxcZ9+/9obQ55DyVQHGiTN39hkETy3Emdnz1JVHTU0Q==
Message-ID: <3ee0b4c6-865e-82b3-b003-64a4ddaab4b5@redhat.com>
Date:   Wed, 16 Sep 2020 09:15:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1600197283-25274-3-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/20 9:14 PM, Matthew Rosato wrote:
> Rather than duplicating the same loop in multiple locations,
> create a static function to do the work.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>

Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>

> ---
>  hw/vfio/common.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 3335714..eba7b55 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -825,17 +825,12 @@ static void vfio_listener_release(VFIOContainer *container)
>      }
>  }
>  
> -struct vfio_info_cap_header *
> -vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
> +static struct vfio_info_cap_header *
> +vfio_get_cap(void *ptr, uint32_t cap_offset, uint16_t id)
>  {
>      struct vfio_info_cap_header *hdr;
> -    void *ptr = info;
> -
> -    if (!(info->flags & VFIO_REGION_INFO_FLAG_CAPS)) {
> -        return NULL;
> -    }
>  
> -    for (hdr = ptr + info->cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
> +    for (hdr = ptr + cap_offset; hdr != ptr; hdr = ptr + hdr->next) {
>          if (hdr->id == id) {
>              return hdr;
>          }
> @@ -844,6 +839,16 @@ vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
>      return NULL;
>  }
>  
> +struct vfio_info_cap_header *
> +vfio_get_region_info_cap(struct vfio_region_info *info, uint16_t id)
> +{
> +    if (!(info->flags & VFIO_REGION_INFO_FLAG_CAPS)) {
> +        return NULL;
> +    }
> +
> +    return vfio_get_cap((void *)info, info->cap_offset, id);
> +}
> +
>  static int vfio_setup_region_sparse_mmaps(VFIORegion *region,
>                                            struct vfio_region_info *info)
>  {
> 

