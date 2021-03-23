Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A233464EC
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhCWQWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhCWQVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:21:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD72C061574
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 09:21:52 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w8so10310870pjf.4
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 09:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MLo6U+EZDo7YptfC8p6Lv8dCxMeh4A33yWpojlfgDC8=;
        b=wMm8Tzi/sJvLTKFvZCBNiYmAnCKiiull5252X9NNO3ZaNvF+OsiXOqdWfXe2Xh7njN
         XzBW0sz6byX+QalQnvkbKe0OIKZ1XrLSaoNQrWWXlTuxMA41S4A4gTSON1wxpjG6kSwx
         XxPeCGJ7Xou3hVAhA5hKkpWrl7UNxa3laOm9fMXj3mjctaR//Mzp39id0jlAh7oGSf4U
         CDdsiWBqG4dUTEqJA5vOAb+Z5fbn6P+TGu2xmG6mPXHGoArNHUFAvchkDDqVs9MuD95l
         obB4hTsvUDUuRsdnUGlnaF44mr8htcwWTM37U09JymK5nqRBL2Qu/T8gPCRdXVCUGD0l
         VABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MLo6U+EZDo7YptfC8p6Lv8dCxMeh4A33yWpojlfgDC8=;
        b=khnggMcu61WP2+YQ4rcM6QDrqQRrnS2zazzb+WgRxy02AutfXdrfqjS+C226rDeHos
         SgSk4mBFebSsV+eIxJ5shjtGiGoQNoFZ+eliNhUbtOiLm2NLnm2MeF0BrAEmnB+z5L8f
         b3gIeEVLFsZFwfxso0Fsbg0GRJ+CoO48n/+fbGE4Pf4oY9EG3Bv86l+NIWMWmHAr83hd
         o35jJc5DQ+aoL57le/wQmUtts3Sy/Xjo7Y1E89sD5VKs/Gx3G/RzbK9h1YFq1TLSh6KS
         amMA8XvPjtNRmpAS2CirjktSHfQs6mAASYZJF6J8bO+INi2r7tQFvH5bVEySI1DtB+5+
         DVyQ==
X-Gm-Message-State: AOAM532MgJP4LrP1hRm0cyeZJS6UjmokXwF/lgtlO7JkbYR83x3JWy/L
        D/DZFV9doIZ1cAUC7j5sP+2ojw==
X-Google-Smtp-Source: ABdhPJygb5PcOAznIMxTZsUt+ShVTt9Wu4NbpOFD86cLB300W/R+aIch4EHQSkFWRrFaPAyUTqZNTw==
X-Received: by 2002:a17:90b:1216:: with SMTP id gl22mr5318799pjb.99.1616516511964;
        Tue, 23 Mar 2021 09:21:51 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id y17sm3015464pju.50.2021.03.23.09.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 09:21:51 -0700 (PDT)
Date:   Tue, 23 Mar 2021 16:21:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YFoVmxIFjGpqM6Bk@google.com>
References: <20210322181646.GG6481@zn.tnic>
 <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com>
 <20210323160604.GB4729@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323160604.GB4729@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021, Borislav Petkov wrote:
> On Tue, Mar 23, 2021 at 03:45:14PM +0000, Sean Christopherson wrote:
> > Practically speaking, "basic" deployments of SGX VMs will be insulated from
> > this bug.  KVM doesn't support EPC oversubscription, so even if all EPC is
> > exhausted, new VMs will fail to launch, but existing VMs will continue to chug
> > along with no ill effects....
> 
> Ok, so it sounds to me like *at* *least* there should be some writeup in
> Documentation/ explaining to the user what to do when she sees such an
> EREMOVE failure, perhaps the gist of this thread and then possibly the
> error message should point to that doc.
> 
> We will of course have to revisit when this hits the wild and people
> start (or not) hitting this. But judging by past experience, if it is
> there, we will hit it. Murphy says so.

I like the idea of pointing at the documentation.  The documentation should
probably emphasize that something is very, very wrong.  E.g. if a kernel bug
triggers EREMOVE failure and isn't detected until the kernel is widely deployed
in a fleet, then the folks deploying the kernel probably _should_ be in all out
panic.  For this variety of bug to escape that far, it means there are huge
holes in test coverage, in both the kernel itself and in the infrasturcture of
whoever is rolling out their new kernel.
