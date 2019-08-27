Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81539F2F2
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 21:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbfH0TIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 15:08:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbfH0TIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 15:08:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72FD418C8917;
        Tue, 27 Aug 2019 19:08:14 +0000 (UTC)
Received: from flask (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id A30AE600D1;
        Tue, 27 Aug 2019 19:08:11 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Tue, 27 Aug 2019 21:08:10 +0200
Date:   Tue, 27 Aug 2019 21:08:10 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: x86: Only print persistent reasons for kvm disabled
 once
Message-ID: <20190827190810.GA21275@flask>
References: <20190826182320.9089-1-tony.luck@intel.com>
 <87imqjm8b4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imqjm8b4.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 27 Aug 2019 19:08:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-08-27 08:27+0200, Vitaly Kuznetsov:
> Tony Luck <tony.luck@intel.com> writes:
> 
> > When I boot my server I'm treated to a console log with:
> >
> > [   40.520510] kvm: disabled by bios
> > [   40.551234] kvm: disabled by bios
> > [   40.607987] kvm: disabled by bios
> > [   40.659701] kvm: disabled by bios
> > [   40.691224] kvm: disabled by bios
> > [   40.718786] kvm: disabled by bios
> > [   40.750122] kvm: disabled by bios
> > [   40.797170] kvm: disabled by bios
> > [   40.828408] kvm: disabled by bios
> >
> >  ... many, many more lines, one for every logical CPU
> 
> (If I didn't miss anything) we have the following code:
> 
> __init vmx_init()
>         kvm_init();
>             kvm_arch_init()
> 
> and we bail on first error so there should be only 1 message per module
> load attempt. The question I have is who (and why) is trying to load
> kvm-intel (or kvm-amd which is not any different) for each CPU? Is it
> udev? Can this be changed?

I agree that this is a highly suspicious behavior.

It would be really helpful if we found out what is causing it.
So far, this patch seems to be working around a userspace bug.

> In particular, I'm worried about eVMCS enablement in vmx_init(), we will
> also get a bunch of "KVM: vmx: using Hyper-V Enlightened VMCS" messages
> if the consequent kvm_arch_init() fails.

And we can't get rid of this through the printk_once trick, because this
code lives in kvm_intel module and therefore gets unloaded on every
failure.

I am also not inclined to apply the patch as we will likely merge the
kvm and kvm_{svm,intel} modules in the future to take full advantage of
link time optimizations and this patch would stop working after that.

Thanks.
