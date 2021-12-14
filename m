Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64353474098
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 11:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhLNKlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 05:41:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:11473 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231272AbhLNKlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 05:41:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639478480; x=1671014480;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RASC9tkX/qeuaKuqj+j/co1PDOniTmejosj0dqMzGoY=;
  b=eLrf2ie+oolgksZuhA57dGNLMvdT1g4VmQkuuLkCDUawgbxQCJKaT55E
   S+T6riA2KvoZbI5GeEKndRsDbdlC6xWe403fiKUVIlORzY4QpWV4FKAJX
   JzLOCSrm9hJNFQrugWRxW7uaLlLtilZscHOeDUmduOJ6TGSKsRmR4PLGM
   gKrzSiKnB1EY1F9DM4iiF3TWG2y2kUQe6rlVx9uqF6ylHRSoDy74uG2Wa
   uhrLV+ePglyC2O/meisv1HCHJMYTQq9ma/FYVYXYLRwuEAFhndEhjyTG8
   OSMLbb5qgegvENc/v3tDVFYDP5rfVnFkDoyWGKbAO6B41sDWCkVHHYg+8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="236483828"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="236483828"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 02:41:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="518181709"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 14 Dec 2021 02:41:16 -0800
Date:   Tue, 14 Dec 2021 18:26:19 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Message-ID: <20211214102619.GA25456@yangzhon-Virtual>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
 <fd16797c-b80f-c414-a731-0b9b73a3732e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd16797c-b80f-c414-a731-0b9b73a3732e@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021 at 05:02:49PM +0100, Paolo Bonzini wrote:
> First, the MSR should be added to msrs_to_save_all and
> kvm_cpu_cap_has(X86_FEATURE_XFD) should be checked in
> kvm_init_msr_list.
> 
> It seems that RDMSR support is missing, too.
> 
> More important, please include:
> 
> - documentation for the new KVM_EXIT_* value
> 
> - a selftest that explains how userspace should react to it.
> 
> This is a strong requirement for any new API (the first has been for
> years; but the latter is also almost always respected these days).
> This series should not have been submitted without documentation.
> 
> Also:
> 
> On 12/8/21 01:03, Yang Zhong wrote:
> >
> >+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XFD))
> >+			return 1;
> 
> This should allow msr->host_initiated always (even if XFD is not
> part of CPUID).  However, if XFD is nonzero and
> kvm_check_guest_realloc_fpstate returns true, then it should return
> 1.
> 
> The selftest should also cover using KVM_GET_MSR/KVM_SET_MSR.
> 

  Paolo, Seems we do not need new KVM_EXIT_* again from below thomas' new patchset:
  git://git.kernel.org/pub/scm/linux/kernel/git/people/tglx/devel.git x86/fpu-kvm

  So the selftest stll need support KVM_GET_MSR/KVM_SET_MSR for MSR_IA32_XFD
  and MSR_IA32_XFD_ERR? If yes, we only do some read/write test with vcpu_set_msr()/
  vcpu_get_msr() from new selftest tool? or do wrmsr from guest side and check this value
  from selftest side? 

  I checked some msr selftest reference code, tsc_msrs_test.c, which maybe better for this
  reference. If you have better suggestion, please share it to me. thanks!

  Yang 


