Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570502FDA54
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 21:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392728AbhATUBv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 15:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728509AbhATT7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 14:59:12 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3900C0613D3
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 11:58:25 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id m5so2878518pjv.5
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 11:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oJo4M6632K9snaVFDSf1XhUlP1UsmMayuk5fe53umD4=;
        b=G36BNaYtJB6cOJoO+cpkrFo5Rz9jEBz7sRhWIAY/mH8XN+L1MplSuDdMu05dGss2+a
         FWnFgtSL2g9zo8K2f0ne0cvRGXQXJ5zNq437oiHkqdLkiXzN2VbNYR+2tER3XvQk+ji1
         G7PoqF8r6rJniXOnWROmGVzbbgW6CBWPg9Zyg39tcc52LpcCmYsYhSNhrlnqJheOnZgK
         SZueUzaRCQeFBcKVKXWTjrHNqcbsYv5mJr1lH7nI5IUoDLvyloOSVtDgrmqLp1vHgwwK
         lIjv7zT4Jl+/gktHmyPUi6+y/tb+WgX6zJH2p5iqyNAG4fqQnVyQGXVPBhzMTZm9c2FE
         mzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oJo4M6632K9snaVFDSf1XhUlP1UsmMayuk5fe53umD4=;
        b=VX8QCsF+KXHg10oscWMfgmgUYqr+PGWDPl9yF8bos9RyLkenw1K5550QzPUzT1+l0R
         qkgvjgZxxHKJ5G2DM9Odno+wmsKDfWKJr6PJRJFN32wpKrBUsykVxtrtPWRAFvjHd64a
         m2fWo8D6R/ncVsNyw2hTBFJtyJyGYNj6L31xTw0fd23+oHKXO36GW2VMFGrLPONLXw6I
         niF9KsJxEZ2mzmEuvv3UawneU7Glq/HXt7fC7FyTyYsOTHeXx9CpT3Xm6wXVY3QknrU8
         5UL1zx48hlhyAgSFlCGCTbVVozrUYOQFOMCexio9zIrjgiXjDABRavYIKl/I/2eOWieE
         0rCw==
X-Gm-Message-State: AOAM533TWF22Pu4c9DzHFH3t74dknJamyUubB75zXqnrwORNI09OELI9
        +yH1WVEGdATASdERjUsFhXPLGxclbzCRgg==
X-Google-Smtp-Source: ABdhPJwCwKNfimf1xsCwD1k7DYvvlx0rSdT1gRA6HWHsXoJ1WS7/+jmqt8GZoVPe6rGidhNonVQPBg==
X-Received: by 2002:a17:90a:f692:: with SMTP id cl18mr1789209pjb.124.1611172705222;
        Wed, 20 Jan 2021 11:58:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w7sm3087741pfb.62.2021.01.20.11.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 11:58:24 -0800 (PST)
Date:   Wed, 20 Jan 2021 11:58:17 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 08/24] kvm: x86/mmu: Add lockdep when setting a TDP MMU
 SPTE
Message-ID: <YAiLWTc1nJv7KSZj@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-9-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-9-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> Add lockdep to __tdp_mmu_set_spte to ensure that SPTEs are only modified
> under the MMU lock. This lockdep will be updated in future commits to
> reflect and validate changes to the TDP MMU's synchronization strategy.

I'd omit the "updated in future commits" justification.  IMO this is a good
change even if we never build on it, and the extra justification would be
confusing if this is merged separately from the parallelization patches.

> No functional change intended.
> 
> Reviewed-by: Peter Feiner <pfeiner@google.com>
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Sean Christopherson <seanjc@google.com> 
