Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5457448BA8F
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 23:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346003AbiAKWMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 17:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345951AbiAKWMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 17:12:46 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D28CC06173F
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:12:46 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id c36so1215866uae.13
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 14:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r07AHSrwP7IiWaEc7XuaOpzxQqznHXlAJOTUVnC9Vs4=;
        b=SoKy7zFxyiZIdEqDDvOy55G3RyQeDHBYuXYA0ds5AFE1ghNy88MWPRSTJJu1I27m//
         Tn0zXSHitKGrBp82XAL0fqoQEQftUzzmRiRs3cYeqCqKNWnVrqdNdiGuAKiExQbrJ/pn
         PeeU8VO/ymOqvy1DR08Ddip5epHa/U+1AvWGOU5mFS00J6+PQf+GxHG7fgugyVD9q/E0
         ddcKS/8jlMs6CeE1VnGo/jSicIwx7r2YbZemenSGs2pQqqMbSFcIfSeWISIqG2Q2ZyGC
         ViHS32HwVD+VIzeEMdbcAwmlRNq7I+FmHmKrUdjmOgMg54ZCHnb/lmlKpIq4kpt3lFY1
         K3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r07AHSrwP7IiWaEc7XuaOpzxQqznHXlAJOTUVnC9Vs4=;
        b=bH+DmHh4nUSTnZSZ29AW5/WHHdzlP3HgQzProiGOwInJdnEgI3BXhVS5NIdivMvXJc
         t03WCwqxKZR8zs5D8lv72w/wk6V/ia3sgZvcDMBqVURnS+O/YOFINXpL0pGSdlifi040
         UN6UbPxxhAIHR5q7pCP56P7O2WWza9I0tjm2yfyNP9EKztjhJqrgTDyjeGyV3lt5p0hI
         4JRsrAuP0ELIwQlrjiFd0hRXX8fs1lHGk+B41HeUrvgAIhcRLWq4cmOAIB4nzX9hyHmv
         pA9EI8cXfsXORNsoy9UkuAprKIrNCF6k1ty4GTzq/+Zpt0uAaWh0Dv0tJuSOA2yv/rmu
         gLDA==
X-Gm-Message-State: AOAM530X1EsSqW9n2IGPrX92c2PVtAUO155qMe5aQnaYgPYOwiWr8Wsu
        UsMESXG0HP5mUGbHX+Nlofv1LoxkSe99qu3PA3JNNQ==
X-Google-Smtp-Source: ABdhPJykyDLPhTd+VxJJF2l6DucJ4yNqzfCKkidJatnlOChHRQstJQQgi8avKM3niDpObkvUxYiEkxdrWnFBgVBxboQ=
X-Received: by 2002:a05:6102:c46:: with SMTP id y6mr3403896vss.82.1641939165542;
 Tue, 11 Jan 2022 14:12:45 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com> <877db6trlc.wl-maz@kernel.org>
In-Reply-To: <877db6trlc.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 11 Jan 2022 14:12:33 -0800
Message-ID: <CAAdAUtiZ4GXkDfjeknCmN5TZAiw5roH2h8pdeUGLMva50CL6rg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] ARM64: Guest performance improvement during dirty
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 3:55 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 10 Jan 2022 21:04:38 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > This patch is to reduce the performance degradation of guest workload during
> > dirty logging on ARM64. A fast path is added to handle permission relaxation
> > during dirty logging. The MMU lock is replaced with rwlock, by which all
> > permision relaxations on leaf pte can be performed under the read lock. This
> > greatly reduces the MMU lock contention during dirty logging. With this
> > solution, the source guest workload performance degradation can be improved
> > by more than 60%.
> >
> > Problem:
> >   * A Google internal live migration test shows that the source guest workload
> >   performance has >99% degradation for about 105 seconds, >50% degradation
> >   for about 112 seconds, >10% degradation for about 112 seconds on ARM64.
> >   This shows that most of the time, the guest workload degradtion is above
> >   99%, which obviously needs some improvement compared to the test result
> >   on x86 (>99% for 6s, >50% for 9s, >10% for 27s).
> >   * Tested H/W: Ampere Altra 3GHz, #CPU: 64, #Mem: 256GB
> >   * VM spec: #vCPU: 48, #Mem/vCPU: 4GB
>
> What are the host and guest page sizes?
Both are 4K and guest mem is 2M hugepage backed. Will add the info for
future posts.
>
> >
> > Analysis:
> >   * We enabled CONFIG_LOCK_STAT in kernel and used dirty_log_perf_test to get
> >     the number of contentions of MMU lock and the "dirty memory time" on
> >     various VM spec.
> >     By using test command
> >     ./dirty_log_perf_test -b 2G -m 2 -i 2 -s anonymous_hugetlb_2mb -v [#vCPU]
>
> How is this test representative of the internal live migration test
> you mention above? '-m 2' indicates a mode that varies depending on
> the HW and revision of the test (I just added a bunch of supported
> modes). Which one is it?
The "dirty memory time" is the time vCPU threads spent in KVM after
fault. Higher "dirty memory time" means higher degradation to guest
workload.
'-m 2' indicates mode "PA-bits:48,  VA-bits:48,  4K pages". Will add
this for future posts.
>
> >     Below are the results:
> >     +-------+------------------------+-----------------------+
> >     | #vCPU | dirty memory time (ms) | number of contentions |
> >     +-------+------------------------+-----------------------+
> >     | 1     | 926                    | 0                     |
> >     +-------+------------------------+-----------------------+
> >     | 2     | 1189                   | 4732558               |
> >     +-------+------------------------+-----------------------+
> >     | 4     | 2503                   | 11527185              |
> >     +-------+------------------------+-----------------------+
> >     | 8     | 5069                   | 24881677              |
> >     +-------+------------------------+-----------------------+
> >     | 16    | 10340                  | 50347956              |
> >     +-------+------------------------+-----------------------+
> >     | 32    | 20351                  | 100605720             |
> >     +-------+------------------------+-----------------------+
> >     | 64    | 40994                  | 201442478             |
> >     +-------+------------------------+-----------------------+
> >
> >   * From the test results above, the "dirty memory time" and the number of
> >     MMU lock contention scale with the number of vCPUs. That means all the
> >     dirty memory operations from all vCPU threads have been serialized by
> >     the MMU lock. Further analysis also shows that the permission relaxation
> >     during dirty logging is where vCPU threads get serialized.
> >
> > Solution:
> >   * On ARM64, there is no mechanism as PML (Page Modification Logging) and
> >     the dirty-bit solution for dirty logging is much complicated compared to
> >     the write-protection solution. The straight way to reduce the guest
> >     performance degradation is to enhance the concurrency for the permission
> >     fault path during dirty logging.
> >   * In this patch, we only put leaf PTE permission relaxation for dirty
> >     logging under read lock, all others would go under write lock.
> >     Below are the results based on the solution:
> >     +-------+------------------------+
> >     | #vCPU | dirty memory time (ms) |
> >     +-------+------------------------+
> >     | 1     | 803                    |
> >     +-------+------------------------+
> >     | 2     | 843                    |
> >     +-------+------------------------+
> >     | 4     | 942                    |
> >     +-------+------------------------+
> >     | 8     | 1458                   |
> >     +-------+------------------------+
> >     | 16    | 2853                   |
> >     +-------+------------------------+
> >     | 32    | 5886                   |
> >     +-------+------------------------+
> >     | 64    | 12190                  |
> >     +-------+------------------------+
> >     All "dirty memory time" have been reduced by more than 60% when the
> >     number of vCPU grows.
>
> How does that translate to the original problem statement with your
> live migration test?
Based on the solution, the test results from the Google internal live
migration test also shows more than 60% improvement with >99% for 30s,
>50% for 58s and >10% for 76s.
Will add this info in to future posts.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
