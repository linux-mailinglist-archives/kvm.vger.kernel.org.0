Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EACB18A17F
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 18:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCRR0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 13:26:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:44788 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbgCRR0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 13:26:15 -0400
IronPort-SDR: HJT8YZ4w7NyCydPMYIPzxRdnCo6HNGdkxuq2EfFMfVxbzXLfKwzc2XV3gUW1MLNrDOut6/ZpI1
 GM+zxDRA/Dfg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 10:26:15 -0700
IronPort-SDR: 3xCuXNbW8CwUc79qaXmP9qo5p7mhscUwJVFlF3lnf3SyrI8MIf+vrZTD5cMCi5BweVbCHemrZc
 6RmHLt5RnJeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="263458442"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 18 Mar 2020 10:26:14 -0700
Date:   Wed, 18 Mar 2020 10:26:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 31/32] KVM: nVMX: Don't flush TLB on nested VM
 transition with EPT enabled
Message-ID: <20200318172614.GK24357@linux.intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
 <20200317045238.30434-32-sean.j.christopherson@intel.com>
 <97f91b27-65ac-9187-6b60-184e1562d228@redhat.com>
 <20200317182251.GD12959@linux.intel.com>
 <218d4dbd-20f1-5bf8-ca44-c53dd9345dab@redhat.com>
 <20200318170241.GJ24357@linux.intel.com>
 <3c3a4d9b-b213-dfc0-2857-a975e9c20770@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c3a4d9b-b213-dfc0-2857-a975e9c20770@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 18, 2020 at 06:11:28PM +0100, Paolo Bonzini wrote:
> On 18/03/20 18:02, Sean Christopherson wrote:
> > So something like this?
> > 
> > 	if (!nested_ept)
> > 		kvm_mmu_new_cr3(vcpu, cr3, enable_ept ||
> > 					   nested_cpu_has_vpid(vmcs12));
> 
> ... which is exactly nested_has_guest_tlb_tag(vcpu).  Well, not exactly
> but it's a bug in your code above. :)

I don't think it's a bug, it's intentionally different.  When enable_ept=0,
nested_has_guest_tlb_tag() returns true if and only if L1 has enabled VPID
for L2 *and* L2 has been assigned a unique VPID by L0.

For sync purposes, whether or not L2 has been assigned a unique VPID is
irrelevant.  L0 needs to invalidate TLB entries to prevent resuing L1's
entries (assuming L1 has been assigned a VPID), but L0 doesn't need to sync
SPTEs because L2 doesn't expect them to be refreshed.

> It completely makes sense to use that as the third argument, and while a
> comment is still needed it will be much smaller.

Ya, agreed.
