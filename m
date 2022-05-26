Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB9B53478E
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 02:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344576AbiEZAjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 20:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344599AbiEZAi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 20:38:59 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072B9B41F1
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 17:38:57 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b135so370277pfb.12
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 17:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7P8MdhBUHeNYERj02eaiVlo3+1akuXNgpyLjujYYpb0=;
        b=nGnImQMrxcKuAMPfn2cnaf9VK34koPZI6BdWd8L/dvJkOmKEczFMWc8Yx7hsQFZeVL
         9KLxd0tBqQk1/z15iyaTJQGyj+rpJcqO/oigF6/cI0x8g+X/Xo/VBfVgAonu8k6z7tAw
         rX3SONGBqur0M8KowUWh/wmc3aYT+yOgmGgvthbF1GbnQhkOPFYSCTfv0l7sg5kj2jls
         D/lYOdddeRohuY3mRJGYNVA5mDFRmRi5K+xU9HMyUH4O1+TPylZTZEwi6U0ynqv/r7ZQ
         PEcsEwLY3XMn7/TlPZPqXhp0uzspbOfW5miRUT3ck3ZbCGUmofEeJzc2ijyz7b5LJr0L
         9x9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7P8MdhBUHeNYERj02eaiVlo3+1akuXNgpyLjujYYpb0=;
        b=fLhR/43EskDNA1Up5Q4gqW7+n1Q/oZpzMre4qnPcLhSZi2acgSrYuZHXzcTMYVhDUX
         wXLmZVpUyuNePRWKUtldr/UjtUOrw2wky3QmY3PAoHwsfU1oFj0pJc2ngdcV8HUGpXXJ
         WTOu2VpSovh9UEcCqD9yvhJdPY8k80jLaNo33iBVSQD/dmAPiB41W2Senct+mXv6aEj9
         1U2XXGfJmzSC9NeR9zAO+1KudGs/CAY9vaPRak783cElZ2oWdtLDL2XXMN5+41swuK7Y
         kqlgx2P8OZXtu9WbLDdJIsKZaztzPlN5ayLO3niaAnCQdT8a0yLzJPGs4EyhF53aKtRs
         DD2A==
X-Gm-Message-State: AOAM530sDn6kJbPz/mDkxyF93veaoCuMpB1ekIM91n174uL34vAQvAnn
        qZnQ2RlWs//P2Tfgr9l8IVh8Ag==
X-Google-Smtp-Source: ABdhPJxQ2PEcWk8DK3E2AzHueuX2Pq6jI8vVF9DbxayvJeVzlRCPUepbJ8f3PDiOx87ktlbbZyxBrw==
X-Received: by 2002:a62:1413:0:b0:518:4259:200e with SMTP id 19-20020a621413000000b005184259200emr34153334pfu.41.1653525537153;
        Wed, 25 May 2022 17:38:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id bh8-20020a056a02020800b003f5cc9c31e2sm141353pgb.38.2022.05.25.17.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 17:38:56 -0700 (PDT)
Date:   Thu, 26 May 2022 00:38:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Marc Zyngier <maz@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Oliver Upton <oupton@google.com>,
        Cgroups <cgroups@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Message-ID: <Yo7MHA2aUaprvgl8@google.com>
References: <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org>
 <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
 <Yn6DeEGLyR4Q0cDp@google.com>
 <CALvZod6nERq4j=L0V+pc-rd5+QKi4yb_23tWV-1MF53xL5KE6Q@mail.gmail.com>
 <CAJD7tka-5+XRkthNV4qCg8woPCpjcwynQoRBame-3GP1L8y+WQ@mail.gmail.com>
 <YoeoLJNQTam5fJSu@cmpxchg.org>
 <CAJD7tkYjcmwBeUx-=MTQeUf78uqFDvfpy7OuKy4OvoS7HiVO1Q@mail.gmail.com>
 <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yo4Ze+DZrLqn0PeU@cmpxchg.org>
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

On Wed, May 25, 2022, Johannes Weiner wrote:
> On Tue, May 24, 2022 at 03:31:52PM -0700, Yosry Ahmed wrote:
> > I don't have enough context to say whether we should piggyback KVM MMU
> > pages to the existing NR_PAGETABLE item, but from a high level it
> > seems like it would be more helpful if they are a separate stat.
> > Anyway, I am willing to go with whatever Sean thinks is best.
> 
> Somebody should work this out and put it into a changelog. It's
> permanent ABI.

After a lot of waffling, my vote is to add a dedicated NR_SECONDARY_PAGETABLE.

It's somewhat redundant from a KVM perspective, as NR_SECONDARY_PAGETABLE will
scale with KVM's per-VM pages_{4k,2m,1g} stats unless the guest is doing something
bizarre, e.g. accessing only 4kb chunks of 2mb pages so that KVM is forced to
allocate a large number of page tables even though the guest isn't accessing that
much memory.

But, someone would need to either understand how KVM works to make that connection,
or know (or be told) to go look at KVM's stats if they're running VMs to better
decipher the stats.

And even in the little bit of time I played with this, I found having
nr_page_table_pages side-by-side with nr_secondary_page_table_pages to be very
informative.  E.g. when backing a VM with THP versus HugeTLB,
nr_secondary_page_table_pages is roughly the same, but nr_page_table_pages is an
order of a magnitude higher with THP.  I'm guessing the THP behavior is due to
something triggering DoubleMap, but now I want to find out why that's happening.

So while I'm pretty sure a clever user could glean the same info by cross-referencing
NR_PAGETABLE stats with KVM stats, I think having NR_SECONDARY_PAGETABLE will at the
very least prove to be helpful for understanding tradeoffs between VM backing types,
and likely even steer folks towards potential optimizations.

Baseline:
  # grep page_table /proc/vmstat 
  nr_page_table_pages 2830
  nr_secondary_page_table_pages 0

THP:
  # grep page_table /proc/vmstat 
  nr_page_table_pages 7584
  nr_secondary_page_table_pages 140

HugeTLB:
  # grep page_table /proc/vmstat
  nr_page_table_pages 3153
  nr_secondary_page_table_pages 153

