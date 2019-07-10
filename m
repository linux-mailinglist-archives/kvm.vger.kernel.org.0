Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B908B6484B
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 16:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfGJOZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 10:25:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38962 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbfGJOZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 10:25:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so2480042wma.4
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 07:25:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+0LosfxsvkNGBVWnJU6QVIa/qGzpJQd9CyzuveK8JfE=;
        b=plMgTCX0nMkVxIjxC0ge/8aliSEONvU7YMG7LS2lLIkUEoSB6/8UhsImf72VWrZcNU
         azX2fTuZSMw6EIobNO/lgN6eP0XdpsRkLj9NxFwb44vWI4YkYWW0PBjNZekexnIpXYzs
         7O4Y5cHqF7GwHcG92dwRSXspCw208B/MCVEl6DcV4PKdL/6Ii8B0PpiY7s9qoTLnGiz/
         cOOWWEFBcw2TCdOjDjBDcqGAA4CJO3uDPsYSDwmxLpdCNKByjrPmAsI1O6cRWD0vng6b
         1QFtVk1k4O+qtG5rd6qEs0Xcn3msZ1k92QWTdy8y0gSbZ80z7YgvRUDluV6r8g20k1pt
         cYyQ==
X-Gm-Message-State: APjAAAXxFl5mLfwdwRk+GUCWra9HblMVPh3oTg15WN/TKFcyOy/uhPKG
        e0NM/GbXAXfEOC7wuCiojtKpQHh1dxY=
X-Google-Smtp-Source: APXvYqzpSaxhhuN89pzaPtBew7yUYSwHgYeg+yOQeIKOSgXSouqRPXnfaK4Me0V2QX6f9hh31inXDg==
X-Received: by 2002:a05:600c:225a:: with SMTP id a26mr5969288wmm.81.1562768745966;
        Wed, 10 Jul 2019 07:25:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id 2sm2854347wrn.29.2019.07.10.07.25.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 07:25:45 -0700 (PDT)
Subject: Re: [PATCH] KVM: Properly check if "page" is valid in kvm_vcpu_unmap
To:     KarimAllah Ahmed <karahmed@amazon.de>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
References: <1562749993-12840-1-git-send-email-karahmed@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b62d552-b82f-a194-bad1-cb6a08475bba@redhat.com>
Date:   Wed, 10 Jul 2019 16:25:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562749993-12840-1-git-send-email-karahmed@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/19 11:13, KarimAllah Ahmed wrote:
> The field "page" is initialized to KVM_UNMAPPED_PAGE when it is not used
> (i.e. when the memory lives outside kernel control). So this check will
> always end up using kunmap even for memremap regions.
> 
> Fixes: e45adf665a53 ("KVM: Introduce a new guest mapping API")
> Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2f2d24a..e629766 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1790,7 +1790,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
>  	if (!map->hva)
>  		return;
>  
> -	if (map->page)
> +	if (map->page != KVM_UNMAPPED_PAGE)
>  		kunmap(map->page);
>  #ifdef CONFIG_HAS_IOMEM
>  	else
> 

Queued, thanks.

Paolo
