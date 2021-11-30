Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10169463264
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 12:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbhK3Lc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 06:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbhK3Lc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 06:32:58 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43B7C061574;
        Tue, 30 Nov 2021 03:29:38 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g14so85339322edb.8;
        Tue, 30 Nov 2021 03:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4ZJYK5Pyg6M1OZI8R6OhktHvKj8jONfwxsgyqS7zKVw=;
        b=hS3xdsuhLh825Zy5CyXqy8kdkjallgGS9ThnPKsUscIhTlNXuE6CejEfZljPIGaRuS
         oc7ADJYJNccl+iIS+fb435+kT+Wo5w123ioG7scg6MMSsuz6aHhDoNbNX8jXCces5K0F
         PYjM4g+cfZ2gNNcIqQh/s9hcryBHhQBsIb49ziFJEAIx5EXi74/YY3XfzUiXOe18ECIo
         bu7Egs9Ck/npOx62zHI52FWVmY9ihQKPeevV9cXirPD/e+LgPMqRaWL+kLq51qPSTFOA
         wxTvZBWNXewy9P/5UDCdMpWexvKVyhoS29YHyJi/92EVrkOB80KkptXB1ZoBj2CZavVE
         mxxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4ZJYK5Pyg6M1OZI8R6OhktHvKj8jONfwxsgyqS7zKVw=;
        b=xTONBY5nwMsWrvwhuPxG8aLxc3FSYm2OaE8PyJvsqykWjePuvE8jp6ciD9lPpU3aiQ
         ktCYGCV3VEYJgdZmaJESegJxGTOY2oE0ZmBS79h+cLuh2U/66enfMu/sNQd3I3AwI/Gc
         Tv1L5mIh//PCvNh3rXFO7C7WCUn7+2G9moTRJDKFeM8yNT234t+t22uoBULuxWbfHdK5
         dqHLLEOoFiGaT7YxG6uqszGYUhRzwV2XUXVK56+YiamjB+t5J6Rnd38TeXo5B0FLlAd1
         MhYG6l0M2Zo2ASDlTxm+bYIsheQnZsj+4yYsOcV4bQHn7VxUm1RL4B57X1aSJ6PgpQ65
         UxhA==
X-Gm-Message-State: AOAM531141JdUtFgWB3UjEkvtasMeemuo+Rs/A2bisbehlWHxaiY0Opy
        M2TmF/BveIXzMAb65wHZLPGm/kGbDT4=
X-Google-Smtp-Source: ABdhPJxWSSekJtGQrdd4lB7tQwJ9KjEr5N4mPYhMxXVyQrmrgXJrf5XZQFVeleF2doedUDkfSYSvQQ==
X-Received: by 2002:a17:906:1697:: with SMTP id s23mr68766522ejd.60.1638271777525;
        Tue, 30 Nov 2021 03:29:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id he14sm8981167ejc.55.2021.11.30.03.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 03:29:37 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <df9d430c-2065-804b-2343-d4bcdb7b2464@redhat.com>
Date:   Tue, 30 Nov 2021 12:29:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 27/28] KVM: x86/mmu: Do remote TLB flush before dropping
 RCU in TDP MMU resched
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-28-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211120045046.3940942-28-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/21 05:50, Sean Christopherson wrote:
>   	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
> -		rcu_read_unlock();
> -
>   		if (flush)
>   			kvm_flush_remote_tlbs(kvm);
>   
> +		rcu_read_unlock();
> +

Couldn't this sleep in kvm_make_all_cpus_request, whilst in an RCU 
read-side critical section?

Paolo
