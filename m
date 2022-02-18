Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5A04BB7F0
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 12:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbiBRLUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 06:20:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiBRLUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 06:20:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15811433BF
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 03:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645183214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cKb0cZODYYb004G8vkUpXzl5M5sjvEaMEp61UfVhGYE=;
        b=UtjgM1tUJosEHw/U96wCmDS1JVVmZ1H3jaUtHz7XJ+RGTXVRZQ9yHr4jAPrElJh/XldCpC
        zF9sMJrpg6TDh1KK/1SoGMOB3poITE3507mU6CvaH2C0J+KFoY0LAyEItT3ghetJTB71qn
        oifdIrxHvauXQ+uCMXyMcEAYbCiX9gI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-fZP9uASMO92laWPntN1BNw-1; Fri, 18 Feb 2022 06:20:13 -0500
X-MC-Unique: fZP9uASMO92laWPntN1BNw-1
Received: by mail-ej1-f71.google.com with SMTP id h22-20020a1709060f5600b006b11a2d3dcfso2923133ejj.4
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 03:20:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cKb0cZODYYb004G8vkUpXzl5M5sjvEaMEp61UfVhGYE=;
        b=1gNU56rTf6CM9yOYrE7bMq14izkL1hvV+LcEE0CywtGtbQgy9VaGDl774rrFoPz7ZZ
         6uSRPCEz0Grh944bcs9hJ5tdIXSiTQxFyFJwXs4vEjorrex+Xq/ESCLKXut70zQAgdJA
         EKWag6TzmJEIA+l6t8wm4BoagFbE+L97KkrpGowU+DfSY5b/7Wuuc4OISqfMenXUZCbX
         RA7YgJDEy51eaO/s89fT62rYoEUTC1nQ3w2O/SLUrOR/7eqeCspICzP+ofDJ5MQn3eGR
         AUo7qbqlW6XSx++f5FCsvausNp473u+raZNKfKeJhyPX+d63euKgvZxgXL+XkmFsOWMF
         cvtA==
X-Gm-Message-State: AOAM530STIBM7mH6S59bDD0Btr+ze8yvjPaWSxCg1KX49ueD2DcaS8EC
        zLNgbcskdY1hnp7ZfwiaIbKstKhaUdbxiYQN1xgwtNMX6fwZZbVSLP4sOrfFjNLMv/TShy1FZgJ
        4tmp+Yv9giB7C
X-Received: by 2002:a17:906:ae4a:b0:6d0:9eee:e951 with SMTP id lf10-20020a170906ae4a00b006d09eeee951mr1899259ejb.2.1645183211910;
        Fri, 18 Feb 2022 03:20:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzopxqIdnzTGCmNYL+f43fQvHudwEnkN8EXmuI9QZ7YMXotpNyJWu9FUG2Za6Ja9QauUua0qA==
X-Received: by 2002:a17:906:ae4a:b0:6d0:9eee:e951 with SMTP id lf10-20020a170906ae4a00b006d09eeee951mr1899251ejb.2.1645183211720;
        Fri, 18 Feb 2022 03:20:11 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b7sm4403880edv.58.2022.02.18.03.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 03:20:11 -0800 (PST)
Message-ID: <12b84d17-94cc-6ee7-bde4-340b609c16d2@redhat.com>
Date:   Fri, 18 Feb 2022 12:20:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/2] KVM: x86/pmu: Protect kvm->arch.pmu_event_filter with
 SRCU
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Eric Hankland <ehankland@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220217083601.24829-1-likexu@tencent.com>
 <20220217083601.24829-2-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220217083601.24829-2-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/17/22 09:36, Like Xu wrote:
> From: Like Xu<likexu@tencent.com>
> 
> Fix the following positive warning:
> 
>   =============================
>   WARNING: suspicious RCU usage
>   arch/x86/kvm/pmu.c:190 suspicious rcu_dereference_check() usage!
>   other info that might help us debug this:
>   rcu_scheduler_active = 2, debug_locks = 1
>   1 lock held by CPU 28/KVM/370841:
>   #0: ff11004089f280b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x87/0x730 [kvm]
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x59/0x73
>    reprogram_fixed_counter+0x15d/0x1a0 [kvm]
>    kvm_pmu_trigger_event+0x1a3/0x260 [kvm]
>    ? free_moved_vector+0x1b4/0x1e0
>    complete_fast_pio_in+0x8a/0xd0 [kvm]
>    [...]

I think the right fix is to add SRCU protection to complete_userspace_io 
in kvm_arch_vcpu_ioctl_run.  Most calls of complete_userspace_io can 
execute similar code to vmexits.

> Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")

It fixes 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring 
instructions", 2022-01-07), actually.  That is when the PMU filter was 
added to kvm_skip_emulated_instruction (called by kvm_fast_pio_in).

Thanks,

Paolo

> It's possible to call KVM_SET_PMU_EVENT_FILTER ioctl with the vCPU running.
> Similar to "kvm->arch.msr_filter", KVM should guarantee that vCPUs will
> see either the previous filter or the new filter so that guest pmu events
> with identical settings in both the old and new filter have deterministic
> behavior.

