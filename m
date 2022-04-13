Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A4B4FFDC8
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiDMSau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiDMSan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:30:43 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5662350E39
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:28:21 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i184so2075297pgc.2
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bpeKB101GiB4lxea+Vei5KAP2vPrN2mAl+5Iy4JIo1Y=;
        b=hSS+V6AJRz170U3P+2UqpwQ5nmzP1chGiCMEpvco/3ng23jK7nkez9K1F+P4cRXQjO
         YSsOdRh0ob/PxY68/0Y/VELl5VQowOxyFpT9XPmnxFvhgOMwtKOeko/YZwR12NjPm/AN
         rztaKQwC/WhmgPfRgIg3aarP/B37AhZS6JUH1dW7S9ZCTAhfmLAt52in0ht8+hzQwrdb
         cuqY1xSpSWScCLE+3OLpp0PfmNkLXJw+2W4WH8WJPkgIpiPFD9LktmKo59tCfPclJ4gv
         aIsOm9E4RLexPhl6n3Rg/6l3RvqmNX5LuUt+M+Evoer+5fHEseA6lLSYh4fIXsahLxbx
         191w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bpeKB101GiB4lxea+Vei5KAP2vPrN2mAl+5Iy4JIo1Y=;
        b=pWSAqv6zND3X9/0FkKaiRI86enVWRPmDVAZAIhaBzx6H9TTGnDP5Tw9QlHvVAiYmN7
         p7GQzdGq0p4Jw2YsZsWlRIZmTSrg15D/CmfjzZ9jM1yBaWPTRTPT+bm3bmYPkwZGiyas
         t378wRLiPdowzLSkm15KU34YAPGUuBPfcNzYF4DCpNDRlYKaHR8SxgQIIv9ZplYCPiL0
         lwQkdvXPFXXz+0ahToPmwhNzhsR4YKHjKmbjv/ww83sOhRBgOCrczxhU+hdxID9k+yUC
         6ZpDo9zmAJls8K+naIfaM6m4iyCP9h4zxSm8yZSQgeDK6ni6g4J1YST0c3XGdXTO9AmQ
         SAaw==
X-Gm-Message-State: AOAM531dfb1HuC2NGNpMNgI1MukrpFMQld78jYXuYnMFFoRs6kWnVlls
        hwKi8GVqTcD6Mqo1kkqAofKxiA==
X-Google-Smtp-Source: ABdhPJwVoOa8Dj+YAhZ33kjw7NtyqOGLBfa4tCRI9XDyKQYayiKcuB3O+jKCPUAV/nNuh3GKhHrCig==
X-Received: by 2002:a65:560e:0:b0:39d:7613:94cf with SMTP id l14-20020a65560e000000b0039d761394cfmr10974179pgs.196.1649874500603;
        Wed, 13 Apr 2022 11:28:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n19-20020a62e513000000b005048eef5827sm24973743pff.142.2022.04.13.11.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 11:28:19 -0700 (PDT)
Date:   Wed, 13 Apr 2022 18:28:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlcWP5Z3osvUg0Ia@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com>
 <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
 <YlTKQz8HVPtyfwKe@google.com>
 <CALzav=dz8rSK6bs8pJ9Vv02Z7aWO+yZ5jAA8+nmLAtJe3SMAsA@mail.gmail.com>
 <YlYhO7GvjKY1cwHr@google.com>
 <YlcPIYJ0CB2qnfpT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlcPIYJ0CB2qnfpT@google.com>
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

On Wed, Apr 13, 2022, David Matlack wrote:
> On Wed, Apr 13, 2022 at 01:02:51AM +0000, Sean Christopherson wrote:
> > There will be one wart due to unsync pages needing @vcpu, but we can pass in NULL
> > for the split case and assert that @vcpu is non-null since all of the children
> > should be direct.
> 
> The NULL vcpu check will be a little gross,

Yeah, I would even call it a lot gross :-)

> but it should never trigger in practice since eager page splitting always
> requests direct SPs. My preference has been to enforce that in code by
> splitting out

It still is enforced in code, just at different points.  The split version WARNs
and continues after finding a page, the below WARNs and rejects _while_ finding
the page.

Speaking of WARNs, that reminds me... it might be worth adding a WARN in
kvm_mmu_get_child_sp() to document (and detect, but more to document) that @direct
should never encounter an page with unsync or unsync_children, e.g. 

	union kvm_mmu_page_role role;
	struct kvm_mmu_page *sp;

	role = kvm_mmu_child_role(sptep, direct, access);
	sp = kvm_mmu_get_page(vcpu, gfn, role);

	/* Comment goes here about direct pages in shadow MMUs? */
	WARN_ON(direct && (sp->unsync || sp->unsync_children));
	return sp;

The indirect walk of FNAME(fetch)() handles unsync_children, but none of the other
callers do.  Obviously shouldn't happen, but especially in the huge page split
case it took me a second to understand exactly why it can't happen.

> but I can see the advantage of your proposal is that eager page splitting and
> faults will go through the exact same code path to get a kvm_mmu_page.
> __kvm_mmu_find_shadow_page(), but I can see the advantage of your
> proposal is that eager page splitting and faults will go through the
> exact same code path to get a kvm_mmu_page.
> 
> > 
> > 		if (sp->unsync) {
> > 			if (WARN_ON_ONCE(!vcpu)) {
> > 				kvm_mmu_prepare_zap_page(kvm, sp,
> > 							 &invalid_list);
> > 				continue;
> > 			}
> > 
> > 			/*
> > 			 * The page is good, but is stale.  kvm_sync_page does
> > 			 * get the latest guest state, but (unlike mmu_unsync_children)
> > 			 * it doesn't write-protect the page or mark it synchronized!
> > 			 * This way the validity of the mapping is ensured, but the
> > 			 * overhead of write protection is not incurred until the
> > 			 * guest invalidates the TLB mapping.  This allows multiple
> > 			 * SPs for a single gfn to be unsync.
> > 			 *
> > 			 * If the sync fails, the page is zapped.  If so, break
> > 			 * in order to rebuild it.
> > 			 */
> > 			if (!kvm_sync_page(vcpu, sp, &invalid_list))
> > 				break;
> > 
> > 			WARN_ON(!list_empty(&invalid_list));
> > 			kvm_flush_remote_tlbs(kvm);
> > 		}
