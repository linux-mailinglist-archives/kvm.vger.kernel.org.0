Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB2A354B3C
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 05:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242306AbhDFDeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 23:34:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:45584 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238560AbhDFDeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 23:34:12 -0400
IronPort-SDR: SjRezrz+LpJ971R+cczF9pobcpcBosvD54Zgepjqt/51Hq4eVyzOReiD9bz/D4Ws3ze/Ua1H21
 za/2CR9t+Waw==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="173049550"
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="173049550"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 20:34:05 -0700
IronPort-SDR: TLr8Nu1ypU+AsAx50MmmG8LA4at8dJwZkiWb5LDo7bbfSHqs50NfbGO9eNSfD9Fqq7UZtj/Dm9
 14mShHFdgpJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,308,1610438400"; 
   d="scan'208";a="440753642"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 05 Apr 2021 20:34:02 -0700
Message-ID: <69c69e29813f32d534b34c84d91f366df58eefe0.camel@linux.intel.com>
Subject: Re: [RFC PATCH 02/12] x86/cpufeature: Add CPUID.19H:{EBX,ECX} cpuid
 leaves
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Date:   Tue, 06 Apr 2021 11:34:01 +0800
In-Reply-To: <YGstqj6YH96jrlAl@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
         <1611565580-47718-3-git-send-email-robert.hu@linux.intel.com>
         <YGstqj6YH96jrlAl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-04-05 at 15:32 +0000, Sean Christopherson wrote:
> > diff --git a/arch/x86/include/asm/cpufeatures.h
> > b/arch/x86/include/asm/cpufeatures.h
> > index 8f2f050..d4a883a 100644
> > --- a/arch/x86/include/asm/cpufeatures.h
> > +++ b/arch/x86/include/asm/cpufeatures.h
> > @@ -13,7 +13,7 @@
> >  /*
> >   * Defines x86 CPU feature bits
> >   */
> > -#define NCAPINTS			19	   /* N 32-bit words worth
> > of info */
> > +#define NCAPINTS			21	   /* N 32-bit words worth
> > of info */
> >  #define NBUGINTS			1	   /* N 32-bit bug flags */
> >  
> >  /*
> > @@ -382,6 +382,15 @@
> >  #define X86_FEATURE_CORE_CAPABILITIES	(18*32+30) /* ""
> > IA32_CORE_CAPABILITIES MSR */
> >  #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative
> > Store Bypass Disable */
> >  
> > +/* Intel-defined KeyLocker feature CPUID level 0x00000019 (EBX),
> > word 20*/
> > +#define X86_FEATURE_KL_INS_ENABLED  (19*32 + 0) /* "" Key Locker
> > instructions */
> > +#define X86_FEATURE_KL_WIDE  (19*32 + 2) /* "" Wide Key Locker
> > instructions */
> > +#define X86_FEATURE_IWKEY_BACKUP  (19*32 + 4) /* "" IWKey backup
> > */
> > +
> > +/* Intel-defined KeyLocker feature CPUID level 0x00000019 (ECX),
> > word 21*/
> > +#define X86_FEATURE_IWKEY_NOBACKUP  (20*32 + 0) /* "" NoBackup
> > parameter to LOADIWKEY */
> > +#define X86_FEATURE_IWKEY_RAND  (20*32 + 1) /* IWKey Randomization
> > */
> 
> These should probably go into a Linux-defined leaf, I'm guessing
> neither leaf
> will be anywhere near full, at least in Linux.  KVM's reverse-CPUID
> code will
> likely/hopefully be gaining support for scattered leafs in the near
> future[*],
> that side of things should be a non-issue if/when this lands.
> 
> https://lkml.kernel.org/r/02455fc7521e9f1dc621b57c02c52cd04ce07797.1616136308.git.kai.huang@intel.com

Yes, in my internal private tree, I have refactored code based on your
patch.

BTW, I'm thinking, what if when those new HW-defined leaves got more
occupied? will then they be moved from the Linux-defined leaves to new
truely-map-to-HW-definition leaves?

