Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60275E819F
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 20:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiIWSO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 14:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiIWSO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 14:14:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B78236784
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663956892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xlpsA1hVsAoy9jBxMFE7nv+cMfSPTOZYBG8PCVZGKL8=;
        b=J2jZKhgas5hJ53W/w3TMicvumDl1Yiv1Lm5Q4IMqCewnXpqu4zMWLqG7OPtUtTi+6IfOvx
        zYC1Ng5Xx6BlonZcR3aBtF+LZF+Ix9xQ6DXRcKOcy10PdO3NztlUeZxynLv8LjQwafOMWQ
        mWVKDE+fqkb/MuKxOjeUOXSQ3hO4dB4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-589-itBFQXQEMQGCYYXXLHILfA-1; Fri, 23 Sep 2022 14:14:50 -0400
X-MC-Unique: itBFQXQEMQGCYYXXLHILfA-1
Received: by mail-wm1-f69.google.com with SMTP id r7-20020a1c4407000000b003b3309435a9so2667936wma.6
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=xlpsA1hVsAoy9jBxMFE7nv+cMfSPTOZYBG8PCVZGKL8=;
        b=tY6hSQ/o1+f1bqbrcYVVqyFwIHH0esainUywr9hWi2nzuH8h/mDGzwGNUrLm5VqsMm
         8F6bdOfg+rR7pB8v271gC8HVKo3nQ/QHJwpBrOg8Z4gt1+DyTDxST7qaitF/vf/6Ir+W
         mcPFeDQiz57bd+4Ec19l0WuykACI9cnyBmGw6wJlPXpMqsmyIKENPbGc+MuEUz5VhNO/
         qn1qJGWruV9FxGliqu4oW2YnNcqiBuARlyNsyjsRYzFXSkGHXj442YbZSpxupQk5r/xh
         CMgL6i4VrmaAkuZLfJ4gV8tb6R3/rf7SbJpQ6J6JIrd5eYWwLgGQ3KgwXvUiIZm7Hxhu
         AAbQ==
X-Gm-Message-State: ACrzQf3MGd93VKVnDXmPYp5X+IrrLAwjVN3o9w2dsiABenzSIRNVvvII
        sykHtPbLWyxjGd7LmH0UZclfqRxOqUgwRY9sW4xixpNsK/OqoE1A8uKVKeLmdNAbvdq0QDVA88l
        6OWdpzQpUaIHf
X-Received: by 2002:adf:f911:0:b0:21e:c0f6:fd26 with SMTP id b17-20020adff911000000b0021ec0f6fd26mr5978815wrr.361.1663956889746;
        Fri, 23 Sep 2022 11:14:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM66NypFqpfKGADDGoJyIEOtRO5ige+1TpLluYDTcbS7M5oV76CxDKtlUBV4OPgiyPPGazx8+Q==
X-Received: by 2002:adf:f911:0:b0:21e:c0f6:fd26 with SMTP id b17-20020adff911000000b0021ec0f6fd26mr5978798wrr.361.1663956889503;
        Fri, 23 Sep 2022 11:14:49 -0700 (PDT)
Received: from [192.168.8.103] (tmo-097-189.customers.d1-online.com. [80.187.97.189])
        by smtp.gmail.com with ESMTPSA id x8-20020adff0c8000000b00228c483128dsm9309204wro.90.2022.09.23.11.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 11:14:48 -0700 (PDT)
Message-ID: <1bfedded-d245-f842-e793-c078fbab8947@redhat.com>
Date:   Fri, 23 Sep 2022 20:14:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v8 3/8] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
 <20220902172737.170349-4-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220902172737.170349-4-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/2022 19.27, Matthew Rosato wrote:
> If the ZPCI_OP ioctl reports that is is available and usable, then the
> underlying KVM host will enable load/store intepretation for any guest
> device without a SHM bit in the guest function handle.  For a device that
> will be using interpretation support, ensure the guest function handle
> matches the host function handle; this value is re-checked every time the
> guest issues a SET PCI FN to enable the guest device as it is the only
> opportunity to reflect function handle changes.
> 
> By default, unless interpret=off is specified, interpretation support will
> always be assumed and exploited if the necessary ioctl and features are
> available on the host kernel.  When these are unavailable, we will silently
> revert to the interception model; this allows existing guest configurations
> to work unmodified on hosts with and without zPCI interpretation support,
> allowing QEMU to choose the best support model available.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/meson.build            |  1 +
>   hw/s390x/s390-pci-bus.c         | 66 ++++++++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-inst.c        | 16 ++++++++
>   hw/s390x/s390-pci-kvm.c         | 22 +++++++++++
>   include/hw/s390x/s390-pci-bus.h |  1 +
>   include/hw/s390x/s390-pci-kvm.h | 24 ++++++++++++
>   target/s390x/kvm/kvm.c          |  7 ++++
>   target/s390x/kvm/kvm_s390x.h    |  1 +
>   8 files changed, 137 insertions(+), 1 deletion(-)
>   create mode 100644 hw/s390x/s390-pci-kvm.c
>   create mode 100644 include/hw/s390x/s390-pci-kvm.h

Looks sane to me.

Acked-by: Thomas Huth <thuth@redhat.com>

