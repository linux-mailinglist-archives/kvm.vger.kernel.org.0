Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4628D4C7B71
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 22:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiB1VM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 16:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiB1VM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 16:12:58 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096D2E4D38
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 13:12:19 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id a8so27429565ejc.8
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 13:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aTNcgvBHQBQFzYOaN3YwVC0F+2YV3FUVuMMmLjjPBjg=;
        b=LciS++MVrFS2vLAc0sSTOjamB3Y+EksHUKcxxBCpMUg0n3jhrKoDzDvfD2eP8sr8xC
         U0Q/fhZ1eMPvg1jy/6rnZj4TjALZ62cIqJaaEQNnbqxvAz9EgnD3W+43+sMKzjSrWJnq
         iLpgYK6MlKN2VPR78EeV+AobJrjhXkhmsCizLtGqokeFROXbaQl5/AwQSkVNtxz3DdoX
         F2ULlU7v/uHrJFnnxcHVFWa2XiLrUtxzeAry6sEYc845WNcgmKy+S5AVcGDFF6TIRJBP
         /Rwnqnls36Gkiz8Y8XTCTtf0Fki3/cJOGWEa2fUAmK2nVwOX/c9cZxQAP7FbZOYi21A4
         UWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aTNcgvBHQBQFzYOaN3YwVC0F+2YV3FUVuMMmLjjPBjg=;
        b=4igdHhCC/48FxGuKnL01VLCPwEJloQLZr9L/RJCmzxJfa5vX4gaRs5tSFo7PU18nkm
         SAucrDZhA5p9On/h2Pnl9YTDnq+HxBsLeiQIP7YGLu1Zeuiq8YlfRGyfdbxyJ0dvZvyT
         bNLVkxxnxlxxyt4ZyTlQhJPMbupVgT0b5EehzQQsuZ3YhBNKMnWqikVdbjIyUFmqUBRJ
         +ehBaECYg+eYas52mH4H1Kfc+kGplnTw1eG83tILvWmpSVqJGjVz0/3bobFz5rT5jhRf
         KI4A6tNlJWHlhhnSVLTGPAeJqqDDUb7sBnkiSFmM86kQjaASJPpoPTHhqzGPGmZqQGt0
         Sxgg==
X-Gm-Message-State: AOAM530zoF904bK1Ca9j9PKBtDbqnaAIxwavmOjwDP8jbOXqFfhu6chZ
        aXZxuEA5OjpwRXY9FpKO38BEHVCKOrtji844Y7Mzsg==
X-Google-Smtp-Source: ABdhPJwrMPu74Yx8ujC09M4UeVVWc8GB0mfEyc43u5BVxXDgEfk57liIDPftkFzoCYLvTcsBuPQo++k3u8bWOe1Y/70=
X-Received: by 2002:a17:906:d14e:b0:6cd:8d7e:eec9 with SMTP id
 br14-20020a170906d14e00b006cd8d7eeec9mr16658691ejb.28.1646082737445; Mon, 28
 Feb 2022 13:12:17 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-21-dmatlack@google.com>
In-Reply-To: <20220203010051.2813563-21-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Feb 2022 13:12:06 -0800
Message-ID: <CANgfPd9cy99Gyjrh286pYBnXSOR7C4wczG9B_wwm=AxX9L3dyQ@mail.gmail.com>
Subject: Re: [PATCH 20/23] KVM: Allow GFP flags to be passed when topping up
 MMU caches
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 5:03 PM David Matlack <dmatlack@google.com> wrote:
>
> This will be used in a subsequent commit to top-up MMU caches under the
> MMU lock with GFP_NOWAIT as part of eager page splitting.
>
> No functional change intended.
>

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  include/linux/kvm_host.h | 1 +
>  virt/kvm/kvm_main.c      | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b3810976a27f..128f4c5a8122 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1329,6 +1329,7 @@ void kvm_reload_remote_mmus(struct kvm *kvm);
>
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> +int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min, gfp_t gfp);
>  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
>  void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
>  void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index afa4bdb6481e..c39e7ba21fab 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -371,7 +371,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>                 return (void *)__get_free_page(gfp_flags);
>  }
>
> -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min, gfp_t gfp)
>  {
>         int capacity;
>         void *obj;
> @@ -384,7 +384,7 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>         if (mc->nobjs >= min)
>                 return 0;
>         while (mc->nobjs < capacity) {
> -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> +               obj = mmu_memory_cache_alloc_obj(mc, gfp);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
>                 mc->objects[mc->nobjs++] = obj;
> @@ -392,6 +392,11 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>         return 0;
>  }
>
> +int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +{
> +       return __kvm_mmu_topup_memory_cache(mc, min, GFP_KERNEL_ACCOUNT);
> +}
> +
>  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
>  {
>         return mc->nobjs;
> --
> 2.35.0.rc2.247.g8bbb082509-goog
>
