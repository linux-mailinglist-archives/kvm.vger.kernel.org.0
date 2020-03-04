Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93530179A62
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 21:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388275AbgCDUrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 15:47:41 -0500
Received: from mga12.intel.com ([192.55.52.136]:6749 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgCDUrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 15:47:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 12:47:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="439262784"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 04 Mar 2020 12:47:40 -0800
Date:   Wed, 4 Mar 2020 12:47:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jan Kiszka <jan.kiszka@siemens.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 3/6] KVM: x86: Add dedicated emulator helper for grabbing
 CPUID.maxphyaddr
Message-ID: <20200304204740.GG21662@linux.intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-4-sean.j.christopherson@intel.com>
 <de2ed4e9-409a-6cb1-e295-ea946be11e82@redhat.com>
 <617748ab-0edd-2ccc-e86b-b86b0adf9d3b@siemens.com>
 <4ddde497-9c71-d64c-df20-3b4439664336@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ddde497-9c71-d64c-df20-3b4439664336@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 11:14:22AM +0100, Paolo Bonzini wrote:
> On 03/03/20 10:48, Jan Kiszka wrote:
> >>
> >> I don't think this is a particularly useful change.  Yes, it's not
> >> intuitive but is it more than a matter of documentation (and possibly
> >> moving the check_cr_write snippet into a separate function)?
> > 
> > Besides the non obvious return value of the current function, this
> > approach also avoids leaving cpuid traces for querying maxphyaddr, which
> > is also not very intuitive IMHO.
> 
> There are already other cases where we leave CPUID traces.  We can just
> stop tracing if check_limit (which should be renamed to from_guest) is
> true; there are other internal cases which call ctxt->ops->get_cpuid,
> such as vendor_intel, and those should also use check_limit==true and
> check the return value of ctxt->ops->get_cpuid.

No, the vendor checks that use get_cpuid() shouldn't do check_limit=true,
they're looking for an exact match on the vendor.

Not that it matters.  @check_limit only comes into play on a vendor check
if CPUID.0 doesn't exist, and @check_limit only effects the output if
CPUID.0 _does_ exist.  I.e. the output for CPUID.0 is unaffected by
@check_limit.
