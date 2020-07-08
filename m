Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDBC218B41
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 17:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgGHPbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 11:31:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30137 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730028AbgGHPbW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 11:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594222281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=59uaosHXgT6qmldDLKNeyh6mr1S59liDZ+jRzuKa0uE=;
        b=Ct9HnZfNwUputkH4aVCW3oYUlbZ38merRG0HGXyhS5Z3E5T3D/kNEtWBg8y2FF/8p74Dzo
        9hP6gRpUw4f/2XK5R2Tnh1mcLu2M5Fx1prVYORYFuW3WrKkhdtw9kX+DuQm3CgO4Eox0l8
        MFV3Jq0+1MqKgitaCqh4yQkHk26rWLQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-EraKMAViMdOndzDKSh-3hQ-1; Wed, 08 Jul 2020 11:31:18 -0400
X-MC-Unique: EraKMAViMdOndzDKSh-3hQ-1
Received: by mail-wr1-f71.google.com with SMTP id y16so52291922wrr.20
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 08:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=59uaosHXgT6qmldDLKNeyh6mr1S59liDZ+jRzuKa0uE=;
        b=D8olUHDQgl61Aa1s2tMwSVDx5kQcfeAL6+FOLAkEyXg9vS4xVDH9R0RN0iSJuhzNm/
         ItH4FI027LtPypb0ywvDaH1wdZQZF1vPRC7t92b0cLVyOzKUv44FlnAfIleDpu62SIl3
         reAqiQrvCqNbYm+zVTRPbL1mxk7CSiEIhqfR9dZDw/N6CwJRqoWeqw/tFJDFCn/4RA+O
         AFBd4FLL3PUPlzPUEuZo/3PJLCF5crlRxRqsbTvgYL12ZwJX8XztpfR37++1trBUnsQI
         GflzcskUJn80iBApNx0rDbBUo7H7H+XGUxS7Ah+PhB4Js6NYvJkGbektaW44/N01kaFf
         OCvA==
X-Gm-Message-State: AOAM530mxL5x2PEj5FCEN7NygTiEMw9ZhZuW+CLAgA2+RQ3hqRvrS2SD
        1SFYRKtnojekPqMERMVl+N4TbkTyRSX0DagMmnyxVYbl4YixK4j9if7HbXC9j//wOMJEikU9+Os
        rNbUu5GVZyanS
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr9638595wmk.67.1594222276520;
        Wed, 08 Jul 2020 08:31:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy0WT3rLNI0em+sO8R/UAW8LZSJNdJTXnuAaTTSym1frgpG8b2UGa/jS7r5G1c/YH3r8JJjA==
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr9638575wmk.67.1594222276235;
        Wed, 08 Jul 2020 08:31:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id j15sm426678wrx.69.2020.07.08.08.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 08:31:15 -0700 (PDT)
Subject: Re: [PATCH] KVM/x86: pmu: Fix #GP condition check for RDPMC emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20200708074409.39028-1-like.xu@linux.intel.com>
 <20200708151824.GA22737@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e285ccb3-29bd-dcb8-73d1-eeee11d72198@redhat.com>
Date:   Wed, 8 Jul 2020 17:31:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708151824.GA22737@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 17:18, Sean Christopherson wrote:
> On Wed, Jul 08, 2020 at 03:44:09PM +0800, Like Xu wrote:
>> in guest protected mode, if the current privilege level
>> is not 0 and the pce flag in the cr4 register is cleared,
>> we will inject a #gp for rdpmc usage.
> 
> Wrapping at ~58 characters is a bit aggressive.  checkpatch enforces 75
> chars, something near that would be prefereable.
> 
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>  arch/x86/kvm/pmu.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index b86346903f2e..d080d475c808 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -372,6 +372,11 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>>  	if (!pmc)
>>  		return 1;
>>  
>> +	if ((kvm_x86_ops.get_cpl(vcpu) != 0) &&
>> +	    !(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
>> +	    (kvm_read_cr4(vcpu) & X86_CR0_PE))
> 
> This reads CR4 but checks CR0.PE.
> 
> And maybe put the X86_CR4_PCE check first so that it's the focus of the
> statement?

I'll squash this to fix it (I'm OOO next week and would like to get kvm/queue
sorted out these few days that I've left).

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d080d475c808..67741d2a0308 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -372,9 +372,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 	if (!pmc)
 		return 1;
 
-	if ((kvm_x86_ops.get_cpl(vcpu) != 0) &&
-	    !(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
-	    (kvm_read_cr4(vcpu) & X86_CR0_PE))
+	if (!(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
+	    (kvm_x86_ops.get_cpl(vcpu) != 0) &&
+	    (kvm_read_cr0(vcpu) & X86_CR0_PE))
 		return 1;
 
 	*data = pmc_read_counter(pmc) & mask;


The order follows the SDM.  I'm tempted to remove the CR0 check
altogether, since non-protected-mode always runs at CPL0 AFAIK, but let's
keep it close to what the manual says.

Paolo

