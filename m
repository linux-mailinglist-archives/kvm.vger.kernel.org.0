Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27421FB7F
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 21:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgGNTCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 15:02:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:19710 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731262AbgGNS6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:55 -0400
IronPort-SDR: givwFSprjeL4Mr4h/slmcV8zftQTk35wDE2YZRBlvpeRAVZ8IfNbXB1l2zsVNPJvxj6lKF0yNw
 8Lxp0ehWQNAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="210549633"
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="210549633"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 11:58:54 -0700
IronPort-SDR: T4uUEX03cyAvgT+sDDYLZfjnqNCrWzrggMmI031wo1yUThJxQ3uGcdrJkujY7qZw+MLsY6rKHu
 YW2uwZzwrDKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="390565699"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jul 2020 11:58:54 -0700
Date:   Tue, 14 Jul 2020 11:58:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH] KVM: x86: Don't attempt to load PDPTRs when 64-bit mode
 is enabled
Message-ID: <20200714185853.GC14404@linux.intel.com>
References: <20200714015732.32426-1-sean.j.christopherson@intel.com>
 <CALMp9eQ1-6GEiSh55-NXgjuq3EOwP9VWNMeriH_J64p9JMjN0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQ1-6GEiSh55-NXgjuq3EOwP9VWNMeriH_J64p9JMjN0g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 11:55:45AM -0700, Jim Mattson wrote:
> On Mon, Jul 13, 2020 at 6:57 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Don't attempt to load PDPTRs if EFER.LME=1, i.e. if 64-bit mode is
> > enabled.  A recent change to reload the PDTPRs when CR0.CD or CR0.NW is
> > toggled botched the EFER.LME handling and sends KVM down the PDTPR path
> > when is_paging() is true, i.e. when the guest toggles CD/NW in 64-bit
> > mode.
> 
> Oops!
> 
> I don't think "is_paging()" is relevant here, so much as "EFER.LME=1."
> As you note below, KVM *should* go down the PDPTR path when
> is_paging() is true and EFER.LME=0.

It's relevant for the EFER.LME=1 case as it's used to detect CR0.PG 0->1.

Though maybe we're in violent agreement?
