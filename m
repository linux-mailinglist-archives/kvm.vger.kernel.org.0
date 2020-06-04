Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68571EE7D4
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 17:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbgFDPdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 11:33:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60903 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729557AbgFDPdc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 11:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591284810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EkTe6msyKKBujkL/w9LaHM/UruPUqU2iBowLUPq5X2I=;
        b=Jc6HTWdiwzE/ayp56Kr0mS5XVW+WLZLBCHL0lE4HjkjHroyaPay8iKXOuPCMIG0gyWflJw
        3GfQZ+FhFsuBLmST25tbaf9UCDkZ97LK6jVVql5NyXDu6kGC6/xbfEWbvhIQvZbVt1KNQi
        VWFVu0OtUJZML3U67MhX4Wg5syTc+mE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-WVuphH4hOSe7bqhGkdhgZQ-1; Thu, 04 Jun 2020 11:33:28 -0400
X-MC-Unique: WVuphH4hOSe7bqhGkdhgZQ-1
Received: by mail-ed1-f72.google.com with SMTP id i93so2842856edi.4
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 08:33:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EkTe6msyKKBujkL/w9LaHM/UruPUqU2iBowLUPq5X2I=;
        b=FZZSokH8ItqeodDpr2xppPRrptbOml85wu/GhnTjlZzsRjjnBkwqMPJYeYWYefo3vg
         JmFcObaygPk9pXbr7TU1y4dAPSHRQlbgaQuykRrBYXbsKogCoE3zqTezwkH8MnYCjfxJ
         4+R9AIuSNIc/ITXB83C6hnv4FbLAOrO7eI8fi0iDKeXC8fDcjbMmPJhQk//P4Y3Wh7jq
         ogpBEIyqYnx4rGRiJwv/qwiAQBjwHusFfksNXO08rXefNWUkPFhD6bRiAqrRclQovYoy
         8eHg1of2ztUZSXMJawIlqPXDMePgakhNT/CRp9BObzoD5oLc7tRiUMSNKLAFnNiHEhnE
         GcTA==
X-Gm-Message-State: AOAM531CpAdz/OD6d7DjmmRTDMoiocvzBgn44E1nW/EIpmiUpxnwbBpR
        bNL8B8qVAZLlij5bfyZVLMqLdlGwL4jvMXObHq8N3qYES5B6gBWknog+xYtTX+Ph6z8Z8twI8MM
        jOomWJPlHxkZt
X-Received: by 2002:a17:906:138b:: with SMTP id f11mr4304825ejc.288.1591284807155;
        Thu, 04 Jun 2020 08:33:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6a+lge9RsDBjzyDM13/1DPTnf2dnUi/mD38OThDFZofvrtupLARjTGRzd9kQr1Mej5yW71A==
X-Received: by 2002:a17:906:138b:: with SMTP id f11mr4304812ejc.288.1591284806925;
        Thu, 04 Jun 2020 08:33:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b24sm2638918edw.70.2020.06.04.08.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 08:33:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Inject #GP when nested_vmx_get_vmptr() fails to read guest memory
In-Reply-To: <20200604145357.GA30223@linux.intel.com>
References: <20200604143158.484651-1-vkuznets@redhat.com> <da7acd6f-204d-70e2-52aa-915a4d9163ef@redhat.com> <20200604145357.GA30223@linux.intel.com>
Date:   Thu, 04 Jun 2020 17:33:25 +0200
Message-ID: <87k10meth6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, Jun 04, 2020 at 04:40:52PM +0200, Paolo Bonzini wrote:
>> On 04/06/20 16:31, Vitaly Kuznetsov wrote:
>
> ...
>
>> > KVM could've handled the request correctly by going to userspace and
>> > performing I/O but there doesn't seem to be a good need for such requests
>> > in the first place. Sane guests should not call VMXON/VMPTRLD/VMCLEAR with
>> > anything but normal memory. Just inject #GP to find insane ones.
>> > 

...

>> 
>> looks good but we need to do the same in handle_vmread, handle_vmwrite,
>> handle_invept and handle_invvpid.  Which probably means adding something
>> like nested_inject_emulation_fault to commonize the inner "if".
>
> Can we just kill the guest already instead of throwing more hacks at this
> and hoping something sticks?  We already have one in
> kvm_write_guest_virt_system...
>
>   commit 541ab2aeb28251bf7135c7961f3a6080eebcc705
>   Author: Fuqian Huang <huangfq.daxian@gmail.com>
>   Date:   Thu Sep 12 12:18:17 2019 +0800
>
>     KVM: x86: work around leak of uninitialized stack contents
>

Oh I see...

[...]

Let's get back to 'vm_bugged' idea then? 

https://lore.kernel.org/kvm/87muadnn1t.fsf@vitty.brq.redhat.com/

-- 
Vitaly

