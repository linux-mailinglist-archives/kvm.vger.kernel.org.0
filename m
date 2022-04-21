Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224C250A6DE
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 19:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390678AbiDURTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 13:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241462AbiDURTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 13:19:41 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEFD49F34
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:16:51 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id y16so3470064ilc.7
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 10:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XzhY22rtiJ4F18tBLtgYTs/jI9h0RWvVOlQ+tRau+5o=;
        b=pK42OJHT0CeEuc0jhItLyks4fe+Xnjx0pc5hU0u/pCXZcWmvdLl+OE/12crIT84m1F
         VJVkgDjOAeSiFct9qEntE2I7HQ1FsGWVdJ86FpnqgNsfTfFHKscoqGSRaypz7Xt4ApBh
         ZWPI/IJ+v4WeM4TVbVbI0n82DvePsALfkbz2hG6tI9YDWgnZK9vxY7tbZj+zXBgU2Z5E
         oe3zu+r8g49xPpC22rBu0pNm4L+j/CKW6d9J3NRboLuKc2JLq8Hp75N/p14Gkc0TadDu
         Vi1nIgZNnu6KydVo6ByWz3Ztrc+m4Ejx2hSRQF+gUi4ZgBi6hO1FnbAGc8yqszaU6zwx
         Njag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XzhY22rtiJ4F18tBLtgYTs/jI9h0RWvVOlQ+tRau+5o=;
        b=gIhrFRZzOsnNIVXGFEgWfFqqm+3yT5+bMIx90/mb0XMpIpf4TJyQTI3oFeitOu7zgr
         Uw9xobwG28zvObYC+4fhycFhDWANoIMuN5SWE2B/Oek6IB62NRvO1tc32iSJYvYUxT8I
         r+EGEOM13JP/R5zgitBkR6qfTOgZeyTeDkI71LHhC5r8YskmCa7nhOtlP8Ecz8ofJcIK
         KWXfrCpJ44R6aStSR9yhrmAKv68NXXsIJQFbzqBcwft+E7ZpL/F18wuXfPaXPki7f7Rt
         pxzheOBRJoK1KLVvtJZYNjV8r0/k2zVxsq5jD1dUuQhA0jfaFMqJt/6femhghRjs//9U
         VLVw==
X-Gm-Message-State: AOAM5317JMHhk7xNC8FnzDlR/RZMUBoGoJ9QHP2BG9+JnnjyBKMwySw6
        mM4vzBAwO+m8bdKce3HYC6dFCQ==
X-Google-Smtp-Source: ABdhPJz6XkmJvX5hjmcdaIfdUbIKzuxRz6hJn/RCOLM3kCv4aIyILwYHTuG617IunDBh4Y458w/0tg==
X-Received: by 2002:a05:6e02:b41:b0:2cc:55ae:91b0 with SMTP id f1-20020a056e020b4100b002cc55ae91b0mr334271ilu.126.1650561410732;
        Thu, 21 Apr 2022 10:16:50 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id n12-20020a92dd0c000000b002cac22690b6sm12524629ilm.0.2022.04.21.10.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 10:16:49 -0700 (PDT)
Date:   Thu, 21 Apr 2022 17:16:46 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 10/17] KVM: arm64: Assume a table pte is already
 owned in post-order traversal
Message-ID: <YmGRfoVUuDZ2YTyc@google.com>
References: <20220415215901.1737897-1-oupton@google.com>
 <20220415215901.1737897-11-oupton@google.com>
 <CANgfPd-LZf1tkSiFTkJ-rww4Cmaign4bJRsg1KWm5eA2P5=j+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-LZf1tkSiFTkJ-rww4Cmaign4bJRsg1KWm5eA2P5=j+A@mail.gmail.com>
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

On Thu, Apr 21, 2022 at 09:11:37AM -0700, Ben Gardon wrote:
> On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> >
> > For parallel walks that collapse a table into a block KVM ensures a
> > locked invalid pte is visible to all observers in pre-order traversal.
> > As such, there is no need to try breaking the pte again.
> 
> When you're doing the pre and post-order traversals, are they
> implemented as separate traversals from the root, or is it a kind of
> pre and post-order where non-leaf nodes are visited on the way down
> and on the way up?

The latter. We do one walk of the tables and fire the appropriate
visitor callbacks based on what part of the walk we're in.

> I assume either could be made to work, but the re-traversal from the
> root probably minimizes TLB flushes, whereas the pre-and-post-order
> would be a more efficient walk?

When we need to start doing operations on a whole range of memory this
way I completely agree (collapse to 2M, shatter to 4K for a memslot,
etc.).

For the current use cases of the stage 2 walker, to coalesce TLBIs we'd
need a better science around when to do blast all of stage 2 vs. TLBI with
an IPA argument. IOW, we go through a decent bit of trouble to avoid
flushing all of stage 2 unless deemed necessary. And the other unfortunate
thing about that is I doubt observations are portable between implementations
so the point where we cut over to a full flush is likely highly dependent
on the microarch.

Later revisions of the ARM architecture bring us TLBI instructions that
take a range argument, which could help a lot in this department.

--
Thanks,
Oliver
