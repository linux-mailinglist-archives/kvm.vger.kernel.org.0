Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61CD357776
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 00:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhDGWQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 18:16:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:6863 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhDGWQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 18:16:03 -0400
IronPort-SDR: jhKRl8WJjFwuNjHtr92qypvjoxC/H0RcgmlC7gdSjIR31vEHT6T96kzf90vf8bs1RwMH5BzEh8
 bBYZyN1zMazA==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="180950759"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="180950759"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 15:15:52 -0700
IronPort-SDR: v8ELuDqiGdeZnUNa8G8KwP1ZNE8zun454H7R0pPUGNbJK2zIlpGeAczCtPE/yX1VtC16iX46iD
 WfEmI9ag3DIw==
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="598524665"
Received: from tkokeray-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.113.100])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 15:15:49 -0700
Date:   Thu, 8 Apr 2021 10:15:47 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 07/11] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-Id: <20210408101547.3d3be1b4efc43f597d44c0f2@intel.com>
In-Reply-To: <YG4t3DYYNd4eBeNt@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
        <963a2416333290e23773260d824a9e038aed5a53.1617825858.git.kai.huang@intel.com>
        <YG4t3DYYNd4eBeNt@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 22:10:36 +0000 Sean Christopherson wrote:
> On Thu, Apr 08, 2021, Kai Huang wrote:
> > +	/*
> > +	 * sgx_virt_ecreate() returns:
> > +	 *  1) 0:	ECREATE was successful
> > +	 *  2) -EFAULT:	ECREATE was run but faulted, and trapnr was set to the
> > +	 *  		exception number.
> > +	 *  3) -EINVAL:	access_ok() on @secs_hva fails. It's a kernel bug and
> > +	 *  		sgx_virt_ecreate() aleady gave a warning.
> 
> Eh, I don't love "kernel bug", all we know is that access_ok() failed.  It's
> also not all that helpful since it doesn't guide the debugger to any particular
> code that would prevent access_ok() from failing.
> 
> What if this comment simply states the rules/expectations and lets the debugger
> figure out what's wrong?  E.g.
> 
> 	 *  3) -EINVAL: access_ok() on @secs_hva failed.  This should never
> 	 *              happen as KVM checks host addresses at memslot creation.
> 	 *              sgx_virt_create() has already warned in this case.
> 
> Same goes for sgx_virt_einit() in the next patch.

Sure. Will update in next version.

> 
> > +	 */
> > +	ret = sgx_virt_ecreate(pageinfo, (void __user *)secs_hva, &trapnr);
> > +	if (!ret)
> > +		return kvm_skip_emulated_instruction(vcpu);
> > +	if (ret == -EFAULT)
> > +		return sgx_inject_fault(vcpu, secs_gva, trapnr);
> > +
> > +	return ret;
> > +}
