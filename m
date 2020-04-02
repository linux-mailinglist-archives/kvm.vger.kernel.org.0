Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376BB19CD5C
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 01:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390120AbgDBXIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 19:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732600AbgDBXIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 19:08:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF1092073B;
        Thu,  2 Apr 2020 23:08:41 +0000 (UTC)
Date:   Thu, 2 Apr 2020 19:08:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86 <x86@kernel.org>, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Covelli <dcovelli@vmware.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle
 split lock #AC in guest
Message-ID: <20200402190839.00315012@gandalf.local.home>
In-Reply-To: <08D90BEB-89F6-4D94-8C2E-A21E43646938@vmware.com>
References: <20200402124205.334622628@linutronix.de>
        <20200402155554.27705-1-sean.j.christopherson@intel.com>
        <20200402155554.27705-4-sean.j.christopherson@intel.com>
        <87sghln6tr.fsf@nanos.tec.linutronix.de>
        <20200402174023.GI13879@linux.intel.com>
        <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
        <20200402205109.GM13879@linux.intel.com>
        <87zhbtle15.fsf@nanos.tec.linutronix.de>
        <08D90BEB-89F6-4D94-8C2E-A21E43646938@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Apr 2020 22:40:03 +0000
Nadav Amit <namit@vmware.com> wrote:

> > On Apr 2, 2020, at 3:27 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> >  As I just verified, it's possible to load the vmware module parallel
> >  to the KVM/VMX one.
> > 
> > So either we deal with it in some way or just decide that SLD and HV
> > modules which do not have the MOD_INFO(sld_safe) magic cannot be loaded
> > when SLD is enabled on the host. I'm fine with the latter :)
> > 
> > What a mess.  
> 
> [ +Doug ]
> 
> Just to communicate the information that was given to me: we do intend to
> fix the SLD issue in VMware and if needed to release a minor version that
> addresses it. Having said that, there are other hypervisors, such as
> virtualbox or jailhouse, which would have a similar issue.

If we go the approach of not letting VM modules load if it doesn't have the
sld_safe flag set, how is this different than a VM module not loading due
to kabi breakage?

If we prevent it from loading (and keeping from having to go into this
inconsistent state that Thomas described), it would encourage people to get
the latest modules, and the maintainers of said modules motivation to
update them.

-- Steve
