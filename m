Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD43A5B34C4
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiIIKCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIIKCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:02:16 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DDB23162
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:02:15 -0700 (PDT)
Date:   Fri, 9 Sep 2022 11:01:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662717734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y+xjoGI2hXYxhtWycnHQ5wVfTyWAv6wxDKxQfifkzGE=;
        b=H/eWJT/R1Z4XEOiJ5IipKnqK4w0Ktqh9UISGSPXNj4o6TG6DnAmSkeLdTgLE79dKj1gQCu
        QLDEro/hUuZC1g8Dj3bLWkAk+UtkuFp+0JS67sUFtN8+3FZYI4/23LyMd6z/5Aiu+XWExY
        qHZcFWGLtK4ubaxK54AHX0RuMNini74=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [PATCH 00/14] KVM: arm64: Parallel stage-2 fault handling
Message-ID: <YxsPFltAMvls/A9n@google.com>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
 <87o7vsvn4m.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7vsvn4m.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Tue, Sep 06, 2022 at 11:00:09AM +0100, Marc Zyngier wrote:

[...]

> This fails to build on -rc4:
> 
>   MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   CC      .vmlinux.export.o
>   LD      .tmp_vmlinux.kallsyms1
> ld: Unexpected GOT/PLT entries detected!
> ld: Unexpected run-time procedure linkages detected!
> ld: ID map text too big or misaligned
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_walk':
> (.hyp.text+0xdc0c): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xdc1c): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_get_leaf':
> (.hyp.text+0xdc80): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xdc90): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_hyp_map':
> (.hyp.text+0xddb0): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xddc0): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_hyp_unmap':
> (.hyp.text+0xde44): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xde50): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_hyp_destroy':
> (.hyp.text+0xdf40): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xdf50): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_map':
> (.hyp.text+0xe16c): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe17c): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_set_owner':
> (.hyp.text+0xe264): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe274): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_unmap':
> (.hyp.text+0xe2d4): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe2e4): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_flush':
> (.hyp.text+0xe5b4): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe5c4): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function `__kvm_nvhe_kvm_pgtable_stage2_destroy':
> (.hyp.text+0xe6f0): undefined reference to `__kvm_nvhe___rcu_read_lock'
> ld: (.hyp.text+0xe700): undefined reference to `__kvm_nvhe___rcu_read_unlock'
> make[3]: *** [Makefile:1169: vmlinux] Error 1
> make[2]: *** [debian/rules:7: build-arch] Error 2
> 
> as this drags the RCU read-lock into EL2, and that's not going to
> work... The following fixes it, but I wonder how you tested it.

Ugh. I was carrying a patch on top of my series to handle compilation
issues with rseq_test, I managed to squash the equivalent of below in
that patch.

Nonetheless, I *did* actually test it to get the numbers above :)

--
Thanks,
Oliver

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index dc839db86a1a..adf170122daf 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -580,7 +580,7 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
>   */
>  enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
>  
> -#if defined(__KVM_NVHE_HYPERVISOR___)
> +#if defined(__KVM_NVHE_HYPERVISOR__)
>  
>  static inline void kvm_pgtable_walk_begin(void) {}
>  static inline void kvm_pgtable_walk_end(void) {}
> 
> -- 
> Without deviation from the norm, progress is not possible.
