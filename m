Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65369655974
	for <lists+kvm@lfdr.de>; Sat, 24 Dec 2022 09:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiLXIxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 03:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLXIxr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 03:53:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32997AE67
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 00:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671871980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0nylbM5CrZpgckONjIihH5A0mWHgFhUpGT7awXnwGE=;
        b=CpFVAkPodYNYZ403jWvfX7dXNyh3YP+JgAfjyVtIHiZ3f9cmJ4MOFmvi4SwWSPR/aXHktD
        /vqBzb4JkBWqXqaRJwg9XqdIoAignqwzcN8yFP1h5d4OHUxT2zCWApa9g+fx9ZNMeTFVHT
        dG43EBtKM9DJdvR2euVEPV4GexLTvIQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-171-r_vPAU06MfSkCFcU201h5Q-1; Sat, 24 Dec 2022 03:52:58 -0500
X-MC-Unique: r_vPAU06MfSkCFcU201h5Q-1
Received: by mail-ej1-f72.google.com with SMTP id nc4-20020a1709071c0400b0078a5ceb571bso4630832ejc.4
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 00:52:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F0nylbM5CrZpgckONjIihH5A0mWHgFhUpGT7awXnwGE=;
        b=Wa7+qNNU2yjBe2ZJ/MgBR8RSAj9yeYHLh8e8kYFBZaPQjlowsm5fX5O3KHCM3Mx68K
         fdXzzQIpc2VHCcSg/wJOs23oVEg50n3ASurwh5SQOogTCF3jIJo0vd1BK00XrmoMwmnQ
         FGY3sxg/i9/JUgcUsdzZ85lHqHlxUpOfI7EKJpLaOX0hAKwC2cY1aPp4nqaHtu8+6rJb
         YrkKMYdS0CPyCBSC+9zmNAn1d76pPipYkhex6mT/xPLvYFT7m84/rmN504STvKPnZuMX
         zGavTbJ6veQnOzAsB3bhWpgwU8Q7e5a3qmQkRqjqB0sEpORd+2ori0Dt0UNXzbyq2yz1
         Wl7g==
X-Gm-Message-State: AFqh2krbeGB2hP5zEW96NDnGrRsAqEBQfVzB1m4+gl3ddUTwA+7haB9i
        r2BSXhqvNZYYDe0/GYwEfXWx3wb2xrROVM2Bb3t9OajWLq9r71RODUPOdxrd4ETKVEK2UD2y0X3
        iV8Eelg72Gd3T
X-Received: by 2002:a05:6402:e83:b0:467:75c6:4565 with SMTP id h3-20020a0564020e8300b0046775c64565mr11200596eda.9.1671871977447;
        Sat, 24 Dec 2022 00:52:57 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvX3U0jZ3CJztUD49BRSLbeYG/HhnsS/s0q/Mu/8HgLeo7e8POR/YGXPMjTBv9P34C3ycUD8w==
X-Received: by 2002:a05:6402:e83:b0:467:75c6:4565 with SMTP id h3-20020a0564020e8300b0046775c64565mr11200590eda.9.1671871977211;
        Sat, 24 Dec 2022 00:52:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g11-20020a056402180b00b0046bb7503d9asm2316209edy.24.2022.12.24.00.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Dec 2022 00:52:56 -0800 (PST)
Message-ID: <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
Date:   Sat, 24 Dec 2022 09:52:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-2-mhal@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in
 kvm_xen_eventfd_update()
In-Reply-To: <20221222203021.1944101-2-mhal@rbox.co>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/22/22 21:30, Michal Luczaj wrote:
> +	idx = srcu_read_lock(&kvm->srcu);
> +
>   	mutex_lock(&kvm->lock);
>   	evtchnfd = idr_find(&kvm->arch.xen.evtchn_ports, port);
>   	mutex_unlock(&kvm->lock);
>   

This lock/unlock pair can cause a deadlock because it's inside the SRCU 
read side critical section.  Fortunately it's simpler to just use 
mutex_lock for the whole function instead of using two small critical 
sections, and then SRCU is not needed.

However, the same issue exists in kvm_xen_hcall_evtchn_send where 
idr_find is not protected by kvm->lock.  In that case, it is important 
to use rcu_read_lock/unlock() around it, because idr_remove() will *not* 
use synchronize_srcu() to wait for readers to complete.

Paolo

