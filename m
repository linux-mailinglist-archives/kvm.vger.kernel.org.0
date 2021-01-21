Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5542FF13B
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 18:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388318AbhAUQ7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 11:59:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387692AbhAUQ7o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 11:59:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611248291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t67tiH17JFwshVtcb2jS0Q6ThwFXTBpwZjCAW7lUaLA=;
        b=RTwK3iz4pph2dPzP3SdcbUmqt6QyK3NmIJvo82Y3o8IyrZkM3/uajUyOcEb/ymBKhWWZjD
        bWIPuRJYoIbjMmd3EgYLCV6VWcQ21gV80efuQW8cCzdEdQDeEY4s5VqgxjLuZW55W9nutj
        D9ohGQOxk2J+6FswhfeQrzHTeS032c8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-S_mwAshlPbGe77FxRuZQtA-1; Thu, 21 Jan 2021 11:58:09 -0500
X-MC-Unique: S_mwAshlPbGe77FxRuZQtA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A47980DDE0;
        Thu, 21 Jan 2021 16:58:08 +0000 (UTC)
Received: from starship (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88CC539A5F;
        Thu, 21 Jan 2021 16:58:04 +0000 (UTC)
Message-ID: <7f9f2fa0a6246573afab18822829120389352ad3.camel@redhat.com>
Subject: Re: [PATCH v2 2/3] KVM: nVMX: add kvm_nested_vmlaunch_resume
 tracepoint
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Jan 2021 18:58:03 +0200
In-Reply-To: <18c386f2-a588-6324-fcde-d13b66f66d4f@redhat.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
         <20210114205449.8715-3-mlevitsk@redhat.com> <YADeT8+fssKw3SSi@google.com>
         <18c386f2-a588-6324-fcde-d13b66f66d4f@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-01-15 at 14:48 +0100, Paolo Bonzini wrote:
> On 15/01/21 01:14, Sean Christopherson wrote:
> > > +	trace_kvm_nested_vmlaunch_resume(kvm_rip_read(vcpu),
> > Hmm, won't this RIP be wrong for the migration case?  I.e. it'll be L2, not L1
> > as is the case for the "true" nested VM-Enter path.

Actually in this case, the initial RIP of 0x000000000000fff0 will be printed
which isn't that bad.

A tracepoint in nested state load function would be very nice to add
to mark this explicitly. I'll do this later.

> 
> It will be the previous RIP---might as well be 0xfffffff0 depending on 
> what userspace does.  I don't think you can do much better than that, 
> using vmcs12->host_rip would be confusing in the SMM case.
> 
> > > +					 vmx->nested.current_vmptr,
> > > +					 vmcs12->guest_rip,
> > > +					 vmcs12->vm_entry_intr_info_field);
> > The placement is a bit funky.  I assume you put it here so that calls from
> > vmx_set_nested_state() also get traced.  But, that also means
> > vmx_pre_leave_smm() will get traced, and it also creates some weirdness where
> > some nested VM-Enters that VM-Fail will get traced, but others will not.
> > 
> > Tracing vmx_pre_leave_smm() isn't necessarily bad, but it could be confusing,
> > especially if the debugger looks up the RIP and sees RSM.  Ditto for the
> > migration case.
> 
> Actually tracing vmx_pre_leave_smm() is good, and pointing to RSM makes 
> sense so I'm not worried about that.
> 
> Paolo
> 

I agree with that and indeed this was my intention.

In fact I will change the svm's tracepoint to behave the same way
in the next patch series (I'll move it to enter_svm_guest_mode).

(When I wrote this patch I somehow thought that this is what SVM already does).

Best regards,
	Maxim Levitsky



