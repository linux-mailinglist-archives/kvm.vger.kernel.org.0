Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0E341459D
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhIVJ6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:58:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234233AbhIVJ6g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 05:58:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632304625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H8lXYjCiQE1RsLJOpWSQ54LN6mhNiVsVotKqDRIpqpU=;
        b=bwPCOjunlHO5UCdE+fL/oGaYyann8+YMHvhjZPVmrpUcW6u6pmBLm6xkr3opIPpaZ16aEv
        Lpbu+xe4X8q8KRZ5+o3aE7ffl4c0mu8yzIeL5uNZtTFGPhbJb3zydwgEShOGsnWJQZWtTg
        xyMhuF+RQLqayTUkKD2O1dV+l5RcMyQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-n_Y3hUHhP_uidiY5twPY3g-1; Wed, 22 Sep 2021 05:57:04 -0400
X-MC-Unique: n_Y3hUHhP_uidiY5twPY3g-1
Received: by mail-ed1-f69.google.com with SMTP id r7-20020aa7c147000000b003d1f18329dcso2440429edp.13
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 02:57:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H8lXYjCiQE1RsLJOpWSQ54LN6mhNiVsVotKqDRIpqpU=;
        b=CCuemGprMSjFFs4oc+Bsjej5dy9k+ep838/KiJq9iZWvAu7vJci8K794vnpib4xNtZ
         zWm6yDIHOPfOnahmLpIumFCuf0jPJLjkiLhL8x/m/C+RWmQyA+Q0izeeDicBlWBvAQaB
         kLXLXL/xoEj4hkwZdkwi1shvC2TlHP7bHC82a8TAFYGblcQ0Q/MG7yiSQ11nOQu9M1zh
         9cWgpN6a5ZPiBIUFYsVUxjd+CcVx0kIKrEzPcRNObrxSNJtpOoBmd/dyTdxuyEm0OEoE
         PV37it7cpuuUCeksz+20Uf4BggF5nYNRdzXbqRADBM4p7DclvXWe30/uBQV6O941Pp2t
         bRNQ==
X-Gm-Message-State: AOAM532SQveE/1Zk8hxlwKHMLu8t6OwIzmC1pWKpBdcWxEc9oSq2up5s
        HP5ugFbdmBfaOxXkLA1sU7ktSdrRDtdmMQGTW1St18Y6rTyVcmg4Cne5UUOLjcmndlTlIpb5aMf
        vx6t8vXoR2HEA
X-Received: by 2002:a17:906:9747:: with SMTP id o7mr40352306ejy.486.1632304623421;
        Wed, 22 Sep 2021 02:57:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb9ww+gqCqOmTPJDggbxqTKvN9bBkyT5bul3yrAh9YWIrPXDtI44i1X+d5sBET3nXuFs313w==
X-Received: by 2002:a17:906:9747:: with SMTP id o7mr40352293ejy.486.1632304623257;
        Wed, 22 Sep 2021 02:57:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m15sm807012ejx.73.2021.09.22.02.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 02:57:02 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: nVMX: Fix nested bus lock VM exit
To:     Sean Christopherson <seanjc@google.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210914095041.29764-1-chenyi.qiang@intel.com>
 <YUigOQ6wL/NSXqjO@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <37eb4ef4-7dd2-1bbb-f250-8a600b91e749@redhat.com>
Date:   Wed, 22 Sep 2021 11:57:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YUigOQ6wL/NSXqjO@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/21 16:52, Sean Christopherson wrote:
> On Tue, Sep 14, 2021, Chenyi Qiang wrote:
>> Nested bus lock VM exits are not supported yet. If L2 triggers bus lock
>> VM exit, it will be directed to L1 VMM, which would cause unexpected
>> behavior. Therefore, handle L2's bus lock VM exits in L0 directly.
>>
>> Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")
> 
> Cc: stable@vger.kernel.org
> 
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>
>> ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 

Queued, thanks.

Paolo

