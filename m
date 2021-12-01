Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259A3465695
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 20:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352657AbhLATk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 14:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245621AbhLATk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 14:40:26 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8928BC0613E1
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 11:37:02 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id k4so14537787pgb.8
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 11:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lr2WGncxUm/mjgsdCL4t3YFfC5CKDyQaP6PDF9pOnuU=;
        b=J2Jd4K0wqeVP0z7h24thga7MCfq9kSoVdwiOz3hh1Z3qr/OJDCkdsbln5BQjnpEmh5
         T3jNJtu3NU8uKRwjvMku+4fYj9uiTJDIyWA7tYRBCDPN02MTpX9mjFWUl1DrOBs8RAMy
         u4shD+B2XhhvCRpsK0HpAuoFdwNhk9Kecv20KNReRd8mBhJJz5K12Ff2jDqNeNbgVswU
         WAsvil1e7t5XG7yAjO27jGG0OZ1fAu/HN0aefNZkHupliGxjoU+LkO+lRkT6AL6MBo+u
         KQs2iS9TvmExcHWIaLDJjJtoKjiUoZfHZ+DB21nYd+0UGyqp+9OHA/1hCbJvFSt4hTh2
         uToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lr2WGncxUm/mjgsdCL4t3YFfC5CKDyQaP6PDF9pOnuU=;
        b=xxcMLWumtGAIzzdxbXfmKmKrOAP/kAcijckoHD+KeImE8F8Dqtg3GVZXu4X4iAVOhW
         3tFIKY4e9chcy0EtjXYb9PSyDxLEqkVxAYlqKJUBWx18vCkGYCjSH2NywywO1Sc3CJmf
         pDKPwfjZRpMdGW7lKA3H4W0ngLz9oVF8KovEqdMDR8bMU2ROsIvAAAdk54vPKNZtM34e
         e/kJ5Cz9rOUepgjS3Z7p9ihwScHhpxL2cZkANBijz1j9T8AtYBYnfsIQNN3AQE6VugA+
         xca1qDBJdBFVf5HCblpqxt5n48K7P0VeqVU1XMVSUjG0IDr7v86Q5P12xsmjSmCtDLzE
         YHkA==
X-Gm-Message-State: AOAM532dTiRkGyoWD4H2T8fnINtCG1qWcJo03Qbzw/x1cfMfqDW35p8O
        ZXI+qq7nhdwGlZLuZhAlxeI6sA==
X-Google-Smtp-Source: ABdhPJzbHZhA1G05sthnxtQBr9bPe2Lc3UCkwo6n/PlaIox8s9Cs7LdLu3Tz2G7l8jmc1fHSUx1cqQ==
X-Received: by 2002:a05:6a00:1489:b0:49f:daa8:c727 with SMTP id v9-20020a056a00148900b0049fdaa8c727mr8073578pfu.56.1638387421856;
        Wed, 01 Dec 2021 11:37:01 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a3sm419738pgj.2.2021.12.01.11.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 11:37:01 -0800 (PST)
Date:   Wed, 1 Dec 2021 19:36:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 15/15] KVM: x86/mmu: Update page stats when splitting
 large pages
Message-ID: <YafO2QLmiMRfSAcZ@google.com>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-16-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119235759.1304274-16-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 19, 2021, David Matlack wrote:
> When splitting large pages we need to update the pages stats to reflect
> all of the new pages at the lower level. We do not need to change the
> page stats for the large page that was removed as that is already
> handled tdp_mmu_set_spte_atomic.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8f60d942c789..4c313613a939 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1299,7 +1299,12 @@ static bool tdp_mmu_split_large_page_atomic(struct kvm *kvm, struct tdp_iter *it
>  		child_sp->spt[i] = child_spte;
>  	}
>  
> -	return tdp_mmu_install_sp_atomic(kvm, iter, child_sp, false);
> +	if (!tdp_mmu_install_sp_atomic(kvm, iter, child_sp, false))
> +		return false;
> +
> +	kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);

This should be done when tdp_mmu_split_large_page_atomic() is introduced, otherwise
this series is effectively introducing a bug and then fixing it.  At a very quick
glance, I don't see anything that would prevent squashing this in.

> +
> +	return true;
>  }
>  
>  static void tdp_mmu_split_large_pages_root(struct kvm *kvm, struct kvm_mmu_page *root,
> -- 
> 2.34.0.rc2.393.gf8c9666880-goog
> 
