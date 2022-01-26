Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E787E49CF3E
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 17:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238530AbiAZQIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 11:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236433AbiAZQIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 11:08:09 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC9EC06173B
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:08:08 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id g2so21501487pgo.9
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RXbr9ZV0Py1ZrZ3gePRRUjbiJrxRVqlHjZYB9UaSH3c=;
        b=hsj2vCaycqgImUlDVo/2tN6tdut4f4lJogQ3VzmgwHjxJ8fsgs6S8lrRUME699j7KM
         WhNzh3Kpehe9jy3sn4AdPT1GbqOUP808iCWHWbpHW8/B06Ij6i3vjFtX6rY3LS0KrHDw
         OhfwHHtEUc17ZFoaLuGrQYbkDFnokSeKEwCgIy09YsA+0BSfKv5OsUvaL5JVWedkwgC4
         Sa91RGLcaG00AOcUCCgygiLOI5QUKUmgSgHXiF0ccNYswh++H/XckpSWL7X2P87hZEc5
         R8l/quDbDS0KOaJ+z1XSBvqLBlY2lxSNx/quUl3f/Te5xAU3W2Nv9YDDX85KOyTZhZUM
         kDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RXbr9ZV0Py1ZrZ3gePRRUjbiJrxRVqlHjZYB9UaSH3c=;
        b=KxH1YAFbPnHXeemsSAVvp8+Tt4ddQK9MfUnCG0jZOlkgc7vpZc3grldjqRj5TVKy33
         9FOlf5rfBYmiisEo6gqWXk/kJ7rqwMi2+RPbh467m+Jb+MZwblqA8PFn0q5jsbsLRD0H
         63U0jPpVK8WkGjzBirkKy3wVfpRnmCJJ5q+VnCbFd193K9oXZqP7XTeoZILdbY/79zW2
         kSYmwv2F7wAtL4dHzBBVT50A1OK3jgjHNj4/prxLvKQyYaQhb+BciJx4U6aPWrs61j0W
         gE1aIaVXMIa5vMiZaeEoZA4qbttrsEOZNPjJ/oTtAbC3vKK1/iLvmgJBDcBcZudXR85S
         woAw==
X-Gm-Message-State: AOAM533qE0IcshEMb75sOuwbda8irTUhR2eL6VEqLE6kTkCORBDB4iSr
        H05tBJfqmt1WfrW+pL/2CqeIQA==
X-Google-Smtp-Source: ABdhPJy5BvxtkYVC/XIW5ZxQCaspp66xlzK/p2zYKQaW31dS3ics9CHm2fQLWB8jT8Z3Jglzoat/lg==
X-Received: by 2002:a63:f610:: with SMTP id m16mr19556229pgh.69.1643213288237;
        Wed, 26 Jan 2022 08:08:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y13sm11923042pgi.8.2022.01.26.08.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:08:07 -0800 (PST)
Date:   Wed, 26 Jan 2022 16:08:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86: Forcibly leave nested virt when SMM state is
 toggled
Message-ID: <YfFx5LZ2rMMtbDWG@google.com>
References: <20220125220358.2091737-1-seanjc@google.com>
 <7eb8c6722a522e42f8e8974c084c7cab3098d9fa.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eb8c6722a522e42f8e8974c084c7cab3098d9fa.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 26, 2022, Maxim Levitsky wrote:
> On Tue, 2022-01-25 at 22:03 +0000, Sean Christopherson wrote:
> > Peeking at QEMU source, AFAICT QEMU restores nested state before events,
> > but I don't see how that can possibly work.  I assume QEMU does something
> > where it restores the "run" state first and then does a full restore?
> 
> Well, according to my testing, nested migration with SMM *is* still quite broken,
> (on both SVM and VMX)
> resulting in various issues up to L1 crash. 
> 
> When I last tackled SMM, I fixed most issues that
> happen just when the L2 is running and I inject flood of SMIs to L1 - even that
> was crashing things all around, so this might be as well the reason for that.

Heh, that would certainly explain why QEMU's code looks broken.  Thanks!
