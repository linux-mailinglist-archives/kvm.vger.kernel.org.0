Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AD818FA89
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgCWQzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:55:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:57826 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgCWQzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:55:52 -0400
IronPort-SDR: BSht4oHei0LHYXbnCmFQk2tzsrm4Nl5X1kyj2VAgwVsFlnZRvLtoUOv64WHOlLgq+gGQYeUAWc
 whQagWfh+r3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 09:55:52 -0700
IronPort-SDR: VxdhzTYxCVd0LA1ifLMuASQRa9I7ogT8V9fqrhCfr75NHfTTSYk/LOQrJenn3x47WNfthB6qQq
 Jh6q92mHVsrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="392972376"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 23 Mar 2020 09:55:51 -0700
Date:   Mon, 23 Mar 2020 09:55:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200323165551.GS28711@linux.intel.com>
References: <20200318163720.93929-1-peterx@redhat.com>
 <20200318163720.93929-4-peterx@redhat.com>
 <20200321192211.GC13851@linux.intel.com>
 <20200323145824.GI127076@xz-x1>
 <20200323154216.GG28711@linux.intel.com>
 <20200323162617.GK127076@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323162617.GK127076@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 12:26:17PM -0400, Peter Xu wrote:
> On Mon, Mar 23, 2020 at 08:42:16AM -0700, Sean Christopherson wrote:
> > > > Regarding the HVA, it's a bit confusing saying that it's guaranteed to be
> > > > valid, and then contradicting that in the second clause.  Maybe something
> > > > like this to explain the GPA->HVA is guaranteed to be valid, but the
> > > > HVA->HPA is not.
> > > >  
> > > > /*
> > > >  * before use.  Note, KVM internal memory slots are guaranteed to remain valid
> > > >  * and unchanged until the VM is destroyed, i.e. the GPA->HVA translation will
> > > >  * not change.  However, the HVA is a user address, i.e. its accessibility is
> > > >  * not guaranteed, and must be accessed via __copy_{to,from}_user().
> > > >  */
> > > 
> > > Sure I can switch to this, though note that I still think the GPA->HVA
> > > is not guaranteed logically because the userspace can unmap any HVA it
> > > wants..
> > 
> > You're conflating the GPA->HVA translation with the validity of the HVA,
> > i.e. the HVA->HPA and/or HVA->VMA translation/association.  GPA->HVA is
> > guaranteed because userspace doesn't have access to the memslot which
> > defines that transation.
> 
> Yes I completely agree if you mean the pure mapping of GPA->HVA.
> 
> I think it's a matter of how to define the "valid" when you say
> "guaranteed to remain valid", because I don't think the mapping is
> still valid from the most strict sense if e.g. the backing HVA does
> not exist any more for that GPA->HVA mapping, then the memslot won't
> be anything useful.

Yes.  That's why my proposed comment is worded to state that the _memslot_
will remain valid.  It deliberately avoids mentioning "valid HVA".
