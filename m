Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33BD673FAD
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 18:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjASROo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 12:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjASROn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 12:14:43 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB6481028
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:14:42 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id b12so2045686pgj.6
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 09:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h3m6FnRHon/ERdNuMp939FY03hOnkC/3DfqdGHHNZVo=;
        b=NZnk8qAovjYt9d3M1s9Ed5R/SzYS10fphjbMp0Qm9eEu2q/Ehkf3+pz3Iz8dY5jpD4
         EhYeMq2MoG4Y5XN2GnpybBkjybdFyqBtQNMk0vpZsEOPYopuFi4vyPQzqyMao6Djew1Z
         eEntn5yb8iXVqoEKyIYOUekjO8DVRF3fhgsoePHjhAFtDrtu5vQA41uLgLxEXem4eDHf
         6XWqtHPGos7auud7cSkHdJi/QRWsyfQ1XNpoIVyanUogFvJ9hrjTarqtF3+qwA7154E2
         3685e5v3o9QVK/UeKtvoIRQt7WJyRCSoLAzCMN0Mhw76RdScYb6VyS6nw81RWkgeu6p0
         XF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3m6FnRHon/ERdNuMp939FY03hOnkC/3DfqdGHHNZVo=;
        b=UVl5crp6Y25pt+V04fnmMHA+ibE2D+CxE/xxKmO3EGG4dAE2LUsok3xPCdlc6Vzpwu
         qrF/LhL3a+o9GsJAqKQvmVDkZIE01gRnJ8eXbE1IXpwMMNV2YAyY+y190e0WJ9v5iP23
         wjhI/ATq52+GHYV9Sz72b/RdrSbLIUS69RhpxNALRozJRz83E1jGu7EPuIxl8+Cfe4PT
         Hk0edMfU+9plIUdtQT20AVjQm/W14/atuMfvXSiDi0k3K25ZXh9hIeKZp6NBE9E1rJl4
         ox31e+uy4GD5cWBFZkhtuJBGWrDzzerh9PcdkiHx7L9FpgV964doEOzSRFcQkn+f7Uo7
         69QQ==
X-Gm-Message-State: AFqh2kpW6OHwMvzkVPzj6XLggn/3x7QQkZATpQdDRI/kcvjDf2tbLBqX
        q+AYimzNg3hLDcqZsy1q2MimjA==
X-Google-Smtp-Source: AMrXdXuzV1QqiuKjtYWMTtGC8EBn/MaadWuvHkkuJ9ZASZGXOhkdhowXaNHl2xYH7k1qU1kPQqtwDA==
X-Received: by 2002:a05:6a00:1c84:b0:581:4260:a650 with SMTP id y4-20020a056a001c8400b005814260a650mr10769799pfw.33.1674148481271;
        Thu, 19 Jan 2023 09:14:41 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id b20-20020aa79514000000b0058d91fb2239sm9246817pfp.63.2023.01.19.09.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 09:14:40 -0800 (PST)
Date:   Thu, 19 Jan 2023 09:14:34 -0800
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
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
        Sean Christopherson <seanjc@google.com>,
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
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH 00/37] KVM: Refactor the KVM/x86 TDP MMU into common
 code
Message-ID: <Y8l6egh2wWN7BUlZ@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
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

On Thu, Dec 08, 2022 at 11:38:20AM -0800, David Matlack wrote:
> 
> Hello,
> 
> This series refactors the KVM/x86 "TDP MMU" into common code. This is
> the first step toward sharing TDP (aka Stage-2) page table management
> code across architectures that support KVM.

Thank you everyone for the feedback on this RFC. I have a couple of
updates to share and a question at the end.

First, Alexandre Ghiti from Rivos is going to work on the RISC-V port.
I'd like to target RISC-V first, since it has significantly lower risk
and complexity than e.g. ARM (which has pKVM, stage-1 walkers, and
[soon] nested virtualization to deal with).

Before I send a v2 I am working on sending several related patches.
These are patches that should have enough justification to be merged
regardless of the fate of the Common MMU. By sending them out
separately, I figure they will be easier to review, allow me to make
incremental progress, and ultimately simplify the v2 of this series.

What I've sent so far:

 - https://lore.kernel.org/kvm/20230117222707.3949974-1-dmatlack@google.com/
 - https://lore.kernel.org/kvm/20230118175300.790835-1-dmatlack@google.com/

What's coming soon:

 - A series to add a common API for range-based TLB flushing (patches
   29-33 from this series, plus another cleanup). This cleanup stands on
   its own, plus Raghavendra from Google has need of this for his ARM
   series to add range-based TLBI support [1]

 - A patch to move sp->tdp_mmu_page into sp->role.tdp_mmu. This was
   suggested by Paolo as an alternative to patch 4, and saves a byte
   from struct kvm_mmu_page.

There will probably be more related cleanups I will send but this is
everything I'm tracking so far. If anyone wants to see a complete v2
sooner, let me know.

Paolo and Sean, what are your thoughts on merging the Common MMU
refactor without RISC-V support? e.g. Should Alexandre and I work on
developing a functional prototype first, or are you open to merging the
refactor and then building RISC-V support on top of that? My preference
is the latter so that there is a more stable base on which to build the
RISC-V support, we can make incremental progress, and keep everyone
upstream more involved in the development.

Thanks.

[2] https://lore.kernel.org/kvm/20230109215347.3119271-4-rananta@google.com/
