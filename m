Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BD5574B7E
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 13:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238608AbiGNLG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 07:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237879AbiGNLGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 07:06:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 261A8DA9
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 04:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657796813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y8wXm24tfJNe6NPosFaatJWUdYNSg5mujV72lboWyy8=;
        b=V97qSS2TSDfudYwuPQpcVcdoxPU6JHfy+DMiXVQ1Ewh0hJhqHib+QuTi9XcwmvuJMaK+rs
        tww4XzrfDXDnGPoyMgN70uP/UgeuG2Z7cK0RNP+Qkux2ginAglvpMYtL18HM+7IyYKpGJM
        WSNcNuxPFAZ3Gw961mrcpQfuhAYWza4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-Th3oFRyRNL-13EyxPWjGxA-1; Thu, 14 Jul 2022 07:06:52 -0400
X-MC-Unique: Th3oFRyRNL-13EyxPWjGxA-1
Received: by mail-wr1-f69.google.com with SMTP id j23-20020adfb317000000b0021d7986c07eso472425wrd.2
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 04:06:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=y8wXm24tfJNe6NPosFaatJWUdYNSg5mujV72lboWyy8=;
        b=z7hpnymRX9tVbm1VGajqcsATGl2Lqgy4rW1CBbzBevULofPpZAdCbz3sySMfvu448n
         xXVT1ZIbsz4Wx6U2V8xiYA9pGElOg9kmCC2HGdQwYMn7nEOlyNpDch/Ul3wJYsvcpz+k
         iqcWrO7RVStbm1TMSQVJPU3kMFStMtUm/ulbG9xdjWCeS5z4k34BIAjiKsgtwataOBX5
         U7QH5+1WdKWqyGnx1vtMdmoAM4qnCdhgQpYYjdo2AREEmoAwB097T1qyhGo/g8mLsMzh
         h9IiSLOb5v20I9yo7s3FP9Ksoj2A9KABAVyJ00NebW7Ju7+iI69vW+7VkFgw3imMG6/j
         wseg==
X-Gm-Message-State: AJIora9UfTmjVYeAaFWVNucvCuxj/MTEaJIXalUawrRLYHzJd98JFEYm
        qlSTB8eaJJK+fW6cCaj4HQRKnvXFTHjGnIel2ULwZZ7n42K6Z0arx5t2s9N5eKr/5bi+2/Oexld
        OzWb2aoVzT0Gaa4RcTPVWIyKLyw5GBW2bLC8FgQUWrjGkSMA2o46gCQD4llOBsL3E
X-Received: by 2002:a1c:2b86:0:b0:3a3:7fb:52d9 with SMTP id r128-20020a1c2b86000000b003a307fb52d9mr36220wmr.86.1657796810862;
        Thu, 14 Jul 2022 04:06:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t/xbT4d5N+qH3qzW75qqZhQnw3n8R4cmUcRmhYPK4Jai8/idmpKmVaJDhefqTviUCY4WtgTg==
X-Received: by 2002:a1c:2b86:0:b0:3a3:7fb:52d9 with SMTP id r128-20020a1c2b86000000b003a307fb52d9mr36171wmr.86.1657796810558;
        Thu, 14 Jul 2022 04:06:50 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id z11-20020a05600c0a0b00b003a033177655sm5819383wmp.29.2022.07.14.04.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 04:06:49 -0700 (PDT)
Message-ID: <a866e044713be1ab3f446775934ec15541c39726.camel@redhat.com>
Subject: Re: [PATCH v2 00/11] SMM emulation and interrupt shadow fixes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 14 Jul 2022 14:06:47 +0300
In-Reply-To: <20220621150902.46126-1-mlevitsk@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-21 at 18:08 +0300, Maxim Levitsky wrote:
> This patch series is a result of long debug work to find out why
> sometimes guests with win11 secure boot
> were failing during boot.
> 
> During writing a unit test I found another bug, turns out
> that on rsm emulation, if the rsm instruction was done in real
> or 32 bit mode, KVM would truncate the restored RIP to 32 bit.
> 
> I also refactored the way we write SMRAM so it is easier
> now to understand what is going on.
> 
> The main bug in this series which I fixed is that we
> allowed #SMI to happen during the STI interrupt shadow,
> and we did nothing to both reset it on #SMI handler
> entry and restore it on RSM.
> 
> Best regards,
>         Maxim Levitsky
> 
> Maxim Levitsky (11):
>   KVM: x86: emulator: em_sysexit should update ctxt->mode
>   KVM: x86: emulator: introduce update_emulation_mode
>   KVM: x86: emulator: remove assign_eip_near/far
>   KVM: x86: emulator: update the emulation mode after rsm
>   KVM: x86: emulator: update the emulation mode after CR0 write
>   KVM: x86: emulator/smm: number of GPRs in the SMRAM image depends on
>     the image format
>   KVM: x86: emulator/smm: add structs for KVM's smram layout
>   KVM: x86: emulator/smm: use smram struct for 32 bit smram load/restore
>   KVM: x86: emulator/smm: use smram struct for 64 bit smram load/restore
>   KVM: x86: SVM: use smram structs
>   KVM: x86: emulator/smm: preserve interrupt shadow in SMRAM
> 
>  arch/x86/include/asm/kvm_host.h |   6 -
>  arch/x86/kvm/emulate.c          | 305 ++++++++++++++++----------------
>  arch/x86/kvm/kvm_emulate.h      | 146 +++++++++++++++
>  arch/x86/kvm/svm/svm.c          |  28 +--
>  arch/x86/kvm/x86.c              | 162 ++++++++---------
>  5 files changed, 394 insertions(+), 253 deletions(-)
> 
> -- 
> 2.26.3
> 
> 
A kind ping on these patches.

Best regards,
	Maxim Levitsky

