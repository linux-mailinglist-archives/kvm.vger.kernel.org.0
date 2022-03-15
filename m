Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7767E4DA458
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351835AbiCOVI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343868AbiCOVI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:08:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 695D61FE
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647378464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SN1lVi51UEx0rS1GDQEkwEDHB11Ld9R4lvr1AnjiHX4=;
        b=Eow9OV/VjpPyeeguH4H+gYnnsNU3lC4GO16Givv72yeJFffd2Eh5xkcuCnmBLQcTvZojyi
        exQxvsJp181OZjHiQ2YInfZno7xRiKwmdLTq6+HQvbGZRz+Gcvisxgibp86ZnNT/BXQ0EW
        xx2HjLqRzo+jqYNYRv+EMJZ0CsWa5wc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-PM_Sma2UMJiFpwEFaNafCQ-1; Tue, 15 Mar 2022 17:07:43 -0400
X-MC-Unique: PM_Sma2UMJiFpwEFaNafCQ-1
Received: by mail-ed1-f72.google.com with SMTP id i5-20020a056402054500b00415ce7443f4so165850edx.12
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SN1lVi51UEx0rS1GDQEkwEDHB11Ld9R4lvr1AnjiHX4=;
        b=FNRltdM03bAimF47JXb/pxWa2RBY33zn0mK+/YgEj+xJLpMhrWWmqMTK24TPY8SmsW
         jFl9oUJaYu4CAcrhTvXVVp7bz+T9noRsc2DRNayV9SOYzT/ptfEkqnvMI8EIy2ASMY29
         wth+bdiOiBBpqjekI7bklp7mh3CEMCLITsg7yhtZoGYV8pP8YFBSfsI9aoHNeDQueEBe
         QhrkqO7kspGDbMgOa+BtnAvlkUNmpXpNde4X1Bks6FKKgXFUC3z4fqY8KCr7bylWI0BK
         bvmfrz6m/rCz223l+CqmGp02XS2O+5ZwidOjJ0BASbWFh3hbdymGZ++ljXJV+W2St7vl
         DnmA==
X-Gm-Message-State: AOAM532EwhD5UX0DGe/19QCp5vrXlVfusfrNkVzC50vSsB91gWGSPU03
        FfeJIbAA1tnzC+TjGygzxfV1WwOJGypTUdQQnhl4GuzPq4UMRDbNhni5hMGcpCiHiCY8BK8/nTJ
        MhxWJgDou3sOJ
X-Received: by 2002:a17:906:7056:b0:6d6:dd99:f2a4 with SMTP id r22-20020a170906705600b006d6dd99f2a4mr23963048ejj.43.1647378460006;
        Tue, 15 Mar 2022 14:07:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzk/xTyM6bm9sOWWR5ouWoP0fdL8AJCBzc0MXluxO2y+Er6xcFyG55VdSgC7XQnlDKji/y9EA==
X-Received: by 2002:a17:906:7056:b0:6d6:dd99:f2a4 with SMTP id r22-20020a170906705600b006d6dd99f2a4mr23963037ejj.43.1647378459811;
        Tue, 15 Mar 2022 14:07:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id y12-20020a50eb8c000000b00410f02e577esm58944edr.7.2022.03.15.14.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 14:07:39 -0700 (PDT)
Message-ID: <b6f55f6a-7f91-1b5e-0057-8946cf1161ae@redhat.com>
Date:   Tue, 15 Mar 2022 22:07:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] x86: kvm Require const tsc for RT
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <Yh5eJSG19S2sjZfy@linutronix.de> <Yi8KpReL9UfO0dEb@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yi8KpReL9UfO0dEb@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/14/22 10:28, Sebastian Andrzej Siewior wrote:
> On 2022-03-01 18:55:51 [+0100], To kvm@vger.kernel.org wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> Date: Sun, 6 Nov 2011 12:26:18 +0100
>>
>> Non constant TSC is a nightmare on bare metal already, but with
>> virtualization it becomes a complete disaster because the workarounds
>> are horrible latency wise. That's also a preliminary for running RT in
>> a guest on top of a RT host.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> ping.

Queued, thanks.

Paolo

