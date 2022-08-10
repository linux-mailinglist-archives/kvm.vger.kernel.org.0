Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996CE58EEAD
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 16:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiHJOpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 10:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbiHJOpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 10:45:45 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4E549B6B
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:45:44 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r69so8007159pgr.2
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=n/FvnPAhiz825x+FeNfX4XyD3zxHDvzfM9TNTYZ90QU=;
        b=E11EqlOQsY2fuSsbrXE2W+WvhjfLaXL+efuSnbpEkwWQswR3jOIlAt3bozTXqmTR2k
         lC043zwoby/ApB4Kzbj9+ckVrdmJ3h2FAhhCptuQ99GN+DHBZrrAa1BS/4X0Y4XzRw62
         UQ/Ik3vX/jCA7ae7OUjGfW+cO0QKG7xUxDyP3XzawnwTiiKy2v4sIimADSO5if6+m1NL
         bQgktj4HfXOqSPRE5C7K8+TfRk0TgZYG4OtCNmh0JTBkkSvjDrDZN9sCq2D9W8Bt6SUK
         d5xYWhA/WtVzxWWClwjRMhcrt8lFQvw7JK98ae+t/t6Xf08YqHOrHujyEoPfFt8txnuD
         06VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=n/FvnPAhiz825x+FeNfX4XyD3zxHDvzfM9TNTYZ90QU=;
        b=HX9zyQwfNRD3ynLI6ov03N+1WhPPLoX+DzlNoBoJlQLh/p5OsrCBSYvNtEJsz8WEqV
         3dVbMg0cVXdUiEzVFHTyrOZnfrsaV/nGsHWqpCFfKoDaI5lB67hdDtb6+wmjyMgoQMug
         UdUGlzTkg9xQPJHU6lNtYEHA3x+61ElWgoIjW5mSX7PeolxaNM6Bhh98/lCh2/yK5rDG
         GzYNp3ajeG652e6bS/qkLLqFaftELQuF/CbQhhgxsMIId/Q2zMgqLMnGA6PQfcHFtBwJ
         iG/8l95tc7atZj/hjh4sH09lE0QRvmxXGcaNyRXm9Fj6ESZweTz1XTALdW9WsSB78BtJ
         0FBQ==
X-Gm-Message-State: ACgBeo1IoQYadTRcrWWNEONN5WvjUmqevqgfH6339rvd+ENDu7UhL43q
        eKehDPkzwNkxxR6gMp9FRq5BoQ==
X-Google-Smtp-Source: AA6agR6NnQkoOacZd11EckpNL+dHKB00fMf5d45XoUSU0xNg2YQ8pHkLvxGU8H6cVgBozQrJQ0y6bw==
X-Received: by 2002:a05:6a00:27a0:b0:52f:8766:82ec with SMTP id bd32-20020a056a0027a000b0052f876682ecmr10684911pfb.17.1660142743680;
        Wed, 10 Aug 2022 07:45:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n184-20020a6227c1000000b0052d2b55be32sm2127604pfn.171.2022.08.10.07.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 07:45:43 -0700 (PDT)
Date:   Wed, 10 Aug 2022 14:45:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86: Disallow writes to immutable feature
 MSRs after KVM_RUN
Message-ID: <YvPEk4tnvajOfjBl@google.com>
References: <20220805172945.35412-1-seanjc@google.com>
 <20220805172945.35412-4-seanjc@google.com>
 <40c9ecc1-e223-160b-4939-07e4f7200781@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c9ecc1-e223-160b-4939-07e4f7200781@intel.com>
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

On Wed, Aug 10, 2022, Xiaoyao Li wrote:
> On 8/6/2022 1:29 AM, Sean Christopherson wrote:
> > @@ -2136,6 +2156,23 @@ static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> >   static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> >   {
> > +	u64 val;
> > +
> > +	/*
> > +	 * Disallow writes to immutable feature MSRs after KVM_RUN.  KVM does
> > +	 * not support modifying the guest vCPU model on the fly, e.g. changing
> > +	 * the nVMX capabilities while L2 is running is nonsensical.  Ignore
> > +	 * writes of the same value, e.g. to allow userspace to blindly stuff
> > +	 * all MSRs when emulating RESET.
> > +	 */
> > +	if (vcpu->arch.last_vmentry_cpu != -1 &&
> 
> can we extract "vcpu->arch.last_vmentry_cpu != -1" into a function like
> kvm_vcpu_has_runned() ?

Ya, a helper is in order.  I'll add a patch in the next version.
