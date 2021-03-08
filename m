Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0611330A4F
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 10:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhCHJag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 04:30:36 -0500
Received: from mga05.intel.com ([192.55.52.43]:4791 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhCHJaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 04:30:16 -0500
IronPort-SDR: xcu7sOWR1fLJJJ6A5YCgKmTJYrmnJQrAG4gpht/uR2v6HLfQxU3XczRYpRMBVxn/1T3g7jp7kK
 yWij/Oi+HDKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="273022005"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="273022005"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 01:30:12 -0800
IronPort-SDR: diR/365hAgy68dFnjcy7Th7jZpHdZg1MAB0kVgUqPyV0CEA4aodHtYvTj3uQv6TJFd4hlRGmhh
 7ul4jOAyM+1A==
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="437333253"
Received: from ggkanher-mobl4.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 01:30:08 -0800
Date:   Mon, 8 Mar 2021 22:30:06 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     <linux-sgx@vger.kernel.org>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <seanjc@google.com>, <jarkko@kernel.org>,
        <luto@kernel.org>, <rick.p.edgecombe@intel.com>,
        <haitao.huang@intel.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Subject: Re: [RFC PATCH v6 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-Id: <20210308223006.5610bc084eb17844f43c0b27@intel.com>
In-Reply-To: <64a2d65f-ddf9-b42b-5b51-76bb3b79a30e@intel.com>
References: <cover.1614338774.git.kai.huang@intel.com>
        <14908104a7ff5724b6fb4e4c7df6e675adafe5a7.1614338774.git.kai.huang@intel.com>
        <64a2d65f-ddf9-b42b-5b51-76bb3b79a30e@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Mar 2021 09:51:56 -0800 Dave Hansen wrote:
> On 2/26/21 4:15 AM, Kai Huang wrote:
> > +int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
> > +		     int *trapnr)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * @secs is userspace address, and it's not guaranteed @secs points at
> > +	 * an actual EPC page. 
> 
> There are four cases that I can think of:
> 1. @secs points to an EPC page.  Good, return 0 and go on with life.
> 2. @secs points to a non-EPC page.  It will fault and permanently error
>    out
> 3. @secs points to a Present=0 PTE.  It will fault, but we need to call
>    the fault handler to get a page in here.
> 4. @secs points to a kernel address
> 
> #1 and #2 are handled and described.
> 
> #4 is probably impossible because the address comes out of some
> gpa_to_hva() KVM code.  But, it still _looks_ wonky here.  I wouldn't
> hate an access_ok() check on it.
> 
> 	/*
> 	 * @secs is an untrusted, userspace-provided address.  It comes
>          * from KVM and is assumed to point somewhere in userspace.
>  	 * This can fault and call SGX or other fault handlers.
> 	 */
> 
> You can also spend a moment to describe the kinds of faults that are
> handled and what is fatal.

Thanks Dave for the comments. I'll refine accordingly.

> 
> 
> > +	 * to physical EPC page by resolving PFN but using __uaccess_xx() is
> > +	 * simpler.
> > +	 */
> 
> I'd leave the justification for the changelog.

Will do.

> 
> > +	__uaccess_begin();
> > +	ret = __ecreate(pageinfo, (void *)secs);
> > +	__uaccess_end();
> > +
> > +	if (encls_faulted(ret)) {
> > +		*trapnr = ENCLS_TRAPNR(ret);
> > +		return -EFAULT;
> > +	}
> 
