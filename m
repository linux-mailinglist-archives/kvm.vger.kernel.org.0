Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED98F6053FC
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 01:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiJSXdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 19:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiJSXcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 19:32:50 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1938172532
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:32:41 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c24so18691297pls.9
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GOdTdD623/YusJfsR/UmEt7HXnKEb0mP+WLNynhu5/Y=;
        b=RWtmUC50GX+0ZQ32g5qbwMLI9xk+r3RrIN8WIX6WSDXgNKi/IH1rFAOE4BaRmDOCQk
         q7NcLh/IYp1ium4abQncAyZUxt/D3M5+XQl9CoRXilqBPO8N7h8Jf1CsFhYVmbXfCDdJ
         GbBFo1r2OXRzCG1d6k4VKyRHomEcqSQLuRT1GyZuynIX/BDcf2/PoFz/pjQyhWdxhJ7R
         sVD0VYdKcDhEum9a00zy7yQZGSf1l+tyC0pHYAEN1ldQKbAxqHQ5v3UZrDNPbgf8ayEb
         tsZrpuY+i/Gwr3TBh/bb8CgBxKZoVz2rjfEqDWpfKxbbZxwNuW3dc3dvsTFn1MN1mOlW
         kiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOdTdD623/YusJfsR/UmEt7HXnKEb0mP+WLNynhu5/Y=;
        b=hOX1ogwNzjPIdgQtzbPCAITzY6jbMVgJPzgozxZTSEqcUCVeIpWTFaAVaZa7d3Q/eD
         z4HGO9/4oOiIVxH4VA9qKOvCQuqexVsjvGHbCt03SUnfc4ndzO8e4d56xj5fCUsd3PcC
         bCKM/VD33amZn+otU+LuDMUmqk+ufpEwoE0FCUpTQeFtR7dfTtC6Ho7CkSn9SwPO7jQw
         jFRhN/FwA0mFCVO5VFa5iGw+562LkEPoSdzZCVjx4zJ//wwZcdc5RXVPxZ3Rc1+KNb2/
         RfhstxdcbNFT+EShYww6+nL2mQU6U/ygAuaArd1CUno1m71U9qcqLCDMULQs3EMoYyvG
         q78Q==
X-Gm-Message-State: ACrzQf2SzvddffERuOPpGejHwemCK7qvAQL24whTVfFOqAyG2K/12SQQ
        6X0XN0Q3sfSDpV+GDbWKbIdfcw==
X-Google-Smtp-Source: AMsMyM7CQOx8R08XpaqcxD826bEvd+nBp7WOm8CizWjgaSQhvlO4ECeDzJxBWgIKiZPBPtpO/OIQMw==
X-Received: by 2002:a17:902:e3cd:b0:17f:9c94:b22f with SMTP id r13-20020a170902e3cd00b0017f9c94b22fmr10927856ple.80.1666222360234;
        Wed, 19 Oct 2022 16:32:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902ab8e00b001783f964fe3sm11270350plr.113.2022.10.19.16.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:32:39 -0700 (PDT)
Date:   Wed, 19 Oct 2022 23:32:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 15/15] KVM: arm64: Handle stage-2 faults in parallel
Message-ID: <Y1CJFLVnnbX4Ck85@google.com>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
 <20221007233253.460257-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007233253.460257-1-oliver.upton@linux.dev>
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

On Fri, Oct 07, 2022, Oliver Upton wrote:
> @@ -1534,7 +1517,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	 */
>  	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
>  			       PAGE_SIZE, __pfn_to_phys(pfn),
> -			       KVM_PGTABLE_PROT_R, NULL);
> +			       KVM_PGTABLE_PROT_R, NULL, KVM_PGTABLE_WALK_SHARED);

All MMU notifier events acquire mmu_lock for write when invoking arch code, i.e.
this isn't a shared walk.
