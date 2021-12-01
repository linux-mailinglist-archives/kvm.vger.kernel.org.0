Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A836C465722
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 21:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241054AbhLAUcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 15:32:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:48255 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239841AbhLAUcB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 15:32:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="217242266"
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="217242266"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 12:28:35 -0800
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="460171745"
Received: from pkumar17-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.62.247])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 12:28:31 -0800
Date:   Thu, 2 Dec 2021 09:28:29 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/59] KVM: X86: TDX support
Message-Id: <20211202092829.9c06c89ea375c9d9790e36b2@intel.com>
In-Reply-To: <YafNwoPumWQ/77Q6@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
        <YaZyyNMY80uVi5YA@google.com>
        <20211202022227.acc0b613e6c483be4736c196@intel.com>
        <20211201190856.GA1166703@private.email.ne.jp>
        <YafNwoPumWQ/77Q6@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
> > Anyway The plan is what Kai said.  The code will reside in the x86 common
> > directory instead of kvm.
> 
> But what's the plan at a higher level?  Will the kernel load the ACM or is that
> done by firmware?  If it's done by firmware, which entity is responsibile for
> loading the TDX module?  If firmware loads the module, what's the plan for
> upgrading the module without a reboot?  When will the kernel initialize the
> module, regardless of who loads it?

The UEFI loads both ACM and TDX module before booting into kernel by using UEFI
tool.  The runtime update is pushed out for future support.  One goal of
this is to reduce the code size so that it can be reviewed more easily and
quickly.

And yes kernel will initialize the TDX module.  The direction we are heading is
to allow to defer TDX module initialization when TDX is truly needed, i.e.
When KVM is loaded with TDX support, or first TD is created.  The code will
basically still reside in host kernel, provided as functions, etc.  And at first
stage, KVM will call those functions to initialize TDX when needed.

The advantage of this approach is it provides more flexibility: the TDX module
initialization code can be reused by future TDX runtime update, etc.  And with
only initializing TDX in KVM, the host kernel doesn't need to handle entering
VMX operation, etc.  It can be introduced later when needed.

> 
> All of those unanswered questions make it nigh impossible to review the KVM
> support because the code organization and APIs provided will differ based on how
> the kernel handles loading and initializing the TDX module.

I think theoretically loading/initializing module should be quite independent
from KVM series, but yes in practice the APIs matter, but I also don't expect
this will reduce the ability to review KVM series a lot as RFC.

Anyway sending out host kernel patches is our top priority now and we are
trying to do asap.
