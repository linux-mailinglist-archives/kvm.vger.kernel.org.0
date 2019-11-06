Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C0FF22C1
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 00:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732846AbfKFXjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 18:39:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:32481 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727238AbfKFXjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 18:39:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 15:39:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400"; 
   d="scan'208";a="200863753"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 06 Nov 2019 15:39:13 -0800
Date:   Wed, 6 Nov 2019 15:39:13 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <20191106233913.GC21617@linux.intel.com>
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
 <20191106170727.14457-2-sean.j.christopherson@intel.com>
 <CAPcyv4gJk2cXLdT2dZwCH2AssMVNxUfdx-bYYwJwy1LwFxOs0w@mail.gmail.com>
 <1cf71906-ba99-e637-650f-fc08ac4f3d5f@redhat.com>
 <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hMOxPDKAZtTvWKEMPBwE_kPrKPB_JxE2YfV5EKkKj_dQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 03:20:11PM -0800, Dan Williams wrote:
> After some more thought I'd feel more comfortable just collapsing the
> ZONE_DEVICE case into the VM_IO/VM_PFNMAP case. I.e. with something
> like this (untested) that just drops the reference immediately and let
> kvm_is_reserved_pfn() do the right thing going forward.

This will break the page fault flow, as it will allow the page to be
whacked before KVM can ensure it will get proper notification from the
mmu_notifier.  E.g. KVM would install the PFN in its secondary MMU after
getting the invalidate notification for the PFN.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d6f0696d98ef..d21689e2b4eb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1464,6 +1464,14 @@ static bool hva_to_pfn_fast(unsigned long addr,
> bool write_fault,
>         npages = __get_user_pages_fast(addr, 1, 1, page);
>         if (npages == 1) {
>                 *pfn = page_to_pfn(page[0]);
> +               /*
> +                * ZONE_DEVICE pages are effectively VM_IO/VM_PFNMAP as
> +                * far as KVM is concerned kvm_is_reserved_pfn() will
> +                * prevent further unnecessary page management on this
> +                * page.
> +                */
> +               if (is_zone_device_page(page[0]))
> +                       put_page(page[0]);
> 
>                 if (writable)
>                         *writable = true;
> @@ -1509,6 +1517,11 @@ static int hva_to_pfn_slow(unsigned long addr,
> bool *async, bool write_fault,
>                 }
>         }
>         *pfn = page_to_pfn(page);
> +
> +       /* See comment in hva_to_pfn_fast. */
> +       if (is_zone_device_page(page[0]))
> +               put_page(page[0]);
> +
>         return npages;
>  }
