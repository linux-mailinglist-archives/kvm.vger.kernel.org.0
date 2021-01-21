Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA6F2FDE76
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732030AbhAUBID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:08:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:56034 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732054AbhAUBHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 20:07:34 -0500
IronPort-SDR: kMdM71PmPru8wYIK+jO8ZVuLu26R31rOcoX70hzsU7TIfDFmRyC7QdGgxpjhQBUpeS40QkElpr
 hObPzgolTknQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="197933704"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="197933704"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:06:44 -0800
IronPort-SDR: VwYre2KwAVOSYN2i4JcVTvwsOLtysMR/qjIRFe+knj324hR4HrTUcRqzfzV3sI4+9FZtz+gPBO
 ZhXz8QlmIarA==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="427102469"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 17:06:40 -0800
Date:   Thu, 21 Jan 2021 14:06:38 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>,
        <kvm@vger.kernel.org>, <x86@kernel.org>, <seanjc@google.com>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH v2 12/26] x86/sgx: Add helper to update
 SGX_LEPUBKEYHASHn MSRs
Message-Id: <20210121140638.b9bac5af44fc0f33996a2853@intel.com>
In-Reply-To: <982ddc27-27ec-2d03-54a4-1c0b07e8a3c9@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
        <5116fdc732e8e14b3378c44e3b461a43f330ed0c.1610935432.git.kai.huang@intel.com>
        <YAgcIhkmw0lllD3G@kernel.org>
        <8613b3f1-c4f6-3e5d-4406-9476727666a7@intel.com>
        <20210121123625.c45deeccc690138f2417bd41@intel.com>
        <982ddc27-27ec-2d03-54a4-1c0b07e8a3c9@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 15:50:31 -0800 Dave Hansen wrote:
> On 1/20/21 3:36 PM, Kai Huang wrote:
> > I actually feel the function name already explains what the function does
> > clearly, therefore I don't think even comment is needed. To be honest I
> > don't know how to rephrase here. Perhaps:
> > 
> > /* Update SGX LEPUBKEYHASH MSRs of the platform. */
> 
> Whee!  I'm gonna write me a function comment!
> 
> /*
>  * A Launch Enclave (LE) must be signed with a public key
>  * that matches this SHA256 hash.  Usually overwrites Intel's
>  * default signing key.
>  */
> 
> So, this isn't a one-liner.  *But*, it tells us what "le" means, what
> "pubkey" means and implies that there need to be 4x64-bits worth of MSR
> writes to get to a SHA256 hash.  

In current linux driver implementation, LE is effectively abandoned, because
the initialization of any enclave doesn't take a valid TOKEN, making
initializing enclave requires hash of enclave's signer equal to the hash in
SGX_LEPUBKEYHASH MSRs. 

I written the function name based on SDM's description, to reflect the fact
that we are updating the SGX_LEPUBKEYHASH MSRs, but nothing more.

So perhaps below?

/*
 * Update the SGX_LEPUBKEYHASH MSRs to the values specified by caller.
 *
 * EINITTOKEN is not used in enclave initialization, which requires
 * hash of enclave's signer must match values in SGX_LEPUBKEYHASH MSRs
 * to make EINIT be successful.
 */


It also tells what it's usually doing
> here: overwriting Intel's blasted hash.

Technically, only initial value is intel's pubkey hash. This function
overwrites whatever pubkey hash that used to sign previous enclave.

> 
> It sure beats the entirely uncommented for loop that we've got today.

Agreed, although to me it seems the comment is a little bit out of the scope
of this function itself, but is more about the logic of the caller.
