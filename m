Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A8F1684F8
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 18:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgBURbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 12:31:17 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32001 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726672AbgBURbQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 12:31:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582306275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gre7ZeHoqmuVRTzKby7XOW3ou3/ssFLu22ygHR886dQ=;
        b=ZZitFPxABZNGbsRTbHleA6Kwp7K5hxdIJJpLE1DdZ6mJCBgNvs5q3T2RXCRf0neK2tKvfF
        8nHK0PaOBathXiBl8usEPkoI2rKi5uf0F0cepSBJ5zcZZiTAbUZ7Vn6gebMVhy+4vLNMdf
        2pxermo5CiSefoLL0LTl2opiC6Ctj6U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-usCV5GKNPAqyx8iSZqCi_g-1; Fri, 21 Feb 2020 12:31:12 -0500
X-MC-Unique: usCV5GKNPAqyx8iSZqCi_g-1
Received: by mail-wm1-f69.google.com with SMTP id g138so854411wmg.8
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 09:31:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gre7ZeHoqmuVRTzKby7XOW3ou3/ssFLu22ygHR886dQ=;
        b=Mb4nRAcVxAptoDXXGUeTu4mHlvg5o+dOSniNdLFgYdBrmJC7vRWS6yOmLWmphadhGF
         t8gY9OPUj8W8PCGgksvy7bN9K3L13fjoGBBNSHZFoOJkdvD6jTorejR2zj8y2OcSoK2F
         LgyeDFgc5d3TZLOx4nyCt/Ve9ZC2qjRGI1kUw0E1pzHpOoq8dGb5VaDDFkYYAxdbPzXY
         PMospRfHeGKohVv8Bd06j3cr36xW8m5PSWUuOLe20hBuhAweF2K7pxz0IxbZ4B3W05N7
         fDwm3QztP4pNsdhX3s+6o8pxqMcblAedKQ9hTbZp/HCv90Ap317HDWvCi8DczeedoOE6
         iKPw==
X-Gm-Message-State: APjAAAXpQjVYXgdtm4yFGv34xRME6zaV3va7zvktWsaItfdRVT57J9/z
        lUUBJFWzrfTumS3YgHPTktp1PzjQEdGJlZfAaYGPGGvpU1vIl4dWBERk5avib22wFszUe0LXah8
        XKjAHxpg9VRME
X-Received: by 2002:adf:a285:: with SMTP id s5mr52449174wra.118.1582306270990;
        Fri, 21 Feb 2020 09:31:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7DaCwm5dSXMY0+lvo38I3IH/+yBcp1BncOFZ36eQi1wCSVSKGwh91upvl4OmRXmjCzVSTDg==
X-Received: by 2002:adf:a285:: with SMTP id s5mr52449151wra.118.1582306270694;
        Fri, 21 Feb 2020 09:31:10 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id j66sm4767694wmb.21.2020.02.21.09.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:31:10 -0800 (PST)
Subject: Re: [PATCH 06/10] KVM: x86: Move "flush guest's TLB" logic to
 separate kvm_x86_ops hook
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
 <20200220204356.8837-7-sean.j.christopherson@intel.com>
 <87tv3krqta.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cef77bcf-0921-a530-9745-7922e657b013@redhat.com>
Date:   Fri, 21 Feb 2020 18:31:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87tv3krqta.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/02/20 14:52, Vitaly Kuznetsov wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index fbabb2f06273..72f7ca4baa6d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2675,7 +2675,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>>  	trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
>>  		st->preempted & KVM_VCPU_FLUSH_TLB);
>>  	if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
>> -		kvm_vcpu_flush_tlb(vcpu, false);
>> +		kvm_x86_ops->tlb_flush_guest(vcpu);
>>  
>>  	vcpu->arch.st.preempted = 0;
> There is one additional place in hyperv.c where we do TLB flush on
> behalf of the guest, kvm_hv_flush_tlb(). Currently, it does
> KVM_REQ_TLB_FLUSH (resulting in kvm_x86_ops->tlb_flush()), do we need
> something like KVM_REQ_TLB_FLUSH_GUEST instead?

Yes, that would be better since INVEPT does not flush linear mappings.
So, when EPT and VPID is enabled, KVM_REQ_TLB_FLUSH would not flush the
guest's translations.

Paolo

