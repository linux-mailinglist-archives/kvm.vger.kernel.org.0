Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5F4882B8
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 20:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436927AbfHIShb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 14:37:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:7513 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436899AbfHIShb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 14:37:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 11:37:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="374571640"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 09 Aug 2019 11:37:30 -0700
Date:   Fri, 9 Aug 2019 11:37:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v3 5/7] x86: KVM: svm: remove hardcoded instruction
 length from intercepts
Message-ID: <20190809183730.GE10541@linux.intel.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
 <20190808173051.6359-6-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808173051.6359-6-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 08, 2019 at 07:30:49PM +0200, Vitaly Kuznetsov wrote:
> Various intercepts hard-code the respective instruction lengths to optimize
> skip_emulated_instruction(): when next_rip is pre-set we skip
> kvm_emulate_instruction(vcpu, EMULTYPE_SKIP). The optimization is, however,
> incorrect: different (redundant) prefixes could be used to enlarge the
> instruction. We can't really avoid decoding.
> 
> svm->next_rip is not used when CPU supports 'nrips' (X86_FEATURE_NRIPS)
> feature: next RIP is provided in VMCB. The feature is not really new
> (Opteron G3s had it already) and the change should have zero affect.
> 
> Remove manual svm->next_rip setting with hard-coded instruction lengths.
> The only case where we now use svm->next_rip is EXIT_IOIO: the instruction
> length is provided to us by hardware.
> 
> Hardcoded RIP advancement remains in vmrun_interception(), this is going to
> be taken care of separately.
> 
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
