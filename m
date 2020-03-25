Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9A719309E
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 19:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgCYSrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 14:47:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:53481 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgCYSrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 14:47:49 -0400
IronPort-SDR: lQAMRVfMC5uhTTel3MP2HVQrp543pnQhw6dp2BRhf60rh8TjNtKm8JvIafEBvtxeSqo52A6oYa
 LEMVHHp2+cAA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 11:47:42 -0700
IronPort-SDR: q13Gvqo8nPRJc1Uw5Sc4GokeBFpqpnCJ5cnXAqZf5qjY30hPaGZm6LXZZHir7XfTHITTn3zJo2
 SdkDa7HFhnCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,305,1580803200"; 
   d="scan'208";a="446714675"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2020 11:47:41 -0700
Date:   Wed, 25 Mar 2020 11:47:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: linux-next: Tree for Mar 25 (arch/x86/kvm/)
Message-ID: <20200325184741.GI14294@linux.intel.com>
References: <20200325195350.7300fee9@canb.auug.org.au>
 <e9286016-66ae-9505-ea52-834527cdae27@infradead.org>
 <d9af8094-96c3-3b7f-835c-4e48d157e582@redhat.com>
 <064720eb-2147-1b92-7a62-f89d6380f40a@infradead.org>
 <85430f7e-93e0-3652-0705-9cf6e948a9d8@redhat.com>
 <20200325161405.GG14294@linux.intel.com>
 <7b71119b-4594-2535-24ba-2c59430e4f30@redhat.com>
 <20200325164606.GH14294@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325164606.GH14294@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 25, 2020 at 09:46:06AM -0700, Sean Christopherson wrote:
> On Wed, Mar 25, 2020 at 05:26:20PM +0100, Paolo Bonzini wrote:
> > On 25/03/20 17:14, Sean Christopherson wrote:
> > >> Doh, right.  I think the only solution for that one is to degrade it to
> > >> WARN_ON(1).
> > > I reproduced the error, give me a bit to play with the code to see if the
> > > BUILD_BUG can be preserved.  I'm curious as to why kvm_cpu_cap_mask() is
> > > special, and why it only fails with this config.
> > > 
> > 
> > I could not reproduce it, but I would not be surprised if there are
> > other configurations where the compiler cannot constant-propagate from
> > the reverse_cpuid struct into __cpuid_entry_get_reg.
> 
> The error is related to UBSAN.  There is at least one legitimate (but benign)
> underlying issue.  I'm chasing down a second instance of the BUILD_BUG.

Argh, red herring.  There is no underlying issue other than gcc tripping up
when -fsanitize=alignment is enabled by UBSAN.  Good news is that the build
error can be fixed without resorting to a hack.
