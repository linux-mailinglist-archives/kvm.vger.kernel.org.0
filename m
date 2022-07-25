Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2ACD58082D
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbiGYX10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbiGYX1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:27:25 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6951026561
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:27:23 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 12so11460367pga.1
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LBRZcpT2Oj7kZwiIgXTNapPpF8SACvWYM09RAzea9XQ=;
        b=h+5ZbQek7/GzuRNvS4l7gk1bhglJKDpog5wTMzwBryAuiqfghqCO5v6L1zSWDtLQXP
         mNpSjOm/8xh/qiD+OrTLt9WI244jmkaeoc5jMl5PShmxLxgv9+XiCjQSxwhg74i3QQyO
         KuU5V4lF1zcRfEUKMsu+RKFMyl8W77IFbaaZ/by6j3PhSSa7fLdZb2laJLEhFCBvYoZC
         rYhoAR3XPqVU1/4rlSPAm7nLpSXhmHHrIZbDIBNUw2i8RsgTxMX6G/9AtyBosZOs6xVJ
         JVqMkG4orZ1meAcN8hOnAoTR7oszSMN3qYErztmQnlB7OyAvUg5tEO65VrbRDo4mY47U
         wE7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LBRZcpT2Oj7kZwiIgXTNapPpF8SACvWYM09RAzea9XQ=;
        b=ywXEWpt9ZSXpkxbEnfOopwFZOcrsrF5/7hGJ5NYzWhaKqvxBrdaL/qXNcYsjtHY9H8
         CkSIYY/PzUIbi8DUpEt1mcQEK7mwWOhMBg8Rg8XyCDNoEkgA8MT//+zucrUVANbOgGSw
         vuLTY7MhOby8ZQVB96Q8eg4JU4PeIuwzaz48pGRN4v5nzq+UrfMqGKELQi3D7WP+URXO
         VBF1j2RQv1+SyU9yWnESotLqXEV4w9bFI8rZ3QAIsrcSqXwWVSDzyUgvPZg77KlfALAb
         uwaJmzXvYvjieQDtitfgjKTOm1+t6G+d8dy5YTuNDL7vajgM+rCZCgV80IKUQNFeIlOm
         AFzg==
X-Gm-Message-State: AJIora8qwxeoowodPqLOjoEJw0IzFATOGFDcc6tCQlAxot4Jw5U+9EAs
        T6XSFKPhatvdJP5+haSLH8AbSg==
X-Google-Smtp-Source: AGRyM1utPTWf9Vi46bEzSrtsWzdtYwfeWkY7II53X8Dvxv0h3Ky7x/hNmaLI7CBFX649RC1wA9K6Pg==
X-Received: by 2002:a05:6a00:bcb:b0:52b:34e3:c043 with SMTP id x11-20020a056a000bcb00b0052b34e3c043mr14899628pfu.64.1658791642874;
        Mon, 25 Jul 2022 16:27:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b14-20020a170903228e00b0016d3ee4533csm7868349plh.18.2022.07.25.16.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:27:22 -0700 (PDT)
Date:   Mon, 25 Jul 2022 23:27:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Track the number of TDP MMU pages,
 but not the actual pages
Message-ID: <Yt8m1xWgwLP1Ecw9@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-5-seanjc@google.com>
 <Yt8lZGrU0wqrPi5j@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt8lZGrU0wqrPi5j@google.com>
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

On Mon, Jul 25, 2022, David Matlack wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 246b69262b93..5c269b2556d6 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1271,6 +1271,9 @@ struct kvm_arch {
> >  	 */
> >  	bool tdp_mmu_enabled;
> >  
> > +	/* The number of TDP MMU pages across all roots. */
> > +	atomic64_t tdp_mmu_pages;
> 
> This is the number of non-root TDP MMU pages, right?

Yes.
