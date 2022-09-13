Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7235B6DD5
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbiIMM7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 08:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiIMM7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 08:59:01 -0400
Received: from out0-152.mail.aliyun.com (out0-152.mail.aliyun.com [140.205.0.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE9C41D20;
        Tue, 13 Sep 2022 05:58:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R981e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047211;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.PEZ9oUN_1663073913;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.PEZ9oUN_1663073913)
          by smtp.aliyun-inc.com;
          Tue, 13 Sep 2022 20:58:33 +0800
Date:   Tue, 13 Sep 2022 20:58:33 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] KVM: x86/mmu: Use 1 as the size of gfn range for
 tlb flushing in FNAME(invlpg)()
Message-ID: <20220913125833.GC113257@k08j02272.eu95sqa>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <8baa40dad8496abb2adb1096e0cf50dcc5f66802.1661331396.git.houwenlong.hwl@antgroup.com>
 <YxjXgERSNIk4ZaN+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxjXgERSNIk4ZaN+@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 01:40:16AM +0800, David Matlack wrote:
> On Wed, Aug 24, 2022 at 05:29:23PM +0800, Hou Wenlong wrote:
> > Only SP with PG_LEVLE_4K level could be unsync, so the size of gfn range
> > must be 1.
> > 
> > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > ---
> >  arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 04149c704d5b..486a3163b1e4 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -937,7 +937,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
> >  
> >  			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
> >  			if (is_shadow_present_pte(old_spte))
> > -				kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
> > +				kvm_flush_remote_tlbs_gfn(vcpu->kvm,
> > +					kvm_mmu_page_get_gfn(sp, sptep - sp->spt), 1);
> 
> The third argument to kvm_flush_remote_tlbs_gfn() is the level, not the
> number of pages. But that aside, I don't understand why this patch is
> necessary. kvm_flush_remote_tlbs_sptep() should already do the right
> thing.
>
Since only SP with PG_LEVEL_4K level could be unsync, so the level must
be PG_LEVEL_4K, then sp->role.level access could be dropped. However,
I'm not sure whether it is useful. I can drop it if it is useless.

> >  
> >  			if (!rmap_can_add(vcpu))
> >  				break;
> > -- 
> > 2.31.1
> > 
