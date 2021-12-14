Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932D9474B47
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 19:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbhLNS4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 13:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLNS4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 13:56:16 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D566C06173E
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 10:56:16 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i12so18620477pfd.6
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 10:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fO41zWDQQqtUAZWhF4qywuUJLzeFNaam3H6vOEt/LkQ=;
        b=R14JMzhYTBttWXYr1U4EJVkcEQKPpXVtZKH2b5ohQOgtXm5ft0IfbnkC8QjsRP1mTa
         uAhLpb3TIXsRAA8ftrKoz9GdJrpSLOSPvsDoNcrRWyQ6hsdF/p6Kvh1GStCyXrU4Nli/
         Qpua7wnBmZpf4uPuYkXr2qy92WMxjRw2DeUyTrTAv00hDCXIzNsxGsGiLAtrpORirR0q
         jqXHs94+tCDhgJpKJ9/QvBd1Z17+Bmiaz/1YhogplE2HGhiv3OgeYdsrt4RQs4FRoO9f
         1Mpt5ZP4VzV3LKbbPOupisL5quwCK8+933NtyAKXUSNz4eqTfLIEB10O1BK+KeucEMSZ
         9lpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fO41zWDQQqtUAZWhF4qywuUJLzeFNaam3H6vOEt/LkQ=;
        b=iVngwTnGwMxP5Q0HyBqq/iTOOsgIYVmUQurVwtXWhHEBOh8224yDdaVkPbdtgUxwxr
         /lfr7GhES+/Gpi+ZCc6669RdpAk39x/lFcx3YNtcC5oO1nLQTIKeUSE7r67SAELFGehR
         vLsuxLCbFbw/Zpu6vVz8iOV/Yvwfm5BwPVS5UQjfz1G6UP/Q5LEwrTSzP2JnaSpyd+jb
         PSXQF2z7fsjMlXVQVAOdez5md+0mcFzwzZCPm+Z5lWdnu3Lf3u+ER4gBGIOZ3c6t5tAP
         9TJ3YIgZIm8doJowsMIT+vqRozT9XLA69rZaLI2soaszcSX9t88GGnlvHixDMMl9j+Jm
         iKDA==
X-Gm-Message-State: AOAM532fODu8u91fyoJ+L7kuHG0RQlOKmWgQLZbjGuPc9ArVUNMIUsQE
        EKy6tI6MHIInW2bsWaUJGZh3cQ==
X-Google-Smtp-Source: ABdhPJxD4FVAIHptbkERfJnHHMLsFKYvx2nE1poXME33PIV0WBGnwDM6XtYE24tRDZW+kciy4qTEwA==
X-Received: by 2002:a63:3285:: with SMTP id y127mr4846666pgy.479.1639508175593;
        Tue, 14 Dec 2021 10:56:15 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m6sm408934pgb.31.2021.12.14.10.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 10:56:15 -0800 (PST)
Date:   Tue, 14 Dec 2021 18:56:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, wanpengli@tencent.com,
        rkrcmar@redhat.com, vkuznets@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] KVM: x86: add kvm per-vCPU exits disable capability
Message-ID: <Ybjoy5h9a8nKK9X4@google.com>
References: <20211214033227.264714-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214033227.264714-1-kechenl@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, Kechen Lu wrote:
> ---
>  Documentation/virt/kvm/api.rst  | 8 +++++++-
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/cpuid.c            | 2 +-
>  arch/x86/kvm/svm/svm.c          | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 4 ++--
>  arch/x86/kvm/x86.c              | 5 ++++-
>  arch/x86/kvm/x86.h              | 5 +++--
>  include/uapi/linux/kvm.h        | 4 +++-
>  8 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index aeeb071c7688..9a44896dc950 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6580,6 +6580,9 @@ branch to guests' 0x200 interrupt vector.
>  
>  :Architectures: x86
>  :Parameters: args[0] defines which exits are disabled
> +             args[1] defines vCPU bitmask based on vCPU ID, 1 on
> +                     corresponding vCPU ID bit would enable exists
> +                     on that vCPU
>  :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
>  
>  Valid bits in args[0] are::
> @@ -6588,13 +6591,16 @@ Valid bits in args[0] are::
>    #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
>    #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
>    #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
> +  #define KVM_X86_DISABLE_EXITS_PER_VCPU         (1UL << 63)

This doesn't scale, there are already plenty of use cases for VMs with 65+ vCPUs.
At a glance, I don't see anything fundamentally wrong with simply supporting a
vCPU-scoped ioctl().

The VM-scoped version already has an undocumented requirement that it be called
before vCPUs are created, because neither VMX nor SVM will update the controls
if exits are disabled after vCPUs are created.  That means the flags checked at
runtime can be purely vCPU, with the per-VM flag picked up at vCPU creation.

Probably worth formalizing that requirement too, e.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 85127b3e3690..6c9bc022a522 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5775,6 +5775,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
                if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
                        break;

+               mutex_lock(&kvm->lock);
+               if (kvm->created_vcpus)
+                       goto disable_exits_unlock;
+
                if ((cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT) &&
                        kvm_can_mwait_in_guest())
                        kvm->arch.mwait_in_guest = true;
@@ -5785,6 +5789,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
                if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
                        kvm->arch.cstate_in_guest = true;
                r = 0;
+disable_exits_unlock:
+               mutex_unlock(&kvm->lock);
                break;
        case KVM_CAP_MSR_PLATFORM_INFO:
                kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
