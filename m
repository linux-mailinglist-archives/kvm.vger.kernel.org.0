Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88D730EAB2
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 04:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhBDDJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 22:09:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231759AbhBDDJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 22:09:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9336D64E42;
        Thu,  4 Feb 2021 03:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612408147;
        bh=DO17Ji2Z5OwqwjGdem1y7DJtxEZJ3ylboTT2HlBtRhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iwR0WxeTygLTUEKdAq8piwO5YNHkpC9sf7RbD4GmDQnYSEAkMVCYG0rdzdBxoo7JU
         47N7wUNkNlwe2H3iNJ/SY4x83z/G+HNXpQTaLE7G4om3cyFu6R5MZsOhayZO19dq60
         tCjO3m092zxY6i2NVBeYnphs9wLvp2RJppI/uy24poCWh4Kk3DjHaOZrht9uEDZiHY
         N6QPitm+2WSN3/2yop23uYQjqLeh2cGFbYVXGddIfg1WvSQbZWyW9YypitoxXmMAJJ
         YlqJ7/ZjS6d6467KmKU1GjRmb//UrGLBwqgvxmVIgbpeWlnzEhZVJdxu0X0dAh9uQB
         mknuElEilXhig==
Date:   Thu, 4 Feb 2021 05:09:00 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBtlTE2xZ3wBrukB@kernel.org>
References: <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <YBmMrqxlTxClg9Eb@kernel.org>
 <YBmX/wFFshokDqWM@google.com>
 <YBndRM9m0XHYwsPP@kernel.org>
 <20210203134906.78b5265502c65f13bacc5e68@intel.com>
 <YBsdeco/t8sa7ecV@kernel.org>
 <YBsq45IDDX9PPc7s@google.com>
 <YBtQRCC3NHBmtrck@kernel.org>
 <b63bf7db09442e994563ccc3a3b608fc2f17b784.camel@intel.com>
 <YBtkkEp5hXpTl84s@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBtkkEp5hXpTl84s@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021 at 05:05:56AM +0200, Jarkko Sakkinen wrote:
> On Thu, Feb 04, 2021 at 03:59:20PM +1300, Kai Huang wrote:
> > On Thu, 2021-02-04 at 03:39 +0200, Jarkko Sakkinen wrote:
> > > On Wed, Feb 03, 2021 at 02:59:47PM -0800, Sean Christopherson wrote:
> > > > On Thu, Feb 04, 2021, Jarkko Sakkinen wrote:
> > > > > On Wed, Feb 03, 2021 at 01:49:06PM +1300, Kai Huang wrote:
> > > > > > What working *incorrectly* thing is related to SGX virtualization? The things
> > > > > > SGX virtualization requires (basically just raw EPC allocation) are all in
> > > > > > sgx/main.c. 
> > > > > 
> > > > > States:
> > > > > 
> > > > > A. SGX driver is unsupported.
> > > > > B. SGX driver is supported and initialized correctly.
> > > > > C. SGX driver is supported and failed to initialize.
> > > > > 
> > > > > I just thought that KVM should support SGX when we are either in states A
> > > > > or B.  Even the short summary implies this. It is expected that SGX driver
> > > > > initializes correctly if it is supported in the first place. If it doesn't,
> > > > > something is probaly seriously wrong. That is something we don't expect in
> > > > > a legit system behavior.
> > > > 
> > > > It's legit behavior, and something we (you?) explicitly want to support.  See
> > > > patch 05, x86/cpu/intel: Allow SGX virtualization without Launch Control support.
> > > 
> > > What I think would be a sane behavior, would be to allow KVM when
> > > sgx_drv_init() returns -ENODEV (case A). This happens when LC is
> > > not enabled:
> > > 
> > > 	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
> > > 		return -ENODEV;
> > > 
> > > /Jarkko
> > 
> > I really don't understand what's the difference between A and C. When "SGX driver is
> > supported and failed to initialize" happens, it just means "SGX driver is
> > unsupported". If it is not the case, can you explicitly point out what will be the
> > problem?

This is as explicit as I can ever possibly get:

A: ret == -ENODEV
B: ret == 0
C: ret != 0 && ret != -ENODEV

/Jarkko
