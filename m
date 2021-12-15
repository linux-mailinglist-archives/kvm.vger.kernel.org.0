Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A7A475D95
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 17:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhLOQec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 11:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbhLOQec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 11:34:32 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA50C061574
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 08:34:31 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id l18so15872920pgj.9
        for <kvm@vger.kernel.org>; Wed, 15 Dec 2021 08:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AodnMcrhfurDRXvg+KlMg2eQVGnGI9xtZpQ7ZuUK8m8=;
        b=X7VIoNq6wdD0tUsGI4klqfEBpzW20+HrFVbJJbf7uPOt/Yk5Rp9QMvSArRtwZ9Tavh
         tanMrH5gPGY9hAV2Ku8oPW2tmWWMNRDd6Mz/NS4XAP7EYTvLA+vSqBqwYVR5+iVoxx0a
         D7kZSJhehbhmdrbV9UTwVX6Tp9CQTBi0Jh1CcthjxDGX7RxchGcuG9Indrr6Gi4ovQhu
         135x2EnYT+YiRgU0LBac2zFY1fH0zeyB5yPQ3++iAqBUReu2XYKorPAa6bOPe1CGB4oU
         s5m4gDYkNcrvBglJvbKIS2Gw7PTg7PMNr8Fn83hgMblQFIHCfoij41ZUXBdIZCg8U2BL
         36FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AodnMcrhfurDRXvg+KlMg2eQVGnGI9xtZpQ7ZuUK8m8=;
        b=bvFEVDclaGKPPyFmBtCQE4QkH805/rW+Y/YzVofFCo0dn0TwN3pcYLNnjj2ZxTqr1I
         k6VyhlV+aTY/vVabI0BtC4f3ydIyfPG0cRv5QQ8yIiwW/kBxoTlZunPIlOwHApZsAPBX
         xg2gFtwh5OXkv2cFauSn2htGGRhf9doitv3Wm1AYHlabo1+G70soYNAVqu+7sXsuuf1C
         lhtYh+YvOCdtRrs7303dQryLJOOnsq3dmquzYvs6iy56vtZIqwzd5Tu0cUAQAYhBDFuw
         knLyliwBueOU2G8mMx7dCYu9MfrXWtHLoEC7hZmoB6jdQ6YDwXk2JzazhoyNzTNu5z7N
         SjpA==
X-Gm-Message-State: AOAM533vgogtEq5C8EKGW3EV4mcRE1HLGpjeB2jDSWHWYe9IUucbQ7p+
        ePMW4DQgOSULDWJEQW21T8NC7u4JGk+MxQ==
X-Google-Smtp-Source: ABdhPJxrZjyP3erhtLiZBw+JHyRvdezfBs/BBD3mHmwyGLzU03L8mN3c7dDAysadP9Xw3iwiTW3Mfg==
X-Received: by 2002:aa7:8717:0:b0:4a2:967c:96b with SMTP id b23-20020aa78717000000b004a2967c096bmr9782590pfo.14.1639586071273;
        Wed, 15 Dec 2021 08:34:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mq10sm3024732pjb.3.2021.12.15.08.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:34:30 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:34:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] KVM: Dynamically allocate "new" memslots from the
 get-go
Message-ID: <YboZE29SMR/EgLOL@google.com>
References: <20211215112440.GA13974@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215112440.GA13974@kili>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 15, 2021, Dan Carpenter wrote:
> Hello Sean Christopherson,
> 
> This is a semi-automatic email about new static checker warnings.

These are all ok, KVM is being clever and using implicit checks on pointers in
select flows, while using explicit checks in others.

> The patch 244893fa2859: "KVM: Dynamically allocate "new" memslots
> from the get-go" from Dec 6, 2021, leads to the following Smatch
> complaint:
> 
>     arch/x86/kvm/../../../virt/kvm/kvm_main.c:1526 kvm_prepare_memory_region()
>     warn: variable dereferenced before check 'new' (see line 1509)

@new is guaranteed to be non-NULL in the !KVM_MR_DELETE case.
 
> arch/x86/kvm/../../../virt/kvm/kvm_main.c
>   1508		if (change != KVM_MR_DELETE) {
>   1509			if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
>   1510				new->dirty_bitmap = NULL;
>   1511			else if (old && old->dirty_bitmap)
>   1512				new->dirty_bitmap = old->dirty_bitmap;
>   1513			else if (!kvm->dirty_ring_size) {
>   1514				r = kvm_alloc_dirty_bitmap(new);
>   1515				if (r)
>   1516					return r;
>   1517	
>   1518				if (kvm_dirty_log_manual_protect_and_init_set(kvm))
>   1519					bitmap_set(new->dirty_bitmap, 0, new->npages);
>                                                    ^^^^^
>   1520			}
>   1521		}
>   1522	
>   1523		r = kvm_arch_prepare_memory_region(kvm, old, new, change);
>                                                              ^^^
> Lots of unchecked dereferences

There's no true dereference, architectures are responsible for ensuring @old and
@new are non-NULL, either via explicit checks on the pointer or implicit checks
on @change.

>   1524	
>   1525		/* Free the bitmap on failure if it was allocated above. */
>   1526		if (r && new && new->dirty_bitmap && old && !old->dirty_bitmap)
>                          ^^^
> New check for NULL.  Can this be NULL?

Yes, when change == KVM_MR_DELETE.

>   1527			kvm_destroy_dirty_bitmap(new);
>   1528	
> 
> regards,
> dan carpenter
