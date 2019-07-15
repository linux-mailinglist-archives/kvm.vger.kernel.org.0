Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720E468FC2
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 16:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389340AbfGOOQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 10:16:39 -0400
Received: from mga07.intel.com ([134.134.136.100]:1226 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731676AbfGOOQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 10:16:37 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 07:16:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="167347987"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jul 2019 07:16:36 -0700
Date:   Mon, 15 Jul 2019 07:16:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com
Subject: Re: [PATCH v7 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
Message-ID: <20190715141636.GB442@linux.intel.com>
References: <20190712082907.29137-1-tao3.xu@intel.com>
 <20190712082907.29137-3-tao3.xu@intel.com>
 <20190712155202.GC29659@linux.intel.com>
 <8ed3cec5-8ba9-b2ed-f0e4-eefb0a988bc8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ed3cec5-8ba9-b2ed-f0e4-eefb0a988bc8@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 15, 2019 at 09:22:14AM +0800, Tao Xu wrote:
> On 7/12/2019 11:52 PM, Sean Christopherson wrote:
> >The SDM only defines bits 31:0, and the kernel uses a u32 to cache its
> >value.  I assume bits 63:32 are reserved?  I'm guessing we also need an
> >SDM update...
> >
> 
> The SDM define IA32_UMWAIT_CONTROL is a 32bit MSR. So need me to set 63:32
> reserved?

Huh, I didn't realize the SDM allows 32 bit MSRs, I assumed all bits
needed to be explicitly defined even if the underlying implementation only
tracked 32 bits.

RDMSR:

  If fewer than 64 bits are implemented in the MSR being read, the values
  return in EDX:EAX in unimplemented bit locations are undefined.

WRMSR:

  Undefined or reserved bits in an MSR should be set to values previously
  read.

From KVM's perspective, bits 63:32 should be treated as reserved-to-zero.
This also means that struct vcpu_vmx can track a u32 instead of a u64
for msr_ia32_umwait_control.
