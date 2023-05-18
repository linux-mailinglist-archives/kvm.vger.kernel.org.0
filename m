Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1544670882C
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 21:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjERTFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 15:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjERTFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 15:05:30 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC61ECA
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:05:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64d18d772bdso1234130b3a.3
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684436727; x=1687028727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qaPXZjQwpMuHucPSSvg3vCkUQc8Ay+DRE5sO9MN2VqU=;
        b=zwveXuIfdYd/qj8tZUjdiY0xZagkmXSohLR+VJHXjIH+BQtZdirtrWdMnfi2Tntiw2
         tNnBgNDzfxhxzJ4MlMXKjmrIFWiSEMC4k63wRhYBN3T6mfHSuzkxxGUb95lZmD1j4ptE
         4HkcpXW02IxpKntr/WVLoZWRb1dBMqYTg9Dwb9NuNqdE3VztQzeiYmREE+HTag6uUoBB
         GTq2m4brQDiLD5CuytB3nCe+3UEYo1w+PxLov+pKHC7m8q/3xnGE6ikvwcRvPzvpRORL
         7jbVVdNo1Pv8ZresIgf7H9Nrh2mDcO7JqyaR8lI8wyQxW4awuwCwa8NAQerB7F7ZhF95
         g+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684436727; x=1687028727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qaPXZjQwpMuHucPSSvg3vCkUQc8Ay+DRE5sO9MN2VqU=;
        b=K2u13QIGtPiSsdY+ugcRERPmQf5CrwE1NxCzYCPoe2C5L6f1G8RMpAyKwMXYugjDYf
         cA5vBd6qlyFOQrILzGRZfb4rdBLbbBjp/0kj/mK+fwom8Rd9RQgLqs8axrFUL89y/XU/
         9wS/PvS8tWJZc2aCqYPkAieuVZ4sfXKRg/H47ybvShjGyf9CA6rbg/INedSsgcBeqnpw
         zrQ4FZDED4iaSMg9QAsJ0rN2rv9b4uiI96bHBeVAuYMt7LvO7lqwD+ZGdWrVMi9eP4wU
         v5sUkc3oBUQL/yVX9rNwPU51gX5n93KGmtyOKa3NnkhkKlNrOhla3aVwyLcmdy7OdEpC
         D61w==
X-Gm-Message-State: AC+VfDzj3bydA/YV4LykNUNdVjtqzO5muCPV5ae/XxAnqKZ+EXYfnBmN
        kRsSSaML1AzH83Q7KCYNop5Gpw==
X-Google-Smtp-Source: ACHHUZ4mwnJuBAqtj5AknLIgnMxasaPqQbsplioZ5tOpO4rPnkfRPMamoigo1opISuywXj4AfUhF2Q==
X-Received: by 2002:a05:6a20:4321:b0:104:3c82:38c0 with SMTP id h33-20020a056a20432100b001043c8238c0mr970876pzk.41.1684436726991;
        Thu, 18 May 2023 12:05:26 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id q35-20020a17090a17a600b002502161b063sm8871pja.54.2023.05.18.12.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 12:05:26 -0700 (PDT)
Date:   Thu, 18 May 2023 19:05:23 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 9/9] KVM: x86/mmu: BUG() in rmap helpers iff
 CONFIG_BUG_ON_DATA_CORRUPTION=y
Message-ID: <ZGZ2834xLw/woerO@google.com>
References: <20230511235917.639770-1-seanjc@google.com>
 <20230511235917.639770-10-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511235917.639770-10-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023, Sean Christopherson wrote:
> Introduce KVM_BUG_ON_DATA_CORRUPTION() and use it in the low-level rmap
> helpers to convert the existing BUG()s to WARN_ON_ONCE() when the kernel
> is built with CONFIG_BUG_ON_DATA_CORRUPTION=n, i.e. does NOT want to BUG()
> on corruption of host kernel data structures.  Environments that don't
> have infrastructure to automatically capture crash dumps, i.e. aren't
> likely to enable CONFIG_BUG_ON_DATA_CORRUPTION=y, are typically better
> served overall by WARN-and-continue behavior (for the kernel, the VM is
> dead regardless), as a BUG() while holding mmu_lock all but guarantees
> the _best_ case scenario is a panic().
> 
> Make the BUG()s conditional instead of removing/replacing them entirely as
> there's a non-zero chance (though by no means a guarantee) that the damage
> isn't contained to the target VM, e.g. if no rmap is found for a SPTE then
> KVM may be double-zapping the SPTE, i.e. has already freed the memory the
> SPTE pointed at and thus KVM is reading/writing memory that KVM no longer
> owns.
> 
> Link: https://lore.kernel.org/all/20221129191237.31447-1-mizhang@google.com
> Suggested-by: Mingwei Zhang <mizhang@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
> +/*
> + * Note, "data corruption" refers to corruption of host kernel data structures,
> + * not guest data.  Guest data corruption, suspected or confirmed, that is tied
> + * and contained to a single VM should *never* BUG() and potentially panic the
> + * host, i.e. use this variant of KVM_BUG() if and only if a KVM data structure
> + * is corrupted and that corruption can have a cascading effect to other parts
> + * of the hosts and/or to other VMs.
> + */
> +#define KVM_BUG_ON_DATA_CORRUPTION(cond, kvm)			\
> +({								\
> +	bool __ret = !!(cond);					\
> +								\
> +	if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION))		\
> +		BUG_ON(__ret);					\
> +	else if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))	\
> +		kvm_vm_bugged(kvm);				\
> +	unlikely(__ret);					\
> +})
> +
Previously, my concern was that people might abuse this feature by
generating lots of KVM_BUG_ON_DATA_CORRUPTION() in the code, with the
execuse that "hey, it is not a BUG_ON(), just turn off
CONFIG_BUG_ON_DATA_CORRUPTION." In reality, especially in production, no
one will take that risk by completely turning off the KCONFIG, so
KVM_BUG_ON_DATA_CORRUPTION() is still a BUG_ON() but with people having
execuses to add more.

Later I realize that this worry is purely based on hypothesis, so I
choose to not worry about that anymore. Overall, making BUG_ON()
tunable is still a very good progress. Thank you and David for the
help.

-Mingwei

>  static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
>  {
>  #ifdef CONFIG_PROVE_RCU
> -- 
> 2.40.1.606.ga4b1b128d6-goog
> 
