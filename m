Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7D049D4BD
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 22:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiAZV7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 16:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiAZV7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 16:59:07 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A399C06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 13:59:07 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z10-20020a17090acb0a00b001b520826011so5572818pjt.5
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 13:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KLxy2RA9O589B5bqVF7T23ZIRWWhfTa26CR5m6El2ic=;
        b=K4WyuIJTLrS5dww1gw4pvfiFpVbDPlTDduBTbG6CzjACuzu4Eab/UjnXiTL7I9Ckc7
         hKua9rYj5QqQX4XBHqIC1N4ufMTU+AxRuzwbJmJjOv8A7eloPbZ7lGhGl+ed5Mutp+FQ
         T4MefO030ABYqZBfZNrwy8Nwt9iiR8np8Lghm+uALLhTatp+lcZP46KXeLVctT5DrNXY
         Ywvwy4fNeXT5NZpCLq2zgYRJvvfNCrO+Gi+wWpMbzkoKxZqWqOam5BCwieNHQ8ZFHP3d
         MTAiVOnG28INTcYlDQi64tcL0JvJWPl4zVDHXSRNIyVrahbZHopTnOgSo1ZX/EzjehJc
         vPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KLxy2RA9O589B5bqVF7T23ZIRWWhfTa26CR5m6El2ic=;
        b=pLkBPRAy1in/MbVFXqGHciF6s0+QkUeM3mgIZcKuaurSudJlgvxZ3quuZYzt46RpXR
         9jH1MZvpJPUqTpXZSAZdENPvR7se6NdBImti6tPwof6gtfj0vtSCtPErWN5N04VDbzdR
         XYCf1HPaczWyegB6C5Mnx3/PtP8maqsC8/lGyqdYdLP6g4Ot2OC7MIknOlQAhdf6rtLf
         xDlt+4kZpoIrq2/YsC30HRG2sTmWiOo/T5lmLpFVN/3kKJ6TP04SIPfL2xOfmzXJzgqf
         p1hyo9HkFLkqPPOJ5C7J00+GjxUWkZCpNdZ1th+25I1aNeE7fTUrfmcJmXx8ujGlGTnK
         VHzA==
X-Gm-Message-State: AOAM530wGnaHilCx1GXIvx6VAsJ02Oo5ojM5+mog2zPBpOLNUk+BfCTI
        h0hwmQhV1IFcyHQePnlPeCXiPQY70+GCCA==
X-Google-Smtp-Source: ABdhPJwkvKTHRVNDftkeWKZyDaowYMbsX++JS95ehMmg+mxJpRkaeumQ89qRo4ExLGm2d8AWDOwK+A==
X-Received: by 2002:a17:902:f68e:: with SMTP id l14mr484264plg.164.1643234346604;
        Wed, 26 Jan 2022 13:59:06 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ms14sm197499pjb.15.2022.01.26.13.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 13:59:05 -0800 (PST)
Date:   Wed, 26 Jan 2022 21:59:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Boris Burkov <boris@bur.io>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kernel-team@fb.com
Subject: Re: [PATCH] KVM: use set_page_dirty rather than SetPageDirty
Message-ID: <YfHEJpP+1c9QZxA0@google.com>
References: <08b5b2c516b81788ca411dc031d403de4594755e.1643226777.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08b5b2c516b81788ca411dc031d403de4594755e.1643226777.git.boris@bur.io>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022, Boris Burkov wrote:
> I tested this fix on the workload and it did prevent the hangs. However,
> I am unsure if the fix is appropriate from a locking perspective, so I
> hope to draw some extra attention to that aspect. set_page_dirty_lock in
> mm/page-writeback.c has a comment about locking that says set_page_dirty
> should be called with the page locked or while definitely holding a
> reference to the mapping's host inode. I believe that the mmap should
> have that reference, so for fear of hurting KVM performance or
> introducing a deadlock, I opted for the unlocked variant.

KVM doesn't hold a reference per se, but it does subscribe to mmu_notifier events
and will not mark the page dirty after KVM has been instructed to unmap the page
(barring bugs, which we've had a slew of).  So yeah, the unlocked variant should
be safe.

Is it feasible to trigger this behavior in a selftest?  KVM has had, and probably
still has, many bugs that all boil down to KVM assuming guest memory is backed by
either anonymous memory or something like shmem/HugeTLBFS/memfd that isn't typically
truncated by the host.
