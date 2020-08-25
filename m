Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF96250CC6
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 02:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgHYAJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 20:09:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:65187 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgHYAJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 20:09:22 -0400
IronPort-SDR: in6mQyaE3lxWCYtRDXPWM6P4GGEKYWJCFKDgTEk2WgUS4sOkZKc1/on3YEaQs9QD8vFVgG/120
 1a4yRG9JIcdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9723"; a="155266726"
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="155266726"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 17:09:21 -0700
IronPort-SDR: 8YS13PJ3V8TKh9YR7Yhpg2pMk3nq/iOi8BK+54EBEiC07H5IaJaawmddGdUrWtpr6gKiVj2mZp
 SpWR03Ye0FAA==
X-IronPort-AV: E=Sophos;i="5.76,350,1592895600"; 
   d="scan'208";a="443424528"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2020 17:09:21 -0700
Date:   Mon, 24 Aug 2020 17:09:20 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: fix crash cleanup when KVM wasn't used
Message-ID: <20200825000920.GB15046@sjchrist-ice>
References: <20200401081348.1345307-1-vkuznets@redhat.com>
 <CALMp9eROXAOg_g=R8JRVfywY7uQXzBtVxKJYXq0dUcob-BfR-g@mail.gmail.com>
 <20200822034046.GE4769@sjchrist-ice>
 <CALMp9eRHh9KXO12k4GaoenSJazFnSaN68FTVxOGhE9Mxw-hf2A@mail.gmail.com>
 <CALMp9eS1HusEZvzLShuuuxQnReKgTtunsKLoy+2GMVJAaTrZ7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS1HusEZvzLShuuuxQnReKgTtunsKLoy+2GMVJAaTrZ7A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 03:45:26PM -0700, Jim Mattson wrote:
> On Mon, Aug 24, 2020 at 11:57 AM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Aug 21, 2020 at 8:40 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > > I agree the code is a mess (kvm_init() and kvm_exit() included), but I'm
> > > pretty sure hardware_disable_nolock() is guaranteed to be a nop as it's
> > > impossible for kvm_usage_count to be non-zero if vmx_init() hasn't
> > > finished.
> >
> > Unless I'm missing something, there's no check for a non-zero
> > kvm_usage_count on this path. There is such a check in
> > hardware_disable_all_nolock(), but not in hardware_disable_nolock().
> 
> However, cpus_hardware_enabled shouldn't have any bits set, so
> everything's fine. Nothing to see here, after all.

Ugh, I forgot that hardware_disable_all_nolock() does a BUG_ON() instead of
bailing on !kvm_usage_count.
