Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCE830227
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 20:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfE3SqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 14:46:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:20607 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfE3SqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 14:46:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:46:02 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 30 May 2019 11:46:02 -0700
Date:   Thu, 30 May 2019 11:46:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH] KVM: LAPIC: Do not mask the local interrupts when LAPIC
 is sw disabled
Message-ID: <20190530184602.GD23930@linux.intel.com>
References: <1558435455-233679-1-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558435455-233679-1-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 21, 2019 at 06:44:15PM +0800, Luwei Kang wrote:
> The current code will mask all the local interrupts in the local
> vector table when the LAPIC is disabled by SVR (Spurious-Interrupt
> Vector Register) "APIC Software Enable/Disable" flag (bit8).
> This may block local interrupt be delivered to target vCPU
> even if LAPIC is enabled by set SVR (bit8 == 1) after.

The current code aligns with the SDM, which states:

  Local APIC State After It Has Been Software Disabled

  When the APIC software enable/disable flag in the spurious interrupt
  vector register has been explicitly cleared (as opposed to being cleared
  during a power up or reset), the local APIC is temporarily disabled.
  The operation and response of a local APIC while in this software-
  disabled state is as follows:

    - The mask bits for all the LVT entries are set. Attempts to reset
      these bits will be ignored.
