Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BDD34749E
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 10:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbhCXJ2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 05:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234779AbhCXJ2f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 05:28:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C05B619FF;
        Wed, 24 Mar 2021 09:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616578114;
        bh=xEeMYENWJ8eHZP35YBP9kXgN0WisfIGoBPFtuDmZEDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q6a8PHrQM/EB8ZQlOmUzsi5MQCYwOZLFhEqTU2kyfMKVSm/frA01PT2byL24paXvc
         aqctd2ewfRak1PMav4Cs6AS/5E/E/FGd3cqu/imnkM8JGaQJyqyf6B75I9rWTnuY/u
         hIaBkJcJOmdbTy2JBO/G08H6zCMCG+BH4AIyXPMzPyTiPGioWEiYeMo+UhDTzt+b6Q
         VNZ7l98VrKL14SZ5gnClw1uKzeNsAc+hBEE1fvm0iMvCqzJdkY0xOsv3+1/34wYcf/
         GVCfH9g9s/2L0Mqg+7mk4Xz/qSdErGQS3b5Q0itR+eAS/36bLmluPyN5M3rQMhon6n
         9dIRXBgivlFpw==
Date:   Wed, 24 Mar 2021 11:28:05 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, Kai Huang <kai.huang@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YFsGJfYA9H69hwKd@kernel.org>
References: <YFjoZQwB7e3oQW8l@google.com>
 <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com>
 <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com>
 <20210323160604.GB4729@zn.tnic>
 <YFoVmxIFjGpqM6Bk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFoVmxIFjGpqM6Bk@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 04:21:47PM +0000, Sean Christopherson wrote:
> On Tue, Mar 23, 2021, Borislav Petkov wrote:
> > On Tue, Mar 23, 2021 at 03:45:14PM +0000, Sean Christopherson wrote:
> > > Practically speaking, "basic" deployments of SGX VMs will be insulated from
> > > this bug.  KVM doesn't support EPC oversubscription, so even if all EPC is
> > > exhausted, new VMs will fail to launch, but existing VMs will continue to chug
> > > along with no ill effects....
> > 
> > Ok, so it sounds to me like *at* *least* there should be some writeup in
> > Documentation/ explaining to the user what to do when she sees such an
> > EREMOVE failure, perhaps the gist of this thread and then possibly the
> > error message should point to that doc.
> > 
> > We will of course have to revisit when this hits the wild and people
> > start (or not) hitting this. But judging by past experience, if it is
> > there, we will hit it. Murphy says so.
> 
> I like the idea of pointing at the documentation.  The documentation should
> probably emphasize that something is very, very wrong.  E.g. if a kernel bug
> triggers EREMOVE failure and isn't detected until the kernel is widely deployed
> in a fleet, then the folks deploying the kernel probably _should_ be in all out
> panic.  For this variety of bug to escape that far, it means there are huge
> holes in test coverage, in both the kernel itself and in the infrasturcture of
> whoever is rolling out their new kernel.

My own experience with WARN()'s has been so far, that the stack trace does
the job fairly well. It's commonly misintepreted same as oops.

/Jarkko
