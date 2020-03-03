Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F05B61779B1
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 15:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgCCO5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 09:57:47 -0500
Received: from mga07.intel.com ([134.134.136.100]:12485 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727440AbgCCO5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 09:57:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 06:57:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="412763005"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 03 Mar 2020 06:57:46 -0800
Date:   Tue, 3 Mar 2020 06:57:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/13] KVM: x86: Dynamically allocate per-vCPU
 emulation context
Message-ID: <20200303145746.GA1439@linux.intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-9-sean.j.christopherson@intel.com>
 <87wo89i7e3.fsf@vitty.brq.redhat.com>
 <83bd7c0c-ac3c-8ab5-091f-598324156d27@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83bd7c0c-ac3c-8ab5-091f-598324156d27@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 11:26:21AM +0100, Paolo Bonzini wrote:
> On 26/02/20 18:29, Vitaly Kuznetsov wrote:
> >>  struct x86_emulate_ctxt {
> >> +	void *vcpu;
> > Why 'void *'? I changed this to 'struct kvm_vcpu *' and it seems to
> > compile just fine...
> > 
> 
> I guess because it's really just an opaque pointer; using void* ensures
> that the emulator doesn't break the emulator ops abstraction.

Ya, it prevents the emulator from directly deferencing the vcpu.
