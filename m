Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B533D6597
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242244AbhGZQnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 12:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242143AbhGZQm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 12:42:26 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477E7C0C13CF
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 09:53:59 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l19so13809856pjz.0
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 09:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2B2SE88+b1PEJjhDplGlsK6E1Mohf1d0wrZ2a0ykYQo=;
        b=hXkY8OSuySlgK5M9HvfCQqcEz7ZYV3DIS6DHuqQVl3I5N5hgne85EqTj49JmYctJeZ
         m5tqwhsV9SkQnKVouuskWYadS3EWBvTn3LOysI/kQF7rl0V83/TEvzna6QeqaI0N/y7C
         2BgO8CrrbPrXtUjb1xEHYFhUiFhwsekHRmFoBaO0rXGkSmFenemuAzPkn1MWnrd+Tn77
         I4TVuhYJJDY+W16oC7qExS4EF7vTx0X+uqgaZ4QhAH6df0QDfrqzZq2PFjus9ys2Gc2v
         nGqS6HJn6e01GAP8+oh56S6lCCBkaKUU+gEvP4O3JUbTtbAVGZGeQnuULErQ1ynDveb5
         GwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2B2SE88+b1PEJjhDplGlsK6E1Mohf1d0wrZ2a0ykYQo=;
        b=aTWsbuBkgKlQo1LKl25GG/ww+NfSxoHMx1/gtXyDHrb9a7ABP0bcvV7FlMkZwRCD6C
         m91aoAoqHcOFiO3kOuKE7OzFgr4RU3tPMT6X1MPszCgtvgl3iYYVkHPdJYD352a3Scuo
         rqQVacLc4BqzMqMlz63TToqCb6m27chzn6A5COVAek82tABBfaAsQlaaIWfi9X/+kgzN
         LT/LAJ/FndNHu00H2lLgcaDGV/8/TP+JUeKOPRLtUGI24Ne0ePgLl1ouisldqBmswGNx
         1bcH0gnrm7kcBKQ0gO/x9xKQ8OZ0aJKk8ZiY4/OmYhdTWvIQFBbwNY2E38UBis78rDNk
         Tsrg==
X-Gm-Message-State: AOAM531onog+gBs22Xp7pEhuS46OOGtoaEwmLp6uJ6o+tIOFCCaOrHsK
        5q6T36vN11XPWEQpFkFCMNilPQ==
X-Google-Smtp-Source: ABdhPJzRvlexmatrWFxj4txynBPRCrYR00F+W5nMDtcAjUYo8c1zoikmCDoFqZrrIXT1jcKWtjtxGg==
X-Received: by 2002:a17:903:1203:b029:12b:599b:524c with SMTP id l3-20020a1709031203b029012b599b524cmr15494749plh.10.1627318438603;
        Mon, 26 Jul 2021 09:53:58 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id n14sm34009pjv.34.2021.07.26.09.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 09:53:57 -0700 (PDT)
Date:   Mon, 26 Jul 2021 16:53:53 +0000
From:   David Matlack <dmatlack@google.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     bgardon@google.com, kvm@vger.kernel.org
Subject: Re: [bug report] KVM: x86/mmu: Use an rwlock for the x86 MMU
Message-ID: <YP7oocNiF5NW8I58@google.com>
References: <20210726075238.GA10030@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726075238.GA10030@kili>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 10:52:38AM +0300, Dan Carpenter wrote:
> [ This is not the correct patch to blame, but there is something going
>   on here which I don't understand so this email is more about me
>   learning rather than reporting bugs. - dan ]
> 
> Hello Ben Gardon,
> 
> The patch 531810caa9f4: "KVM: x86/mmu: Use an rwlock for the x86 MMU"
> from Feb 2, 2021, leads to the following static checker warning:
> 
> 	arch/x86/kvm/mmu/mmu.c:5769 kvm_mmu_zap_all()
> 	warn: sleeping in atomic context
> 
> arch/x86/kvm/mmu/mmu.c
>     5756 void kvm_mmu_zap_all(struct kvm *kvm)
>     5757 {
>     5758 	struct kvm_mmu_page *sp, *node;
>     5759 	LIST_HEAD(invalid_list);
>     5760 	int ign;
>     5761 
>     5762 	write_lock(&kvm->mmu_lock);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^
> This line bumps the preempt count.
> 
>     5763 restart:
>     5764 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
>     5765 		if (WARN_ON(sp->role.invalid))
>     5766 			continue;
>     5767 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
>     5768 			goto restart;
> --> 5769 		if (cond_resched_rwlock_write(&kvm->mmu_lock))
>                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This line triggers a sleeping in atomic warning.  What's going on here
> that I'm not understanding?

cond_resched_rwlock_write drops the provided lock (kvm->mmu_lock in this
case) before scheduling and then re-acquires it afterwards. So this
warning looks like a false positive.

> 
>     5770 			goto restart;
>     5771 	}
>     5772 
>     5773 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
>     5774 
>     5775 	if (is_tdp_mmu_enabled(kvm))
>     5776 		kvm_tdp_mmu_zap_all(kvm);
>     5777 
>     5778 	write_unlock(&kvm->mmu_lock);
>     5779 }
> 
> regards,
> dan carpenter
