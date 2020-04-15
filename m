Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5831AAB03
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407872AbgDOOxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:53:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40877 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407867AbgDOOxf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 10:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586962413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K5aShlaM4L7LBpzpuTEwY9oR96TrokeSvhA+JevS168=;
        b=JjydEm3K+xWc2nEV5L+8ZaX23sdIouTvuMz7Cz8Jnjz/rI4L/lTo9gxWzUYQ3SdNzaVfVB
        HXFEUYXmezcWWbE9/5BnInA/OY6JigarzpKICa7rJe0chUEGgkEc8SSrnfL95BeewS0odx
        YNlOEuVHhO0ayg8j8tpzXNUx7miRg8k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-_kbU28PXMoynlXK5JzNlQw-1; Wed, 15 Apr 2020 10:53:32 -0400
X-MC-Unique: _kbU28PXMoynlXK5JzNlQw-1
Received: by mail-wr1-f69.google.com with SMTP id f2so33297wrm.9
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K5aShlaM4L7LBpzpuTEwY9oR96TrokeSvhA+JevS168=;
        b=Zw6tOF8IZGVD2Myxc08TwGftVVlhiIVOrnX0caxZUxgw2NtGNOxUmgaM7Cer/oDCCs
         sHMi54HNhAk+ix6JVoZEBki25WB1EumDQFpeXizr3SuZTqbI0ct7fpPCrINsrgpSIH5M
         b81KxOhQCQJ9/t40Z2zSRM0nhM7cq6ckuTNhHy76S38NK7Bpp9HJgcRcDrtgoPQLIDEG
         wJEbyk+nS3l9/ONP99I7tD5YQAWfbc2nknWy4nNgPSxwV3ItRizI0NTa/EYCx3ezWpBU
         ChsY7LfGujY8qiB/Wue4vM1hBgFicNR4rhxyTEbYQ/fLK4vWqkn3wZ3Jnl/RAzxWPm38
         guSw==
X-Gm-Message-State: AGi0PuYUhJpUL79A2oOPY4mrq9ne6TAFphPeUYFWQabJT4IoHibJzT9o
        iaEGFsaaK11IkMFaE1+ntD9G0fBMC7rW3KyvYquYTapyzxboOzALN6myPzn5WPaFySPn5+PHaXC
        X5zZ53P4MGmTm
X-Received: by 2002:a1c:4ca:: with SMTP id 193mr5676260wme.18.1586962410825;
        Wed, 15 Apr 2020 07:53:30 -0700 (PDT)
X-Google-Smtp-Source: APiQypKgkkaOjvC7IzHh45gZluJBlRAB0EDDEKLC5J1nBzdDb/gCljFCcJsnBzwUJEmVbAtBvAy4Yw==
X-Received: by 2002:a1c:4ca:: with SMTP id 193mr5676247wme.18.1586962410610;
        Wed, 15 Apr 2020 07:53:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id p10sm22953476wrm.6.2020.04.15.07.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:53:30 -0700 (PDT)
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com>
 <875ze2ywhy.fsf@vitty.brq.redhat.com>
 <cc29ce22-4c70-87d1-d7aa-9d38438ba8a5@linux.alibaba.com>
 <87a73dxgk6.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e122372-249d-3d93-99ed-a670fff33936@redhat.com>
Date:   Wed, 15 Apr 2020 16:53:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87a73dxgk6.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 11:07, Vitaly Kuznetsov wrote:
> In case this is no longer needed I'd suggest we drop 'kvm_run' parameter
> and extract it from 'struct kvm_vcpu' when needed. This looks like a
> natural add-on to your cleanup patch.

I agree, though I think it should be _instead_ of Tianjia's patch rather
than on top.

Paolo

