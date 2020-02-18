Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8261B162EF2
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 19:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgBRSsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 13:48:04 -0500
Received: from mga04.intel.com ([192.55.52.120]:18818 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbgBRSsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 13:48:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 10:48:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,457,1574150400"; 
   d="scan'208";a="435949765"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 10:48:02 -0800
Date:   Tue, 18 Feb 2020 10:48:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Erwan Velu <e.velu@criteo.com>
Cc:     Erwan Velu <erwanaliasr1@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: Print "disabled by bios" only once per host
Message-ID: <20200218184802.GC28156@linux.intel.com>
References: <20200214143035.607115-1-e.velu@criteo.com>
 <20200214170508.GB20690@linux.intel.com>
 <70b4d8fa-57c0-055b-8391-4952dec32a58@criteo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70b4d8fa-57c0-055b-8391-4952dec32a58@criteo.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 05:28:49PM +0100, Erwan Velu wrote:
> On 14/02/2020 18:05, Sean Christopherson wrote:
> >This has come up before[*].  Using _once() doesn't fully solve the issue
> >when KVM is built as a module.  The spam is more than likely a userspace
> >bug, i.e. userspace is probing KVM on every CPU.
> 
> I made some progress on this.
> 
> 
> That's "/usr/bin/udevadm trigger --type=devices --action=add" the culprit.
> 
> It does echo "add" in /sys/devices/system/cpu/cpu<x>/uevent
> 
> For the each cpu, it does the 'add' which trigger the "disabled by bios"
> message from kvm_arch_init.
> 
> Note that doing a "add" on the same processor will trigger the same message
> at every "add" event.
> 
> 
> So I tried the patch of using pr_err_once() instead of printk() and the
> behavior is fine : despite the number of "add" generated, there is a single
> line being printed out.
> 
> Without the patch, every "add" generates the "disabled by bios" message.

That's a sort of unintentional side effect of KVM being split into two
modules, kvm and kvm_{intel,amd}.  E.g. if userspace did 'rmmod kvm' on
failure of 'modprobe kvm_intel' then using _*once() would be ineffective.
 
> So the question is : do we want to handle the case where a possible bios
> missed the configuration of some cores ?

That's a question for AMD/SVM.  Starting with kernel 5.6, Intel/VMX checks
for BIOS enabling on all CPUs.

That being said, checking for correct BIOS configuration on all CPUs is
orthogonal to this print statement issue.  Probing kvm_intel on every CPU
doesn't do anything to address a misoncifgured BIOS, e.g. if VMX/SVM is
fully supported on CPU0 then additional probes of kvm_{intel,amd} are nops,
they don't actually check for support on other CPUs.

> If no, then the patch is fine and could be submitted. I don't see the need
> of printing this message at every call as it pollute the kernel log.
> 
> If yes, then we need to keep a trace of the number of enabled/disabled cores
> so we can report a mismatch. As this message seems printed per cpu, that
> would kind of mean a global variable right ?
>
> What are your recommendations on this ?

Fix userspace to only do the "add" on one CPU.

Changing kvm_arch_init() to use pr_err_once() for the disabled_by_bios()
case "works", but it's effectively a hack to workaround a flawed userspace.
