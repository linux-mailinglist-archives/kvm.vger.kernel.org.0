Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F39505C52
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 18:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346055AbiDRQUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 12:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbiDRQUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 12:20:05 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BA42CE11
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 09:17:26 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id j71so6190442pge.11
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 09:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/1uUNVci0qIn0YYzjZTRHTLzpktyiWsbrO4Jd0320Kw=;
        b=YNlYOX8OZrFE1EX2zjkrcu7/Xk3yn9mq4h3KA/NkCdgYZOBhj+aHBBUh5w++lFTQib
         dPwTHqwzihdFtn3CdHKjzn9XsGuj3u4iVQLue5sDNSrM/CP0ktjuEXElRXMkPN7aLerP
         3vltDaFh/8xfNuKXtL6sXitBPg4Dgx3AhlSXJkkTOxOuwrxJLbGfMIK0H2ELv8acUFdZ
         tzmAcytUfnlQ9MPa/FQWmhamw2T0hyfQdiqvuWAwksA9vlJq0GT+4eOJxHIKEeXu7Fx1
         HI7wF8SHxgM8x9wBwKDZg2C6L6zdp1l90vP4EnNdSc4N4B2K3FmfP3o8R1nekmS9/sDM
         ogPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/1uUNVci0qIn0YYzjZTRHTLzpktyiWsbrO4Jd0320Kw=;
        b=A0hUCE2tW8UWKx06o8oFGdpds75lN1HDqeXna2eW/RHjxniGwtljzgQwv68v96NMWn
         zIymumS4ajId/92LACqjus7C44yGGOqr8UAJPSNTFEdOsSAtdAch9inUU0UD3akdw5he
         roS/nTBZbCDgWjTVLFw1RNr4lY4VV0fsjB7F0OLaB4nb8TOJ5VSch/1MJGrkPx8lNtis
         Jbir3TrGvKAromAgRoDk9bvcoRU3LtRzngruwoMII0Y8McQDQSSpeKtlPVx6iIPOqB+E
         u2kQH+aHnEhLz/aA6erKW7ljsypzU25Pf78AEV4w9bCVmFDA8ZM4GYcDtL0fvooAYjqS
         9+VQ==
X-Gm-Message-State: AOAM533gpRjSrqo1mi8og85Uzq9F1KT29se746m34YTCJuUhbZ2ONtA1
        9S/m7HTwyieiAfAOtwz2/qxVHNHeXNmxhQ==
X-Google-Smtp-Source: ABdhPJx3wdpuwNFjtcc37qlw/QgYQAPo+0oPb4GNCdgYeXRlZ5iNwJproNy68jSx5XZaj7Us7QtClQ==
X-Received: by 2002:a63:ad45:0:b0:382:2459:5bc6 with SMTP id y5-20020a63ad45000000b0038224595bc6mr11102015pgo.474.1650298645458;
        Mon, 18 Apr 2022 09:17:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b001cb87502e32sm13349456pjf.23.2022.04.18.09.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 09:17:24 -0700 (PDT)
Date:   Mon, 18 Apr 2022 16:17:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 3/3] KVM: selftests: Add selftests for dirty quota
 throttling
Message-ID: <Yl2PEXqHswOc2j0L@google.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-4-shivam.kumar1@nutanix.com>
 <3bd9825e-311f-1d33-08d4-04f3d22f9239@nutanix.com>
 <6c5ee7d1-63bb-a0a7-fb0c-78ffcfd97bc5@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6c5ee7d1-63bb-a0a7-fb0c-78ffcfd97bc5@nutanix.com>
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

On Mon, Apr 18, 2022, Shivam Kumar wrote:
> > > +void vcpu_handle_dirty_quota_exit(struct kvm_run *run,
> > > +            uint64_t test_dirty_quota_increment)
> > > +{
> > > +    uint64_t quota = run->dirty_quota_exit.quota;
> > > +    uint64_t count = run->dirty_quota_exit.count;
> > > +
> > > +    /*
> > > +     * Due to PML, number of pages dirtied by the vcpu can exceed its dirty
> > > +     * quota by PML buffer size.
> > > +     */
> > > +    TEST_ASSERT(count <= quota + PML_BUFFER_SIZE, "Invalid number of pages
> > > +        dirtied: count=%"PRIu64", quota=%"PRIu64"\n", count, quota);
> Sean, I don't think this would be valid anymore because as you mentioned, the
> vcpu can dirty multiple pages in one vmexit. I could use your help here.

TL;DR: Should be fine, but s390 likely needs an exception.

Practically speaking the 512 entry fuzziness is all but guaranteed to prevent
false failures.

But, unconditionally allowing for overflow of 512 entries also means the test is
unlikely to ever detect violations.  So to provide meaningful coverage, this needs
to allow overflow if and only if PML is enabled.

And that brings us back to false failures due to _legitimate_ scenarios where a vCPU
can dirty multiple pages.  Emphasis on legitimate, because except for an s390 edge
case, I don't think this test's guest code does anything that would dirty multiple
pages in a single instruction, e.g. there's no emulation, shouldn't be any descriptor
table side effects, etc...  So unless I'm missing something, KVM should be able to
precisely handle the core run loop.

s390 does appear to have a caveat:

	/*
	 * On s390x, all pages of a 1M segment are initially marked as dirty
	 * when a page of the segment is written to for the very first time.
	 * To compensate this specialty in this test, we need to touch all
	 * pages during the first iteration.
	 */
	for (i = 0; i < guest_num_pages; i++) {
		addr = guest_test_virt_mem + i * guest_page_size;
		*(uint64_t *)addr = READ_ONCE(iteration);
	}

IIUC, subsequent iterations will be ok, but the first iteration needs to allow
for overflow of 256 (AFAIK the test only uses 4kb pages on s390).
