Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6901BE815
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 22:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgD2UGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 16:06:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:37019 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgD2UGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 16:06:30 -0400
IronPort-SDR: OqmVG6wuJxhpQbu6OPYgekd/oHCyHWVmDMqvwFDKln8Zn+sye7UbKRFnWS1qSI98GSJTiPgXoM
 aHI/PfKTRHlg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 13:06:30 -0700
IronPort-SDR: m0hwcU/Pm2d+wtnIowylzWCVRuCjU8EwMkKdW30+nKlBoOHV3ncQiMMWzW2at5i/VsEZUZBqrr
 cmL1GXMTa68g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="459315579"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2020 13:06:29 -0700
Date:   Wed, 29 Apr 2020 13:06:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 09/13] KVM: nVMX: Prioritize SMI over nested IRQ/NMI
Message-ID: <20200429200629.GH15992@linux.intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-10-sean.j.christopherson@intel.com>
 <CALMp9eSuYqeVmWhb6q7T5DAW_Npbuin_N1+sbWjvcu0zTqiwsQ@mail.gmail.com>
 <20200428225949.GP12735@linux.intel.com>
 <CALMp9eRFfEB1avbQv0O0V=EGrJdSNTxg8Z-BONmQ--dV66CuAg@mail.gmail.com>
 <20200429145040.GA15992@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200429145040.GA15992@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 07:50:40AM -0700, Sean Christopherson wrote:
> On Tue, Apr 28, 2020 at 04:16:16PM -0700, Jim Mattson wrote:
> > On Tue, Apr 28, 2020 at 3:59 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > On Tue, Apr 28, 2020 at 03:04:02PM -0700, Jim Mattson wrote:
> > > > From the SDM, volume 3:
> > > >
> > > > • System-management interrupts (SMIs), INIT signals, and higher
> > > > priority events take priority over MTF VM exits.
> > > >
> > > > I think this block needs to be moved up.
> > >
> > > Hrm.  It definitely needs to be moved above the preemption timer, though I
> > > can't find any public documentation about the preemption timer's priority.
> > > Preemption timer is lower priority than MTF, ergo it's not in the same
> > > class as SMI.
> > >
> > > Regarding SMI vs. MTF and #DB trap, to actually prioritize SMIs above MTF
> > > and #DBs, we'd need to save/restore MTF and pending #DBs via SMRAM.  I
> > > think it makes sense to take the easy road and keep SMI after the traps,
> > > with a comment to say it's technically wrong but not worth fixing.
> > 
> > Pending debug exceptions should just go in the pending debug
> > exceptions field. End of story and end of complications. I don't
> > understand why kvm is so averse to using this field the way it was
> > intended.
> 
> Ah, it took my brain a bit to catch on.  I assume you're suggesting calling
> nested_vmx_updated_pending_dbg() so that the pending #DB naturally gets
> propagated to/from vmcs12 on SMI/RSM?  I think that should work.

This works for L2, but not L1 :-(  And L2 can't be fixed without first
fixing L1 because inject_pending_event() also incorrectly prioritizes #DB
over SMI.  For L1, utilizing SMRAM to save/restore the pending #DB is
likely the easiest solution as it avoids having to add new state for
migration.

I have everything coded up but it'll probably take a few weeks to test and
get it sent out, need to focus on other stuff for a while.
