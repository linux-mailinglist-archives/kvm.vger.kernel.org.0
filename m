Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9FF1AE026
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 16:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgDQOst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 10:48:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:15995 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgDQOst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 10:48:49 -0400
IronPort-SDR: ZqBG2JENyS2WYCWTLzPT0FyrmcpdH7aUGcdbOyl9ZkwOOPsVBSc7rltgu74U5qzLePrJF7s//+
 fxUXmjnHCvmA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 07:48:48 -0700
IronPort-SDR: 8LU7QCQKjz9b/lRjmUHp/RKAb3IHYJGz4p9X/Ngm8s+c00GIDVTK6WInm9AGW0TSg8Z0z/qWad
 QFeF0AJnC//Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254229236"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 07:48:48 -0700
Date:   Fri, 17 Apr 2020 07:48:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     sam hao <ssesamhao@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: Slab-of-out-bounds in search_memslots() in kvm_host.h
Message-ID: <20200417144848.GA13233@linux.intel.com>
References: <CANhq1J6AJvkXUVZtbYgZubepU8xL88Q56UrcDprmG_eDapmXtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANhq1J6AJvkXUVZtbYgZubepU8xL88Q56UrcDprmG_eDapmXtA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 09:24:10PM +0800, sam hao wrote:
> Hi,
> 
> I've found possible out of bounds access in search_memslots() in kvm_host.h.

...

> if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
>             gfn < memslots[start].base_gfn + memslots[start].npages) {
>                 atomic_set(&slots->lru_slot, start);
>                 return &memslots[start];
> }

Fixed (with this exact check) by commit b6467ab142b7 ("KVM: Check validity
of resolved slot when searching memslots").  Syzbot found this one very
quickly :-)  Thanks!
