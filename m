Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B627A55D243
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbiF0QWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 12:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239145AbiF0QWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 12:22:51 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CE5D86
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:22:50 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id m14so8626117plg.5
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 09:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cV3hVzy9TYCqPFueATEq37SOh6vFTuLA/SrvAB62Xzg=;
        b=BseriqoiozT548bWf87kfEM21QE/lsC7Xh53iRBx2LmFdeNav386MocuZafko2ZdzZ
         JQe5ovxOhcstFhT8iCD21C825q81Za8C3tdgW13ebnSYPD7k8WHS3yPH0VHQSCGZnmQf
         FicGbHrtEuD0O3jI+Q4LIietAgpYwoWp5qedMxPLBADENHHnn+UkkXouxHyxDA/j0F9g
         moM6KAIDklQszHLohnncrg9SWHa8qDcecTbUS930nHP7JYFxSIbGRQKh+59wLE+AXy7E
         fCLhJT8SPzPCj5eph3yGYAVFqleuzS1aYTb4Me1axhRhNHXk+NS3u9/PAs9nbb1c6HO+
         fcfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cV3hVzy9TYCqPFueATEq37SOh6vFTuLA/SrvAB62Xzg=;
        b=xT1/cdUsEOqxgxUCX60UJ/7wZbFSE1OMQjpCDi1eB1OgJeS6Ym8GxlYQ6wHUOwIBRe
         HXczBMm7VDyiqXr1nTj0XBnG67/bSS/Y2PV3H+w5nMuXRRydpcqwWInuySOadlPKB3GC
         a9nhVzgHUaaf1lg+2SIG5j+/Hs12VB7puA4lsIaM3kFkULs36e/IqYzPPFncMMPIaNH1
         Ji6w/oKTjsT3Pr++8ZnbL1RVrgHr1RrNAWtBm4Nekudsgk6wmBH6WYL5MrSTATkigcoR
         2xghLB0AH/kmnYWZYlp2+Mu0e+NN/33MrhTnKDXNlPZ+7HB18JShgMsuyQ5q5TUEReei
         JgiA==
X-Gm-Message-State: AJIora/uelXmG/+iRKHrRZr6Eb3YEk+srcuApo45zfBk1Dg0FMHDDzG9
        8UyWEJ94r2VRKb4mgyzRYZP/Yg==
X-Google-Smtp-Source: AGRyM1v1/klo71FJcOnTZoW3zB85VLk+X/utjbZmu0W37du2cpFLJFufJZy1ShhykQNqxxTcsGcOvw==
X-Received: by 2002:a17:902:e54f:b0:16a:29de:9603 with SMTP id n15-20020a170902e54f00b0016a29de9603mr15741779plf.46.1656346970060;
        Mon, 27 Jun 2022 09:22:50 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id o14-20020a17090a4e8e00b001e2bd411079sm9752135pjh.20.2022.06.27.09.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 09:22:49 -0700 (PDT)
Date:   Mon, 27 Jun 2022 16:22:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
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
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v5 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Message-ID: <YrnZVgq1E/u1nYm0@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-4-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-4-yosryahmed@google.com>
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

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> Count the pages used by KVM mmu on x86 for in secondary pagetable stats.

"for in" is funky.  And it's worth providing a brief explanation of what the
secondary pagetable stats actually are.  "secondary" is confusingly close to
"second level pagetables", e.g. might be misconstrued as KVM counters for the
number of stage-2 / two-dimension paging page (TDP) tables.

Code looks good, though it needs a rebased on kvm/queue.
