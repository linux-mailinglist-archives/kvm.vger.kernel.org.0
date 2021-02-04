Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B531930F56A
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 15:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhBDOwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 09:52:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236861AbhBDOwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 09:52:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0196064E42;
        Thu,  4 Feb 2021 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612450285;
        bh=0qYGseK9qf12SS5lXXAuSTG3AzzmKTRorIWU/7nzoEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dlNzm8dAKbkBKUruPZZi3TYb/UhRCldN/2NOVeBd5wxJ13B7iK7NFn77Fp511bMb3
         K/QMAZKneSu0Fqdrg3//TubwABcutxn5J5LY3BUaUWFBDvR8oeiWlg65enEp5S5suC
         cwr7v04jk9ezr0OLsUC3pzoh8fPZ4McZFrxOBnIo5KJjv2gEIqZ9nB54Dj16W8vKbL
         1tpszIvDYbdknpvo2Qg9vVrhgtrXueKBToFoZmnNRsvNfZvpuEYrOyDTSgYnM2Fi5b
         slDs8YFH810aoTP0JKrnPyBpFF/M9mnFzTuycD+q17utrVVkKUY/C3pOSygWkiGsqj
         GkfckfFmxSLpQ==
Date:   Thu, 4 Feb 2021 16:51:17 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBwJ5S0C3dMS2AFY@kernel.org>
References: <YBmX/wFFshokDqWM@google.com>
 <YBndRM9m0XHYwsPP@kernel.org>
 <20210203134906.78b5265502c65f13bacc5e68@intel.com>
 <YBsdeco/t8sa7ecV@kernel.org>
 <YBsq45IDDX9PPc7s@google.com>
 <YBtQRCC3NHBmtrck@kernel.org>
 <b63bf7db09442e994563ccc3a3b608fc2f17b784.camel@intel.com>
 <YBtkkEp5hXpTl84s@kernel.org>
 <YBtlTE2xZ3wBrukB@kernel.org>
 <b523357d2f062bf801d8fa1b05bf7abf13c19e89.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b523357d2f062bf801d8fa1b05bf7abf13c19e89.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021 at 04:20:49PM +1300, Kai Huang wrote:
> On Thu, 2021-02-04 at 05:09 +0200, Jarkko Sakkinen wrote:
> > On Thu, Feb 04, 2021 at 05:05:56AM +0200, Jarkko Sakkinen wrote:
> > > On Thu, Feb 04, 2021 at 03:59:20PM +1300, Kai Huang wrote:
> > > > On Thu, 2021-02-04 at 03:39 +0200, Jarkko Sakkinen wrote:
> > > > > On Wed, Feb 03, 2021 at 02:59:47PM -0800, Sean Christopherson wrote:
> > > > > > On Thu, Feb 04, 2021, Jarkko Sakkinen wrote:
> > > > > > > On Wed, Feb 03, 2021 at 01:49:06PM +1300, Kai Huang wrote:
> > > > > > > > What working *incorrectly* thing is related to SGX virtualization? The things
> > > > > > > > SGX virtualization requires (basically just raw EPC allocation) are all in
> > > > > > > > sgx/main.c. 
> > > > > > > 
> > > > > > > States:
> > > > > > > 
> > > > > > > A. SGX driver is unsupported.
> > > > > > > B. SGX driver is supported and initialized correctly.
> > > > > > > C. SGX driver is supported and failed to initialize.
> > > > > > > 
> > > > > > > I just thought that KVM should support SGX when we are either in states A
> > > > > > > or B.  Even the short summary implies this. It is expected that SGX driver
> > > > > > > initializes correctly if it is supported in the first place. If it doesn't,
> > > > > > > something is probaly seriously wrong. That is something we don't expect in
> > > > > > > a legit system behavior.
> > > > > > 
> > > > > > It's legit behavior, and something we (you?) explicitly want to support.  See
> > > > > > patch 05, x86/cpu/intel: Allow SGX virtualization without Launch Control support.
> > > > > 
> > > > > What I think would be a sane behavior, would be to allow KVM when
> > > > > sgx_drv_init() returns -ENODEV (case A). This happens when LC is
> > > > > not enabled:
> > > > > 
> > > > > 	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
> > > > > 		return -ENODEV;
> > > > > 
> > > > > /Jarkko
> > > > 
> > > > I really don't understand what's the difference between A and C. When "SGX driver is
> > > > supported and failed to initialize" happens, it just means "SGX driver is
> > > > unsupported". If it is not the case, can you explicitly point out what will be the
> > > > problem?
> > 
> > This is as explicit as I can ever possibly get:
> > 
> > A: ret == -ENODEV
> > B: ret == 0
> > C: ret != 0 && ret != -ENODEV
> 
> Let me try again: 
> 
> Why A and C should be treated differently? What will behave incorrectly, in case of
> C?

So you don't know what different error codes mean?

/Jarkko
