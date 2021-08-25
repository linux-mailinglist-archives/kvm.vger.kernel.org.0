Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3951A3F6E14
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 06:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhHYEGn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 00:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhHYEGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 00:06:43 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBCCC061757;
        Tue, 24 Aug 2021 21:05:58 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a21so29150136ioq.6;
        Tue, 24 Aug 2021 21:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NZoI/2t89xBZsKpePuesqEGL96FIMPFUNLVpR72Rozg=;
        b=EegF7oqbZkc2syS4cXBmSapTwbjI4P79ZFnOvmTcRGDf1kVVRrqdOELBgYukAMVcRF
         E5L0A65z7uT82650RwrmS3opolb9Z0mBUOg4LsgLiDhQldz++hVRAipq2bIJghRVUEHd
         wN+ZgZFdXl7G+cbp2HlnKij+sP9dWtX9h1sr6fh+Thp2l4oajwXETlk4CL3tjSQP95Kq
         JRg1F4lVdlrkiu7JvQ6zV4mvbwfrJinel9BV6bjsC9Wwo2t8Dtfov7YT27pmbBuQz/jf
         Hp0lXMS5ZggnkGmfhrAjIkOhfyJr3MU4MyRLSGqJ78LkVbcAv6TxYqsGfoRd66ksCdF9
         w3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NZoI/2t89xBZsKpePuesqEGL96FIMPFUNLVpR72Rozg=;
        b=e7BDFNsQjNKMBlkhlgs+E2MkH0GQtsfAKecuhwxinEiairYO5cTkEdsYGQYvs8PT3Y
         HnCV/aDiflBVJCKLWF25AyFe7qa6jvGekpEsXqQHJLBU1XqFa0aAzzEwhK3uJm8tcC7o
         AI4BIjnFKnOqaZRcnEa5ynpVeMsM/SWKPJafpELh65R1HbSkGOwHXksJQwoVHHAHj1F4
         6mptRVpIdEbG7sfDck3EnIu3WgK77QdsdGUWlxxDU74jnjhPKNa8Y4c3WQ4xxkFID1zi
         /DMooDkcuq9+Xj26cTIGdzOP3etaSV7VOFoNy7NkDAlRLppH+xB+xpItk9Vs7oYYRLy0
         0U0g==
X-Gm-Message-State: AOAM530yZB4GoHFjq3K5kU2G7ZqUOcoSak80UdEZhX5iXF3ZibUEgJAY
        B+f4V3qc7E7yUoEsh4HkUFSSa60nwRIeeTfAdHY=
X-Google-Smtp-Source: ABdhPJyBMWkZD2uYn2FqafJci0TEl6KsEXYS9GefAs47Rcnz5EruGKrU3wGb07bVNKki4a1w4hfLPGSN8iSuh7e6ies=
X-Received: by 2002:a5d:96da:: with SMTP id r26mr34232231iol.47.1629864357564;
 Tue, 24 Aug 2021 21:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210821000501.375978-1-seanjc@google.com> <20210821000501.375978-3-seanjc@google.com>
In-Reply-To: <20210821000501.375978-3-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Wed, 25 Aug 2021 12:05:45 +0800
Message-ID: <CAJhGHyB1RjBLRLtaS80XQSTb0g35smxnBQPjEp-BwieKu1cwXw@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: Guard cpusmask NULL check with CONFIG_CPUMASK_OFFSTACK
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 21, 2021 at 8:09 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Check for a NULL cpumask_var_t when kicking multiple vCPUs if and only if
> cpumasks are configured to be allocated off-stack.  This is a meaningless
> optimization, e.g. avoids a TEST+Jcc and TEST+CMOV on x86, but more
> importantly helps document that the NULL check is necessary even though
> all callers pass in a local variable.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 786b914db98f..82c5280dd5ce 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -247,7 +247,7 @@ static void ack_flush(void *_completed)
>
>  static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
>  {
> -       if (unlikely(!cpus))
> +       if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && unlikely(!cpus))
>                 cpus = cpu_online_mask;
>
>         if (cpumask_empty(cpus))
> @@ -277,6 +277,14 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>                 if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
>                         continue;
>
> +               /*
> +                * tmp can be NULL if cpumasks are allocated off stack, as
> +                * allocation of the mask is deliberately not fatal and is
> +                * handled by falling back to kicking all online CPUs.
> +                */
> +               if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && !tmp)
> +                       continue;
> +

Hello, Sean

I don't think it is a good idea to reinvent the cpumask_available().
You can rework the patch as the following code if cpumask_available()
fits for you.

Thanks
Lai

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e67c93ca403..ca043ec7ed74 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -245,9 +245,11 @@ static void ack_flush(void *_completed)
 {
 }

-static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
+static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
 {
-       if (unlikely(!cpus))
+       const struct cpumask *cpus = tmp;
+
+       if (unlikely(!cpumask_available(tmp)))
                cpus = cpu_online_mask;

        if (cpumask_empty(cpus))
@@ -278,7 +280,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm,
unsigned int req,
                if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
                        continue;

-               if (tmp != NULL && cpu != -1 && cpu != me &&
+               if (cpumask_available(tmp) && cpu != -1 && cpu != me &&
                    kvm_request_needs_ipi(vcpu, req))
                        __cpumask_set_cpu(cpu, tmp);
        }

>                 /*
>                  * Note, the vCPU could get migrated to a different pCPU at any
>                  * point after kvm_request_needs_ipi(), which could result in
> @@ -288,7 +296,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>                  * were reading SPTEs _before_ any changes were finalized.  See
>                  * kvm_vcpu_kick() for more details on handling requests.
>                  */
> -               if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
> +               if (kvm_request_needs_ipi(vcpu, req)) {
>                         cpu = READ_ONCE(vcpu->cpu);
>                         if (cpu != -1 && cpu != me)
>                                 __cpumask_set_cpu(cpu, tmp);
> --
> 2.33.0.rc2.250.ged5fa647cd-goog
>
