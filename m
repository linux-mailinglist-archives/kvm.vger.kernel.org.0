Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 808A87332E
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 17:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfGXPzi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 11:55:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:26320 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfGXPzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 11:55:37 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 08:55:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,303,1559545200"; 
   d="scan'208";a="193502096"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jul 2019 08:55:36 -0700
Date:   Wed, 24 Jul 2019 08:55:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 2/2 v2]kvm-unit-test: nVMX: Test Host Segment Registers
 and Descriptor Tables on vmentry of nested guests
Message-ID: <20190724155536.GA25376@linux.intel.com>
References: <20190703235437.13429-1-krish.sadhukhan@oracle.com>
 <20190703235437.13429-3-krish.sadhukhan@oracle.com>
 <826A8AB0-D0A3-4C77-96C9-9C6670CF6C9C@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <826A8AB0-D0A3-4C77-96C9-9C6670CF6C9C@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 21, 2019 at 11:26:24AM -0700, Nadav Amit wrote:
> > On Jul 3, 2019, at 4:54 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
> > 
> > According to section "Checks on Host Segment and Descriptor-Table
> > Registers" in Intel SDM vol 3C, the following checks are performed on
> > vmentry of nested guests:
> > 
> >    - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
> >      RPL (bits 1:0) and the TI flag (bit 2) must be 0.
> >    - The selector fields for CS and TR cannot be 0000H.
> >    - The selector field for SS cannot be 0000H if the "host address-space
> >      size" VM-exit control is 0.
> >    - On processors that support Intel 64 architecture, the base-address
> >      fields for FS, GS, GDTR, IDTR, and TR must contain canonical
> >      addresses.
> 
> As I noted on v1, this patch causes the test to fail on bare-metal:
> 
>  FAIL: HOST_SEL_SS 0: VMX inst error is 8 (actual 7)
> 
> I don’t know what the root-cause is, but I don't think that tests that
> fail on bare-metal (excluding because of CPU errata) should be included.

A 64-bit VMM isn't allowed to transition to 32-bit mode by way of VM-Exit,
and the VMX tests are 64-bit only.

  If the logical processor is in IA-32e mode (if IA32_EFER.LMA=1) at the
  time of VM entry, the "host address space size" VM-exit control must be 1.
