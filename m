Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80258F9661
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 17:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfKLQ5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 11:57:18 -0500
Received: from mga05.intel.com ([192.55.52.43]:28377 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbfKLQ5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 11:57:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 08:57:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,297,1569308400"; 
   d="scan'208";a="229453522"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 12 Nov 2019 08:57:17 -0800
Date:   Tue, 12 Nov 2019 08:57:17 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being
 reserved
Message-ID: <20191112165717.GA18089@linux.intel.com>
References: <CAPcyv4jysxEu54XK2kUYnvTqUL7zf2fJvv7jWRR=P4Shy+3bOQ@mail.gmail.com>
 <CAPcyv4i3M18V9Gmx3x7Ad12VjXbq94NsaUG9o71j59mG9-6H9Q@mail.gmail.com>
 <0db7c328-1543-55db-bc02-c589deb3db22@redhat.com>
 <CAPcyv4gMu547patcROaqBqbwxut5au-WyE_M=XsKxyCLbLXHTg@mail.gmail.com>
 <20191107155846.GA7760@linux.intel.com>
 <20191109014323.GB8254@linux.intel.com>
 <CAPcyv4hAY_OfExNP+_067Syh9kZAapppNwKZemVROfxgbDLLYQ@mail.gmail.com>
 <20191111182750.GE11805@linux.intel.com>
 <CAPcyv4hErx-Hd5q+3+W6VUSWDpEuOfipMsWAL+nnQtZvYAf3bg@mail.gmail.com>
 <e6637be8-7890-579b-8131-6fdbbd791fa0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6637be8-7890-579b-8131-6fdbbd791fa0@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 12, 2019 at 11:19:44AM +0100, Paolo Bonzini wrote:
> On 12/11/19 01:51, Dan Williams wrote:
> > An elevated page reference count for file mapped pages causes the
> > filesystem (for a dax mode file) to wait for that reference count to
> > drop to 1 before allowing the truncate to proceed. For a page cache
> > backed file mapping (non-dax) the reference count is not considered in
> > the truncate path. It does prevent the page from getting freed in the
> > page cache case, but the association to the file is lost for truncate.
> 
> KVM support for file-backed guest memory is limited.  It is not
> completely broken, in fact cases such as hugetlbfs are in use routinely,
> but corner cases such as truncate aren't covered well indeed.

KVM's actual MMU should be ok since it coordinates with the mmu_notifier.

kvm_vcpu_map() is where KVM could run afoul of page cache truncation.
This is the other main use of hva_to_pfn*(), where KVM directly accesses
guest memory (which could be file-backed) without coordinating with the
mmu_notifier.  IIUC, an ill-timed page cache truncation could result in a
write from KVM effectively being dropped due to writeback racing with
KVM's write to the page.  If that's true, then I think KVM would need to
to move to the proposed pin_user_pages() to ensure its "DMA" isn't lost.

> > As long as any memory the guest expects to be persistent is backed by
> > mmu-notifier coordination we're all good, otherwise an elevated
> > reference count does not coordinate with truncate in a reliable way.

KVM itself is (mostly) blissfully unaware of any such expectations.  The
userspace VMM, e.g. Qemu, is ultimately responsible for ensuring the guest
sees a valid model, e.g. that persistent memory (as presented to the guest)
is actually persistent (from the guest's perspective).

The big caveat is the truncation issue above.
