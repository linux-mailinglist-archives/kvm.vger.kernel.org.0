Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C726179342
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 16:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgCDPYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 10:24:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:48224 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgCDPYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 10:24:01 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 07:24:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,514,1574150400"; 
   d="scan'208";a="229361356"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 04 Mar 2020 07:24:00 -0800
Date:   Wed, 4 Mar 2020 07:24:00 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Liu, Jing2" <jing2.liu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Derek Yerger <derek@djy.llc>,
        kernel@najdan.com, Thomas Lambertz <mail@thomaslambertz.de>,
        Rik van Riel <riel@surriel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/4] KVM: x86: TIF_NEED_FPU_LOAD bug fixes
Message-ID: <20200304152400.GA21662@linux.intel.com>
References: <20200117062628.6233-1-sean.j.christopherson@intel.com>
 <32d432f7-bbdf-a240-7ee9-303d019d8d1a@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32d432f7-bbdf-a240-7ee9-303d019d8d1a@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 03:38:44PM +0800, Liu, Jing2 wrote:
> 
> On 1/17/2020 2:26 PM, Sean Christopherson wrote:
> >TIF_FPU_NEED_LOAD can be set any time
> >control is transferred out of KVM, e.g. via IRQ->softirq, not just when
> >KVM is preempted.
> 
> Hi Sean,
> 
> Is this just because kernel_fpu_begin() is called during softirq? I saw the
> dump trace in 3/4 message, but didn't find out clue.

Yes, but "just" doing kernel_fpu_begin() swaps the task's (e.g. guest's in
this case) XSAVE/FPU state out of the CPU's registers.

> Could I ask where kernel_fpu_begin() is called? Or is this just a "possible"
> thing?

In the trace from patch 3, it's called by gcmaes_crypt_by_sg() to decrypt a
packet[*] during a receive action after the kernel was interruped by the
network device.

[*] I assume it's decrypting a packet, I'm not at all familiar with the
    networking stack so it could be decrypting something else entirely.

> Because I just want to make sure that, kvm can use this flag to cover all
> preempt/softirq/(other?) cases?

Yes, TIF_FPU_NEED_LOAD is set any time its associated tasks's FPU state is
swapped out and needs to be reloaded before returning to userspace.  For
KVM, "returning to userspace" also means entering the guest or accessing
guest state.
