Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545E55394C5
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 18:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiEaQPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 12:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346026AbiEaQPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 12:15:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F345F95DDA
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 09:15:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BFF6B81232
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 16:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CE2C385A9;
        Tue, 31 May 2022 16:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654013713;
        bh=ztvgCS8fRDKevpyO8kfxRzUmJyQtb9CbHw0LvkPe3z8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EwU9SA3Q0QwHRGV/O1ph9cWHDdnUrAclRMUVedLVhrPRlzuhpbrCVpq2LuZWeeajM
         CbM8hAQolPve4NGkntUaQOi4m3C0XGqZyF1+QJH52J90VAn8kbYe7uqgIBbqNnzAVT
         cVNU1lg0Dzj3RFeIahW5Wuc/qvyu3gVX5G9zLRgJd/G4WI3eXAvkP+5NlJgJ0j7D26
         ecPxdX00ITbttgrprGLmTJHKCNnLw818ybiWYvoY00dfyF3KToimQqt9fBE5UMGNm5
         whrex7z71U3f1kuqGbuWyIgu8DOwFZmFKA4W/Tl1LvpKyAGvIsz/J1MtLb2CUSqVKV
         vk732sDM0cgwQ==
Date:   Tue, 31 May 2022 17:15:06 +0100
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/89] KVM: arm64: Return error from kvm_arch_init_vm()
 on allocation failure
Message-ID: <20220531161505.GD25502@willie-the-truck>
References: <20220519134204.5379-1-will@kernel.org>
 <20220519134204.5379-4-will@kernel.org>
 <Yoe6BxKzJPIaZ+pk@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yoe6BxKzJPIaZ+pk@monolith.localdoman>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 04:55:51PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, May 19, 2022 at 02:40:38PM +0100, Will Deacon wrote:
> > If we fail to allocate the 'supported_cpus' cpumask in kvm_arch_init_vm()
> > then be sure to return -ENOMEM instead of success (0) on the failure
> > path.
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/arm.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 523bc934fe2f..775b52871b51 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -146,8 +146,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >  	if (ret)
> >  		goto out_free_stage2_pgd;
> >  
> > -	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL))
> > +	if (!zalloc_cpumask_var(&kvm->arch.supported_cpus, GFP_KERNEL)) {
> > +		ret = -ENOMEM;
> >  		goto out_free_stage2_pgd;
> > +	}
> >  	cpumask_copy(kvm->arch.supported_cpus, cpu_possible_mask);
> >  
> >  	kvm_vgic_early_init(kvm);
> 
> Thank you for the fix:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks!

> This can go in independent of the series. I can send it after rc1 if you
> prefer to focus on something else.

Cheers, but I reckon I'll post the first 6 patches as their own series at
-rc1 anyway.

Will
