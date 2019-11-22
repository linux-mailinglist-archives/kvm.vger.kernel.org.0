Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B236110758E
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 17:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbfKVQPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 11:15:30 -0500
Received: from mga05.intel.com ([192.55.52.43]:24195 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfKVQPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 11:15:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 08:15:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,230,1571727600"; 
   d="scan'208";a="232706418"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 22 Nov 2019 08:15:28 -0800
Date:   Sat, 23 Nov 2019 00:17:23 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [PATCH v7 1/9] Documentation: Introduce EPT based Subpage
 Protection and related ioctls
Message-ID: <20191122161723.GA10458@local-michael-cet-test>
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-2-weijiang.yang@intel.com>
 <dbf1f124-7864-b1e8-fae3-49448372d502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbf1f124-7864-b1e8-fae3-49448372d502@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 21, 2019 at 11:02:56AM +0100, Paolo Bonzini wrote:
> On 19/11/19 09:49, Yang Weijiang wrote:
> > +
> > +#define SUBPAGE_MAX_BITMAP   64
> 
> Please rename this to KVM_SUBPAGE_MAX_PAGES
>
OK.
> > +struct kvm_subpage_info {
> > +	__u64 gfn;    /* the first page gfn of the contiguous pages */
> > +	__u64 npages; /* number of 4K pages */
> 
> This can be
> 
> 	u32 npages;
> 	u32 flags;
> 
> Check that the flags are 0, and fail the ioctl if they aren't.  This
> will make it easy to extend the API in the future.
> 
Cool, thanks for the suggestion!

> > +	__u32 access_map[SUBPAGE_MAX_BITMAP]; /* sub-page write-access bitmap array */
> > +};
> 
> Please make this access_map[0], since the number of entries actually
> depends on npages.
> 
> Likewise, kvm_arch_vm_ioctl should read the header first, then allocate
> memory for the access_map and read into it.  It's probably simpler if
> you make kvm_vm_ioctl_get_subpages/kvm_vm_ioctl_set_subpages take
> parameters like
> 
> int kvm_vm_ioctl_get_subpages(struct kvm *kvm, u64 gfn, u32 npages,
> 			      u32 *access_map);
> int kvm_vm_ioctl_set_subpages(struct kvm *kvm, u64 gfn, u32 npages,
> 			      u32 *access_map);
>
Sure, will make the change. thank you!

> Thanks,
> 
> Paolo
