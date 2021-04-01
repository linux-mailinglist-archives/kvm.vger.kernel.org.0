Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48D63513BE
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 12:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhDAKho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 06:37:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233844AbhDAKhX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 06:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617273442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CwwpY9zbsR9wmWnWgRPCRzGvVQBCnRsTEtAa4NdFU5k=;
        b=ScnHDH9hunJq0jEW40aJ8NAd2Dlj4H/obNsQeyEQkUDgUFZSjWZDHf/JMcTM2WNqQOiRUJ
        WBx5FSr/G2eAmjtIzaBGWCobYKZvY95NmKp5pefboRcCxD9j6yBh85kwVc4ojGwVFBWGS0
        0cROoGMD0fF5Jl1v4vXyrSGJfZbK0SQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-viLBUHKDM_6jDgMl4aIS_A-1; Thu, 01 Apr 2021 06:37:20 -0400
X-MC-Unique: viLBUHKDM_6jDgMl4aIS_A-1
Received: by mail-ed1-f69.google.com with SMTP id k8so2608232edn.19
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 03:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CwwpY9zbsR9wmWnWgRPCRzGvVQBCnRsTEtAa4NdFU5k=;
        b=HAEYg43J3jIQLdBwf6cKh2HzBg/HpCUHT2ntA2BUc3P37FNF7aQEPNGsu9AJEFnTlb
         JEbYqrforBC8k0AZLfRWewuTt0vqmw0JYBVYX8xkeH8yZnrnkVMQ4czW2mZgdvgM7gMq
         1BoXhwIuD9eXEALDEhslIq3lDVimNWfmSNNlmtbSD8ivIYmeDjuqLzzOpyrFKkn0v+Dd
         cRgYrFOdt4U6RCOZlfSZ1OKQJ5E1m5cbspzzpR7P49FRGOUBi3F/NA3eECs95dhlmOK0
         Z+zzbrfa0vGBEdHaiCwuqFoo1dc82H5PfpX1Mr2VfrR9BCwOPiGGE+w1e0iIEgdM+xX5
         YQpQ==
X-Gm-Message-State: AOAM531z3ByooI9Lw+aEOXRMIUbRAncbUaBqewo+eQjqYW9no0DbVd4Z
        RBhQKkAilUV78XlZyzX7SkslxQl+Cp8vVxFhkTYD3GyGjbMFEPX87P9LfnCUzXUvZWQx8c3hwOD
        r3145j/QnVt9P
X-Received: by 2002:a17:906:73cd:: with SMTP id n13mr8138947ejl.535.1617273439666;
        Thu, 01 Apr 2021 03:37:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoUdSWV6alowEJjrB0ng3a9PHsGiuAok+cNZ5pAIf5wRLMsANMzn1JKnVF08lT4MhG1RqcJg==
X-Received: by 2002:a17:906:73cd:: with SMTP id n13mr8138926ejl.535.1617273439481;
        Thu, 01 Apr 2021 03:37:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id mc10sm2581695ejb.56.2021.04.01.03.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 03:37:18 -0700 (PDT)
Subject: Re: [PATCH 13/13] KVM: x86/mmu: Tear down roots in fast invalidation
 thread
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210331210841.3996155-1-bgardon@google.com>
 <20210331210841.3996155-14-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1055496-6da4-0652-a95c-f5b56748ca04@redhat.com>
Date:   Thu, 1 Apr 2021 12:37:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210331210841.3996155-14-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 23:08, Ben Gardon wrote:
> +/*
> + * Since kvm_tdp_mmu_invalidate_roots has acquired a reference to each
> + * invalidated root, they will not be freed until this function drops the
> + * reference. Before dropping that reference, tear down the paging
> + * structure so that whichever thread does drop the last reference
> + * only has to do a trivial ammount of work. Since the roots are invalid,
> + * no new SPTEs should be created under them.
> + */
> +void kvm_tdp_mmu_zap_all_fast(struct kvm *kvm)

Please rename this to kvm_tdp_mmu_zap_invalidated_roots.

Paolo

