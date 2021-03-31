Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFF834F64D
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 03:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhCaBls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 21:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhCaBlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 21:41:22 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BBDC061574;
        Tue, 30 Mar 2021 18:41:21 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso17480353otq.3;
        Tue, 30 Mar 2021 18:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FwTk7Uw5F75P1AWalfGsAJn2SsFNx4MbYfUVHPETdms=;
        b=bDZwxEbD9OJWmz0PQrB65GzWm2jqwI7C8bGTPZ6dFkhtKfJe/Sn+2oIqMA36LCTOq0
         gXmqPCKiQ/l3hlmicCHBqiFOC5sJw8LEwDU+Hm2076b7zHLJpO2tSkqeyfe+g3Nr08Mo
         z5K0KEItAOtYM3xaQNFo3KEYKf/1cPnTT36gKCVlVuewrZWfcF6bgASoYPFqLJvhF7Nm
         CXXplHN97sNHw9zNZLTrMoDf45RhlE0WD/cNrjQrDvCHd+sXTf18riqmt7550miseADe
         Eay2qSCba3ZKM+ZBuUh1Xn/bhHWp1MxeTTIEmUzo78RcHB+1J7jdnyJvUa45VI1ekjJ+
         v1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FwTk7Uw5F75P1AWalfGsAJn2SsFNx4MbYfUVHPETdms=;
        b=Ru6Jf1CK3DG2lMJ94NsO298bFO5f5GuJ7YWvlh9nAkIwxZN8Htx2B+u753uPwwWJNf
         Y+yXZgzqJHQS9S/kJpLfVWTEoEcTgccMoVnrdAvxwBPrBoYRJqNcbbBX7dkkEJ/XyqLR
         AF7B2wdOObWpTWuXqphPBM37SszCPJ62+SqqTIhUrmP4BYRyeuqL4KL5ahNAdl9AQAS5
         npDgASath2ofJ9ZasRSK8Pj/1OGG7/yqnsX4L483T8gH99QoW2MXw2Iid6qCTMysYXj1
         4LcAyXlIZmCU2tD3PT1Nt7lnfm612f6pCwA0hqWVhxdm4Yfx+xng23ZleU977Fubn8Oo
         lC6g==
X-Gm-Message-State: AOAM533nDLBWLZsQqSJEui9iTdQbf1bNW6r7Szv8uexa2mwKfZq/vx8e
        Mov+mzLLqQv22TlWSv0S7kmCBZkExguDDjHeuRg=
X-Google-Smtp-Source: ABdhPJxNU/zkkQc3mvXwJJGCzeK3rm35lItyeHVTXYPqwT2zLyPWFvFtvSrH6Hb+/K4hh98Ah6X5LcFLMeOTqCfIKO4=
X-Received: by 2002:a05:6830:22c3:: with SMTP id q3mr627896otc.56.1617154881330;
 Tue, 30 Mar 2021 18:41:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210330165958.3094759-1-pbonzini@redhat.com> <20210330165958.3094759-2-pbonzini@redhat.com>
In-Reply-To: <20210330165958.3094759-2-pbonzini@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 31 Mar 2021 09:41:08 +0800
Message-ID: <CANRm+CxiN0DPJMCoYzeQ5FMCfw8Cyp0CvGftFs68dz+-rrTCiw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: x86: reduce pvclock_gtod_sync_lock critical sections
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Mar 2021 at 01:02, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> There is no need to include changes to vcpu->requests into
> the pvclock_gtod_sync_lock critical section.  The changes to
> the shared data structures (in pvclock_update_vm_gtod_copy)
> already occur under the lock.
>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

> ---
>  arch/x86/kvm/x86.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe806e894212..0a83eff40b43 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2562,10 +2562,12 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
>
>         kvm_hv_invalidate_tsc_page(kvm);
>
> -       spin_lock(&ka->pvclock_gtod_sync_lock);
>         kvm_make_mclock_inprogress_request(kvm);
> +
>         /* no guest entries from this point */
> +       spin_lock(&ka->pvclock_gtod_sync_lock);
>         pvclock_update_vm_gtod_copy(kvm);
> +       spin_unlock(&ka->pvclock_gtod_sync_lock);
>
>         kvm_for_each_vcpu(i, vcpu, kvm)
>                 kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> @@ -2573,8 +2575,6 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
>         /* guest entries allowed */
>         kvm_for_each_vcpu(i, vcpu, kvm)
>                 kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
> -
> -       spin_unlock(&ka->pvclock_gtod_sync_lock);
>  #endif
>  }
>
> @@ -7740,16 +7740,14 @@ static void kvm_hyperv_tsc_notifier(void)
>                 struct kvm_arch *ka = &kvm->arch;
>
>                 spin_lock(&ka->pvclock_gtod_sync_lock);
> -
>                 pvclock_update_vm_gtod_copy(kvm);
> +               spin_unlock(&ka->pvclock_gtod_sync_lock);
>
>                 kvm_for_each_vcpu(cpu, vcpu, kvm)
>                         kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>
>                 kvm_for_each_vcpu(cpu, vcpu, kvm)
>                         kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
> -
> -               spin_unlock(&ka->pvclock_gtod_sync_lock);
>         }
>         mutex_unlock(&kvm_lock);
>  }
> --
> 2.26.2
>
>
