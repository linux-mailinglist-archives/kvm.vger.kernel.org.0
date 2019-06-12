Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B2443126
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 22:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389105AbfFLUyd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 16:54:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:36792 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbfFLUyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 16:54:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 13:54:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jun 2019 13:54:30 -0700
Date:   Wed, 12 Jun 2019 13:54:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     George Kennedy <george.kennedy@oracle.com>, joro@8bytes.org,
        pbonzini@redhat.com, mingo@redhat.com, hpa@zytor.com,
        kvm@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: kernel BUG at arch/x86/kvm/x86.c:361! on AMD CPU
Message-ID: <20190612205430.GA26320@linux.intel.com>
References: <37952f51-7687-672c-45d9-92ba418c9133@oracle.com>
 <20190612161255.GN32652@zn.tnic>
 <af0054d1-1fc8-c106-b503-ca91da5a6fee@oracle.com>
 <20190612195152.GQ32652@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612195152.GQ32652@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 12, 2019 at 09:51:52PM +0200, Borislav Petkov wrote:
> On Wed, Jun 12, 2019 at 02:45:34PM -0400, George Kennedy wrote:
> > The crash can still be reproduced with VM running Upstream 5.2.0-rc4 
> 
> That's clear.
> 
> > and host running Ubuntu on AMD CPU.
> 
> That's the important question: why can't I trigger it with 5.2.0-rc4+ as
> the host and you can with the ubuntu kernel 4.15 or so. I.e., what changed
> upstream or does the ubuntu kernel have out-of-tree stuff?
> 
> Maybe kvm folks would have a better idea. That kvm_spurious_fault thing
> is for:
> 
> /*
>  * Hardware virtualization extension instructions may fault if a
>  * reboot turns off virtualization while processes are running.
>  * Trap the fault and ignore the instruction if that happens.
>  */
> asmlinkage void kvm_spurious_fault(void);
> 
> but you're not rebooting...

The reboot thing is a red-herring.   The ____kvm_handle_fault_on_reboot()
macro suppresses faults that occur on VMX and SVM instructions while the
kernel is rebooting (CPUs need to leave VMX/SVM mode to recognize INIT),
i.e. kvm_spurious_fault() is reached when a VMX or SVM instruction faults
and we're *not* rebooting.

TL;DR: an SVM instruction is faulting unexpectedly.
