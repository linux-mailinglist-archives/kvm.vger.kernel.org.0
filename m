Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E89C1BCA2C
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 20:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbgD1Sr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 14:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730824AbgD1SrX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 14:47:23 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F70C03C1AB
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 11:47:23 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c16so21635758ilr.3
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 11:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KoCNgzdwIuXjlJSUOdO4yyYJyVpoTgFZrzjKxnpEZi8=;
        b=rO220pzNzM3a+H1KYm5QBMcl/fEuqAh35tLkRk1QNXkpdeaL2kKwvxSpg6bZX4GZXD
         yUveR7vUOW+O2g7f/F5sr7mUbZPDtS98ERIWq2CeqZ0U9bLovZ3WEmFXmfhWK4wzsaqa
         VNbdjVrPbg7mjuZtz5tU25cKpIPJ695O0qVMm2sTLFCysbQgTh3jH1ymfGPCdLp4vaTI
         69vdjF1k9BGEEE3Ys0zBQ96OIOslNyKI55I1wMpyA9hCWOX61Nh/54vQ8LNxLhjSzDDq
         ib4Xc7lMTdg0KEIHwcBMyThE0Zptq4j5HIx9lZPRBbzqdAqowE5MHfMIlJ04sm4Uuk8g
         Mgbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KoCNgzdwIuXjlJSUOdO4yyYJyVpoTgFZrzjKxnpEZi8=;
        b=hnKhNy9ANUZpbjvs70llVOo2lYfSa7AEXMJVjWtV+KMHzEHekDprBW1v8/GeHMzcsI
         IvSliGGlogi/t+BPUehuBPJatKhJT7jPQcpfp+rbkGtLLoFaHN/RU3ZOZ2GvGVzmLCQX
         GYs1n8PEYU1IadDa+YI4D1NatzwDJJazEFUX0OEJYwkhOdnjxS8Kz6kl+phBKzalzwCh
         nVUGT22dVAL+wu1+aG/oMTn1+z39XFqg2/MQRcAht39gklF1I+P4QR8MDzIqzDXTXYsK
         GSMTGPAI+AspP/Pl5NvBaYzl/KYYiXJ2sh25ULVxBduFJCQhMyncpM/3EJUqVHuPnasc
         lV0A==
X-Gm-Message-State: AGi0PuY6FyZUosVuSUzJuFntzMom0L/IL4S3Fdd3J7uzQGWigSXM4uE2
        iIjGvtkQMxJ2QUa5r65XTWq7ODJ2yB2nE7JnDnzmFg==
X-Google-Smtp-Source: APiQypKCil1UPL1+1J/3/O1rhnojP17NOIllMYWa0RqW4VJTJHHWAbOZsy2NrekLO5Nlr5bL9MWczKgMt5cNr1VcE8E=
X-Received: by 2002:a92:d186:: with SMTP id z6mr26810990ilz.119.1588099642177;
 Tue, 28 Apr 2020 11:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200428173217.5430-1-sean.j.christopherson@intel.com>
In-Reply-To: <20200428173217.5430-1-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 11:47:11 -0700
Message-ID: <CALMp9eQp4sMbQ0Sa_BL2fd0m8=_M61XRS8KhN6uiNod4OrtwXQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: nVMX: Tweak handling of failure code for nested
 VM-Enter failure
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 10:32 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Use an enum for passing around the failure code for a failed VM-Enter
> that results in VM-Exit to provide a level of indirection from the final
> resting place of the failure code, vmcs.EXIT_QUALIFICATION.  The exit
> qualification field is an unsigned long, e.g. passing around
> 'u32 exit_qual' throws up red flags as it suggests KVM may be dropping
> bits when reporting errors to L1.  This is a red herring because the
> only defined failure codes are 0, 2, 3, and 4, i.e. don't come remotely
> close to overflowing a u32.
>
> Setting vmcs.EXIT_QUALIFICATION on entry failure is further complicated
> by the MSR load list, which returns the (1-based) entry that failed, and
> the number of MSRs to load is a 32-bit VMCS field.  At first blush, it
> would appear that overflowing a u32 is possible, but the number of MSRs
> that can be loaded is hardcapped at 4096 (limited by MSR_IA32_VMX_MISC).
>
> In other words, there are two completely disparate types of data that
> eventually get stuffed into vmcs.EXIT_QUALIFICATION, neither of which is
> an 'unsigned long' in nature.  This was presumably the reasoning for
> switching to 'u32' when the related code was refactored in commit
> ca0bde28f2ed6 ("kvm: nVMX: Split VMCS checks from nested_vmx_run()").
>
> Using an enum for the failure code addresses the technically-possible-
> but-will-never-happen scenario where Intel defines a failure code that
> doesn't fit in a 32-bit integer.  The enum variables and values will
> either be automatically sized (gcc 5.4 behavior) or be subjected to some
> combination of truncation.  The former case will simply work, while the
> latter will trigger a compile-time warning unless the compiler is being
> particularly unhelpful.
>
> Separating the failure code from the failed MSR entry allows for
> disassociating both from vmcs.EXIT_QUALIFICATION, which avoids the
> conundrum where KVM has to choose between 'u32 exit_qual' and tracking
> values as 'unsigned long' that have no business being tracked as such.
> To cement the split, set vmcs12->exit_qualification directly from the
> entry error code or failed MSR index instead of bouncing through a local
> variable.
>
> Opportunistically rename the variables in load_vmcs12_host_state() and
> vmx_set_nested_state() to call out that they're ignored, set exit_reason
> on demand on nested VM-Enter failure, and add a comment in
> nested_vmx_load_msr() to call out that returning 'i + 1' can't wrap.
>
> No functional change intended.
>
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
