Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD7532A6D2
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448963AbhCBPxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:53:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:28029 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239889AbhCBAgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:36:18 -0500
IronPort-SDR: aVUhxmNESQveZO4dyfIEmEkrZVhgGoZeTfSD5QT5Oe01vBC4IcLqDGupiV7uQChxGa/DJc4fir
 syDWkYLt0Zug==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="250689958"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="250689958"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:34:52 -0800
IronPort-SDR: q/gVISHjvG9nz3tcGBNF2kID5er53oMhF8pXWDjUedqSozUxg5VB4RjzHUvh05q0z5shv0bjnJ
 j2vQ9wXi3Ehg==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427144731"
Received: from yueliu2-mobl.amr.corp.intel.com ([10.252.139.111])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:34:48 -0800
Message-ID: <bbebb1b782ace1b4b9ba17cb4cefacead97d73b0.camel@intel.com>
Subject: Re: [PATCH 12/25] x86/sgx: Add helper to update SGX_LEPUBKEYHASHn
 MSRs
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Tue, 02 Mar 2021 13:34:46 +1300
In-Reply-To: <YD0c4rEAbx2y5CXT@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
         <6730fbd2f7b26532f09e5a5e416a58f03a66d222.1614590788.git.kai.huang@intel.com>
         <YD0c4rEAbx2y5CXT@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-03-01 at 08:57 -0800, Sean Christopherson wrote:
> On Mon, Mar 01, 2021, Kai Huang wrote:
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 8c922e68274d..276220d0e4b5 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -696,6 +696,21 @@ static bool __init sgx_page_cache_init(void)
> >  	return true;
> >  }
> >  
> > 
> > 
> > 
> > +
> > +/*
> > + * Update the SGX_LEPUBKEYHASH MSRs to the values specified by caller.
> > + * Bare-metal driver requires to update them to hash of enclave's signer
> > + * before EINIT. KVM needs to update them to guest's virtual MSR values
> > + * before doing EINIT from guest.
> > + */
> > +void sgx_update_lepubkeyhash(u64 *lepubkeyhash)
> > +{
> > +	int i;
> 
> Probably worth adding:
> 
> 	WARN_ON_ONCE(preemptible());

Agreed. Will do.

> 
> > +
> > +	for (i = 0; i < 4; i++)
> > +		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
> > +}
> > +
> >  static int __init sgx_init(void)
> >  {
> >  	int ret;


