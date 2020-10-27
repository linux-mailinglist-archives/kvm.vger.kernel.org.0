Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F7929CA37
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 21:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372950AbgJ0Ubh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 16:31:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S372938AbgJ0Ubg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Oct 2020 16:31:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603830695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jw2I23iwBY99w0/c3MnXeZh6i5zZp8WwMZqR6Jv0Uw=;
        b=eUOElFqm2VeCd5um4jI8pbtsQuynjgO/DwyV9U5+fTeEzErRgZVGJb1tL2Au8lsanRu6ji
        R7lfi5fJ7SjUb82hJuJH9ZlEpc8MMPm5+ox1s5u6NKwnlsZlGuE3BDnIQHHnra9yRYnR1W
        lNhu2BIEbVEMLdSBrATmc1g1v73vvJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-pEKfTLzFM5CZIQZ1fdHpcA-1; Tue, 27 Oct 2020 16:31:33 -0400
X-MC-Unique: pEKfTLzFM5CZIQZ1fdHpcA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB33D1868434;
        Tue, 27 Oct 2020 20:31:31 +0000 (UTC)
Received: from ovpn-66-71.rdu2.redhat.com (ovpn-66-71.rdu2.redhat.com [10.10.66.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00B8F60C07;
        Tue, 27 Oct 2020 20:31:27 +0000 (UTC)
Message-ID: <c0d5290b9e2dfc7692ed5575babf73092156ca90.camel@redhat.com>
Subject: Re: [PATCH v6 2/4] KVM: x86: report negative values from wrmsr
 emulation to userspace
From:   Qian Cai <cai@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 27 Oct 2020 16:31:26 -0400
In-Reply-To: <849d7acb00b3dadc3fc7db1e574c03dc74a06270.camel@redhat.com>
References: <20200922211025.175547-1-mlevitsk@redhat.com>
         <20200922211025.175547-3-mlevitsk@redhat.com>
         <849d7acb00b3dadc3fc7db1e574c03dc74a06270.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-10-26 at 15:40 -0400, Qian Cai wrote:
> On Wed, 2020-09-23 at 00:10 +0300, Maxim Levitsky wrote:
> > This will allow the KVM to report such errors (e.g -ENOMEM)
> > to the userspace.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Reverting this and its dependency:
> 
> 72f211ecaa80 KVM: x86: allow kvm_x86_ops.set_efer to return an error value
> 
> on the top of linux-next (they have also unfortunately merged into the
> mainline
> at the same time) fixed an issue that a simple Intel KVM guest is unable to
> boot
> below.

So I debug this a bit more. This also breaks nested virt (VMX). We have here:

[  345.504403] kvm [1491]: vcpu0 unhandled rdmsr: 0x4e data 0x0
[  345.758560] kvm [1491]: vcpu0 unhandled rdmsr: 0x1c9 data 0x0
[  345.758594] kvm [1491]: vcpu0 unhandled rdmsr: 0x1a6 data 0x0
[  345.758619] kvm [1491]: vcpu0 unhandled rdmsr: 0x1a7 data 0x0
[  345.758644] kvm [1491]: vcpu0 unhandled rdmsr: 0x3f6 data 0x0
[  345.951601] kvm [1493]: vcpu1 unhandled rdmsr: 0x4e data 0x0
[  351.857036] kvm [1493]: vcpu1 unhandled wrmsr: 0xc90 data 0xfffff

After this commit, -ENOENT is returned to vcpu_enter_guest() causes the
userspace to abort.

kvm_msr_ignored_check()
  kvm_set_msr()
    kvm_emulate_wrmsr()
      vmx_handle_exit()
        vcpu_enter_guest()

Something like below will unbreak the userspace, but does anyone has a better
idea?

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1748,7 +1748,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
                return 0;
 
        /* Signal all other negative errors to userspace */
-       if (r < 0)
+       if (r < 0 && r != -ENOENT)
                return r;
 
        /* MSR write failed? Inject a #GP */

