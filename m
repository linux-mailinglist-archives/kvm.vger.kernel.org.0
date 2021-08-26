Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBB93F8BA4
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243059AbhHZQSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 12:18:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52313 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232855AbhHZQSp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 12:18:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629994677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dc80C4dit3QwOZ5pXnhfczxS8gOs+rep9eS8mfVRLco=;
        b=We54DdFMbVr6/Pw73QQRi0hmf6xRg6G12X1IXjpimt/CCHPG71KtN5NYjyqeCWVVEzcOCa
        K6/fmuxyK1F1Pl1OKCAiBmsGVVQQT0BzCuYPR8E0cMF2wyXmWDA3dCzBIUKq9/jIeSh8px
        ZntORrLw9zhlU+5azlYi/DjilNyiRP8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-qbGM84NrOdmtem7DtN0L9A-1; Thu, 26 Aug 2021 12:17:54 -0400
X-MC-Unique: qbGM84NrOdmtem7DtN0L9A-1
Received: by mail-wr1-f70.google.com with SMTP id n10-20020a5d660a0000b02901551ef5616eso1000604wru.20
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 09:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dc80C4dit3QwOZ5pXnhfczxS8gOs+rep9eS8mfVRLco=;
        b=bYhOTWLV8ggQ+Ws63ngfjObnVAjMKnBqRG+KAEhIb6Jog9l68re9Lebp7wOIAsis5m
         19dHAsiuzMF8Ufqoi+xjVNkRBLiiZu5/AYNLjESKEkO6r2MOa9dDc/o5vuBIEyLGUxxX
         RTN0f+dwjBKUz0hTvEChlT9USFHeXmaZrorQqaFScB8fcP77cO89jQl6Dx3sgKiFt81B
         KuECAC6D/cc1amyPNoBTtIziXsf0mjnGIi0lve4fUjMzguhlocY8icZrepdwqNQ31Dgp
         xm9/oQi1GEVQWOAKjUxZGfuvMdjndMPcYSRE3C23i/zXe5zzVouEO+wuqg7lx+ISfmqQ
         BwTA==
X-Gm-Message-State: AOAM533LDu6TWcIk0D9FC0KgArSUXZ7w/nr5o/60Bsp5w9pGJTGh+GHi
        /vXmYXNdxSsY7C9BJK2Y8pYG2H17VOQ4wNzsHiG11yranWju4YcZau0kz9JCN9l5ZsJMFVrI4n1
        luQCxblOIbspA
X-Received: by 2002:a7b:c7c3:: with SMTP id z3mr4474002wmk.96.1629994672907;
        Thu, 26 Aug 2021 09:17:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyERgwCImWECf7qWig1zkLiUfQr++QiieKp+R0ZIoVmj3xDFRrIQEXTFDkgVFjgzSU79w72sg==
X-Received: by 2002:a7b:c7c3:: with SMTP id z3mr4473979wmk.96.1629994672673;
        Thu, 26 Aug 2021 09:17:52 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z13sm3715665wrs.71.2021.08.26.09.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 09:17:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] KVM: Optimize kvm_make_vcpus_request_mask() a bit
In-Reply-To: <YSeyV9cWQXCd+UKk@google.com>
References: <20210826122442.966977-1-vkuznets@redhat.com>
 <20210826122442.966977-4-vkuznets@redhat.com>
 <YSeyV9cWQXCd+UKk@google.com>
Date:   Thu, 26 Aug 2021 18:17:51 +0200
Message-ID: <87fsuwi3io.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Aug 26, 2021, Vitaly Kuznetsov wrote:
>> Iterating over set bits in 'vcpu_bitmap' should be faster than going
>> through all vCPUs, especially when just a few bits are set.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>
> ...
>
>> +	if (vcpu_bitmap) {
>> +		for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
>> +			vcpu = kvm_get_vcpu(kvm, i);
>> +			if (!vcpu || vcpu == except)
>> +				continue;
>> +			kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
>> +		}
>> +	} else {
>> +		kvm_for_each_vcpu(i, vcpu, kvm) {
>> +			if (vcpu == except)
>> +				continue;
>> +			kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
>>  		}
>>  	}
>
> Rather than feed kvm_make_all_cpus_request_except() into kvm_make_vcpus_request_mask(),
> I think it would be better to move the kvm_for_each_vcpu() path into
> kvm_make_all_cpus_request_except() (see bottom of the mail).  That eliminates the
> silliness of calling a "mask" function without a mask, and also allows a follow-up
> patch to drop @except from kvm_make_vcpus_request_mask(), which is truly nonsensical
> as the caller can and should simply not set that vCPU in the mask. 

Both make perfect sense, thanks! v4 is being prepared.

-- 
Vitaly

