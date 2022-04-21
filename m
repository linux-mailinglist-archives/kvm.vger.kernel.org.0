Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE5050A6D0
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 19:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390632AbiDURRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 13:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390619AbiDURRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 13:17:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BDC549F29
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650561265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1YMKcSiA0LOgoG4cDHR7os5spSf2HROMrqJ1+238Lww=;
        b=cj0fzBHYl4qY6eYwpBOee9+Qmka1dtm0noXOISNgxRlSq/aYNsoi2veTYPwZRTLxxmCGRu
        43ecHb2GUvN5r35njLRQgS571QRJZ3F53RQ/E3NCyjFNnnIxDRmXny9+tMHVzY7r/IiqRv
        hJJmc0gTEx/eItYe0+w0IzhgGwMteAw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-4q7FdTSQM_2wQ4vq2ZixSg-1; Thu, 21 Apr 2022 13:14:24 -0400
X-MC-Unique: 4q7FdTSQM_2wQ4vq2ZixSg-1
Received: by mail-ej1-f72.google.com with SMTP id qk32-20020a1709077fa000b006eff51cd918so2775712ejc.19
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1YMKcSiA0LOgoG4cDHR7os5spSf2HROMrqJ1+238Lww=;
        b=MVVcVHQcBRKgrCPgZFl3peHY0YL3lZU6VpRz9OVzfKwSB6zlbg2lJYtR8KA/2f+uR6
         tZaRCIIsdUzf/D7g1fCPYsV0CUZUdF8RD1gmtCrNO5XQhw8+ztrWubHtsMQi5pDuJurE
         JFNQ4l3PQlUWL7LdfVkoA3YCKK+squPUWRR3RImAn3boQ/dr4TWPsVpiuZQqIWRuItIq
         IGAqYK2ApxqXY513G1OKum6G6E1ElvLLk2cZOGkigXzOPlj1AwP3P3CCdWPfGd2XsSeq
         UHS6vJ86rlWsK48ckBOILth5mWeg6eN4m0OSkMFElXXpd+0+5ReCvtC7TBEujEXppebO
         epUw==
X-Gm-Message-State: AOAM530pdWYhqZneUFY1UAnkGGu2M2okI++/w5IW4eNG73Y8Wc9QZgwZ
        PYYAnak199MrPWfXSPyBV6tRvbq4Fi/mbCaO5exlpmNB9wqHmlfhM4CrQYjYmugsl8uadhg2gDi
        ZZwPdU4FYtjrl
X-Received: by 2002:a17:907:7815:b0:6ce:5242:1280 with SMTP id la21-20020a170907781500b006ce52421280mr466142ejc.217.1650561263076;
        Thu, 21 Apr 2022 10:14:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjpxVRQrq2bmfsUTwiZkkocLi9PluIUEZjPLmqlLk+39bZSgQ5aZ8L7QdX/BJW0PyqWPmlIA==
X-Received: by 2002:a17:907:7815:b0:6ce:5242:1280 with SMTP id la21-20020a170907781500b006ce52421280mr466118ejc.217.1650561262828;
        Thu, 21 Apr 2022 10:14:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e12-20020a170906c00c00b006e66eff7584sm8022976ejz.102.2022.04.21.10.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 10:14:22 -0700 (PDT)
Message-ID: <b1b04160-1604-8281-4c82-09b1f84ba86c@redhat.com>
Date:   Thu, 21 Apr 2022 19:14:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: x86: add HC_VMM_CUSTOM hypercall
Content-Language: en-US
To:     Peter Oskolkov <posk@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Peter Oskolkov <posk@posk.io>
References: <20220421165137.306101-1-posk@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220421165137.306101-1-posk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 18:51, Peter Oskolkov wrote:
> Allow kvm-based VMMs to request KVM to pass a custom vmcall
> from the guest to the VMM in the host.
> 
> Quite often, operating systems research projects and/or specialized
> paravirtualized workloads would benefit from a extra-low-overhead,
> extra-low-latency guest-host communication channel.

You can use a memory page and an I/O port.  It should be as fast as a 
hypercall.  You can even change it to use ioeventfd if an asynchronous 
channel is enough, and then it's going to be less than 1 us latency.

Paolo

> With cloud-hypervisor modified to handle the new hypercall (simply
> return the sum of the received arguments), the following function in
> guest_userspace_  completes, on average, in 2.5 microseconds (walltime)
> on a relatively modern Intel Xeon processor:

