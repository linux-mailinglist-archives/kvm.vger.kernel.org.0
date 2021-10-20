Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1FF43535C
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 21:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhJTTEN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 15:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhJTTEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 15:04:11 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E49DC06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 12:01:57 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n11so16809206plf.4
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 12:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DANx3HO6cgPisAl+CHhBZy+n2kHgp44pkICwDmul91Y=;
        b=T2NpTM70PleU3Fgawia08s/phmB4W9mNfejNL2ZIBKiqj1LnIfPkJ+ajkOUm4p8Y7R
         yJg0aSR2qHZf4XvVVbHhpfkkoD/wL+gJv6TazBaQGH9k1P9sdh7Pl231jNNfXqq0ruDH
         wZMWuKyi7HsMW1lnaT5GRWpsVhH2KQWmRxtNTe79CVhjYrTnfcdej/kOgHttUwopLFE3
         f/XdT1INFEaMarLdmGz6fIQddAsdZo37xruTpsVsMwQhmW9Z6C4rkSQBfx2bKTBKEmYQ
         sCjar7V528p8iltu4Z7FeKclr2dmHxuvQ3iXKTSvd3/w+Om0wfpCOQ4/noJJP+52FLO7
         B4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DANx3HO6cgPisAl+CHhBZy+n2kHgp44pkICwDmul91Y=;
        b=hSyVBruYdy+Zw2Lqn+SxDyQne1u0EztbY1jGIS0eA6y4Hc/4+qzbBu26Z007vHJzS4
         vrglMI95QZWOjb9fYFrPP6xz7ry/HpkJXcOvVoVd7ZccuO9zkTgkZ49cqd7mqHOXCbYI
         nfiupDSVqmBu8s7PaX2vGFvVu1R5RTohN4XNVOHF/ACR3XX8ZUwsOcE+8KJiFUgIDJMj
         1IRa/yX17bo76UsXRfM84K5eCIWra9TGHtZMuaGWzs9fyVPbL4pB/K5zY95Qu4W+0t9z
         yu/hhTjpWFDUfeaM0t+bIdLoCQbHzv0td0UReCPRjsrrIzEJ4zIttBorGFVyTJ/R0tzw
         KTmw==
X-Gm-Message-State: AOAM530Jw2tkR/MUukuf9VhPmDBuNNJC/E23mv4wEu6zYEPbeGm4QZHx
        92VgsqDsrOm7E0H5yQEZKssR6w==
X-Google-Smtp-Source: ABdhPJxTtZlD3tik07e31gwxjRrXsiDg7LAunZboxgnl2JeTj/bjMYSpzdfqi37yk9rhQ+Oc4bfF5g==
X-Received: by 2002:a17:903:230f:b0:13f:cca9:bf2f with SMTP id d15-20020a170903230f00b0013fcca9bf2fmr821720plh.51.1634756516653;
        Wed, 20 Oct 2021 12:01:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j198sm3003802pgc.4.2021.10.20.12.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:01:55 -0700 (PDT)
Date:   Wed, 20 Oct 2021 19:01:51 +0000
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
Subject: Re: [PATCH v5 01/13] KVM: x86: Cache total page count to avoid
 traversing the memslot array
Message-ID: <YXBnn6ZaXbaqKvOo@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <d07f07cdd545ab1a495a9a0da06e43ad97c069a2.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9Fi128rYxiF1v3@google.com>
 <e618edce-b310-6d9a-3860-d7f4d8c0d98f@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e618edce-b310-6d9a-3860-d7f4d8c0d98f@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Maciej S. Szmigiero wrote:
> On 20.10.2021 00:24, Sean Christopherson wrote:
> > E.g. the whole thing can be
> > 
> > 	if (!kvm->arch.n_requested_mmu_pages &&
> > 	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
> > 		unsigned long nr_mmu_pages;
> > 
> > 		if (change == KVM_MR_CREATE) {
> > 			kvm->arch.n_memslots_pages += new->npages;
> > 		} else {
> > 			WARN_ON(kvm->arch.n_memslots_pages < old->npages);
> > 			kvm->arch.n_memslots_pages -= old->npages;
> > 		}
> > 
> > 		nr_mmu_pages = (unsigned long)kvm->arch.n_memslots_pages;
> > 		nr_mmu_pages *= (KVM_PERMILLE_MMU_PAGES / 1000);
> 
> The above line will set nr_mmu_pages to zero since KVM_PERMILLE_MMU_PAGES
> is 20, so when integer-divided by 1000 will result in a multiplication
> coefficient of zero.

Ugh, math.  And thus do_div() to avoid the whole 64-bit divide issue on 32-bit KVM.
Bummer.
