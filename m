Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB25E36E2AF
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 02:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhD2Ale (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 20:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhD2Ald (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 20:41:33 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DDAC06138C
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 17:40:48 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id i190so5333959pfc.12
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 17:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4awlf4C5aIDwxCX8Cd8Uakbh16U3MG80dqO+vEd3Xwo=;
        b=LU8ti1Vx7Ov9lHevash08+QhqpSGt/ZEiGe7fS0cHa83Pm3K4dPoaubVo/ogw+m6qy
         w5jRHY67NXfunL64qV1MFPS2gwkFBHgNKiTpW8hDImp7ayjPOZ7paUCKaQMc2LdXuYdB
         b6er2kQsLhSGphpM75M4WTsD1SpYFaIdmwCehKwC21z9AWQd0bOcAKApd6TbBljKyaKM
         n6RNKC/7V66Njwrt+mPAbNaDWlHPYEtrBoyZmHHkKAe8oadVaEfvu2zsvljgFHu0cctZ
         ZLEzIHGdmrBdFyg5uwwyylaqnaiw/WoLA3hG/Zmx/ZU3jkPLdPnsBlBPJ4GVMwGutPDQ
         MKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4awlf4C5aIDwxCX8Cd8Uakbh16U3MG80dqO+vEd3Xwo=;
        b=UcwqXNedYHsjK6UuIn+DtHFdc5W8KRhZZeNNajjxA5lSLk65hQeSAeYSBrbFMXm8rR
         52wAKShAN7aVwaZTl5qyAOe4U1BeZlqPSqYxdurrBtIgLeK2oAwkqGrJLbLLKu13RtKO
         FtRzaiABprOTFZWg69tCzKrYDuhfh2wLfS7S3kgpR/mj/CvQu+WneZoZFLfSUXn+Nluw
         oIhbO1QYiRttqwQrVu6bvFOvEH+5+0UwGWHRceKHDoT+tG/oaMSLNF5alvEBJzwUIV6B
         mlWa6X22iYi4g4pCNndmKdxYIuIHT2qpfB4dXUEOSAtqVHT9bJS0S6obkMzxg0ntgCpr
         ED8A==
X-Gm-Message-State: AOAM530VwpsunnfbVHcAzT0Yr/q6EOM2AyuNKIb0O7O1KEAK3gkfBgRl
        VJ6pMwlq1UKuhXwD603CSbGhFw==
X-Google-Smtp-Source: ABdhPJzuuAuPfzXaOhuj2tkYQIzPQar3yiyzTkotAN/6gS6BnX3tHVREy1gCvDqu3rBH3MQy99SXMA==
X-Received: by 2002:a62:ea1a:0:b029:27a:bcea:5d3d with SMTP id t26-20020a62ea1a0000b029027abcea5d3dmr10350937pfh.69.1619656847464;
        Wed, 28 Apr 2021 17:40:47 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x62sm714484pfb.71.2021.04.28.17.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 17:40:46 -0700 (PDT)
Date:   Thu, 29 Apr 2021 00:40:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 5/6] KVM: x86/mmu: Protect kvm->memslots with a mutex
Message-ID: <YIoAixSoRsM/APgx@google.com>
References: <20210427223635.2711774-1-bgardon@google.com>
 <20210427223635.2711774-6-bgardon@google.com>
 <997f9fe3-847b-8216-c629-1ad5fdd2ffae@redhat.com>
 <CANgfPd8RZXQ-BamwQPS66Q5hLRZaDFhi0WaA=ZvCP4BbofiUhg@mail.gmail.com>
 <d936b13b-bb00-fc93-de3b-adc59fa32a7b@redhat.com>
 <CANgfPd9kVJOAR_uq+oh9kE2gr00EUAGSPiJ9jMR9BdG2CAC+BA@mail.gmail.com>
 <5b4a0c30-118c-da1f-281c-130438a1c833@redhat.com>
 <CANgfPd_S=LjEs+s2UzcHZKfUHf+n498eSbfidpXNFXjJT8kxzw@mail.gmail.com>
 <16b2f0f3-c9a8-c455-fff0-231c2fe04a8e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16b2f0f3-c9a8-c455-fff0-231c2fe04a8e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021, Paolo Bonzini wrote:
> it's not ugly and it's still relatively easy to explain.

LOL, that's debatable.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2799c6660cce..48929dd5fb29 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1377,16 +1374,17 @@ static int kvm_set_memslot(struct kvm *kvm,
>  		goto out_slots;
>  	update_memslots(slots, new, change);
> -	slots = install_new_memslots(kvm, as_id, slots);
> +	install_new_memslots(kvm, as_id, slots);
>  	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
> -
> -	kvfree(slots);
>  	return 0;
>  out_slots:
> -	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> +		slot = id_to_memslot(slots, old->id);
> +		slot->flags &= ~KVM_MEMSLOT_INVALID;

Modifying flags on an SRCU-protect field outside of said protection is sketchy.
It's probably ok to do this prior to the generation update, emphasis on
"probably".  Of course, the VM is also likely about to be killed in this case...

>  		slots = install_new_memslots(kvm, as_id, slots);

This will explode if memory allocation for KVM_MR_MOVE fails.  In that case,
the rmaps for "slots" will have been cleared by kvm_alloc_memslot_metadata().

> +	}
>  	kvfree(slots);
>  	return r;
>  }

The SRCU index is already tracked in vcpu->srcu_idx, why not temporarily drop
the SRCU lock if activate_shadow_mmu() needs to do work so that it can take
slots_lock?  That seems simpler and I think would avoid modifying the common
memslot code.

kvm_arch_async_page_ready() is the only path for reaching kvm_mmu_reload() that
looks scary, but that should be impossible to reach with the correct MMU context.
We could always and an explicit sanity check on the rmaps being avaiable.
