Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC88EB57F2
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 00:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfIQWY0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 18:24:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:63482 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbfIQWY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 18:24:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 15:24:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,518,1559545200"; 
   d="scan'208";a="193880518"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Sep 2019 15:24:25 -0700
Date:   Tue, 17 Sep 2019 15:24:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, jmattson@google.com, pshier@google.com,
        krish.sadhukhan@oracle.com
Subject: Re: [kvm-unit-tests PATCH v4 1/2] x86: nvmx: fix bug in
 __enter_guest()
Message-ID: <20190917222424.GA10319@linux.intel.com>
References: <20190917201602.113133-1-marcorr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917201602.113133-1-marcorr@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 01:16:01PM -0700, Marc Orr wrote:
> __enter_guest() should only set the launched flag when a launch has
> succeeded. Thus, don't set the launched flag when the VMX_ENTRY_FAILURE,
> bit 31, is set in the VMCS exit reason.
> 
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---
>  x86/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 6079420db33a..7313c78f15c2 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -1820,7 +1820,7 @@ static void __enter_guest(u8 abort_flag, struct vmentry_failure *failure)
>  		abort();
>  	}
>  
> -	if (!failure->early) {
> +	if (!failure->early && !(vmcs_read(EXI_REASON) & VMX_ENTRY_FAILURE)) {

Good enough for now, but struct vmentry_failure really needs to be cleaned
up and renamed.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

>  		launched = 1;
>  		check_for_guest_termination();
>  	}
> -- 
> 2.23.0.237.gc6a4ce50a0-goog
> 
