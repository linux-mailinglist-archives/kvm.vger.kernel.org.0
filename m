Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E6A5BB2D7
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 21:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiIPTdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 15:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIPTdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 15:33:39 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1088ACA13
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 12:33:37 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso735706pjk.0
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 12:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=7koUmLdWd3oEgwetevFBcgnuG0GVKxojKR8I+sUBlm8=;
        b=bP5yedyAXi7WDrG/FFmAEiTMdMkkudI5cP9ED/DF56Kof4boDDYNcpCpYMPnXkKrg4
         ujqkBFTI9wqTn+/w2Rr0zYuMlMXL8hzgwdb88DnxyrIhCqy19p+XzNMMiRLYfdcRuKUX
         nu5PhJo7e/Ne+i9ncLJasmEcEfNLfuN8y1evlNvmdlZHAfxoR1aPqocR10BLUEgcaowu
         LNKLG/2NjDH+zWjFMdVi20i/KXRM57VYWS1o1Jo3pPmgdYyuLHDVJojta2xIZHMxb3G/
         U5j63Ur+XVi2+F2jcCa87/m0B+icKHxHTr0fkbsQA6n9p02cKITP0BA4O50QxHcZG7iw
         y+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=7koUmLdWd3oEgwetevFBcgnuG0GVKxojKR8I+sUBlm8=;
        b=P+Izave1WL1Nw3o/QMKEustQnhiCjtlj2rOmyR++PlB0WUprzeskxV12y+43leIunL
         Sn4Lwcpx31154TwQUJm66nRoLuySNU0/fcWNQ/8l82ye+l9uJdQt7htp8NPU5eoycGvk
         ErXlhw/NzDzV6HYB96j5dHk3F6F+z9pCJOexbLLb6xnNNKrPEnsEOUjzrCRH+jaFgfYg
         acKoHgCcMb7TVh9+SBfPx1K9mQP2yjw6aUQhkJimyekfS7keF+f+uzJc8a3DBVeDrhUA
         BVTLaYsbrqzatTKjRVWYK/OfG3vzrueVKzKSh8W/d449n7dOH+E135N31SUSgginCW9A
         Xqzw==
X-Gm-Message-State: ACrzQf2QvsptdEOdB7Iig84ZUdZYZ9PFrExzzgQ+x8T0a6M8aXL4iBFL
        NCj+4DTPJKrR4TF/QUFbHif3vA==
X-Google-Smtp-Source: AMsMyM4oimrpkumsosCVMs3B9/WKzAd0DHlcSmg3LTcPU4vkIyDhae7RO57hjNIG3ht9++EePRARiQ==
X-Received: by 2002:a17:90b:3809:b0:202:b482:b7d6 with SMTP id mq9-20020a17090b380900b00202b482b7d6mr17580055pjb.209.1663356817295;
        Fri, 16 Sep 2022 12:33:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 129-20020a620487000000b0053e984a887csm15130733pfe.96.2022.09.16.12.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 12:33:36 -0700 (PDT)
Date:   Fri, 16 Sep 2022 19:33:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Hou Wenlong <houwenlong.hwl@antgroup.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/6] KVM: x86/mmu: Use 1 as the size of gfn range for
 tlb flushing in FNAME(invlpg)()
Message-ID: <YyTPjSl8lNPWWSlL@google.com>
References: <cover.1661331396.git.houwenlong.hwl@antgroup.com>
 <8baa40dad8496abb2adb1096e0cf50dcc5f66802.1661331396.git.houwenlong.hwl@antgroup.com>
 <YxjXgERSNIk4ZaN+@google.com>
 <20220913125833.GC113257@k08j02272.eu95sqa>
 <CALzav=c7Y_Do0vk_AtezYMBss6eRDGzyHovMYArXQ4JfmfKoOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=c7Y_Do0vk_AtezYMBss6eRDGzyHovMYArXQ4JfmfKoOw@mail.gmail.com>
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

On Tue, Sep 13, 2022, David Matlack wrote:
> On Tue, Sep 13, 2022 at 5:58 AM Hou Wenlong <houwenlong.hwl@antgroup.com> wrote:
> >
> > On Thu, Sep 08, 2022 at 01:40:16AM +0800, David Matlack wrote:
> > > On Wed, Aug 24, 2022 at 05:29:23PM +0800, Hou Wenlong wrote:
> > > > Only SP with PG_LEVLE_4K level could be unsync, so the size of gfn range
> > > > must be 1.
> > > >
> > > > Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > > > index 04149c704d5b..486a3163b1e4 100644
> > > > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > > > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > > > @@ -937,7 +937,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
> > > >
> > > >                     mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
> > > >                     if (is_shadow_present_pte(old_spte))
> > > > -                           kvm_flush_remote_tlbs_sptep(vcpu->kvm, sptep);
> > > > +                           kvm_flush_remote_tlbs_gfn(vcpu->kvm,
> > > > +                                   kvm_mmu_page_get_gfn(sp, sptep - sp->spt), 1);
> > >
> > > The third argument to kvm_flush_remote_tlbs_gfn() is the level, not the
> > > number of pages. But that aside, I don't understand why this patch is
> > > necessary. kvm_flush_remote_tlbs_sptep() should already do the right
> > > thing.
> > >
> > Since only SP with PG_LEVEL_4K level could be unsync, so the level must
> > be PG_LEVEL_4K, then sp->role.level access could be dropped. However,
> > I'm not sure whether it is useful. I can drop it if it is useless.
> 
> Ah, I see. I would be surprised if avoiding the read of sp->role.level
> has any noticeable impact on VM performance so I vote to drop this patch.

Agreed, the cost of the sp->role.level lookup is negligible in this case, and IMO
using kvm_flush_remote_tlbs_sptep() is more intuitive.

If kvm_flush_remote_tlbs_sptep() didn't exist and this was open coding the use of
kvm_flush_remote_tlbs_with_address() + KVM_PAGES_PER_HPAGE(), then I would be in
favor of hardcoding '1', because at that point the use of KVM_PAGES_PER_HPAGE() is
misleading in its own way.
