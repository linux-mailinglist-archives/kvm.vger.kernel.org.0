Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B92FE131
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 05:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbhAUDw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 22:52:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:11882 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404443AbhATXy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 18:54:58 -0500
IronPort-SDR: dX8ra6GDEPK9uJ4i61e8qejUPVvPoKz3CDz2DdezQ4V4XfPSFEyfkYmV59fX0DKhWTHUCMWH0Q
 fwTbEyKfrRtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="243263645"
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="243263645"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:50:06 -0800
IronPort-SDR: 4AP6fJa7VhL+aPyngr1xLfCcgtI+WKM5lnw+ImFph7KA+lkiTcrSCxGuCQWzkdB5zYrIFdo7J5
 atn9W1769BLg==
X-IronPort-AV: E=Sophos;i="5.79,362,1602572400"; 
   d="scan'208";a="407066573"
Received: from gapoveda-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.186])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 15:50:02 -0800
Date:   Thu, 21 Jan 2021 12:50:00 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <jethro@fortanix.com>, <b.thiel@posteo.de>
Subject: Re: [RFC PATCH v2 06/26] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-Id: <20210121125000.c8b68c0510c9cdebbafd572a@intel.com>
In-Reply-To: <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
        <a6c0b0d2632a6c603e68d9bdc81f564290ff04ad.1610935432.git.kai.huang@intel.com>
        <bc73adaf-fae6-2088-c8d4-6f53057a4eac@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jan 2021 13:02:15 -0800 Dave Hansen wrote:
> On 1/17/21 7:27 PM, Kai Huang wrote:
> > -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > -		     IS_ENABLED(CONFIG_X86_SGX);
> > +	enable_sgx_driver = cpu_has(c, X86_FEATURE_SGX) &&
> > +			    cpu_has(c, X86_FEATURE_SGX1) &&
> > +			    IS_ENABLED(CONFIG_X86_SGX) &&
> > +			    cpu_has(c, X86_FEATURE_SGX_LC);
> > +	enable_sgx_virt = cpu_has(c, X86_FEATURE_SGX) &&
> > +			  cpu_has(c, X86_FEATURE_SGX1) &&
> > +			  IS_ENABLED(CONFIG_X86_SGX) &&
> > +			  IS_ENABLED(CONFIG_X86_SGX_VIRTUALIZATION) &&
> > +			  enable_vmx;
> 
> Would it be too much to ask that the SGX/SGX1 checks not be duplicated?
>  Perhaps:
> 
> 	enable_sgx_any = cpu_feature_enabled(CONFIG_X86_SGX) &&
> 			 cpu_feature_enabled(CONFIG_X86_SGX1);
> 
> 	enable_sgx_driver = enable_sgx_any &&
> 			    cpu_has(c, X86_FEATURE_SGX_LC);
> 
> 	enable_sgx_virt = enable_sgx_any &&
> 			  enable_vmx &&
> 		     IS_ENABLED(CONFIG_X86_SGX_VIRTUALIZATION)
> 

I am happy to do it. Thanks.
