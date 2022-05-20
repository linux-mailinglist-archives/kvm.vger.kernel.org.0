Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B7352ECCA
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349560AbiETNAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiETNAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:00:50 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A5462C0
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 06:00:49 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id q10so9860747oia.9
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 06:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m1I83n4PUC08udPGh28I5vhbfHKAx+wBXDUq+Y3BXBo=;
        b=EL5S8Pbfxlxir0aOubRo43JmPkaD40toeNu1YK18HJSHvtL1ZLCD0bRZPG+mKx7qkY
         f89SN8Dr0KcGuboF5Ut4MPmv1of+ce1NFHNqCUxt76s4ULgg5ClihqdpMg+zfOyEW6NE
         dOvtkezU4eMZ/xrep6lohbP8eIAaPtCnGxfcD9pmYSgQ9THg/KiOlsSw9UxNRgi6UzAY
         9WH5Q9xN02YzkwaFSlN5lQ0E8QWAet29GrGboJS153P6KPIAhHys46wMoR9rUF4mZ/AD
         03uXBFcA/1vtKXDqFkgfCvfiUnnrw8hIYpS+jLtGmbabzMX/ZbHX3N7lmS6piF0JiLab
         jvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m1I83n4PUC08udPGh28I5vhbfHKAx+wBXDUq+Y3BXBo=;
        b=7GoUr2gPGfbdnYDy34KK+eC/6mSObYsRaAmCh3B/e4SWZkOpUfKHfN1avo7BH7aHQ6
         DOUHwKg8dyYdE/BLMCfyKjIkGFBhLiLoEIRGZ1TchnzDcKz8EKYt7lqHcmPbSicJxb0Y
         3fzEi8pKbgkGL69iehNkmF94/sq8rQWIe4U3t9gmd1mmWh/ktibQLql39woLkB2hOVLk
         ocyqWm0aYzf+bcau2oyZ0PsdvDpDkUwxWI/+CNb+mp4p/UCXdTDsLqC0+XFzO8xqQr/B
         +1jh4h6e+S230hz5G3bE6Hgdgmqh1deggpY2Y+qYg+g75gouW2wylWu7MySSqj3f/bfh
         ibDA==
X-Gm-Message-State: AOAM530dCH360efNPG1pAy82/7QLkxvva9hbcV6vDZzOmiU68UkSckYZ
        E2IiGV/pxatE3y7p552YRxEuYl3eWd278ZPGXDhVmw==
X-Google-Smtp-Source: ABdhPJy98dHVNaBKTqGEhAkjVKO9b+S+j92rry67f6e2uKi3FVTumcvHpzK/BOl+ZrruOYSWOlP55BozDmZiufyNngA=
X-Received: by 2002:a05:6808:c2:b0:325:eb71:7266 with SMTP id
 t2-20020a05680800c200b00325eb717266mr5766203oic.269.1653051646802; Fri, 20
 May 2022 06:00:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220518132512.37864-1-likexu@tencent.com> <20220518132512.37864-4-likexu@tencent.com>
 <31f3de9a-a752-e322-ebd0-731c42afd47a@redhat.com>
In-Reply-To: <31f3de9a-a752-e322-ebd0-731c42afd47a@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 20 May 2022 06:00:35 -0700
Message-ID: <CALMp9eSp5d3mq2GaT+AhDSXaZ=HN0SUSnW5VGY+o4NHLz=VkSA@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 03/11] KVM: x86/pmu: Protect kvm->arch.pmu_event_filter
 with SRCU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 5:51 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 5/18/22 15:25, Like Xu wrote:
> > From: Like Xu <likexu@tencent.com>
> >
> > Similar to "kvm->arch.msr_filter", KVM should guarantee that vCPUs will
> > see either the previous filter or the new filter when user space calls
> > KVM_SET_PMU_EVENT_FILTER ioctl with the vCPU running so that guest
> > pmu events with identical settings in both the old and new filter have
> > deterministic behavior.
> >
> > Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
>
> Please always include the call trace where SRCU is not taken.  The ones
> I reconstructed always end up at a place inside srcu_read_lock/unlock:
>
> reprogram_gp_counter/reprogram_fixed_counter
>    amd_pmu_set_msr
>     kvm_set_msr_common
>      svm_set_msr
>       __kvm_set_msr
>       kvm_set_msr_ignored_check
>        kvm_set_msr_with_filter
>         kvm_emulate_wrmsr**
>         emulator_set_msr_with_filter**
>        kvm_set_msr
>         emulator_set_msr**
>        do_set_msr
>         __msr_io
>          msr_io
>           ioctl(KVM_SET_MSRS)**
>    intel_pmu_set_msr
>     kvm_set_msr_common
>      vmx_set_msr (see svm_set_msr)
>    reprogram_counter
>     global_ctrl_changed
>      intel_pmu_set_msr (see above)
>     kvm_pmu_handle_event
>      vcpu_enter_guest**
>     kvm_pmu_incr_counter
>      kvm_pmu_trigger_event
>       nested_vmx_run**
>       kvm_skip_emulated_instruction**
>       x86_emulate_instruction**
>    reprogram_fixed_counters
>     intel_pmu_set_msr (see above)
>
> Paolo

I agree with Paolo that existing usage is covered by
srcu_read_lock/unlock, but (a) it's not easy to confirm this, and (b)
this is very fragile.

Whichever way we decide to go, the userspace MSR filter and the PMU
event filter should adopt the same approach.
