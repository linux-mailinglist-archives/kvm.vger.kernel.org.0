Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A9011580D
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 20:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfLFT5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 14:57:43 -0500
Received: from mga17.intel.com ([192.55.52.151]:35492 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbfLFT5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 14:57:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 11:57:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,285,1571727600"; 
   d="scan'208";a="214617049"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 06 Dec 2019 11:57:42 -0800
Date:   Fri, 6 Dec 2019 11:57:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 00/28] kvm: mmu: Rework the x86 TDP direct mapped case
Message-ID: <20191206195742.GC5433@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20191127190922.GH22227@linux.intel.com>
 <CANgfPd-XR0ZpbTtV21KrM_Ud1d0ntHxE6M4JzcFVZ4M0zG8XYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-XR0ZpbTtV21KrM_Ud1d0ntHxE6M4JzcFVZ4M0zG8XYQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 06, 2019 at 11:55:42AM -0800, Ben Gardon wrote:
> I'm finally back in the office. Sorry for not getting back to you sooner.
> I don't think it would be easy to send the synchronization changes
> first. The reason they seem so small is that they're all handled by
> the iterator. If we tried to put the synchronization changes in
> without the iterator we'd have to 1.) deal with struct kvm_mmu_pages,
> 2.) deal with the rmap, and 3.) change a huge amount of code to insert
> the synchronization changes into the existing framework. The changes
> wouldn't be mechanical or easy to insert either since a lot of
> bookkeeping is currently done before PTEs are updated, with no
> facility for rolling back the bookkeeping on PTE cmpxchg failure. We
> could start with the iterator changes and then do the synchronization
> changes, but the other way around would be very difficult.

By synchronization changes, I meant switching to a r/w lock instead of a
straight spinlock.  Is that doable in a smallish series?
