Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC9A4C2EC7
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiBXO7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiBXO71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:59:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDF8E1B0BFB
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 06:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645714735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7t/PhndngG1sSe9ScfhTi54FhdXHMvtO4i3SsRE9GWw=;
        b=N2uVPf5jL1sKJFp08z1CFdJMFTBqFspK0mP74DDmtXKb8RZpuzFdJaK0rF8ln+X3eiiAP8
        esE/1T8qIdeKD1YzFvy3h6/K78yo3Qpj491d6HqOFVtOmYZvjtLhYpwYmpOu+xy7/wDamy
        G+tXwUFUcTOtllR73hi7vTTvYlA9cS8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-7lyA-ARLN6yZhsMqXtoTcg-1; Thu, 24 Feb 2022 09:58:54 -0500
X-MC-Unique: 7lyA-ARLN6yZhsMqXtoTcg-1
Received: by mail-ed1-f71.google.com with SMTP id h17-20020a05640250d100b004133863d836so871560edb.0
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 06:58:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7t/PhndngG1sSe9ScfhTi54FhdXHMvtO4i3SsRE9GWw=;
        b=um3u/9SOxhXpGd8XSjfumBrLb7vGe2fTgqUyNuzrMxVBD3E6CW/NKggO9GdKYvAJ1g
         xmWzERJXs4yoKtcw1xuiGNfaYvdez7UkQmEiGxpsjF12cdZG6k2/sH935xgQ5cFTgY/1
         a2UNgqewTJdDjjjlQfUzz8mALR7zshNgx5O6x1feLvB9FEomKX8MtJ7bXrvtR4yhxM4I
         hufmh5iuHf5i9Zvu/XBCcIqgc+kI0affIPRJjQa7ZmNPpdznmFD0hGK+jbCLfZGc1hK2
         SBaW3kMx3O9gfbUgUq2pnQwzySi95zV6FtZvMGVGDKjr1YQZyne16GhFgK0NqHunFVrz
         BCpA==
X-Gm-Message-State: AOAM532b2UMmU/HLu5Y2Bpk+qLI2CIppie5pbxG6S9tRuDPwlV49WzSR
        uS3it3FUknYhTeOUusnOk3uUjYbswV+P3tBA1Z9oIpV3sV6hZ+O6+5WUoM4imf+WHvnLHxJFxlw
        X0daMoytQIulE
X-Received: by 2002:a50:ef0b:0:b0:413:2c17:d967 with SMTP id m11-20020a50ef0b000000b004132c17d967mr2647078eds.307.1645714733019;
        Thu, 24 Feb 2022 06:58:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwAth6e+lJsfBzJhg/2BDAmUQF+x6IiOo7EAOTCu9A2htoA90IJCRZ9rRv4/yCpgmPIuakpvw==
X-Received: by 2002:a50:ef0b:0:b0:413:2c17:d967 with SMTP id m11-20020a50ef0b000000b004132c17d967mr2647058eds.307.1645714732810;
        Thu, 24 Feb 2022 06:58:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g20sm37931ejk.209.2022.02.24.06.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 06:58:52 -0800 (PST)
Message-ID: <a0594849-c141-16b5-4420-167174f2b2f1@redhat.com>
Date:   Thu, 24 Feb 2022 15:58:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/11] KVM: x86: Prep work for VMX IPI virtualization
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20220204214205.3306634-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220204214205.3306634-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 22:41, Sean Christopherson wrote:
> Prepare for VMX's IPI virtualization, in which hardware treats ICR as a
> single 64-bit register in x2APIC mode.  The SDM wasn't clear on how ICR
> should be modeled, KVM just took the easier path and guessed wrong.
> 
> Hardware's implementation of ICR as a 64-bit register requires explicit
> handling to maintain backwards compatibility in KVM_{G,S}ET_REG, as
> migrating a VM between hosts with different IPI virtualization support
> would lead to ICR "corruption" for writes that aren't intercepted by
> KVM (hardware doesn't fill ICR2 in vAPIC page).
> 
> This series includes AVIC cleanups for things I encountered along the way.
> AVIC still has multiple issues, this only fixes the easy bugs.
> 
> Sean Christopherson (11):
>    Revert "svm: Add warning message for AVIC IPI invalid target"
>    KVM: VMX: Handle APIC-write offset wrangling in VMX code
>    KVM: x86: Use "raw" APIC register read for handling APIC-write VM-Exit
>    KVM: SVM: Use common kvm_apic_write_nodecode() for AVIC write traps
>    KVM: SVM: Don't rewrite guest ICR on AVIC IPI virtualization failure
>    KVM: x86: WARN if KVM emulates an IPI without clearing the BUSY flag
>    KVM: x86: Make kvm_lapic_reg_{read,write}() static
>    KVM: x86: Add helpers to handle 64-bit APIC MSR read/writes
>    KVM: x86: Treat x2APIC's ICR as a 64-bit register, not two 32-bit regs
>    KVM: x86: Make kvm_lapic_set_reg() a "private" xAPIC helper
>    KVM: selftests: Add test to verify KVM handles x2APIC ICR=>ICR2 dance
> 
>   arch/x86/kvm/lapic.c                          | 193 ++++++++++++------
>   arch/x86/kvm/lapic.h                          |  21 +-
>   arch/x86/kvm/svm/avic.c                       |  38 ++--
>   arch/x86/kvm/trace.h                          |   6 +-
>   arch/x86/kvm/vmx/vmx.c                        |  11 +-
>   arch/x86/kvm/x86.c                            |  15 +-
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/x86_64/apic.h       |   1 +
>   .../selftests/kvm/x86_64/xapic_state_test.c   | 150 ++++++++++++++
>   10 files changed, 325 insertions(+), 112 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/xapic_state_test.c
> 
> 
> base-commit: 17179d0068b20413de2355f84c75a93740257e20

Queued, with patch 4 adjusted.  Thanks,

Paolo

