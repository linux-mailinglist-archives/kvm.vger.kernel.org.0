Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADC91647D1
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 16:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgBSPIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 10:08:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:29339 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgBSPIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 10:08:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 07:08:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,459,1574150400"; 
   d="scan'208";a="434501370"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 19 Feb 2020 07:08:21 -0800
Date:   Wed, 19 Feb 2020 07:08:21 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: Re: [PATCH] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200219150820.GA15888@linux.intel.com>
References: <20200218110013.15640-1-jianjay.zhou@huawei.com>
 <20200218212303.GH28156@linux.intel.com>
 <B2D15215269B544CADD246097EACE7474BAFEC8D@DGGEMM528-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2D15215269B544CADD246097EACE7474BAFEC8D@DGGEMM528-MBX.china.huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 06:58:33AM +0000, Zhoujian (jay) wrote:
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -360,6 +360,11 @@ static inline unsigned long
> > *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
> > >  	return memslot->dirty_bitmap + len / sizeof(*memslot->dirty_bitmap);
> > > }
> > >
> > > +static inline void kvm_set_first_dirty_bitmap(struct kvm_memory_slot
> > > +*memslot) {
> > > +	bitmap_set(memslot->dirty_bitmap, 0, memslot->npages); }
> > 
> > I'd prefer this be open coded with a comment, e.g. "first" is misleading because
> > it's really "initial dirty bitmap for this memslot after enabling dirty logging".
> 
> kvm_create_dirty_bitmap allocates twice size as large as the actual dirty bitmap
> size, and there is kvm_second_dirty_bitmap to get the second part of the map,
> this is the reason why I use first_dirty_bitmap here, which means the first part
> (not first time) of the dirty bitmap.

Ha, I didn't consider that usage of "first", obviously :-)

> I'll try to be more clear if this is misleading...
