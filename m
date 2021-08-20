Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593C93F35CA
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 23:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhHTVBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 17:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhHTVBs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 17:01:48 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077F0C061575
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 14:01:10 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id t66so12301828qkb.0
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 14:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hFKLnnqi/Dpw7z7KzTGlV1/db6RzMAc6Y8UjXQLOhbQ=;
        b=tPH6w/D/mrob2wDKf+lpRu/LME/iVMMs0JKKxfzabgzD2zxn+xgFRLaQ+qwr3x7LlQ
         Lge5mhpT3wm29E8Y1MxpZRo171kRIxi3OCtpLkvqukQinmGoKWKrYxJdOm+sAd4oAT3W
         pOUx9B1X60E+y60laBmKZ7HlJJY0DQmlDxU68uG1bnT5+Wm+Js7uH1/tQ9anQuToNGSI
         8Ub9cxNlYK2pzK/1n4N9Rj/LMGm7RQnbqIfvb0QFnFNlewYdvRTbAa3x2mJNSTdmFRsm
         ks2ItbfuyEaLUfbEi0YfFjoYTrTrCq9XLRRENZScd7PSPUWsxp65VxzT6CCjOyFGmsZK
         7f0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hFKLnnqi/Dpw7z7KzTGlV1/db6RzMAc6Y8UjXQLOhbQ=;
        b=J5cKPV+iLrFHBX4+I+2yQcaF88RzGtrSLn5J1I3j1Yx2Ks/+r0NOzDxC6qE3RetW5h
         LDBzBq8hoMW6LVyeq4Mxeo6BHYuvmxkyoWChxmpiJboBn9qdLMNgQO11FcOAzyjKftyd
         iIV/r/IuCnKkEU0dl8kzwxpQuy+B/Ej0bsGsncH4NTaP5lP4VuuWBiBcl/m4E5v+rImF
         RqN0SJ85tXC2lUdPirVgNgUJWXeNIlF4mY60Lb+ABYr0aUzPokz05a6DPqr7JnubqcM7
         o5NMHtUzbR4b4z2Yr1v2YHtJBcIr6rQOxu8XBWxKG3Uu4qH3HtmljXuXqdjjyiRuhyAX
         ZHBA==
X-Gm-Message-State: AOAM533g29Ektc/TztBEI+/wdh4c5bkCyv8P3+Kjk/Un8uq6W0iOh1tx
        GzW4ZplIYBVo/kMw+AGxfOeTvWwBB15uQeorunQ9Pw==
X-Google-Smtp-Source: ABdhPJwWnDBr7vwtUzWMyPt8C+NJaLfm4Oe/LTA5LuA5TmMpDI/Ii9Yncf/2/Q8qDG0GdVdi9qpPRlQEFlwCYbQq9VQ=
X-Received: by 2002:a05:620a:204e:: with SMTP id d14mr10687840qka.147.1629493268884;
 Fri, 20 Aug 2021 14:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210819154910.1064090-1-pgonda@google.com> <20210819154910.1064090-3-pgonda@google.com>
In-Reply-To: <20210819154910.1064090-3-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 20 Aug 2021 14:00:57 -0700
Message-ID: <CAA03e5Hx_BW806LRnsm7jL6tH2YdwVZ2x49UsNe3M93_Kz0WXg@mail.gmail.com>
Subject: Re: [PATCH 2/2 V4] KVM, SEV: Add support for SEV-ES intra host migration
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 8:49 AM Peter Gonda <pgonda@google.com> wrote:
>
> For SEV-ES to work with intra host migration the VMSAs, GHCB metadata,
> and other SEV-ES info needs to be preserved along with the guest's
> memory.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kvm/svm/sev.c | 58 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 55 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2d98b56b6f8c..970d75c34e9a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1554,6 +1554,53 @@ static void migrate_info_from(struct kvm_sev_info *dst,
>         list_replace_init(&src->regions_list, &dst->regions_list);
>  }
>
> +static int migrate_vmsa_from(struct kvm *dst, struct kvm *src)
> +{
> +       int i, num_vcpus;
> +       struct kvm_vcpu *dst_vcpu, *src_vcpu;
> +       struct vcpu_svm *dst_svm, *src_svm;
> +
> +       num_vcpus = atomic_read(&dst->online_vcpus);
> +       if (num_vcpus != atomic_read(&src->online_vcpus)) {
> +               pr_warn_ratelimited(
> +                       "Source and target VMs must have same number of vCPUs.\n");
> +               return -EINVAL;
> +       }
> +
> +       for (i = 0; i < num_vcpus; ++i) {
> +               src_vcpu = src->vcpus[i];
> +               if (!src_vcpu->arch.guest_state_protected) {
> +                       pr_warn_ratelimited(
> +                               "Source ES VM vCPUs must have protected state.\n");
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       for (i = 0; i < num_vcpus; ++i) {
> +               src_vcpu = src->vcpus[i];
> +               src_svm = to_svm(src_vcpu);
> +               dst_vcpu = dst->vcpus[i];
> +               dst_svm = to_svm(dst_vcpu);
> +
> +               dst_vcpu->vcpu_id = src_vcpu->vcpu_id;
> +               dst_svm->vmsa = src_svm->vmsa;
> +               src_svm->vmsa = NULL;
> +               dst_svm->ghcb = src_svm->ghcb;
> +               src_svm->ghcb = NULL;
> +               dst_svm->vmcb->control.ghcb_gpa =
> +                               src_svm->vmcb->control.ghcb_gpa;

Should we clear `src_svm->vmcb->control.ghcb_gpa`? (All the other
fields in `srv_svm` that are copied are then cleared, except for this
one.) Aside: Do we really need to clear all of the fields in `src_svm`
after they're copied over? It might be worth adding a comment to
explain why we're clearing them. It's not immediately obvious to me
why we're doing that.

> +               dst_svm->ghcb_sa = src_svm->ghcb_sa;
> +               src_svm->ghcb_sa = NULL;
> +               dst_svm->ghcb_sa_len = src_svm->ghcb_sa_len;
> +               src_svm->ghcb_sa_len = 0;
> +               dst_svm->ghcb_sa_sync = src_svm->ghcb_sa_sync;
> +               src_svm->ghcb_sa_sync = false;
> +               dst_svm->ghcb_sa_free = src_svm->ghcb_sa_free;
> +               src_svm->ghcb_sa_free = false;
> +       }
> +       return 0;
> +}
> +
>  int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>  {
>         struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1565,7 +1612,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>         if (ret)
>                 return ret;
>
> -       if (!sev_guest(kvm) || sev_es_guest(kvm)) {
> +       if (!sev_guest(kvm)) {
>                 ret = -EINVAL;
>                 pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");
>                 goto out_unlock;
> @@ -1589,15 +1636,20 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
>         if (ret)
>                 goto out_fput;
>
> -       if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
> +       if (!sev_guest(source_kvm)) {
>                 ret = -EINVAL;
>                 pr_warn_ratelimited(
>                         "Source VM must be SEV enabled to migrate from.\n");
>                 goto out_source;
>         }
>
> +       if (sev_es_guest(kvm)) {
> +               ret = migrate_vmsa_from(kvm, source_kvm);
> +               if (ret)
> +                       goto out_source;
> +       }
>         migrate_info_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
> -        ret = 0;
> +       ret = 0;

nit: looks like there's some space issue on this line. Since I believe
this line was introduced in the previous patch, I wouldn't expect it
to show up with a diff in patch #2.

>  out_source:
>         svm_unlock_after_migration(source_kvm);
> --
> 2.33.0.rc1.237.g0d66db33f3-goog

This patch looks good overall to me.

Reviewed-by: Marc Orr <marcorr@google.com>
