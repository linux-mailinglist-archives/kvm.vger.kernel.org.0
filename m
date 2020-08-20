Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E724F24C529
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 20:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgHTSRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 14:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgHTSRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 14:17:33 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CA0C061385
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 11:17:33 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id u24so2694229oic.7
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 11:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AqwNbu1HWUt4R6j2fAlPtVcc+T0GWfE6Bpd2JZpeu5s=;
        b=uPwlzmqhgX/EYgnmB9sD9UPHBsB3TKTCLtOrSlZgdZtcUZshPmYfdinO29QNTlYBUb
         Iu9VNU53LM4lO0MhcbWZUW048qtAjy+X0y2VIGVh8ICwqk18NU1dG2c+9i5ljMhkk34R
         IFuqBqupiwFu9o1cNHRmK23NjpPDSIG5E6qa9oF/847cU6J5V1tG/bpOkmqviQervfAD
         fER1/rte0aWzpahDSpLtWq4+FPrOy52IP4pTMRCQTG8j7t+2HCj5QGsYyKYp/hQO7Z13
         FOXF4wDFBnF3xL1IopjT5OxvntOWSQGvxRDUXSpiitP7CBtIWlerq+HlAHGK+b24hzFO
         po1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AqwNbu1HWUt4R6j2fAlPtVcc+T0GWfE6Bpd2JZpeu5s=;
        b=EGquHjhymgj+LtCtdCgtA0rdOTJ+/Bk6JvKxHgFGkCQMuTk43vb+4h29mZbPXOoL8p
         LqmDPrxg9w6i0mrAbuAJaUqRbaadJ2Wp4YsNm4N+K2vxMeml+P0fEFIOF51+laDXF9AA
         jK1n+Xkxdzf1ccun6QOk1F7OzIci7A2cNTOOGbJUUXqv4rLXlWyGYNi5cBi2CEcYsLoo
         sOzYUXMK3DvCB6N+iWX+YB0FCceuBBqY0EpcbK7ia7nP+tXlFvXWLnkPxGwRm93kzqGs
         x6SCwUS3Wd9dk+/bNUCFj0wY+vNs9Qgvip0Tw2dzGK4kXMTHotpCbesDw+aJyJtDXfIK
         ca4w==
X-Gm-Message-State: AOAM531UaT3Wt47CLatCpBLXyTNozBIGcGM02ucHaqjVqY9ANtBm4uiL
        HpzHxsJBs3fpvEh910FXZj4nrY5afL3qn7iNYMFnQw==
X-Google-Smtp-Source: ABdhPJwynxn3yXrfU1irra19+aSE4N/ho4km47OwhxJ5a3SznZlvWjavZemDmOTKcffqapgqGswuLSliEnb3Z1uqpoI=
X-Received: by 2002:aca:b942:: with SMTP id j63mr74013oif.28.1597947452528;
 Thu, 20 Aug 2020 11:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com> <20200818211533.849501-6-aaronlewis@google.com>
In-Reply-To: <20200818211533.849501-6-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 11:17:20 -0700
Message-ID: <CALMp9eQoPcMRmt8EAfh9AFF8vskbkWogXc5o3m6-f8fX5RndwA@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] KVM: x86: Add support for exiting to userspace
 on rdmsr or wrmsr
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Alexander Graf <graf@amazon.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 2:16 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add support for exiting to userspace on a rdmsr or wrmsr instruction if
> the MSR being read from or written to is in the user_exit_msrs list.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>
> v2 -> v3
>
>   - Refactored commit based on Alexander Graf's changes in the first commit
>     in this series.  Changes made were:
>       - Updated member 'inject_gp' to 'error' based on struct msr in kvm_run.
>       - Move flag 'vcpu->kvm->arch.user_space_msr_enabled' out of
>         kvm_msr_user_space() to allow it to work with both methods that bounce
>         to userspace (msr list and #GP fallback).  Updated caller functions
>         to account for this change.
>       - trace_kvm_msr has been moved up and combine with a previous call in
>         complete_emulated_msr() based on the suggestion made by Alexander
>         Graf <graf@amazon.com>.
>
> ---

> @@ -1653,9 +1663,6 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
>                               u32 exit_reason, u64 data,
>                               int (*completion)(struct kvm_vcpu *vcpu))
>  {
> -       if (!vcpu->kvm->arch.user_space_msr_enabled)
> -               return 0;
> -
>         vcpu->run->exit_reason = exit_reason;
>         vcpu->run->msr.error = 0;
>         vcpu->run->msr.pad[0] = 0;
> @@ -1686,10 +1693,18 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
>         u64 data;
>         int r;
>
> +       if (kvm_msr_user_exit(vcpu->kvm, ecx)) {
> +               kvm_get_msr_user_space(vcpu, ecx);
> +               /* Bounce to user space */
> +               return 0;
> +       }
> +
> +
>         r = kvm_get_msr(vcpu, ecx, &data);
>
>         /* MSR read failed? See if we should ask user space */
> -       if (r && kvm_get_msr_user_space(vcpu, ecx)) {
> +       if (r && vcpu->kvm->arch.user_space_msr_enabled) {
> +               kvm_get_msr_user_space(vcpu, ecx);
>                 /* Bounce to user space */
>                 return 0;
>         }

The before and after bounce to userspace is unfortunate. If we can
consolidate the allow/deny list checks at the top of kvm_get_msr(),
and we can tell why kvm_get_msr() failed (e.g. -EPERM=disallowed,
-ENOENT=unknown MSR, -EINVAL=illegal access), then we can eliminate
the first bounce to userspace above. -EPERM would always go to
userspace. -ENOENT would go to userspace if userspace asked to handle
unknown MSRs. -EINVAL would go to userspace if userspace asked to
handle all #GPs. (Yes; I'd still like to be able to distinguish
between "unknown MSR" and "illegal value." Otherwise, it seems
impossible for userspace to know how to proceed.)

(You may ask, "why would you get -EINVAL on a RDMSR?" This would be
the case if you tried to read a write-only MSR, like IA32_FLUSH_CMD.)

> @@ -1715,10 +1730,17 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>         u64 data = kvm_read_edx_eax(vcpu);
>         int r;
>
> +       if (kvm_msr_user_exit(vcpu->kvm, ecx)) {
> +               kvm_set_msr_user_space(vcpu, ecx, data);
> +               /* Bounce to user space */
> +               return 0;
> +       }
> +
>         r = kvm_set_msr(vcpu, ecx, data);
>
>         /* MSR write failed? See if we should ask user space */
> -       if (r && kvm_set_msr_user_space(vcpu, ecx, data)) {
> +       if (r && vcpu->kvm->arch.user_space_msr_enabled) {
> +               kvm_set_msr_user_space(vcpu, ecx, data);
>                 /* Bounce to user space */
>                 return 0;
>         }

Same idea as above.

> @@ -3606,6 +3628,25 @@ static int kvm_vm_ioctl_set_exit_msrs(struct kvm *kvm,
>         return 0;
>  }
>
> +bool kvm_msr_user_exit(struct kvm *kvm, u32 index)
> +{
> +       struct kvm_msr_list *exit_msrs;
> +       int i;
> +
> +       exit_msrs = kvm->arch.user_exit_msrs;
> +
> +       if (!exit_msrs)
> +               return false;
> +
> +       for (i = 0; i < exit_msrs->nmsrs; ++i) {
> +               if (exit_msrs->indices[i] == index)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +EXPORT_SYMBOL_GPL(kvm_msr_user_exit);

I think this should probably be scrapped, along with Alexander's
allow-list check, in favor of a rule-based allow/deny list approach as
I outlined in an earlier message today.
