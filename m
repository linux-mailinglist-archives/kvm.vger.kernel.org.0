Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E793C7A04
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 01:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbhGMXVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 19:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhGMXVF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 19:21:05 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF1C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 16:18:14 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id m3so9633452qkm.10
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 16:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X7EKvFIO/8O+BrCmufnPNCIDCKJof7TC2G+GPb281Kk=;
        b=vstfIIXpC66V8Fdf4gXiMzbgUIxqHrQh2s9iRgiZ9eMvf3unWbjSWZwMPPrPq3PUoc
         +U3DefG4sYEYRyWdjXmqNPwezvTbwnB8pLyu447a9Ev+FEvtCUVXWrIWsgCEHH5o0bOR
         lRjJUuw7qCUDMXLloWLJjk73ntKVVo+MmURiCiLFzzJujrNkdW1kJTE8IrWukSnbeyca
         KDn0PEMzOHJ7v3a2eY8SRkY+vzOyweW1FmwPay6axcOT2ZaSgvpve+uMQF1ME/sxoSwW
         /1jknaGnzrB4/Q+doN97u6uMvaP2DG46u+zSYP3ydM0he47WVyiTEHYCgQSJxL9N7KB3
         +1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X7EKvFIO/8O+BrCmufnPNCIDCKJof7TC2G+GPb281Kk=;
        b=FNa9G5RdnD973q2f5nh4PAIJSRcM3ulH2qGT214LuJKmFSBMrZJwjyjO9D/k7RU//A
         puvGcL+sBtfAtiIwoSxgqCf9JFQaNZK/Yq57/2CX4BXGhKPjnC96RxWzp1CO3+jS/WL/
         SGuqT8zAQuAVoUtYcCrg38xiXqmTAizkiI7InQdWDT8dcNnf7BKrmlR8aoSjelw9Qj37
         TX0VlAD3KWIV7GfrIqlm7qhAiZomFBzt3pQ3Qv4IBa5vKRcsm1DugwPtj+/zEqxkRvym
         6a4p9tVRk53S7EzdYe8IU2ypLc9IhyziKrszI8WOjTaLXsrX4qJZ+ALoVxpqZU4mUlyr
         UDug==
X-Gm-Message-State: AOAM5326RbhkfP0HmLCuB9PM/UtY6JVgIMC9tssFfT3bf1c7+cBKqSCb
        SEgwVhz9HQCxKNytxmQ++2dfZOuE88pTwzHvOrGy6w==
X-Google-Smtp-Source: ABdhPJw71oxMLOthCOty8sCCNUamAqIXG1dQrWSKcfyxw3TB3eUuJW33VfEC6A0+HHgXbhhD2CzYo5hYvYhgObPdFnw=
X-Received: by 2002:a05:620a:a90:: with SMTP id v16mr6752709qkg.150.1626218293567;
 Tue, 13 Jul 2021 16:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210621163118.1040170-1-pgonda@google.com> <20210621163118.1040170-2-pgonda@google.com>
In-Reply-To: <20210621163118.1040170-2-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 13 Jul 2021 16:18:02 -0700
Message-ID: <CAA03e5EusWamD=awDq2N8zO7R22Ce-7b2nZaaJiE92R7oxHpXQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM, SEV: Refactor out function for unregistering
 encrypted regions
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

On Mon, Jun 21, 2021 at 9:59 AM Peter Gonda <pgonda@google.com> wrote:
>
> Factor out helper function for freeing the encrypted region list.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
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
>
> ---
>  arch/x86/kvm/svm/sev.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 46e339c84998..5af46ff6ec48 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1767,11 +1767,25 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>         return ret;
>  }
>
> +static void __unregister_region_list_locked(struct kvm *kvm,
> +                                           struct list_head *mem_regions)
> +{
> +       struct enc_region *pos, *q;
> +
> +       lockdep_assert_held(&kvm->lock);
> +
> +       if (list_empty(mem_regions))
> +               return;
> +
> +       list_for_each_entry_safe(pos, q, mem_regions, list) {
> +               __unregister_enc_region_locked(kvm, pos);
> +               cond_resched();
> +       }
> +}
> +
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> -       struct list_head *head = &sev->regions_list;
> -       struct list_head *pos, *q;
>
>         if (!sev_guest(kvm))
>                 return;
> @@ -1795,13 +1809,7 @@ void sev_vm_destroy(struct kvm *kvm)
>          * if userspace was terminated before unregistering the memory regions
>          * then lets unpin all the registered memory.
>          */
> -       if (!list_empty(head)) {
> -               list_for_each_safe(pos, q, head) {
> -                       __unregister_enc_region_locked(kvm,
> -                               list_entry(pos, struct enc_region, list));
> -                       cond_resched();
> -               }
> -       }
> +       __unregister_region_list_locked(kvm, &sev->regions_list);
>
>         mutex_unlock(&kvm->lock);
>
> --
> 2.32.0.288.g62a8d224e6-goog

Reviewed-by: Marc Orr <marcorr@google.com>
