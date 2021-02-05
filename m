Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7F0310298
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 03:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBECJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 21:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhBECJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 21:09:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65C5A64FB0;
        Fri,  5 Feb 2021 02:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612490921;
        bh=ohT/o4ihZnrPvuQ1joQWVWE7+VxOLOWwPRzPgsnSby8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zzvph+EX8RjaaCqQeBfjYAntCykri1cybHU5psGsewspD54LfTLifU8xbgNzKQ+Zp
         7FZmSxaN5uO2P18A7XnORlrvQx4FIt69HOM7S+maECBXNslq5XTQbYGNxhPZWbraKw
         lgg7fgQ+tYA657VUbSlTmUJay84f8XPrpm8QIJsY93qovVpQqQBon87w1vp5IMZ02W
         2/ukVWq+3v9OFSpEejWeIWF1tanBPtlEBgGwE4ozJGSTr/gxYA3cTqeZTtaLP6ahqr
         jGugI4mYokDHmw7ukwWiJIGvFkSysRZ4S3BfTB07x8Y+myav/5MXSFhyFmKDLpyTF9
         tTt5/+0ybcrOg==
Date:   Fri, 5 Feb 2021 04:08:33 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YByooRl8riad4moe@kernel.org>
References: <20210203134906.78b5265502c65f13bacc5e68@intel.com>
 <YBsdeco/t8sa7ecV@kernel.org>
 <YBsq45IDDX9PPc7s@google.com>
 <YBtQRCC3NHBmtrck@kernel.org>
 <b63bf7db09442e994563ccc3a3b608fc2f17b784.camel@intel.com>
 <YBtkkEp5hXpTl84s@kernel.org>
 <YBtlTE2xZ3wBrukB@kernel.org>
 <b523357d2f062bf801d8fa1b05bf7abf13c19e89.camel@intel.com>
 <YBwJ5S0C3dMS2AFY@kernel.org>
 <7a1d2316-5ce2-63fa-4186-a623dac1ecc8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a1d2316-5ce2-63fa-4186-a623dac1ecc8@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021 at 02:41:57PM -0800, Dave Hansen wrote:
> On 2/4/21 6:51 AM, Jarkko Sakkinen wrote:
> >>> A: ret == -ENODEV
> >>> B: ret == 0
> >>> C: ret != 0 && ret != -ENODEV
> >> Let me try again: 
> >>
> >> Why A and C should be treated differently? What will behave incorrectly, in case of
> >> C?
> > So you don't know what different error codes mean?
> 
> How about we just leave the check in place as Sean wrote it, and add a
> nice comment to explain what it is doing:
> 	
> 	/*
> 	 * Always try to initialize the native *and* KVM drivers.
> 	 * The KVM driver is less picky than the native one and
> 	 * can function if the native one is not supported on the
> 	 * current system or fails to initialize.
> 	 *
> 	 * Error out only if both fail to initialize.
>  	 */
> 	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> 	if (ret)
> 		goto err_kthread;

WFM, I can go along, as long as there is a remark. There is a semantical
difference between "not supported" and "failure to initialize". The
driving point is that this should not be hidden. I was first thinking
a note in the commit message, but inline comment is actually a better
idea. Thanks!

I can ack the next version, as long as this comment is included.

/Jarkko
