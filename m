Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B311560FB
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 23:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgBGWD0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 17:03:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:23731 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgBGWD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 17:03:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 14:03:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,415,1574150400"; 
   d="scan'208";a="280100123"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2020 14:03:25 -0800
Date:   Fri, 7 Feb 2020 14:03:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 17/19] KVM: Terminate memslot walks via used_slots
Message-ID: <20200207220325.GO2401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-18-sean.j.christopherson@intel.com>
 <20200206210944.GD700495@xz-x1>
 <20200207183325.GI2401@linux.intel.com>
 <20200207203909.GE720553@xz-x1>
 <20200207211016.GN2401@linux.intel.com>
 <20200207214623.GF720553@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207214623.GF720553@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 04:46:23PM -0500, Peter Xu wrote:
> On Fri, Feb 07, 2020 at 01:10:16PM -0800, Sean Christopherson wrote:
> > On Fri, Feb 07, 2020 at 03:39:09PM -0500, Peter Xu wrote:
> > > On Fri, Feb 07, 2020 at 10:33:25AM -0800, Sean Christopherson wrote:
> > > > On Thu, Feb 06, 2020 at 04:09:44PM -0500, Peter Xu wrote:
> > > > > On Tue, Jan 21, 2020 at 02:31:55PM -0800, Sean Christopherson wrote:
> > > > > > @@ -9652,13 +9652,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > > > >  		if (IS_ERR((void *)hva))
> > > > > >  			return PTR_ERR((void *)hva);
> > > > > >  	} else {
> > > > > > -		if (!slot->npages)
> > > > > > +		if (!slot || !slot->npages)
> > > > > >  			return 0;
> > > > > >  
> > > > > > -		hva = 0;
> > > > > > +		hva = slot->userspace_addr;
> > > > > 
> > > > > Is this intended?
> > > > 
> > > > Yes.  It's possible to allow VA=0 for userspace mappings.  It's extremely
> > > > uncommon, but possible.  Therefore "hva == 0" shouldn't be used to
> > > > indicate an invalid slot.
> > > 
> > > Note that this is the deletion path in __x86_set_memory_region() not
> > > allocation.  IIUC userspace_addr won't even be used in follow up code
> > > path so it shouldn't really matter.  Or am I misunderstood somewhere?
> > 
> > No, but that's precisely why I don't want to zero out @hva, as doing so
> > implies that '0' indicates an invalid hva, which is wrong.
> > 
> > What if I change this to 
> > 
> > 			hva = 0xdeadull << 48;
> > 
> > and add a blurb in the changelog about stuff hva with a non-canonical value
> > to indicate it's being destroyed.
> 
> IMO it's fairly common to have the case where "when A is XXX then
> parameters B is invalid" happens in C.

I'm not arguing that's not the case.  My point is that there's nothing
special about '0', so why use it?  E.g. "hva = 1" would also be ok from a
functional perspective, but more obviously "wrong".
