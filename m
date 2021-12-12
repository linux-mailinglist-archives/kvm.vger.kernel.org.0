Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39AF471A67
	for <lists+kvm@lfdr.de>; Sun, 12 Dec 2021 14:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhLLNZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 08:25:59 -0500
Received: from mga18.intel.com ([134.134.136.126]:25181 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231147AbhLLNZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 08:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639315558; x=1670851558;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UVgsHQ0yCvU4R2e1t7Q7njPEsjY6WlZzqKR6lmHRqxw=;
  b=QfBdKkcORThQ3ha8S4zgcJPJmctO/9gcxw5rWjO+3EYTAGJMaRb0b5d2
   fiwLOTeUImx43xheV3QPzneBLbIDgpR5C94+DXCeg4TRzOUB2RJDUA2FK
   2Dciq/67d20nbZu7Tive2Ypx1nGHKioA3tLv6RjP3SYOZHcLBrmurYgGB
   8fb4C7cLNF3ez4jopZ4OMJK+IMxckzzaqLwS+B0v4epcMrjA1ArIMo9a9
   sFBRmmAapnmPTJHCGXJ8hJ5eZ7pS33PPJSaTzmxxR0DVTv3eJFwqlIkG8
   Yu25EWldS8ecJLcrC8TEfx8NA4qNNfW12T87PSQPsMcppYL9X2LZnSbDc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10195"; a="225465564"
X-IronPort-AV: E=Sophos;i="5.88,200,1635231600"; 
   d="scan'208";a="225465564"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2021 05:25:58 -0800
X-IronPort-AV: E=Sophos;i="5.88,200,1635231600"; 
   d="scan'208";a="608521467"
Received: from yangzhon-virtual.bj.intel.com (HELO yangzhon-Virtual) ([10.238.144.101])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 12 Dec 2021 05:25:54 -0800
Date:   Sun, 12 Dec 2021 21:10:59 +0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Message-ID: <20211212131059.GA21846@yangzhon-Virtual>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com>
 <97814bdf-2e58-2823-ca55-30b2447af3f1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97814bdf-2e58-2823-ca55-30b2447af3f1@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021 at 11:01:15PM +0100, Paolo Bonzini wrote:
> On 12/8/21 01:03, Yang Zhong wrote:
> >--- a/arch/x86/kvm/cpuid.c
> >+++ b/arch/x86/kvm/cpuid.c
> >@@ -219,6 +219,11 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  		kvm_apic_set_version(vcpu);
> >  	}
> >+	/* Enable saving guest XFD_ERR */
> >+	best = kvm_find_cpuid_entry(vcpu, 7, 0);
> >+	if (best && cpuid_entry_has(best, X86_FEATURE_AMX_TILE))
> >+		vcpu->arch.guest_fpu.xfd_err = 0;
> >+
> 
> This is incorrect.  Instead it should check whether leaf 0xD
> includes any dynamic features.
> 

  Thanks Paolo, So ditto for "[PATCH 04/19] kvm: x86: Check guest xstate permissions when KVM_SET_CPUID2".

  Yang

> Paolo
