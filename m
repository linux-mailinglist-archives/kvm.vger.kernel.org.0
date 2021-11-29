Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76CD4626BF
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbhK2W5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbhK2WzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:55:04 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8BDC12710C
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:05:53 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso14908046pjo.3
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5sDERUw/7RbLmxxw3xc+XUUsW1NhTfcSaWrTPeN89uc=;
        b=qLkRoFUS14KP9zMKn6XmRpx6dla8pF2XGci+7CpOi3Gjf+BLW/uLJiuFW25KIxCu0p
         qY5sqlfl3WesbrORA0FxzLxupmW1lr02GJodHH/tuCP6PnvpYfxorAml4ZVRXL/OWJre
         OogxJ6fLvCb5Y8LGYUk+qdFr8WEahfJtPaUMDauxT9GbfvtyJwHFSjQn5P0McgIELHuy
         j0uS+KBx5GrQ8WSI2rFhbrQeJHrm7BmE4kHIrPQ9afUuFI7gBgw0ZkI+W9CZrpfLoBDP
         6rEjGqIeAu9rzNodCIMJ3pCvrbTr8jYrUiOycTPG8p3HDIjL9QyfNf12XW8bm1uzpOGU
         kHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5sDERUw/7RbLmxxw3xc+XUUsW1NhTfcSaWrTPeN89uc=;
        b=NAYSJnl+5oz6jIXcTRv62OumiJUH8BbvAEp6DvxWlCoP4NHCTBb1CjO96JY1/mUPXm
         6xKl27tiFv0I4AQWzHUBRXRcQmr1HAc+jyr7wG9mWbcyhoAgS2lEhfhPoXwR6EqfyjLU
         +g2JWn2BukD86B1N5VSGIVXg4wEAajcAFIzMOtxPkDN5UpPDWmE5NHF6aNdFSex+hjiG
         Dft55lVD2ucrHzaF8PbULYPf/49NXEd2NCY4nh/0YiE3AVTFcfEDkv+MLGdXGicTWbmI
         Tih4H7+i6G4qFDMcd742klZT0BqNN7ALo35LqLpvhRmySjIuuOqZ4dV1wjELXuy8PkeR
         WrDw==
X-Gm-Message-State: AOAM531dO6LCjWBwgGRFi15kRn1+LPyTkgEtwidikjaFbo2JYYw4B7bF
        atQW7s3OMKvFaYqdzxu23kPCAw==
X-Google-Smtp-Source: ABdhPJwbXd6qyKHBxqqgFKv6ap8JyMFbqJzbWzhavHwdCVDLk23PO4HZqOGhhXb7L6PXNPxBe/Jt6g==
X-Received: by 2002:a17:90b:3890:: with SMTP id mu16mr40379960pjb.186.1638209152601;
        Mon, 29 Nov 2021 10:05:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b10sm18148352pft.179.2021.11.29.10.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 10:05:52 -0800 (PST)
Date:   Mon, 29 Nov 2021 18:05:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>
Subject: Re: [RFC PATCH v3 18/59] KVM: x86: Add flag to mark TSC as immutable
 (for TDX)
Message-ID: <YaUWfFpYP/7lcpmZ@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <00772535f09b2bf98e6bc7008e81c6ffb381ed84.1637799475.git.isaku.yamahata@intel.com>
 <87ilwgja6x.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilwgja6x.ffs@tglx>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021, Thomas Gleixner wrote:
> On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> >
> > The TSC for TDX1 guests is fixed at TD creation time.  Add tsc_immutable
> 
> What's a TDX1 guest?

The "revision 1.0" version of TDX.  Some of these patches use "TDX1" to identify
behaviors that may not hold true in future iterations of TDX, and also to highlight
things that are dictated by the spec, e.g. some of the guest TSC frequency values.
For this patch in particular, there's probably no need to differentiate TDX1 vs. TDX,
the qualification was more for cases where KVM needs to define magic values to adhere
to the spec, e.g. to make it clear that the magic values aren't made up by KVM.

> > to reflect that the TSC of the guest cannot be changed in any way, and
> > use it to short circuit all paths that lead to one of the myriad TSC
> > adjustment flows.
> 
> I can kinda see the reason for this being valuable on it's own, but in
> general why does TDX need a gazillion flags to disable tons of different
> things if _ALL_ these flags are going to be set by for TDX guests
> anyway?
> 
> Seperate flags make only sense when they have a value on their own,
> i.e. are useful for things outside of TDX. If not they are just useless
> ballast.

SEV-SNP and TDX have different, but overlapping, restrictions.  And SEV-ES also
shares most SEV-SNP's restrictions.  TDX guests that can be debugged and/or profiled
also have different restrictions, though I forget if any of these flags would be
affected.

The goal with individual flags is to avoid seemingly arbitrary is_snp_guest() and
is_tdx_guest() checks throughout common x86 code, e.g. to avoid confusion over why
KVM does X for TDX but Y for SNP.  And I personally find it easer to audit KVM
behavior with respect to the SNP/TDX specs if the non-obvious restrictions are
explicitly set when the VM is created.

For some of the flags, there's also hope that future iterations of TDX will remove
some of the restrictions, though that's more of a bonus than a direct justification
for adding individual flags.
