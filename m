Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9696F2F46F4
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 09:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbhAMI4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 03:56:36 -0500
Received: from mga06.intel.com ([134.134.136.31]:60062 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbhAMI4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 03:56:36 -0500
IronPort-SDR: f4FoFy6nq6D+OT1iwbajEg6Gp3GBUaawvW50zMOwTzz9AtiUS3KGfzkVfkmZICjK6Z22FQ16cH
 iPcU54xnGlBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="239714988"
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="239714988"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 00:55:54 -0800
IronPort-SDR: QW8QHbRBBNihnFpi+b2RJHCR1kQGzt9rZqUJbbLgXgPmyoi5Ul0MODuUpFhyt2YqiajX9b9B8+
 55TIxwF/XzSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,343,1602572400"; 
   d="scan'208";a="464832307"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.172])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jan 2021 00:55:51 -0800
Date:   Wed, 13 Jan 2021 17:07:38 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86/access: Fixed test stuck issue on new
 52bit machine
Message-ID: <20210113090738.GA26448@local-michael-cet-test.sh.intel.com>
References: <20210110091942.12835-1-weijiang.yang@intel.com>
 <X/zQdznwyBXHoout@google.com>
 <20210112090421.GA2614@local-michael-cet-test.sh.intel.com>
 <X/3V92hO1Sw1IdfZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/3V92hO1Sw1IdfZ@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 09:01:43AM -0800, Sean Christopherson wrote:
> On Tue, Jan 12, 2021, Yang Weijiang wrote:
> > On Mon, Jan 11, 2021 at 02:25:59PM -0800, Sean Christopherson wrote:
> > > On Sun, Jan 10, 2021, Yang Weijiang wrote:
> > > > When the application is tested on a machine with 52bit-physical-address, the
> > > > synthesized 52bit GPA triggers EPT(4-Level) fast_page_fault infinitely.
> > > 
> > > That doesn't sound right, KVM should use 5-level EPT if guest maxpa > 48.
> > > Hmm, unless the CPU doesn't support 5-level EPT, but I didn't think such CPUs
> > > (maxpa=52 w/o 5-level EPT) existed?  Ah, but it would be possible with nested
> > > VMX, and initial KVM 5-level support didn't allow nested 5-level EPT.  Any
> > > chance you're running this test in a VM with 5-level EPT disabled, but maxpa=52?
> > >
> > Hi, Sean,
> > Thanks for the reply!
> > I use default settings of the unit-test + 5.2.0 QEMU + 5.10 kernel, in
> 
> The default settings are supposed to set guest.MAXPA = host.MAXPA.  At least, I
> assume that's the purpose of '-cpu max'.  Maybe your copy of kvm-unit-tests'
> x86/unittests.cfg is stale?
> 
>   [access]
>   file = access.flat
>   arch = x86_64
>   extra_params = -cpu max
>   timeout = 180
> 
Yes, I used the default max option, but looks like guest max physical
address is forgotten somehow in this case. Anyway, I dropped a patch to
QEMU community to enable it.

> > this case, QEMU uses cpu->phys_bits==40, so the guest's PA=40bit and
> > LA=57bit, hence 5-level EPT is not enabled. My physical machine is PA=52
> > and LA=57 as can checked from cpuid:
> > cpuid -1r -l 0x80000008 -s 0
> > CPU:
> >    0x80000008 0x00: eax=0x00003934 ...
> > There're two other ways to w/a this issue: 1) change the QEMU params to
> > to extra_params = -cpu host,host-phys-bits, so guest's PA=52 and LA=57,
> > this will enable 5-level EPT, meanwhile, it escapes the problematic GPA
> > by adding AC_*_BIT51_MASK in invalid_mask.
> > 
> > 2) add allow_smaller_maxphyaddr=1 to kvm-intel module.
> 
> Setting allow_smaller_maxphyaddr=1 is the correct answer.
