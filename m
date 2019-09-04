Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC478A8DCA
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbfIDRlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 13:41:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:35286 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729863AbfIDRlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 13:41:23 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 10:41:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="185183906"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 04 Sep 2019 10:41:22 -0700
Date:   Wed, 4 Sep 2019 10:41:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] doc: kvm: Fix return description of KVM_SET_MSRS
Message-ID: <20190904174122.GK24079@linux.intel.com>
References: <20190904060118.43851-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904060118.43851-1-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 04, 2019 at 02:01:18PM +0800, Xiaoyao Li wrote:
> Userspace can use ioctl KVM_SET_MSRS to update a set of MSRs of guest.
> This ioctl sets specified MSRs one by one. Once it fails to set an MSR
> due to setting reserved bits, the MSR is not supported/emulated by kvm,
> or violating other restrictions, it stops further processing and returns
> the number of MSRs have been set successfully.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> v2:
>   elaborate the changelog and description of ioctl KVM_SET_MSRS based on
>   Sean's comments.
> 
> ---
>  Documentation/virt/kvm/api.txt | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 2d067767b617..4638e893dec0 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -586,7 +586,7 @@ Capability: basic
>  Architectures: x86
>  Type: vcpu ioctl
>  Parameters: struct kvm_msrs (in)
> -Returns: 0 on success, -1 on error
> +Returns: number of msrs successfully set (see below), -1 on error
>  
>  Writes model-specific registers to the vcpu.  See KVM_GET_MSRS for the
>  data structures.
> @@ -595,6 +595,11 @@ Application code should set the 'nmsrs' member (which indicates the
>  size of the entries array), and the 'index' and 'data' members of each
>  array entry.
>  
> +It tries to set the MSRs in array entries[] one by one. Once failing to

Probably better to say 'If' as opposed to 'Once', don't want to imply that
userspace is incompetent :)

> +set an MSR (due to setting reserved bits, the MSR is not supported/emulated
> +by kvm, or violating other restrctions), 

Make it clear the list is not exhaustive, e.g.:

It tries to set the MSRs in array entries[] one by one.  If setting an MSR
fails, e.g. due to setting reserved bits, the MSR isn't supported/emulated by
KVM, etc..., it stops processing the MSR list and returns the number of MSRs
that have been set successfully.

> it stops setting following MSRs
> +and returns the number of MSRs have been set successfully.
> +
>  
>  4.20 KVM_SET_CPUID
>  
> -- 
> 2.19.1
> 
