Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 854A71054F2
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 15:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfKUO7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 09:59:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:64119 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfKUO7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 09:59:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Nov 2019 06:59:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,226,1571727600"; 
   d="scan'208";a="259394955"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Nov 2019 06:59:52 -0800
Date:   Thu, 21 Nov 2019 23:01:50 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 8/9] mmu: spp: Handle SPP protected pages when VM
 memory changes
Message-ID: <20191121150149.GE17169@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-9-weijiang.yang@intel.com>
 <ac9aa811-7a20-8481-7ddc-a2e39899cee1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac9aa811-7a20-8481-7ddc-a2e39899cee1@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:32:15AM +0100, Paolo Bonzini wrote:
> On 19/11/19 09:49, Yang Weijiang wrote:
> > +			/*
> > +			 * if it's EPT leaf entry and the physical page is
> > +			 * SPP protected, then re-enable SPP protection for
> > +			 * the page.
> > +			 */
> > +			if (kvm->arch.spp_active &&
> > +			    level == PT_PAGE_TABLE_LEVEL) {
> > +				struct kvm_subpage spp_info = {0};
> > +				int i;
> > +
> > +				spp_info.base_gfn = gfn;
> > +				spp_info.npages = 1;
> > +				i = kvm_spp_get_permission(kvm, &spp_info);
> > +				if (i == 1 &&
> > +				    spp_info.access_map[0] != FULL_SPP_ACCESS)
> > +					new_spte |= PT_SPP_MASK;
> > +			}
> 
> This can use gfn_to_subpage_wp_info directly (or is_spp_protected if you
> prefer).
>
Sure, will change it, thank you!
> Paolo
