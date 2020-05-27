Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491B61E49D6
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 18:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390975AbgE0QXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 12:23:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:48576 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389927AbgE0QXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 12:23:20 -0400
IronPort-SDR: ePlEA2ZG9ulCsXpPHLn+zVKtohLzVjPnR9d28gT4fhCDOijoN3m/hqsEwTxWDdtGK7EUuHcjgV
 Md3M4qYQCR9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 09:23:19 -0700
IronPort-SDR: kAwgXQUKDoO2amv9DlNMtYdinxSP/3MS/jtF8lV7tGc6W0BBq67huu/HbpuIWizlGwj6F160kE
 cfa1RVzsrwRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="291651774"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 27 May 2020 09:23:19 -0700
Date:   Wed, 27 May 2020 09:23:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
Message-ID: <20200527162318.GD24461@linux.intel.com>
References: <20200527085400.23759-1-sean.j.christopherson@intel.com>
 <875zch66fy.fsf@vitty.brq.redhat.com>
 <c444fbcc-8ac3-2431-4cdb-2a37b93b1fa2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c444fbcc-8ac3-2431-4cdb-2a37b93b1fa2@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 27, 2020 at 06:15:27PM +0200, Paolo Bonzini wrote:
> On 27/05/20 12:03, Vitaly Kuznetsov wrote:
> >>  
> >>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> >> +	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
> >>  
> >>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > 
> > Looking at kvm_update_cpuid() I was thinking if it would make sense to
> > duplicate the "/* Note, maxphyaddr must be updated before tdp_level. */"
> > comment here (it seems to be a vmx-only thing btw), drop it from
> > kvm_update_cpuid() or move cpuid_query_maxphyaddr() to get_tdp_level()
> > but didn't come to a conclusive answer. 
> 
> Yeah, it makes sense to at least add the comment here too.

Hmm, one option would be to make .get_tdp_level() pure function by passing
in vcpu->arch.maxphyaddr.  That should make the comment redundant.  I don't
love bleeding VMX's implementation into the prototype, but that ship has
kinda already sailed.

Side topic, cpuid_query_maxphyaddr() should be unexported, the RTIT usage can
and should use vcpu->arch.maxphyaddr.  I'll send a patch for that.
