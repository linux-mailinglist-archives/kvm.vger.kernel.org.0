Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF0F1A39DB
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 20:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgDISea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 14:34:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:23441 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgDISe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 14:34:29 -0400
IronPort-SDR: sOVKgnjaZM2QywELzJE6Xp5QY/Fl+TLrl8+VJh+oKgM4j+CF8DpByLuA17bQg6zBrfyCj2les3
 gXfIA3+580lw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 11:34:29 -0700
IronPort-SDR: TXiQILKrvdolDKooLN9c/56KVHIEqAB+3FOJVk0Pm8gC6Cuodb9ZMB8c7oO0p3xyw7/Wf3Del6
 S0hoHcbVYIdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,363,1580803200"; 
   d="scan'208";a="453259274"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 09 Apr 2020 11:34:29 -0700
Date:   Thu, 9 Apr 2020 11:34:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Kang, Luwei" <luwei.kang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [PATCH] KVM: VMX: Disable Intel PT before VM-entry
Message-ID: <20200409183429.GA8919@linux.intel.com>
References: <1584503298-18731-1-git-send-email-luwei.kang@intel.com>
 <20200318154826.GC24357@linux.intel.com>
 <82D7661F83C1A047AF7DC287873BF1E1738A9724@SHSMSX104.ccr.corp.intel.com>
 <20200330172152.GE24988@linux.intel.com>
 <82D7661F83C1A047AF7DC287873BF1E1738B1A1C@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E1738B1A1C@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 30, 2020 at 08:29:26PM -0700, Kang, Luwei wrote:
> > > > On Wed, Mar 18, 2020 at 11:48:18AM +0800, Luwei Kang wrote:
> > Ah, right.  What about enhancing intel_pt_handle_vmx() and 'struct pt' to
> > replace vmx_on with a field that incorporates the KVM mode?
> 
> Some history is the host perf didn't fully agree with introducing HOST_GUEST
> mode for PT in KVM. Because the KVM will disable the host trace before
> VM-entry in HOST_GUEST mode and KVM guest will win in this case. e.g. Intel
> PT has been enabled in KVM guest and the host wants to start system-wide
> trace(collect all the trace on this system) at this time, the trace produced
> by the Guest OS will be saved in guest PT buffer and host buffer can't get
> this. So I prefer don't introduce the KVM PT mode to host perf framework. The
> similar problem happens on PEBS virtualization via DS as well.

A maintainer's distaste for a feature isn't a good reason to put a hack
into KVM.  Perf burying its head in the sand won't change the fact that
"pt->vmx_on" is poorly named and misleading.  Disagreement over features
is fine, but things will go sideways quick if perf and KVM are outright
hostile towards each other.
