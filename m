Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E984528709
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 16:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241574AbiEPO3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 10:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242415AbiEPO3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 10:29:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1EFAB3B3CE
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 07:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652711387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lPKKgGPBIO6GD4be1xmI2wen8ydvR/wU0Q/vm/10lOs=;
        b=JOQ6JStfVa4JydgtHdfPGOOiCUilHA4dL/EKQG4QYjKLbDt6WM5IsLWtDPldPaw83mp2ws
        lRptYZyqeW1D/atDT4vzfSFH6PzOnwsiuKbXhCml+eZqv8BRKA/J/8V3YPIuYkM9KPg7ii
        XLE4Ya8/sLY19TGNJDMxh9IlzR2c6pM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-OsJYEsXJOtm9ChvAgVRZ5g-1; Mon, 16 May 2022 10:29:45 -0400
X-MC-Unique: OsJYEsXJOtm9ChvAgVRZ5g-1
Received: by mail-wm1-f72.google.com with SMTP id m26-20020a7bcb9a000000b0039455e871b6so5718474wmi.8
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 07:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=lPKKgGPBIO6GD4be1xmI2wen8ydvR/wU0Q/vm/10lOs=;
        b=ZJ79r+z1Yjrz3BpTjawjq06qH0OrT72UVs5NqsGJc6Cuq/cGxifxKnHj+H14G0aNBm
         GTun93Fq56GE3JidPkpCQGhvw6K94JGyag9ww0xsVy2VmPOGKMw2r9jgdRuwfh3u5RUg
         105a30LkSOOgQM1K/NASkvgvGnIkO9eFTn8bynybRqgh7vDHFfv/O2f6Dz8IFKH7e0E2
         ZKp2rHCReWpcr746TVeczjLbmXFWTKhY1Ea5Ti6MH/IOVzYVN6hcUGppcbxr6HB5v/e9
         75NAR0duT4CkIeEovJM38JrBJci3tiBcYrBEt6LzSdMPNd2aqpOEli6Mu23woT7267d/
         Snpw==
X-Gm-Message-State: AOAM531zHBidfvJzCYyOLZJrmnHu8wyo/DnU9vm7YoWxU0tf9iJTBalX
        fzxObaneGj5wf3DvDdBLNgXg11Q/0xJYS45ZOYM6z1/VYpwb0DVv6bReCmED3FdJChFxd6t0UgO
        jG69+VgXyvY4k
X-Received: by 2002:a5d:67c3:0:b0:20d:a38:973a with SMTP id n3-20020a5d67c3000000b0020d0a38973amr3598035wrw.493.1652711384108;
        Mon, 16 May 2022 07:29:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlVZfPvmrQksgiXHuLPZaBseoDd467dEq/TuP4ebt9RoV/BkkODC8CydF44brExJtMDVMnPA==
X-Received: by 2002:a5d:67c3:0:b0:20d:a38:973a with SMTP id n3-20020a5d67c3000000b0020d0a38973amr3598009wrw.493.1652711383866;
        Mon, 16 May 2022 07:29:43 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m7-20020adfa3c7000000b0020d02262664sm5854977wrb.25.2022.05.16.07.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 07:29:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 02/34] KVM: x86: hyper-v: Introduce TLB flush ring
In-Reply-To: <fdcba8b4aed2956e9bfc92ada2170f481a85a362.camel@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-3-vkuznets@redhat.com>
 <fdcba8b4aed2956e9bfc92ada2170f481a85a362.camel@redhat.com>
Date:   Mon, 16 May 2022 16:29:42 +0200
Message-ID: <87y1z1v9d5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
>> To allow flushing individual GVAs instead of always flushing the whole
>> VPID a per-vCPU structure to pass the requests is needed. Introduce a
>> simple ring write-locked structure to hold two types of entries:
>> individual GVA (GFN + up to 4095 following GFNs in the lower 12 bits)
>> and 'flush all'.
>> 
>> The queuing rule is: if there's not enough space on the ring to put
>> the request and leave at least 1 entry for 'flush all' - put 'flush
>> all' entry.
>> 
>> The size of the ring is arbitrary set to '16'.
>> 
>> Note, kvm_hv_flush_tlb() only queues 'flush all' entries for now so
>> there's very small functional change but the infrastructure is
>> prepared to handle individual GVA flush requests.
>
> As I see from this patch, also the code doesn't process the requests
> from the ring buffer yet, but rather just ignores it completely,
> and resets the whole ring buffer (kvm_hv_vcpu_empty_flush_tlb)
> Maybe you should mention it here.
>
>
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 16 +++++++
>>  arch/x86/kvm/hyperv.c           | 83 +++++++++++++++++++++++++++++++++
>>  arch/x86/kvm/hyperv.h           | 13 ++++++
>>  arch/x86/kvm/x86.c              |  5 +-
>>  arch/x86/kvm/x86.h              |  1 +
>>  5 files changed, 116 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 1de3ad9308d8..b4dd2ff61658 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -578,6 +578,20 @@ struct kvm_vcpu_hv_synic {
>>  	bool dont_zero_synic_pages;
>>  };
>>  
>> +#define KVM_HV_TLB_FLUSH_RING_SIZE (16)
>> +
>> +struct kvm_vcpu_hv_tlb_flush_entry {
>> +	u64 addr;
>> +	u64 flush_all:1;
>> +	u64 pad:63;
>> +};
>
> Have you considered using kfifo.h library instead?
>

As a matter of fact I have not and this is a good suggestion,
actually. Let me try to use it instead of my home-brewed ring. I'll
address your other comments after that. Thanks!

-- 
Vitaly

