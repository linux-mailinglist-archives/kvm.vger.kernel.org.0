Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21152F40FF
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 02:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbhAMBQn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 12 Jan 2021 20:16:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:41221 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbhAMBQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 20:16:43 -0500
IronPort-SDR: 5dA1V977T/EoUbIZ1+UuvPOdGKQVJM6f+dAmvLgstgy5fzqssFLBWBYIzUDDOZh7VFD9mIlg3H
 NDB8ptZpPaMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="174624869"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="174624869"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 17:15:58 -0800
IronPort-SDR: p48fnh44ysKcN358GzCcAtXmQZxWJHipkmlxpO7Hkc7nvb9o/QmxE+JQXS/ziJvJ34Z9dbp1DI
 XMkKaR1arTZA==
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="381649432"
Received: from rjchin-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.18.242])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 17:15:55 -0800
Date:   Wed, 13 Jan 2021 14:15:54 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 01/23] x86/sgx: Split out adding EPC page to free
 list to separate helper
Message-Id: <20210113141554.52aa72520a056232459b4cba@intel.com>
In-Reply-To: <X/4YdCN9LwZGompH@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
        <3d50c2614ff8a46b44062a398fd8644bcda92132.1609890536.git.kai.huang@intel.com>
        <31681b840aac59a8d8dcb05f2356d25cf09e1f11.camel@kernel.org>
        <20210112131944.9d69bb30cf4b94b6f6f25e7b@intel.com>
        <X/4YdCN9LwZGompH@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 13:45:24 -0800 Sean Christopherson wrote:
> On Tue, Jan 12, 2021, Kai Huang wrote:
> > On Tue, 12 Jan 2021 00:38:40 +0200 Jarkko Sakkinen wrote:
> > > On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> > > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > 
> > > > SGX virtualization requires to allocate "raw" EPC and use it as virtual
> > > > EPC for SGX guest.  Unlike EPC used by SGX driver, virtual EPC doesn't
> > > > track how EPC pages are used in VM, e.g. (de)construction of enclaves,
> > > > so it cannot guarantee EREMOVE success, e.g. it doesn't have a priori
> > > > knowledge of which pages are SECS with non-zero child counts.
> > > > 
> > > > Split sgx_free_page() into two parts so that the "add to free list"
> > > > part can be used by virtual EPC without having to modify the EREMOVE
> > > > logic in sgx_free_page().
> > > > 
> > > > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > 
> > > I have a better idea with the same outcome for KVM.
> > > 
> > > https://lore.kernel.org/linux-sgx/20210111223610.62261-1-jarkko@kernel.org/T/#t
> > 
> > I agree with your patch this one can be replaced. I'll include your patch in
> > next version, and once it is upstreamed, it can be removed in my series.
> > 
> > Sean, please let me know if you have objection.
> 
> 6 of one, half dozen of the other.  I liked not having to modify the existing
> call sites, but it's your code.
> 
> Though on that topic, this snippet is wrong:
> 
> @@ -431,7 +443,8 @@ void sgx_encl_release(struct kref *ref)
>  		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
>  					   list);
>  		list_del(&va_page->list);
> -		sgx_free_epc_page(va_page->epc_page);
> +		sgx_reset_epc_page(entry->epc_page);
> +		sgx_free_epc_page(entry->epc_page);
> 
> s/entry/va_page in the new code.
> 
> P.S. I apparently hadn't been subscribed linux-sgx and so didn't see those
>      patches.  I'm now subscribed and can chime-in as needed.

Thanks. I also have replied to Jarkko's v2 patch, and I think you can see it
now.

I think if Jarkko's patch is eventually merged to upstream, we can drop
this patch. So please help to comment if Jarkko's patch is reasonable, since I
don't have history with SGX driver and cannot immediately tell if it is
reasonable.
