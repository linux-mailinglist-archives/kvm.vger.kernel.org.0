Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2942EC7C9
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 02:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbhAGBjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 20:39:43 -0500
Received: from mga17.intel.com ([192.55.52.151]:48257 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbhAGBjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 20:39:42 -0500
IronPort-SDR: gCK4z46qJUktLLh+3FC6v1x4TdQvrTPLIkcyx8uImkV8QDLQZ03EV0EYgtpJO+nkNfyQl+D27q
 a0IXtwhsmBbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="157142700"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="157142700"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 17:39:02 -0800
IronPort-SDR: EdZDSLnrykEpEI/YIFx2ASC6fAtw8AXOxsRXVKdriNvY0jQgl9GvkkIHbblXdrM2QJH/4NtQcu
 UIUmLcLlL1xg==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="351077237"
Received: from naljabex-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.117.182])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 17:38:58 -0800
Date:   Thu, 7 Jan 2021 14:38:55 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <jarkko@kernel.org>, <luto@kernel.org>,
        <haitao.huang@intel.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Subject: Re: [RFC PATCH 03/23] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210107143855.b316478af5d94ffa89bd6f41@intel.com>
In-Reply-To: <33d9bec8-9427-b9cd-a9fb-ca5c44e4d2fe@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <ace9d4cb10318370f6145aaced0cfa73dda36477.1609890536.git.kai.huang@intel.com>
        <2e424ff3-51cb-d6ed-6c5f-190e1d4fe21a@intel.com>
        <X/YfE28guNBxcpui@google.com>
        <20210107134758.ba0b5d950282973eaefe1ded@intel.com>
        <33d9bec8-9427-b9cd-a9fb-ca5c44e4d2fe@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 16:52:49 -0800 Dave Hansen wrote:
> On 1/6/21 4:47 PM, Kai Huang wrote:
> >>>> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> >>>> +	if (ret) {
> >>>> +		/*
> >>>> +		 * Only SGX_CHILD_PRESENT is expected, which is because of
> >>>> +		 * EREMOVE-ing an SECS still with child, in which case it can
> >>>> +		 * be handled by EREMOVE-ing the SECS again after all pages in
> >>>> +		 * virtual EPC have been EREMOVE-ed. See comments in below in
> >>>> +		 * sgx_virt_epc_release().
> >>>> +		 */
> >>>> +		WARN_ON_ONCE(ret != SGX_CHILD_PRESENT);
> >>>> +		return ret;
> >>>> +	}
> >>> I find myself wondering what errors could cause the WARN_ON_ONCE() to be
> >>> hit.  The SDM indicates that it's only:
> >>>
> >>> 	SGX_ENCLAVE_ACT If there are still logical processors executing
> >>> 			inside the enclave.
> >>>
> >>> Should that be mentioned in the comment?
> >> And faults, which are also spliced into the return value by the ENCLS macros.
> >> I do remember hitting this WARN when I broke things, though I can't remember
> >> whether it was a fault or the SGX_ENCLAVE_ACT scenario.  Probably the latter?
> > I'll add a comment saying that there should be no active logical processor
> > still running inside guest's enclave. We cannot handle SGX_ENCLAVE_ACT here
> > anyway.
> 
> One more thing...
> 
> Could we dump out the *actual* error code with a WARN(), please?  If we
> see a warning, I'd rather not have to disassemble the instructions and
> check against register values to see whether the error code was sane.

Sure. But WARN_ONCE() should be used, right, instead of WARN()?
