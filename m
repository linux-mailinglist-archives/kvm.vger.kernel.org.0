Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5053310066
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 23:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhBDW4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 17:56:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:28394 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhBDW4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 17:56:47 -0500
IronPort-SDR: x7hS1k1mdxIKt4ygq6cbDbiWRAdoLx/Ryw4XigdRALT+yhqtx5DxAfrtTFGS3HO9RGS1VrIu+S
 y5N9M8koOQJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="245413414"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="245413414"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 14:56:05 -0800
IronPort-SDR: 0rJovWCJqwYk8U1DeFP0T3Goh9PEWc49ptonH1/M8aqA2vmhCbjhIzGQLtYcG4IU2DuMl+1rbO
 dXFNRYoFReYw==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="434145373"
Received: from pmewert-mobl.amr.corp.intel.com ([10.254.98.203])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 14:56:02 -0800
Message-ID: <06ef6b5ea45d334f133e67fc6f323b7cfd9ae49f.camel@intel.com>
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver
 even when SGX driver is disabled
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Fri, 05 Feb 2021 11:56:00 +1300
In-Reply-To: <7a1d2316-5ce2-63fa-4186-a623dac1ecc8@intel.com>
References: <YBmX/wFFshokDqWM@google.com> <YBndRM9m0XHYwsPP@kernel.org>
         <20210203134906.78b5265502c65f13bacc5e68@intel.com>
         <YBsdeco/t8sa7ecV@kernel.org> <YBsq45IDDX9PPc7s@google.com>
         <YBtQRCC3NHBmtrck@kernel.org>
         <b63bf7db09442e994563ccc3a3b608fc2f17b784.camel@intel.com>
         <YBtkkEp5hXpTl84s@kernel.org> <YBtlTE2xZ3wBrukB@kernel.org>
         <b523357d2f062bf801d8fa1b05bf7abf13c19e89.camel@intel.com>
         <YBwJ5S0C3dMS2AFY@kernel.org>
         <7a1d2316-5ce2-63fa-4186-a623dac1ecc8@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-02-04 at 14:41 -0800, Dave Hansen wrote:
> On 2/4/21 6:51 AM, Jarkko Sakkinen wrote:
> > > > A: ret == -ENODEV
> > > > B: ret == 0
> > > > C: ret != 0 && ret != -ENODEV
> > > Let me try again: 
> > > 
> > > Why A and C should be treated differently? What will behave incorrectly, in case of
> > > C?
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
>  	 */
> 	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> 	if (ret)
> 		goto err_kthread;
> 

Perfect to me. Thanks.

