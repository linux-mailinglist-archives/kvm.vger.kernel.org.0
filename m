Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8A265597B
	for <lists+kvm@lfdr.de>; Sat, 24 Dec 2022 09:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiLXIzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 03:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiLXIzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 03:55:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5CAB7D0
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 00:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671872077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFNuI/LVWINAZkmD4oM8l+iW2KAO4My6NfN3oP5L+Js=;
        b=UE6XY9VITSrB5f8cXyGnmRAwDwsCSnzG6+5KxZYbTw4avGqFvCZro9JNmhqGV6ZmCLs1LK
        0iPIWbMyB852lim+xDOxlpaI4c6sHjJS5s2LgOomTgBnt7AsczKHBPhfoqyHZB+STX++dy
        SaB/Fsr+smPw7ERjL5zoUPESFIJ+NoI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-513-O-gnzrUOOI6bj0FVs3SY7w-1; Sat, 24 Dec 2022 03:54:36 -0500
X-MC-Unique: O-gnzrUOOI6bj0FVs3SY7w-1
Received: by mail-ej1-f69.google.com with SMTP id nc4-20020a1709071c0400b0078a5ceb571bso4631998ejc.4
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 00:54:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFNuI/LVWINAZkmD4oM8l+iW2KAO4My6NfN3oP5L+Js=;
        b=quFTw6OQM2ZdKc8bwLAOPLehptmcdjuvZYMZV0R0+M6lQiX8Eo/xL5uuYnwDJqyPhE
         qW6BddR6jLLb0wwWUaEcU5bZG89vmxsZvBe3d3/6+SzK1KTKa7Pzntk3hvObMDHa3gjK
         bXyTIMhkIuJz+Ygox6wu8UlV4tXQcw1TF8+FnDoJZp+Yj7puNWfB2G0gzsntFTRg6Lgs
         CjfX3c0491IDFU1AR0I5djHg9Ju6tWyAEJTxoOf5tUuSCNxwtsKSxGPorvUyUCKNFeJ3
         MeeFOLott/fFhSzN0T9JjWsuC/Un0bybVinheb7+Vdr6R0gtO8SUhJ2Qbu8x0fZaJdEG
         +3kA==
X-Gm-Message-State: AFqh2kpjZozLpAjaNd63/LJvh0c7a9Af+OP+1umWywTBVzVjMldBY8JS
        xHggW9/3Uf2elsbBwjv5mQSZn3uY0T0wwnb3LltJf6qQSMvCP29w7b4EK40Fs8PI3U7QCQimAo8
        3vEPMjpsu0CfH
X-Received: by 2002:a17:906:3095:b0:809:c1f4:ea09 with SMTP id 21-20020a170906309500b00809c1f4ea09mr9636128ejv.69.1671872074845;
        Sat, 24 Dec 2022 00:54:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvykEyqEeShMPMX8+NwlBldjdavPlN7s6YP5XIdLQ5mW8W18/z8X9j6XcxetcBJw0DHjDqjww==
X-Received: by 2002:a17:906:3095:b0:809:c1f4:ea09 with SMTP id 21-20020a170906309500b00809c1f4ea09mr9636123ejv.69.1671872074691;
        Sat, 24 Dec 2022 00:54:34 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id b10-20020a1709063caa00b007bd28b50305sm2270817ejh.200.2022.12.24.00.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Dec 2022 00:54:34 -0800 (PST)
Message-ID: <bb0a9b3a-eed6-399f-f448-b0ab763226f9@redhat.com>
Date:   Sat, 24 Dec 2022 09:54:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 2/2] KVM: x86/xen: Simplify eventfd IOCTLs
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-3-mhal@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221222203021.1944101-3-mhal@rbox.co>
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
> Port number is validated in kvm_xen_setattr_evtchn().
> Remove superfluous checks in kvm_xen_eventfd_assign() and
> kvm_xen_eventfd_update().
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>   arch/x86/kvm/xen.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 8e17629e5665..87da95ceba92 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -1828,9 +1828,6 @@ static int kvm_xen_eventfd_update(struct kvm *kvm,
>   	int ret = -EINVAL;
>   	int idx;
>   
> -	if (!port || port >= max_evtchn_port(kvm))
> -		return -EINVAL;
> -
>   	idx = srcu_read_lock(&kvm->srcu);
>   
>   	mutex_lock(&kvm->lock);
> @@ -1880,12 +1877,9 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm,
>   {
>   	u32 port = data->u.evtchn.send_port;
>   	struct eventfd_ctx *eventfd = NULL;
> -	struct evtchnfd *evtchnfd = NULL;
> +	struct evtchnfd *evtchnfd;
>   	int ret = -EINVAL;
>   
> -	if (!port || port >= max_evtchn_port(kvm))
> -		return -EINVAL;
> -
>   	evtchnfd = kzalloc(sizeof(struct evtchnfd), GFP_KERNEL);
>   	if (!evtchnfd)
>   		return -ENOMEM;

Queued this one, thanks.

Paolo

