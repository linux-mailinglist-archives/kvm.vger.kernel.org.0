Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072E2594E41
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 03:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiHPBg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 21:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiHPBgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 21:36:07 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A3BE727F
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 14:26:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ch17-20020a17090af41100b001fa74771f61so210812pjb.0
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 14:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=s6C7xjGZFgkJFr5KfYkyBRVqHeZGBiLrMu8lM2DAdGc=;
        b=AG3J8t9JIoa5aHNcIfU8Afi648JK1hym91JEPUZ0dSFr5Vu5y1F0zIWj3okus4yq7j
         8SrjoNQWRS//nsxmvCMkWk5+ZtML4OympnohBF9ZypJ8vl3UZvWN6IWIIFXPyNQCw1PI
         ucQrEA19LX2XEiWOCgX4GP+56VU6Fg+OsQ8WCf2ae6sSq2c0PCH0rSS7aYW8rMg6949Y
         46jOZtF9nXRcO3kDvuQpcCjcdnmbi6fI43+d2V1+EJk6zApr7+iOgtfTnxXurQoQ5YSI
         iZJ4cd/1gtdUwzdgm7U6lWdHkdrKAPobffvwMvfHC7Fh5oAzxw+sZQqSq2Mjlarza+pI
         0NxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=s6C7xjGZFgkJFr5KfYkyBRVqHeZGBiLrMu8lM2DAdGc=;
        b=3iZ6WxW5spmdkFLp6WLzXbS3ZKRMuLgU0xIjyl949hC2ReXtq+jMS2RYA48vjieKbi
         Lid+pYh0ceeLCV6H8m+GVg9Jus2Meqx04j+nzqckhROGqSu3AM8Hb8wz4MhjGcSu0Rgh
         1w9hCXOKQkyAyO57YlbYEDPMYY76zyB6cOo4ZOyg5pl/KhbWHWfqAZpEfITFPjpb63pW
         oLWKRbaYVqZxCAugQOsk00bXhLLuTyABjPv+BvjlVbhJB5i6cEmojvLIFYekM7zkBWP1
         FGzmQe/d7r9ru7FG2cduOjWX4Qt/uT27JmpYgpwdBJaVbUx4Es5hxhPvUdYzQy9O7zfF
         iyxw==
X-Gm-Message-State: ACgBeo28HNGQBxG9pPcxO+oKiAQCgvkgByyV6kmzOusORbw5giuYZxZc
        SU5UfoXYIU83eHZY+UROUYMFJg==
X-Google-Smtp-Source: AA6agR5M/rTTm9t+DDlIhUOT49cx0BFsQgd8Bv4U1FkQ3NT1pVtZbfkGUWydTZW3Wa2xY49yXK93gQ==
X-Received: by 2002:a17:90b:164b:b0:1f5:15ae:3206 with SMTP id il11-20020a17090b164b00b001f515ae3206mr19855063pjb.140.1660598802001;
        Mon, 15 Aug 2022 14:26:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w12-20020a170902e88c00b0016a6caacaefsm7476713plg.103.2022.08.15.14.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:26:41 -0700 (PDT)
Date:   Mon, 15 Aug 2022 21:26:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v2 3/3] kvm/x86: Allow to respond to generic signals
 during slow page faults
Message-ID: <Yvq6DSu4wmPfXO5/@google.com>
References: <20220721000318.93522-1-peterx@redhat.com>
 <20220721000318.93522-4-peterx@redhat.com>
 <YvVitqmmj7Y0eggY@google.com>
 <YvVtX+rosTLxFPe3@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvVtX+rosTLxFPe3@xz-m1.local>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022, Peter Xu wrote:
> On Thu, Aug 11, 2022 at 08:12:38PM +0000, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 17252f39bd7c..aeafe0e9cfbf 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3012,6 +3012,13 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> > >  static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > >  			       unsigned int access)
> > >  {
> > > +	/* NOTE: not all error pfn is fatal; handle sigpending pfn first */
> > > +	if (unlikely(is_sigpending_pfn(fault->pfn))) {
> > 
> > Move this into kvm_handle_bad_page(), then there's no need for a comment to call
> > out that this needs to come before the is_error_pfn() check.  This _is_ a "bad"
> > PFN, it just so happens that userspace might be able to resolve the "bad" PFN.
> 
> It's a pity it needs to be in "bad pfn" category since that's the only
> thing we can easily use, but true it is now.

Would renaming that to kvm_handle_error_pfn() help?  I agree that "bad" is poor
terminology now that it handles a variety of errors, hence the quotes.
