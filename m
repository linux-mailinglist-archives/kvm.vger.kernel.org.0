Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1328131C7B
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 00:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgAFXir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 18:38:47 -0500
Received: from mga06.intel.com ([134.134.136.31]:29283 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgAFXiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 18:38:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 15:38:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,404,1571727600"; 
   d="scan'208";a="395171038"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 06 Jan 2020 15:38:46 -0800
Date:   Mon, 6 Jan 2020 15:38:46 -0800
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
Message-ID: <20200106233846.GC12879@linux.intel.com>
References: <d741b3a58769749b7873fea703c027a68b8e2e3d.1577462279.git.thomas.lendacky@amd.com>
 <20200106224931.GB12879@linux.intel.com>
 <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5c2e60c-536f-e0cd-98b9-86e6da82e48f@amd.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 06, 2020 at 05:14:04PM -0600, Tom Lendacky wrote:
> On 1/6/20 4:49 PM, Sean Christopherson wrote:
> > This doesn't handle the case where x86_phys_bits _isn't_ reduced by SME/SEV
> > on a future processor, i.e. x86_phys_bits==52.
> 
> Not sure I follow. If MSR_K8_SYSCFG_MEM_ENCRYPT is set then there will
> always be a reduction in physical addressing (so I'm told).

Hmm, I'm going off APM Vol 2, which states, or at least strongly implies,
that reducing the PA space is optional.  Section 7.10.2 is especially
clear on this:

  In implementations where the physical address size of the processor is
  reduced when memory encryption features are enabled, software must
  ensure it is executing from addresses where these upper physical address
  bits are 0 prior to setting SYSCFG[MemEncryptionModEn].

But, hopefully the other approach I have in mind actually works, as it's
significantly less special-case code and would naturally handle either
case, i.e. make this a moot point.


Entry on SYSCFG:

  3.2.1 System Configuration Register (SYSCFG)

  ...

  MemEncryptionMode. Bit 23.  Setting this bit to 1 enables the SME and
  SEV memory encryption features.

The SME entry the above links to says:

  7.10.1 Determining Support for Secure Memory Encryption

  ...

  Additionally, in some implementations, the physical address size of the
  processor may be reduced when memory encryption features are enabled, for
  example from 48 to 43 bits. In this case the upper physical address bits are
  treated as reserved when the feature is enabled except where otherwise
  indicated. When memory encryption is supported in an implementation, CPUID
  Fn8000_001F[EBX] reports any physical address size reduction present. Bits
  reserved in this mode are treated the same as other page table reserved bits,
  and will generate a page fault if found to be non-zero when used for address
  translation.

  ...

  7.10.2 Enabling Memory Encryption Extensions

  Prior to using SME, memory encryption features must be enabled by setting
  SYSCFG MSR bit 23 (MemEncryptionModEn) to 1. In implementations where the
  physical address size of the processor is reduced when memory encryption
  features are enabled, software must ensure it is executing from addresses where
  these upper physical address bits are 0 prior to setting
  SYSCFG[MemEncryptionModEn]. Memory encryption is then further controlled via
  the page tables.
