Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7731B1A6FD5
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 01:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgDMXav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 19:30:51 -0400
Received: from mga04.intel.com ([192.55.52.120]:61968 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbgDMXav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 19:30:51 -0400
IronPort-SDR: uL+o9OnxC0Ku67lo1TM/m+AXMaflaHOtCK9YlzPUKWF34dJsIzqJef7YtJBQ/Wy9GVGPb4ICJt
 cpEdOaOAol1Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 16:30:50 -0700
IronPort-SDR: 6xS3oIyiWPYzbuRuMfCpwesOhyBvX6iAngnFLjtn/UTd6IYVL3OoZLFq+1VlApXBC2iDRMQ/DC
 oVRktY4SdKOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,380,1580803200"; 
   d="scan'208";a="399774243"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 13 Apr 2020 16:30:47 -0700
Date:   Mon, 13 Apr 2020 16:30:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        ubizjak@gmail.com
Subject: Re: [PATCH] KVM: SVM: fix compilation with modular PSP and
 non-modular KVM
Message-ID: <20200413233047.GJ21204@linux.intel.com>
References: <20200413075032.5546-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413075032.5546-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 13, 2020 at 03:50:31AM -0400, Paolo Bonzini wrote:
> Use svm_sev_enabled() in order to cull all calls to PSP code.  Otherwise,
> compilation fails with undefined symbols if the PSP device driver is compiled
> as a module and KVM is not.
> 
> Reported-by: Uros Bizjak <ubizjak@gmail.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0e3fc311d7da..364ffe32139c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1117,7 +1117,7 @@ int __init sev_hardware_setup(void)
>  	/* Maximum number of encrypted guests supported simultaneously */
>  	max_sev_asid = cpuid_ecx(0x8000001F);
>  
> -	if (!max_sev_asid)
> +        if (!svm_sev_enabled())
>  		return 1;
>  
>  	/* Minimum ASID value that should be used for SEV guest */
> @@ -1156,6 +1156,9 @@ int __init sev_hardware_setup(void)
>  
>  void sev_hardware_teardown(void)
>  {
> +        if (!svm_sev_enabled())
> +                return;
> +

Tabs instead of spaces.  Checkpatch also whinges about going past 75 chars
in the changelog.

>  	bitmap_free(sev_asid_bitmap);
>  	bitmap_free(sev_reclaim_asid_bitmap);
>  
> -- 
> 2.18.2
> 
