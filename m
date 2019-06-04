Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C06349A5
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfFDN7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 09:59:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:24617 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbfFDN7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 09:59:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 06:59:09 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga005.fm.intel.com with ESMTP; 04 Jun 2019 06:59:09 -0700
Date:   Tue, 4 Jun 2019 06:59:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, pbonzini@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 1/2] kvm-unit-test: x86: Add a wrapper to check if the
 CPU supports NX bit in MSR_EFER
Message-ID: <20190604135908.GP13384@linux.intel.com>
References: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
 <20190522234545.5930-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522234545.5930-2-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 22, 2019 at 07:45:44PM -0400, Krish Sadhukhan wrote:
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  lib/x86/processor.h | 8 ++++++++
>  x86/vmexit.c        | 2 +-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 15237a5..2ca988e 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -476,4 +476,12 @@ static inline void set_bit(int bit, u8 *addr)
>  			     : "+m" (*addr) : "Ir" (bit) : "cc", "memory");
>  }
>  
> +static inline int efer_nx_enabled(void)

cpu_has_efer_nx() would be more appropriate.  Most readers would expect
"enabled" to mean we're checking MSR_EFER.NX==1.

This can have a boolean return value.

> +{
> +	if (cpuid(0x80000001).d & (1 << 20))
> +		return 1;
> +	else
> +		return 0;
> +}

This can simply be:

    return cpuid(0x80000001).d & (1 << 20);

or if gcc complains about boolean stuff:

    return !!(cpuid(0x80000001).d & (1 << 20));
> +
>  #endif
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index c12dd24..7053a46 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -526,7 +526,7 @@ static bool do_test(struct test *test)
>  
>  static void enable_nx(void *junk)
>  {
> -	if (cpuid(0x80000001).d & (1 << 20))
> +	if (efer_nx_enabled())
>  		wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX_MASK);
>  }
>  
> -- 
> 2.20.1
> 
