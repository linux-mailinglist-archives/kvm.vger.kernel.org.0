Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C587A3761FA
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhEGI3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 04:29:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50867 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236227AbhEGI3g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 04:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620376116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2EtsHTWG0I945KmFB2rvkJ4C7JnZYKjnyrdpp2fnzKI=;
        b=Tvs6A6rgIXHsJscr0c4asfndA9VQfPI/0Y1vMMvgh0Mb862IxMJ/auWC7Qh1TKrBmCeE1l
        gD9F1vuzUAZ3sJ1CGUWeWpBafulkCWAMp4X7u2ykn1PuU87+5/nWeJSvxOu3OsANQ6dQ/h
        JjKTe55jNBboV7dvGWySJA2szQdmFOU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-GaTnWfAsMY2ni3RRAtbb_Q-1; Fri, 07 May 2021 04:28:32 -0400
X-MC-Unique: GaTnWfAsMY2ni3RRAtbb_Q-1
Received: by mail-wr1-f70.google.com with SMTP id 91-20020adf94640000b029010b019075afso3254135wrq.17
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 01:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2EtsHTWG0I945KmFB2rvkJ4C7JnZYKjnyrdpp2fnzKI=;
        b=EMM3n4IrxV0i7X1RO4wumwLW2ZiwQbhNi1rckwal4TCQxoRouBYeLjXluJc++ayQNk
         FF5CEAr4NLBKtBRFdALlRIg/PlnqegkwIpnuC5I6ngUv8usvvb35wbC/tn7HUF3He+/+
         LBVSP+9s2nvOG6XcJIUhtJn9CKu+stlsHVc6AOZJnOr+72Hrsi0ewcAg6nzh1Y4vBjN3
         msaXjFBJ5rtYYmVX0yTgYt5zr03rJ4pZGTj3Ivn3HMIq6hSUWvFoLpflHg1zpIrYp8Y6
         tLetOCW50eWYgi2F9KLfcQtQtu27nKNG0InNyVtYhVrsozT5nAlqPKaIclxYWURyrXVX
         AAVA==
X-Gm-Message-State: AOAM533mb2L5WBm944XkswJ9ryqOjGEXka8cRtJfAhir9eQ0kjI+kFKV
        CtgV2PY0SgpsiRaQLNlTdBPQpCsUiQsZ9C5a/4gp9iMmjmPVe0D/PvHDSZ/ATC+SYpu7Gfz82JX
        HWZNjiiJmdk7Q
X-Received: by 2002:a1c:4e06:: with SMTP id g6mr8566096wmh.30.1620376111669;
        Fri, 07 May 2021 01:28:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7DglUp/7+aIhLhSphLrJcy6WZJYfjkEbPnKZcfDzBYJtlkC3FZlonDpDwsI35pPuGY73A3A==
X-Received: by 2002:a1c:4e06:: with SMTP id g6mr8566077wmh.30.1620376111514;
        Fri, 07 May 2021 01:28:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id l21sm12474008wme.10.2021.05.07.01.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 01:28:30 -0700 (PDT)
Subject: Re: [PATCH v3 5/8] KVM: x86/mmu: Add a field to control memslot rmap
 allocation
To:     Ben Gardon <bgardon@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-6-bgardon@google.com>
 <CANgfPd-eJsHRYARTa0tm4EUVQyXvdQxGQfGfj=qLi5vkLTG6pw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a12eaa7e-f422-d8f4-e024-492aa038a398@redhat.com>
Date:   Fri, 7 May 2021 10:28:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd-eJsHRYARTa0tm4EUVQyXvdQxGQfGfj=qLi5vkLTG6pw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/21 01:44, Ben Gardon wrote:
>>   struct kvm_vm_stat {
>> @@ -1853,4 +1859,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
>>
>>   int kvm_cpu_dirty_log_size(void);
>>
>> +inline bool kvm_memslots_have_rmaps(struct kvm *kvm);
> Woops, this shouldn't be marked inline as it creates build problems
> for the next patch with some configs.
> 

Possibly stupid (or at least lazy) question: why can't it be a "normal" 
static inline function?

Paolo

