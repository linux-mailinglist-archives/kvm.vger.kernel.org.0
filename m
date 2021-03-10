Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DD9334913
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 21:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhCJUoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 15:44:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:58443 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230491AbhCJUoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 15:44:15 -0500
IronPort-SDR: ziWv5KNtIST7z6I1+g9nvbU4w+qgqVyljisoYyRL5Tuj5dug9CxNoKmiWl7hwVGP2MDVZtibjB
 v5hercud+LoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="167835676"
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="167835676"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 12:44:15 -0800
IronPort-SDR: j71S+seXjSD2UZQz7i5nkTRxqrVG0IghE+KqmMko2hAAUd91sa+u9WXuqyx8cG45Iwth9SGz1l
 bMP616clnbTw==
X-IronPort-AV: E=Sophos;i="5.81,238,1610438400"; 
   d="scan'208";a="438040003"
Received: from xuhuiliu-mobl1.amr.corp.intel.com ([10.251.31.67])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 12:44:09 -0800
Message-ID: <519e3851e2857f653af29d64a79044cff233401b.camel@intel.com>
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de, jmattson@google.com, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net
Date:   Thu, 11 Mar 2021 09:44:07 +1300
In-Reply-To: <YEkJXu262YDa8ZaK@kernel.org>
References: <cover.1615250634.git.kai.huang@intel.com>
         <20210309093037.GA699@zn.tnic> <YEkJXu262YDa8ZaK@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-03-10 at 20:01 +0200, Jarkko Sakkinen wrote:
> On Tue, Mar 09, 2021 at 10:30:37AM +0100, Borislav Petkov wrote:
> > On Tue, Mar 09, 2021 at 02:38:49PM +1300, Kai Huang wrote:
> > > This series adds KVM SGX virtualization support. The first 14 patches starting
> > > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> > > support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> > 
> > Ok, I guess I'll queue 1-14 once Sean doesn't find anything
> > objectionable then give Paolo an immutable commit to base the KVM stuff
> > ontop.
> > 
> > Unless folks have better suggestions, ofc.
> 
> I'm otherwise cool with that, except patch #2.
> 
> It's based on this series:
> 
> https://lore.kernel.org/linux-sgx/20210113233541.17669-1-jarkko@kernel.org/
> 
> It's not reasonable to create driver specific wrapper for
> sgx_free_epc_page() because there is exactly *2* call sites of the function
> in the driver.  The driver contains 10 call sites (11 after my NUMA patches
> have been applied) of sgx_free_epc_page() in total.
> 
> Instead, it is better to add explicit EREMOVE to those call sites.
> 
> The wrapper only trashes the codebase. I'm not happy with it, given all the
> trouble to make it clean and sound.

However, your change has side effort: it always put page back into free pool, even
EREMOVE fails. To make your change w/o having any functional change, it has to be:

	if(!sgx_reset_epc_page())
		sgx_free_epc_page();

And for this, Dave raised one concern we should add a WARN() to let user know EPC
page is leaked, and reboot is requied to get them back.

However with sgx_reset_epc_page(), there's no place to add such WARN(), and
implementing original sgx_free_epc_page() as sgx_encl_free_epc_page() looks very
reasonable to me:

https://www.spinics.net/lists/linux-sgx/msg04631.html

Hi Dave,

What is your comment here?

> 
> > Thx.
> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
> > https://people.kernel.org/tglx/notes-about-netiquette
> 
> 
> /Jarkko


