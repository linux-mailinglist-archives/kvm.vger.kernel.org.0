Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65237470AA
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 14:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjGDMRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 08:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjGDMRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 08:17:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC188E70
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 05:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688472982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YIXfzZjsdVt8vvfchF5Qn1Sl+Sb+f/LHZzCge3DWDPE=;
        b=Lo67/PcaOexquWfs0Z3M5QzgFSD5FwCeHqhQWwH+kApHH/Xrd451Uckb/5Dr6/A5rPyEgS
        Y/ZIiKGBxc0gkTvYpWLpevccyRgDQc7jG1bXwbYgIkVMRiYad0V8vG4AN3zVTo8mwSQt4b
        g85X+yCOV1i0vU09ccMyISysI3rKsL0=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-YOHFo_ShNFqk1X6pX-K9Ng-1; Tue, 04 Jul 2023 08:16:21 -0400
X-MC-Unique: YOHFo_ShNFqk1X6pX-K9Ng-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-39cb2a0b57aso4770380b6e.1
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 05:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688472980; x=1691064980;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YIXfzZjsdVt8vvfchF5Qn1Sl+Sb+f/LHZzCge3DWDPE=;
        b=hwC4d55lEgwl6QsOf2QO0zMYw49Y/DL4KAfs5pkKSah/ZFEXX2aYCK5NixRWNoNXY8
         Y50LSy6nlOZCk6A+57M68hUMVvF5dqFSwP7qtkVCpE1zcGWLa1rkVArfl6/X/nXLzUaO
         sVwrn399UIepPb7o89Vzkug7FN1NAP7EEt/2AlDMpzQk4YqDSBAQsI2EGXGACOYIw0Up
         qvAqymDZvP3U6DVAsLFjfuz0dvT+/6XxEIKbWBmzWklLep9EvzaL9DnFQ7PqAWrqjYHI
         T0p3jVyI+lYeW5GFbWqxPZi2qeI7UiwyAl6BOxQa2rMWQADCr3fMbSvsbAJ3YPd0mTof
         W/Tg==
X-Gm-Message-State: AC+VfDz9pjJ7eIwIulVuOf4atqzHsHlMf7xn4Tfv6oFZTgX9rKkDi7OD
        OVDJs+Cb/O9bdB4X2i3rZah4jfMteDhvbAO34Ze7IRe/AB2F/qNTCnafJ9JchCIg0X8+2pXWLoA
        UmPmVcR6DNFoY
X-Received: by 2002:a05:6808:2a83:b0:3a3:6576:f31b with SMTP id fc3-20020a0568082a8300b003a36576f31bmr9794646oib.36.1688472980381;
        Tue, 04 Jul 2023 05:16:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ62AHFVi349eOottfwQKI1ADJu/ofloNDCL3+OXJkcHbdoOoYm5j7T6tdVHgGJsNtprjihKwQ==
X-Received: by 2002:a05:6808:2a83:b0:3a3:6576:f31b with SMTP id fc3-20020a0568082a8300b003a36576f31bmr9794623oib.36.1688472980098;
        Tue, 04 Jul 2023 05:16:20 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-179-126.web.vodafone.de. [109.43.179.126])
        by smtp.gmail.com with ESMTPSA id g10-20020ad4510a000000b0063623c266easm6309903qvp.3.2023.07.04.05.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 05:16:19 -0700 (PDT)
Message-ID: <ab53c709-964b-452e-9cb2-c4c8d67d318f@redhat.com>
Date:   Tue, 4 Jul 2023 14:16:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 06/20] s390x/cpu topology: interception of PTF
 instruction
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-7-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
> When the host supports the CPU topology facility, the PTF
> instruction with function code 2 is interpreted by the SIE,
> provided that the userland hypervisor activates the interpretation
> by using the KVM_CAP_S390_CPU_TOPOLOGY KVM extension.
> 
> The PTF instructions with function code 0 and 1 are intercepted
> and must be emulated by the userland hypervisor.
> 
> During RESET all CPU of the configuration are placed in
> horizontal polarity.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>   include/hw/s390x/s390-virtio-ccw.h |  6 ++++
>   hw/s390x/cpu-topology.c            | 54 ++++++++++++++++++++++++++++++
>   target/s390x/kvm/kvm.c             | 11 ++++++
>   3 files changed, 71 insertions(+)


Reviewed-by: Thomas Huth <thuth@redhat.com>

