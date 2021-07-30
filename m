Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988193DBF83
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 22:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhG3UTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 16:19:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhG3UTb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 16:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627676365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/zFJyWsxPQk78UOPs/+ij8Jx+cS7quRI3uqSv1o/GPo=;
        b=JrVXkiKHaoIA3YKi1A2u01NB9sdZ1Gvk8mlKmjH+ER8lTpQ13ZI8u4130Ro3TD+Pp4FfgT
        dD5XxGmAVOZmw+uSy5/5Bi+AFdxFdjGxV85MNzVXyq8+E4Q4zuuQKeGmbza75GIeKaqcOI
        DYvhpx9FFjn6fOHE82sVK+SWX0Oc2nM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-ZQrrNAXBM_Kw-zBUIZVvqQ-1; Fri, 30 Jul 2021 16:19:24 -0400
X-MC-Unique: ZQrrNAXBM_Kw-zBUIZVvqQ-1
Received: by mail-qk1-f197.google.com with SMTP id 18-20020a05620a0792b02903b8e915ccceso6378722qka.18
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 13:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/zFJyWsxPQk78UOPs/+ij8Jx+cS7quRI3uqSv1o/GPo=;
        b=R7FdE3DQr4F8JvF99zebl7yYGBuba487kg7ZVyhu5nyLqNu3sbLu9TJDBatTDjbJsB
         bjCI/xNNC4wd3mySlnEjk5qL0N7gEVa5b13T+i7bHRJX4bxzDRVTVo6OiMV2pHuWr7KK
         2kK8VWZmaNNm1q6mVg94r6YFYTpnPa0wVCZM9J1iNpU7lr3eDXVLsg4qwp17nRK/W+Yu
         akwCCKhXNI3C8Aby03ZkVVJxVk9WvmKXhH720pmMTvjUuc1hYnqden/X/uDVBv4K2dFW
         iAFIP3pExY58faPQmdxXcWIhNZJQST+XyHmUxh6DdeDXJ/ODmv1DvX79QcyF7d26LQgz
         mcfA==
X-Gm-Message-State: AOAM530JyjQKCTZA6bftfZjyIvUbel35UH2GjXguZiEWDe58kNFY79tf
        O8Hsw47zAeLs6NC22wtg9MwBanvb3iKJouN0JdGefcS9V7qj/LmFqqaYrlZTp8ETHYgEda2U3qM
        Rmqd75A1wPUIj
X-Received: by 2002:ad4:522c:: with SMTP id r12mr4643070qvq.17.1627676363799;
        Fri, 30 Jul 2021 13:19:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpcJumONCf8DoskE6RaFKasSWi6GXBAhPM3j6dnrtWg/hV7L9H+UMK1U8vpHb8qp71Nb1+Ow==
X-Received: by 2002:ad4:522c:: with SMTP id r12mr4643056qvq.17.1627676363551;
        Fri, 30 Jul 2021 13:19:23 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id w26sm1388000qki.6.2021.07.30.13.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 13:19:22 -0700 (PDT)
Date:   Fri, 30 Jul 2021 16:19:21 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Hamza Mahfooz <someguy@effective-light.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: const-ify all relevant uses of struct
 kvm_memory_slot
Message-ID: <YQReyaxp/rwypHbR@t490s>
References: <20210713023338.57108-1-someguy@effective-light.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210713023338.57108-1-someguy@effective-light.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Hamza,

On Mon, Jul 12, 2021 at 10:33:38PM -0400, Hamza Mahfooz wrote:
> @@ -1467,16 +1467,20 @@ rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
>  
>  static void
>  slot_rmap_walk_init(struct slot_rmap_walk_iterator *iterator,
> -		    struct kvm_memory_slot *slot, int start_level,
> +		    const struct kvm_memory_slot *slot, int start_level,
>  		    int end_level, gfn_t start_gfn, gfn_t end_gfn)
>  {
> -	iterator->slot = slot;
> -	iterator->start_level = start_level;
> -	iterator->end_level = end_level;
> -	iterator->start_gfn = start_gfn;
> -	iterator->end_gfn = end_gfn;
> +	struct slot_rmap_walk_iterator iter = {
> +		.slot = slot,
> +		.start_gfn = start_gfn,
> +		.end_gfn = end_gfn,
> +		.start_level = start_level,
> +		.end_level = end_level,
> +	};
> +
> +	rmap_walk_init_level(&iter, iterator->start_level);

Here it should be s/iterator->//.

>  
> -	rmap_walk_init_level(iterator, iterator->start_level);
> +	memcpy(iterator, &iter, sizeof(struct slot_rmap_walk_iterator));
>  }

This patch breaks kvm/queue with above issue.  Constify of kvm_memory_slot
pointer should have nothing to do with this so at least it should need a
separate patch.  At the meantime I also don't understand why memcpy() here,
which seems to be even slower..

-- 
Peter Xu

