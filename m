Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38B8278E56
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 18:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgIYQYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 12:24:39 -0400
Received: from mga05.intel.com ([192.55.52.43]:20870 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728527AbgIYQYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 12:24:39 -0400
IronPort-SDR: QiZRKP0dxNKCCMAljWhsnB36/4Mg2zBq6BLVPDMLkxN9dWV15E1T//TCLqTzn0WKv3btiL28n0
 uKifjLxucQ6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="246359717"
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="246359717"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 09:24:28 -0700
IronPort-SDR: rx14zkNaZDSiLEmlJkNzBdA7ttZxuY3+qnQL327w0JyasTHGHBSDBUI967iD66wmj5gi9w7VxM
 BMYNDCw+z0QA==
X-IronPort-AV: E=Sophos;i="5.77,302,1596524400"; 
   d="scan'208";a="512942553"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 09:24:27 -0700
Date:   Fri, 25 Sep 2020 09:24:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Explicitly check for hv_remote_flush_tlb when
 loading pgd()
Message-ID: <20200925162426.GB31009@linux.intel.com>
References: <20200924180429.10016-1-sean.j.christopherson@intel.com>
 <87h7rmch3v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7rmch3v.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 11:59:00AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > +#if IS_ENABLED(CONFIG_HYPERV)
> >  	enum ept_pointers_status ept_pointers_match;
> >  	spinlock_t ept_pointer_lock;
> > +#endif
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> In case ept_pointers_match/ept_pointer_lock are useless for TDX we may
> want to find better names for them to make it clear this is a Hyper-V
> thingy (e.g. something like hv_tlb_ept_match/hv_tlb_ept_lock).

Good call.  I'll send a v2, looking at hv_remote_flush_tlb_with_range(), I
think there are additional cleanups/optimizations that can be done, e.g. do the
extra flushes only on vCPUs with a mistmatching EPTP instead of flushing all
vCPUs' EPTPs if _any_ vCPU has a mismatched EPTP.

> 
> >  };
> >  
> >  bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
> 
> -- 
> Vitaly
> 
