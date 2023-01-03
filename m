Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2801865C542
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 18:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbjACRmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 12:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238336AbjACRmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 12:42:37 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4477A2DB
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 09:42:36 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o31-20020a17090a0a2200b00223fedffb30so31831245pjo.3
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 09:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OkcZf3Nc7+BU1+DO0enKeeF9MyS0vVC/gIcg/2SqswM=;
        b=gS6a/Etgsc3Y7wqJ1duGRSBfgWWVzFB4u1JMrxXTtmJzxj3QvXhb39dbInsEk3YqZX
         FoWN1FUPGmngIT6N6nqeyXb+BJIHU0LO87D2ByM2QmyUtps6LxE7DHpdveXReFP4vzAw
         99HYN3J4tHMdgezOwSWNy7CyYU1D67c15zs7FaECgSU0CCqzDam22fzrxEV15mO7cqcp
         f5TbCO1iUh3Vl8usPlVbkfN9c7sCvDFIbXzwd8CH6R3PPJRGKK2woFXWIBZVn9bTIIDE
         yRji+6s9YSRhvi1peu9DzDqEnOxKqAE8qlTvvYpAl5WHesv3r4y0RARgwkoPR6qq3GDH
         0zew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OkcZf3Nc7+BU1+DO0enKeeF9MyS0vVC/gIcg/2SqswM=;
        b=pj2SlbgfaQK/OdufhC68bBhhapA9WB0ae3Kf+v3LlADxuv8m+bCIzUAAOgnNJlX9gp
         ZJ7O31Ol/jqUYFnEmPdXhm4xiFigGbEclFrU4NhF5s2AG25sKY5BI0zD3k5xVyjrwsan
         WRjJ99vAYUdGJN9tcUb0SCYFVFYx44IxSF606qZNDuqb7Vjha2wnSdffGJa+dUSjknFt
         x6KWE9tTFAht0jxxpOtzmRANejj5q6ToIPqRK2yVYgJi4SYp+hCAaOkPN83nrKYrmGhc
         5RhwdXQx8XM5LdMG15fSZsNgF7MpSSwziB250U8lprDaA0YaUkHtUkIjYYD8lz8jem4E
         VYkA==
X-Gm-Message-State: AFqh2kqB9+8RPWR/qpKVr5IAOQRj+00s0cLF1JLnNaUwl3L/52xkHn96
        vBJFi4m3BM8nWnA6Eunus96AIg==
X-Google-Smtp-Source: AMrXdXtPqHrkrzSlIRciJoetvHMCPwMdBuKzCM1WyhWc9yv71Rd92zOcdIG8AXUPiO47gGatcXvf6g==
X-Received: by 2002:a17:902:9049:b0:189:6d32:afeb with SMTP id w9-20020a170902904900b001896d32afebmr4220394plz.1.1672767755628;
        Tue, 03 Jan 2023 09:42:35 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u18-20020a170903125200b00189adf6770fsm22749792plh.233.2023.01.03.09.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 09:42:35 -0800 (PST)
Date:   Tue, 3 Jan 2023 17:42:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] Documentation: kvm: clarify SRCU locking order
Message-ID: <Y7RpB+trpnhVRhQW@google.com>
References: <20221228110410.1682852-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228110410.1682852-2-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 28, 2022, Paolo Bonzini wrote:
> Currently only the locking order of SRCU vs kvm->slots_arch_lock
> and kvm->slots_lock is documented.  Extend this to kvm->lock
> since Xen emulation got it terribly wrong.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/locking.rst | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> index 845a561629f1..a3ca76f9be75 100644
> --- a/Documentation/virt/kvm/locking.rst
> +++ b/Documentation/virt/kvm/locking.rst
> @@ -16,17 +16,26 @@ The acquisition orders for mutexes are as follows:
>  - kvm->slots_lock is taken outside kvm->irq_lock, though acquiring
>    them together is quite rare.
>  
> -- Unlike kvm->slots_lock, kvm->slots_arch_lock is released before
> -  synchronize_srcu(&kvm->srcu).  Therefore kvm->slots_arch_lock
> -  can be taken inside a kvm->srcu read-side critical section,
> -  while kvm->slots_lock cannot.
> -
>  - kvm->mn_active_invalidate_count ensures that pairs of
>    invalidate_range_start() and invalidate_range_end() callbacks
>    use the same memslots array.  kvm->slots_lock and kvm->slots_arch_lock
>    are taken on the waiting side in install_new_memslots, so MMU notifiers
>    must not take either kvm->slots_lock or kvm->slots_arch_lock.
>  
> +For SRCU:
> +
> +- ``synchronize_srcu(&kvm->srcu)`` is called _inside_
> +  the kvm->slots_lock critical section, therefore kvm->slots_lock
> +  cannot be taken inside a kvm->srcu read-side critical section.
> +  Instead, kvm->slots_arch_lock is released before the call
> +  to ``synchronize_srcu()`` and _can_ be taken inside a
> +  kvm->srcu read-side critical section.
> +
> +- kvm->lock is taken inside kvm->srcu, therefore

Prior to the recent Xen change, is this actually true?  There are many instances
where kvm->srcu is taken inside kvm->lock, but I can't find any existing cases
where the reverse is true.  Logically, it makes sense to take kvm->lock first since
kvm->srcu can be taken deep in helpers, e.g. for accessing guest memory.  It's also
more consistent to take kvm->lock first since kvm->srcu is taken inside vcpu->mutex,
and vcpu->mutex is taken inside kvm->lock.

Disallowing synchronize_srcu(kvm->srcu) inside kvm->lock isn't probelmatic per se,
but it's going to result in a weird set of rules because synchronize_scru() can,
and is, called while holding a variety of other locks.

In other words, IMO taking kvm->srcu outside of kvm->lock in the Xen code is the
real bug.

> +  ``synchronize_srcu(&kvm->srcu)`` cannot be called inside
> +  a kvm->lock critical section.  If you cannot delay the
> +  call until after kvm->lock is released, use ``call_srcu``.
> +
>  On x86:
>  
>  - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
> -- 
> 2.31.1
> 
