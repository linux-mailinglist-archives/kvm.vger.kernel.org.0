Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0DF719CD63
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 01:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389857AbgDBXSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 19:18:15 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:44339 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387919AbgDBXSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 19:18:15 -0400
Received: by mail-il1-f194.google.com with SMTP id j69so5390490ila.11
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 16:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=39dgXP5mbIg8YapOVVddrrbM7IoqVqxM5hwBU1j8EUs=;
        b=dwo1sQwWh9cHbBQrmkixhDQuRMc3S2WNAcFZSWZFwhrPENB7yJ8Aq4pl4Vp+quJApm
         tGXKNwBWAP4ca9T0JhdQkFsnO1j30wqpkZYa917k1wo4pKEhpsSkMBdwYbmdEJsfO+x7
         vOsCnA5Wpv4sgcy/5xdAvsA7ATWmYV1jGglfh1J9vX7LZjrsBB1/XU87OunvRWysb9ut
         oozz4ur7HMDbGeGlFPGOVADtBfQCen7XgIv3BnV7nSijerinrdf8PXH2yYruik9EomGS
         aeMauAp3DXKGlHJt80YjBCKXrlX2hEn4/0WcoBaT/l3Vt3x6j+P6rKAqypraG1OBBmTs
         NJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=39dgXP5mbIg8YapOVVddrrbM7IoqVqxM5hwBU1j8EUs=;
        b=Q3epjBMStZ5JhJfRzkBUyqxOT99bnhUyvVY95Ih+ZQS+N3ZGfcHKCv7XzhYghrSPSB
         uXpEwrR1Kse9jsBRfRlitAUaxKf3Ig9D0h7JQqAa/XGoLRygRLcxMSxP3nyUVdoZ6kMU
         nK240TztKrqj6XZe5O9CwBmbMCWCnM2gwBo6gyITnfp6wOcKGS+Aff1QnYuIEbtAPF9i
         QNXvxUnqzJmth7471CLPwwrov9HMnavT4gHBO5/AzHATAX+Ti4JVLbC8bIGSKo753Rn+
         HJ7iOI/wWuU8wVqcnaaXlycCPn5PkZaM6LlswwyOp/bPUFdbPZCjxQOtHq+SzBjKLoar
         uHtA==
X-Gm-Message-State: AGi0PubupD/qhgXqjQixEBoHGJoyaPCt+N2Lbp6q2atQHDMwDaNrzo0W
        0wOaOG3elUqGxet9nQMK4Af8uGeKDhYoOYMrtkfNBQ==
X-Google-Smtp-Source: APiQypL/lGLPx7YT86ux57tULDVK457ntFa+LYEm+kpoKEXkiy1gvSvDDTtl7qb2LZN4VOY/qxG+D1B9NtX31AOZhFA=
X-Received: by 2002:a92:5fdb:: with SMTP id i88mr5930879ill.118.1585869492403;
 Thu, 02 Apr 2020 16:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200402124205.334622628@linutronix.de> <20200402155554.27705-1-sean.j.christopherson@intel.com>
 <20200402155554.27705-4-sean.j.christopherson@intel.com> <87sghln6tr.fsf@nanos.tec.linutronix.de>
 <20200402174023.GI13879@linux.intel.com> <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
 <20200402205109.GM13879@linux.intel.com> <87zhbtle15.fsf@nanos.tec.linutronix.de>
 <08D90BEB-89F6-4D94-8C2E-A21E43646938@vmware.com> <20200402190839.00315012@gandalf.local.home>
 <alpine.DEB.2.21.2004021613110.10453@xps-7390>
In-Reply-To: <alpine.DEB.2.21.2004021613110.10453@xps-7390>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 2 Apr 2020 16:18:01 -0700
Message-ID: <CALMp9eSgKQW=rVnBq26cjNfcDXv2BWeA47oHM5pyQke7RpGykw@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle
 split lock #AC in guest
To:     "Kenneth R. Crudup" <kenny@panix.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Nadav Amit <namit@vmware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86 <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Covelli <dcovelli@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 2, 2020 at 4:16 PM Kenneth R. Crudup <kenny@panix.com> wrote:
>
>
> On Thu, 2 Apr 2020, Steven Rostedt wrote:
>
> > If we go the approach of not letting VM modules load if it doesn't have the
> > sld_safe flag set, how is this different than a VM module not loading due
> > to kabi breakage?
>
> Why not a compromise: if such a module is attempted to be loaded, print up
> a message saying something akin to "turn the parameter 'split_lock_detect'
> off" as we reject loading it- and if we see that we've booted with it off
> just splat a WARN_ON() if someone tries to load such modules?

What modules are we talking about? I thought we were discussing L1
hypervisors, which are just binary blobs. The only modules at the L0
level are kvm and kvm_intel.
