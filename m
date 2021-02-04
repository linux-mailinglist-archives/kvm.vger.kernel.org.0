Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5939430E989
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 02:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhBDBkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 20:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhBDBkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 20:40:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7172E64E31;
        Thu,  4 Feb 2021 01:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612402764;
        bh=6M98RcZOM/Vz/I/vJ2XWRs5F5FBLaXaewlLXJ7TVPXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y4GMFZkLXl+nnbtq16WfAcOSgIx3UWaTIwtN9anXdO1NCFQpzjpf2zaDc85BspcuE
         q5daxXWBuzLjdkVDWV6gX7FWP/ZxkD4PZPwlXFJKMqynfYDsyw4aTPgM2hjFhC4DGh
         uCSQjKnsgAlSnf7s67fIHthyXRWxzs6sDWTaupE6Ex7z/sMwHUVpoeUQrZR78X/4w1
         IvR1jq/Hu33MU6rfSMh9EK5JoZ/3Ifh6bVZcK8HDIN6AyjXbVXznlv2J1pQ9WtVNJx
         +xUuEWXunHnmatS7R2QBp12Q0DTUJkOPozKWTbkQKX+8TImQt5ZEUTOrbTRCM8CASl
         qkiZXwcBfsSbA==
Date:   Thu, 4 Feb 2021 03:39:16 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBtQRCC3NHBmtrck@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <YBmMrqxlTxClg9Eb@kernel.org>
 <YBmX/wFFshokDqWM@google.com>
 <YBndRM9m0XHYwsPP@kernel.org>
 <20210203134906.78b5265502c65f13bacc5e68@intel.com>
 <YBsdeco/t8sa7ecV@kernel.org>
 <YBsq45IDDX9PPc7s@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBsq45IDDX9PPc7s@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 02:59:47PM -0800, Sean Christopherson wrote:
> On Thu, Feb 04, 2021, Jarkko Sakkinen wrote:
> > On Wed, Feb 03, 2021 at 01:49:06PM +1300, Kai Huang wrote:
> > > What working *incorrectly* thing is related to SGX virtualization? The things
> > > SGX virtualization requires (basically just raw EPC allocation) are all in
> > > sgx/main.c. 
> > 
> > States:
> > 
> > A. SGX driver is unsupported.
> > B. SGX driver is supported and initialized correctly.
> > C. SGX driver is supported and failed to initialize.
> > 
> > I just thought that KVM should support SGX when we are either in states A
> > or B.  Even the short summary implies this. It is expected that SGX driver
> > initializes correctly if it is supported in the first place. If it doesn't,
> > something is probaly seriously wrong. That is something we don't expect in
> > a legit system behavior.
> 
> It's legit behavior, and something we (you?) explicitly want to support.  See
> patch 05, x86/cpu/intel: Allow SGX virtualization without Launch Control support.

What I think would be a sane behavior, would be to allow KVM when
sgx_drv_init() returns -ENODEV (case A). This happens when LC is
not enabled:

	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
		return -ENODEV;

/Jarkko
