Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D2C598CA7
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 21:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiHRTey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 15:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiHRTex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 15:34:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F60CE300
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 12:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660851290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t27VGD5bDfERJC+pXOu8wApRHc2zsJd/CGr71ZZBapU=;
        b=hc3+k6UpDNMezdmG0CjFG/+7BJZBroiBdDmN4e615MG3prYMKeQEhdUjgrfXNI/rjgndOd
        l0R4s6KXiHe/uHMihi1ikAPVOvLUobuJwfxDh3NgOfsGCGRwAEl3JuQuCO6mtiM9C77ruH
        L4lOM/1iCwi1CTZ2bb//l1BM8L1HAdI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-20-Z2tQuJX7P_yzTshxWECfVA-1; Thu, 18 Aug 2022 15:34:47 -0400
X-MC-Unique: Z2tQuJX7P_yzTshxWECfVA-1
Received: by mail-qt1-f197.google.com with SMTP id ci6-20020a05622a260600b0034370b6f5d6so1877683qtb.14
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 12:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=t27VGD5bDfERJC+pXOu8wApRHc2zsJd/CGr71ZZBapU=;
        b=jzO+QcGJtFvaZJECcupjtyGR/qCdlHpNVfPJivHgOB3ym+FkLpVmfVZZpKQzuf+cGM
         1X53V3Mpkda23DIYf1tCpomWBvg5CssqaKpVN9meLXGQKSSq4Imihh+BFDBalor/tmRS
         SOlcx/sCEtVqK05lDXH8G500b97k3SYWXljSVTTbghEeqKgJ1t+e/hMhC4R1bZIVW15v
         xjkD6S0X7BOZTW49LFAkWLBnGcNAlXEitKdwhPEuK5PQS662XZyj2xn4WywWncqGgfKs
         aNWw4TrnNDiAQwUIxcvzGcVokm12tHCzPw/AYs+m5KdMpJuz5sO4OObgVEP3EAU3odkQ
         b3ug==
X-Gm-Message-State: ACgBeo3+AbOMo9CRM6PClJHxk2ibe7oI/R6dFuDtChNW6eLnO359kVOH
        beMeOsRmuYwmnD93XLUlyhhzVARXhknSpdz6B3Tk/WWektRRH7BJXEkcsiqdgfUNcZkVp94eZ2z
        i3u1uLk3lN/qN
X-Received: by 2002:a05:622a:1009:b0:343:568f:fee4 with SMTP id d9-20020a05622a100900b00343568ffee4mr4229055qte.178.1660851286569;
        Thu, 18 Aug 2022 12:34:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4rh0XfDF2nyUyvht8cKX6rp+fnTerdC2qC+Y809jfEDSiDwN9OY5lwp+zPLhZJ5ic8/HYtdQ==
X-Received: by 2002:a05:622a:1009:b0:343:568f:fee4 with SMTP id d9-20020a05622a100900b00343568ffee4mr4229045qte.178.1660851286340;
        Thu, 18 Aug 2022 12:34:46 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id z15-20020ac8100f000000b003435f947d9fsm1478583qti.74.2022.08.18.12.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 12:34:45 -0700 (PDT)
Date:   Thu, 18 Aug 2022 15:34:44 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] softmmu/memory: add missing begin/commit
 callback calls
Message-ID: <Yv6UVMMX/hHFkGoM@xz-m1.local>
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-2-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220816101250.1715523-2-eesposit@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 16, 2022 at 06:12:49AM -0400, Emanuele Giuseppe Esposito wrote:
> kvm listeners now need ->commit callback in order to actually send
> the ioctl to the hypervisor. Therefore, add missing callers around
> address_space_set_flatview(), which in turn calls
> address_space_update_topology_pass() which calls ->region_* and
> ->log_* callbacks.
> 
> Using MEMORY_LISTENER_CALL_GLOBAL is a little bit an overkill,
> but it is harmless, considering that other listeners that are not
> invoked in address_space_update_topology_pass() won't do anything,
> since they won't have anything to commit.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  softmmu/memory.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/softmmu/memory.c b/softmmu/memory.c
> index 7ba2048836..1afd3f9703 100644
> --- a/softmmu/memory.c
> +++ b/softmmu/memory.c
> @@ -1076,7 +1076,9 @@ static void address_space_update_topology(AddressSpace *as)
>      if (!g_hash_table_lookup(flat_views, physmr)) {
>          generate_memory_topology(physmr);
>      }
> +    MEMORY_LISTENER_CALL_GLOBAL(begin, Forward);
>      address_space_set_flatview(as);
> +    MEMORY_LISTENER_CALL_GLOBAL(commit, Forward);

Should the pair be with MEMORY_LISTENER_CALL() rather than the global
version?  Since it's only updating one address space.

Besides the perf implication (walking per-as list should be faster than
walking global memory listener list?), I think it feels broken too since
we'll call begin() then commit() (with no region_add()/region_del()/..) for
all the listeners that are not registered against this AS.  IIUC it will
empty all regions with those listeners?

Thanks,

-- 
Peter Xu

