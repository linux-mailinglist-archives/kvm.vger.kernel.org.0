Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D895605E6
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 18:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiF2Qb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 12:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiF2QbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 12:31:25 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9113467D
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 09:31:24 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-101ab23ff3fso22200629fac.1
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 09:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q7thwy75XNsSCRPOWOozhMPbtUuFfDHqmCqTx7JYJDo=;
        b=XM+oHc1X7p1kNP/j9n6X2RjMFNVAgMi7Hl3RaZl7JOddM8RA2JxXBhUSZiA4OiquM5
         M2KlQCVxrnDLkjeugS1ikqmgd1pl7G/IAQ723Zy6R4AGzaaAOBmDeuUqHSrV304NOr1F
         UhiO7+/m+8LzUKmraoQGoHjHrforgc5lurae2h31n1RvtunY6unl53g73xAMbl0NcI5g
         n9i5oGNpcF7GD5Ry3X+iU4rW1icOI4AwoqslgQEh4YRMsH5ICJoqOWAiAhgO+QUPEAcV
         NgfLHgA2OS7hcHgz7U24ipW4WFjxYUC2+cds0E3mZHrOJjNOCPmI4ONJ1JnvA/Uvhzq/
         22Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q7thwy75XNsSCRPOWOozhMPbtUuFfDHqmCqTx7JYJDo=;
        b=1BKqClmYEp9Ses6cduaiHD+XPEzZAgFUSBlI/Z6Gs2O8ke2rEl+8sW5vILjFhveFqW
         gjatYSCjQ2xYCnFcSq1Nyete1zu5Nxuweb6vtd90P+bPSAjGk5qYpDhPZkbn6u0GWzmM
         Isnx3z1jJQBpC5hKn0URE+bXYPStgtGBWC/Kd8yE1x4glU4FZrVfOrPO9pCmJtwGPygM
         uiT2ylyi00wNCcl8IVN1xNrDQBOKoD98zrH3Sqm4PWMgZlUMpbNVN2krP6Oqslflj7Fc
         2zm4nednuSgPDJyKGVWqtRytwPBWWDTe+GEa5jEI3RaZnrNUjFOGMwSEB+oRZDyf350u
         EAeQ==
X-Gm-Message-State: AJIora9gI9mHrG6cxOT71fTEs66KJEb1ET4G1aqMIRTEgGTo8tYXqQb2
        Zr6yFAQKlWEmN1PGYdMR7dKWblEym+5fm3bQTZcUnQ==
X-Google-Smtp-Source: AGRyM1u9TD9lOx2AIm1cqMUMRT2gwTyLTDprchu9bU7eiWqc2WXJ4sjR9kPK2AzybmpZbNtc5ympPlJJjJNqTtuNnkw=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr3543919oab.112.1656520283337; Wed, 29
 Jun 2022 09:31:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220621150902.46126-1-mlevitsk@redhat.com> <20220621150902.46126-12-mlevitsk@redhat.com>
In-Reply-To: <20220621150902.46126-12-mlevitsk@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jun 2022 09:31:12 -0700
Message-ID: <CALMp9eSe5jtvmOPWLYCcrMmqyVBeBkg90RwtR4bwxay99NAF3g@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] KVM: x86: emulator/smm: preserve interrupt
 shadow in SMRAM
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        x86@kernel.org, Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
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

On Tue, Jun 21, 2022 at 8:09 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> When #SMI is asserted, the CPU can be in interrupt shadow
> due to sti or mov ss.
>
> It is not mandatory in  Intel/AMD prm to have the #SMI
> blocked during the shadow, and on top of
> that, since neither SVM nor VMX has true support for SMI
> window, waiting for one instruction would mean single stepping
> the guest.
>
> Instead, allow #SMI in this case, but both reset the interrupt
> window and stash its value in SMRAM to restore it on exit
> from SMM.
>
> This fixes rare failures seen mostly on windows guests on VMX,
> when #SMI falls on the sti instruction which mainfest in
> VM entry failure due to EFLAGS.IF not being set, but STI interrupt
> window still being set in the VMCS.

I think you're just making stuff up! See Note #5 at
https://sandpile.org/x86/inter.htm.

Can you reference the vendors' documentation that supports this change?
