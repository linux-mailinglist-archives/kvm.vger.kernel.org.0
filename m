Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49E6F1CBC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 18:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732239AbfKFRqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 12:46:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:24378 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbfKFRqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 12:46:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 09:46:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="228407130"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Nov 2019 09:46:52 -0800
Date:   Wed, 6 Nov 2019 09:46:52 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being
 reserved
Message-ID: <20191106174652.GE16249@linux.intel.com>
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-2-sean.j.christopherson@intel.com>
 <8ba98630-9ca0-85c2-3c94-45d54a448fca@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ba98630-9ca0-85c2-3c94-45d54a448fca@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 06:14:40PM +0100, Paolo Bonzini wrote:
> On 06/11/19 18:07, Sean Christopherson wrote:
> >  void kvm_get_pfn(kvm_pfn_t pfn)
> >  {
> > -	if (!kvm_is_reserved_pfn(pfn))
> > +	if (!kvm_is_reserved_pfn(pfn) && !WARN_ON(kvm_is_zone_device_pfn(pfn)))
> >  		get_page(pfn_to_page(pfn));
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_get_pfn);
> 
> Can you call remap_pfn_range with a source address that is ZONE_DEVICE?
>  If so, you would get a WARN from the kvm_get_pfn call in
> hva_to_pfn_remapped.

I don't know, at a quick glance I'm guessing it's possible via /dev/mem?
But, get_page() isn't sufficient to properly grab a ZONE_DEVICE page, so
the WARN is a good thing and intentional.

So assuming the answer is "yes", perhaps hva_to_pfn_remapped() should
adds its own check on kvm_is_zone_device_pfn() and return -EINVAL or
something?  That'd likely end up kill the guest, but wouldn't break the
kernel.
