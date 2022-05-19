Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AD552CF10
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 11:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiESJMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 05:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbiESJMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 05:12:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAFEB56775
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 02:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652951535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C7uZ8GjzotyzPb+OIEuRVJxWtUaoDnZX9WfGiYxdAlI=;
        b=hK8hRnGUqAkKIsrpfZ/bT5SdR/JcrssYTHE7eJitMQ6YXM+7RbaT0Ow05VS0XbmYQ8ihcT
        GgALWwb2OZb72I2COAX96EgfW9C0yQzIe6PldIPi2f36+3CI//yO+3iDaBa/xZ+VcsjnZE
        AdU4Tsm8ycHo7cWVDOnp199PSYOuITY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-42xPHF2LM8qSqGmMvQBH2Q-1; Thu, 19 May 2022 05:12:14 -0400
X-MC-Unique: 42xPHF2LM8qSqGmMvQBH2Q-1
Received: by mail-wm1-f71.google.com with SMTP id h133-20020a1c218b000000b003972dbb1066so812803wmh.4
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 02:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=C7uZ8GjzotyzPb+OIEuRVJxWtUaoDnZX9WfGiYxdAlI=;
        b=MpG9Dv9MXN/g08aCyDcgvxYlca9MkD7Hj+wBuecRpBP8nA4sh9VHSb0K8yDbNxJ5Uc
         cerlv8Ia7bx3GFPlp2UE7kBUMWsIoXxRG/BD5wRrnItFfdVNZIYL7NEJ6A3ceib9qTbA
         M2Hk+Dw6kjRsWH/V0LhTdjKb/Tyu8GSR2PBc+XRLwVZ2U6Sdre8JY5XAG0R1zXZqlzbf
         mAOaiq+w4jhOy9ZfCJBg+h4qCmBS7EBQaKFT/iTdxymyV2rVerXodd9dUnMpKP//LeNC
         7v8xZjlCholJwQuUsjXaT/xVXseifKk+YydNV0I781zyeqGV/ldQpkiUms8+LBj20R7b
         y4AA==
X-Gm-Message-State: AOAM532DW6rRhov+fK17QonTplD9KHRtiuxBfJ2WtSzijk9CiIbV+HRH
        uUYXQpsk82id+xFwVkYe21IeGOGIK+siUdqUMvRtE5vOlf1rLkVY1ZCpgduHp6CYKaSSLNvKcEN
        0Jz9WpcYFQLOI
X-Received: by 2002:a05:600c:24a:b0:394:4ce6:57db with SMTP id 10-20020a05600c024a00b003944ce657dbmr3314841wmj.193.1652951533213;
        Thu, 19 May 2022 02:12:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAjJ9ypKrE9q84MzsZpXh8nKsN8Ag++Nlblpj2jTGJaJr1Jf9MyW+TEzh6O3hOz+eJ6ih0Ag==
X-Received: by 2002:a05:600c:24a:b0:394:4ce6:57db with SMTP id 10-20020a05600c024a00b003944ce657dbmr3314812wmj.193.1652951532964;
        Thu, 19 May 2022 02:12:12 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d15-20020a1c730f000000b00394975e14f4sm3750939wmb.8.2022.05.19.02.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 02:12:12 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 20/34] KVM: x86: KVM_REQ_TLB_FLUSH_CURRENT is a
 superset of KVM_REQ_HV_TLB_FLUSH too
In-Reply-To: <6c9add3244d86080ccd8c3c72a37b9ee112d45b8.camel@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
 <20220414132013.1588929-21-vkuznets@redhat.com>
 <6c9add3244d86080ccd8c3c72a37b9ee112d45b8.camel@redhat.com>
Date:   Thu, 19 May 2022 11:12:11 +0200
Message-ID: <87mtfdubro.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
>> KVM_REQ_TLB_FLUSH_CURRENT is an even stronger operation than
>> KVM_REQ_TLB_FLUSH_GUEST so KVM_REQ_HV_TLB_FLUSH needs not to be
>> processed after it.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/x86.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index e5aec386d299..d3839e648ab3 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3357,8 +3357,11 @@ static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
>>   */
>>  void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
>>  {
>> -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
>> +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
>>  		kvm_vcpu_flush_tlb_current(vcpu);
>> +		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
>> +			kvm_hv_vcpu_empty_flush_tlb(vcpu);
>> +	}
>>  
>>  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
>>  		kvm_vcpu_flush_tlb_guest(vcpu);
>
>
> I think that this patch should be moved near patch 1 and/or even squished with it.
>

Sure, will merge.

This, however, made me think there's room for optimization here. In some
cases, when both KVM_REQ_TLB_FLUSH_CURRENT and KVM_REQ_TLB_FLUSH_GUEST
were requested, there's no need to flush twice, e.g. on SVM
.flush_tlb_current == .flush_tlb_guest. I'll probably not go into this
territory with this series as it's already fairly big, just something
for the future.

-- 
Vitaly

