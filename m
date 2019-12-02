Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1AA10F38E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 00:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfLBXqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 18:46:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:55457 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfLBXqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 18:46:45 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="293592396"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 02 Dec 2019 15:46:44 -0800
Date:   Mon, 2 Dec 2019 15:46:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 10/28] kvm: mmu: Flush TLBs before freeing direct MMU
 page table memory
Message-ID: <20191202234644.GH8120@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-11-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-11-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:18:06PM -0700, Ben Gardon wrote:
> If page table memory is freed before a TLB flush, it can result in
> improper guest access to memory through paging structure caches.
> Specifically, until a TLB flush, memory that was part of the paging
> structure could be used by the hardware for address translation if a
> partial walk leading to it is stored in the paging structure cache. Ensure
> that there is a TLB flush before page table memory is freed by
> transferring disconnected pages to a disconnected list, and on a flush
> transferring a snapshot of the disconnected list to a free list. The free
> list is processed asynchronously to avoid slowing TLB flushes.

Tangentially realted to TLB flushing, what generations of CPUs have you
tested this on?  I don't have any specific concerns, but ideally it'd be
nice to get testing cycles on older hardware before merging.  Thankfully
TDP-only eliminates ridiculously old hardware :-)
