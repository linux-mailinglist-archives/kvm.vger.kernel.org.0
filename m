Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013396569C2
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 12:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiL0LPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 06:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiL0LOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 06:14:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF9F2E9
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672139645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bZYacPdkOeKkUF+8E+NKgm04sBXoJCSeU32YMBjx4M8=;
        b=Ze0qZwM1Lq/M6k09LoJhiZ5EBIia47BxSESAKw0vpQcbNdP6Lc0TXSRFQ6Zadq6j870+pY
        EvhH/npTn8heoPaXhmJiekrS3a1OW3tB0iXYpmCM6zVOJoHZP1mVnD1mXfxb+jEvgIvEjh
        FceysIksUt/FG1pf09b7QeqapjwB3Ng=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-638-egRUFv2DPPOJhKYyoc2Ctw-1; Tue, 27 Dec 2022 06:14:03 -0500
X-MC-Unique: egRUFv2DPPOJhKYyoc2Ctw-1
Received: by mail-ed1-f71.google.com with SMTP id z16-20020a05640235d000b0046d0912ae25so9093159edc.5
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:14:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bZYacPdkOeKkUF+8E+NKgm04sBXoJCSeU32YMBjx4M8=;
        b=kC22asW9Mo/IEK6KGwyxvLLPp6zkQPaAXxxhsl9Y1csHocGDJZaAmHxfbTlXjsHiD4
         oNfy4n1SlN9vg+ZO0bRg1rDQ8DczbaxqK4LEg4mhKEJRn8PBvPVtyyS6U2n0lD+ObhGE
         /13hT85qtCum84zPiV2iC3lIUzgYlkSdX2pC545f2tP5mJIzPUWED7gURrn3ocjBCDcz
         zJcTNV2Ocom+nFPgferaHjpMuqXFgCdHjmegW64RHniM379EW+US0NtRoSmdgEgw+EtC
         0h5hn2KLnNKUYjJH6EUudhzSQSWdEV3EnzWwclzXpoRV3PamGh9ofCW12vQCcgs4rmGm
         MRJg==
X-Gm-Message-State: AFqh2krUascjsf+KvymtEXabVy6kClHdYQi9EKlrsW3B3lSwWkmtQZWi
        OIvZLtfa8346+8NjuZvCuJiIfu69ow9uSCbYpDeSWApyPuzJ2hC79nal6VQZoamoJghWi8Wl4jd
        hDQY51/bGiPK5
X-Received: by 2002:a17:906:684b:b0:7c1:ff4:d0c6 with SMTP id a11-20020a170906684b00b007c10ff4d0c6mr18861910ejs.36.1672139641735;
        Tue, 27 Dec 2022 03:14:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuTvHu5LyN039mR0jxQHt/DogLpF/rlAQJnHb2v8rN4ygI+wL79VyNiKL5Cu3d62r3keQzLZA==
X-Received: by 2002:a17:906:684b:b0:7c1:ff4:d0c6 with SMTP id a11-20020a170906684b00b007c10ff4d0c6mr18861894ejs.36.1672139641325;
        Tue, 27 Dec 2022 03:14:01 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id 18-20020a170906301200b007bf5250b515sm5889017ejz.29.2022.12.27.03.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 03:14:00 -0800 (PST)
Message-ID: <4500b24d-8ac0-c7a8-dd8d-bbb660752c71@redhat.com>
Date:   Tue, 27 Dec 2022 12:14:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] KVM: use unified srcu interface function
Content-Language: en-US
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
References: <CAPm50aKYh-qXt_MmQvbSH6Tye=yxrwAp_x_jcJHh=8ZoA=1P_A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAPm50aKYh-qXt_MmQvbSH6Tye=yxrwAp_x_jcJHh=8ZoA=1P_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/25/22 13:48, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> kvm->irq_routing is protected by kvm->irq_srcu.
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>

Please use the same email to send your message from, for the author, and 
for the Signed-off-by.

Perhaps you can do

git config user.name "Peng Hao (Tencent)"
git config user.email flyingpenghao@gmail.com

?  This is a common set up for people that do not use the company email 
to write to mailing lists.

Paolo

> ---
>   virt/kvm/irqchip.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 1e567d1f6d3d..d3ccfe922880 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -18,6 +18,10 @@
>   #include <linux/export.h>
>   #include <trace/events/kvm.h>
> 
> +#define kvm_get_irq_routing(kvm) \
> +       srcu_dereference_check((kvm)->irq_routing, &(kvm)->irq_srcu,    \
> +                               lockdep_is_held(&(kvm)->irq_lock))
> +
>   int kvm_irq_map_gsi(struct kvm *kvm,
>                      struct kvm_kernel_irq_routing_entry *entries, int gsi)
>   {
> @@ -25,8 +29,7 @@ int kvm_irq_map_gsi(struct kvm *kvm,
>          struct kvm_kernel_irq_routing_entry *e;
>          int n = 0;
> 
> -       irq_rt = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
> -                                       lockdep_is_held(&kvm->irq_lock));
> +       irq_rt = kvm_get_irq_routing(kvm);
>          if (irq_rt && gsi < irq_rt->nr_rt_entries) {
>                  hlist_for_each_entry(e, &irq_rt->map[gsi], link) {
>                          entries[n] = *e;
> @@ -216,7 +219,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
>          }
> 
>          mutex_lock(&kvm->irq_lock);
> -       old = rcu_dereference_protected(kvm->irq_routing, 1);
> +       old = kvm_get_irq_routing(kvm);
>          rcu_assign_pointer(kvm->irq_routing, new);
>          kvm_irq_routing_update(kvm);
>          kvm_arch_irq_routing_update(kvm);
> --
> 2.27.0

