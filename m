Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F25358360
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhDHMiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:38:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhDHMiC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:38:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617885470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=69zA1bhHptdUoU8kGQcTxZKNjzEk/X7EQu4AbY435gw=;
        b=JgWb/lOOMHWA5V3U+B+xDkfP86hjxDxD7hYxCElBE2F2k/Zd8EszgoAdaD5CaPc7CabIT0
        xilmywEsPS+GK+Frhm0U/+Yo2dS8zx4Xx4cJbAewaBQQwOejCC8BCqVcQ1PAusr/q6yW0L
        JLUTB9JGrzRJ4LNbLhrEFSMoKtGs/eI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-E2_u2gCJN-6K0teRNKg49A-1; Thu, 08 Apr 2021 08:37:49 -0400
X-MC-Unique: E2_u2gCJN-6K0teRNKg49A-1
Received: by mail-ed1-f72.google.com with SMTP id i19so958315edy.18
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 05:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=69zA1bhHptdUoU8kGQcTxZKNjzEk/X7EQu4AbY435gw=;
        b=UTMkgJYPUGc3+rM6eXa26RnYD4SlyqACIg20uGQh2EU/jvrkqUUVHZCFNEyTXKlF3S
         J8nCASAEAzwcWT8Y5AlikDTBUZKE+IC4cx6vYtMxqgXnd8sbs2HQHo+MhORhoTIvT/a3
         v9vmrmxv7e3tm+fRDgJLDwYyYsQ/FP5Te5oIBxNSrO1peATD73iqiJZMDt13UQNw1WfV
         6XGX4Dpai+zsmVHIeXFSbSE9vU3HOsBpkPg2PHv7jGSJ1ZaDBwR3hAtNrfXApa1WOWp6
         jpKl6QvDdC/ji9N4TDYMjfctzyLvYZ82nAcYWyNpQ+/Bd7EExKmZB/IMvLXzFYAUpEVU
         fz3w==
X-Gm-Message-State: AOAM531qe3UwqtlRImNghNSrPVYytO08N54vjanCPzLY/qvsNNNNtchv
        vRq4ld9JMrffMKtmFq+3/R1qPA7NprhAglP7gGrnoLD9MSLMolucCwQuqk1zQDApdg14vz17R5I
        QEZQBi3jz9ueL
X-Received: by 2002:a05:6402:8d0:: with SMTP id d16mr11466698edz.188.1617885467876;
        Thu, 08 Apr 2021 05:37:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw76kziLfjbuXhsqlp1TrtaLd1hK1hbVJFzsqDBDTZxforS60mer4C1Apk6o11RACcFo9O6+w==
X-Received: by 2002:a05:6402:8d0:: with SMTP id d16mr11466668edz.188.1617885467742;
        Thu, 08 Apr 2021 05:37:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v8sm17388506edc.30.2021.04.08.05.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 05:37:47 -0700 (PDT)
Subject: Re: [PATCH 3/4] KVM: x86: kvm_hv_flush_tlb use inputs from XMM
 registers
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-4-sidcha@amazon.de>
 <87eefl7zp4.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <01fc0ac9-f159-d3df-6c8c-8f8122fe31ea@redhat.com>
Date:   Thu, 8 Apr 2021 14:37:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87eefl7zp4.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/21 14:01, Vitaly Kuznetsov wrote:
> 
> Also, we can probably defer kvm_hv_hypercall_read_xmm() until we know
> how many regs we actually need to not read them all (we will always
> need xmm[0] I guess so we can as well read it here).

The cost is get/put FPU, so I think there's not much to gain from that.

Paolo

