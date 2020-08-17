Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB2E246D60
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 18:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389147AbgHQQys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 12:54:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:58190 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389041AbgHQQyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 12:54:25 -0400
IronPort-SDR: Deo6gq4MeatWj4kph92QCrrEBLGoEHRff6KYdiUFv5/B1ZUAY+T7ToGKdQpUzM2d4dtzO1ZLfJ
 ZYoGJUqa/KWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="134810301"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="134810301"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 09:54:22 -0700
IronPort-SDR: 5QaLYquQgxJFgogwW+gHqL7hUTVQPvijvIwNRUcF36536k4FXznaAfbVbS7BcnIV7U27eXq/M6
 ttueXy8HVE5g==
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="296546351"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 09:54:12 -0700
Date:   Mon, 17 Aug 2020 09:54:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     contact@kevinloughlin.org
Cc:     kvm@vger.kernel.org
Subject: Re: x86 MMU: RMap Interface
Message-ID: <20200817165411.GE22407@linux.intel.com>
References: <d49ad8fb155e2ebc6e54d8b83c335926@kevinloughlin.org>
 <20200720154901.GB20375@linux.intel.com>
 <b7f5d039b4e4b12697ee5e65cf03d25b@kevinloughlin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7f5d039b4e4b12697ee5e65cf03d25b@kevinloughlin.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 14, 2020 at 11:44:49PM -0400, contact@kevinloughlin.org wrote:
> Thanks!
> 
> Given this info, am I correct in saying that all non-MMIO guest pages are
> (1) added to the rmap upon being marked present, and (2) removed from the
> rmap upon being marked non-present?
> 
> I primarily ask because I'm observing behavior (running x86-64 guest with
> TDP/EPT enabled) wherein multiple SPTEs appear to be added to the rmap for
> the same GFN<->PFN mapping (sometimes later followed by multiple removals of
> the same GFN<->PFN mapping). My understanding was that, for a given guest,
> each GFN<->PFN mapping corresponds to exactly one rmap entry (and vice
> versa). Is this incorrect?
> 
> I observe the behavior I mentioned whether I log upon rmap updates, or upon
> mmu_spte_set() (for non-present->present) and mmu_clear_track_bits() (for
> present->non-present). Perhaps I'm missing a more obvious interface for
> logging when the PFNs backing guest pages are marked as present/non-present?

The basic premise is correct, but there are exceptions (or rather, at least
one exception that immediately comes to mind).  With TDP and no nested VMs,
a given instance of the MMU will have a 1:1 GFN:PFN mapping.  But, if the
MMU is recreated (reloaded with a different EPTP), e.g. as part of a fast
zap, then there may be mappings for the GFN:PFN in both the old MMU/EPTP
instance and the new MMU/EPTP instance, and thus multiple rmaps.

KVM currently does a fast zap (and MMU reload) when deleting memslots, which
happens multiple times during boot, so the behavior you're observing is
expected.
