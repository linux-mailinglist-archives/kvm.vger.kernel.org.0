Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7326CC1E6
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 16:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjC1ORd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 10:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbjC1OR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 10:17:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502CCAD3A
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 07:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680013005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=McVfL5jdOZS7kfAfgWz7ZBlWLPWSFJhKhjaCyPWzQL0=;
        b=gdYQ6GXGKV+mh7h/5Cq1L/5TXfXncQYaL+ZC0pluzvcfZDWgD+UbOYA4Vj3GZg9Y+z0dx6
        SQNMz2n9AUAFLgFMMQw7MZ8i5GBx2Qt1lbWQNJD4miuk/i57zM69isxwoqkTBT5DgyTXe3
        My/+XTtrLoLeGvRbrrPOBGX/qIRMCoY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-NRkW4P4YP0ue7KRgBJbNDw-1; Tue, 28 Mar 2023 10:16:41 -0400
X-MC-Unique: NRkW4P4YP0ue7KRgBJbNDw-1
Received: by mail-ed1-f69.google.com with SMTP id k30-20020a50ce5e000000b00500544ebfb1so17645907edj.7
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 07:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680012994;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=McVfL5jdOZS7kfAfgWz7ZBlWLPWSFJhKhjaCyPWzQL0=;
        b=3g0fxt3ucnPf6DgWEuuuoZJFyyLzY0GiixTw9wmgrISv2G2Gql6l4KNlLSYuWLuobl
         6E/WgA2CWmJ+AsPkpTXJSG2DNvtURc5c7rUo9Ajp1O2ZaPd05sU9C8HD0Er7rwf1o26v
         uGBYJq9a7fQPeKxjfOiRXik4oCbR/TJo4umypQoJ6JjfdjqqiDcFSksN+vyoaAywiV/V
         emrtY8JaRf8Ua7bK3A58Tul5HsF/IZTfOWTgCIU20VqZw6UmDtPkLaYgNL4iNr+qsxjX
         kd31i5H6fg5op4UuFx7c+wyKdMbEMVVWsvNEZaTBfm3sQUwKiaWyXse2tOVJW/l/pUim
         i1jw==
X-Gm-Message-State: AAQBX9dJ3bnEdkrK+v6VKPpXeTBLX1ZjuhgrbgWC1B/cKjg7qVQW+J8S
        yG197kMoeap622Z1JjwMxLC+D4Sr7JXkpXTL128tyUMQ2GIRsmKFToBdrQFpTY1/iw/LpLgKcRI
        HvfBIE0Ndwd5d
X-Received: by 2002:a17:906:5a43:b0:8aa:be5c:b7c5 with SMTP id my3-20020a1709065a4300b008aabe5cb7c5mr17112820ejc.41.1680012994692;
        Tue, 28 Mar 2023 07:16:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350aoU2aSW/2CIaXWA1zbjboShcLbK5aGfXZD89zPwYbyXrwZeU0E5CjgejUESFiorIvBi+i+dA==
X-Received: by 2002:a17:906:5a43:b0:8aa:be5c:b7c5 with SMTP id my3-20020a1709065a4300b008aabe5cb7c5mr17112786ejc.41.1680012994437;
        Tue, 28 Mar 2023 07:16:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id i11-20020a170906264b00b009255b14e91dsm15283127ejc.46.2023.03.28.07.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 07:16:33 -0700 (PDT)
Message-ID: <e142e2ac-2207-2d97-55b6-fb2ed0e9db89@redhat.com>
Date:   Tue, 28 Mar 2023 16:16:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PING PATCH v4 00/29] Add KVM LoongArch support
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/28/23 14:30, Tianrui Zhao wrote:
> Ping patch series, please help for reviewing the loongarch kvm patch
> set. Thanks very much.
> 
> This series adds KVM LoongArch support. Loongson 3A5000 supports hardware
> assisted virtualization. With cpu virtualization, there are separate
> hw-supported user mode and kernel mode in guest mode. With memory
> virtualization, there are two-level hw mmu table for guest mode and host
> mode. Also there is separate hw cpu timer with consant frequency in
> guest mode, so that vm can migrate between hosts with different freq.
> Currently, we are able to boot LoongArch Linux Guests.
> 
> Few key aspects of KVM LoongArch added by this series are:
> 1. Enable kvm hardware function when kvm module is loaded.
> 2. Implement VM and vcpu related ioctl interface such as vcpu create,
>     vcpu run etc. GET_ONE_REG/SET_ONE_REG ioctl commands are use to
>     get general registers one by one.
> 3. Hardware access about MMU, timer and csr are emulated in kernel.
> 4. Hardwares such as mmio and iocsr device are emulated in user space
>     such as APIC, IPI, pci devices etc.

Please check Documentation/virtual/kvm/api.rst and document the 
loongarch-specific parts of the API, in particular ioctls that have 
architecture-specific semantics (KVM_GET/SET_ONE_REG, KVM_INTERRUPT) and 
vcpu->run fields.

Code-wise what I could understand looked okay, I only made a suggestion 
on the handling of idle; thanks for going through the previous review 
carefully.

Paolo

