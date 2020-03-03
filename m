Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEB8177BE5
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgCCQ2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:28:10 -0500
Received: from mga07.intel.com ([134.134.136.100]:18741 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730385AbgCCQ2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:28:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 08:28:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="287035714"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Mar 2020 08:28:08 -0800
Date:   Tue, 3 Mar 2020 08:28:08 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 3/6] KVM: x86: Add dedicated emulator helper for grabbing
 CPUID.maxphyaddr
Message-ID: <20200303162808.GJ1439@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-4-sean.j.christopherson@intel.com>
 <de2ed4e9-409a-6cb1-e295-ea946be11e82@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de2ed4e9-409a-6cb1-e295-ea946be11e82@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 09:48:03AM +0100, Paolo Bonzini wrote:
> On 02/03/20 20:57, Sean Christopherson wrote:
> > Add a helper to retrieve cpuid_maxphyaddr() instead of manually
> > calculating the value in the emulator via raw CPUID output.  In addition
> > to consolidating logic, this also paves the way toward simplifying
> > kvm_cpuid(), whose somewhat confusing return value exists purely to
> > support the emulator's maxphyaddr calculation.
> > 
> > No functional change intended.
> 
> I don't think this is a particularly useful change.  Yes, it's not
> intuitive but is it more than a matter of documentation (and possibly
> moving the check_cr_write snippet into a separate function)?

I really don't like duplicating the maxphyaddr logic.  I'm paranoid
something will come along and change the "effective" maxphyaddr and we'll
forget all about the emulator, e.g. SEV, TME and paravirt XO all dance
around maxphyaddr.
