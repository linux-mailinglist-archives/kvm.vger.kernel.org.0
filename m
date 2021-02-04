Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4D730EAA1
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 04:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhBDDGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 22:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232138AbhBDDGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 22:06:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 747AE64E42;
        Thu,  4 Feb 2021 03:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612407960;
        bh=hmc5VBzB3YO0sZl/LTnIPs8r2hhaZ3cnQLrS3D5Tk1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uGIJ9q/NWP56+uFCjk3p9604Sdcas36IJjircBYpi2P/W4Yrv3jts3IlOTo7dQhFs
         Mupr92taEGhC95uh6Iv3WWAsgSf8jUfDAAWV7oJmIUo7Bj4es9PX2503QSu+o+9Ltt
         NJ1VC/XWrDUqUg/PuFtPrivbfN6O1y+JDlGrW7kcsKsLbTbQOgnZOcZroq1Y7Jr5bM
         JIi3EiZ/+V5DvmI9pjdWhoVsV58EnZcm5CrdDhQ5DbFBjmg/Flp2VgTJEgYtPywAtQ
         KjATBPPD2PFvnL4KmCyNJ/xDQTx3XDuBS5rs7Cv40TUn91eNmbZuIGXdR9cN0Leq4c
         i5WRM8T+VqZiw==
Date:   Thu, 4 Feb 2021 05:05:52 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBtkkEp5hXpTl84s@kernel.org>
References: <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <YBmMrqxlTxClg9Eb@kernel.org>
 <YBmX/wFFshokDqWM@google.com>
 <YBndRM9m0XHYwsPP@kernel.org>
 <20210203134906.78b5265502c65f13bacc5e68@intel.com>
 <YBsdeco/t8sa7ecV@kernel.org>
 <YBsq45IDDX9PPc7s@google.com>
 <YBtQRCC3NHBmtrck@kernel.org>
 <b63bf7db09442e994563ccc3a3b608fc2f17b784.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b63bf7db09442e994563ccc3a3b608fc2f17b784.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021 at 03:59:20PM +1300, Kai Huang wrote:
> On Thu, 2021-02-04 at 03:39 +0200, Jarkko Sakkinen wrote:
> > On Wed, Feb 03, 2021 at 02:59:47PM -0800, Sean Christopherson wrote:
> > > On Thu, Feb 04, 2021, Jarkko Sakkinen wrote:
> > > > On Wed, Feb 03, 2021 at 01:49:06PM +1300, Kai Huang wrote:
> > > > > What working *incorrectly* thing is related to SGX virtualization? The things
> > > > > SGX virtualization requires (basically just raw EPC allocation) are all in
> > > > > sgx/main.c. 
> > > > 
> > > > States:
> > > > 
> > > > A. SGX driver is unsupported.
> > > > B. SGX driver is supported and initialized correctly.
> > > > C. SGX driver is supported and failed to initialize.
> > > > 
> > > > I just thought that KVM should support SGX when we are either in states A
> > > > or B.  Even the short summary implies this. It is expected that SGX driver
> > > > initializes correctly if it is supported in the first place. If it doesn't,
> > > > something is probaly seriously wrong. That is something we don't expect in
> > > > a legit system behavior.
> > > 
> > > It's legit behavior, and something we (you?) explicitly want to support.  See
> > > patch 05, x86/cpu/intel: Allow SGX virtualization without Launch Control support.
> > 
> > What I think would be a sane behavior, would be to allow KVM when
> > sgx_drv_init() returns -ENODEV (case A). This happens when LC is
> > not enabled:
> > 
> > 	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
> > 		return -ENODEV;
> > 
> > /Jarkko
> 
> I really don't understand what's the difference between A and C. When "SGX driver is
> supported and failed to initialize" happens, it just means "SGX driver is
> unsupported". If it is not the case, can you explicitly point out what will be the
> problem?

ret != 0 && ret != -ENODEV

/Jarkko
