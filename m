Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556FC111B92
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 23:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfLCWUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 17:20:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:30662 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbfLCWUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 17:20:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 14:20:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,275,1571727600"; 
   d="scan'208";a="242586533"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 03 Dec 2019 14:20:36 -0800
Date:   Tue, 3 Dec 2019 14:20:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: X86: Use APIC_DEST_* macros properly in
 kvm_lapic_irq.dest_mode
Message-ID: <20191203222036.GL19877@linux.intel.com>
References: <20191203165903.22917-1-peterx@redhat.com>
 <20191203165903.22917-4-peterx@redhat.com>
 <20191203220752.GJ19877@linux.intel.com>
 <20191203221519.GI17275@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203221519.GI17275@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 05:15:19PM -0500, Peter Xu wrote:
> On Tue, Dec 03, 2019 at 02:07:52PM -0800, Sean Christopherson wrote:
> > On Tue, Dec 03, 2019 at 11:59:00AM -0500, Peter Xu wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index b79cd6aa4075..f815c97b1b57 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1022,6 +1022,11 @@ struct kvm_lapic_irq {
> > >  	bool msi_redir_hint;
> > >  };
> > >  
> > > +static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode)
> > > +{
> > > +	return dest_mode ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
> > 
> > IMO this belongs in ioapic.c as it's specifically provided for converting
> > an I/O APIC redirection entry into a local APIC destination mode.  Without
> > the I/O APIC context, %true==APIC_DEST_LOGICAL looks like a completely
> > arbitrary decision.  And if it's in ioapic.c, it can take the union
> > of a bool, which avoids the casting and shortens the callers.  E.g.:
> > 
> > static u64 ioapic_to_lapic_dest_mode(union kvm_ioapic_redirect_entry *e)
> > {
> > 	return e->fields.dest_mode ?  APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
> > }
> > 
> > The other option would be to use the same approach as delivery_mode and
> > open code the shift.
> 
> It's also used for MSI address encodings, please see below [1].

Boooh.  How about naming the param "logical_dest_mode" or something else
with "logical" in the name so that the correctness of the function itself
is apparent?
