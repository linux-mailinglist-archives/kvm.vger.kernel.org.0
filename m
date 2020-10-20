Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E272944E1
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 00:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438825AbgJTWCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 18:02:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:12286 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393297AbgJTWCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 18:02:01 -0400
IronPort-SDR: cUm1QtxOsuLL1KNdzUI8oz/dn24cfCzxHM5CSvUPYipZ4MZzKmfiADnUKaUU6lqClFjNiXYVc1
 xbXlLLJkRYjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="167402789"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="167402789"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 15:02:00 -0700
IronPort-SDR: SDvlJ7R/uvctTTXAgbabzL6A8JomQVIrmC8a8NdhXDwLV2ZwgBW7c11bOTo5UlF+0Fm0u2Aam9
 f50ahWPNGLNg==
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="522522811"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 15:02:00 -0700
Date:   Tue, 20 Oct 2020 15:01:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND v4 1/2] KVM: VMX: Convert vcpu_vmx.exit_reason to a union
Message-ID: <20201020220158.GA9031@linux.intel.com>
References: <20201012033542.4696-1-chenyi.qiang@intel.com>
 <20201012033542.4696-2-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012033542.4696-2-chenyi.qiang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 11:35:41AM +0800, Chenyi Qiang wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> bits 15:0, and single-bit modifiers in bits 31:16.
> 
> Historically, KVM has only had to worry about handling the "failed
> VM-Entry" modifier, which could only be set in very specific flows and
> required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> bit was a somewhat viable approach.  But even with only a single bit to
> worry about, KVM has had several bugs related to comparing a basic exit
> reason against the full exit reason store in vcpu_vmx.
> 
> Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> be set on more or less any VM-Exit, as opposed to the significantly more
> restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> flows isn't scalable.  Tracking exit reason in a union forces code to
> explicitly choose between consuming the full exit reason and the basic
> exit, and is a convenient way to document and access the modifiers.
> 
> No functional change intended.
> 
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

This needs your SOB since you are involved in the handling of the patch.
