Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A0830EADC
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 04:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhBDDVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 22:21:12 -0500
Received: from mga12.intel.com ([192.55.52.136]:61543 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233918AbhBDDVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 22:21:11 -0500
IronPort-SDR: FsXH32dWhrF8Qdkpo7O8X+icRkfeTCJ+Wl5oSBunV8JXvBstJBBHhNB+K6wjMBOffl03UYQIK0
 u+MDLRl6hZxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="160328580"
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="160328580"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 19:20:55 -0800
IronPort-SDR: qK4wTXN4DanvCVJZGOcRFdVJBax3j9hwQbNeg8YTx1O65tL0GHaq/XOSOWsoCH9ipHy9Oa3PNv
 6ujPovxrTtKA==
X-IronPort-AV: E=Sophos;i="5.79,400,1602572400"; 
   d="scan'208";a="583043391"
Received: from hgheewal-mobl2.amr.corp.intel.com ([10.254.80.158])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 19:20:51 -0800
Message-ID: <b523357d2f062bf801d8fa1b05bf7abf13c19e89.camel@intel.com>
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver
 even when SGX driver is disabled
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Thu, 04 Feb 2021 16:20:49 +1300
In-Reply-To: <YBtlTE2xZ3wBrukB@kernel.org>
References: <20210201184040.646ea9923c2119c205b3378d@intel.com>
         <YBmMrqxlTxClg9Eb@kernel.org> <YBmX/wFFshokDqWM@google.com>
         <YBndRM9m0XHYwsPP@kernel.org>
         <20210203134906.78b5265502c65f13bacc5e68@intel.com>
         <YBsdeco/t8sa7ecV@kernel.org> <YBsq45IDDX9PPc7s@google.com>
         <YBtQRCC3NHBmtrck@kernel.org>
         <b63bf7db09442e994563ccc3a3b608fc2f17b784.camel@intel.com>
         <YBtkkEp5hXpTl84s@kernel.org> <YBtlTE2xZ3wBrukB@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-02-04 at 05:09 +0200, Jarkko Sakkinen wrote:
> On Thu, Feb 04, 2021 at 05:05:56AM +0200, Jarkko Sakkinen wrote:
> > On Thu, Feb 04, 2021 at 03:59:20PM +1300, Kai Huang wrote:
> > > On Thu, 2021-02-04 at 03:39 +0200, Jarkko Sakkinen wrote:
> > > > On Wed, Feb 03, 2021 at 02:59:47PM -0800, Sean Christopherson wrote:
> > > > > On Thu, Feb 04, 2021, Jarkko Sakkinen wrote:
> > > > > > On Wed, Feb 03, 2021 at 01:49:06PM +1300, Kai Huang wrote:
> > > > > > > What working *incorrectly* thing is related to SGX virtualization? The things
> > > > > > > SGX virtualization requires (basically just raw EPC allocation) are all in
> > > > > > > sgx/main.c. 
> > > > > > 
> > > > > > States:
> > > > > > 
> > > > > > A. SGX driver is unsupported.
> > > > > > B. SGX driver is supported and initialized correctly.
> > > > > > C. SGX driver is supported and failed to initialize.
> > > > > > 
> > > > > > I just thought that KVM should support SGX when we are either in states A
> > > > > > or B.  Even the short summary implies this. It is expected that SGX driver
> > > > > > initializes correctly if it is supported in the first place. If it doesn't,
> > > > > > something is probaly seriously wrong. That is something we don't expect in
> > > > > > a legit system behavior.
> > > > > 
> > > > > It's legit behavior, and something we (you?) explicitly want to support.  See
> > > > > patch 05, x86/cpu/intel: Allow SGX virtualization without Launch Control support.
> > > > 
> > > > What I think would be a sane behavior, would be to allow KVM when
> > > > sgx_drv_init() returns -ENODEV (case A). This happens when LC is
> > > > not enabled:
> > > > 
> > > > 	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
> > > > 		return -ENODEV;
> > > > 
> > > > /Jarkko
> > > 
> > > I really don't understand what's the difference between A and C. When "SGX driver is
> > > supported and failed to initialize" happens, it just means "SGX driver is
> > > unsupported". If it is not the case, can you explicitly point out what will be the
> > > problem?
> 
> This is as explicit as I can ever possibly get:
> 
> A: ret == -ENODEV
> B: ret == 0
> C: ret != 0 && ret != -ENODEV

Let me try again: 

Why A and C should be treated differently? What will behave incorrectly, in case of
C?

> 
> /Jarkko


