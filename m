Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9570614F30
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 17:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiKAQ2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 12:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiKAQ2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 12:28:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23981CB28
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 09:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667320055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0AbHCvMc1vq6ZTia1yRY1TXl4yRSTxvVwe8opekaGTY=;
        b=Ibv9xuvwMvcR9djApHIre0ckjXK1Is4Z601+KUbSiA+y4K1HIzWjk9tOOQfAD9QpcImbc9
        EeWNZtqrzZig4xXqsGN/Gch3ayqwI4RUOLtWTbb4aKgLKuZct1mut6g73Kh+D/xP2hXYzq
        UYDlq5jZGo70ynK+90+WWVmkHy3/VW8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-0PVC1j89PZm2Ril_ONDw7g-1; Tue, 01 Nov 2022 12:27:34 -0400
X-MC-Unique: 0PVC1j89PZm2Ril_ONDw7g-1
Received: by mail-qk1-f199.google.com with SMTP id i17-20020a05620a249100b006fa2e10a2ecso5214483qkn.16
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 09:27:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0AbHCvMc1vq6ZTia1yRY1TXl4yRSTxvVwe8opekaGTY=;
        b=uipIPqLuhBgeFM7tVG1Xq2AnYMXMB6/xjTB1D/eN28ptSEfzLpjXVpyduwOJyeDVkn
         Rnqe4lKuoCr+6IHG0c1OmG2kZ92ds7nZrsk9upyYdDNnSs4mPM/j4w0tjKYPGXwNi7Dr
         0bLuHfT7fYNA+ZYFKHN2CkhsStBfQYjTtK73MLuIoErR2fTQGkJM8tlepS6debokxfb4
         Uaipz/jjhATHpXrZTCuAkpAcyTWZz6dgp71Z7WiK2whsd1O8mxLpuv035F9Rwm8AtkCM
         jqdOm/0EXH+tOWNIms3IB8EzCm7AbcA6OOvH6mlScKxvV5heJbJPPokLamhEUrhLYcF0
         tMpQ==
X-Gm-Message-State: ACrzQf2cyX2q0/RR9VA3FrBNtsigYGLaRVK8M9z6WFMe3p2eZa8Xqb3G
        NFrkIVrAyxRuArLJ8VrGmJNau2MDry2zM3FzTlWSuj0vE4piXIWH2fIcOLdx2xl1Umy8uMLAKoM
        I3jTy+gTCoXr7
X-Received: by 2002:a37:44cc:0:b0:6fa:35d6:f5ef with SMTP id r195-20020a3744cc000000b006fa35d6f5efmr6032093qka.364.1667320054292;
        Tue, 01 Nov 2022 09:27:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Hm1MAU6xhK5BGu+YKaf3h5HOo2br+U+K9EH88KvDDia/UuQS9ctFk5X6BH8Yi2mvOgm2tWQ==
X-Received: by 2002:a37:44cc:0:b0:6fa:35d6:f5ef with SMTP id r195-20020a3744cc000000b006fa35d6f5efmr6032075qka.364.1667320054055;
        Tue, 01 Nov 2022 09:27:34 -0700 (PDT)
Received: from ovpn-194-149.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v1-20020a05620a440100b006fa2dde9db8sm4257678qkp.95.2022.11.01.09.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 09:27:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 45/48] KVM: selftests: Introduce rdmsr_from_l2() and
 use it for MSR-Bitmap tests
In-Reply-To: <Y2FFNO3Bu9Z3LtCW@google.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
 <20221101145426.251680-46-vkuznets@redhat.com>
 <Y2FFNO3Bu9Z3LtCW@google.com>
Date:   Tue, 01 Nov 2022 17:27:29 +0100
Message-ID: <87bkpqskr2.fsf@ovpn-194-149.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Nov 01, 2022, Vitaly Kuznetsov wrote:
>> Hyper-V MSR-Bitmap tests do RDMSR from L2 to exit to L1. While 'evmcs_test'
>> correctly clobbers all GPRs (which are not preserved), 'hyperv_svm_test'
>> does not. Introduce and use common rdmsr_from_l2() to avoid code
>> duplication and remove hardcoding of MSRs.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  .../selftests/kvm/include/x86_64/processor.h  |  9 +++++++
>>  .../testing/selftests/kvm/x86_64/evmcs_test.c | 24 ++++---------------
>>  .../selftests/kvm/x86_64/hyperv_svm_test.c    |  8 +++----
>>  3 files changed, 17 insertions(+), 24 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> index fbaf0b6cec4b..a14b7e4ea7c4 100644
>> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
>> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
>> @@ -520,6 +520,15 @@ static inline void cpu_relax(void)
>>  		"hlt\n"	\
>>  		)
>>  
>> +/* Exit to L1 from L2 with RDMSR instruction */
>> +static inline void rdmsr_from_l2(uint32_t msr)
>
> I would prefer keeping this helper out of common x86-64 code, even if it means
> duplicating code across multiple Hyper-V tests until the L1 VM-Enter/VM-Exit
> sequences get cleaned up.  The name is misleading, e.g. it doesn't really read
> the MSR since there are no outputs

It's somewhat similar to vmcall()/vmmcall() which are only used to exit
from L2 to L1 (and thus nobody complained that all the register values
are random) and not issue a hypercall and return some value.

> and while we could obviously fix that with a
> rename or a generic DO_VMEXIT_FROM_L2() macro, I would rather fix the underlying
> problem of the world switches clobbering L2 state.  That way all the helpers that
> exist for L1 can be used verbatim for L2 instead of needing dedicated helpers for
> every instruction that is used to trigger a VM-Exit.
>

I'm fine with keeping two copies of this in Hyper-V tests for now, of course.

-- 
Vitaly

