Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1689B64ACB9
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 02:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiLMBCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 20:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbiLMBCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 20:02:12 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930BA1115
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:02:11 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d15so4315963pls.6
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6GqFhoQ5IFUAK9oX1MHOecDUK0USc3JCTx3X8yerj1o=;
        b=FtjwIkrUOBV2twjG7aSDbbD70cPG5TPStSgDCsNV45Bhmz74eNy+ozucvejg73x4O1
         Iohs4s0dpsdVjim7W9yTFCi/EcSDg8iCwzhlHWz1fotOSARecFpPQ4Hcfa3qQYCWl4fD
         i1NYMRChruL7+5L6pSJLJXVhu8QmidC5EEUqHA/lI7bch3t3TIv1aCN57q4l7rtPFYua
         FlWlimYfUfUgVCukMvVJuuDDKaWduMb0REZn22mFV2kYcjkEnorPqV83jL7/8bj0vUDj
         SOGbsMyi3efvpD/4Q6/fjpBXN88wAA6q87W5qjPxSb+fHE/weIam6vo+2qT/aO85DhR1
         U6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GqFhoQ5IFUAK9oX1MHOecDUK0USc3JCTx3X8yerj1o=;
        b=yadPrqR8kQCMM0uZ1IWffaogWDE/LYO3sfYfzOPpl9izfdD9RTtZ08xRbBMSUJBaQP
         GxlqOGRce3wGf0+LQ+C3RsQX5IW8+QTrBMpafhpK29fLKm+M5mw66M3SXh8aJ9zuvMhq
         kPQ7iW+EERpntMQtmHvJ2nM2lGXN8KStnD6FHRpGsAepspPjWcYrt47jckaT4huWHRkb
         bUR2zpRp04BGGg+eIrpMYscQtspBvqrTr5s3B8LpfD3mLl9DkuLQaHo7FMeLpX0e2fTu
         6uYO8oBK8yohYvvzziuBeFBIFMcuB/aHTfXoBbwpxorDm+FjIYTFyItwx2KOafSoBKpd
         Qubg==
X-Gm-Message-State: ANoB5pkG/qrgbuVrTbDajFwIpIctiHYHmE52ufa9Bv1bMibh4nqSKZrz
        3qdJFrH2S8n/LYJ7v8xvymNPCA==
X-Google-Smtp-Source: AA0mqf6YEPI+D/p+C5vB/eTbMi0DUTnPh+gMPudwZTqoN9JqStWe3ScZcQMFez7S1hpnK/27SYk6nw==
X-Received: by 2002:a17:90b:394b:b0:218:7bf2:4ff2 with SMTP id oe11-20020a17090b394b00b002187bf24ff2mr62913pjb.0.1670893330943;
        Mon, 12 Dec 2022 17:02:10 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n15-20020a170903110f00b00186bc66d2cbsm7066219plh.73.2022.12.12.17.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 17:02:10 -0800 (PST)
Date:   Tue, 13 Dec 2022 01:02:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Subject: Re: [RFC PATCH 20/37] KVM: x86/mmu: Abstract away computing the max
 mapping level
Message-ID: <Y5fPDqI7TBngeaj8@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-21-dmatlack@google.com>
 <CANgfPd-6LNdZ42tb0DnC21r1Z5JGR_1Lvvop8RKJJ8hEz+PUDg@mail.gmail.com>
 <CALzav=cashgJPmeKSRQnd_kdYg2EK0G4rygSCt6GaJWSYz3juw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cashgJPmeKSRQnd_kdYg2EK0G4rygSCt6GaJWSYz3juw@mail.gmail.com>
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

On Mon, Dec 12, 2022, David Matlack wrote:
> On Mon, Dec 12, 2022 at 11:32 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
> > >
> > > Abstract away kvm_mmu_max_mapping_level(), which is an x86-specific
> > > function for computing the max level that a given GFN can be mapped in
> > > KVM's page tables. This will be used in a future commit to enable moving
> > > the TDP MMU to common code.
> > >
> > > Provide a default implementation for non-x86 architectures that just
> > > returns the max level. This will result in more zapping than necessary
> > > when disabling dirty logging (i.e. less than optimal performance) but no
> > > correctness issues.
> >
> > Apologies if you already implemented it in a later patch in this
> > series, but would it not at least be possible to port
> > host_pfn_mapping_level to common code and check that?
> > I'm assuming, though I could be wrong, that all archs map GFNs with at
> > most a host page table granularity mapping.
> > I suppose that doesn't strictly need to be included in this series,
> > but it would be worth addressing in the commit description.
> 
> It's not implemented later in this series, but I agree it's something
> we should do. In fact, it's worth doing regardless of this series as a
> way to share more code across architectures (e.g. KVM/ARM has it's own
> version in arch/arm64/kvm/mmu.c:get_user_mapping_size()).

Ya, ARM converted to walking the host user page tables largely in response to
x86's conversion.  After x86 switched, ARM was left holding the bag that was
PageTransCompoundMap().

On a related topic, I'm guessing all the comments in transparent_hugepage_adjust()
about the code working _only_ for THP are stale.  Unless ARM support for HugeTLB
works differently, walking host user page tables should Just Work for all hugepage
types.
