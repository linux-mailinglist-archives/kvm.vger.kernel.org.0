Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8895A2F2C9C
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 11:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404887AbhALKW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 05:22:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730219AbhALKW2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 05:22:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610446861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lI5PuvPTiPf0gmjqGd/hf2wO6dPsnxRECFfzR1WJPLs=;
        b=d+wLLjwaKCCpIgTY83REThYySYmchS6C4KBbDgaREWPij5C6YpgyAWeTJIPAeAslVB3/qr
        oTANctNDsAU0OPm6Qyb5T13XJ7IgouXGBjzKs5pOWiZtYZ5cjfpDyYyuiMceEed6CDK0+A
        DDAvQA1vTM60ldYAZ6UWWKrS+TZ/EyU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-51A-Z5yQNBSJ8CFOLiSOaw-1; Tue, 12 Jan 2021 05:21:00 -0500
X-MC-Unique: 51A-Z5yQNBSJ8CFOLiSOaw-1
Received: by mail-ej1-f71.google.com with SMTP id y14so818955ejf.11
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 02:20:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lI5PuvPTiPf0gmjqGd/hf2wO6dPsnxRECFfzR1WJPLs=;
        b=o/4NvrFUEgp2kE019onjLr8TsTlzwq2kQSZuGr2tGxhJgQ8KgS5It+pxIXNg99xBT3
         VjvVUH3e2swbKR9VSJPhNfKUzGRJFhb5WqRYXDn4HuokVmnwMf0nyrAdyZSaOJspc101
         fHMPuDNXnkN92U02btpM1ErkOsLSK+hwaTrqLcQwx48Zli0Fv6ga6rmbI8dOWY43WZi/
         Q6Y3U5heloPpRYg+IsjyFUYQpkFMMtCK9q3mF24lqzco2Vzjjwy5x+A320Yl+ZINz+zn
         D7sehYb1DQ5Yca5N53CGa61DIIaCSEbttu+9PRZsouRB8SkVUdtITCsH+zcl7CIczCrI
         TJLw==
X-Gm-Message-State: AOAM530Yg7Ds4KQs0BqZqvCfIchi+TSM2INb/7UFx5ybxJAcOUiLp98I
        /Qnn03EPpNiywcXSD+TM9zxPZc+ULkLXRBTR5xysFFgdSvdnB19dm6I5ATZtIuUkhGOUsVy7+H+
        hembDSVw5m+AS
X-Received: by 2002:a17:906:707:: with SMTP id y7mr1527494ejb.212.1610446858832;
        Tue, 12 Jan 2021 02:20:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywO1rPIkn1yRD5GniRn5LraCSMkHNnGgGyImnsjbNcJA9ru2wDzuqOeUkJy+33I6qvdMGgvw==
X-Received: by 2002:a17:906:707:: with SMTP id y7mr1527483ejb.212.1610446858615;
        Tue, 12 Jan 2021 02:20:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x4sm1192917edr.40.2021.01.12.02.20.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 02:20:57 -0800 (PST)
Subject: Re: [PATCH] kvm: Fixes lack of KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
 enabled check
To:     Kunkun Jiang <jiangkunkun@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wanghaibin.wang@huawei.com, Keqian Zhu <zhukeqian1@huawei.com>
References: <20210112092942.2310-1-jiangkunkun@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9dd32bc9-a35c-e43f-51f2-c0989cca4e66@redhat.com>
Date:   Tue, 12 Jan 2021 11:20:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210112092942.2310-1-jiangkunkun@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 10:29, Kunkun Jiang wrote:
> The KVM_CLEAR_DIRTY_LOG ioctl lacks the check whether the capability
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT is enabled or not. This may cause
> some problems if userspace calls the KVM_CLEAR_DIRTY_LOG ioctl, but
> dose't enable this capability. So we'd better to add it.
> 
> Fixes: 2a31b9db15353 ("kvm: introduce manual dirty log reprotect")
> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> ---
>   virt/kvm/kvm_main.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fa9e3614d30e..8f5633d8a0e8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1602,6 +1602,9 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>   	unsigned long *dirty_bitmap_buffer;
>   	bool flush;
>   
> +	if (!kvm->manual_dirty_log_protect)
> +		return -EPERM;
> +
>   	/* Dirty ring tracking is exclusive to dirty log tracking */
>   	if (kvm->dirty_ring_size)
>   		return -ENXIO;

This is not a problem, KVM_CLEAR_DIRTY_LOG can always be used even if 
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT was not enabled.  The meaning is the 
same: clear the bits without returning them.

Paolo

