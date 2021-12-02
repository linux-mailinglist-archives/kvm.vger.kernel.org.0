Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B6F465BFD
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 03:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344397AbhLBCHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 21:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhLBCHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 21:07:03 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B466C061748
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 18:03:41 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id r5so25423761pgi.6
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 18:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y8Yop8ED3EGPor3MCeQDZ51Vt374HnVayFIUSI65N6A=;
        b=sIjZA7JIHVVZwIUFPNucSbWS+MSXfMTMzlZmQnQHVSImkyNOA0ikxtiRmRg1UJczm4
         H0eKu02maxMH4wYxhoiicyPYecKAjHe5u4lzYr7scg8AGJRvxIVxha9ctIVeZjgyQ5Ci
         fO8ekC1hfjREVU0oweV/GwYY8R1Q5b1DbWwTxXkZxem4+xHM5U6Vvpqzp/IsA/WIHqot
         vAhCf00qH6MNbJ7AlbC7JdJbO+WLBc6cJOFbEV5uk19G/hUrX2ni5uGCxPpV2WCWzoE+
         vEWl5m0IUu6lqsgQndiKsR1wEKJ6rwwgBL4q1unvF0NzGxlTZ9E+4vQxD+AMBPnzsJ+1
         Pi/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y8Yop8ED3EGPor3MCeQDZ51Vt374HnVayFIUSI65N6A=;
        b=RjyRFkEAmfiVG0aVDFTyxSiIWnD98FS1eXrhrWVttheie5EZ+OFIBe/HRHnDN6Juzz
         Zp14N8obwDR6mliSRdY0xUv8xBlvvLQsI6AW0nsXjOXhZKcepEToLq7aV778wtE9QwIj
         /xMQQpTv8BJNa/oy+o3Z9HxUkuWCBCPb+lUPJp0ZxQeNQdVxyv4sqS699DIJEmYoCbfP
         G0pVYBDEPz+oPCf4/CfKT3c4SAj1Np3HuwuRZbb7L1Lwm3b3ynYWZQFrssaevg1yyneg
         D8eHD/vkoXCzhdzISKYOIvR/IQbpYO3NbziWzwGIv1iok0pPFghJJpqXrKpZ1D5Hh1Sb
         +ERQ==
X-Gm-Message-State: AOAM532YuYeiyFP6hqI2u3TQ861LQ+9E5nzMnvs/yHmyPJSKWKpihZvu
        zSRCjyXii7NWK6R9AHGzRFFYtQ==
X-Google-Smtp-Source: ABdhPJw0HWd/CJFMh+gN5JsMT2ryNIzesyfy/X4sft27BnKZ+Ws5ipI2UW199ZRiXe8J2frwd78eag==
X-Received: by 2002:a63:f651:: with SMTP id u17mr7248306pgj.256.1638410620966;
        Wed, 01 Dec 2021 18:03:40 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v10sm1123864pfu.123.2021.12.01.18.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 18:03:40 -0800 (PST)
Date:   Thu, 2 Dec 2021 02:03:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 00/28] KVM: x86/mmu: Overhaul TDP MMU zapping and flushing
Message-ID: <YagpeekJ6I52f4U1@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <CALzav=cRRW2ZdotseqV+eKcu2oxehkkzKjYYDc3PA=Lw16JrGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cRRW2ZdotseqV+eKcu2oxehkkzKjYYDc3PA=Lw16JrGQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01, 2021, David Matlack wrote:
> On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Overhaul TDP MMU's handling of zapping and TLB flushing to reduce the
> > number of TLB flushes, and to clean up the zapping code.  The final patch
> > realizes the biggest change, which is to use RCU to defer any TLB flush
> > due to zapping a SP to the caller.  The largest cleanup is to separate the
> > flows for zapping roots (zap _everything_), zapping leaf SPTEs (zap guest
> > mappings for whatever reason), and zapping a specific SP (NX recovery).
> > They're currently smushed into a single zap_gfn_range(), which was a good
> > idea at the time, but became a mess when trying to handle the different
> > rules, e.g. TLB flushes aren't needed when zapping a root because KVM can
> > safely zap a root if and only if it's unreachable.
> >
> > For booting an 8 vCPU, remote_tlb_flush (requests) goes from roughly
> > 180 (600) to 130 (215).
> >
> > Please don't apply patches 02 and 03, they've been posted elsehwere and by
> > other people.  I included them here because some of the patches have
> > pseudo-dependencies on their changes.  Patch 01 is also posted separately.
> > I had a brain fart and sent it out realizing that doing so would lead to
> > oddities.
> 
> What's the base commit for this series?

Pretty sure it's based on a stale kvm/queue, commit 81d7c6659da0 ("KVM: VMX: Remove
vCPU from PI wakeup list before updating PID.NV").  Time to add useAutoBase=true...
