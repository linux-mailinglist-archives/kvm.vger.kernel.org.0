Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE0B50346B
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 08:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiDPG0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Apr 2022 02:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiDPG0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Apr 2022 02:26:24 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB42CC74B9
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 23:23:53 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id b5so5871276ile.0
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 23:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7kGQzOanbVYOn3E2/I6eHWRNeF8kbJWDccGBZinYNyA=;
        b=rBmeWm6Xh+wdDYz5RPh2Ezh8mTuDrZ8Mz6yu3hX/xrzi0KrXHeGg5fQOMpAcGwa7XQ
         D/4DlrKL0TuDE5GPF55FXnCOyyrejef3SexMyLDkah+mHcvIDOEHVuh8yoy1yWkYOdC9
         DGFvbrGMS4cskIXRvDRG6GlMHXumEloo72d4GtrD2uGABdHkVhp+QwE/6eJD38UGyqfR
         cNJAEP2KkCUZw0LySL/SZ3vwN9c7hwog2Diek3Mo+I+DATDBG2ZKCIfvSU7iK0Mz878m
         9Xr5nh9E42A0lzxvShmg6W4DNDINRq2eEzdxbhoC2SuxZD4WO520ggYTJmAswNKS/F4b
         STzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7kGQzOanbVYOn3E2/I6eHWRNeF8kbJWDccGBZinYNyA=;
        b=lEALbA8Xr0gGA53vtTrQmbBCE3w9V5c9PbeA3zVaxkvhYBh7F/cIhFEcEVSXzq8qu3
         HbVi4vFU4dvdhUgQMHgfNNcB6dgTh3AxWltWrV9gmBX74Psiz4FCd8kgYyk55rdOcoZ2
         mkBluba/ZVguqCjgv45R/OkQ5in7eEuVufPryHpYXBbLxVmMGEQQ8af4Tj0gE8QZhZo9
         UCR7FlogZ90PUpTf63T8IXB8caeTjGw8DkMjiB8F0jDc82EeoR1ZFZadfpVi3HGPF3/W
         peQP9LooNagemkm2zaXnzZUyuukAA6UHbteytC4r81o2T2aY1f8TwFVMvNlmYYKwfc4w
         MDow==
X-Gm-Message-State: AOAM531QN7X8RBKreeemAX6daWQfiFdoIedYQPU/T/sE7IKAU4SNy7XC
        TT2ffpFmBdnWa4E+h4YHCflcGg==
X-Google-Smtp-Source: ABdhPJx4jhYq1M16sthiEkXqSurfMvFzfqy3CGbYFohSNEFKufgt1T3p0m6z4tUXcXTYLx8II2g5Zw==
X-Received: by 2002:a05:6e02:1d85:b0:2cb:fa5e:73fa with SMTP id h5-20020a056e021d8500b002cbfa5e73famr861577ila.294.1650090233095;
        Fri, 15 Apr 2022 23:23:53 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id y4-20020a92d204000000b002ca9d47d5d0sm3814128ily.20.2022.04.15.23.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 23:23:50 -0700 (PDT)
Date:   Sat, 16 Apr 2022 06:23:46 +0000
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
Message-ID: <Ylpg8l0BDlNpDWjs@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
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

On Fri, Apr 15, 2022 at 09:58:44PM +0000, Oliver Upton wrote:

[...]

> 
> Smoke tested with KVM selftests + kvm_page_table_test w/ 2M hugetlb to
> exercise the table pruning code. Haven't done anything beyond this,
> sending as an RFC now to get eyes on the code.

Ok, got around to testing this thing a bit harder. Keep in mind that
permission faults at PAGE_SIZE granularity already go on the read side
of the lock. I used the dirty_log_perf_test with 4G/vCPU and anonymous
THP all the way up to 48 vCPUs. Here is the data as it compares to
5.18-rc2.

Dirty log time (split 2M -> 4K):

+-------+----------+-------------------+
| vCPUs | 5.18-rc2 | 5.18-rc2 + series |
+-------+----------+-------------------+
|     1 | 0.83s    | 0.85s             |
|     2 | 0.95s    | 1.07s             |
|     4 | 2.65s    | 1.13s             |
|     8 | 4.88s    | 1.33s             |
|    16 | 9.71s    | 1.73s             |
|    32 | 20.43s   | 3.99s             |
|    48 | 29.15s   | 6.28s             |
+-------+----------+-------------------+

The scaling of prefaulting pass looks better too (same config):

+-------+----------+-------------------+
| vCPUs | 5.18-rc2 | 5.18-rc2 + series |
+-------+----------+-------------------+
|     1 | 0.42s    | 0.18s             |
|     2 | 0.55s    | 0.19s             |
|     4 | 0.79s    | 0.27s             |
|     8 | 1.29s    | 0.35s             |
|    16 | 2.03s    | 0.53s             |
|    32 | 4.03s    | 1.01s             |
|    48 | 6.10s    | 1.51s             |
+-------+----------+-------------------+

--
Thanks,
Oliver
