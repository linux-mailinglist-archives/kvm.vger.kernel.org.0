Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B2E512A0E
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 05:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242398AbiD1DnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 23:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiD1DnA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 23:43:00 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFB36FF49;
        Wed, 27 Apr 2022 20:39:47 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2f7c424c66cso39701947b3.1;
        Wed, 27 Apr 2022 20:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mihABchek1Eixq9pTsDEvJD+Zdo5A9r3WorbFfIZpzE=;
        b=diTUXy8/eVt0YaxdFzg9kwj1y5VW3ZYyIAG1VcXLNwlNPGJISgVE10tKvWxYEWuhk2
         vi1EPHKpghMO6o7uuxgxptKqbBG0EGFz1Psijc+IDqg5IkL48Ri8NSPXOvrobrKtokZx
         hui3skwT7H99rLlyfEunD6715gz3CiVWjxVlhNeJQcGgxyfbMe6q80utgN/ElepuTkHs
         R5JbVYXeknk+2GILtar3Z+2a+YVwj/6EOVlqquxwO3yXFoe9eoPV1BYHRvUZxJ3FN92A
         ciAImVCI51fJAeUxQO2VVn1Q/K1HwIwHU3YE1WM/UY3ts2p1zKj6UDLmRl6Nf/cNEvLT
         j7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mihABchek1Eixq9pTsDEvJD+Zdo5A9r3WorbFfIZpzE=;
        b=1oavkV0Mq5aSOPXB7zb1DXmpPOPQx4hZapucrLTcyjiKM/DzGAyZNDAyYplHn3qiyG
         j6nMqUvwVyCtwnsRj2jlpQXDth29sxcDF5MRQAEOgdm+0aiI0RCouirk/hEX53jlsLKq
         AH6iKbPEkcyUOipqtDzTq5mcrbrN4sLct9CdUxFmdtqa3KTIptJAaVit4tLxNfFFpVYQ
         21JGp2MrDsxWrD1ELAs0bCupvEkBF86ZQAqeHh6FWQ05rISYr1swboGktGyhaMkzzsGo
         M9zkldUGA9LT2U4f5xbQTo1mbpPBsymz1OWvPoVkbrS1IfyAgzOvnlvDTfAooQ5n/YPv
         eoQg==
X-Gm-Message-State: AOAM53178izP0QYXVDdmrnv7cyjP9xYvkLHnxR+n9nYRd8kpLPD24xuX
        oVDky2JbcikvTvMNpq2a+4On7V6/8Mi+JgTLHAs=
X-Google-Smtp-Source: ABdhPJz7I6GB+kHu8lN1fpQm1FvM9jKqX1BOGg+joAovqHyJBAjwgZQ/qLAOx3Kk1/UBgKVS9VNdthzKFFV217hUiSo=
X-Received: by 2002:a0d:cb41:0:b0:2f7:d205:9c99 with SMTP id
 n62-20020a0dcb41000000b002f7d2059c99mr22457299ywd.417.1651117186852; Wed, 27
 Apr 2022 20:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com> <20220427014004.1992589-7-seanjc@google.com>
In-Reply-To: <20220427014004.1992589-7-seanjc@google.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Thu, 28 Apr 2022 11:39:35 +0800
Message-ID: <CAJhGHyB4RwNekpKNQu_KsGTZCyz2EoZMt0V9+PF=p43EksD_6Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] KVM: Fix multiple races in gfn=>pfn cache refresh
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022 at 7:16 PM Sean Christopherson <seanjc@google.com> wrote:

> @@ -159,10 +249,23 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
>

The following code of refresh_in_progress is somewhat like mutex.

+ mutex_lock(&gpc->refresh_in_progress); // before write_lock_irq(&gpc->lock);

Is it fit for the intention?

Thanks
Lai

>         write_lock_irq(&gpc->lock);
>
> +       /*
> +        * If another task is refreshing the cache, wait for it to complete.
> +        * There is no guarantee that concurrent refreshes will see the same
> +        * gpa, memslots generation, etc..., so they must be fully serialized.
> +        */
> +       while (gpc->refresh_in_progress) {
> +               write_unlock_irq(&gpc->lock);
> +
> +               cond_resched();
> +
> +               write_lock_irq(&gpc->lock);
> +       }
> +       gpc->refresh_in_progress = true;
> +
>         old_pfn = gpc->pfn;
>         old_khva = gpc->khva - offset_in_page(gpc->khva);
>         old_uhva = gpc->uhva;
> -       old_valid = gpc->valid;
>
