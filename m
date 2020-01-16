Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A87C13FF98
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 00:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732382AbgAPXoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 18:44:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:15930 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbgAPXoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 18:44:12 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 15:44:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,327,1574150400"; 
   d="scan'208";a="249024648"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 16 Jan 2020 15:44:11 -0800
Date:   Thu, 16 Jan 2020 15:44:10 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Spoorti Doddamani <spoosd@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Question on rdtsc instruction in guest
Message-ID: <20200116234410.GF20561@linux.intel.com>
References: <CAGKSnTgv5F_d23oRi3FHwKVw8Mij7_5g4o2FiaXwDA43KP+nng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGKSnTgv5F_d23oRi3FHwKVw8Mij7_5g4o2FiaXwDA43KP+nng@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 04:39:47PM -0500, Spoorti Doddamani wrote:
> Hi,
> 
> I would like to know how rdtsc instruction works when executed in
> guest. The guest uses kvm-clock for timekeeping. The tsc_timestamp
> field in the shared page between the hypervisor and guest is updated
> constantly by the hypervisor. Does rdtsc instruction, when executed in
> guest, read the value from this shared page? Or does it read the
> hardware TSC MSR register? If it reads from the hardware TSC MSR
> register why do I observe different values of TSC when executed in
> host and guest? Or is the instruction emulated by the hypervisor?

On KVM, RDTSC accesses hardware directly.  A VMM *can* configure RDTSC to
VM-Exit, e.g. to emulate it, but KVM does not do so (unless you get into
nested virtualization scenarios).

As to why the guest sees a different value, hardware supports a virtual
TSC via a TSC offset mechanism, i.e. RDTSC returns the "real" TSC plus an
arbitrary value (the offset) controlled by the VMM (KVM).  This allows KVM
to virtualize the TSC and expose RDTSC to the guest (as opposed to
emulating RDTSC).

Recent CPUs also support TSC scaling, which essentially allows the virtual
TSC to count at a different frequency than the real TSC.  This is used to
migrate VMs between physical systems with different TSC frequencies.
