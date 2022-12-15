Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E1E64E0F9
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 19:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiLOSfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 13:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLOSfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 13:35:04 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053A75444E
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:33:16 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id t2so7782253ply.2
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0SF8E+b5YBv75SsZr0KjAQMV34mCm2oO4VY9lqM9jNc=;
        b=eRz9dTSKrO3pQivTTn2m+LM38XtBEXuPDnMvdwbOIrnAC6Ms5UB6hN0Xi0eV9ZCRpd
         W70ghrAQ9e4P/1onDV2teorffP9+AP0mdH+h5zxUO1ltfKjVfl+uWxE5hJBJySNeI7f7
         3LbCX5PT8Qgz9VtVNKu3Dljm1O5s5V/onzR96owxKIWLGgTZYpdGN1lrKSBydhOWYDM6
         7Ht7fa4eLVbuqV80VZ6am/oUxgAOxGNRPlXHEIQQTM+r4Ttc4HXAsTuHzp3OQuUGVUXd
         holDa8Y42WOZSb5OqHkChPrttss/NgtJG2ZDuXOtebiJklyRaYPUFZxK4IAaMGlkKcB8
         dT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0SF8E+b5YBv75SsZr0KjAQMV34mCm2oO4VY9lqM9jNc=;
        b=65rofgTwLuuVCc2TXxgIETWgdkBoBN7Ls7HlRHwnadoVbgamkXwGQlPYRv5FdGMKr2
         UBkk/8QbNukvAJ+yL3UigcLKNq/2ggHBQlr6H7m1x41DkyMHHD1EdcXZ+DL/rt0KV9UR
         WHG6i6F2oUQ2UfCuDI11fJGSE+lhmuAr7E11g5hCJKZ6BWLmP6baXmVDdXOnkOtyz+eB
         TD89cqFP4fMDTlJk+pqVWjGakbeBrpcKfUi8cWsh3vOdh0kPR7crUqn16nwpM+x3o7Fo
         al3XODx3eDCecgvZDt8JUByyOT33mrzuMoiRV5e7saFfbuaZQ3IPAkzc69Mn9s4OGbXe
         hNiw==
X-Gm-Message-State: AFqh2krMJ7MQaZLDO9MixvfHhg5gaIjSSKw7I9LI5BcH3tpqN0I7LK1n
        EvmWSoKu6AN/0Y/1RmueKQk5oA==
X-Google-Smtp-Source: AMrXdXusF60D7Cn3GQ2k+NibT3RjeHG1QGsemYAYFG6bM3YmpXDrlnK7ekDWdMhfEOLdnMeWpziYMw==
X-Received: by 2002:a05:6a20:4407:b0:9d:c38f:9bdd with SMTP id ce7-20020a056a20440700b0009dc38f9bddmr368527pzb.2.1671129195411;
        Thu, 15 Dec 2022 10:33:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e8-20020aa798c8000000b005769b244c2fsm2052338pfm.40.2022.12.15.10.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 10:33:14 -0800 (PST)
Date:   Thu, 15 Dec 2022 18:33:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v2 0/4] KVM: nVMX: Fix 2nd exec controls override goofs
Message-ID: <Y5toZtbdxwgCTlFT@google.com>
References: <20221213062306.667649-1-seanjc@google.com>
 <20221214030037.4qz6v6fvfx6of32n@linux.intel.com>
 <Y5pn2fYf5eHu8yCb@google.com>
 <20221215112436.2iqizpso5loeficn@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215112436.2iqizpso5loeficn@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022, Yu Zhang wrote:
> On Thu, Dec 15, 2022 at 12:18:33AM +0000, Sean Christopherson wrote:
> > > 
> > > BTW, we may need another patch to remove the obsolete comments in
> > > nested_vmx_setup_ctls_msrs():
> > 
> > Ouch, indeed.  Want to send a proper patch?  Or provide your SoB and I'll write
> > a changelog?
> > 
> > The comment was added by commit 80154d77c922 ("KVM: VMX: cache secondary exec controls"),
> > but arguably the below is the appropriate Fixes, as it's the commit that fixed the
> > existing cases where KVM didn't enumerate supported-but-conditional controls.
> > 
> > Fixes: 6defc591846d ("KVM: nVMX: include conditional controls in /dev/kvm KVM_GET_MSRS")
> > 
> 
> Thanks a lot, Sean, especially for sharing the commit history.
> 
> And I just sent out a patch to fix it.
> 
> One question is about the process of small cleanup patches like
> this: would it be better off to include the cleanup patches as
> part of a larger submission, or is it OK to be sent seperately?

In this case, it's ok to be sent separately.  There are no code dependencies, and
the changelog can be written to say "this comment is no longer accurate", even if
there is still broken code in KVM.

> Previously I submitted some small patches(e.g. [1] & [2]) but
> have not received any reply. So I am just wondering, maybe those
> patches are too trivial and sometimes time-wasting for the reviewers?

They're definitely not too trivial.  This is just an especially rough time of
year for reviews, e.g. end of year corporate stuff, merge window, holidays, etc.

Part of why I haven't provided reviews is that the patches _aren't_ super trivial,
e.g. I'm on the fence on whether mmu_is_direct() should take @vcpu or @mmu, and if
I vote to have it take @mmu, then that'll conflict with mmu_is_nested().  So I end
up staying silent until I can come back to it with fresh eyes to see if there's a
better alternative, or if I'm just being nitpicky.
