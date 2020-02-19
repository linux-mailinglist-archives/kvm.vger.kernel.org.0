Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0926164A1C
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 17:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgBSQWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 11:22:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:37343 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbgBSQWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 11:22:40 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 08:22:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,461,1574150400"; 
   d="scan'208";a="254146684"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 19 Feb 2020 08:22:31 -0800
Date:   Wed, 19 Feb 2020 08:22:31 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Longpeng (Mike)" <longpeng2@huawei.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, weidong.huang@huawei.com,
        weifuqiang@huawei.com, kvm@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
Message-ID: <20200219162231.GE15888@linux.intel.com>
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
 <20200218203717.GE28156@linux.intel.com>
 <a041fdb4-bfd0-ac4b-2809-6fddfc4f8d83@huawei.com>
 <20200219015836.GM28156@linux.intel.com>
 <6ccbde03-953c-c006-a07e-8146b84389d9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ccbde03-953c-c006-a07e-8146b84389d9@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 08:21:26PM +0800, Longpeng (Mike) wrote:
> 在 2020/2/19 9:58, Sean Christopherson 写道:
> > FWIW, I'd be in favor of going the READ/WRITE_ONCE() route for x86, e.g.
> > convert everything as a follow-up patch (or patches).  I'm fairly confident
> > that KVM's usage of lookup_address_in_mm() is safe, but I wouldn't exactly
> > bet my life on it.  I'd much rather the failing scenario be that KVM uses
> > a sub-optimal page size as opposed to exploding on a bad pointer.
> > 
> Um...our testcase starts 50 VMs with 2U4G(use 1G hugepage) and then do
> live-upgrade(private feature that just modify the qemu and libvirt) and
> live-migrate in turns for each one. However our live upgraded new QEMU won't do
> touch_all_pages.
> Suppose we start a VM without touch_all_pages in QEMU, the VM's guest memory is
> not mapped in the CR3 pagetable at the moment. When the 2 vcpus running, they
> could access some pages belong to the same 1G-hugepage, both of them will vmexit
> due to ept_violation and then call gup-->follow_hugetlb_page-->hugetlb_fault, so
> the race may encounter, right?

Yep.  The code I'm referring to is similar but different code that just
happened to go into KVM for kernel 5.6.  It has no effect on the gup() flow
that leads to this bug.  I mentioned it above as an example of code outside
of hugetlb_fault() that would also benefit from moving to READ/WRITE_ONCE().
