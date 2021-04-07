Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63390357289
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 19:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354423AbhDGRAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 13:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343608AbhDGRAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 13:00:07 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B028C061760
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 09:59:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so1647801pjg.5
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 09:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=Qka4XP86mo9tivOZXeavKjVRjtUNs3I7vqQxIv9BF4o=;
        b=sKeG7jF4DC6TkXssMwfoL5Yb2M1BIPx0VHweK89YLof7HVvwYTDocHqwKP9iyPbezs
         eBMc5Fx/A7j66s9Pr/5DHJYgatXOlXejrVfzhzwyPWOfpEH/2OhT3qyGDFRCVxiVW5cH
         jj49DGK2wrNlvBo44yjLpWvx3KfAQktiCjCPQ54YSK0ylxusD7IiO/AmCxv9jx4Ak6Of
         g5U5BoNKlaCYQ2dMW3D2isrgvjyEw70ZJwI+I37gxZJMTvnyRRoUnWyUfbkdCitbiH/8
         R675Wd6nzsuPnsOR6DGaLMsmk3g2Nx/MQvR0+IH6P6a1YlP2TLdodzEWCrOVjV7mTr+L
         ORRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=Qka4XP86mo9tivOZXeavKjVRjtUNs3I7vqQxIv9BF4o=;
        b=fHXEQFFZHm6Zn7ECbEEwbxdaHMt2yHWeHrBnph6Fu2RBNz2iWITYd/P6Q+az2Wk9gR
         aE6UxVs0rGta6EfTstFH3/0Qz5hdGEBKK6dd3BUJEIGb91h/hf2EGfYlPF+HJEbSoYxj
         s24cMvL5rrQ1eHr1PCn2Gshuc14Vcob3WDZIftZqYn3QS69TScCIgqmQRiXGAGt+Dhiy
         xdYscSQ85VlExvHZ8KZD/jyUiuqUxaTsSMg9CRdHS962fWdcw6ctkfqtDyvQtC9N5G8C
         Du3mODzRP59r0wnJq0BXmvBxy+daMNOqVG4Y0UF2rkT2EkfYUeZye2RDaNmPK7iJRAmV
         dp7A==
X-Gm-Message-State: AOAM532KZohZvICpIoQOgdAssOX8Jjbb++UCJFAjEK7pheMS7dz50YGK
        OsosNySTDKnz6J48QwbaQ/sQYBcXNVAMbw==
X-Google-Smtp-Source: ABdhPJwRHR+AB/msn9dCF+HMY/knTGJpePFjMSnYGVO76q0g1jJjsff5eYDRDkH7v8g1ezxKMhfgdQ==
X-Received: by 2002:a17:90a:7064:: with SMTP id f91mr4337107pjk.89.1617814796875;
        Wed, 07 Apr 2021 09:59:56 -0700 (PDT)
Received: from [2620:15c:17:3:c4a4:628a:2d06:e140] ([2620:15c:17:3:c4a4:628a:2d06:e140])
        by smtp.gmail.com with ESMTPSA id u1sm21982451pgg.11.2021.04.07.09.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 09:59:56 -0700 (PDT)
Date:   Wed, 7 Apr 2021 09:59:55 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
To:     Sean Christopherson <seanjc@google.com>
cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <kernellwp@gmail.com>
Subject: Re: [PATCH v2] KVM: Explicitly use GFP_KERNEL_ACCOUNT for 'struct
 kvm_vcpu' allocations
In-Reply-To: <20210406190740.4055679-1-seanjc@google.com>
Message-ID: <bed5081-1f13-bc1e-6328-b2bb4517c54@google.com>
References: <20210406190740.4055679-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Apr 2021, Sean Christopherson wrote:

> Use GFP_KERNEL_ACCOUNT when allocating vCPUs to make it more obvious that
> that the allocations are accounted, to make it easier to audit KVM's
> allocations in the future, and to be consistent with other cache usage in
> KVM.
> 
> When using SLAB/SLUB, this is a nop as the cache itself is created with
> SLAB_ACCOUNT.
> 
> When using SLOB, there are caveats within caveats.  SLOB doesn't honor
> SLAB_ACCOUNT, so passing GFP_KERNEL_ACCOUNT will result in vCPU
> allocations now being accounted.   But, even that depends on internal
> SLOB details as SLOB will only go to the page allocator when its cache is
> depleted.  That just happens to be extremely likely for vCPUs because the
> size of kvm_vcpu is larger than the a page for almost all combinations of
> architecture and page size.  Whether or not the SLOB behavior is by
> design is unknown; it's just as likely that no SLOB users care about
> accounding and so no one has bothered to implemented support in SLOB.
> Regardless, accounting vCPU allocations will not break SLOB+KVM+cgroup
> users, if any exist.
> 
> Cc: Wanpeng Li <kernellwp@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Always happy to see this ambiguity (SLAB_ACCOUNT vs GFP_KERNEL_ACCOUNT) 
resolved for slab allocations.

Acked-by: David Rientjes <rientjes@google.com>
