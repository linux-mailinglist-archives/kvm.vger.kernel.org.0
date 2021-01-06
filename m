Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BC92EC611
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 23:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbhAFWMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 17:12:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:39507 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbhAFWMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 17:12:52 -0500
IronPort-SDR: SkZi+whbm6SJnzO1N3xsp11iC+dpiXmsS7UiGef8yS+6mFTEQ0o503Ugtoc41vOXgQUNgQuwGz
 Yhb0C4TYaIbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="195894393"
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="195894393"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 14:12:12 -0800
IronPort-SDR: 4Yo+n2zROsvNYYwuuMK5dewuSVtcH4TMRpLdY76u8WrqqBkvg0XldDl2aeCBrdC3ndpn4V3opi
 nS9ZAQZbWd9w==
X-IronPort-AV: E=Sophos;i="5.79,328,1602572400"; 
   d="scan'208";a="351018269"
Received: from vastrong-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.243])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2021 14:12:08 -0800
Date:   Thu, 7 Jan 2021 11:12:06 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <haitao.huang@intel.com>, <pbonzini@redhat.com>,
        <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2
 sub-features
Message-Id: <20210107111206.c8207e64540a8361c04259b7@intel.com>
In-Reply-To: <6d28e858-a5c0-6ce8-8c0d-2fdfbea3734b@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
        <6d28e858-a5c0-6ce8-8c0d-2fdfbea3734b@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Jan 2021 11:39:46 -0800 Dave Hansen wrote:
> On 1/5/21 5:55 PM, Kai Huang wrote:
> > --- a/arch/x86/kernel/cpu/feat_ctl.c
> > +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > @@ -97,6 +97,8 @@ static void clear_sgx_caps(void)
> >  {
> >  	setup_clear_cpu_cap(X86_FEATURE_SGX);
> >  	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> > +	setup_clear_cpu_cap(X86_FEATURE_SGX1);
> > +	setup_clear_cpu_cap(X86_FEATURE_SGX2);
> >  }
> 
> Logically, I think you want this *after* the "Allow SGX virtualization
> without Launch Control support" patch.  As it stands, this will totally
> disable SGX (including virtualization) if launch control is unavailable.

To me it is better to be here, since clear_sgx_caps(), which disables SGX
totally, should logically clear all SGX feature bits, no matter later patch's
behavior. So when new SGX bits are introduced, clear_sgx_caps() should clear
them too. Otherwise the logic of this patch (adding new SGX feature bits) is
not complete IMHO.

And actually in later patch "Allow SGX virtualization without Launch Control
support", a new clear_sgx_lc() is added, and is called when LC is not
available but SGX virtualization is enabled, to make sure only SGX_LC bit is
cleared in this case. I don't quite understand why we need to clear SGX1 and
SGX2 in clear_sgx_caps() after the later patch.
