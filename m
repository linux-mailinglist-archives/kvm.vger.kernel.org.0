Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0975F2847ED
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 09:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgJFHyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 03:54:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726789AbgJFHyT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 03:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601970857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CqPUw39/jXIA7We8BHxAVU+vFUTTd1iP9nplWmg+lMc=;
        b=B0gnlI3VYspVEVQYEiw4ciq4S53JfCNcJv6M+dcyUMvttLOhVmCLfg+4BIBZ98zxD+o/pG
        dxwV2+mIYZlJpm1BE/Z4BVBHnQD7+u3NF8XBI1Q5kRD4JXfYZPr7+hhJ2BgjQw4cqL0I0T
        1OOJ1sh8YP8bWX5JMoxqe8SMeYO2F8A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-ynfkRJJaPSO2i5ee4BNcmg-1; Tue, 06 Oct 2020 03:54:13 -0400
X-MC-Unique: ynfkRJJaPSO2i5ee4BNcmg-1
Received: by mail-ed1-f71.google.com with SMTP id y8so3152435edj.5
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 00:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CqPUw39/jXIA7We8BHxAVU+vFUTTd1iP9nplWmg+lMc=;
        b=Gj0PivR7R+QPPauFdcsR6K98RPgVEhMWxDkmjx1Z7gPVTWuM22Ywxid93eogwNw6uU
         vDVFkfan8fbutAtVx2dJRdQY/xNPCK2ON054p04jIcscDnkfvXJMsyXXqzIrT8wwHvFN
         FC1gcJpmtz+2ka3mmYAvP9KfOr/063i2c7MzdUQWxSJzSodtGDyqejzULVJlX94c9KrP
         KSJHI3pvJFOUZR4cr+dh8JQj0cUuaBBQ8V0PDuxFgkKUXp+1cPO3tdYNZ/C1T7eexBYm
         9yaC3UbgaOc3IIRpmfdOYtL+6c96l68LapGMnJZys3zpkILw5r8EGZuupLyvuraFg+an
         GSfA==
X-Gm-Message-State: AOAM531x3nDhQugAwY+1iiWdbw7rtJ6XcHgnG9maj1rMpF4NsHOvdxfK
        BY5wBsKC93q8dRxFpECttvXVMkQL9uQcJSeF9avxa8QoaJplMfMQFpLzjK/evZ3wsJXx5kVHqov
        M4juvxNLvtI52
X-Received: by 2002:a17:906:7e53:: with SMTP id z19mr3818613ejr.334.1601970850390;
        Tue, 06 Oct 2020 00:54:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTcIIL/npOIZSASW0C84APBzE5abGizc6OTd93C3idQkS/1aVBcFnt7XcOnzD7t6TpRvLYNw==
X-Received: by 2002:a17:906:7e53:: with SMTP id z19mr3818592ejr.334.1601970850171;
        Tue, 06 Oct 2020 00:54:10 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id dm8sm1694159edb.57.2020.10.06.00.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 00:54:09 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: filter guest NX capability for cpuid2
In-Reply-To: <20201005163743.GE11938@linux.intel.com>
References: <20201005145921.84848-1-tianjia.zhang@linux.alibaba.com> <87ft6s8zdg.fsf@vitty.brq.redhat.com> <20201005163743.GE11938@linux.intel.com>
Date:   Tue, 06 Oct 2020 09:54:08 +0200
Message-ID: <87d01v94db.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Oct 05, 2020 at 05:29:47PM +0200, Vitaly Kuznetsov wrote:
>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:
>> 
>> > Original KVM_SET_CPUID has removed NX on non-NX hosts as it did
>> > before. but KVM_SET_CPUID2 does not. The two should be consistent.
>> >
>> > Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> > ---
>> >  arch/x86/kvm/cpuid.c | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> > index 3fd6eec202d7..3e7ba2b11acb 100644
>> > --- a/arch/x86/kvm/cpuid.c
>> > +++ b/arch/x86/kvm/cpuid.c
>> > @@ -257,6 +257,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>> >  		goto out;
>> >  	}
>> >  
>> > +	cpuid_fix_nx_cap(vcpu);
>> >  	kvm_update_cpuid_runtime(vcpu);
>> >  	kvm_vcpu_after_set_cpuid(vcpu);
>> >  out:
>> 
>> I stumbled upon this too and came to the conclusion this is
>> intentional, e.g. see this:
>> 
>> commit 0771671749b59a507b6da4efb931c44d9691e248
>> Author: Dan Kenigsberg <danken@qumranet.com>
>> Date:   Wed Nov 21 17:10:04 2007 +0200
>> 
>>     KVM: Enhance guest cpuid management
>> 
>> ...
>> 
>>     [avi: fix original KVM_SET_CPUID not removing nx on non-nx hosts as it did
>>           before]
>> 
>> but this is a very, very old story.
>
> Doesn't mean it's bogus though :-)  _If_ we want to extend this behavior to
> KVM_SET_CPUID2, there should be a justified need.

Yes, exactly. I meand to say that founding fathers of KVM left the
adjustment for KVM_SET_CPUID exclusively on purpose and not by mistake
:-)

-- 
Vitaly

