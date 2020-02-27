Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F19172C97
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 00:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgB0X5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 18:57:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:12972 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728993AbgB0X5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 18:57:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 15:57:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="232368034"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 27 Feb 2020 15:57:39 -0800
Date:   Thu, 27 Feb 2020 15:57:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/2] kvm: vmx: Use basic exit reason to check if it's the
 specific VM EXIT
Message-ID: <20200227235739.GM17014@linux.intel.com>
References: <20200224020751.1469-2-xiaoyao.li@intel.com>
 <87lfosp9xs.fsf@vitty.brq.redhat.com>
 <d9744594-4a66-d867-f785-64ce4d42b848@intel.com>
 <87imjwp24x.fsf@vitty.brq.redhat.com>
 <20200224161728.GC29865@linux.intel.com>
 <50134028-ef7a-46c6-7602-095c47406ed7@intel.com>
 <20200225061317.GV29865@linux.intel.com>
 <bb2d36b4-a077-691e-d59e-f65bf534d1ff@intel.com>
 <20200226235924.GW9940@linux.intel.com>
 <022bf970-1b86-d952-5563-0d18c9eea6e2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <022bf970-1b86-d952-5563-0d18c9eea6e2@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 04:35:20PM +0800, Xiaoyao Li wrote:
> On 2/27/2020 7:59 AM, Sean Christopherson wrote:
> >Ah, good point.  But, that's just another bug in my psuedo patch :-)
> >It's literally one call site that needs to be updated.  E.g.
> >
> >	if (is_guest_mode(vcpu) && nested_vmx_exit_reflected(vcpu, exit_reason))
> >		return nested_vmx_reflect_vmexit(vcpu, full_exit_reason);
> >
> 
> shouldn't we also pass full_exit_reason to nested_vmx_exit_reflected()?

Yep, see the patch I sent.  Alternatively, and perhaps a better approach
once we have the union, would be to not pass exit_reason at all and instead
have nested_vmx_exit_reflected() grab it directly from vmx->...

> 
> >Everywhere else KVM calls nested_vmx_reflect_vmexit() is (currently) done
> 
> I guess you wanted to say nested_vmx_vmexit() not
> nested_vmx_reflect_vmexit() here.

Ya.
 
> >with a hardcoded value (except handle_vmfunc(), but I actually want to
> >change that one).
> >
> 
