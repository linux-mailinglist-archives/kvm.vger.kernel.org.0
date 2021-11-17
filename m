Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7FA454D40
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 19:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240092AbhKQSfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 13:35:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40948 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240068AbhKQSft (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 13:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637173970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y/veQ2/16dN3v+kYCtByKkIi6t7D2etplr3VDnS6swM=;
        b=RPLpoFq8mWsa4ZE1DSP08VqXYHmdmZzgcDBicYmaW3My1KuvpnwpjbUcjkyunAPOb+hjcv
        A1zc5dR9gU2ureF812ycSzkFLAToTehxXx0++M2ZMQJNjFISqWur5tPuvcdVOafKLfGE8F
        pdN7sGIuxZLWsskWmr4HcFe4AGjiHF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-PjXVD03KNVumiIGzdSE9Pw-1; Wed, 17 Nov 2021 13:32:45 -0500
X-MC-Unique: PjXVD03KNVumiIGzdSE9Pw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69C331069401;
        Wed, 17 Nov 2021 18:32:43 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9303160657;
        Wed, 17 Nov 2021 18:32:25 +0000 (UTC)
Message-ID: <e642702a-4455-9c1e-ac29-ba5809a2139c@redhat.com>
Date:   Wed, 17 Nov 2021 19:32:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Pass parameter flush as false in
 kvm_tdp_mmu_zap_collapsible_sptes()
Content-Language: en-US
To:     Ben Gardon <bgardon@google.com>,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
 <21453a1d2533afb6e59fb6c729af89e771ff2e76.1637140154.git.houwenlong93@linux.alibaba.com>
 <CANgfPd_=M-8r8H5uoaPz_VTXZpmX6XD+QGAdBdz4PERUoqE1OA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CANgfPd_=M-8r8H5uoaPz_VTXZpmX6XD+QGAdBdz4PERUoqE1OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 18:50, Ben Gardon wrote:
>> Since tlb flush has been done for legacy MMU before
>> kvm_tdp_mmu_zap_collapsible_sptes(), so the parameter flush
>> should be false for kvm_tdp_mmu_zap_collapsible_sptes().
>>
>> Fixes: e2209710ccc5d ("KVM: x86/mmu: Skip rmap operations if rmaps not allocated")
>> Signed-off-by: Hou Wenlong<houwenlong93@linux.alibaba.com>
> Haha, I'm glad we're thinking along similar lines. I just sent a patch
> yesterday to remove the flush parameter from that function entirely:
> https://lore.kernel.org/lkml/20211115234603.2908381-2-bgardon@google.com/
> I'll CC you on that patch.
> 

And actually I had applied that before reading Sean's answer, so his 
follow up is not needed anymore.

Paolo

