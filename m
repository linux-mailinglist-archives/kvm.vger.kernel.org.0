Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4B019008D
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 22:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCWVnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 17:43:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:58783 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgCWVnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 17:43:18 -0400
IronPort-SDR: tziNcJmLxCcjM0YPon1rWz7pbDJ35kAPuY+ggIQidfcBI6iOVQCYFy4zqj+i3+5g9xH27p3KiP
 gXMqSIYYVtaQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:43:18 -0700
IronPort-SDR: gG/i2xiQabDd+0fKhxgcrKNHoliXkP2XeeQaOXnMeGJ5UazG6ramiBv3ouABkLU8FEAciJMZ8d
 bqHQCPBHyiVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="235350031"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 23 Mar 2020 14:43:18 -0700
Date:   Mon, 23 Mar 2020 14:43:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: Re: [PATCH 7/7] KVM: selftests: Add "delete" testcase to
 set_memory_region_test
Message-ID: <20200323214317.GV28711@linux.intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
 <20200320205546.2396-8-sean.j.christopherson@intel.com>
 <20200323190636.GM127076@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323190636.GM127076@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 03:06:36PM -0400, Peter Xu wrote:
> On Fri, Mar 20, 2020 at 01:55:46PM -0700, Sean Christopherson wrote:
> > +	/*
> > +	 * Spin until the memory region is moved to a misaligned address.  This
> > +	 * may or may not trigger MMIO, as the window where the memslot is
> > +	 * invalid is quite small.
> > +	 */
> > +	val = guest_spin_on_val(0);
> > +	GUEST_ASSERT(val == 1 || val == MMIO_VAL);
> > +
> > +	/* Spin until the memory region is realigned. */
> > +	GUEST_ASSERT(guest_spin_on_val(MMIO_VAL) == 1);
> 
> IIUC ideally we should do GUEST_SYNC() after each GUEST_ASSERT() to
> make sure the two threads are in sync.  Otherwise e.g. there's no
> guarantee that the main thread won't run too fast to quickly remove
> the memslot and re-add it back before the guest_spin_on_val() starts
> above, then the assert could trigger when it reads the value as zero.

Hrm, I was thinking ucall wasn't available across pthreads, but it's just
dumped into a global variable.  I'll rework this to replace the udelay()
hacks with proper synchronization.
