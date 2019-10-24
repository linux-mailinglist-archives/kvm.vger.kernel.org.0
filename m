Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0144E2831
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 04:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437083AbfJXCbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 22:31:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:16285 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbfJXCbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 22:31:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 19:31:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,222,1569308400"; 
   d="scan'208";a="201327829"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 23 Oct 2019 19:31:43 -0700
Date:   Wed, 23 Oct 2019 19:31:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Junaid Shahid <junaids@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Sperbeck <jsperbeck@google.com>
Subject: Re: [PATCH v2] kvm: call kvm_arch_destroy_vm if vm creation fails
Message-ID: <20191024023142.GB3744@linux.intel.com>
References: <20191023203214.93252-1-jmattson@google.com>
 <20191024000544.GA3744@linux.intel.com>
 <3ccc2f6c-9695-ee76-5734-e93eb802d7e2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ccc2f6c-9695-ee76-5734-e93eb802d7e2@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 23, 2019 at 06:18:35PM -0700, Junaid Shahid wrote:
> [Plain-text resend]
> 
> On 10/23/19 5:05 PM, Sean Christopherson wrote:
> > 
> > Side topic, the loops to free the buses and memslots belong higher up,
> > the arrays aren't initialized until after hardware_enable().  Probably
> > doesn't harm anything but it's a waste of cycles.  I'll send a patch.
> > 
> 
> Aren't the x86_set_memory_region() calls inside kvm_arch_destroy_vm() going
> to be problematic if hardware_enable_all() fails? Perhaps we should move the
> memslots allocation before kvm_arch_init_vm(), or check for NULL memslots in
> kvm_arch_destroy_vm().

Oof, that does appear to be the case.  Initializing memslots and buses
before calling into arch code seems like the way to go.
