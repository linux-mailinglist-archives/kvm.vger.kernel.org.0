Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E2D662F97
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 19:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbjAIS4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 13:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbjAIS4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 13:56:14 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF171408F
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 10:56:12 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id e76so9429385ybh.11
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 10:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=npK1pVWS9Y7zSvO0nWYdwcAA7TbeGlnyEckY5HPb/Qg=;
        b=EHKm0/F2buMoOsKhjWg0lWsOuJldy/zfoO9SoYjwOUBjEtYFI7vDu+I5lwSpjMbW6Z
         3ObtFaGnVjmdcg2O2Aret0FZO2bn7yqTJbEhANZLCO7TmNFgRBE+1H+8TwiSfzm06+sv
         NoXn+BRIUqVauOHPZ13p93njC8trw+pKMvKGKG+JOay5G96uMzNCvp6yocnoligPU/KG
         nsT5KAmMgHERAldXeigMGDd8xVH2mvsfpS/FV/+f0V+6HxueWNzcx2CaGaqz8pAq/Qe/
         1IhIl/jFSe8NXCzMDt2iiVq0nAJOXzbL0gSR4VpeaFp+Z0f01ufRbR7OxltlcKWyJfdN
         GLKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=npK1pVWS9Y7zSvO0nWYdwcAA7TbeGlnyEckY5HPb/Qg=;
        b=VqA6kEBAqhtwzGVWVc/ZgkTEXuxjIEABPzwVIG3ToQbC2LqpIBwKXsJ2np/udD7oH6
         79MLYk+G+mEN7RlWVtErB99dQ86DYhsF2jICNSdd/KxYElGCMrpIp5mz6aAGAIQy4u+D
         IbXdg6Vi93eA+E1/zPeFzvVJ4ZL+EQNAA4gaipYOnS62BJ20hK5bsSP36al8gqE5MARe
         Fxz4yrpJsE9n5NlsmwbQqhI0Vgxv/VWloFdh+6qK9OxUew72ebHqBb1WD9f7JDhcjU3C
         5Qb+PQZrGn2fC7bCj477iD+JMKhqPksZnvp1QsiQ9X9FHU6sQxH0iJDv1RSiBz3iq9St
         qJKw==
X-Gm-Message-State: AFqh2komxvr2a5dufKq7cHAoPsAHmeCBLHtMaHFXp75btYPZyJ48amgD
        eiXBfe/TvoZM7x3ox33z/gG2Z7f4GSnAbxyRlzPYyQ==
X-Google-Smtp-Source: AMrXdXuGuwlSiliqUzNPwuP95duqjm2wzwipEY34JM0d62JWS00zM7bbMqGhGQDGetcNhy7upYl68Cx0Wdx6BZEJfKU=
X-Received: by 2002:a5b:1c8:0:b0:6fe:46c9:7479 with SMTP id
 f8-20020a5b01c8000000b006fe46c97479mr7514517ybp.191.1673290571936; Mon, 09
 Jan 2023 10:56:11 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-11-dmatlack@google.com>
 <ce1ea196-d854-18bd-0e60-91985ed5aaea@redhat.com>
In-Reply-To: <ce1ea196-d854-18bd-0e60-91985ed5aaea@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 Jan 2023 10:55:45 -0800
Message-ID: <CALzav=fVbvKQMhSBD0AdrRTH+jDyRG0Hf5M-H7vCtRCR1Lk9sw@mail.gmail.com>
Subject: Re: [RFC PATCH 10/37] KVM: MMU: Move struct kvm_page_fault to common code
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
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Dec 12, 2022 at 2:27 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/8/22 20:38, David Matlack wrote:
> > +
> > +     /* Derived from mmu and global state.  */
> > +     const bool is_tdp;
>
> I think this could stay in the architecture-independent part.

I agree but until there's a use case for accessing it in common code
I'm inclined to leave it in x86's kvm_page_fault_arch.
