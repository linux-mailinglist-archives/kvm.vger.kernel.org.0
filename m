Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBF2647F1A
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 09:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiLIIR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 03:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiLIIRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 03:17:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5066D5E3D8
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 00:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670573814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mlVkey4HSjl2vV6t9Lx9uOWqOaugTBfPTR5asZdKNaU=;
        b=Zs+99kE27ODNtMazKjowP3Uiramnsob1/POUB6SNwIRqvYBEZVXYq4vkepRLqiy0vMA9AC
        agEyHfzSsmUE/wWu4ObpCTC0A2kY9zKyoUYpeWv3rr824QMdtkzYxQkg0QhsFpGq5d+Fw0
        2jy819B0JkQcnc0yo9lf37uRdYu6lXw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-468-KFZWIw6ZNUO55sUb8oZUeA-1; Fri, 09 Dec 2022 03:16:53 -0500
X-MC-Unique: KFZWIw6ZNUO55sUb8oZUeA-1
Received: by mail-ej1-f72.google.com with SMTP id sc5-20020a1709078a0500b007c0ca93c161so2626053ejc.7
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 00:16:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mlVkey4HSjl2vV6t9Lx9uOWqOaugTBfPTR5asZdKNaU=;
        b=4EfkDXLPjprY0NlzdDzmVOMgNatuY8AKLnjsMzEedl++OHbxOK4CMX5NpC3RjzJ1Gw
         mY/uHnue3/cK6bYqtazXC3+fphDAxbX+DGoVhN+gwAJKSmDUUAGX6FhXr7D3cYUBS0Wk
         NckndRhesgncTVmogwAUhiHnyxoyxbqT7CyBr18KJsH7+IIgoNOAt3iOGSgMPKgQNiZ1
         L1V6Sjfe5ebErOdXfiMzBHLDq0yMPV2E//E8VMnYxZhui5Mns5lcah4VIzZPQrBq2LE/
         MbX7y9n2TwOyapV8uQ+oSCjnPZwygrwvYkL2N1O57/73UEJ61vLy/3MiQ1q0RFkjlQSn
         7ysA==
X-Gm-Message-State: ANoB5pkOGDgCAjdKETfN9xJGl1tqbd6dR5tU90MPrFh2cJISVY0x3EOF
        uYydfywH6kDtgCtZPE+/caGpgXwaD0dxmBAIZ7ml4Bk3B9FKqfOUnnkhyL61M33/5MYtgo4QKo7
        vMXugDg7VHb+V
X-Received: by 2002:a17:906:5283:b0:78d:f454:ba16 with SMTP id c3-20020a170906528300b0078df454ba16mr4623105ejm.21.1670573812090;
        Fri, 09 Dec 2022 00:16:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5wWcuD3cuTP1HHb5J1FFJS7MF//CMRuYbka2YADU0Y5oKZopzpSPP25NgDP/gUc0Ss8veizQ==
X-Received: by 2002:a17:906:5283:b0:78d:f454:ba16 with SMTP id c3-20020a170906528300b0078df454ba16mr4623096ejm.21.1670573811890;
        Fri, 09 Dec 2022 00:16:51 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id o26-20020a170906769a00b007adaca75bd0sm271346ejm.179.2022.12.09.00.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 00:16:51 -0800 (PST)
Message-ID: <28d6ff21-8335-9cf6-6937-992c93bfdd33@redhat.com>
Date:   Fri, 9 Dec 2022 09:16:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM/riscv changes for 6.2
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy0qihfFCXTV-QUjP-5XiQQqBC4_sP-swx77k6PC3uTmmw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy0qihfFCXTV-QUjP-5XiQQqBC4_sP-swx77k6PC3uTmmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/22 11:33, Anup Patel wrote:
>    https://github.com/kvm-riscv/linux.git  tags/kvm-riscv-6.2-1

Pulled, thanks.

Paolo

