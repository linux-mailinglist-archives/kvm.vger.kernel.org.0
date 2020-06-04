Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7158A1EE88D
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgFDQ1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729540AbgFDQ1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 12:27:37 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8494B206E6;
        Thu,  4 Jun 2020 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591288056;
        bh=S/InZdO6ZGDXoUUOdS8+reiil89ywTIZT3qwWyRGzdA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MxtQ4iIJUJQsEL4elLYGFqRxB2hbDMaW0p6AfFk7rmu5mLrBe+x17urAdIhyJe7XR
         dZ6pMY78PGmOHv7ZBPgDOY7IhlTHSPZGZ+jc3dmu2mDG9esPXot2mFXcP6Ga2usK/5
         ZSNMQtXae0NVKUtMJm+rQ+sK3U4tFOnxhRw12fHA=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jgsiM-000IWN-U1; Thu, 04 Jun 2020 17:27:35 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 04 Jun 2020 17:27:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        kernel-team@android.com, will@kernel.org,
        Jun Nakajima <jun.nakajima@intel.com>
Subject: Re: [RFC 00/16] KVM protected memory extension
In-Reply-To: <20200604154835.GE30223@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200604161523.39962919@why> <20200604154835.GE30223@linux.intel.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <cd292393f8e45407b2754efbaf89aa70@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, kirill@shutemov.name, dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, rientjes@google.com, aarcange@redhat.com, keescook@chromium.org, wad@chromium.org, rick.p.edgecombe@intel.com, andi.kleen@intel.com, x86@kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com, kernel-team@android.com, will@kernel.org, jun.nakajima@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2020-06-04 16:48, Sean Christopherson wrote:
> +Jun
> 
> On Thu, Jun 04, 2020 at 04:15:23PM +0100, Marc Zyngier wrote:
>> Hi Kirill,
>> 
>> Thanks for this.
>> 
>> On Fri, 22 May 2020 15:51:58 +0300
>> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>> 
>> > == Background / Problem ==
>> >
>> > There are a number of hardware features (MKTME, SEV) which protect guest
>> > memory from some unauthorized host access. The patchset proposes a purely
>> > software feature that mitigates some of the same host-side read-only
>> > attacks.
>> >
>> >
>> > == What does this set mitigate? ==
>> >
>> >  - Host kernel ”accidental” access to guest data (think speculation)
>> >
>> >  - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
>> >
>> >  - Host userspace access to guest data (compromised qemu)
>> >
>> > == What does this set NOT mitigate? ==
>> >
>> >  - Full host kernel compromise.  Kernel will just map the pages again.
>> >
>> >  - Hardware attacks
>> 
>> Just as a heads up, we (the Android kernel team) are currently
>> involved in something pretty similar for KVM/arm64 in order to bring
>> some level of confidentiality to guests.
>> 
>> The main idea is to de-privilege the host kernel by wrapping it in its
>> own nested set of page tables which allows us to remove memory
>> allocated to guests on a per-page basis. The core hypervisor runs more
>> or less independently at its own privilege level. It still is KVM
>> though, as we don't intend to reinvent the wheel.
>> 
>> Will has written a much more lingo-heavy description here:
>> https://lore.kernel.org/kvmarm/20200327165935.GA8048@willie-the-truck/
> 
> Pardon my arm64 ignorance...
> 
> IIUC, in this mode, the host kernel runs at EL1?  And to switch to a 
> guest
> it has to bounce through EL2, which is KVM, or at least a chunk of KVM?
> I assume the EL1->EL2->EL1 switch is done by trapping an exception of 
> some
> form?
> 
> If all of the above are "yes", does KVM already have the necessary 
> logic to
> perform the EL1->EL2->EL1 switches, or is that being added as part of 
> the
> de-privileging effort?

KVM already handles the EL1->EL2->EL1 madness, meaning that from
an exception level perspective, the host kernel is already a guest.
It's just that this guest can directly change the hypervisor's text,
its page tables, and muck with about everything else.

De-privileging the memory access to non host EL1 memory is where the
ongoing effort is.

          M.
-- 
Jazz is not dead. It just smells funny...
