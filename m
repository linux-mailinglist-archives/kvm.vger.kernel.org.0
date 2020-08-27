Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819EF2543A7
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 12:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgH0KX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 06:23:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34097 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726093AbgH0KXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 06:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598523803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+kLy6tLm5kHK6ubmxV4JMC+Ts5+1/ugqr6zlczEOapo=;
        b=ddkHhs8USk7aO6x5hxM8tUkQiDO64nIFQZd9dcE9BsGs9rLnSJbCfrfaF1a0mBURxZScY0
        6m2G0X5vxJuN1nx7W5afqS0v54Cf9ZGFrkbOQNUedGhsYVaRGKLoGxnOKwESoO/bXiraXS
        +pQZeDUv0ZS5/JY/SxqNLhgVA2VsCNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-aVScZKfANIKVFLxVfpsGkQ-1; Thu, 27 Aug 2020 06:23:20 -0400
X-MC-Unique: aVScZKfANIKVFLxVfpsGkQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D6AD800683;
        Thu, 27 Aug 2020 10:23:18 +0000 (UTC)
Received: from starship (unknown [10.35.206.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92A581944D;
        Thu, 27 Aug 2020 10:23:13 +0000 (UTC)
Message-ID: <cb1b39bc000d96da154d9e6132ee88b448a27c59.camel@redhat.com>
Subject: Re: [PATCH v2 4/7] KVM: x86: allow kvm_x86_ops.set_efer to return a
 value
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 27 Aug 2020 13:23:12 +0300
In-Reply-To: <20200821004350.GB13886@sjchrist-ice>
References: <20200820133339.372823-1-mlevitsk@redhat.com>
         <20200820133339.372823-5-mlevitsk@redhat.com>
         <CALMp9eRNLjj5cs1xj44WVRoKK0ZrcGXn7ffdH+bEeDHkLE9nSA@mail.gmail.com>
         <20200821004350.GB13886@sjchrist-ice>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 17:43 -0700, Sean Christopherson wrote:
> On Thu, Aug 20, 2020 at 02:43:56PM -0700, Jim Mattson wrote:
> > On Thu, Aug 20, 2020 at 6:34 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > This will be used later to return an error when setting this msr fails.
> > > 
> > > For VMX, it already has an error condition when EFER is
> > > not in the shared MSR list, so return an error in this case.
> > > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -1471,7 +1471,8 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >         efer &= ~EFER_LMA;
> > >         efer |= vcpu->arch.efer & EFER_LMA;
> > > 
> > > -       kvm_x86_ops.set_efer(vcpu, efer);
> > > +       if (kvm_x86_ops.set_efer(vcpu, efer))
> > > +               return 1;
> > 
> > This seems like a userspace ABI change to me. Previously, it looks
> > like userspace could always use KVM_SET_MSRS to set MSR_EFER to 0 or
> > EFER_SCE, and it would always succeed. Now, it looks like it will fail
> > on CPUs that don't support EFER in hardware. (Perhaps it should fail,
> > but it didn't before, AFAICT.)
> 
> KVM emulates SYSCALL, presumably that also works when EFER doesn't exist in
> hardware.

This is a fair point.
How about checking the return value only when '!msr_info->host_initiated' in set_efer?

This way userspace initiated EFER write will work as it did before,
but guest initiated write will fail 
(and set_efer already checks and fails for many cases)

I also digged a bit around the failure check in VMX, the 'find_msr_entry(vmx, MSR_EFER);'
This one if I am not mistaken will only fail when host doesn't support EFER.
I don't mind ignoring this error as well as it was before.

> 
> The above also adds weirdness to nested VMX as vmx_set_efer() simply can't
> fail.
It will now fail on non 64 bit Intel CPUs that support VMX. I do think that
we had these for a while. As I said I'll return 0 when find_msr_entry fails,
thus return this behavior as it was on Intel.

Best regards,
	Maxim Levitsky


