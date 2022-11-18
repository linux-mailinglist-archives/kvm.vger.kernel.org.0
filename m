Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21F262FC4C
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 19:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242573AbiKRSRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 13:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242567AbiKRSRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 13:17:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8CD898F4
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 10:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668795401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tcZyfCjhGB+86VTTi39yHttoDg1tfElgyWJYE0q/xYg=;
        b=cbTgzj+sA2NYsk3nREbJuM/sgYZrn5Uy2sLvunTjPtOXKmL8116gCzvEeSAzzJRzqdST+y
        phVNDxv5QYRDNAmmce83ze+1pfgL97aTqYNmi/JcBeoSwh1ic2RVtWj8TcErVMlUP5aRB1
        sU+ZwyXDvDv+HLijryOOy1+IWxiEDzY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-o6PvmA03PRSPfC4zcl2c-w-1; Fri, 18 Nov 2022 13:16:40 -0500
X-MC-Unique: o6PvmA03PRSPfC4zcl2c-w-1
Received: by mail-wr1-f70.google.com with SMTP id l1-20020adfa381000000b0024184dfcb5eso1865352wrb.21
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 10:16:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tcZyfCjhGB+86VTTi39yHttoDg1tfElgyWJYE0q/xYg=;
        b=h4/wTBwAKjtLbSBMMISY3gMjCt6cvhRUgkyh5SUKTRGPYkCBgrz3mDf5v5o8RgkxmW
         IzcdF7qsgSnCUYDrWsTCnO0fYcdde99EczYBEs6vlIDNCwk6HqQDZHTMFuFrYp0UJR1G
         T2rhM9QekNwZ8x23DAuG31CrcavnOdPAtfJAnAHnsKNGxZko0Y3zL+hlStl79zkmCChK
         NIBmEAVcHPaychmBklsskTyrwiq0wv7iL+NgwuwlJrGsKMQ3XMoIv0P+qCWSt7ivXxQs
         8fAERu9SqwvFUblxS0P2Wr9Q1HvM+NPGJcWCmrUMSAcyLbJIpNJWz8znLLI04IhdEkN7
         JbBQ==
X-Gm-Message-State: ANoB5plpV+1tsigftTCSIMQGktxsvvfLjQ0SWfhvXaq2KgRCmYNjeb4N
        jrQWNOx4R9Sm8GwQIDgbnOyOWzYHGwiPNPdcmgVv16n0EYS4vKFHFY/Eu2VlgfUmPEOSVu9NEVN
        tLKWAv3wdkzUzB7fMy8PWFNlpN+TcxgPWiTteWsVWEercPb5FaLC22xfG66J14Zb3
X-Received: by 2002:adf:de0f:0:b0:241:c224:1f95 with SMTP id b15-20020adfde0f000000b00241c2241f95mr2474499wrm.671.1668795398145;
        Fri, 18 Nov 2022 10:16:38 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6OaBmTpfEsqjkDvdbNLPVjcZGjUgmkb9kJvv7cWDrvVC1gh2O88AlZ6sJYq0KoQ1exPgvqcQ==
X-Received: by 2002:adf:de0f:0:b0:241:c224:1f95 with SMTP id b15-20020adfde0f000000b00241c2241f95mr2474484wrm.671.1668795397858;
        Fri, 18 Nov 2022 10:16:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 6-20020a05600c024600b003b50428cf66sm5048454wmj.33.2022.11.18.10.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 10:16:37 -0800 (PST)
Message-ID: <89e2e3f9-ad89-3581-4460-f87f552d08a5@redhat.com>
Date:   Fri, 18 Nov 2022 19:16:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-US
To:     KVM list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: KVM 6.2 state
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


These are the patches that are still on my list:

* https://patchew.org/linux/20221105045704.2315186-1-vipinsh@google.com/
[PATCH 0/6] Add Hyper-v extended hypercall support in KVM

* https://patchew.org/linux/20221019165618.927057-1-seanjc@google.com/
[PATCH v6 0/8] KVM: x86: Apply NX mitigation more precisely

* https://patchew.org/linux/20221004093131.40392-1-thuth@redhat.com/
[RFC PATCH 0/3] Use TAP in some more KVM selftests

* https://patchew.org/linux/20221012181702.3663607-1-seanjc@google.com/
[PATCH v4 00/11] KVM: x86/mmu: Make tdp_mmu a read-only parameter

* https://patchew.org/linux/20221001005915.2041642-1-seanjc@google.com/
[PATCH v4 00/32] KVM: x86: AVIC and local APIC fixes+cleanups


Of which only the last one *might* be delayed to 6.3.

Sean, if you have anything else feel free to collect them yourself and 
send a pull request.

Paolo

