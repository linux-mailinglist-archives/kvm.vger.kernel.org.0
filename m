Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC39F3AC4DD
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 09:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhFRHWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 03:22:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232136AbhFRHWi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 03:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624000828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=08bKtYLw8+WJMSJXFwmWg9TmqP7htBCNATjR/bZl300=;
        b=DV3saigLbsI8fdeBhP/NRgFbSEpD84JUeRHA4rNeQ9nfVItpnOtCCX0hCosJmEo8maLtCH
        jbMYp2T0/aP85rq9SePyrXX4wIFvMaYVGiEfAuO5V3VnglFnO1Hmw08ptQtI21nSwo3ysq
        hM4R9p0DvM3AwEJlQgkZy+SS/T+xXHk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-dpEvZkzcPv2ViGwZFJ6bXw-1; Fri, 18 Jun 2021 03:20:27 -0400
X-MC-Unique: dpEvZkzcPv2ViGwZFJ6bXw-1
Received: by mail-pg1-f197.google.com with SMTP id 4-20020a6315440000b029022154a87a57so5419693pgv.13
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 00:20:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=08bKtYLw8+WJMSJXFwmWg9TmqP7htBCNATjR/bZl300=;
        b=jiooCShGFks9UnCRzk1TkSVJCUia4uwYwGgXDokQGhAKxzi9OrilJ23NKXW5gW3Jyf
         MTXRaCdDqm65mt6BMyuq8qc5lfGaoOIk+JBfYvL9VPtWC8NIxxqlo8Z22zZvJAa0JNEj
         yV/i/6jlbJEH7M3R6pL8UVBx063W3X4TTBhmdh4pa6F7yntxQCfnOkQkAPif0JDMJZ+S
         BvAKBDVrzghVY28VyTjzNaz6eAjdw0PK38bU4zu3YFyIDWwP3vvLR+QgEtPkzaNv0I7H
         v1TK5XTe/mNMOkaSCLmbxmmcy7S9baPMUK1xIDDjwy8UaiQGPRiyCENa5MyJMe7lW2af
         fP2Q==
X-Gm-Message-State: AOAM532HQGwyvlpwi/K2R1fXK6fbhWlGaUOq2KA3rnImHH+WaRmL90TG
        fjCsPhsfloOu871XhHOqXHmrfyCnBi0yGiUMRGOmYZi4ZxbrjHL8ArReE2xTpog31saNJnLihqX
        2QmOgHLowZzAq
X-Received: by 2002:a63:5d5:: with SMTP id 204mr8666305pgf.72.1624000826234;
        Fri, 18 Jun 2021 00:20:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEQkh9qhMUesoxoT0WlU7iHzOuiibkI62nhu2NHrn8HyNbptwaeYz6rc1kpnZvt7mx+SI2wg==
X-Received: by 2002:a63:5d5:: with SMTP id 204mr8666288pgf.72.1624000826020;
        Fri, 18 Jun 2021 00:20:26 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d92sm7246815pjk.38.2021.06.18.00.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 00:20:25 -0700 (PDT)
Subject: Re: [PATCH] vhost-vdpa: fix bug-"v->vqs" and "v" don't free
To:     Cai Huoqing <caihuoqing@baidu.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20210618065307.183-1-caihuoqing@baidu.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5f046ae5-2a1a-e843-bcae-f16ac0167c0e@redhat.com>
Date:   Fri, 18 Jun 2021 15:20:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210618065307.183-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/6/18 ÏÂÎç2:53, Cai Huoqing Ð´µÀ:
> "v->vqs" and "v" don't free when "cdev_device_add" returns error
>
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>   drivers/vhost/vdpa.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index fb41db3da611..6e5d5df5ee70 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1065,6 +1065,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>   
>   err:
>          put_device(&v->dev);
> +       kfree(v->vqs);
> +       kfree(v);


Isn't this the charge of vhost_vdpa_release_dev()?

Thanks


>          return r;
>   }
>   

