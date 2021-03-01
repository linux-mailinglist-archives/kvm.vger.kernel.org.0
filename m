Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF5C32776B
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 07:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhCAGOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 01:14:15 -0500
Received: from mga06.intel.com ([134.134.136.31]:6306 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231247AbhCAGOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 01:14:14 -0500
IronPort-SDR: JDxwnz1Wkq3Qp5gKNMYZt630Wgahkjk2vb230xTP+RkVODYgmYZ2maMeT4bS4aoh8Eo3y6ypHI
 fHV6Dg/471UQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="247780721"
X-IronPort-AV: E=Sophos;i="5.81,214,1610438400"; 
   d="scan'208";a="247780721"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2021 22:13:31 -0800
IronPort-SDR: gjjuLpoz9CdjFbuuRI3Jf02DDXMPatetPJznPnEPkciJpm5g/1hjgCxG3fbHunpHG807ca7fhF
 z2aztX39tyJw==
X-IronPort-AV: E=Sophos;i="5.81,214,1610438400"; 
   d="scan'208";a="517310331"
Received: from jscomeax-mobl.amr.corp.intel.com ([10.252.139.76])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2021 22:13:28 -0800
Message-ID: <c528da37e6ea6172d68270d8bdc1280afc1e98c8.camel@intel.com>
Subject: Re: [RFC PATCH v6 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave@sr71.net>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        jarkko@kernel.org, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Mon, 01 Mar 2021 19:13:25 +1300
In-Reply-To: <55e0f003-ca2b-24d2-5a23-31a77c5b943d@sr71.net>
References: <cover.1614338774.git.kai.huang@intel.com>
         <308bd5a53199d1bf520d488f748e11ce76156a33.1614338774.git.kai.huang@intel.com>
         <746450bb-917d-ab6c-9a6a-671112cd203e@sr71.net>
         <YDlRgtnVS4+KkzUW@google.com>
         <55e0f003-ca2b-24d2-5a23-31a77c5b943d@sr71.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-02-26 at 12:12 -0800, Dave Hansen wrote:
> On 2/26/21 11:52 AM, Sean Christopherson wrote:
> > > We must give a more informative message saying that the page is leaked.
> > >  Ideally, we'd also make this debuggable by dumping out how many of
> > > these pages there have been somewhere.  That can wait, though, until we
> > > have some kind of stats coming out of the code (there's nothing now).  A
> > > comment to remind us to do this would be nice.
> > Eh, having debugged these several times, the WARN_ONCE in sgx_reset_epc_page()
> > is probably sufficient.  IIRC, when I hit this, things were either laughably
> > broken and every page was failing, or there was another ENCLS failure somewhere
> > else that provided additional info.  Not saying don't add more debug info,
> > rather that it's probably not a priority.
> 
> Minimally, I just want a warning that says, "Whoops, I leaked a page".
> Or EREMOVE could even say, "whoops, this *MIGHT* leak a page".
> 
> My beef is mostly that "EREMOVE failed" doesn't tell and end user squat
> about what this means for their system.  At least if we say "leaked",
> they have some inclination that they've got to reboot to get the page back.

Agreed that a msg to say EPC page is leaked is useful. However I found with current
sgx_reset_epc_page() I cannot find a suitable place to add:

Theoretically, it's not that right to add "EPC page is leaked", or even *might* (btw,
I don't think we should use *might* since it is vague), in to sgx_reset_epc_page(),
since whether leak or not is controlled by whether to call sgx_free_epc_page() upon
error, which is not in sgx_reset_epc_page(). And

	if (!sgx_reset_epc_page())
		sgx_free_epc_page();

is called 3 times so I don't want to add a msg for each of them.

I ended up with this solution: 

1) Rename existing sgx_free_epc_page() to sgx_encl_free_epc_page() to make it more
specific that it is used to free EPC page that is assigned to an enclave. 2) Wrap
non-EREMOVE part (putting back to free EPC pool) to sgx_free_epc_page() so it can be
used by virtual EPC.

In this way we can just put the error msg in sgx_encl_free_epc_page().

And as you said it's time to get RFC tag off, so I'll send out formal patch with
above solution, but w/o your Acked-by on this particular patch. Thanks :)

