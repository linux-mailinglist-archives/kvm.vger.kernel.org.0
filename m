Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBF1588CE2
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiHCNW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbiHCNW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:22:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0B5B19C31
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659532976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r+gknjCfxt0fEOnt+pVR0+jPvwgnjQqFJO2CdOTgi0A=;
        b=SKmQPvD7Hi+SkHNTWyCTcK4BVzl85qbLGS33wujAyrCOQbCwWjXT20tTcjDfnIjIrX4UFD
        Y6vN8hLYYwDmykGlCaA8AuAUDrTYlqi9VUPj+YhoqWSlkl8PpoR+2Lb6HP4K4ZgAE4iwHc
        Bv0hH973SOygfP15QzoiPdEJMS9N7kQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-P379gEKiNyqF0pUR8HMjRw-1; Wed, 03 Aug 2022 09:22:55 -0400
X-MC-Unique: P379gEKiNyqF0pUR8HMjRw-1
Received: by mail-ed1-f71.google.com with SMTP id h6-20020a05640250c600b0043d9964d2ceso5860070edb.4
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 06:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=r+gknjCfxt0fEOnt+pVR0+jPvwgnjQqFJO2CdOTgi0A=;
        b=ik1kNGsXs+ujZ9lx6tRWuGTAfsa4M746FY2DVd5bGfU/8nCK88eWFdTmmCtHLZpUKr
         HL6zE341333wh5zqmBcdM8R6qC6Iojdq1vuZHYw/ajcOAgMnK0Kgs6dB79HcJI+qGSFF
         U7QNf6jbtSNICGKyqQlP/OwUXJY7+wiI4adgANeiKkE+YcWOeDAUHFAk9iD/vLlBl2dW
         dwjbk1nTQeUii+kDvrvY1Gk4ngu4hUKmrAUsq4nuhq5LuPVODQZ9F9uj6oLInPtpvPx5
         Yot9a2K1l6ZyU9ACJliCJc0QXJb/tH0GjzeBSoIr8nhRg+PHKVVC0CcXRs9xZr2vg60h
         NRQw==
X-Gm-Message-State: ACgBeo0gdI0vHs+HJw+q6oz3U0KjrUJnljw/iVIqUXlhJ27pf3NI8vMv
        gL/uH4YyvOKQocaLSoOlqKIoO4SLOP87DoykSYG/pPl4sfxPSFbfb6OVwcZGv74OhotDYkURx3I
        n2jb6OiQTRklJ
X-Received: by 2002:a17:907:2da6:b0:730:8b30:e517 with SMTP id gt38-20020a1709072da600b007308b30e517mr11135809ejc.291.1659532974347;
        Wed, 03 Aug 2022 06:22:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7QXzIvyo5JHfdTWJxkKXD5/xn7PyCYwfwoPD1cdJzUdavBBqrMT6feXNS0/L/XKVI9iTydcQ==
X-Received: by 2002:a17:907:2da6:b0:730:8b30:e517 with SMTP id gt38-20020a1709072da600b007308b30e517mr11135794ejc.291.1659532974112;
        Wed, 03 Aug 2022 06:22:54 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f14-20020a17090631ce00b006f3ef214daesm7263746ejf.20.2022.08.03.06.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 06:22:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 33/39] KVM: selftests: nVMX: Allocate Hyper-V
 partition assist page
In-Reply-To: <YtnGd4OT3FQJ75b8@google.com>
References: <20220714134929.1125828-1-vkuznets@redhat.com>
 <20220714134929.1125828-34-vkuznets@redhat.com>
 <YtnGd4OT3FQJ75b8@google.com>
Date:   Wed, 03 Aug 2022 15:22:52 +0200
Message-ID: <877d3p1mxf.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
>> In preparation to testing Hyper-V L2 TLB flush hypercalls, allocate
>> so-called Partition assist page and link it to 'struct vmx_pages'.
>> 
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  tools/testing/selftests/kvm/include/x86_64/vmx.h | 4 ++++
>>  tools/testing/selftests/kvm/lib/x86_64/vmx.c     | 7 +++++++
>>  2 files changed, 11 insertions(+)
>> 
>> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
>> index cc3604f8f1d3..f7c8184c1de8 100644
>> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
>> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
>> @@ -570,6 +570,10 @@ struct vmx_pages {
>>  	uint64_t enlightened_vmcs_gpa;
>>  	void *enlightened_vmcs;
>>  
>> +	void *partition_assist_hva;
>> +	uint64_t partition_assist_gpa;
>> +	void *partition_assist;
>
> Rather than duplicate this and other Hyper-V stuff, can you first add a struct
> to hold the Hyper-V pages, along with a helper to populate them?  I'd even throw
> in the eVMCS stuff, it's trivial for the helper to have a flag saying "don't bother
> allocating eVMCS".  That will give us an easier path to allocating these pages
> if and only if the test actually wants to enable Hyper-V stuff.

Good suggestion and a good excuse to do another refresh/rebase as this
apparently missed 5.20 merge window. 

v9 is coming to rescue!

-- 
Vitaly

