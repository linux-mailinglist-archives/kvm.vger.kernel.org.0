Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19914F49AD
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443939AbiDEWUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573285AbiDESqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 14:46:24 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ABA6C1FC
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 11:44:23 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id n6-20020a17090a670600b001caa71a9c4aso347903pjj.1
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 11:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QTtfteCBJde9+EQLf4xy64EIb7y4vRXVxoJwl5th8o4=;
        b=j2y3x9BT3RfV/P+m5cLOxF75ZVUNuijh/mc9q79SzD3/O/0yLV/DpjQ7+JwCtYtgoK
         1jDdFs3T35o+85eKLs7bntj4yuZJBYsKvl1QO08/qf4+MX+Him161GtNXWnRX6c4fXfj
         iSb0IxK7g3Cxl9aocr3TrUE+MTus/YYh+zJvARyv8+3Q/Qr5wl1k7mNeeFjSDBo8H5DD
         OoL3EPOUkGLb+R8Y5W1i0Xnqj3lSlET2k76ADfxHxzqmNT4xd3PQ4UATJ3NFzfJd2GTO
         tOe0SQkqHmbYOJ+cBc8EJl0D0A/+0ErtIzitql/SzKncBNLwQ5kNalNLWEvpc+bMbdS1
         g1kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QTtfteCBJde9+EQLf4xy64EIb7y4vRXVxoJwl5th8o4=;
        b=f2Cv4XYDU4xwYL2ATb0owJTdI+SelRp27THAOuIaxTrNZO+xbr9VmmuTTP+6skgSO2
         t3w/FxdWX48PaVvoTKKHn6LrYjBDgzdAL1eIOx0VC5uMuIW4ST8EO+TUaNmPNxXJfMAo
         NBCA9crTg0VY4hdPyywZbd9Ogflr7P+dyLXjMbveqqd8n88c/nPWvH3NCyLjp6Gm0kuY
         QBC0Txkey5SN0O4QX0q5B9Bik/ltKv0jIZcIp+TwCpkNfhl7k9uG8HFsG4KB3QzVYgI0
         r72t1OpgscSPUUMgdhSi4N08IRL7D6r/xM2vAEBYmsO0ZYJ9GeqG9f27NY3sSpS6tfMM
         pztA==
X-Gm-Message-State: AOAM530KKSRMRDszL1nTJyyr1Np6A7a83Yl0P9cQAbsOaDQm5MO69jWX
        1dkhSuKpZUx+FA60rtI0rkUaeOQU3KgCUfVTpydJeQ==
X-Google-Smtp-Source: ABdhPJyQZ5gG6StvwqBHK1D/Yby5/Op5+tOYpB7C6O0TsYQWBvo+aujEbht9/RPHfgoxfTxoOo8Kg8gUFg8lSs129SU=
X-Received: by 2002:a17:903:408c:b0:156:8617:17be with SMTP id
 z12-20020a170903408c00b00156861717bemr5015662plc.162.1649184262949; Tue, 05
 Apr 2022 11:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220311001252.195690-1-yosryahmed@google.com> <20220311192023.ocjybjc6q2yozrix@google.com>
In-Reply-To: <20220311192023.ocjybjc6q2yozrix@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 5 Apr 2022 11:43:47 -0700
Message-ID: <CAJD7tkaFqcbKt6wW1-NVpBovG5i2+Rj0XauKm1fom394kKSh0A@mail.gmail.com>
Subject: Re: [PATCH] KVM: memcg: count KVM page table pages used by KVM in
 memcg pagetable stats
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
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

On Fri, Mar 11, 2022 at 11:20 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:12:52AM +0000, Yosry Ahmed wrote:
> > Count the pages used by KVM for page tables in pagetable memcg stats in
> > memory.stat.
>
>
> This is not just the memcg stats. NR_PAGETABLE is exposed in system-wide
> meminfo as well as per-node meminfo. Memcg infrastructure maintaining
> per-memcg (& per-node) NR_PAGETABLE stat should be transparent here.
> Please update your commit message.

Thanks for pointing this out! Updated in v2 patch series.

>
> BTW you are only updating the stats for x86. What about other archs?
> Also does those arch allocated pagetable memory from page allocator or
> kmem cache?
>

v2 patch series includes patches for other archs as well. Thanks!
