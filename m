Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CB222A0C4
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 22:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbgGVUcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 16:32:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:34992 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgGVUcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 16:32:46 -0400
IronPort-SDR: jiXj/a9LaqWJqy8qlku6zsM4Oz9CQT0ooOeMvVO378bT6ex/+nxpWuBWw8YPhzOFK2JuilMbT8
 Qvs6FXGtEHhg==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="215045946"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="215045946"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 13:32:45 -0700
IronPort-SDR: 8yKgNfCi3/8G/Oq7P71tWxhlFKpxRnZ+tszPoYSoQ4Ma1iaTLU6hAj3oaYiFdGPQ3cljuLY0Hm
 YtIvsy1SmKIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="326802777"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jul 2020 13:32:45 -0700
Date:   Wed, 22 Jul 2020 13:32:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [RESEND v13 06/11] KVM: x86: Load guest fpu state when access
 MSRs managed by XSAVES
Message-ID: <20200722203244.GG9114@linux.intel.com>
References: <20200716031627.11492-1-weijiang.yang@intel.com>
 <20200716031627.11492-7-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716031627.11492-7-weijiang.yang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 16, 2020 at 11:16:22AM +0800, Yang Weijiang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> A handful of CET MSRs are not context switched through "traditional"
> methods, e.g. VMCS or manual switching, but rather are passed through
> to the guest and are saved and restored by XSAVES/XRSTORS, i.e. in the
> guest's FPU state.
> 
> Load the guest's FPU state if userspace is accessing MSRs whose values
> are managed by XSAVES so that the MSR helper, e.g. vmx_{get,set}_msr(),
> can simply do {RD,WR}MSR to access the guest's value.
> 
> Note that guest_cpuid_has() is not queried as host userspace is allowed
> to access MSRs that have not been exposed to the guest, e.g. it might do
> KVM_SET_MSRS prior to KVM_SET_CPUID2.

No comments on the patch itself.  Added a blurb to the changelog to call
out the vcpu==NULL case is possible due to KVM_GET_MSRS also being a device
scope ioctl().

> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
