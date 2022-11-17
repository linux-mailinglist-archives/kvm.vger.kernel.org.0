Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF2262E538
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 20:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240538AbiKQT06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 14:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiKQT05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 14:26:57 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0787579E2B;
        Thu, 17 Nov 2022 11:26:56 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id k2-20020a17090a4c8200b002187cce2f92so1102164pjh.2;
        Thu, 17 Nov 2022 11:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y71MJucuUf5PzoAmht6G11w2phAOT05/ACj/kjL1Fvg=;
        b=RWBqUf+9Q4ctah+HUiqbi9uD5rT/ypQMEjxar268uJaesdQBOMO15KeY31cpQrRyZb
         uZMKmE1JxzsO7rj4GR/6LfDYv7FVJ4Xmg440r3ZLHJuHu1aLmY+MQjDVR96vCO8ChgzY
         9FmeGlQipGv1ltH+d5xXVAMIHaOaAZRlNfX4DccXquLgq+EdJOgCxRENNIZHJausYF3E
         YkLCa1E4prcY+WfNKqKRCbvRHmrvV9sv5fa1q9n316jLIByqYvndE7hlQcCLpYDTmLW+
         tnPBb3sjxnhKpyZTh51lDuNHJ/Lnid+fO6TgZMC+8UKlZ4/D6PSDUDvH61zw5vN4t+kk
         RNZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y71MJucuUf5PzoAmht6G11w2phAOT05/ACj/kjL1Fvg=;
        b=2XHeUoIRlIqmqWvDFu6wMEiXQGvMJ6DztGGyewNMQNYU6dKM+ptjjL39ekHuNUxK8h
         Kl2W940yWNL2iiFNaAI/h9GAbVEsamTJqkTrzV8NgiONzZphD93FpNLNCXMhanPArpD5
         Y0U+jsteX9i1h82/NEYVxsKECML3NdBTbxDqnH314AGIBVDgn+EuPiw52LI8c8wkMDrw
         l/TeC8jTyu79EuEDZ6/UOPFZJfRGYNJKsGiZB0xBYrXI28uFFl7lRkLjCiOVq4UIfAfd
         CEmZRQbW52KWfqbw/kdjeKHgi5iu3arpI1wKIaA2HxS9A7w8PmXFpZG7pIUB5alSOfV0
         FYEw==
X-Gm-Message-State: ANoB5plIWXMu4xNzqrntxqJO7qn90Ier0XJGqL462V7dljg1eO379TH+
        9GQyF7+k+i2f8yJDnNdUzbc=
X-Google-Smtp-Source: AA0mqf7oqxD/mCJ4nOyXw0cLvJ5fmSXzhReGCBcbXcnWKoptueUDpALi2m0sA8o4XYGqqRMp1BS27w==
X-Received: by 2002:a17:90a:6fc5:b0:218:1e70:2af with SMTP id e63-20020a17090a6fc500b002181e7002afmr4342125pjk.46.1668713215450;
        Thu, 17 Nov 2022 11:26:55 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id qe1-20020a17090b4f8100b00210039560c0sm3940135pjb.49.2022.11.17.11.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 11:26:54 -0800 (PST)
Date:   Thu, 17 Nov 2022 11:26:53 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v10 049/108] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <20221117192653.GM2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <9d5595dfe1b5ab77bcb5650bc4d940dd977b0a32.1667110240.git.isaku.yamahata@intel.com>
 <67b782ee-c95c-d6bc-3cca-cdfe75f4bf6a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <67b782ee-c95c-d6bc-3cca-cdfe75f4bf6a@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 09:40:38AM +0800,
Chenyi Qiang <chenyi.qiang@intel.com> wrote:

> > +static int __must_check handle_changed_private_spte(struct kvm *kvm, gfn_t gfn,
> > +						    u64 old_spte, u64 new_spte,
> > +						    int level)
> > +{
> > +	bool was_present = is_shadow_present_pte(old_spte);
> > +	bool is_present = is_shadow_present_pte(new_spte);
> > +	bool was_leaf = was_present && is_last_spte(old_spte, level);
> > +	bool is_leaf = is_present && is_last_spte(new_spte, level);
> > +	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> > +	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> > +	int ret;
> 
> int ret = 0;
> 
> > +
> > +	lockdep_assert_held(&kvm->mmu_lock);
> > +	if (is_present) {
> > +		/* TDP MMU doesn't change present -> present */
> > +		KVM_BUG_ON(was_present, kvm);
> > +
> > +		/*
> > +		 * Use different call to either set up middle level
> > +		 * private page table, or leaf.
> > +		 */
> > +		if (is_leaf)
> > +			ret = static_call(kvm_x86_set_private_spte)(kvm, gfn, level, new_pfn);
> > +		else {
> > +			void *private_spt = get_private_spt(gfn, new_spte, level);
> > +
> > +			KVM_BUG_ON(!private_spt, kvm);
> > +			ret = static_call(kvm_x86_link_private_spt)(kvm, gfn, level, private_spt);
> > +		}
> > +	} else if (was_leaf) {
> > +		/* non-present -> non-present doesn't make sense. */
> > +		KVM_BUG_ON(!was_present, kvm);
> > +		/*
> > +		 * Zap private leaf SPTE.  Zapping private table is done
> > +		 * below in handle_removed_tdp_mmu_page().
> > +		 */
> > +		lockdep_assert_held_write(&kvm->mmu_lock);
> > +		ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
> > +		if (!ret) {
> > +			ret = static_call(kvm_x86_remove_private_spte)(kvm, gfn, level, old_pfn);
> > +			WARN_ON_ONCE(ret);
> > +		}
> > +	}
> 
> Otherwise, "ret" may be returned without initialization. Then it will
> trigger the WARN_ON_ONCE(ret) after handle_changed_spte() in patch 48.

Thanks for catching it.  Compiler didn't complain it.  Maybe W=1 is needed.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
