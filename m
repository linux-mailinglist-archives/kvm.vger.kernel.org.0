Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC1964AD4A
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 02:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiLMBmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 20:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234239AbiLMBmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 20:42:16 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00681D660
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:42:14 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id f3so9471597pgc.2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=opT7QlxBkoYVHWKjfFWe+3FrtkzNsO2VihRNj3rgWn4=;
        b=SK1WTnhEcJ7vOVSL2xzzXtEkHtH43rxXSGW7Dtujo2q/jDMxxwle2K41T6LEOAbu31
         njuyn58rLHAdSISg9P623gyKYXFOPbX7pgjYFQq0nCNnpQM5nUBslElHcKrZV00WUweD
         2Ab6o7XW4eUWoa8IW7OXTpjK3c5JsXSeCBMBKd1ZVWft5A67PRSXDH8qkRexDCQaB9Yn
         RRx3hIYf+BW8rjptQ0hTe+UyiZNfb7Ry3StWfXGfsaNsXjMTMnyjPwgtlBcOWZ5bOvDK
         NYZEtjUykiKNojc+IPEX89P4N1KrKqPpyt3Z0lKnKRo6M5fuKnMpjzJMGm1TZAMuI+Yh
         G8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opT7QlxBkoYVHWKjfFWe+3FrtkzNsO2VihRNj3rgWn4=;
        b=Xh+XR7zavgNfdc3VOQNazCFYcWFTOeIlsITH0JcpsWYP+VWEtzvzRy35n4xUHAw+U7
         SqhcIs+cnbKDRL4rOX08avINuVhHTBVKQV4I4g0YeZJYaT+ooRrejNg6K88wEejSrDk/
         uQy5XhGuuZxQ/bXhRKpzgDpqjp/zF+HKKIvshJYtGfD3uT7WYh2TfidwjNuLIuimExVN
         eknr5l5LZwrSi8JGOmaAdtAo2y+yolFNhqY17R/jTJZKIeN2lbEHvP9RohBdDhc6tXqE
         A5/CgGstj08S0L6Dptig1M/CdGlv3/2SrsufdikTA9G9A21vfl0cKj1j5Jpx/E9yssD6
         dp1g==
X-Gm-Message-State: ANoB5pmCYLqSugQh55deeo7X2X3yaPT27kXUNCTLTaa8eml5QD4+mfRD
        HGB521NScBkus7aVID3kIjqlbA==
X-Google-Smtp-Source: AA0mqf4Ax5/VKVlxMD5DSzFDunN/IfJNpj08Gszf3tnTB/tljXojhITyTp9EJLu9yUUGsdwIrNP7Ng==
X-Received: by 2002:a62:160a:0:b0:576:22d7:fd9e with SMTP id 10-20020a62160a000000b0057622d7fd9emr72299pfw.0.1670895734011;
        Mon, 12 Dec 2022 17:42:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i134-20020a62878c000000b005761c4754e7sm6630376pfe.144.2022.12.12.17.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 17:42:13 -0800 (PST)
Date:   Tue, 13 Dec 2022 01:42:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        "Amit, Nadav" <namit@vmware.com>,
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
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Message-ID: <Y5fYcosbituc0kc4@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
 <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
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

On Mon, Dec 12, 2022, Paolo Bonzini wrote:
> On 12/12/22 18:39, Sean Christopherson wrote:
> > My preference would be to leave .smm in x86's page role
> 
> What about defining a byte of arch_role and a macro to build it?

I think David already carved out a big chunk for arch role bits, my objection
was purely to making as_id a generic 8-bit role.

> > Unless I'm missing something, e.g. a need to map GPAs differently for
> > SMM vs. non-SMM, SMM could have been implemented with a simple flag
> > in a memslot to mark the memslot as SMM-only.
> 
> Unfortunately not, because there can be another region (for example video
> RAM at 0A0000h) underneath SMRAM.

Ugh, it's even a very explicitly documented "feature".

  When compatible SMM space is enabled, SMM-mode CBO accesses to this range route
  to physical system DRAM at 00_000A_0h – 00_000B_FFFFh.
  
  Non-SMM mode CBO accesses to this range are considered to be to the Video Buffer
  Area as described above. PCI Express* and DMI originated cycles to SMM space are not
  supported and are considered to be to the Video Buffer Area.

I also forgot KVM supports SMBASE relocation :-(

> In fact, KVM_MEM_X86_SMRAM was the first idea.  It was uglier than multiple
> address spaces (https://lore.kernel.org/lkml/1431084034-8425-1-git-send-email-pbonzini@redhat.com).
> In retrospect there were probably ways to mix the best of the two designs,
> but it wasn't generic enough.
>
> > And separate address spaces become truly nasty if the CPU can access multiple
> > protected regions, e.g. if the CPU can access type X and type Y at the same time,
> > then there would need to be memslots for "regular", X, Y, and X+Y.
> 
> Without a usecase that's hard to say.  It's just as possible that there
> would be a natural hierarchy of levels.

Ah, true.
