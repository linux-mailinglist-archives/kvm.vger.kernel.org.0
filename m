Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB55860482F
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 15:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiJSNwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 09:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiJSNvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 09:51:38 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4289118499B
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 06:35:34 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a67so25250194edf.12
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 06:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jGDuBvVBWtQQhTh15f+xlFUiPdaWSbx11jMCTBh0luA=;
        b=PxTuqiFHKGLs6Q04zg2G4eSd00jK6zzgrt4HdFyWkirB8aCwSWFmJDbb4XEBPbs84b
         XjeLDlepBSGLM9yuvsYFtIMpaA2nrkP9RseT+JMyFrkJmTtNG6S7IBl+ZFb+Z7EU964K
         51qHIrDOsh043I6Y6V8E1g4XMUP9UGgmtMVCorWtgXXr8Ez+6KCd5ZzkSfC1vBvU0cH1
         djCo4kPBwtzeKGV/O9N2hFeEJoYjXLSvmvYEL25wdP7p2Tf7hgW6O1nT+5fEjsm/qMk2
         LLG+qdTEOncIhwY/g1cG4Fb+GhzkkvlzTi4NT6ZkssFxxTJuSnyH4YRDTPFp3De08sQ/
         Humg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jGDuBvVBWtQQhTh15f+xlFUiPdaWSbx11jMCTBh0luA=;
        b=2z0hZGm3iqF6R02o36w6Fq8DBLtRMC2L3yMM33cxpDQ+9He+WoqeJjlQ6yEa8sIS2U
         NEcbZ2GiikvQpuCIWczO5QMfD7lecvcJB2RZlaINTbuhG/3iYusF4aiNpTNKE1rilorh
         uKv1CKwdrjgYIojIaC/IZCRJJcG5tc1DfKKX0T0m0VYK2Mj+9DFpFIPslSeO26b6lyOq
         I47PUQfc3gtrxeRf6JjhWN3soUBf5ammq1KVe24XIgTkcvE7eJUyYiVSQ3W5MAuHW0EF
         9MlXk0yJ4huK+2PnVm2Xte5H290h2Qbt12PwnPTyunl3ymxSHPfDsPRHRNmAgMWqYvZd
         izSA==
X-Gm-Message-State: ACrzQf1yaUxnZy4C8xrhanKH4pNcsNkoyK6NUbbGI2roh45HS+kfchs3
        3BEAIERHRB7lE/qYZi1QEUfCeQ==
X-Google-Smtp-Source: AMsMyM5/lmcijk1PTC/MIbN3EcbOaf5vqEsarZQ2QfOuX/8iQ6m+Bp7SwPos1MPS6rC1Qfj/aMnvQg==
X-Received: by 2002:a05:6402:5ca:b0:445:c80a:3c2 with SMTP id n10-20020a05640205ca00b00445c80a03c2mr7515578edx.247.1666186508675;
        Wed, 19 Oct 2022 06:35:08 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id d7-20020aa7d687000000b004580296bb0bsm10538281edr.83.2022.10.19.06.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 06:35:08 -0700 (PDT)
Date:   Wed, 19 Oct 2022 13:35:05 +0000
From:   Quentin Perret <qperret@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <Y0/9CZHSMLLnmWU9@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
 <Y07VaRwVf3McX27a@google.com>
 <20221019115723.GA4067@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019115723.GA4067@willie-the-truck>
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

On Wednesday 19 Oct 2022 at 12:57:24 (+0100), Will Deacon wrote:
> On Tue, Oct 18, 2022 at 04:33:45PM +0000, Quentin Perret wrote:
> > On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > > +void pkvm_hyp_vm_table_init(void *tbl)
> > > +{
> > > +	WARN_ON(vm_table);
> > > +	vm_table = tbl;
> > > +}
> > 
> > Uh, why does this one need to be exposed outside pkvm.c ?
> 
> We need to initialise the table using the memory donated by the host
> on the __pkvm_init path. That's all private to nvhe/setup.c, so rather
> than expose the raw pointers (of either the table or the donated memory),
> we've got this initialisation function instead which is invoked by
> __pkvm_init_finalise() on the deprivilege path.
> 
> Happy to repaint it if you have a patch?

I don't, I just got confused, maybe because in an older version of this
(possibly quite old) the table was statically allocated? Anyways, it's
all fine as-is, thanks for the reply.
