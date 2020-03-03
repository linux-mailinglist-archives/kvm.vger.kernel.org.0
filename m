Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AB1177A9F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 16:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgCCPhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 10:37:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:36919 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728356AbgCCPhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 10:37:48 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 07:37:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="438757504"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 03 Mar 2020 07:37:47 -0800
Date:   Tue, 3 Mar 2020 07:37:47 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 66/66] KVM: x86: Move nSVM CPUID 0x8000000A handing
 into common x86 code
Message-ID: <20200303153747.GD1439@linux.intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-67-sean.j.christopherson@intel.com>
 <9d2b5256-5c00-54d2-8f73-c78d54b23552@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d2b5256-5c00-54d2-8f73-c78d54b23552@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 04:35:57PM +0100, Paolo Bonzini wrote:
> On 03/03/20 00:57, Sean Christopherson wrote:
> > +	case 0x8000000A:
> > +		if (!kvm_cpu_cap_has(X86_FEATURE_SVM)) {
> > +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> > +			break;
> > +		}
> > +		entry->eax = 1; /* SVM revision 1 */
> > +		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
> > +				   ASID emulation to nested SVM */
> > +		entry->ecx = 0; /* Reserved */
> > +		/* Note, 0x8000000A.EDX is managed via kvm_cpu_caps. */;
> 
> ... meaning this should do
> 
>                 cpuid_entry_override(entry, CPUID_8000_000A_EDX);
> 
> shouldn't it?

Argh, yes.
