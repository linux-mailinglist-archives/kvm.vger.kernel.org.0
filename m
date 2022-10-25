Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C848460D628
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 23:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiJYVbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 17:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJYVbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 17:31:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD10F9AFEF
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 14:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666733492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7hKsWSae5sy5SIIfTkisxh09ZmojqAtDcfYU+07eeHs=;
        b=CwgeV12QDI44Z/WEFWCWemDOm6Lx6xFKpVqDHGZgKEnmtR+hsDY/6IdDFG5SMmL1f1Trdz
        TPDU8hT0H87kzhQQiPba1DcxIaBvVriI87pMGFpaUsmezQqiQhjt6HBcgpa+cbe7/KAANI
        cfWpoR62OHNWiFfLu7GPuDRG6p6+5MY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-333-Arv6TLbENFqlOTOmhl_cBg-1; Tue, 25 Oct 2022 17:31:31 -0400
X-MC-Unique: Arv6TLbENFqlOTOmhl_cBg-1
Received: by mail-wm1-f70.google.com with SMTP id c130-20020a1c3588000000b003b56be513e1so5576059wma.0
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 14:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7hKsWSae5sy5SIIfTkisxh09ZmojqAtDcfYU+07eeHs=;
        b=J5+Or2Rk8dIjBPEZH92cGWB+QlRjGmoDJ9Kl8g7IMc4qAgYhaf1J6gWdjGhE44S8wm
         EHR3n7wLMMo82ZRbGGHxsLrlr4jXbpLXsMpPvLbdwxzaDHWZPU24JiMt3vx5iQEGvrrN
         B1zNn5+iXOC6wMHTWAtRr1HBi8ylP0sCryGlgCy6+a8zJFmdPOOjw2/Ox15Iu1aBRr13
         sSKhEZaoXJYktf64UZuOdU5injBzTEvwDj8hahVb0lqPW+rnGyTbFX2TOKxh7E8WhLQd
         8hoNAy423m05HlrcwSZFQIwdkUhTbGyXfQPeCGwFmEkGWcxmSN/oI5BCFa05gIJDZPij
         ODcA==
X-Gm-Message-State: ACrzQf0E8oHkNc8l1e1rEfrtEcsFvjNGJVahXRURDKPRURdaUwfyZ22P
        kwHcpVrIn9PZnwm7JNIgATQVnUnuZqFjIXv3TY5Wp73Oqgd7/bxsKObE5m+e4FgZLHjajwhG+Ap
        Q+9n9n/C8Pj5f
X-Received: by 2002:a05:6000:1686:b0:230:e1f7:71f5 with SMTP id y6-20020a056000168600b00230e1f771f5mr26072393wrd.185.1666733490394;
        Tue, 25 Oct 2022 14:31:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7xsuyYu7Tk8bVYCy9RkUT4jl1X9RJ6EehpXE+KHb0jZkFtXiZqqEGPtyJ2fw8kjohftqYZAQ==
X-Received: by 2002:a05:6000:1686:b0:230:e1f7:71f5 with SMTP id y6-20020a056000168600b00230e1f771f5mr26072389wrd.185.1666733490191;
        Tue, 25 Oct 2022 14:31:30 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id k16-20020a5d4290000000b0022efc4322a9sm3569724wrq.10.2022.10.25.14.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 14:31:28 -0700 (PDT)
Message-ID: <c71894e8-d6ee-9a2d-3054-5d4df61fe122@redhat.com>
Date:   Tue, 25 Oct 2022 23:31:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: x86: Do not expose the host value of CPUID.8000001EH
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com
References: <20221022082643.1725875-1-pbonzini@redhat.com>
 <Y1gS6Z/kc+WfUsa3@google.com>
 <e906030e-a77d-468f-2c68-d6c643a768c4@redhat.com>
 <Y1hUZYs7kz7JXmr7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y1hUZYs7kz7JXmr7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/25/22 23:25, Sean Christopherson wrote:
>> 0xb and 0x1f are already special cased because EDX is set to the X2APIC id.
>> KVM knows how to do that unlike the NodeId and CoreId.
> But KVM doesn't properly support 0xB/0x1F.  E.g. if usersepace regurgitates
> KVM_GET_SUPPORTED_CPUID back into KVM_SET_CPUID2, all vCPUs will observe the same
> x2APIC ID in EDX, and it will be a host x2APIC ID to boot.
> 
> KVM only handles the where userspace provides 0xB.1 (or 0x1F.1), the guest performs
> CPUID with ECX>1,_and_  userspace doesn't provide the exact CPUID entry.

Ah, you're right - I confused it with the "undefined leaves" behavior here:

         } else {
                 *eax = *ebx = *ecx = *edx = 0;
                 /*
                  * When leaf 0BH or 1FH is defined, CL is pass-through
                  * and EDX is always the x2APIC ID, even for undefined
                  * subleaves. Index 1 will exist iff the leaf is
                  * implemented, so we pass through CL iff leaf 1
                  * exists. EDX can be copied from any existing index.
                  */
                 if (function == 0xb || function == 0x1f) {
                         entry = kvm_find_cpuid_entry(vcpu, function, 1);
                         if (entry) {
                                 *ecx = index & 0xff;
                                 *edx = entry->edx;
                         }
                 }
         }

but KVM in principle could set EDX to the right value for 0xB and 0x1F, 
the x2APIC ID is available for the kernel LAPIC case.  0x8000001e cannot 
be fixed up the same way.

> I suppose one could argue that KVM needs to communicate to userspace that KVM
> emulates the edge case behavior of CPUID 0xB and 0x1F, but I would argue that KVM
> communicates that by announcing a max basic leaf >= 0xB/0x1F.

I agree (or we could fix it up automagically if so inclined).  Either 
way it should be documented at the end of api.rst.

Paolo

