Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9185A0973
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 09:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbiHYHEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 03:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235211AbiHYHD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 03:03:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6E5A1A55
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 00:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661411034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Ffg639fyFav+yTERy7xieKmvjhwhKltTl/7JA3fe1o=;
        b=IFjJqHhcIShM0sXapb/GC7sO0jJtdyx9j65RqqMu9lvsC6jafQndr9TFSbD4kuH/d/cKPR
        oXe4nYvv3LfMBZoUHh6k9Vz+2hKeMEAelGGRl1aX+Vm0nPmTWGX9gvYZe/vDsCQ5FZu9FV
        d8SpqK1+3BIQF92RG3tZHdNaCi4BbOE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-511-I-oNdRb-NYSP1u8dv4rzAA-1; Thu, 25 Aug 2022 03:03:51 -0400
X-MC-Unique: I-oNdRb-NYSP1u8dv4rzAA-1
Received: by mail-pl1-f197.google.com with SMTP id b9-20020a170903228900b001730a0e11e5so3811015plh.19
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 00:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=+Ffg639fyFav+yTERy7xieKmvjhwhKltTl/7JA3fe1o=;
        b=cClUSZDwZec6wefNR4EV+WPMdUc0k63SPaU9mA0W3ixDBvT7ZcuKefry+oFCaAbD7w
         t6YZecsSqleVIT3t/PxV9pB5kxSIm8wZL+ERdz5/Uf/49s/jmOwI+y1qdLeSQFdRAezj
         uTkAEcz+2kvl0FRal67jrJaekHha8OXCHVT9MsqFtfvWMiFKBW8zgPLAq9zGIX6EU12H
         3vlR2QQgyn0jHONKGjsYbW7z+Nt8xtu8tVoEWol6v4sYXJnoVeDMUa2M46adb1f3a1Dj
         WgIu0qqLfqBKs3pJTZwt6F1Xz7KiS/DIgsoCeDYGPQiO2KTWNFLJ4cybcqWC7XzDUUBd
         yhlg==
X-Gm-Message-State: ACgBeo11ZH2dJP8yMHR13yvBQeQnMF/GQxcTEPRDzp5y1tTTkGjxY+mR
        rfmHnwUP7WWqxXSq/BnhztlfO9uMtFZuRll0tKKjm+BOu9Z3UgFAaThH/LuW1We5gA0asIckGBp
        Zxcz8O4yJ1fBR
X-Received: by 2002:a17:903:120c:b0:170:aa42:dbba with SMTP id l12-20020a170903120c00b00170aa42dbbamr2638232plh.67.1661411029961;
        Thu, 25 Aug 2022 00:03:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR71A9+1ssM8l0gU1/rJujbzZ0dEmhpSI0OZl7bEsrI1ruifEdYAsxDq2H0vI9SqQdgeiSLCKg==
X-Received: by 2002:a17:903:120c:b0:170:aa42:dbba with SMTP id l12-20020a170903120c00b00170aa42dbbamr2638212plh.67.1661411029695;
        Thu, 25 Aug 2022 00:03:49 -0700 (PDT)
Received: from [10.72.12.107] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g11-20020a170902e38b00b001726ea1b716sm559783ple.237.2022.08.25.00.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 00:03:49 -0700 (PDT)
Message-ID: <06761c62-93b4-8eaa-370f-f26b7c5306ca@redhat.com>
Date:   Thu, 25 Aug 2022 15:03:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v2 2/7] vhost_test: batch used buffer
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
 <20220817135718.2553-3-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220817135718.2553-3-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/8/17 21:57, Guo Zhi 写道:
> Only add to used ring when a batch of buffer have all been used.  And if
> in order feature negotiated, only add the last used descriptor for a
> batch of buffer.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/vhost/test.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index bc8e7fb1e635..57cdb3a3edf6 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -43,6 +43,9 @@ struct vhost_test {
>   static void handle_vq(struct vhost_test *n)
>   {
>   	struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
> +	struct vring_used_elem *heads = kmalloc(sizeof(*heads)
> +			* vq->num, GFP_KERNEL);


Though it's a test device, it would be better to try avoid memory 
allocation in the datapath.

And where is is freed?

Thanks


> +	int batch_idx = 0;
>   	unsigned out, in;
>   	int head;
>   	size_t len, total_len = 0;
> @@ -84,11 +87,14 @@ static void handle_vq(struct vhost_test *n)
>   			vq_err(vq, "Unexpected 0 len for TX\n");
>   			break;
>   		}
> -		vhost_add_used_and_signal(&n->dev, vq, head, 0);
> +		heads[batch_idx].id = cpu_to_vhost32(vq, head);
> +		heads[batch_idx++].len = cpu_to_vhost32(vq, len);
>   		total_len += len;
>   		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
>   			break;
>   	}
> +	if (batch_idx)
> +		vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx);
>   
>   	mutex_unlock(&vq->mutex);
>   }

