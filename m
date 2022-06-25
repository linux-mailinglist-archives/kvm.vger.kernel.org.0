Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F6755A5D6
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 03:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiFYBXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 21:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiFYBXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 21:23:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7598D15FEF
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 18:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656120191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7XLzZJXOdWaEWC8BB0Bij+Fr78R+fiLBcMspKDhyed8=;
        b=FolPKYZb/693Kpf66xPNF5oLCdQkOcNTC2qj8gFkhXXg3BITtkWzs11wjwnhhZ2x/30jS4
        Q94nGWUpcC85JDjkALakobHkqyVLYVUnop0/unTNaTLjK5FOxUPBnwydMvx98OUl+7hAHX
        Tn91n7V+kUiEaIcPHBmcJfgWvK7Y0Q8=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-yiSOd5fuPSWY5pwI8Mv8vg-1; Fri, 24 Jun 2022 21:23:10 -0400
X-MC-Unique: yiSOd5fuPSWY5pwI8Mv8vg-1
Received: by mail-il1-f199.google.com with SMTP id b11-20020a92340b000000b002d3dbbc7b15so2565474ila.5
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 18:23:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7XLzZJXOdWaEWC8BB0Bij+Fr78R+fiLBcMspKDhyed8=;
        b=pzCZqgStmSewQaeQj3rMBDFoCxmnQVEg0i/P3PPDmzIDMx2aU/3i6GWQs5lmTNje3o
         X52xO0NqgU2eqp/YcGKqJ1a2FLZwkYq02p6EH8xXdKs3YxK6vOnnlNUW4yczq/nFLjgO
         9ZPcvZLC3w6RJos/L47d3Ti2h3jSlzvZZv9QLDaDk1K2gTZ8EI6JhRPsU7DV8gm1MUGr
         6RzcVK47zJphh39UPgtyYws5kvwlSuil5mJhfvPej4b18W/YSFYR7Yc1NMlWaI9IoblJ
         xs5KqzNrOjz3uDWEDkwz646ZZCkETl1asFnZ5oLa7scPGA+FT2CKtmpA7W/yJ5uRh8le
         3jkA==
X-Gm-Message-State: AJIora+ghGzuvNluO4+VAfw9kxmKUzznEhHIcV4jU2B0WP/Mt745Yy6A
        PdBrrwUUp1WdSS24LtCiAdsLfw2gFPS4TqJue+C+NTs1VJyWmldlwIaPPtgSDO4x/rX6vFT0/ed
        hx/2+60JLAOVP
X-Received: by 2002:a5d:9291:0:b0:669:d90b:24e0 with SMTP id s17-20020a5d9291000000b00669d90b24e0mr911540iom.53.1656120189522;
        Fri, 24 Jun 2022 18:23:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vU+hqUMZ39OLtBJ83hd5BrE2EQXNCbPmdU+o5BGQ4i9ivzq9fjRpN79r5OZj+RHPH35LRgzA==
X-Received: by 2002:a5d:9291:0:b0:669:d90b:24e0 with SMTP id s17-20020a5d9291000000b00669d90b24e0mr911528iom.53.1656120189246;
        Fri, 24 Jun 2022 18:23:09 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id t16-20020a92dc10000000b002d94906dacfsm1739700iln.67.2022.06.24.18.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 18:23:07 -0700 (PDT)
Date:   Fri, 24 Jun 2022 21:23:04 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Message-ID: <YrZjeEv1Z2IDMwgy@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
 <20220625003554.GJ23621@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220625003554.GJ23621@ziepe.ca>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jason,

On Fri, Jun 24, 2022 at 09:35:54PM -0300, Jason Gunthorpe wrote:
> Can you talk abit about what is required to use this new interface
> correctly?
> 
> Lots of GUP callers are in simple system call contexts (like ioctl),
> can/should they set this flag and if so what else do they need to do?

Thanks for taking a look.

IMHO the major thing required is the caller can handle the case when GUP
returned (1) less page than expected, and (2) -EINTR returns.

For the -EINTR case, IIUC ideally in an ioctl context we should better
deliver it back to user app this -EINTR (while do cleanups gracefully),
rather than returning anything else (e.g. converting it to -EFAULT or
something else).

But note that FAULT_FLAG_INTERRUPTIBLE is only used in an userfaultfd
context (aka, userfaultfd_get_blocking_state()).  For example, if we hang
at lock_page() (if not go into whether hanging at lock_page makes sense or
not at all.. it really sounds like a bug) and we receive a non-fatal
signal, we won't be able to be scheduled for that since lock_page() uses
TASK_UNINTERRUPTIBLE always.

I think it's a separate problem on whether we should extend the usage of
FAULT_FLAG_INTERRUPTIBLE to things like lock_page() (and probably not..),
and currently it does solve a major issue regarding postcopy hanging on
pages for hypervisor use case.  Hopefully that still justifies this plumber
work to enable the interruptible cap to GUP layer.

If to go back to the original question with a shorter answer: if the ioctl
context that GUP upon a page that will never be with a uffd context, then
it's probably not gonna help at all.. at least not before we use
FAULT_FLAG_INTERRUPTIBLE outside uffd page fault handling.

Thanks,

-- 
Peter Xu

