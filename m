Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC825816AC
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 17:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiGZPnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 11:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239077AbiGZPnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 11:43:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C809C2C677
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658850211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y6NYfeTb550US7mev7AopaFJdf46Ahr+jvda49+lmqU=;
        b=KQj9cPHv1sTDyAihg0eMOJVHH0/e6Lpbf2cjcD9d4xaRUoi3dmPo9JXz+nzTvzMcekHA1r
        FcgQSfL5bg7y8ObhEQb3Sxdhx1PqS6XncJL16b88UQaPxI+GfUcQ6aMtScaADUi/SByXHk
        RPOc61c5WC4WfxFvuxhY9TjzOtbVo+4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-_PgzdNwhNMOHdx_jcYH0tg-1; Tue, 26 Jul 2022 11:43:30 -0400
X-MC-Unique: _PgzdNwhNMOHdx_jcYH0tg-1
Received: by mail-ed1-f72.google.com with SMTP id z1-20020a05640235c100b0043bca7d9b3eso8104215edc.5
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:43:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y6NYfeTb550US7mev7AopaFJdf46Ahr+jvda49+lmqU=;
        b=GBE9No3pGocTVcRETn9vbxDpmIrLyrmJEKcqA73ocJI8zB6wkzhQNvDY2xj5AhGNKD
         dB2MP/OGgfWiWgRphA1Sd83ScKd8W8/BRaEKekY9eERpZSbZDJIIShI5+7r0sBsJ+YTQ
         tQI53Fft+/wjv1cPkKQsOyZuG57f7HpvnFjOPKnmnCPyBLBTzs1EeW8CZH+t+uKn+kg8
         Yp8tQI2bEE2UzA4aOUP6ImVk3VyZ9AyXTFURD47PAmH221QO1JeBfEemNDyN6p/xLAr1
         7SYfI5X7IyjWDj1fdJYj6OEMwF62BRB1iA3BxXsRrHdf1DI0zCzOXw62EcMa7MSNwSsM
         Zs2Q==
X-Gm-Message-State: AJIora8y/aHbmbuLmBdoPVAgVAPwX+0d9v5y++KmPQAl6yTpfV7H5khS
        9kscWJkPsHIYbrHuKQaRLfQbzXTS1/G1FZBBMMvu5TlVJGDtMCo5yJAH8Ue1OFoK9FlZ98KiG31
        4lN/MATutvjYp
X-Received: by 2002:a05:6402:331c:b0:43b:c62e:24dd with SMTP id e28-20020a056402331c00b0043bc62e24ddmr18559313eda.325.1658850209304;
        Tue, 26 Jul 2022 08:43:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tfsDx5b8T5x9hwqArzic0Fuj5fMOp55zpv2kn2x2FQaclY40VE6p07BBhvL07U9oisoulw4g==
X-Received: by 2002:a05:6402:331c:b0:43b:c62e:24dd with SMTP id e28-20020a056402331c00b0043bc62e24ddmr18559278eda.325.1658850208849;
        Tue, 26 Jul 2022 08:43:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id x4-20020aa7dac4000000b0042617ba638esm8699374eds.24.2022.07.26.08.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 08:43:28 -0700 (PDT)
Message-ID: <ffc99463-6a61-8694-6a4e-3162580f94ee@redhat.com>
Date:   Tue, 26 Jul 2022 17:43:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: x86: enable TDP MMU by default
Content-Language: en-US
To:     Stoiko Ivanov <s.ivanov@proxmox.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bgardon@google.com
References: <20210726163106.1433600-1-pbonzini@redhat.com>
 <20220726165748.76db5284@rosa.proxmox.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220726165748.76db5284@rosa.proxmox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/26/22 16:57, Stoiko Ivanov wrote:
> Hi,
> 
> Proxmox[0] recently switched to the 5.15 kernel series (based on the one
> for Ubuntu 22.04), which includes this commit.
> While it's working well on most installations, we have a few users who
> reported that some of their guests shutdown with
> `KVM: entry failed, hardware error 0x80000021` being logged under certain
> conditions and environments[1]:
> * The issue is not deterministically reproducible, and only happens
>    eventually with certain loads (e.g. we have only one system in our
>    office which exhibits the issue - and this only by repeatedly installing
>    Windows 2k22 ~ one out of 10 installs will cause the guest-crash)
> * While most reports are referring to (newer) Windows guests, some users
>    run into the issue with Linux VMs as well
> * The affected systems are from a quite wide range - our affected machine
>    is an old IvyBridge Xeon with outdated BIOS (an equivalent system with
>    the latest available BIOS is not affected), but we have
>    reports of all kind of Intel CPUs (up to an i5-12400). It seems AMD CPUs
>    are not affected.
> 
> Disabling tdp_mmu seems to mitigate the issue, but I still thought you
> might want to know that in some cases tdp_mmu causes problems, or that you
> even might have an idea of how to fix the issue without explicitly
> disabling tdp_mmu?

If you don't need secure boot, you can try disabling SMM.  It should not 
be related to TDP MMU, but the logs (thanks!) point at an SMM entry (RIP 
= 0x8000, CS base=0x7ffc2000).

This is likely to be fixed by 
https://lore.kernel.org/kvm/20220621150902.46126-1-mlevitsk@redhat.com/.

Paolo

