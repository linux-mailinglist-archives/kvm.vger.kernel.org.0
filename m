Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3337558DA85
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 16:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244372AbiHIOuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 10:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiHIOt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 10:49:59 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E098C1CB1C
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 07:49:58 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f65so11532767pgc.12
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 07:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=pj/fEy+PbSOJfjnAmjWjp05xip889MBZsAYo8a+A09M=;
        b=CXaj2mo3edpOrrs/eGAixM+dbKdbKNrdKswMb3QFsqibFiHrd0zQLlivVeSMpb5NBU
         0OVZyUfeaiDip8FhxSvA0JN1Yzd+S+tyOctSvkpgSfu9Ds7e2w75/lLCNX/2raMU34uI
         9iH4h045wCfCNy4t6/RaDbw/ro1zUMhC0iRlwYXF0GmSlqXE5Hs3aQmq/roM38MjBGvg
         lbtcc7Y5VCBykGHk4du/nAWcH8yMISZwnCRlXN+FO2rKv8mXxe4EemIGzpExOQI7MV51
         vUHtL/hcOUP4J4f33kPHXkvlSCsfhWSS1oXRy4/lXEBtkXwB28Yg13qi1O8dsEAgP+34
         g1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=pj/fEy+PbSOJfjnAmjWjp05xip889MBZsAYo8a+A09M=;
        b=hDH+5A6Veav+6/B37T6EQO6hvWp7FXwwudE60R3essqWxdvW+yVlSkuOQyB+yJv8f1
         4I4G75JqD6i4/x9m9ryQgT2WrpvwFAmTPbosQkju+N3OFN99eQ2C49dew88JlwnQ29Bg
         KmLGG2uJSotRWyxFstDPaAoICmbfG+b4qLO2is3QIDv6VHeWbKV8dPOF4CPNDMBheWKN
         a+YCW34KzyvmfaG0dcAGPHKo4r9G8AGuDWySeaFsLHTQOLOxXdiJB4Kf15bGyyJWkNww
         6dogdZxDKY7q2PnXNpniTdDbVbWZlOygQr+E0YCoxjI4f4byByB+0aMR5LP8uVUrUP5b
         tebA==
X-Gm-Message-State: ACgBeo2rsaimbg8WSuGJ3nFCHHjBHL/i3hD4bZ5hLTyfdPHkfAWSnoUz
        zsVozeBaTIGkFOy3QDoT2mMNbA==
X-Google-Smtp-Source: AA6agR5raAJf/FGY+7K6wm6kyAjMcdb6Lw1pH0tvolG9dm1dLZhHNnUyqda3L+Izobzyg/WjAqaY3w==
X-Received: by 2002:a63:4d1a:0:b0:41b:d319:d8ad with SMTP id a26-20020a634d1a000000b0041bd319d8admr19737406pgb.613.1660056598253;
        Tue, 09 Aug 2022 07:49:58 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id jb9-20020a170903258900b001709e3c755fsm5596792plb.230.2022.08.09.07.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 07:49:57 -0700 (PDT)
Date:   Tue, 9 Aug 2022 14:49:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 8/8] KVM: x86/mmu: explicitly check nx_hugepage in
 disallowed_hugepage_adjust()
Message-ID: <YvJ0EpvDhc00NTSx@google.com>
References: <20220805230513.148869-1-seanjc@google.com>
 <20220805230513.148869-9-seanjc@google.com>
 <36634375-e7ee-e28e-20dd-9ab1ebdd8040@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36634375-e7ee-e28e-20dd-9ab1ebdd8040@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022, Paolo Bonzini wrote:
> On 8/6/22 01:05, Sean Christopherson wrote:
> >   	    !is_large_pte(spte)) {
> > +		u64 page_mask;
> > +
> > +		/*
> > +		 * Ensure nx_huge_page_disallowed is read after checking for a
> > +		 * present shadow page.  A different vCPU may be concurrently
> > +		 * installing the shadow page if mmu_lock is held for read.
> > +		 * Pairs with the smp_wmb() in kvm_tdp_mmu_map().
> > +		 */
> > +		smp_rmb();
> > +
> > +		if (!spte_to_child_sp(spte)->nx_huge_page_disallowed)
> > +			return;
> > +
> 
> I wonder if the barrier shouldn't be simply in to_shadow_page(), i.e. always
> assume in the TDP MMU code that sp->xyz is read after the SPTE that points
> to that struct kvm_mmu_page.

If we can get away with it, I'd prefer to rely on the READ_ONCE() in
kvm_tdp_mmu_read_spte() and required ordering of:

	READ_ONCE() => PRESENT => spte_to_child_sp()
