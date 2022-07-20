Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A3B57BDB6
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 20:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiGTS0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 14:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiGTS0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 14:26:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E71F220F3
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 11:26:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEC406173C
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 18:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BF8C3411E;
        Wed, 20 Jul 2022 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658341589;
        bh=1yszCxwggYM4jJ5bah2lLB5C4oXcdYdLEA0qjz82pAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oR4ERFNR2+UVNBGGeoTFnTaaCoPW3ezYofdRY1WsECL0Og0X17PdO1j0IAic6PNq5
         lJXxMQwcuoogN6wkbeKDDAQuLpOsE+SZ4tFcT3te+BcQgJhc6wHJTogCdJZo9nKUJk
         FW9C8rCPvo7x8jejTULVSWM1gaVZn0q26kV8aU4T7Z66BeV8CSNP6cUtus08KsLEgu
         MlPCJ3a0VNYYRuJ047pHFQ8xUWMY01bSxut7tt6Pzi0uCX+M5v6GeYfmW+U6rVC2NV
         lsb8AY9f93HbEauX8FpWAvrwXY9hkNj3Kbyuu0ip4sdoTQFLFlNCSf6ovWVFx0Fvce
         aiqLRl8JfZIcQ==
Date:   Wed, 20 Jul 2022 19:26:22 +0100
From:   Will Deacon <will@kernel.org>
To:     Vincent Donnefort <vdonnefort@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 18/24] KVM: arm64: Instantiate guest stage-2
 page-tables at EL2
Message-ID: <20220720182621.GC16603@willie-the-truck>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-19-will@kernel.org>
 <YtayYuo2qBplXcdi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtayYuo2qBplXcdi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 19, 2022 at 02:32:18PM +0100, Vincent Donnefort wrote:
> [...]
> 
> >  }
> >  
> >  void reclaim_guest_pages(struct kvm_shadow_vm *vm)
> >  {
> > -	unsigned long nr_pages;
> > +	unsigned long nr_pages, pfn;
> >  
> >  	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
> > -	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
> > +	pfn = hyp_virt_to_pfn(vm->pgt.pgd);
> > +
> > +	guest_lock_component(vm);
> > +	kvm_pgtable_stage2_destroy(&vm->pgt);
> > +	vm->kvm.arch.mmu.pgd_phys = 0ULL;
> > +	guest_unlock_component(vm);
> > +
> > +	WARN_ON(__pkvm_hyp_donate_host(pfn, nr_pages));
> >  }
> 
> The pfn introduction being removed in a subsequent patch, this is probably
> unecessary noise.

Quite right, that should be left as-is. Will fix.

Will
