Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478524713FE
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 14:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhLKN3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 08:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhLKN3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 08:29:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60F0C061714;
        Sat, 11 Dec 2021 05:29:13 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639229352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KVQaZKg6wzwR7P8DKR7q2rQbyL3SCRYJm4Gzt7C/tXo=;
        b=wpxIsy1yPIhdHPzacri8eiRf6aDbvVYvB0vChGmAcoPb4aFdvsRRAkoJA507OzW+esPtQc
        KCVbIe6Lbp/Hqsy8s2H1fqH3Pb4fA7Z3K3/H7kJQLG3BS1y511tauWZTRMJ98ZdvxgtohR
        1IaeQFy3zXL46IBnsXNsHwrJj15+yOxhRFSAft8zbTIpCdAvSaN8NybY/1Drl2VUIxPK5v
        0ZoKoqKIUOsr3GU4pOp+dQh3bQNDDhBucbMOZFxrbrTyR0q4+8USPczBBU8x3NqIUREZ97
        pMpv3mYlRjLLj9/k3Xfz4Fkost0tpYPoBoOPRJbTmkjqGmi1IB2+ehfhg63Q9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639229352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KVQaZKg6wzwR7P8DKR7q2rQbyL3SCRYJm4Gzt7C/tXo=;
        b=K7/JsHAuvl0el3uQDn5cUCEDQ/hecgNx5WTSlNPyTk3yNCSHXB7bmkebuBTJUx5RxFzxvu
        EhEQfowyiEKH3mAg==
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
In-Reply-To: <BN9PR11MB5276DF25E38EE7C4F4D29F288C729@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com> <87pmq4vw54.ffs@tglx>
 <BN9PR11MB5276DF25E38EE7C4F4D29F288C729@BN9PR11MB5276.namprd11.prod.outlook.com>
Date:   Sat, 11 Dec 2021 14:29:11 +0100
Message-ID: <87zgp7uv6g.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kevin,

On Sat, Dec 11 2021 at 03:07, Kevin Tian wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> #NM in the guest is slow path, right? So why are you trying to optimize
>> for it?
>
> This is really good information. The current logic is obviously
> based on the assumption that #NM is frequently triggered.

More context.

When an application want's to use AMX, it invokes the prctl() which
grants permission. If permission is granted then still the kernel FPU
state buffers are default size and XFD is armed.

When a thread of that process issues the first AMX (tile) instruction,
then #NM is raised.

The #NM handler does:

    1) Read MSR_XFD_ERR. If 0, goto regular #NM

    2) Write MSR_XFD_ERR to 0

    3) Check whether the process has permission granted. If not,
       raise SIGILL and return.

    4) Allocate and install a larger FPU state buffer for the task.
       If allocation fails, raise SIGSEGV and return.

    5) Disarm XFD for that task

That means one thread takes at max. one AMX/XFD related #NM during its
lifetime, which means two VMEXITs.

If there are other XFD controlled facilities in the future, then it will
be NR_USED_XFD_CONTROLLED_FACILITIES * 2 VMEXITs per thread which uses
them. Not the end of the world either.

Looking at the targeted application space it's pretty unlikely that
tasks which utilize AMX are going to be so short lived that the overhead
of these VMEXITs really matters.

This of course can be revisited when there is a sane use case, but
optimizing for it prematurely does not buy us anything else than
pointless complexity.

>> The straight forward solution to this is:
>> 
>>     1) Trap #NM and MSR_XFD_ERR write
>
> and #NM vmexit handler should be called in kvm_x86_handle_exit_irqoff()
> before preemption is enabled, otherwise there is still a small window
> where MSR_XFD_ERR might be clobbered after preemption enable and
> before #NM handler is actually called.

Yes.

Thanks,

        tglx

