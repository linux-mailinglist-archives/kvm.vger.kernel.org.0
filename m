Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ACB3050B9
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 05:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbhA0EXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 23:23:45 -0500
Received: from mga06.intel.com ([134.134.136.31]:18876 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389526AbhA0AF4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 19:05:56 -0500
IronPort-SDR: gQ5INyTeTkFDLdcfwpaBuFIFqNVx8zX4DRdOitgLbS3s26ww7hF/KGMaiYq4wlVodznptJ5byD
 8xe1AwE/Q/gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="241520118"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="241520118"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:00:30 -0800
IronPort-SDR: LyDtHRIRhbRzfMaAD3eTyQWnx6VzE7ilwzaDwwPQOA1IhG27JX1JvP8MVWcSs5YwWBQteLydHz
 hRyZjP+aMIFA==
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="472934086"
Received: from rsperry-desk.amr.corp.intel.com ([10.251.7.187])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 16:00:26 -0800
Message-ID: <a7877d1d9624873d25da175a02d0840f7b5e91dc.camel@intel.com>
Subject: Re: [RFC PATCH v3 05/27] x86/sgx: Add SGX_CHILD_PRESENT hardware
 error code
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Wed, 27 Jan 2021 13:00:23 +1300
In-Reply-To: <3bdda0ea-3935-1a8a-8d11-b898371d6168@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
         <5a7c7715147f089d97ae4c033b74b0eafb8f3f89.1611634586.git.kai.huang@intel.com>
         <3bdda0ea-3935-1a8a-8d11-b898371d6168@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-26 at 07:49 -0800, Dave Hansen wrote:
> On 1/26/21 1:30 AM, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > SGX virtualization requires to allocate "raw" EPC and use it as "virtual
> > EPC" for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> > track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> > so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> > knowledge of which pages are SECS with non-zero child counts.
> 
> The grammar there is a bit questionable in spots.  Here's a rewrite:
> 
> SGX can accurately track how bare-metal enclave pages are used.  This
> enables SECS to be specifically targeted and EREMOVE'd only after all
> child pages have been EREMOVE'd.  This ensures that bare-metal SGX will
> never encounter SGX_CHILD_PRESENT in normal operation.

How about:

"SGX driver can accurate track how enclave pages are used. This enables..."

Since in another email, you mentioned that we should get rid of bare-metal driver,
and Andy suggested we can just use SGX driver?

> 
> Virtual EPC is different.  The host does not track how EPC pages are
> used by the guest, so it cannot guarantee EREMOVE success.  It might,
> for instance, encounter a SECS with a non-zero child count.
> 
> Aside: Would it be *possible* for the host to figure out where the SECS
> pages are?  If not, we can say "host can not track" versus what I said:
> "host does not track".

Technically it is possible, so "host does not track" is more reasonable.

> 
> > Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> > failures are expected, but only due to SGX_CHILD_PRESENT.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> With the improved changelog:
> 
> Acked-by: Dave Hansen <dave.hansen@intel.com>

Thanks.

