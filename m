Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF94B144B6D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 06:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVFrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 00:47:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:27602 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgAVFrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jan 2020 00:47:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 21:47:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,348,1574150400"; 
   d="scan'208";a="221136424"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jan 2020 21:47:24 -0800
Date:   Tue, 21 Jan 2020 21:47:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
Message-ID: <20200122054724.GD18513@linux.intel.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
 <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 19, 2020 at 09:54:44AM +0100, Paolo Bonzini wrote:
> On 15/01/20 18:10, Vitaly Kuznetsov wrote:
> > With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
> > with default (matching CPU model) values and in case eVMCS is also enabled,
> > fails.
> > 
> > It would be possible to drop VMX feature filtering completely and make
> > this a guest's responsibility: if it decides to use eVMCS it should know
> > which fields are available and which are not. Hyper-V mostly complies to
> > this, however, there is at least one problematic control:
> > SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
> > which Hyper-V enables. As there is no 'apic_addr_field' in eVMCS, we
> > fail to handle this properly in KVM. It is unclear how this is supposed
> > to work, genuine Hyper-V doesn't expose the control so it is possible that
> > this is just a bug (in Hyper-V).
> 
> Yes, it most likely is and it would be nice if Microsoft fixed it, but I
> guess we're stuck with it for existing Windows versions.  Well, for one
> we found a bug in Hyper-V and not the converse. :)
> 
> There is a problem with this approach, in that we're stuck with it
> forever due to live migration.  But I guess if in the future eVMCS v2
> adds an apic_address field we can limit the hack to eVMCS v1.  Another
> possibility is to use the quirks mechanism but it's overkill for now.
> 
> Unless there are objections, I plan to apply these patches.

Doesn't applying this patch contradict your earlier opinion?  This patch
would still hide the affected controls from the guest because the host
controls enlightened_vmcs_enabled.

On Sat, Jan 18, 2020 at 10:42:31PM +0100, Paolo Bonzini wrote:
> IMHO the features should stay available in case the guest chooses not to
> use eVMCS.  A guest that uses eVMCS should know which features it cannot
> use and not enable them.

Makes sense, wasn't thinking about the scenario where the guest doesn't
support eVMCS or doesn't want to use it for whatever reason.

Rather than update vmx->nested.msrs or filter vmx_get_msr(), what about
manually adding eVMCS consistency checks on the disallowed bits and handle
SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES as a one-off case by simply
clearing it from the eVMCS?  Or alternatively, squashing all the disallowed
bits.
