Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF53F64ACED
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 02:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiLMBSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 20:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234063AbiLMBSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 20:18:43 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB351C12E
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:18:41 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so1879773pjd.5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 17:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=65IDnHecXM4GAPku5HHW6zoqaWMBpSe6UVEVil1rUW8=;
        b=aCbTEC5zVQHMxXGUQTyU3DWgykcdtGQYX+TMVnYfhhivfYDwUdEI2A+rvhEs/NwsaF
         DBS7EUg/X3QUOeZSsBrnvtkOTybUx0UgHQfTJ3hA35ipZDaXqrdLdH18As7YVMN94+FU
         E0ZAjnBtiWq0DWCLJTMY1LLhx6oaO6nTa/LCKJnCfj9cvh92FEO+h9Fh1uCxf/eAl6iw
         7hyDu3aUhJ3UKrfyvsiyjGIexzmF9DmyPzjASetqH/jMJK8TS5INlchOlJfnBagkkznK
         3XYQb4be1caEftz1e2fA0GEffMBeGMtYKiW3GQDIe6ihjILD9JWzVjZUmCWBKLdW3ozR
         bQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=65IDnHecXM4GAPku5HHW6zoqaWMBpSe6UVEVil1rUW8=;
        b=gllt/CnIvLWRJTZOoc0Wkx1jAl5Q0DMl3k/f6w5jJ1GyA+SpSsBB72J+rhcVdsoqb5
         qh4ytY03EM1GA9+7LQ27BWypsb2eSnEMKS6wc4MBFvGkcHn6TRMY11v7KpBfjFVk8XXK
         9qsWf6qaZDBJ8wYfNKG2Xio44v/hx6hFj4Ed/obOXJ3szEWDoJasDeJfqN48Cea5xnKg
         v5GucDNyslSFWAoCiCYT6oaIzhyUdE/GcVFz6KqKKld79/x0H65igPKPHTAbcCsRvMPV
         zYQi0c0MjNe91xGLgo4FonegkQkfQ+50ZS9gT/3j863pp9xk91zuXu1M3pFc332nds8S
         HTYw==
X-Gm-Message-State: ANoB5pllVrZ7NXgJV1SZ5I+VzVUXl6DU5NSOOKh1yNTXA/78CPx7NEHr
        +fP/jZYN9qA7hCW2WZ1vqrLhKQ==
X-Google-Smtp-Source: AA0mqf5INLD3H26KoHZlGz+PIVih+odmnj70wLNIiESaeaUKfnuuF7xa7n6FGQnW8NJxdar9YAD0/g==
X-Received: by 2002:a05:6a20:2d21:b0:a4:9691:6e9 with SMTP id g33-20020a056a202d2100b000a4969106e9mr23637142pzl.1.1670894320396;
        Mon, 12 Dec 2022 17:18:40 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id r14-20020a63a54e000000b00460ea630c1bsm5762650pgu.46.2022.12.12.17.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 17:18:40 -0800 (PST)
Date:   Mon, 12 Dec 2022 17:18:35 -0800
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
Message-ID: <Y5fS69mLXlV+cQlg@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
 <01cb4882-7a06-176f-7d55-f80cca300ffd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

On Mon, Dec 12, 2022 at 11:50:29PM +0100, Paolo Bonzini wrote:
> On 12/12/22 18:39, Sean Christopherson wrote:
> > > The notion of address spaces is already existing architecture-neutral
> > > concept in KVM (e.g. see uses of KVM_ADDRESS_SPACE_NUM in
> > > virt/kvm/kvm_main.c), although SMM is the only use-case I'm aware of.
> > 
> > Yes, SMM is currently the only use-case.
> 
> It's possible that in the future Hyper-V VTLs will also have per-level
> protections.  It wouldn't use as_id, but it would likely be recorded in the
> upper byte of the role.
> 
> I'm not sure if Microsoft intends to port those to ARM as well.
> 
> > My preference would be to leave .smm in x86's page role
> 
> What about defining a byte of arch_role and a macro to build it?

Both would work. I went with as_id in the common role since that's how
it's encoded in kvm_memory_slot and because, not matter what, the TDP
MMU still has to handle multiple address spaces. i.e. Even if we hide
SMM away in the role, the TDP MMU still has to access it with some
wrapper e.g.  kvm_mmu_page_as_id() (that would just return 0 outside of
x86). From that perspective, just having as_id directly in the common
role seemed like the cleanest option.

The only way to truly shield the TDP MMU from SMM would be to disallow
it. e.g. Disable the TDP MMU if defined(CONFIG_KVM_SMM), or something
similar. But I don't know enough about how KVM SMM support is used to
say if that's even worth entertaining.
