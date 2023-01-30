Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8D8681DD8
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 23:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjA3WM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 17:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbjA3WMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 17:12:53 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1216F305F9
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 14:12:49 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id s76so1172123vkb.9
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 14:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B9uCs7d9bI8X6lNKZ7ZR4tAOVN8haO7ZbwgyLwils8A=;
        b=bBK8lpvjAA41DqZ3plICiMl3eMYmkkVlJF9BXvs0Y6RBHdZpV5VmOonUO0Ugg2/7eW
         8IQ6hcinRGaoaFO5YrGiw0HdCCCccVzJEr2tQWmrhiIWXVL0NsbyGPwOyYAM111zg6kg
         LmO0YZi+BJe+XxOYB7xueKoe3RP9VTxa2x2sni3h4zaMHMP0QIYnOsGXgRiosdMlwzwQ
         bDznp4aMJ8ck5Lk5Hw4Jj645rH8zpX1jPxkBv1g+S7FFmCEHezLLz5WaTQU1+fz8ozDB
         iryboxvBPYqswC/eI+2gpez0YF2ysgQB40zaaaAX9FNgvJUBKY2WSRLy2naUj65fDdvE
         dT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B9uCs7d9bI8X6lNKZ7ZR4tAOVN8haO7ZbwgyLwils8A=;
        b=pCh1Gaz30dcHGrTlicUmynhZ/fad6YUx1kgoNQdIjsGdH5AJCwH9hf7TB1HRLK4OW0
         455g2saZ+8LNQfJve10xx/oNQe5t4a/2Sn3nlNeAJsnpyadhYP/sRFs50hDKssXX7ApH
         iHXx9iyYb5IFpgUhkj8UHBPG+l2HKXxsY6RscqMdJM4zMk3WjpxVI8sC2C0Hr1ZHnAs+
         NAypY1TrlF0RmGpv5Zyc5HRVL5MbAQznPobvgvZ7PUZ61OtbZxPlnly9yUJBodhW3Gxc
         E/3KsE+0K/Teg9FKbAWxtjwCNoG7nU53pQJ/WEeR53wH7VhvmgBlk3V+VRcD4u2A5gro
         NGgw==
X-Gm-Message-State: AO0yUKXIHfxUqncDm4z61eSD3LZt7A3qcRoW/y1HYFvYfO8Ct/dNdb4v
        kdcWhgd/5iW6n5EAQeKWaJZcSkI3mqNio3rJXAS89g==
X-Google-Smtp-Source: AK7set/nIru8D9r0Imi8xjLhSPk9CL3OX61Jk+PPQ2BfDXQZJrSj0fuAsdF+LH8C2V6KpcKTmacoFwcw7/c2FevfBYs=
X-Received: by 2002:a05:6122:1810:b0:3e9:ec45:c2d7 with SMTP id
 ay16-20020a056122181000b003e9ec45c2d7mr1594742vkb.24.1675116768134; Mon, 30
 Jan 2023 14:12:48 -0800 (PST)
MIME-Version: 1.0
References: <20230125213857.824959-1-vipinsh@google.com> <Y9GmiyRQ6sULCjEG@google.com>
 <CANgfPd9T7jdh1Cjjo4y6DcxC2poTaGhQ7wNLf6OgGtStg-yKJg@mail.gmail.com> <Y9HcHRBShQgjxsQb@google.com>
In-Reply-To: <Y9HcHRBShQgjxsQb@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 30 Jan 2023 14:12:21 -0800
Message-ID: <CALzav=fkmS0U4tb4trDtbCmDxo27EcJeOWbiwb+meagj9+PFiw@mail.gmail.com>
Subject: Re: [Patch] KVM: x86/mmu: Make optimized __handle_changed_spte() for
 clear dirty log
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 25, 2023 at 5:49 PM Sean Christopherson <seanjc@google.com> wrote:
[...]
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 92 ++++++++++----------------------------
>  1 file changed, 24 insertions(+), 68 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bba33aea0fb0..2f78ca43a276 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
[...]
> @@ -1289,8 +1244,7 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
>                 new_spte = mark_spte_for_access_track(new_spte);
>         }
>
> -       tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
> -
> +       kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte, new_spte, iter->level);

This can race with fast_page_fault() setting the W-bit and the CPU
setting the D-bit. i.e. This call to kvm_tdp_mmu_write_spte() could
clear the W-bit or D-bit.

> @@ -1703,9 +1657,11 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
>                                 new_spte = iter.old_spte & ~shadow_dirty_mask;
>                         else
>                                 continue;
> +
> +                       kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
>                 }
>
> -               tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
> +               kvm_tdp_mmu_write_spte(iter.sptep, iter.old_spte, new_spte, iter.level);

Similar issue here. This call to kvm_tdp_mmu_write_spte() could clear
the A-bit or mark the SPTE for access-tracking.

> --
>
