Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFB34FE7C8
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 20:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356974AbiDLSWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 14:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358681AbiDLSWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 14:22:04 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B799831528
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 11:19:45 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id cj5so2457371pfb.13
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 11:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X8mJ2ojcIe20g/huptYO9qfRt1S1C1vtiT7bWUcTZ3Q=;
        b=leH/Qwl5H1Y7XXLFtPPMYEnzfeaIH8QIF0J+gpIJHCwJpre2uZZc62aPiewTzDBBcy
         JY9pS5TZ9EzEt6MGJJON1sJYfwU68sj7EHy8wlUqKInlU00uwpEU3msjQTUeK8/aEJ4g
         yfQSTnAdTbCf+PGblKqn5gLuh2EbjSRHh0yPJD9U8nK1zOeTbnCt3VGuz27aZgMA/PLj
         CM5HXJp/ggDvDYNKw9xFQd4/+kvaH2/X1jVbvwJTG/oTT+/YloeDkokkIdRv05TU/LiL
         +K7zBOrZ5dlf+I47NESFEkkrm6Wr0EKQE+Utya835/dvU6de8SLeB0T+AAy6LAZMjZbZ
         +WJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X8mJ2ojcIe20g/huptYO9qfRt1S1C1vtiT7bWUcTZ3Q=;
        b=dnMR1Un09osXs5GYcide9ztrsoLFFcL0HlgfubJX/ISMgKSFvriUm9nDiN3b3HyuIP
         BI0HCnUtkW+SpcaJ7wax0T4no5DhlUqXRwjLIck3xPEEjegMVCZDm6YRZYn+sOpNxFGU
         mO2ZNIW5+AjMn67Mojbho1Ghlde+40JWYLPYxEuYTwxYlurKEgR5CHxsQxrT65WTDu4r
         qWfGhoZL3OCEWVZMQLmXkeOxXLxQHBaTYT/negvqig8mygySe0wzxFCMG/azBcwpIyg1
         yOvbpma/ryMxccGb10Ig9VYGqkyy6mIgd5EOMubh/bGULh+7fYqZ6ZHK1zSpvnjizO8o
         E1Ng==
X-Gm-Message-State: AOAM531tkxnCQvE9w7yEcmtUJLLEX2jA06YFr65lqXKeL9iBsCD0fwP3
        WqkH6TXKCnIOQK+T3ApS/9YbwLjDfT3h5A==
X-Google-Smtp-Source: ABdhPJzbeWw9e8fnoxeV4yZVYuSqRzeP72JoDpYopmyS4PDHKsfhv543wj3nzNZTVIxoFswrRZwciQ==
X-Received: by 2002:a63:931e:0:b0:39d:9d36:545d with SMTP id b30-20020a63931e000000b0039d9d36545dmr2744848pge.511.1649787585067;
        Tue, 12 Apr 2022 11:19:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b5-20020a056a0002c500b0050600032179sm2925084pft.130.2022.04.12.11.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:19:44 -0700 (PDT)
Date:   Tue, 12 Apr 2022 18:19:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jue Wang <juew@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Add support for CMCI and UCNA.
Message-ID: <YlXCvEevoCZPj9Ba@google.com>
References: <20220323182816.2179533-1-juew@google.com>
 <YlR8l7aAYCwqaXEs@google.com>
 <390f6cd9-1757-b83c-ab97-5a991559e998@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <390f6cd9-1757-b83c-ab97-5a991559e998@redhat.com>
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

On Tue, Apr 12, 2022, Paolo Bonzini wrote:
> On 4/11/22 21:08, Sean Christopherson wrote:
> > > +			if (!(mcg_cap & MCG_CMCI_P) &&
> > > +			    (data || !msr_info->host_initiated))
> > This looks wrong, userspace should either be able to write the MSR or not, '0'
> > isn't special.  Unless there's a danger to KVM, which I don't think there is,
> > userspace should be allowed to ignore architectural restrictions, i.e. bypass
> > the MCG_CMCI_P check, so that KVM doesn't create an unnecessary dependency between
> > ioctls.  I.e. this should be:
> > 
> > 		if (!(mcg_cap & MCG_CMCI_P) && !msr_info->host_initiated)
> > 			return 1;
> > 
> 
> This is somewhat dangerous as it complicates (or removes) the invariants
> that other code can rely on.  Thus, usually, only the default value is
> allowed for KVM_SET_MSR.

Heh, I don't know if "usually" is the right word, that implies KVM is consistent
enough to have a simple majority for any behavior, whatever that behavior may be :-)

Anyways, on second look, I agree that KVM should require that userspace first enable
CMCI via mcg_cap.  I thought that vcpu->arch.mcg_cap could be written via the MSR
interface, i.e. via userspace writes to MSR_IA32_MCG_CAP, and could create dependencies
within KVM_SET_MSRS.  But KVM only allows reading the MSR.
