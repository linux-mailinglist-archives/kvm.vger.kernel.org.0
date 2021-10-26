Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E4843B94C
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 20:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238187AbhJZSVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 14:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238182AbhJZSVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 14:21:44 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28510C061767
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 11:19:20 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c4so301422pgv.11
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 11:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8MQhmUPz3GGqmHcq2niFjSu/U2tFNwA4AMVi4uwigWQ=;
        b=RlGBs0ZlgCnvLY9LcX3AH5FwP9OJFutUH/YqgYPCNYVpBFo7x5EwyZcZV55FPjSdn3
         /a35vp5eep6C7+ri1o7XsuQDAqneW0KWhNrWxhY9msnlHzOeED+seAl3yz+IHp15xGHu
         fmtsz0YFraPm1E5y2hB/4aEslCZn4iGZNlpZJ3p7LHVb99M8mQRsalQAk6ELIzrbFc4d
         8QjMrELGhb+H4shg8PjfWV1yRiDzZMJnT9HJfYwMW/126gvZJTB0UDT0T5ZKxBdRr++V
         1eywJDH+TVPxg2zccniWG9UCZdgr02a9JV8tDy9x3MrzJhLzVsi7BL/OIRH0u3kp1Cpu
         u4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8MQhmUPz3GGqmHcq2niFjSu/U2tFNwA4AMVi4uwigWQ=;
        b=RaJq7OU5M2r6TYYHByB+6j1x+S2XHs1rzhzZLTe05q38WItYHaxTqcId9NBfbJr1sZ
         F/4CBDWdT3SYHa5DRWjgGoURdkjLkyW+CEoLnoI/N6pWlpkkUL4bE/L4o4b6otF/3iOI
         ADFlMfJ7PjI+4vmEZCd1FJMa2z8gWoEFTOCjso/gEkeX9mfWECUA6miH8nlljYR4oDUn
         1L6N5F/5NGlgK2fOTmVi+zYZ31MSrcRs/dm+JZqfj+piG833ovy3bkjAEmCEtC59KfyT
         Z1T7fvtKZ3liOyugmnjFKSUS3vuu26ppKHAq9N9ZROZBeyjTvD8tWFKq9Uj1uSQf9Z+T
         o0SQ==
X-Gm-Message-State: AOAM531iQUA9glDRjrgswC0YSPIiZF1ZNK5jbSoq7+VBpQJOeVYc8Onk
        fi3CZKYVJOqEL5MS/4VrYqHkHA==
X-Google-Smtp-Source: ABdhPJy3mF0NKAhq9etQyCwtwvhHI9PTm28sOPjIJffOQZcg02vRVLZLJ/3HSAfq6unLJpeJKEjm+w==
X-Received: by 2002:a05:6a00:150f:b0:47c:1e13:b683 with SMTP id q15-20020a056a00150f00b0047c1e13b683mr2364327pfu.45.1635272359365;
        Tue, 26 Oct 2021 11:19:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mm19sm1605002pjb.24.2021.10.26.11.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 11:19:18 -0700 (PDT)
Date:   Tue, 26 Oct 2021 18:19:15 +0000
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
Subject: Re: [PATCH v5 09/13] KVM: Use interval tree to do fast hva lookup in
 memslots
Message-ID: <YXhGo/FpqUAuz7Td@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <89deea791ff7a5f4faa535edb9956e9863a564b8.1632171479.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89deea791ff7a5f4faa535edb9956e9863a564b8.1632171479.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> The current memslots implementation only allows quick binary search by gfn,
> quick lookup by hva is not possible - the implementation has to do a linear
> scan of the whole memslots array, even though the operation being performed
> might apply just to a single memslot.
> 
> This significantly hurts performance of per-hva operations with higher
> memslot counts.
> 
> Since hva ranges can overlap between memslots an interval tree is needed
> for tracking them.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 50597608d085..7ed780996910 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -472,6 +472,12 @@ static void kvm_null_fn(void)
>  }
>  #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
>  
> +/* Iterate over each memslot intersecting [start, last] (inclusive) range */
> +#define kvm_for_each_memslot_in_hva_range(node, slots, start, last)	     \
> +	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
> +	     node;							     \
> +	     node = interval_tree_iter_next(node, start, last))	     \

Similar to kvm_for_each_memslot_in_gfn_range(), this should use an opaque iterator
to hide the implementation details from the caller, e.g. to avoid having to define
a "struct interval_tree_node" and do container_of.
