Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30C7114140
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 14:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbfLENLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 08:11:44 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37658 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbfLENLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 08:11:44 -0500
Received: by mail-io1-f67.google.com with SMTP id k24so3538935ioc.4
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 05:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nRzsRVrzIZ8qzsOeQGHmR1zC3AbsQBaHnvSc3LrXPyo=;
        b=Gvd5+fM4MvRzV3/Z7F5e4TXuYksjxgHStYKyp6ntRl4GEjDTSwP+q4f7zMCkwslK8B
         LJAyE2vBldWUjAlR40YMqRYJpGMqUXAiCAej0CWAzCCbkSCSBnc7fcg1IpATZ43M5EF8
         RbEqvyaTpegLgHc2f5Z06q+oz3lnMKktrh3VTInlo0P/UltrETvi+xE5nueBJODSrtOG
         QbSCwCAJ8iDGzOa2Z/P2husbc+Sg/1x2gEqmHvt/5ej7DKUH8JppfU2iSBLQh547dBi9
         yKlobujfj/0oQaRiogWcZ7tjM6VgH95D0mkrWKuL1xu0JYGH0Nljik3KpEv5vYnh56eV
         /IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nRzsRVrzIZ8qzsOeQGHmR1zC3AbsQBaHnvSc3LrXPyo=;
        b=dwBqOHxK9HeMtlRRyMGiBOFElYRRAYzPt9B6cHtxrkV/XgM02NyneW2hlGyo+9FCvS
         RUIiDc6EYogdkeFby4pFiGZF3bwu5hz56JFo7UmPUEmdZ9cCCRG8nCrjVQr+QXsznEzi
         EJ/JfmDic2c05ILnR2ss3YPlOcc23Fd9E7RRt6NnqGsrfCPehfQBkhIl7DcdV0dX8Y3M
         CY6DutQXFCgalvxuoofRWyGEPev+1zbiPWdETehJtusHiv+bRcS46NcMVSjBbMTqPr/9
         SS2ak87pNLWaWihgGyP+gC2Dzf4ATx0sUsszUnW5+Kvy34ADKIE6pvQNf9GojVYD+FRb
         w+SQ==
X-Gm-Message-State: APjAAAWB5rCcN9oFBxpbRg4wcsxNqYv0XyZhjFBJ5AF5+BjZ0Z28eUHz
        PulH6wrAaUGII8LFmzdELgPVd1j5CLhhppcvMH882g==
X-Google-Smtp-Source: APXvYqwBr2QAnzvWwRqIUapAEjYeaiXR8AVLYAVOriZ4h5aU14iVxrDgWZ3vYbKKfmKE4mKiINpq3eOmvEXIDMsoPS4=
X-Received: by 2002:a02:3312:: with SMTP id c18mr8071185jae.24.1575551502650;
 Thu, 05 Dec 2019 05:11:42 -0800 (PST)
MIME-Version: 1.0
References: <20191204214027.85958-1-jmattson@google.com> <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
In-Reply-To: <b9067562-bbba-7904-84f0-593f90577fca@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Dec 2019 05:11:31 -0800
Message-ID: <CALMp9eRbiKnH15NBFk0hrh8udcqZvu6RHm0Nrfh4TikQ3xF6OA@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 5, 2019 at 3:46 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/12/19 22:40, Jim Mattson wrote:
> > According to the SDM, a VMWRITE in VMX non-root operation with an
> > invalid VMCS-link pointer results in VMfailInvalid before the validity
> > of the VMCS field in the secondary source operand is checked.
> >
> > Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if running L2")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 38 +++++++++++++++++++-------------------
> >  1 file changed, 19 insertions(+), 19 deletions(-)
>
> As Vitaly pointed out, the test must be split in two, like this:

Right. Odd that no kvm-unit-tests noticed.

> ---------------- 8< -----------------------
> From 3b9d87060e800ffae2bd19da94ede05018066c87 Mon Sep 17 00:00:00 2001
> From: Paolo Bonzini <pbonzini@redhat.com>
> Date: Thu, 5 Dec 2019 12:39:07 +0100
> Subject: [PATCH] kvm: nVMX: VMWRITE checks VMCS-link pointer before VMCS field
>
> According to the SDM, a VMWRITE in VMX non-root operation with an
> invalid VMCS-link pointer results in VMfailInvalid before the validity
> of the VMCS field in the secondary source operand is checked.
>
> While cleaning up handle_vmwrite, make the code of handle_vmread look
> the same, too.

Okay.

> Fixes: 6d894f498f5d1 ("KVM: nVMX: vmread/vmwrite: Use shadow vmcs12 if running L2")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Cc: Liran Alon <liran.alon@oracle.com>
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4aea7d304beb..c080a879b95d 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4767,14 +4767,13 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>         if (to_vmx(vcpu)->nested.current_vmptr == -1ull)
>                 return nested_vmx_failInvalid(vcpu);
>
> -       if (!is_guest_mode(vcpu))
> -               vmcs12 = get_vmcs12(vcpu);
> -       else {
> +       vmcs12 = get_vmcs12(vcpu);
> +       if (is_guest_mode(vcpu)) {
>                 /*
>                  * When vmcs->vmcs_link_pointer is -1ull, any VMREAD
>                  * to shadowed-field sets the ALU flags for VMfailInvalid.
>                  */
> -               if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
> +               if (vmcs12->vmcs_link_pointer == -1ull)
>                         return nested_vmx_failInvalid(vcpu);
>                 vmcs12 = get_shadow_vmcs12(vcpu);
>         }
> @@ -4878,8 +4877,19 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>                 }
>         }
>
> +       vmcs12 = get_vmcs12(vcpu);
> +       if (is_guest_mode(vcpu)) {
> +               /*
> +                * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
> +                * to shadowed-field sets the ALU flags for VMfailInvalid.
> +                */
> +               if (vmcs12->vmcs_link_pointer == -1ull)
> +                       return nested_vmx_failInvalid(vcpu);
> +               vmcs12 = get_shadow_vmcs12(vcpu);
> +       }
>
>         field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
> +
>         /*
>          * If the vCPU supports "VMWRITE to any supported field in the
>          * VMCS," then the "read-only" fields are actually read/write.
> @@ -4889,24 +4899,12 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>                 return nested_vmx_failValid(vcpu,
>                         VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
>
> -       if (!is_guest_mode(vcpu)) {
> -               vmcs12 = get_vmcs12(vcpu);
> -
> -               /*
> -                * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
> -                * vmcs12, else we may crush a field or consume a stale value.
> -                */
> -               if (!is_shadow_field_rw(field))
> -                       copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
> -       } else {
> -               /*
> -                * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
> -                * to shadowed-field sets the ALU flags for VMfailInvalid.
> -                */
> -               if (get_vmcs12(vcpu)->vmcs_link_pointer == -1ull)
> -                       return nested_vmx_failInvalid(vcpu);
> -               vmcs12 = get_shadow_vmcs12(vcpu);
> -       }
> +       /*
> +        * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
> +        * vmcs12, else we may crush a field or consume a stale value.
> +        */
> +       if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field))
> +               copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
>
>         offset = vmcs_field_to_offset(field);
>         if (offset < 0)
>
>
> ... and also, do you have a matching kvm-unit-tests patch?

I'll put one together, along with a test that shows the current
priority inversion between read-only and unsupported VMCS fields.

> Thanks,
>
> Paolo
>
