Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBED517B0A
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiECAAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 20:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbiEBX7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:59:02 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B5A633A
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:55:28 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so770072pjb.5
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 16:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KF+0hHq9SEiR1B1K23N9qqmjFGxNYyDbMKeM3XCoCIA=;
        b=lazFntWQL/l49iNuHrVAg+ZM2my/Zj1tAQupWNwnULXQWQ6RaIywfzw7Ji2YH00tfF
         bZtIiCT+3Rh8Dbvp0GdIEA9WJc0Wc4PseZLS0cItxB7zQTQAd8dPd96WihSJujy5RV/T
         90ZqnDWg+FYE9fwKzM0MYncZ2AEpJoVHQ49KsiZJ/RvQhJ0VdCZLlbfElbhN35xlBRlS
         jDV8p8rFteDGJZier8572E1WzRDr9PwzVjzTg++6z/8nWJjhwMzgl95vk/jYNui4TvuR
         GaI8BFeRU2fq/3gT+zTMsJMi6NMn7mfQxMUHecg6OM6JjB5yXhqbd+/HmirCHY9cBtcn
         HYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KF+0hHq9SEiR1B1K23N9qqmjFGxNYyDbMKeM3XCoCIA=;
        b=Y4WWrZwOM6lzkYPKtKmc7b2nG62jEuccWnIjWQ9IezC/MLsBXjGe0lJf/xb69qGuRz
         VfLNFRLOMzD3HwaO/88yqDt846Iwihu49w8gR3v+6qJc7yIVLyUKNjLdzGz0x8T5uiST
         PUoEJHHV1mI+J2nnGpsYG7MgpgIor6TMtEKIOTVMc832MJ0OG7Hx23JuZJTLcAylvjAU
         IWWsOsmMsLlW/Tx7R8A5jOuf6Z6897xqCWMGRYASPBztIZ4Dk6B9Mg2y8X8SQ6ESDtc2
         AUUzdFgUlRAAGfr0Au3UX91TjJSdj/XTBnpNpIUigRYzEBVjfcTdLDB8dojioOfhoWJq
         nEIg==
X-Gm-Message-State: AOAM5308Y7DB5mIgXte6Ea508FrhopvPFEKHrvbUVgsMK2NdKeu348BF
        uoYUpA8obvSuwTXl9UqLvZXtqA==
X-Google-Smtp-Source: ABdhPJxpaMM2fi5EZQja67jPxxKDSFZl//fXpAE1n0fwEK0QxIJzBAkYYQYIvcxXlPckj892rv/ZEw==
X-Received: by 2002:a17:90a:9ea:b0:1dc:1c48:eda with SMTP id 97-20020a17090a09ea00b001dc1c480edamr1808249pjo.38.1651535728233;
        Mon, 02 May 2022 16:55:28 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d8-20020aa78e48000000b0050dc7628199sm5232277pfr.115.2022.05.02.16.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 16:55:27 -0700 (PDT)
Date:   Mon, 2 May 2022 23:55:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Update number of zapped pages even if
 page list is stable
Message-ID: <YnBvbHXTseOZkmHF@google.com>
References: <20211129235233.1277558-1-seanjc@google.com>
 <YlCNpQ9nkD1ToY13@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlCNpQ9nkD1ToY13@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 08, 2022, Sean Christopherson wrote:
> Very high latency ping, this is still problematic and still applies cleanly.

PING!  PING!  PING!  PING!

Don't make me write a script to ping you every hour :-)

> On Mon, Nov 29, 2021, Sean Christopherson wrote:
> > When zapping obsolete pages, update the running count of zapped pages
> > regardless of whether or not the list has become unstable due to zapping
> > a shadow page with its own child shadow pages.  If the VM is backed by
> > mostly 4kb pages, KVM can zap an absurd number of SPTEs without bumping
> > the batch count and thus without yielding.  In the worst case scenario,
> > this can cause a soft lokcup.
> > 
> >  watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [dirty_log_perf_:13020]
> >    RIP: 0010:workingset_activation+0x19/0x130
> >    mark_page_accessed+0x266/0x2e0
> >    kvm_set_pfn_accessed+0x31/0x40
> >    mmu_spte_clear_track_bits+0x136/0x1c0
> >    drop_spte+0x1a/0xc0
> >    mmu_page_zap_pte+0xef/0x120
> >    __kvm_mmu_prepare_zap_page+0x205/0x5e0
> >    kvm_mmu_zap_all_fast+0xd7/0x190
> >    kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
> >    kvm_page_track_flush_slot+0x5c/0x80
> >    kvm_arch_flush_shadow_memslot+0xe/0x10
> >    kvm_set_memslot+0x1a8/0x5d0
> >    __kvm_set_memory_region+0x337/0x590
> >    kvm_vm_ioctl+0xb08/0x1040
> > 
> > Fixes: fbb158cb88b6 ("KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""")
> > Reported-by: David Matlack <dmatlack@google.com>
> > Reviewed-by: Ben Gardon <bgardon@google.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > 
> > v2:
> >  - Rebase to kvm/master, commit 30d7c5d60a88 ("KVM: SEV: expose...")
> >  - Collect Ben's review, modulo bad splat.
> >  - Copy+paste the correct splat and symptom. [David].
> > 
> > @David, I kept the unstable declaration out of the loop, mostly because I
> > really don't like putting declarations in loops, but also because
> > nr_zapped is declared out of the loop and I didn't want to change that
> > unnecessarily or make the code inconsistent.
> > 
> >  arch/x86/kvm/mmu/mmu.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 0c839ee1282c..208c892136bf 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5576,6 +5576,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
> >  {
> >  	struct kvm_mmu_page *sp, *node;
> >  	int nr_zapped, batch = 0;
> > +	bool unstable;
> >  
> >  restart:
> >  	list_for_each_entry_safe_reverse(sp, node,
> > @@ -5607,11 +5608,12 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
> >  			goto restart;
> >  		}
> >  
> > -		if (__kvm_mmu_prepare_zap_page(kvm, sp,
> > -				&kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
> > -			batch += nr_zapped;
> > +		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
> > +				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
> > +		batch += nr_zapped;
> > +
> > +		if (unstable)
> >  			goto restart;
> > -		}
> >  	}
> >  
> >  	/*
> > -- 
> > 2.34.0.rc2.393.gf8c9666880-goog
> 
