Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79157373EAC
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 17:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhEEPht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 11:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbhEEPhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 11:37:48 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CC3C06174A
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 08:36:52 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y2so1300869plr.5
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 08:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uh5fnNg4PWYr5e3cV22y9vYtxdN1GmrpBB3SRm60g3I=;
        b=BAW6nWwMYE/qNeiD8Uv6sfc0s0VCmV87nng79Gp4ifLQZWxTEt+Y3n9e8mSwU41CON
         Kw/etwdSsl/FVeP+dqEkjelHig7+u5EXG+yBC1KAZ5wK13qIEmEV87+/Byfy8tFjitse
         +acufFHjk56KyNImGAzIj3gUWxS742gVQdMmIXnPT66Bq4k3fMvqqsxEA35GLH6xgGPT
         STUQiwE+dTla5M2kSkcGz0wy6RDlRGrS0q4atlyuSi6gFaOKXR1LriMnKepaK5eE572G
         Q9br1bd/QUse+1zRyqZIT3GlZ1jROgvt1I2z4Zb3RAoYjtaJWdWfOuXpoFufy7QvjIsl
         w/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uh5fnNg4PWYr5e3cV22y9vYtxdN1GmrpBB3SRm60g3I=;
        b=mS5Bk2eivq9MYjBoDz+HSt4c4LsbNsekKTJkTyXmeyFfLZ3d2IKF+yoYmZJkhQznOe
         SElSeTf05BvW090nYPxsLt3OjasD3J+0w/lo1ppUhN1dhfbSxbwObpn1p0eWiUky0iCx
         ORH31LFTmpmJpNJYJmsR7wLOvS+cnkT0X1RGnjd5wSHfvx+Rg52lukCfFlSfnhmSIbsE
         UEfoa5XVucw4vwpsJ67I10L1iF1G8jJI7WY6wa9laOMwiM2kHJIFyBQe9KQIp84rMFer
         dbugLGnBXryQ4ZzhvT8Sr0iZCM9vVXXWe1Wac/U6WRLtcy2xDRhj0XFuX3i+u+WnfTlz
         wgqQ==
X-Gm-Message-State: AOAM533cSbDGT7C/kN1Web8shitGo2zXCIuycR086oe9koF6SVck2Nnn
        VSF4dfgS+bYE6uyZTBMl8TGAEQ==
X-Google-Smtp-Source: ABdhPJwJshXIaDcc8ih2fcYI40swoQEQ4+4URUBGAeGDf8TBQWEjne7XmzoRhTQubVJItcu/gBjy1Q==
X-Received: by 2002:a17:90a:f491:: with SMTP id bx17mr12330618pjb.176.1620229011512;
        Wed, 05 May 2021 08:36:51 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c13sm1829446pjc.43.2021.05.05.08.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 08:36:50 -0700 (PDT)
Date:   Wed, 5 May 2021 15:36:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 11/15] KVM: VMX: Disable loading of TSX_CTRL MSR the more
 conventional way
Message-ID: <YJK7jzbihzFIkb59@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-12-seanjc@google.com>
 <08a4afca-c3cb-1999-02a6-a72440ab2214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08a4afca-c3cb-1999-02a6-a72440ab2214@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021, Paolo Bonzini wrote:
> On 04/05/21 19:17, Sean Christopherson wrote:
> > Tag TSX_CTRL as not needing to be loaded when RTM isn't supported in the
> > host.  Crushing the write mask to '0' has the same effect, but requires
> > more mental gymnastics to understand.
> 
> This doesn't explain _why_ this is now possible.  What about:
> 
> Now that user return MSRs is always present in the list, we don't have

User return MSRs aren't always present in the list; this series doesn't change
that behavior at all.

> the problem that the TSX_CTRL MSR needs a slot vmx->guest_uret_msrs even
> if RTM is not supported in the host (and therefore there is nothing to
> enable).  Thus we can simply tag TSX_CTRL as not needing to be loaded
> instead of crushing the write mask to '0'.

Unless I'm missing something, it would have been possible to give TSX_CTRL a
slot but not load it even before this refactoring, we just missed that approach
when handling the TSX_CTRL without HLE/RTM case.  Several other MSRs rely on
this behavior, notably the SYSCALL MSRs, which are present in the list so that
the guest can read/write the MSRs, but are loaded into hardware iff the guest
has enabled SYSCALL.

All that said, I certainly have no objection to writing a longer changelog.
