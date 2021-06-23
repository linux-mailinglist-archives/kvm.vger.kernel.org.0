Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0083B1E74
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 18:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFWQTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 12:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWQTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 12:19:30 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C43AC061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:17:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id y14so2157209pgs.12
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 09:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7zn0oCEuocGAdQ6ZsgTeBUSCFiV5Hshm48AY9/StAM4=;
        b=Nz0Xjy+hjgVfAotFNLUVfPHkM8fT//dLdVyMD2rSuPCq5XlGXdsVfWDftvNwegRi0j
         QuoHiUC4wWpK8j0CDRqFS1T+cK0RAt8KUHRRNPR9DcBNmJ8rTWtjzAdj7xjQh6jVOqVv
         8RGrdSLkvx0n/VS0WKegRt+rFTykf/mHcjkZamF54etoNv82r/4GSu6uyfPSHpIdznQD
         2GxNvp9/0v/tcZ2fFeK5Oro2OGcpg7Th3oGhH78UuIIB4KFRfMRjKlMTTL/Tea/t4cUi
         74RjXxU6/898atYSMaLd8jV+mTNju5h5f9YH9h6H9kNpbgBodX4ezdGrHWggZTLhSvA3
         VLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7zn0oCEuocGAdQ6ZsgTeBUSCFiV5Hshm48AY9/StAM4=;
        b=txKX9y7/6+Rkwx5fNVW1hSa9vfneABvJ4PmfWb4uKvmPUZcusN49GVHmCPzngvT+/p
         pO1ENRq7tBAHWPlqYNTOq/CHjNajeYcjk+HEbgKWiUj6IUDPuT3KPNUD98krnpHzcJZw
         heCXUnjtVP+DtGHCxqpDKUlz4Ekpfn0r0N1TzDjKzGN93Uwy++eD7uuH6yHJl4r/Udwu
         bKQDeEqvfZDyRliARarv9j2iFc+dlc20XgpGpx4ok2ZdrNW9TCTuXdSt9m1mn4ftz2hO
         u9eCDGvimKX79517HeDGlMP/ojRc/xYlT/drzy+ABz95z7JIVcuDnULwTc/AcQxUi4rc
         chlA==
X-Gm-Message-State: AOAM53148e0WwDxYU4efoTFsS9b+KMugOZt2+u9lpnbnwlRDHGarM0Hb
        wjdNBL0Iz+wIgHvBi4zyXZOUwA==
X-Google-Smtp-Source: ABdhPJxPdUdZP/AXCe6m1ksJPlw7BankA6YIx7crDzcku/94bYiHOb5QSaOiXQXiHo19oS0Tio2AUg==
X-Received: by 2002:a63:464b:: with SMTP id v11mr285761pgk.156.1624465030475;
        Wed, 23 Jun 2021 09:17:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id la18sm3068180pjb.55.2021.06.23.09.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 09:17:08 -0700 (PDT)
Date:   Wed, 23 Jun 2021 16:17:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 10/54] KVM: x86/mmu: Replace EPT shadow page shenanigans
 with simpler check
Message-ID: <YNNegF8RcF3vX2Sh@google.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <20210622175739.3610207-11-seanjc@google.com>
 <8ce36922-dba0-9b53-6f74-82f3f68b443c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ce36922-dba0-9b53-6f74-82f3f68b443c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021, Paolo Bonzini wrote:
> On 22/06/21 19:56, Sean Christopherson wrote:
> > Replace the hack to identify nested EPT shadow pages with a simple check
> > that the size of the guest PTEs associated with the shadow page and the
> > current MMU match, which is the intent of the "8 bytes == PAE" test.
> > The nested EPT hack existed to avoid a false negative due to the is_pae()
> > check not matching for 32-bit L2 guests; checking the MMU role directly
> > avoids the indirect calculation of the guest PTE size entirely.
> 
> What the commit message doesn't say is, did we miss this opportunity all
> along, or has there been a change since commit 47c42e6b4192 ("KVM: x86:
> fix handling of role.cr4_pae and rename it to 'gpte_size'", 2019-03-28)
> that allows this?

The code was wrong from the initial "unsync" commit.  The 4-byte vs. 8-byte check
papered over the real bug, which was that the roles were not checked for
compabitility.  I suspect that the bug only manisfested as an observable problem
when the GPTE sizes mismatched, thus the PAE check was added.

So yes, there was an "opportunity" that was missed all along.

> I think the only change needed would be making the commit something like
> this:
> 
> ==========
> KVM: x86/mmu: Use MMU role to check for matching guest page sizes
> 
> Originally, __kvm_sync_page used to check the cr4_pae bit in the role
> to avoid zapping 4-byte kvm_mmu_pages when guest page size are 8-byte
> or the other way round.  However, in commit 47c42e6b4192 ("KVM: x86: fix
> handling of role.cr4_pae and rename it to 'gpte_size'", 2019-03-28) it
> was observed that this did not work for nested EPT, where the page table
> size would be 8 bytes even if CR4.PAE=0.  (Note that the check still
> has to be done for nested *NPT*, so it is not possible to use tdp_enabled
> or similar).
> 
> Therefore, a hack was introduced to identify nested EPT shadow pages
> and unconditionally call __kvm_sync_page() on them.  However, it is
> possible to do without the hack to identify nested EPT shadow pages:
> if EPT is active, there will be no shadow pages in non-EPT format,
> and all of them will have gpte_is_8_bytes set to true; we can just
> check the MMU role directly, and the test will always be true.
> 
> Even for non-EPT shadow MMUs, this test should really always be true
> now that __kvm_sync_page() is called if and only if the role is an
> exact match (kvm_mmu_get_page()) or is part of the current MMU context
> (kvm_mmu_sync_roots()).  A future commit will convert the likely-pointless
> check into a meaningful WARN to enforce that the mmu_roles of the current
> context and the shadow page are compatible.
> ==========
> 
> 
> Paolo
> 
> > Note, this should be a glorified nop now that __kvm_sync_page() is called
> > if and only if the role is an exact match (kvm_mmu_get_page()) or is part
> > of the current MMU context (kvm_mmu_sync_roots()).  A future commit will
> > convert the likely-pointless check into a meaningful WARN to enforce that
> > the mmu_roles of the current context and the shadow page are compatible.
> > 
> > Cc: Vitaly Kuznetsov<vkuznets@redhat.com>
> > Signed-off-by: Sean Christopherson<seanjc@google.com>
> 
