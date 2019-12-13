Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D3211EE86
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 00:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLMX3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 18:29:20 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:33303 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfLMX3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 18:29:19 -0500
Received: by mail-il1-f194.google.com with SMTP id r81so864266ilk.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 15:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WsJwT1xMG1ojwj13bCzmKC5Zx0aA/xgIWA7F7I5vDR4=;
        b=nuXWwyCaVOkeNJleaLdPVFXKmoBP0fgw77DdGOHEJ9ilzzTgi7GaTidVvxDFGp8RwV
         UX8ddRuCjKV7CSdKARh28ztylUe6o+GSZXvg6tjIdWn/+QRjX6eN62qNMhytYV8h81xV
         7biXW2FhVZL8ZSGtGrWc/RVzabu95DXAtbmB7RxvT70smShZ8yaac/ZQjmo7EIb5Y+Zm
         ro5DIgMDu1bheY5Og2yLQ3Qixukuh9o9N6UuH9U8dOhlbOKtkhjDrhmqgJW6Wh2hUiHU
         25ss/ubmbljbE2cvOY7T4FaXgPudgR9+SAhJjGi/RkLK2LjfdIDh6Zf71Z3DNqj1qI2k
         aNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WsJwT1xMG1ojwj13bCzmKC5Zx0aA/xgIWA7F7I5vDR4=;
        b=nszfZqvslyE2CZaBPm1tdWHbS4tT2qMltei1jmWXHHseegwXsBc+Xmg93lGBdthCWo
         KnZicuLE1+rd4QU5CXiXSeojUT7a3v6FGGxirwjsbnQ+n/Bvb2Z7NIbK8rDo7yJS/sbP
         7b3hjlsGJKCUQd2hpTNIUmPw9O2k8AdbQaTHZW+uPm3b7kf0EwSSNn+K5IQJQgPFYT0x
         NNyuhb/f8zEo+0DB0FGmVWPu0OVIqAEF+XN+1tV643TtZvDj3RU2T5PbA8cD9rowjsJy
         nuQm7VrknLseSMx22Qc6lr6h5IQNgrbQeQRfycqbUCQLErvtPiII/sSqmmvZe8cc/kxl
         q5Wg==
X-Gm-Message-State: APjAAAWENc3GEePpIah9xTjzRSOnm031cA5+TPqpTbOFz7m3S43k1bVx
        H9+fzQTb8ofj6qyutDs133twKNSo7kF2mM3WzCWzEg==
X-Google-Smtp-Source: APXvYqzD02pXdCa28Q/TQNf7iqUBK4qdt7Q9nQ2RH23POG10bbIpDBFKw3IcSH5H+AbKmrvyybOLCYz/TFsMw1+5DBA=
X-Received: by 2002:a05:6e02:8eb:: with SMTP id n11mr1987293ilt.26.1576279758281;
 Fri, 13 Dec 2019 15:29:18 -0800 (PST)
MIME-Version: 1.0
References: <20191213231646.88015-1-jmattson@google.com> <52043F85-F9D7-4EED-B5EB-999CE5CA2065@oracle.com>
In-Reply-To: <52043F85-F9D7-4EED-B5EB-999CE5CA2065@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 13 Dec 2019 15:29:06 -0800
Message-ID: <CALMp9eRGoCdsAWKDdQ-rgLwoTJt5utyx29Se90U96JY6yyaNdg@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Add logical CPU to KVM_EXIT_FAIL_ENTRY info
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 13, 2019 at 3:26 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 14 Dec 2019, at 1:16, Jim Mattson <jmattson@google.com> wrote:
> >
> > More often than not, a failed VM-entry in a production environment is
> > the result of a defective CPU (at least, insofar as Intel x86 is
> > concerned). To aid in identifying the bad hardware, add the logical
> > CPU to the information provided to userspace on a KVM exit with reason
> > KVM_EXIT_FAIL_ENTRY. The presence of this additional information is
> > indicated by a new capability, KVM_CAP_FAILED_ENTRY_CPU.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > ---
> > Documentation/virt/kvm/api.txt | 1 +
> > arch/x86/kvm/svm.c             | 1 +
> > arch/x86/kvm/vmx/vmx.c         | 2 ++
> > arch/x86/kvm/x86.c             | 1 +
> > include/uapi/linux/kvm.h       | 2 ++
> > 5 files changed, 7 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > index ebb37b34dcfc..6e5d92406b65 100644
> > --- a/Documentation/virt/kvm/api.txt
> > +++ b/Documentation/virt/kvm/api.txt
> > @@ -4245,6 +4245,7 @@ hardware_exit_reason.
> >               /* KVM_EXIT_FAIL_ENTRY */
> >               struct {
> >                       __u64 hardware_entry_failure_reason;
> > +                     __u32 cpu; /* if KVM_CAP_FAILED_ENTRY_CPU */
> >               } fail_entry;
> >
> > If exit_reason is KVM_EXIT_FAIL_ENTRY, the vcpu could not be run due
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 122d4ce3b1ab..4d06b2413c63 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -4980,6 +4980,7 @@ static int handle_exit(struct kvm_vcpu *vcpu)
> >               kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> >               kvm_run->fail_entry.hardware_entry_failure_reason
> >                       = svm->vmcb->control.exit_code;
> > +             kvm_run->fail_entry.cpu = raw_smp_processor_id();
>
> Why not just use vcpu->cpu?
> Same for vmx_handle_exit() to be consistent.

Ah. Perfect. Thanks.

> >               dump_vmcb(vcpu);
> >               return 0;
> >       }
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index e3394c839dea..4d540b1c08e0 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5846,6 +5846,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> >               vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> >               vcpu->run->fail_entry.hardware_entry_failure_reason
> >                       = exit_reason;
> > +             vcpu->run->fail_entry.cpu = vmx->loaded_vmcs->cpu;
> >               return 0;
> >       }
> >
> > @@ -5854,6 +5855,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> >               vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> >               vcpu->run->fail_entry.hardware_entry_failure_reason
> >                       = vmcs_read32(VM_INSTRUCTION_ERROR);
> > +             vcpu->run->fail_entry.cpu = vmx->loaded_vmcs->cpu;
> >               return 0;
> >       }
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index cf917139de6b..9e89a32056d1 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3273,6 +3273,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >       case KVM_CAP_GET_MSR_FEATURES:
> >       case KVM_CAP_MSR_PLATFORM_INFO:
> >       case KVM_CAP_EXCEPTION_PAYLOAD:
> > +     case KVM_CAP_FAILED_ENTRY_CPU:
> >               r = 1;
> >               break;
> >       case KVM_CAP_SYNC_REGS:
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index f0a16b4adbbd..09ba7174456d 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -277,6 +277,7 @@ struct kvm_run {
> >               /* KVM_EXIT_FAIL_ENTRY */
> >               struct {
> >                       __u64 hardware_entry_failure_reason;
> > +                     __u32 cpu;
> >               } fail_entry;
> >               /* KVM_EXIT_EXCEPTION */
> >               struct {
> > @@ -1009,6 +1010,7 @@ struct kvm_ppc_resize_hpt {
> > #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
> > #define KVM_CAP_ARM_NISV_TO_USER 177
> > #define KVM_CAP_ARM_INJECT_EXT_DABT 178
> > +#define KVM_CAP_FAILED_ENTRY_CPU 179
> >
> > #ifdef KVM_CAP_IRQ_ROUTING
> >
> > --
> > 2.24.1.735.g03f4e72817-goog
> >
>
