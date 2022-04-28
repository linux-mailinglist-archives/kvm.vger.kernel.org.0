Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87FC513B13
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 19:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350588AbiD1RtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 13:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350586AbiD1RtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 13:49:08 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C79D85657
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 10:45:52 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id h8so7242878iov.12
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 10:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rYkNgcXPFsN0AZS9Gdq00dTATV9XxHLGEv5CoQhxVgg=;
        b=hzMsoV3D0yJ0Unlop+rpTzklIYhRnWH7ICsyDlDVFdcLE9BIlkNP73Wm+4oXNVuiB8
         plJ8GuyyvEt6ZXQbKxd1muNdZzq09naSLXrKhBTeETybRl01LEoPVDN68ktaYn9l0zsi
         yoyQHHe1wradnURDVY6+HNGMMkWazXFQRLoTut+ycpEUb54hblTXLdMjgsITAqGXMdx5
         3Y8FH49L78ooub0KNRfiN5ke97caoBhhHNMCuuOQncS7BD/mI1wPI6p0qS0ilNo4Z01F
         oWlrVzL07peONZe79tOTcyd8YQZsNWlwpVd98T9TgcHmPXq0Kuzw5WruzgVtu+f1uIoR
         iH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rYkNgcXPFsN0AZS9Gdq00dTATV9XxHLGEv5CoQhxVgg=;
        b=qeVX2ip7q831ZJSuCVPeXygqZHM4+2u4aiqLGJqy5YMSAqvD7D5qtIIr8idIhNxl3W
         FLdVfnA9QdPXoGZpsHvsc9Nw6zrQOTrojPoILuHZe1R/zAt8Fm9YKlWoWFndguJjp7OO
         E3ka7avl0qfBK0HyHBPMxm22jI7ADA9snsSXDplohYx/ygwh+4isBbNpFrmZJlyaBPH9
         sryPPo5EobwPwIROOq/qmW0zxw2IVX+1CwarscCj6vMMbvallAGJlJPdJXreaqFfr70D
         +ED89nFTe6B41sLUkXWI6F4nQwA1L6pItGgF23WEPK9UBCT/CPK0eafR8x4NxqMnXFFH
         qjGQ==
X-Gm-Message-State: AOAM532QNNXxPaNn+/XrymvAuMxnbX7wfGFOfJTwzW0xsagD+hVGKFRf
        vYA0cjwilPqvjcEpP48HflpLgw==
X-Google-Smtp-Source: ABdhPJx/sYY/i7dOFt3+PaiV4KhSUz6X+tqTVPbVDr2OqPDCjEE/yaOau4YnhKo+v4gz0/SI7nAHRg==
X-Received: by 2002:a02:cc48:0:b0:32b:14:4186 with SMTP id i8-20020a02cc48000000b0032b00144186mr6761137jaq.189.1651167951414;
        Thu, 28 Apr 2022 10:45:51 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id f15-20020a056e020c6f00b002cbc9935527sm269640ilj.83.2022.04.28.10.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 10:45:50 -0700 (PDT)
Date:   Thu, 28 Apr 2022 17:45:47 +0000
From:   Oliver Upton <oupton@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
Message-ID: <YmrSywSU1ezREvT6@google.com>
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com>
 <YmegoB/fBkfwaE5z@google.com>
 <CAJD7tkY-WZKcyer=TbWF0dVfOhvZO7hqPN=AYCDZe1f+2HA-QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkY-WZKcyer=TbWF0dVfOhvZO7hqPN=AYCDZe1f+2HA-QQ@mail.gmail.com>
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

On Tue, Apr 26, 2022 at 12:27:57PM -0700, Yosry Ahmed wrote:
> > What page tables do we want to account? KVM on ARM manages several page
> > tables.
> >
> > For regular KVM, the host kernel manages allocations for the hyp stage 1
> > tables in addition to the stage 2 tables used for a particular VM. The
> > former is system overhead whereas the latter could be attributed to a
> > guest VM.
> 
> Honestly I would love to get your input on this. The main motivation
> here is to give users insights on the kernel memory usage on their
> system (or in a cgroup). We currently have NR_PAGETABLE stats for
> normal kernel page tables (allocated using
> __pte_alloc_one()/pte_free()), this shows up in /proc/meminfo,
> /path/to/cgroup/memory.stat, and node stats. The idea is to add
> NR_SECONDARY_PAGETABLE that should include the memory used for kvm
> pagetables, which should be a separate category (no overlap). What
> gets included or not depends on the semantics of KVM and what exactly
> falls under the category of secondary pagetables from the user's pov.
> 
> Currently it looks like s2 page table allocations get accounted to
> kmem of memory control groups (GFP_KERNEL_ACCOUNT), while hyp page
> table allocations do not (GFP_KERNEL). So we could either follow this
> and only account s2 page table allocations in the stats, or make hyp
> allocations use GFP_KERNEL_ACCOUNT as well and add them to the stats.
> Let me know what you think.

I think it is reasonable to just focus on stage 2 table allocations and
ignore all else. As Marc pointed out it isn't workable in other
contexts anyway (pKVM), and keeps the patch tidy too.

GFP_KERNEL_ACCOUNT for hyp allocations wouldn't make sense, as it is
done at init to build out the system page tables for EL2.

--
Thanks,
Oliver
