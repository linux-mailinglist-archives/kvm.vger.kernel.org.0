Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3566D90CE
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 09:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbjDFHvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 03:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbjDFHvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 03:51:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C947ABA
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 00:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680767450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zfpt1hWlJeW+De1zXUq58qE//gZcupovgtklglmgOFw=;
        b=ReWCfjFhhlA4kzXJsKA6z8n3PzX8kfoIG+aZf/9n5HaqtWtUIy5+GnoWXPU9npYdhvSh/V
        9NAB+LBG7RYjezi+dxztJ9fIAfHcKd/2ayBq5YMHez8cAweu6cypnUqvwskwbVzr+tSX3m
        ul+an4P9a2YyBLFsa7xy9RK35/km9tg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-7PiBXBLAMzS7btM6W--Jhg-1; Thu, 06 Apr 2023 03:50:41 -0400
X-MC-Unique: 7PiBXBLAMzS7btM6W--Jhg-1
Received: by mail-qv1-f70.google.com with SMTP id a10-20020a0ccdca000000b005d70160fbb0so17495679qvn.21
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 00:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680767441;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zfpt1hWlJeW+De1zXUq58qE//gZcupovgtklglmgOFw=;
        b=WVtmQKgw8eu45g7a/KsjXDyiv9hYnnFn9T62qlbri1tWZ/xnHzpaxLWnsoShIjL8At
         CWQUODm/QiK5a3bz090rNbDhw9wlsg7CnWrfA4+X/LwNnZZ2ERXy+oS00kj8j4kYMeYZ
         Kqrjc8f0edkM3Z6pRn3jWpcBGrPVImDWgm44VG1ss7MQJkAGc94O+/W4l0xs03Uuho/m
         FLLCalga1GK/RmmvyCxSRBX1jMi5aGe+NwJtPsYjZFNDlN3zNs4cflnsEvsFKq7QBsRp
         ecar5upqhlf7rZajr3y84CnFdnTdzPFBBHUj9hgMyoggCzo09oSJ6JecOS1BbqMW0yGR
         XdiA==
X-Gm-Message-State: AAQBX9e5kwAmizdUqkM3iwhtYbZBatp+5ko52AW6o0KwaGtNAwPDhB23
        2OeSHTbbsNsqB2AjyCoEpO0HW9wUmG7QYO2H0VYhH6BC0gKdjKK785CMqdrJJno3GD7MoSnXG25
        5EDSfigInJmhPmLv/Oyooa1E=
X-Received: by 2002:a05:6214:19c3:b0:5a5:b269:bfd7 with SMTP id j3-20020a05621419c300b005a5b269bfd7mr3536295qvc.8.1680767441138;
        Thu, 06 Apr 2023 00:50:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350aOTMeFA6L3L3kDCyW2m/d0fTHZIJmC7P+sa1stPv6snl6xCxTWIR0yTmfZxFMazbqwU1fSEQ==
X-Received: by 2002:a05:6214:19c3:b0:5a5:b269:bfd7 with SMTP id j3-20020a05621419c300b005a5b269bfd7mr3536276qvc.8.1680767440725;
        Thu, 06 Apr 2023 00:50:40 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-178-193.web.vodafone.de. [109.43.178.193])
        by smtp.gmail.com with ESMTPSA id 65-20020a370c44000000b00746777fd176sm297041qkm.26.2023.04.06.00.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 00:50:40 -0700 (PDT)
Message-ID: <3cccc7e6-3a39-b3b4-feaf-85a3faa58570@redhat.com>
Date:   Thu, 6 Apr 2023 09:50:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 10/10] hw/s390x: Rename pv.c -> pv-kvm.c
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Hildenbrand <david@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-11-philmd@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230405160454.97436-11-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/04/2023 18.04, Philippe Mathieu-Daudé wrote:
> Protected Virtualization is specific to KVM.
> Rename the file as 'pv-kvm.c' to make this clearer.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/s390x/{pv.c => pv-kvm.c} | 0
>   hw/s390x/meson.build        | 2 +-
>   2 files changed, 1 insertion(+), 1 deletion(-)
>   rename hw/s390x/{pv.c => pv-kvm.c} (100%)
> 
> diff --git a/hw/s390x/pv.c b/hw/s390x/pv-kvm.c
> similarity index 100%
> rename from hw/s390x/pv.c
> rename to hw/s390x/pv-kvm.c
> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
> index f291016fee..2f43b6c473 100644
> --- a/hw/s390x/meson.build
> +++ b/hw/s390x/meson.build
> @@ -22,7 +22,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
>     'tod-kvm.c',
>     's390-skeys-kvm.c',
>     's390-stattrib-kvm.c',
> -  'pv.c',
> +  'pv-kvm.c',
>     's390-pci-kvm.c',
>   ))
>   s390x_ss.add(when: 'CONFIG_TCG', if_true: files(

Hmmm, maybe we should rather move it to target/s390x/kvm/ instead?

Janosch, what's your opinion?

  Thomas

