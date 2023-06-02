Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526F271F7DA
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbjFBB0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbjFBB0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:26:11 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70415138
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:26:08 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5618857518dso21163427b3.2
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685669167; x=1688261167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iwY3spp+fGUtp0w3LjKa+4NnaZkM8DvbIKDWvtVax6A=;
        b=amtNAmM8zVh2VUUWyPoUEZRJs6pOIjakCGtevlewJ4igFgQXtWQSsGZ1wE/gtm5bxM
         t9k7e99DNtJaogeYbOpgLVqYMpvSjin7m6EJ5rpAH4BTVJXWcp70Iz1sYKsiqnKeX5xa
         vBgxu1TKUXy7/8d3Mr0IemvInOtc+ev1qUsPPWeFMU2YZbP8pTQ9BpqXhw2PKMq7qRKG
         AaMWLNkLP+km3LgLkO3mK1O2ALibBC+RBykf4IizzH1XBRXo5y2ogl94yqJnqhOw4DnO
         qT47GMU4q/5N1CESCkv6hQuEvNJStLvpX9T+f+jHeW3PSBMSqwUmQHDUcokPAyedEjpa
         i7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685669167; x=1688261167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iwY3spp+fGUtp0w3LjKa+4NnaZkM8DvbIKDWvtVax6A=;
        b=PDcRG6DyKO5KCxOS6Gb3fz86vdK+dY3sOUOgw+JfwnwnVks9eKqoDtJdcMH+zj8CDz
         ruhePe0bs8FUTFZD+/tVhoENdZOLpNzamPHu4ScL8afI8ujqyUQGe7qSx+0Z6dg1hEbB
         ercFyou2AdkJnfLNjbJZ8tJNLbLEvkbxMC1QWWa9m16Smd7sYzZdvL4W2CSFhTV+SxP9
         l6Ladv2JEuBa8HZvwAzItRU38Qr7QaFpfYdVo7B7jlPSOmOxYg+cGt7BhGVzAh8PmeqE
         uhoxAkx6F+9P37/xqu8X8BL7e23GVmUgsOtM5LdqS9nwLvXbfXMdEFn2yrtrPg4Gpha8
         d4Eg==
X-Gm-Message-State: AC+VfDwKFs1nBeIuNmP5NhacKxRQmPDJYtZB3je09GGAqjk/V3ymiHZY
        GpzDtpVKVD2aIvBf1Ny3XBReCzEyfKY=
X-Google-Smtp-Source: ACHHUZ68qFeLVCrPRJNTeJQCCocYWYe48bFd/0hpjCiMFwiomz6bW84/9hxqZbE6sqO214FFZ2XXQ80Im9U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:cb0b:0:b0:565:bd68:b493 with SMTP id
 q11-20020a81cb0b000000b00565bd68b493mr6419475ywi.6.1685669167676; Thu, 01 Jun
 2023 18:26:07 -0700 (PDT)
Date:   Thu,  1 Jun 2023 18:25:47 -0700
In-Reply-To: <20230411130338.8592-1-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230411130338.8592-1-cloudliang@tencent.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <168565360839.667711.17229671566468688990.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Remove redundant check for MSR_IA32_DS_AREA
 set handler
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Apr 2023 21:03:38 +0800, Jinrong Liang wrote:
> After commit 2de154f541fc ("KVM: x86/pmu: Provide "error" semantics
> for unsupported-but-known PMU MSRs"), the guest_cpuid_has(DS) check
> is not necessary any more since if the guest supports X86_FEATURE_DS,
> it never returns 1. And if the guest does not support this feature,
> the set_msr handler will get false from kvm_pmu_is_valid_msr() before
> reaching this point. Therefore, the check will not be true in all cases
> and can be safely removed, which also simplifies the code and improves
> its readability.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: x86/pmu: Remove redundant check for MSR_IA32_DS_AREA set handler
      https://github.com/kvm-x86/linux/commit/33ab767c2628

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
