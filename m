Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC41915CC85
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 21:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgBMUqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 15:46:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:54689 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbgBMUqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 15:46:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 12:46:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,437,1574150400"; 
   d="scan'208";a="313849043"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2020 12:46:28 -0800
Date:   Thu, 13 Feb 2020 12:46:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        kvm-ppc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/35] mm:gup/writeback: add callbacks for inaccessible
 pages
Message-ID: <20200213204628.GE18610@linux.intel.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-2-borntraeger@de.ibm.com>
 <28792269-e053-ac70-a344-45612ee5c729@de.ibm.com>
 <20200213195602.GD18610@linux.intel.com>
 <e2c41b25-6d6d-6685-3450-2e3e8d84efd1@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2c41b25-6d6d-6685-3450-2e3e8d84efd1@de.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 13, 2020 at 09:13:35PM +0100, Christian Borntraeger wrote:
> 
> On 13.02.20 20:56, Sean Christopherson wrote:
> > On Mon, Feb 10, 2020 at 06:27:04PM +0100, Christian Borntraeger wrote:
> > Am I missing a need to do this for the swap/reclaim case?  Or is there a
> > completely different use case I'm overlooking?
> 
> This is actually to protect the host against a malicious user space. For 
> example a bad QEMU could simply start direct I/O on such protected memory.
> We do not want userspace to be able to trigger I/O errors and thus we
> implemented the logic to "whenever somebody accesses that page (gup) or
> doing I/O, make sure that this page can be accessed. When the guest tries
> to access that page we will wait in the page fault handler for writeback to
> have finished and for the page_ref to be the expected value.

Ah.  I was assuming the pages would unmappable by userspace, enforced by
some other mechanism

> > 
> > Tangentially related, hooks here could be quite useful for sanity checking
> > the kernel/KVM and/or debugging kernel/KVM bugs.  Would it make sense to
> > pass a param to arch_make_page_accessible() to provide some information as
> > to why the page needs to be made accessible?
> 
> Some kind of enum that can be used optionally to optimize things?

Not just optimize, in the case above it'd probably preferable for us to
reject a userspace mapping outright, e.g. return -EFAULT if called from
gup()/follow().  Debug scenarios might also require differentiating between
writeback and "other".
