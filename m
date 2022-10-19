Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB87A60542F
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 01:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJSXrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 19:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiJSXrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 19:47:41 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84603172519
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:47:39 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e129so17672933pgc.9
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SMev/lW9fUqeyWhlXOgZuXyCWdyrzKCQD/McomQJ1RA=;
        b=MbpsrN3VudRVHu0Gcx/JefnYoDsxETXGIEIlP76Fk2/9MaHQ5VzkUu0KmaEAJaEOLn
         s1OZDBSarbltkUO3NufRfQQs7rv76vydj6cxIxCK2MV4RqaDr7tjEIfGbX0CqYuPkIxs
         qzkopkWXQYJ7+Cgh+46XvoGlunBB7B3NQEL9ymCbDbdKMbJwfllvxqGRmxkRC8+4SeSv
         HMgyrKynwN2JMyOLDqgh6dv8ZlI7E4gq0/9gJD2wW7dfmyQy57mngHv3/d2aQ7OWZSr9
         sMx8oKKfHtNft9k9ja9zO3bCxFQ1IWsTq1QHCrEN3D6WFfPSBPL7vvJ56Onulo/O+bBi
         u73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMev/lW9fUqeyWhlXOgZuXyCWdyrzKCQD/McomQJ1RA=;
        b=6NMnlPtbyVlwUli/WciLCvT/Apmbbfl56p0i4UheGy9ruLRdcr07Elv/8B7UowJ63Z
         dPfyN/KWKbLWN4/oSq8t9FsW+CRs6tcKvbftNybZqt10Xni76j4ajK3coBmIXTdBlB63
         ePgdaLjatUowA/pKEiJJoE4/8+48tQxPwyBEgMuPEyI4aslfnAu94m0WTX4YlpX9+AdY
         ATm2Q946zxuAZ86l619galZFZNOiUfHLnN1Uhdz87Ld9FYcFFTre7MCap5DnHLDbynOA
         ncQVug29ijfm3N3xhkEFcc1bOET9uRb5Y3EoWrgf+QRjRIVrYSrmotlP/ytuJzu/4i9X
         HqzA==
X-Gm-Message-State: ACrzQf0RabVubDeqfVhrXF3QoNXACIpav5JjZMFaKj50Bjy/iU8Ae1Mg
        p7cMRO0YkFS9kjWaq/d/ZnAQow==
X-Google-Smtp-Source: AMsMyM62+iL+OA9RwIZDPmQbjrTbDqZbvXHqo7Kkj0k3+p7svo0gNo/pc+9H6Mb/jHd7JFB7WnS0nQ==
X-Received: by 2002:a63:1e05:0:b0:451:31d0:8c0f with SMTP id e5-20020a631e05000000b0045131d08c0fmr9324222pge.227.1666223259315;
        Wed, 19 Oct 2022 16:47:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c28-20020aa7953c000000b0053725e331a1sm11889654pfp.82.2022.10.19.16.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:47:38 -0700 (PDT)
Date:   Wed, 19 Oct 2022 23:47:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v10 00/14] KVM: selftests: Add aarch64/page_fault_test
Message-ID: <Y1CMl3pkulxyjbfw@google.com>
References: <20221017195834.2295901-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022, Ricardo Koller wrote:
> This series adds a new aarch64 selftest for testing stage 2 fault handling
> for various combinations of guest accesses (e.g., write, S1PTW), backing
> sources (e.g., anon), and types of faults (e.g., read on hugetlbfs with a
> hole, write on a readonly memslot). Each test tries a different combination
> and then checks that the access results in the right behavior (e.g., uffd
> faults with the right address and write/read flag). Some interesting
> combinations are:

...

> Ricardo Koller (14):
>   KVM: selftests: Add a userfaultfd library
>   KVM: selftests: aarch64: Add virt_get_pte_hva() library function
>   KVM: selftests: Add missing close and munmap in
>     __vm_mem_region_delete()
>   KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
>     macros
>   tools: Copy bitfield.h from the kernel sources
>   KVM: selftests: Stash backing_src_type in struct userspace_mem_region
>   KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
>   KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and
>     vm_vaddr_alloc()
>   KVM: selftests: Use the right memslot for code, page-tables, and data
>     allocations
>   KVM: selftests: aarch64: Add aarch64/page_fault_test
>   KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
>   KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
>   KVM: selftests: aarch64: Add readonly memslot tests into
>     page_fault_test
>   KVM: selftests: aarch64: Add mix of tests into page_fault_test

One alignment nit in the first patch, but definitely not worthy of a v11.  If it
gets fixed up when applying, yay.  If not, no big deal.
