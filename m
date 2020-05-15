Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB5D1D5CDE
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 01:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgEOXlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 19:41:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:15505 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgEOXlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 19:41:52 -0400
IronPort-SDR: /WxQe0mlhZy1I5P8lw5QZSb/wrB4yyfTHfLJ2TIcExAZogyFBCXnlKqrRzE7fRhLkofFF/nXkc
 QPcG+Gx5V1zw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 16:41:52 -0700
IronPort-SDR: fjY4lg3AR4/iVB/85q1re+MQmPVW0UrbesGEMgv8Z8hnV60UfmZ7pBRWJRjtVOPIecoM1SUKcv
 jtMC73e6QDKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,396,1583222400"; 
   d="scan'208";a="266763504"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 15 May 2020 16:41:51 -0700
Date:   Fri, 15 May 2020 16:41:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Anthony Yznaga <anthony.yznaga@oracle.com>
Cc:     kvm@vger.kernel.org
Subject: Re: question: KVM_MR_CREATE and kvm_mmu_slot_apply_flags()
Message-ID: <20200515234151.GN17572@linux.intel.com>
References: <7796d7df-9c6b-7f34-6cf4-38607fcfd79b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7796d7df-9c6b-7f34-6cf4-38607fcfd79b@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 15, 2020 at 02:28:54PM -0700, Anthony Yznaga wrote:
> Hi,
> 
> I'm investigating optimizing qemu start time for large memory guests,
> and I'm trying to understand why kvm_mmu_slot_apply_flags() is called by
> kvm_arch_commit_memory_region() for KVM_MR_CREATE.  The comments in
> kvm_mmu_slot_apply_flags() imply it should be, but what I've observed is
> that the new slot will have no mappings resulting in slot_handle_level_range()
> walking the rmaps and doing nothing.  This can take a noticeable amount of
> time for very large ranges.  It doesn't look like there would ever be any
> mappings in a newly created slot.  Am I missing something?

I don't think so.  I've stared at that call more than once trying to figure
out why it's there.  AFAICT, the original code was completely unoptimized,
then the DELETE check got added as the obvious "this is pointless" case.
Note, KVM_MR_MOVE is in the same boat as CREATE; it's basically DELETE+CREATE.

There can theoretically be rmaps for the new/moved memslot, but they should
already be up-to-date since they're consuming the new memslot's properties.

I've always been too scared to remove it and didn't have a strong argument
for doing so :-)
