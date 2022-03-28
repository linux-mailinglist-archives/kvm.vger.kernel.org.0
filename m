Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA104E9A27
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 16:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244097AbiC1Oyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 10:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244092AbiC1Oym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 10:54:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A00E5DE56
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 07:53:01 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so15916170pjf.1
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 07:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=szL7lceaP/NxR0+lC2cN5AaRzpZIx1sqZ2iEfehaPgU=;
        b=dWoW0WSt+vofTr+ILF/HwHxImbE9tGNhavUUeWUHY4WvJIuRkKIJBouTRGpch6aByh
         BOCESJWtyC9Iu76Ajmq58cWmG3JORjH1N3DUNyraC9UHpqtMgq5J0B7YvvIwCiB4qSuq
         43EA1b7BzZ2gstsbw3w8peW/pUMClebmhupAU6Is6uLzwHPCvvmMNApimCrwyzdm/Ogc
         mRYGeomM5FLr79ZfvojBlNJCv+Y03N/h38wNank/TQ/Bgl3Zpp+EdIMaiOjSkX9MRwim
         EKf9jK+/Xhy0XPU89tIm71stvekDcCJDBojjObxOlzFtX+2WvswVa86Asj04kDqvnjXi
         Yq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=szL7lceaP/NxR0+lC2cN5AaRzpZIx1sqZ2iEfehaPgU=;
        b=gvQXXWr6t2DpbRXe+zOPgSmc8Vsxjicjzpclk8Jm1z2wOwmwBYETTl1Gxc2jGFwMZn
         urS/8eCftRktHWm/JeeM/uh8oUrnETcgpW0Qd9XAkrMiE1QmJUyCNkTfMP6aMLYWZmaB
         u+sb4jm5EydPdM0Tl2eIvCssliCNL2hw+e1vYx9ShHzPGaQrUEvAFjWs66AJ1lOvtJoc
         zP2tu2dYB4V6617YWAN5fTpWWC3EXT0TYyUEwjSxC9xPQ90DB4rl1jLW4zIv7rnChjIy
         I5zJJxCsF19ckh55jrbxc/kwERsJaQNlNjsvy88Cs1AavMOoyATJ6TDDTJPCE1dzU3Ka
         rqpA==
X-Gm-Message-State: AOAM531jiir5QcKogwFQ1DksRFZJLMo+sTSMv9NwuDKKpq30/ESjecBZ
        OHX2p8BdJd4Ohm7W2r/JI0Ue4yfSJ+c4jQ==
X-Google-Smtp-Source: ABdhPJyIClNMv5o0NWmY1p1hSJAbH+a7bM/zRuKCdQmA7b/Y9V8XkwNQyyrDzOcaszKj/ka4JXU7Gg==
X-Received: by 2002:a17:90b:f82:b0:1c6:58b9:bd36 with SMTP id ft2-20020a17090b0f8200b001c658b9bd36mr41688643pjb.141.1648479180804;
        Mon, 28 Mar 2022 07:53:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a16-20020a637050000000b00385f92b13d1sm13066121pgn.43.2022.03.28.07.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 07:53:00 -0700 (PDT)
Date:   Mon, 28 Mar 2022 14:52:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Zap only TDP MMU leafs in zap range and
 mmu_notifier unmap
Message-ID: <YkHLyP1LvH0MYN25@google.com>
References: <20220325230348.2587437-1-seanjc@google.com>
 <87lewuo4ge.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lewuo4ge.fsf@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Re-introduce zapping only leaf SPTEs in kvm_zap_gfn_range() and
> > kvm_tdp_mmu_unmap_gfn_range(), this time without losing a pending TLB
> > flush when processing multiple roots (including nested TDP shadow roots).
> > Dropping the TLB flush resulted in random crashes when running Hyper-V
> > Server 2019 in a guest with KSM enabled in the host (or any source of
> > mmu_notifier invalidations, KSM is just the easiest to force).
> >
> > This effectively revert commits 873dd122172f8cce329113cfb0dfe3d2344d80c0
> > and fcb93eb6d09dd302cbef22bd95a5858af75e4156, and thus restores commit
> > cf3e26427c08ad9015956293ab389004ac6a338e, plus this delta on top:
> >
> > bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
> >         struct kvm_mmu_page *root;
> >
> >         for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> > -               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
> > +               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
> >
> >         return flush;
> >  }
> >
> 
> I confirm this fixes the issue I was seeing, thanks!
> 
> Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Phew!  I think I would have cried were that not the case :-)  Thanks for testing!
