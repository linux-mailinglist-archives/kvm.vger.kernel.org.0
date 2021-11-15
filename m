Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E5445159F
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 21:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352280AbhKOUoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 15:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242183AbhKOUKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 15:10:21 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8937C061234
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:51:32 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id k23so9829485lje.1
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 11:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FqQWR88PfuH6viWEg1VKiu8Fxld4zRCDkmocgGjhxJM=;
        b=SqdraDxrI/nmSCo3A9X4yl4pw+SmGoE3oDXBBQs/PpKkbxma/sjYndCHHIJY/Z/rXP
         mpwvuasKpyqjyg5aqF514QIugrgJHYuXAXG+L3bHnG3RV/TG8V6TfpLPczuVOu1GFLzF
         vwWtowblWGzptHoOimhsV/nqyW5lVD475+GkIUlyofDob/OhZZ9X1Ir5eTbnH5A4i1AS
         VXdjf5f8uR8HXVoP0n+fucsMAafRWDUseBAingvW6I1a38G7gwV3KiteObTA48QZBEI/
         XGe4hKcH4AwKnJr/BwLHCavnISWFBvGieDW8tuNBZfaKTnFO0i22rBtB8kZc1PONQs/Q
         kVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FqQWR88PfuH6viWEg1VKiu8Fxld4zRCDkmocgGjhxJM=;
        b=a/WVfPLtdGSk+9oaUJoazpPaGEZzhljvtY72Gt4BNQHeIZk3ZJgUT4574bsSDRd1C1
         29D2mzCPnSG9c2IUPNOTpIcl3VhOOTsIsk9PnW4s1wj5bul8CZD2vSfVWaYda9PqKg1q
         gWAR5CVUzNj7de8O5QvF9caVfas4tdQS0VCMVwkaRYyFjmxUc/OvnDWUAYbueGs2X6GZ
         0eR0va46vME4iZDUTmVFIJfeWK5J5CVRr0vfCupjRGiQMSbu76Q0/VUWwGbkROplk8ni
         T6vhvGm2+dcbj0U2IpcoVsVeJqhHFdASNHXgm2sbA2HstR5jj+1rD88TLUpKcuGZR0o9
         opQA==
X-Gm-Message-State: AOAM531r+60hUd8NczSHIW87aQiY8/bSVEmOSePUr7YjeqO6ekx7Q+5w
        5KjziAERPDqz1St+SnDFHhqSP2jPnnWSw9q+sVryhQ==
X-Google-Smtp-Source: ABdhPJzVkfqISpGf8xMX7i7C6sh3Y99ZApFvj7WdxSOET84+pFRoHE8nQLJAh1RyU7/BOJydtwnZUjVqojmwcYCNQ10=
X-Received: by 2002:a05:651c:1507:: with SMTP id e7mr1150625ljf.83.1637005890725;
 Mon, 15 Nov 2021 11:51:30 -0800 (PST)
MIME-Version: 1.0
References: <20211109215101.2211373-1-seanjc@google.com> <20211109215101.2211373-2-seanjc@google.com>
In-Reply-To: <20211109215101.2211373-2-seanjc@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 15 Nov 2021 12:51:19 -0700
Message-ID: <CAMkAt6qLVLsP6_0X_u+zdRT99rutphZ11y-1-hEUQ8KZOUU8tA@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: SEV: Disallow COPY_ENC_CONTEXT_FROM if target
 has created vCPUs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 9, 2021 at 2:53 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Reject COPY_ENC_CONTEXT_FROM if the destination VM has created vCPUs.
> KVM relies on SEV activation to occur before vCPUs are created, e.g. to
> set VMCB flags and intercepts correctly.
>
> Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
> Cc: stable@vger.kernel.org
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Nathan Tempelman <natet@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3e2769855e51..eeec499e4372 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1775,7 +1775,12 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>         mutex_unlock(&source_kvm->lock);
>         mutex_lock(&kvm->lock);
>
> -       if (sev_guest(kvm)) {
> +       /*
> +        * Disallow out-of-band SEV/SEV-ES init if the target is already an
> +        * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
> +        * created after SEV/SEV-ES initialization, e.g. to init intercepts.
> +        */
> +       if (sev_guest(kvm) || kvm->created_vcpus) {
>                 ret = -EINVAL;
>                 goto e_mirror_unlock;
>         }

Now that we have some framework for running SEV related selftests, do
you mind adding a regression test for this change?

> --
> 2.34.0.rc0.344.g81b53c2807-goog
>
