Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1D1389890
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 23:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhESVZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 17:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhESVZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 17:25:31 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B43C061760
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:24:10 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id e19so10823480pfv.3
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 14:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N3dW/ATcWO3PY6v2BY4HSFEQmmBCUs+/OWJJEnN9Srk=;
        b=CeeodCR0FxrR09xkryZqzSbIZOBk/0Oj2AxolLq4hJHYw2ZUIoRQL800ilJbQlJAvZ
         DwyjP0YDXa+V4mOt0fb0uPYLnysNRf/IYlZg5rN/trEG2zvIUnulTsI4YLG8iadSTeML
         pWlhklwtfesO0K05zO+pumkh733cZPEEmfD6Ux4Qp7LC2UlJhqeUejQYKcHlFpwH001j
         zhPYs1kj5VOTVDUjJUGsD9HHbAj9XPum73dibf2FWrUvc1e7EDjr+dWOEL276oPxQOJq
         TxMoA9UsZKLAn5/TeaasOkI/PGe8a2a+rhB8p1r9HGUtIjvOKryy4zq/zaj8nxu4QEP0
         4F+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N3dW/ATcWO3PY6v2BY4HSFEQmmBCUs+/OWJJEnN9Srk=;
        b=JCA5OA4a/WuoIhdGfZQIWp0/C7Yv311pH6uivn1cH2pP3bHCE9bezhAkwC5r1iINCJ
         TWZMKKlFpeo5N5Rcke3E62RT82msp3KaRpXOXrj4yKyRp8tgJcO6OOQsf/jdFqnlyQO5
         NFWieQryIauNDWp8ORIUdIteZNz73NOtIDtfKo2GhVzmieehnQp3J7YcN6V9OZ/YnQHG
         MoL0iodQVx5gmEwm8tOMX0YaIRiYMq1eh4VRnizmE2GR382UsXUUxwaAHNKxIvR30Kbo
         WjAXxr6vsQwQWOME/JSZ9tomqQAjFwvMFtLBF4aCBqz7ItXSDxL71pGOihFn6FoQYCJd
         H3KA==
X-Gm-Message-State: AOAM530KKlgvA4tDMOa8dvvDGbGKneeVIsc9BpcTup6+OJWB+6ePo3Ai
        w9woRyIp0X/mB1oqcLaDPIs/GA==
X-Google-Smtp-Source: ABdhPJxRutlVEomE7U/WS/VK1S1uDUBga4d3T33UUIYJFrntdjgNVwxYfJHfR58XJi84sCecZe4/bg==
X-Received: by 2002:a62:d411:0:b029:2b5:fce4:7e64 with SMTP id a17-20020a62d4110000b02902b5fce47e64mr1328219pfh.15.1621459449756;
        Wed, 19 May 2021 14:24:09 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x13sm314784pjl.22.2021.05.19.14.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 14:24:09 -0700 (PDT)
Date:   Wed, 19 May 2021 21:24:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] KVM: Integrate gfn_to_memslot_approx() into
 search_memslots()
Message-ID: <YKWB9bPyyFfo0uhf@google.com>
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <b8258ced64a81c7d90320c2921fe08b11eb47362.1621191551.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8258ced64a81c7d90320c2921fe08b11eb47362.1621191551.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8895b95b6a22..3c40c7d32f7e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1091,10 +1091,14 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
>   * gfn_to_memslot() itself isn't here as an inline because that would
>   * bloat other code too much.
>   *
> + * With "approx" set returns the memslot also when the address falls
> + * in a hole. In that case one of the memslots bordering the hole is
> + * returned.
> + *
>   * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
>   */
>  static inline struct kvm_memory_slot *
> -search_memslots(struct kvm_memslots *slots, gfn_t gfn)
> +search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)

An alternative to modifying the PPC code would be to make the existing
search_memslots() a wrapper to __search_memslots(), with the latter taking
@approx.

We might also want to make this __always_inline to improve the likelihood of the
compiler optimizing away @approx.  I doubt it matters in practice...

>  {
>  	int start = 0, end = slots->used_slots;
>  	int slot = atomic_read(&slots->lru_slot);
> @@ -1116,19 +1120,22 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn)
>  			start = slot + 1;
>  	}
>  
> +	if (approx && start >= slots->used_slots)
> +		return &memslots[slots->used_slots - 1];
> +
>  	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
>  	    gfn < memslots[start].base_gfn + memslots[start].npages) {
>  		atomic_set(&slots->lru_slot, start);
>  		return &memslots[start];
>  	}
>  
> -	return NULL;
> +	return approx ? &memslots[start] : NULL;
>  }
>  
>  static inline struct kvm_memory_slot *
>  __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>  {
> -	return search_memslots(slots, gfn);
> +	return search_memslots(slots, gfn, false);
>  }
>  
>  static inline unsigned long
