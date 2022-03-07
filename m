Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FFF4D0C29
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 00:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbiCGXlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 18:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiCGXlC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 18:41:02 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4622410E5
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 15:40:05 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id z11so13751665lfh.13
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 15:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bH59quT9Rp4y+BYnuvhUI8Xloeds0wulYCUciw4C3j4=;
        b=kCF5g2h+dd8QMyeJ20SqRvJJOIf1pabp7XZPoeaYBb6+gXXwoULqfICvDke96/mhhT
         e2kNJHAmu/InctdLWMjGDRKXgL3m+XPeBSYX0G7qDiEdTyRTB3BJ1oS18l78SU6RBkYi
         Y2USAPx06B5gxcdymMaMhhmN18O/NRL4g2KtrPfP5jkfwB+LpAOoXWHghflp6gZ0YjCP
         Aeh1OumCrc18SVQqaR2l+Li+RmtLTevzmhJp8NBEjijRtmt2C1wvm7bhLxNB0QH974J0
         6QNGwXaThNN25qCB1TVn2Pag26T1qfJ3AKRlHVzpJ8RU+O2dBOzqz7h6Vgfnmn4Rvku3
         53iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bH59quT9Rp4y+BYnuvhUI8Xloeds0wulYCUciw4C3j4=;
        b=vbasDHefD5VXCtA04RU+J02DmlX+Ns9LR36wuMKQusFvDez135QA8qB3b9k6o1Dl+n
         /4U3E/ilTFJ7ZtOxeb7ELB90OJhEIeFrskJd3TC8blnGwRkKtODllsCxp+Qdn60sI6PI
         fDYOWgg4wxlfxQ8AUQWg5j7io3/b3C+/z/YjGUrbk/WEKkYHPZqEGFOY2ApCrzxQHG+/
         F/WannApSl2GnOuNDoPOLjmqsYa/Vgzf853Sd8LjYI2vgRFB+cg1HW3gd9iXpYxl6DBb
         9FkuZYWmnymccbwnxLgS79kE0+57T/scnuGRb5jmIWd0P8OS+0V8wtbRVC1qOOZueZ77
         YuaA==
X-Gm-Message-State: AOAM5314x37a46l5pm1ujfsQGR5WMRfgWOsJjqYA1JnGLpW/K+Z42V9U
        QQBLux4XE7hMZ4eXjn7S93e9QFigr0mU7iMiXUVyLg==
X-Google-Smtp-Source: ABdhPJw7lc5h8kjZxLC9dZiRIvmTMM38trbW23obPTJ9KL11C7pLvI+HnbjPR2ROLjtDlGzyiR9h7DiJoV5nyQpMx54=
X-Received: by 2002:a05:6512:1287:b0:447:5c8a:c9e2 with SMTP id
 u7-20020a056512128700b004475c8ac9e2mr9405466lfs.64.1646696404019; Mon, 07 Mar
 2022 15:40:04 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <YiWWdekvbPjI/WZm@xz-m1.local>
In-Reply-To: <YiWWdekvbPjI/WZm@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 7 Mar 2022 15:39:37 -0800
Message-ID: <CALzav=fzOkR4oNXoccc40GKzdBrmA+q5bgKE9ViE5W0UYjjHmw@mail.gmail.com>
Subject: Re: [PATCH 00/23] Extend Eager Page Splitting to the shadow MMU
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 6, 2022 at 9:22 PM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, David,
>
> Sorry for a very late comment.
>
> On Thu, Feb 03, 2022 at 01:00:28AM +0000, David Matlack wrote:
> > Performance
> > -----------
> >
> > Eager page splitting moves the cost of splitting huge pages off of the
> > vCPU thread and onto the thread invoking VM-ioctls to configure dirty
> > logging. This is useful because:
> >
> >  - Splitting on the vCPU thread interrupts vCPUs execution and is
> >    disruptive to customers whereas splitting on VM ioctl threads can
> >    run in parallel with vCPU execution.
> >
> >  - Splitting on the VM ioctl thread is more efficient because it does
> >    no require performing VM-exit handling and page table walks for every
> >    4K page.
> >
> > To measure the performance impact of Eager Page Splitting I ran
> > dirty_log_perf_test with tdp_mmu=N, various virtual CPU counts, 1GiB per
> > vCPU, and backed by 1GiB HugeTLB memory.
> >
> > To measure the imapct of customer performance, we can look at the time
> > it takes all vCPUs to dirty memory after dirty logging has been enabled.
> > Without Eager Page Splitting enabled, such dirtying must take faults to
> > split huge pages and bottleneck on the MMU lock.
> >
> >              | "Iteration 1 dirty memory time"             |
> >              | ------------------------------------------- |
> > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > ------------ | -------------------- | -------------------- |
> > 2            | 0.310786549s         | 0.058731929s         |
> > 4            | 0.419165587s         | 0.059615316s         |
> > 8            | 1.061233860s         | 0.060945457s         |
> > 16           | 2.852955595s         | 0.067069980s         |
> > 32           | 7.032750509s         | 0.078623606s         |
> > 64           | 16.501287504s        | 0.083914116s         |
> >
> > Eager Page Splitting does increase the time it takes to enable dirty
> > logging when not using initially-all-set, since that's when KVM splits
> > huge pages. However, this runs in parallel with vCPU execution and does
> > not bottleneck on the MMU lock.
> >
> >              | "Enabling dirty logging time"               |
> >              | ------------------------------------------- |
> > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > ------------ | -------------------- | -------------------- |
> > 2            | 0.001581619s         |  0.025699730s        |
> > 4            | 0.003138664s         |  0.051510208s        |
> > 8            | 0.006247177s         |  0.102960379s        |
> > 16           | 0.012603892s         |  0.206949435s        |
> > 32           | 0.026428036s         |  0.435855597s        |
> > 64           | 0.103826796s         |  1.199686530s        |
> >
> > Similarly, Eager Page Splitting increases the time it takes to clear the
> > dirty log for when using initially-all-set. The first time userspace
> > clears the dirty log, KVM will split huge pages:
> >
> >              | "Iteration 1 clear dirty log time"          |
> >              | ------------------------------------------- |
> > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > ------------ | -------------------- | -------------------- |
> > 2            | 0.001544730s         | 0.055327916s         |
> > 4            | 0.003145920s         | 0.111887354s         |
> > 8            | 0.006306964s         | 0.223920530s         |
> > 16           | 0.012681628s         | 0.447849488s         |
> > 32           | 0.026827560s         | 0.943874520s         |
> > 64           | 0.090461490s         | 2.664388025s         |
> >
> > Subsequent calls to clear the dirty log incur almost no additional cost
> > since KVM can very quickly determine there are no more huge pages to
> > split via the RMAP. This is unlike the TDP MMU which must re-traverse
> > the entire page table to check for huge pages.
> >
> >              | "Iteration 2 clear dirty log time"          |
> >              | ------------------------------------------- |
> > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > ------------ | -------------------- | -------------------- |
> > 2            | 0.015613726s         | 0.015771982s         |
> > 4            | 0.031456620s         | 0.031911594s         |
> > 8            | 0.063341572s         | 0.063837403s         |
> > 16           | 0.128409332s         | 0.127484064s         |
> > 32           | 0.255635696s         | 0.268837996s         |
> > 64           | 0.695572818s         | 0.700420727s         |
>
> Are all the tests above with ept=Y (except the one below)?

Yes.

>
> >
> > Eager Page Splitting also improves the performance for shadow paging
> > configurations, as measured with ept=N. Although the absolute gains are
> > less since ept=N requires taking the MMU lock to track writes to 4KiB
> > pages (i.e. no fast_page_fault() or PML), which dominates the dirty
> > memory time.
> >
> >              | "Iteration 1 dirty memory time"             |
> >              | ------------------------------------------- |
> > vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
> > ------------ | -------------------- | -------------------- |
> > 2            | 0.373022770s         | 0.348926043s         |
> > 4            | 0.563697483s         | 0.453022037s         |
> > 8            | 1.588492808s         | 1.524962010s         |
> > 16           | 3.988934732s         | 3.369129917s         |
> > 32           | 9.470333115s         | 8.292953856s         |
> > 64           | 20.086419186s        | 18.531840021s        |
>
> This one is definitely for ept=N because it's written there. That's ~10%
> performance increase which looks still good, but IMHO that increase is
> "debatable" since a normal guest may not simply write over the whole guest
> mem.. So that 10% increase is based on some assumptions.
>
> What if the guest writes 80% and reads 20%?  IIUC the split thread will
> also start to block the readers too for shadow mmu while it was not blocked
> previusly?  From that pov, not sure whether the series needs some more
> justification, as the changeset seems still large.
>
> Is there other benefits besides the 10% increase on writes?

Yes, in fact workloads that perform some reads will benefit _more_
than workloads that perform only writes.

The reason is that the current lazy splitting approach unmaps the
entire huge page on write and then maps in the just the faulting 4K
page. That means reads on the unmapped portion of the hugepage will
now take a fault and require the MMU lock. In contrast, Eager Page
Splitting fully splits each huge page so readers should never take
faults.

For example, here is the data with 20% writes and 80% reads (i.e. pass
`-f 5` to dirty_log_perf_test):

             | "Iteration 1 dirty memory time"             |
             | ------------------------------------------- |
vCPU Count   | eager_page_split=N   | eager_page_split=Y   |
------------ | -------------------- | -------------------- |
2            | 0.403108098s         | 0.071808764s         |
4            | 0.562173582s         | 0.105272819s         |
8            | 1.382974557s         | 0.248713796s         |
16           | 3.608993666s         | 0.571990327s         |
32           | 9.100678321s         | 1.702453103s         |
64           | 19.784780903s        | 3.489443239s        |

>
> Thanks,

>
> --
> Peter Xu
>
