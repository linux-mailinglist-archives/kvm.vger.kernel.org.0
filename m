Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C204E54CC08
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 17:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244998AbiFOPAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 11:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbiFOPAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 11:00:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DA8369FD
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 08:00:47 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 31so9967737pgv.11
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 08:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=il73qXcw7xzDZxb6s7e1hn8itRCEBnm4f9uCfmJHj5U=;
        b=FWOK6yqgEAAluGBmF3x41If+3DVIEGQ/zl5kPZ9BxkkioPe0Cy9ljt+Ih+30sbhdVJ
         e5C685QcmZGqbhIwP/FYjuZy8mr7KvKBbyRyGPdrIjKRArFqseZq5BGkcBp7kymrdN6X
         4qHhG8dH3+lvEnbGrQMrswNvZuBQE2fJDZcMRY24jpRwP5AYoG7q1k/qqdRVmZa4fS51
         haIH3AWH5vXoiI6ohis6GlkFP8jLtqx2xVH9KaESs9HaSGDnogKM4B40aQzGOv1b+Qeq
         AWdOxQOtdB9wdBw07hZm+zmLHq3jD/DCaxkpWPyyjeIPzHIQmAOrxQq+9y8ZFjn94scY
         m9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=il73qXcw7xzDZxb6s7e1hn8itRCEBnm4f9uCfmJHj5U=;
        b=fbqPr4O0AxV75yM9Pq8YoLdYrsbonzPESksQlrGF9q80/QOaEvPcVC2tTeQrHaf+E2
         YSYD1jwvyQayhknBFWwqnRAWu3pOAq+ScgoCRCeiFQgUDAhzNEvwdGQXrJxC2GBzCfgN
         FIDpfouOJTpO/OEdL7OeEg6o6RyOTEyE8IGbvFk6F/XXR2vn+gH9EbFJ2A5B3XPq0sRk
         cNztOp+UAj4ZrTxPEHiLJN2k8kI12nm5uZlB5/TpCzaGWjFxCEY+pqbNZSxpB4hN02qg
         cKgEcOwaygsMi92Xch5S8x3eZYURkP02gTsJNe9M+bO5StqRFsrWEcykbRoGsGsL1aUs
         38yw==
X-Gm-Message-State: AJIora/swwWe36Hjwdq2z1HbB/EfS1T6kf7KEZsQdTMpRuij6uKUn6ka
        liy6WBQAV5otaq7WuNIwYcoz6g==
X-Google-Smtp-Source: AGRyM1vu32JJzZQFQsSzSIHZfN7cJ+OSfFpfcRosRaZbYyZNcCdHlrqm1Jw7/UTxJ6K7W9hDieHx2Q==
X-Received: by 2002:a63:88:0:b0:3fe:2558:674 with SMTP id 130-20020a630088000000b003fe25580674mr203692pga.504.1655305246348;
        Wed, 15 Jun 2022 08:00:46 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z14-20020a17090a540e00b001e2f578560csm1878688pjh.45.2022.06.15.08.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 08:00:45 -0700 (PDT)
Date:   Wed, 15 Jun 2022 15:00:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, den@virtuozzo.com,
        ptikhomirov@virtuozzo.com, alexander@mihalicyn.com
Subject: Re: [Question] debugging VM cpu hotplug (#GP -> #DF) which results
 in reset
Message-ID: <Yqn0GofIXFOHk6k4@google.com>
References: <20220615171410.ab537c7af3691a0d91171a76@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615171410.ab537c7af3691a0d91171a76@virtuozzo.com>
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

On Wed, Jun 15, 2022, Alexander Mikhalitsyn wrote:
> Dear friends,
> 
> I'm sorry for disturbing you but I've getting stuck with debugging KVM
> problem and looking for an advice. I'm working mostly on kernel
> containers/CRIU and am newbie with KVM so, I believe that I'm missing
> something very simple.
> 
> My case:
> - AMD EPYC 7443P 24-Core Processor (Milan family processor)
> - OpenVZ kernel (based on RHEL7 3.10.0-1160.53.1) on the Host Node (HN)
> - Qemu/KVM VM (8 vCPU assigned) with many different kernels from 3.10.0-1160 RHEL7 to mainline 5.18
> 
> Reproducer (run inside VM):
> echo 0 > /sys/devices/system/cpu/cpu3/online
> echo 1 > /sys/devices/system/cpu/cpu3/online <- got reset here
> 
> *Not* reproducible on:
> - any Intel which we tried
> - AMD EPYC 7261 (Rome family)

Hmm, given that Milan is problematic but Rome isn't, that implies the bug is related
to a feature that's new in Milan.  PCID is the one that comes to mind, and IIRC there
were issues with PCID (or INVCPID?) in various kernels when running on Milan.

Can you try hiding PCID and INVPCID from the guest?

> - without KVM (on Host)

...

> ==== trace-cmd record -b 20000 -e kvm:kvm_cr -e kvm:kvm_userspace_exit -e probe:* =====
> 
>              CPU-1834  [003] 69194.833364: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
>              CPU-1838  [000] 69194.834177: kvm_multiple_exception_L9: (ffffffff814313c6) vcpu=0xffff93ee9a528000
>              CPU-1838  [000] 69194.834180: kvm_multiple_exception_L41: (ffffffff81431493) vcpu=0xffff93ee9a528000 exception=0xd000001 has_error=0x0 nr=0xd error_code=0x0 has_payload=0x0
>              CPU-1838  [000] 69194.834195: kvm_multiple_exception_L9: (ffffffff814313c6) vcpu=0xffff93ee9a528000
>              CPU-1838  [000] 69194.834196: kvm_multiple_exception_L41: (ffffffff81431493) vcpu=0xffff93ee9a528000 exception=0x8000100 has_error=0x0 nr=0x8 error_code=0x0 has_payload=0x0
>              CPU-1838  [000] 69194.834200: shutdown_interception_L8: (ffffffff8146e4a0)

If you can modify the host kernel, throwing a WARN in kvm_multiple_exception() should
pinpoint the source of the #GP.  Though you may get unlucky and find that KVM is just
reflecting an intercepted a #GP that was first "injected" by hardware.  Note that this
could spam the log if KVM is injecting a large number of #GPs.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cea051ca62e..19d959bf97cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -612,6 +612,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
        u32 prev_nr;
        int class1, class2;

+       WARN_ON(nr == GP_VECTOR);
+
        kvm_make_request(KVM_REQ_EVENT, vcpu);

        if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {

