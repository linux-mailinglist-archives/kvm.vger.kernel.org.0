Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEF037964F
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhEJRqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhEJRqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:46:50 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25D3C061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:45:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 10so14271589pfl.1
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LDoI2UalAlpzMx1MJ5YgvrfSa+Lr0EXSwAv1GVcujSA=;
        b=EGcYvglaEIinKcy4974XzdhpdOdcIeeSlM6NNicCm8aUuu2M2z0AvqCqxl6dDbsCtJ
         3HKTRlgNYIr59QD5I13Y0o3AzCZrZ5XChwUrh6zAAsgYnX5pqtT2N0dEoM2t8rmXNzGZ
         CjDT15xetRNeEdtxnKmaReAH2qAGxHKdSPwXloTuPKekEeOUwo2nAY/zRseH2nGGVH8V
         bc1OKqMNkO+Mn7exVIjzximSdkQ0Z40sObFtURklEwJVnCqgYEtrVEUPnqjrEQRxnSIF
         J2CXZTaEfDj0lnbn/PGvobKT6yus2cwI+/Zeajm9P+0skcnQQNGa5oT1zsrgsub3AkDR
         jhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LDoI2UalAlpzMx1MJ5YgvrfSa+Lr0EXSwAv1GVcujSA=;
        b=aquoPcGdOAK9+5ElSVJtfP0LXeyB7HvwTs/ttSckoRGKOs+cqKjlGBiu1DSwXOZ0eY
         rtp0y0n+XQddEbxihLvgCitmwp4Q2+E1n+9N5QSrKDIvHtIdf0YHh4YR1zhfW47YFNZf
         ClfeY4fQUMQCp7knyOLBHNIZHwTiIuxV4BhiJ/A+4k7FNuOl3Cs2SERo5H9a8cH2lGNn
         6Ulc6fx8TMvSXNPS5SJvoFOts2aUUlvEX8ahu824D/CkHu1cEjTb3c037EOS59S1g7Zw
         gxoYoBYhIMMG2ffAozViHELYqGqdjWqlbIAuNVrTRLTI8MVHNVGSzpEY2ixYmmMMjp9y
         GDfw==
X-Gm-Message-State: AOAM532qz9txfdPJs1K/2UVQ97rJcjiMfTfJrds6Kz9ZUS87sXzVJ49v
        ZL3ELfi8ZRMJrRCnCASkWg5G8w==
X-Google-Smtp-Source: ABdhPJx1WQxFKTJwzDm127qsIpURVaFa1oDtslL6RK2QilZyhWR2vlNTkEmjmGUmJ6PlbuvPxEECPQ==
X-Received: by 2002:a63:ed4d:: with SMTP id m13mr26369865pgk.433.1620668742283;
        Mon, 10 May 2021 10:45:42 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i14sm11971640pgk.77.2021.05.10.10.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 10:45:41 -0700 (PDT)
Date:   Mon, 10 May 2021 17:45:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v3 7/8] KVM: x86/mmu: Protect rmaps independently with
 SRCU
Message-ID: <YJlxQe1AXljq5yhQ@google.com>
References: <20210506184241.618958-1-bgardon@google.com>
 <20210506184241.618958-8-bgardon@google.com>
 <e2e73709-f247-1a60-4835-f3fad37ab736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e73709-f247-1a60-4835-f3fad37ab736@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021, Paolo Bonzini wrote:
> On 06/05/21 20:42, Ben Gardon wrote:
> > In preparation for lazily allocating the rmaps when the TDP MMU is in
> > use, protect the rmaps with SRCU. Unfortunately, this requires
> > propagating a pointer to struct kvm around to several functions.
> 
> Thinking more about it, this is not needed because all reads of the rmap
> array are guarded by the load-acquire of kvm->arch.memslots_have_rmaps.
> That is, the pattern is always
> 
> 	if (!load-acquire(memslot_have_rmaps))
> 		return;
> 	... = __gfn_to_rmap(...)
> 
> 				slots->arch.rmap[x] = ...
> 				store-release(memslot_have_rmaps, true)
> 
> where the load-acquire/store-release have the same role that
> srcu_dereference/rcu_assign_pointer had before this patch.
> 
> We also know that any read that misses the check has the potential for a
> NULL pointer dereference, so it *has* to be like that.
> 
> That said, srcu_dereference has zero cost unless debugging options are
> enabled, and it *is* true that the rmap can disappear if kvm->srcu is not
> held, so I lean towards keeping this change and just changing the commit
> message like this:
> 
> ---------
> Currently, rmaps are always allocated and published together with a new
> memslot, so the srcu_dereference for the memslots array already ensures that
> the memory pointed to by slots->arch.rmap is zero at the time
> slots->arch.rmap.  However, they still need to be accessed in an SRCU
> read-side critical section, as the whole memslot can be deleted outside
> SRCU.
> --------

I disagree, sprinkling random and unnecessary __rcu/SRCU annotations does more
harm than good.  Adding the unnecessary tag could be quite misleading as it
would imply the rmap pointers can _change_ independent of the memslots.

Similary, adding rcu_assign_pointer() in alloc_memslot_rmap() implies that its
safe to access the rmap after its pointer is assigned, and that's simply not
true since an rmap array can be freed if rmap allocation for a different memslot
fails.  Accessing the rmap is safe if and only if all rmaps are allocated, i.e.
if arch.memslots_have_rmaps is true, as you pointed out.

Furthermore, to actually gain any protection from SRCU, there would have to be
an synchronize_srcu() call after assigning the pointers, and that _does_ have an
associated.  Not to mention that to truly respect the __rcu annotation, deleting
the rmaps would also have to be done "independently" with the correct
rcu_assign_pointer() and synchronize_srcu() logic.
