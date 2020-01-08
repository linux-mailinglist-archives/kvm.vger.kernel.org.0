Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD301337CA
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 01:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgAHAEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 19:04:14 -0500
Received: from mga04.intel.com ([192.55.52.120]:19712 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgAHAEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 19:04:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jan 2020 16:04:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,407,1571727600"; 
   d="scan'208";a="211354742"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 07 Jan 2020 16:04:12 -0800
Date:   Tue, 7 Jan 2020 16:04:12 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: Override default MMIO mask if memory
 encryption is enabled
Message-ID: <20200108000412.GE16987@linux.intel.com>
References: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
 <20200106224931.GB12879@linux.intel.com>
 <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
 <20200106233846.GC12879@linux.intel.com>
 <a4fb7657-59b6-2a3f-1765-037a9a9cd03a@amd.com>
 <20200107222813.GB16987@linux.intel.com>
 <298352c6-7670-2929-9621-1124775bfaed@amd.com>
 <20200107233102.GC16987@linux.intel.com>
 <c60d15f2-ca10-678c-30aa-5369cf3864c7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c60d15f2-ca10-678c-30aa-5369cf3864c7@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 07, 2020 at 05:51:51PM -0600, Tom Lendacky wrote:
> On 1/7/20 5:31 PM, Sean Christopherson wrote:
> > AIUI, using phys_bits=48, then the standard scenario is Cbit=47 and some
> > additional bits 46:M are reserved.  Applying that logic to phys_bits=52,
> > then Cbit=51 and bits 50:M are reserved, so there's a collision but it's
> 
> There's no requirement that the C-bit correspond to phys_bits. So, for
> example, you can have C-bit=51 and phys_bits=48 and so 47:M are reserved.

But then using blindly using x86_phys_bits would break if the PA bits
aren't reduced, e.g. C-bit=47 and phys_bits=47. AFAICT, there's no
requirement that there be reduced PA bits when there is a C-bit.  I'm
guessing there aren't plans to ship such CPUs, but I don't see anything
in the APM to prevent such a scenario.

Maybe the least painful approach would be to go with a version of this
patch and add a check that there are indeeded reserved/reduced bits?
Probably with a WARN_ON_ONCE if the check fails.
