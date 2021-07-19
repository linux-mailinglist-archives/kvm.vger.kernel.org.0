Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0CA3CCCAD
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 05:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhGSDdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jul 2021 23:33:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234370AbhGSDdw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 18 Jul 2021 23:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626665453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4thYMEzNgF3AoCRQde59dht0ziPpusYLCABZjd2uI4s=;
        b=BsIRhtUSe9rE3jt9iuOzQZ31E2yIxBVN8/91NYn7XzrhsipJKdAjAH+hzqwnlO4uM74LGW
        UlC9fBrK6QPstnzveu+zIW2Gf7ZNqC7Hi+0KO1H49PvCIpPA+ss3HltruTXjsvyAknDsDt
        p78coo+NSDq4Kva/9lTYa6jfVFZM454=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-HzHBGWfePOudKLCTHXh04w-1; Sun, 18 Jul 2021 23:30:49 -0400
X-MC-Unique: HzHBGWfePOudKLCTHXh04w-1
Received: by mail-pf1-f197.google.com with SMTP id 15-20020aa7924f0000b029033034a332ecso12592251pfp.16
        for <kvm@vger.kernel.org>; Sun, 18 Jul 2021 20:30:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4thYMEzNgF3AoCRQde59dht0ziPpusYLCABZjd2uI4s=;
        b=nMIm5jcBjXDlFW2IStVDLUdPjN21Xj01nx7dUaeA/IvSzSdrFMO5vpdxDvJB07hqyj
         5NXLqxLLwXBUPLm/hOCTAwhcuROGrK4SHtIRRPHsykWSqqbsfjN5X4XRWzGoJ1s1rUsw
         qvL2lJCM8D82i7dg/1lmsVyP6FXSZDjhWzzTufsGCguMyhcS5PaOZMX1/O7yPcMadUf5
         ftVh+3Q72e77EzwqeaomqvvbzJuSCAdAP+snLkSpoA2XDh7cuxd+ObDGOUN83ye1NxJk
         YeqJ+B4actK62C8mnsPdgvAA8Fh4v0c39BTDARo/Cyy8Eu7yGjcv0d5sV/Se+sa5rwrl
         DTuw==
X-Gm-Message-State: AOAM532P5Ws9BE5f2+gZHn+r2YoN7bdQJX7kLOnJebUKfwmeN/eBkCi3
        zCEbPlkIXqWLeMca82VMkI1ujlyKxO6ncyM9NuH2YWCdldeMyf6ytDwjuTBw7wshuIleZ3PmhUO
        Vf+60hRfdOknV
X-Received: by 2002:a17:90a:fe07:: with SMTP id ck7mr11831840pjb.51.1626665448809;
        Sun, 18 Jul 2021 20:30:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxe6zlZhtmikh9nPja5DIIRB06qSd9L4IveW6TD/qUNVnYqP4YhQrac1LChSjiJDHogpY4xig==
X-Received: by 2002:a17:90a:fe07:: with SMTP id ck7mr11831822pjb.51.1626665448660;
        Sun, 18 Jul 2021 20:30:48 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i1sm17606689pfo.37.2021.07.18.20.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 20:30:48 -0700 (PDT)
Subject: Re: [PATCH 2/2] vhost: Fix the calculation in vhost_overflow()
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210716102239.96-1-xieyongji@bytedance.com>
 <20210716102239.96-2-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e2d68906-ffa1-4e87-4251-d83ce96a8869@redhat.com>
Date:   Mon, 19 Jul 2021 11:30:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210716102239.96-2-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/7/16 下午6:22, Xie Yongji 写道:
> This fixes the incorrect calculation for integer overflow
> when the last address of iova range is 0xffffffff.
>
> Fixes: ec33d031a14b ("vhost: detect 32 bit integer wrap around“)
> Reported-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vhost/vhost.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b9e853e6094d..a9fd1b311d2f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -738,7 +738,8 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
>   static bool vhost_overflow(u64 uaddr, u64 size)
>   {
>   	/* Make sure 64 bit math will not overflow. */
> -	return uaddr > ULONG_MAX || size > ULONG_MAX || uaddr > ULONG_MAX - size;
> +	return uaddr > ULONG_MAX || size > ULONG_MAX ||
> +	       uaddr - 1 > ULONG_MAX - size;
>   }


Acked-by: Jason Wang <jasowang@redhat.com>


>   
>   /* Caller should have vq mutex and device mutex. */

