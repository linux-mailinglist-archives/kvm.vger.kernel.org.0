Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C2A373EF4
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 17:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhEEPvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 11:51:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229797AbhEEPvh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 11:51:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620229840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wITGEIqpZnfr6XwKeX5z8uHosmf/mobmC6J56/IU3Aw=;
        b=C5H3votlCyRqu79Y2dtG0sWe7yl7ftswnhCefJYIFuH5AzbVnodoD79hRfCpuSUoBvFzwJ
        L7ywzcWTPFMx4kt8u0yKLV/GlnHTqeDKoYz6RFq/4gyqOuyHgWoLg6MlqKBCneCQx9P7pZ
        9kpoFdAuD7JbQc3vc/joJha2zdOV+Ow=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-09CgqwcuN1OtWgUxxG7DoA-1; Wed, 05 May 2021 11:50:38 -0400
X-MC-Unique: 09CgqwcuN1OtWgUxxG7DoA-1
Received: by mail-wr1-f69.google.com with SMTP id 88-20020adf95610000b029010758d8d7e2so849000wrs.19
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 08:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wITGEIqpZnfr6XwKeX5z8uHosmf/mobmC6J56/IU3Aw=;
        b=jJJ/AwaAwiEaTvl7B4g95GmUQRSP7FZS+VBu+0rXqoOhc3ZnyTYxMs6IxeRWhqo3KK
         y8p5YQEqQ2WoWZSca9uYwDhTdGXRJTLLTAnReAv7qOY8oxlxeeEHmrnfQfzNp6xzPRfn
         hQ028jXQhuKHcWkdgo98B5ykfXZTrpcJjKQjaJukcWkqqeeQ2cGb3vrOW3ctKLXfdsbJ
         d34jO7o/C+67PuAu6DQd2nURgcu2UUait4Ucnjomg/xbxighldJEEgs8QNd1+bvCEhDD
         9m7AD6CWMwZhGU4wd3h/Nrp6PYNPOvRNScA0BKyP5QVCCGf05fERkSF5oz32hxnHYuJQ
         a6Jw==
X-Gm-Message-State: AOAM5331EkXvGuOeT+okEuW8NDGi0v+0FbSqycwtaFhm8nZCEiWqXSoa
        SXaSroPg9yH9+f/Gu95keyctLWZcFd+TpFSjWSPCEqNOdXOAkMpCTXLpjX4pp7cdBlJMR4toX/i
        clLfoAnbFVH9N
X-Received: by 2002:a1c:1f95:: with SMTP id f143mr10882609wmf.77.1620229837079;
        Wed, 05 May 2021 08:50:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4jd7+IaqHS5ld5iDky4g39jgFwX3kqGr1QxZXDrhgU/SfwpeA2uONta8KDTD2AqxzIa+L5A==
X-Received: by 2002:a1c:1f95:: with SMTP id f143mr10882590wmf.77.1620229836839;
        Wed, 05 May 2021 08:50:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w7sm12609912wru.51.2021.05.05.08.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 08:50:36 -0700 (PDT)
Subject: Re: [PATCH 11/15] KVM: VMX: Disable loading of TSX_CTRL MSR the more
 conventional way
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-12-seanjc@google.com>
 <08a4afca-c3cb-1999-02a6-a72440ab2214@redhat.com>
 <YJK7jzbihzFIkb59@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b33cf48c-03f2-b864-481f-1588dd7cc6aa@redhat.com>
Date:   Wed, 5 May 2021 17:50:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJK7jzbihzFIkb59@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 17:36, Sean Christopherson wrote:
> On Wed, May 05, 2021, Paolo Bonzini wrote:
>> On 04/05/21 19:17, Sean Christopherson wrote:
>>> Tag TSX_CTRL as not needing to be loaded when RTM isn't supported in the
>>> host.  Crushing the write mask to '0' has the same effect, but requires
>>> more mental gymnastics to understand.
>>
>> This doesn't explain _why_ this is now possible.  What about:
>>
>> Now that user return MSRs is always present in the list, we don't have
> 
> User return MSRs aren't always present in the list; this series doesn't change
> that behavior at all.
> 
>> the problem that the TSX_CTRL MSR needs a slot vmx->guest_uret_msrs even
>> if RTM is not supported in the host (and therefore there is nothing to
>> enable).  Thus we can simply tag TSX_CTRL as not needing to be loaded
>> instead of crushing the write mask to '0'.
> 
> Unless I'm missing something, it would have been possible to give TSX_CTRL a
> slot but not load it even before this refactoring, we just missed that approach
> when handling the TSX_CTRL without HLE/RTM case.  Several other MSRs rely on
> this behavior, notably the SYSCALL MSRs, which are present in the list so that
> the guest can read/write the MSRs, but are loaded into hardware iff the guest
> has enabled SYSCALL.

You're right, it used to be done with vmx->nr_active_uret_msr.

Paolo

> All that said, I certainly have no objection to writing a longer changelog.

