Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718E53509BD
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhCaVr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhCaVr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:47:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05302C061574
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:47:56 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so1929602pjb.0
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8xelLMkxcC6WtOofiMih6F32tqKnPtSyw2jgK+CDHu4=;
        b=lRekl3fx/1xVTY4VSWAcqWY60kFcYfE3ex87ZMiyF3YMama3alXemQAvey4ua2Q2NU
         eIzwbu8ulmg+dSFPJ/LLw9M8TUwNtZ6Kf+zsLYX2btGWc+Mt6r+WqI3nE4cuuPodpDWB
         vkPyVKuV4l3DmqBnpyedy5K2ELlMSQALGThaUNGPrMsL7lsHqmcjeklTCzt6GLWxXFOh
         fcNEDPnE/MDmfK1tIflC1u5mhPxRa8t1lqjHjJZcz8mlLg7SmVa3KnKTiibQ3TVoVdfM
         W0WQ/smihKucHGWCEceoSVORhE99fiU+/wSW3je405yKPyFBfEyxm9lRJkvzLqkv3YeD
         nlyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8xelLMkxcC6WtOofiMih6F32tqKnPtSyw2jgK+CDHu4=;
        b=YRBz6NGZRJR1dWsbEA2VL/71G8JBSzWZp42hVQRPIidcA01p+VChs5spORv/v3Uw4x
         /YMPwknDO+wNz965GfV8VZSqJp8wGDLEfN73SWyNHSPSrj+/lNVmN+kUKbL730GZq+1H
         8yeOgYYpvK5T+ZEncz0c9Y8tGRg5n0WIcwIJSbGCz73RxgSuLEQy6U4LcN3w3mj6oFZn
         CcyTCdKhOijD1SSZyqIYwv6MZotZS0k+X5UEP01HP8mBPmZUnY7T9dg8f5xoT+PxwLmX
         XvQiLncbYJbY0WhOVe9yieTuo4PrweC19lvUjqyx/AB2U1SqWBAUOxSPJkzjy5xX+zuG
         7r4Q==
X-Gm-Message-State: AOAM533SbtOhdq+hDoe6LwdCT9yGiFPbQNioBbSCyJ0RprDonDFvE/Im
        pTgmOeJwiE7TZVHO9zKdbhj6vQ==
X-Google-Smtp-Source: ABdhPJyZugl5lfedBulyUfvB1YGfF9LGCaOpUeSH521YqKnnt+A07YJz3hlU79HRomGEJDuqkrmSZg==
X-Received: by 2002:a17:90b:1987:: with SMTP id mv7mr5273831pjb.152.1617227275455;
        Wed, 31 Mar 2021 14:47:55 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a30sm3300970pfr.66.2021.03.31.14.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 14:47:54 -0700 (PDT)
Date:   Wed, 31 Mar 2021 21:47:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGTuB3/JRvUwH64K@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
 <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
 <YGTkLMAzk88wOiZm@google.com>
 <345ab567-386f-9080-f9cb-0e17fa90a852@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <345ab567-386f-9080-f9cb-0e17fa90a852@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 31/03/21 23:05, Sean Christopherson wrote:
> > > Wouldn't it be incorrect to lock a mutex (e.g. inside*another*  MMU
> > > notifier's invalidate callback) while holding an rwlock_t?  That makes sense
> > > because anybody that's busy waiting in write_lock potentially cannot be
> > > preempted until the other task gets the mutex.  This is a potential
> > > deadlock.
> > 
> > Yes?  I don't think I follow your point though.  Nesting a spinlock or rwlock
> > inside a rwlock is ok, so long as the locks are always taken in the same order,
> > i.e. it's never mmu_lock -> mmu_notifier_slots_lock.
> 
> *Another* MMU notifier could nest a mutex inside KVM's rwlock.
> 
> But... is it correct that the MMU notifier invalidate callbacks are always
> called with the mmap_sem taken (sometimes for reading, e.g.
> try_to_merge_with_ksm_page->try_to_merge_one_page->write_protect_page)?

No :-(

File-based invalidations through the rmaps do not take mmap_sem.  They get at
the VMAs via the address_space's interval tree, which is protected by its own
i_mmap_rwsem.

E.g. try_to_unmap() -> rmap_walk_file() -> try_to_unmap_one() 

> We could take it temporarily in install_memslots, since the MMU notifier's mm
> is stored in kvm->mm.
> 
> In this case, a pair of kvm_mmu_notifier_lock/unlock functions would be the
> best way to abstract it.
> 
> Paolo
> 
