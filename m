Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE26354840
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 23:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbhDEVon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 17:44:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:22464 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241285AbhDEVof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 17:44:35 -0400
IronPort-SDR: AS/V0asYt8r4Z/kjetnJ2P5fDFYZ57Z7JiqIFrzoaBIukpp68LSRhCnl9FB4noqErhRDaAZ2S8
 wQ1C9ucsfJDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="192969212"
X-IronPort-AV: E=Sophos;i="5.81,307,1610438400"; 
   d="scan'208";a="192969212"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 14:44:27 -0700
IronPort-SDR: NL/8LNdLPJM1vO+5NCSHPWI4yacFrkBLuzlr9BGpbNHWAJbCL2tqrMIQxkty5FjOca8Ym8kP6R
 x8CtHID2LyhQ==
X-IronPort-AV: E=Sophos;i="5.81,307,1610438400"; 
   d="scan'208";a="518763072"
Received: from lddickin-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.112.181])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 14:44:24 -0700
Date:   Tue, 6 Apr 2021 09:44:21 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 13/25] x86/sgx: Add helpers to expose ECREATE and
 EINIT to KVM
Message-Id: <20210406094421.4fdfbb6c4c11e7ee64c3b0a3@intel.com>
In-Reply-To: <20210405090759.GB19485@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <20e09daf559aa5e9e680a0b4b5fba940f1bad86e.1616136308.git.kai.huang@intel.com>
        <20210405090759.GB19485@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Apr 2021 11:07:59 +0200 Borislav Petkov wrote:
> On Fri, Mar 19, 2021 at 08:23:08PM +1300, Kai Huang wrote:
> > +	/*
> > +	 * @secs is an untrusted, userspace-provided address.  It comes from
> > +	 * KVM and is assumed to be a valid pointer which points somewhere in
> > +	 * userspace.  This can fault and call SGX or other fault handlers when
> > +	 * userspace mapping @secs doesn't exist.
> > +	 *
> > +	 * Add a WARN() to make sure @secs is already valid userspace pointer
> > +	 * from caller (KVM), who should already have handled invalid pointer
> > +	 * case (for instance, made by malicious guest).  All other checks,
> > +	 * such as alignment of @secs, are deferred to ENCLS itself.
> > +	 */
> > +	WARN_ON_ONCE(!access_ok(secs, PAGE_SIZE));
> 
> So why do we continue here then? IOW:

The intention was to catch KVM bug, since KVM is the only caller, and in current
implementation KVM won't call this function if @secs is not a valid userspace
pointer. But yes we can also return here, but in this case an exception number
must also be specified to *trapnr so that KVM can inject to guest. It's not that
straightforward to decide which exception should we inject, but I think #GP
should be OK. Please see below.

> 
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index fdfc21263a95..497b06fc6f7f 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -270,7 +270,7 @@ int __init sgx_vepc_init(void)
>   *
>   * Return:
>   * - 0:		ECREATE was successful.
> - * - -EFAULT:	ECREATE returned error.
> + * - <0:	ECREATE returned error.
>   */
>  int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
>  		     int *trapnr)
> @@ -288,7 +288,9 @@ int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
>  	 * case (for instance, made by malicious guest).  All other checks,
>  	 * such as alignment of @secs, are deferred to ENCLS itself.
>  	 */
> -	WARN_ON_ONCE(!access_ok(secs, PAGE_SIZE));
> +	if (WARN_ON_ONCE(!access_ok(secs, PAGE_SIZE)))
> +		return -EINVAL;
> +

*trapnr should also be set to an exception before return -EINVAL. It's not
possible to get it from ENCLS_TRAPNR(ret) like below, since ENCLS hasn't been
run yet. I think it makes sense to just set it to #GP(X86_TRAP_GP), since
above error basically means SECS is not pointing to an valid EPC address, and
in such case #GP should happen based on SDM (SDM 40.3 ECREATE).

>  	__uaccess_begin();
>  	ret = __ecreate(pageinfo, (void *)secs);
>  	__uaccess_end();
> 
> > +	__uaccess_begin();
> > +	ret = __ecreate(pageinfo, (void *)secs);
> > +	__uaccess_end();
> > +
> > +	if (encls_faulted(ret)) {
> > +		*trapnr = ENCLS_TRAPNR(ret);
> > +		return -EFAULT;
> > +	}
> > +
> > +	/* ECREATE doesn't return an error code, it faults or succeeds. */
> > +	WARN_ON_ONCE(ret);
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(sgx_virt_ecreate);
> > +
> > +static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
> > +			    void __user *secs)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * Make sure all userspace pointers from caller (KVM) are valid.
> > +	 * All other checks deferred to ENCLS itself.  Also see comment
> > +	 * for @secs in sgx_virt_ecreate().
> > +	 */
> > +#define SGX_EINITTOKEN_SIZE	304
> > +	WARN_ON_ONCE(!access_ok(sigstruct, sizeof(struct sgx_sigstruct)) ||
> > +		     !access_ok(token, SGX_EINITTOKEN_SIZE) ||
> > +		     !access_ok(secs, PAGE_SIZE));
> 
> Ditto.

The same as above, *trapnr should be set to X86_TRAP_GP before return
-EINVAL, although for sigstruct, token, they are just normal memory, but not
EPC.

Sean, do you have comments?
