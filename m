Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A844E126EEB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 21:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfLSUcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 15:32:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:34389 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfLSUcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 15:32:15 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 12:32:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,333,1571727600"; 
   d="scan'208";a="228370439"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 19 Dec 2019 12:32:14 -0800
Date:   Thu, 19 Dec 2019 12:32:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH v2] kvm/svm: PKU not currently supported
Message-ID: <20191219203214.GC6439@linux.intel.com>
References: <20191219201759.21860-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219201759.21860-1-john.allen@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 19, 2019 at 02:17:59PM -0600, John Allen wrote:
> Current SVM implementation does not have support for handling PKU. Guests
> running on a host with future AMD cpus that support the feature will read
> garbage from the PKRU register and will hit segmentation faults on boot as
> memory is getting marked as protected that should not be. Ensure that cpuid
> from SVM does not advertise the feature.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> v2:
>   -Introduce kvm_x86_ops->pku_supported()

I like the v1 approach better, it's less code to unwind when SVM gains
support for virtualizaing PKU.

The existing cases of kvm_x86_ops->*_supported() in __do_cpuid_func() are
necessary to handle cases where it may not be possible to expose a feature
even though it's supported in hardware, host and KVM, e.g. VMX's separate
MSR-based features and PT's software control to hide it from guest.  In
this case, hiding PKU is purely due to lack of support in KVM.  The SVM
series to enable PKU can then delete a single line of SVM code instead of
having to go back in and do surgery on x86 and VMX.
