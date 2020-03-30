Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7293319837E
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 20:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgC3Si0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 14:38:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:10718 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgC3SiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 14:38:25 -0400
IronPort-SDR: pMNpGvTyoIgrUlFjUow2/DH0k3h4e6Ra4Dti2YBifbijqxb3TET3PHeKBXUsBWoZH1ky4f5Ljc
 pNI2U8zo9zKg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 11:38:24 -0700
IronPort-SDR: vmDLHrwOyJPANg9XoxSgdQHcZKErDEqyL+mWIwW6cCoiJMojrsa7UWS1RPZR+x6W86/e3ufcQI
 frnTna6TPwiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="248792299"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2020 11:38:24 -0700
Date:   Mon, 30 Mar 2020 11:38:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 03/37] KVM: nVMX: Invalidate all EPTP contexts when
 emulating INVEPT for L1
Message-ID: <20200330183824.GI24988@linux.intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
 <20200320212833.3507-4-sean.j.christopherson@intel.com>
 <CALMp9eR5Uu7nRDOS2nQHGzb+Gi6vjDEk1AmuiqkkGWFjKNG+sA@mail.gmail.com>
 <20200323162807.GN28711@linux.intel.com>
 <CALMp9eR42eM7g81EgHieyNky+kP2mycO7UyMN+y2ibLoqrD2Yg@mail.gmail.com>
 <20200323164447.GQ28711@linux.intel.com>
 <8d99cdf0-606a-f4df-35e7-3b856bb3ea0e@redhat.com>
 <CALMp9eQ-rzdZHdM0DFzVyaynEhf0+e9rYGqi57fhN54VTFcNnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQ-rzdZHdM0DFzVyaynEhf0+e9rYGqi57fhN54VTFcNnA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 05:12:04PM -0700, Jim Mattson wrote:
> On Mon, Mar 23, 2020 at 4:51 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 23/03/20 17:44, Sean Christopherson wrote:
> > > So I think
> > >
> > >   Fixes: 14c07ad89f4d ("x86/kvm/mmu: introduce guest_mmu")
> > >
> > > would be appropriate?
> > >
> >
> > Yes.
> 
> I think it was actually commit efebf0aaec3d ("KVM: nVMX: Do not flush
> TLB on L1<->L2 transitions if L1 uses VPID and EPT").

Hmm, commit efebf0aaec3d it only changed flushing behavior, it didn't
affect KVM's behavior with respect to refreshing unsync'd SPTE, i.e.
reloading guest_mmu.

It's somewhat of a moot point, because _technically_ there is no bug since,
at the time of this fix, KVM always flushes and reloads on nested VM-Enter.
