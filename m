Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11A953486B
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 03:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344499AbiEZBzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 21:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345777AbiEZBzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 21:55:00 -0400
X-Greylist: delayed 358 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 May 2022 18:54:59 PDT
Received: from mail.eskimo.com (mail.eskimo.com [204.122.16.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123F7A7E1A;
        Wed, 25 May 2022 18:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=eskimo.com;
        s=default; t=1653529739;
        bh=VhtTl6PFy6AJclvYo5GWavMZF1ZfPH1+J4/x75mDWjI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=DdT41yPyzKxpmbcaQX5W7TJI+nZKXvXHp0XOaE3t/AshCmDmkknIDvMdC97vgtgHA
         O7cAuOWYWmXjDsGg3KiuOfxgHhgBAgJ8Iqtm1KGGsk0IGdPE1EHj07aBv/LdLmLoqt
         2hjfZ6kTEgMmcJkpZFVQDwKPOTq4EKL8fxKVo2zX8UwZmqmMoRkIOBq6K10WmH/RBl
         BILUDMZ0YxbNiQ9I+AGY3fT7z7ZNwUbUwX1ZATQ/UOFRDnYDZ6rYNWFMtd6hetNmJl
         2XYJREu+I+OCl89A1OiIRL7Y8wfWyjALHYtRX8d/zdDmn1e3JP0JtF9qQK7jWTYMYH
         EClu34hVNf57Q==
Received: from ubuntu.eskimo.com (ubuntu.eskimo.com [204.122.16.33])
        by mail.eskimo.com (Postfix) with ESMTPS id B64B63C9FF9;
        Wed, 25 May 2022 18:48:59 -0700 (PDT)
Date:   Wed, 25 May 2022 18:48:59 -0700 (PDT)
From:   Robert Dinse <nanook@eskimo.com>
To:     Sean Christopherson <seanjc@google.com>
cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 0/4] KVM: x86: Emulator _regs fixes and cleanups
In-Reply-To: <20220525222604.2810054-1-seanjc@google.com>
Message-ID: <847a4d9b-e064-fac5-ae5e-3574baa170b@eskimo.com>
References: <20220525222604.2810054-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Virus-Scanned: clamav-milter 0.103.6 at mail.eskimo.com
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


      This set of patches did allow 5.18 to compile without errors using gcc 
12.1.  Thank you!

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  Eskimo North Linux Friendly Internet Access, Shell Accounts, and Hosting.
    Knowledgeable human assistance, not telephone trees or script readers.
  See our web site: http://www.eskimo.com/ (206) 812-0051 or (800) 246-6874.

On Wed, 25 May 2022, Sean Christopherson wrote:

> Date: Wed, 25 May 2022 22:26:00 +0000
> From: Sean Christopherson <seanjc@google.com>
> To: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>,
>     Vitaly Kuznetsov <vkuznets@redhat.com>,
>     Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>,
>     Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
>     linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>,
>     Kees Cook <keescook@chromium.org>
> Subject: [PATCH 0/4] KVM: x86: Emulator _regs fixes and cleanups
> 
> Clean up and harden the use of the x86_emulate_ctxt._regs, which is
> surrounded by a fair bit of magic.  This series was prompted by bug reports
> by Kees and Robert where GCC-12 flags an out-of-bounds _regs access.  I'm
> 99% certain GCC-12 is wrong and is generating a false positive, but just in
> case...
>
> I didn't tag patch 2 with Fixes or Cc: stable@; if it turns out to "fix"
> the GCC-12 compilation error, it's probably worth sending to v5.18 stable
> tree (KVM hasn't changed, but the warning=>error was "introdued in v5.18
> by commit e6148767825c ("Makefile: Enable -Warray-bounds")).
>
> Sean Christopherson (4):
>  KVM: x86: Grab regs_dirty in local 'unsigned long'
>  KVM: x86: Harden _regs accesses to guard against buggy input
>  KVM: x86: Omit VCPU_REGS_RIP from emulator's _regs array
>  KVM: x86: Use 16-bit fields to track dirty/valid emulator GPRs
>
> arch/x86/kvm/emulate.c     | 14 ++++++++++++--
> arch/x86/kvm/kvm_emulate.h | 14 +++++++++++---
> 2 files changed, 23 insertions(+), 5 deletions(-)
>
>
> base-commit: 90bde5bea810d766e7046bf5884f2ccf76dd78e9
> -- 
> 2.36.1.124.g0e6072fb45-goog
>
