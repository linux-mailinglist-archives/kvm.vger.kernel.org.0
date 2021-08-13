Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478233EADE9
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 02:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbhHMAY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 20:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbhHMAY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 20:24:28 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75CEC061756
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 17:24:02 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 108-20020a9d01750000b029050e5cc11ae3so10104170otu.5
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 17:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S1WCLIgZJw7NB7QaNs+s3IBr5WciGpbAMHOWjTXCxiM=;
        b=lNird6IBQmqSdAXSUHpc1tAygLYoeS1OSllyuO8BnsNw+WhxslDvZMo+CSIFnsDKkm
         qYe9UNCTgPcOwBjwck8emtVRAN4OexBmqlhcJfNJ9IdUa47SiAOLoOfFSzbm5/RUj3C8
         Xv7dVT20G2ENUmAtRiJDW9S7W0doj6euh/JLShdp6q8bNqi06fL10DkkKqHvlXpafh5D
         jNNLSLE0QiT4t8xvePj6jSUNG5gin7TFGaauGWggFSwAqJnO/vTHTCjax2Ce8fzxt0fz
         rGFQYf65RKVEwzzlOspVix8k2Vrz8aNpWie+d7yz6Nb4oO241PyENsiUFA4VMVAOaQUF
         XEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S1WCLIgZJw7NB7QaNs+s3IBr5WciGpbAMHOWjTXCxiM=;
        b=OdyA92yG/Zhx5H0rU/4f1QYa3UmTYlGu1PnR/+o04225OcSqM7zW+IDlKEbvfb/7zT
         zC/tck6u2wcek2594/eFKH/8spwXMH6oSN5K+rTFPHVYKlHHWCt27aVJuTo8k4EsAjGv
         HE9w1MVWbWMD06gYks63RZ56M3kBAXT7JGJGVbCS50tTBLTTfQJK4iDQ67Y0g9Y/BpNk
         lwHFFl/EWjlj1gWE4QlMHJvdPIyYOyKbCY42YJkLaiuQQSbUoJlz0vvNuKqME4T3G9en
         NNE/0mM/Uyg+6XPcQqmR44lfDwZg0VKf+B1H2b2va0FKkrruQaTCXxb+/ho/zpvXVS33
         Lc+Q==
X-Gm-Message-State: AOAM532T0bf49fOdXK2bodz07lVB4vq9pAyp2pd0KpINr9hK7LxWNSfa
        WrIXcgIC3t+TwrtxZDrFQJ9D74+3ff2Q1w3PtbHIDg==
X-Google-Smtp-Source: ABdhPJz9eZarCF2OPXGn3J2rardcf0zIdLldAXQELt1i1YQeMkwdN40oBWCirYukbLR0n07ltcVc5VpupVEl3sUCHC8=
X-Received: by 2002:a05:6830:108d:: with SMTP id y13mr5375423oto.295.1628814241893;
 Thu, 12 Aug 2021 17:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200128092715.69429-1-oupton@google.com> <20200128092715.69429-5-oupton@google.com>
In-Reply-To: <20200128092715.69429-5-oupton@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 Aug 2021 17:23:50 -0700
Message-ID: <CALMp9eT+bbnjZ_CXn6900LxtZ5=fZo3-3ZLp1HL2aHo6Dgqzxg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: nVMX: Emulate MTF when performing instruction emulation
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 28, 2020 at 1:27 AM Oliver Upton <oupton@google.com> wrote:
>
> Since commit 5f3d45e7f282 ("kvm/x86: add support for
> MONITOR_TRAP_FLAG"), KVM has allowed an L1 guest to use the monitor trap
> flag processor-based execution control for its L2 guest. KVM simply
> forwards any MTF VM-exits to the L1 guest, which works for normal
> instruction execution.
>
> However, when KVM needs to emulate an instruction on the behalf of an L2
> guest, the monitor trap flag is not emulated. Add the necessary logic to
> kvm_skip_emulated_instruction() to synthesize an MTF VM-exit to L1 upon
> instruction emulation for L2.
>
> Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/svm.c              |  1 +
>  arch/x86/kvm/vmx/nested.c       | 37 ++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/nested.h       |  5 +++++
>  arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.h          |  3 +++
>  arch/x86/kvm/x86.c              | 15 +++++++------
>  8 files changed, 78 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 69e31dbdfdc2..e1061ebc1b4b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1103,6 +1103,7 @@ struct kvm_x86_ops {
>         int (*handle_exit)(struct kvm_vcpu *vcpu,
>                 enum exit_fastpath_completion exit_fastpath);
>         int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
> +       void (*do_singlestep)(struct kvm_vcpu *vcpu);
>         void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
>         u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
>         void (*patch_hypercall)(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 503d3f42da16..3f3f780c8c65 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -390,6 +390,7 @@ struct kvm_sync_regs {
>  #define KVM_STATE_NESTED_GUEST_MODE    0x00000001
>  #define KVM_STATE_NESTED_RUN_PENDING   0x00000002
>  #define KVM_STATE_NESTED_EVMCS         0x00000004
> +#define KVM_STATE_NESTED_MTF_PENDING   0x00000008

Maybe I don't understand the distinction, but shouldn't this new flag
have a KVM_STATE_NESTED_VMX prefix and live with
KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE, below?

>
>  #define KVM_STATE_NESTED_SMM_GUEST_MODE        0x00000001
>  #define KVM_STATE_NESTED_SMM_VMXON     0x00000002
