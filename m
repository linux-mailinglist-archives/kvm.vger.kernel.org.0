Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C572F24074
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 20:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfETSdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 14:33:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:62965 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfETSdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 14:33:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 11:33:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga005.fm.intel.com with ESMTP; 20 May 2019 11:33:31 -0700
Date:   Mon, 20 May 2019 11:33:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alexander Graf <agraf@csgraf.de>
Cc:     Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        KarimAllah Ahmed <karahmed@amazon.de>
Subject: Re: #VE support for VMI
Message-ID: <20190520183331.GD28482@linux.intel.com>
References: <571322cc13b98f3805a4843db28f5befbb1bd5a9.camel@bitdefender.com>
 <80e0baaf-150b-0966-6920-b36d23a6cdef@csgraf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80e0baaf-150b-0966-6920-b36d23a6cdef@csgraf.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 11:10:51AM -0700, Alexander Graf wrote:
> On 20.05.19 08:48, Mihai Donțu wrote:
> > Hi Paolo,
> > 
> > We are looking at adding #VE support to the VMI subsystem we are
> > working on. Its purpose is to suppress VMEXIT-s caused by the page
> > table walker when the guest page tables are write-protected. A very
> > small in-guest agent (protected by the hypervisor) will receive the EPT
> > violation events, handle PT-walk writes and turn the rest into VMCALL-
> > s.
> > 
> > A brief presentation of similar work on Xen can be found here:
> > https://www.slideshare.net/xen_com_mgr/xpdss17-hypervisorbased-security-bringing-virtualized-exceptions-into-the-game-mihai-dontu-bitdefender
> > 
> > There is a bit of an issue with using #VE on KVM, though: because the
> > EPT is built on-the-fly (as the guest runs), when we enable #VE in
> > VMCS, all EPT violations become virtualized, because all EPTE-s have
> > bit 63 zero (0: convert to #VE, 1: generate VMEXIT). At the moment, I
> 
> Are you 100% sure? Last time I played with #VE, it only triggered on
> misconfigurations/permission checks (lack of R/W/X, but P=1), not on P=0
> pages.

#VEs trigger on RWX=0, but not misconfigurations, i.e. any and all
EPT_VIOLATION exits (reason 48) are convertible, and EPT_MISCONFIG exits
(reason 49) are never convertible.  The reasoning behind the logic is
that an EPT_MISCONFIG is the result of a VMM bug (or in KVM's case, MMIO
trickery), whereas a RWX=0 EPT_VIOLATION could be a malicious entity in
the guest probing non-existent pages or pages it doesn't have access to.
