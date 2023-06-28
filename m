Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074E87416EF
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjF1RFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 13:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjF1RFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 13:05:39 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7215A1BE4;
        Wed, 28 Jun 2023 10:05:38 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-666eb03457cso3394043b3a.1;
        Wed, 28 Jun 2023 10:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687971938; x=1690563938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jU0D3jztQr/atZmp0Mr2fgpDIGn4JXGFEn6H1cHgCp4=;
        b=NyCu/TdMfAvYkiVvTLQwSa/yIuSCWTLnlry0tgAPk03LDSY5ujX6BDmoZSrGOFR4L1
         M7DWsZN8iafbaGnRzvT/uxNwJN6XHjnVjNAFsGaiW6ToHnRiK8BmA7JEjJqjGenPLqH2
         AzCv2TqsR0gWeNj+bpeuBUZnmTC7MCBbkFEPA4fswffgOqg9yUz/IkZsJGdKCL0CGItq
         8Dq/Lnnfm/TXS2ZWtT1bP2ehUidF7Lmj+h5advee7o1xYDooK6XnS0F+CMIwiOyXUTmU
         vjFXfilhBJqjR4bB5OevYPH8kuXykhwzHTubuVke29OD3s7JIUkibEUku1SpTPQMsQx9
         DCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687971938; x=1690563938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jU0D3jztQr/atZmp0Mr2fgpDIGn4JXGFEn6H1cHgCp4=;
        b=W85EZj47vRV9TEmFSjtUR0unAYVspQhfuGksckqjkushMhf2S5i+tFkLYXibGsCd5h
         /CaX/QRm2ZtYi9upqsOO+I5pauTZ6CkCgoTEKsdCICXxEF5092i1+nQSs6yQiR78gbnY
         BnBUfRWcKXG6timEMthEvzbFbBlQ0JKCV/wZWJVhrsgr2x+iSf5KIpbKIElE214gWtsK
         if6xQBpoh+V9SgWVeQdwftUK8vtIrQA8LaqXE3c9UCDTz09PYp5RZPA3xjLNDA+QNZED
         HZr/sRAjhfaqLJLcv7M9fzvwmPIVaBecTy3NuX7hylHNsIS6u/ug7M1qrfclVVGw8H2g
         emJA==
X-Gm-Message-State: AC+VfDwQz9yxCaA/Gy0d+QM78IavAHFcby8XnV8kK3489UjhSwWVC8pJ
        wuU72JI1x+y1BgUrOw0Xmpc=
X-Google-Smtp-Source: ACHHUZ5hV65eaKopW0K70HcSN9zamVCK+9R3I3nJG6hYTsDd+b5tJ9Zsfntbl1NDSUsBFPtzCbcXrw==
X-Received: by 2002:a05:6a21:3392:b0:123:7989:ba55 with SMTP id yy18-20020a056a21339200b001237989ba55mr18930270pzb.41.1687971937707;
        Wed, 28 Jun 2023 10:05:37 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id q136-20020a632a8e000000b0055b0c330b30sm3036053pgq.84.2023.06.28.10.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 10:05:37 -0700 (PDT)
Date:   Wed, 28 Jun 2023 10:05:36 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [RFC PATCH v2 5/6] KVM: Add flags to struct kvm_gfn_range
Message-ID: <20230628170536.GF3436214@ls.amr.corp.intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
 <689da77417c2f4055f02a71aab51ff603bc195af.1687474039.git.isaku.yamahata@intel.com>
 <20230628152132.xyfquj67vhklsvlu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230628152132.xyfquj67vhklsvlu@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 10:21:32AM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> On Thu, Jun 22, 2023 at 04:16:29PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add flags to strut kvm_gfn_range to indicate who triggered the callback
> > and new memory attributes.
> > 
> > TDX needs to know the reason for a callback by kvm_unmap_gfn_range().  mmu
> > notifier, set memory attributes ioctl or KVM gmem callback.  With TDX,
> > zapping a private page from the encrypted page table and adding the page
> > back to the same private GPA results in zeroing the page, and the guest has
> > to accept the page again.  On the change of memory attribute from private
> > to shared, zapping the GPA range irrespective to private-or-shared and
> > expecting the fault doesn't work for TDX.  Instead, zap shared pages only
> > and keep the private pages.  Concretely
> > - If it's from mmu notifier, zap shared pages.
> > - If it's from KVM gmem, zap private pages.
> > - If setting memory attributes to private, zap shared pages.
> > - If setting memory attributes to shared, zap private pages.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > ---
> > Changes v1 -> v2:
> > - consolidate KVM_GFN_RANGE_FLAGS_GMEM_{PUNCH_HOLE, RELEASE} into
> >   KVM_GFN_RANGE_FLAGS_GMEM.
> > - Update the commit message to describe TDX more.  Drop SEV_SNP.
> > ---
> >  include/linux/kvm_host.h | 10 +++++++++-
> >  virt/kvm/guest_mem.c     |  9 ++++++---
> >  virt/kvm/kvm_main.c      |  4 +++-
> >  3 files changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 1a47cedae8a1..1fe0516fcddf 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -256,12 +256,20 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
> >  #endif
> >  
> >  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
> > +
> > +#define KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR	BIT(0)
> > +#define KVM_GFN_RANGE_FLAGS_GMEM		BIT(1)
> > +
> >  struct kvm_gfn_range {
> >  	struct kvm_memory_slot *slot;
> >  	gfn_t start;
> >  	gfn_t end;
> > -	pte_t pte;
> > +	union {
> > +		pte_t pte;
> > +		u64 attrs;
> > +	};
> >  	bool may_block;
> > +	unsigned int flags;
> >  };
> >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
> >  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> > diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> > index cdf2d84683c8..387226136960 100644
> > --- a/virt/kvm/guest_mem.c
> > +++ b/virt/kvm/guest_mem.c
> > @@ -99,7 +99,8 @@ static struct folio *kvm_gmem_get_folio(struct file *file, pgoff_t index)
> >  }
> >  
> >  static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
> > -				      pgoff_t start, pgoff_t end)
> > +				      pgoff_t start, pgoff_t end,
> > +				      unsigned int flags)
> >  {
> >  	struct kvm_memory_slot *slot;
> >  	unsigned long index;
> > @@ -118,6 +119,7 @@ static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
> >  			.slot = slot,
> >  			.pte = __pte(0),
> >  			.may_block = true,
> > +			.flags = flags,
> >  		};
> >  
> >  		kvm_mmu_invalidate_range_add(kvm, gfn_range.start, gfn_range.end);
> > @@ -156,7 +158,8 @@ static long kvm_gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
> >  	 */
> >  	filemap_invalidate_lock(file->f_mapping);
> >  
> > -	kvm_gmem_invalidate_begin(kvm, gmem, start, end);
> > +	kvm_gmem_invalidate_begin(kvm, gmem, start, end,
> > +				  KVM_GFN_RANGE_FLAGS_GMEM);
> 
> Do you anticipate ever needing to pass a different flag via
> kvm_gmem_invalidate_begin()? If not it might make sense to just
> hard-code it rather than passing as a parameter.

I'll update this patch following the suggestion by Sean. [1]
I'll drop the flag. the struct kvm_gfn_range will be

struct kvm_gfn_range {
 struct kvm_memory_slot *slot;
 gfn_t start;
 gfn_t end;
 union {
  struct test_clear_young_metadata *metadata;
  unsigned long attributes;
  pte_t pte;
  unsigned long callback_arg; /* needs a better name */
 };
 bool only_private;
 bool only_shared;
 bool may_block;
};


[1] https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com/
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
