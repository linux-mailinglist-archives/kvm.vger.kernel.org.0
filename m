Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4632314A7B
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 09:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhBIIkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 03:40:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229759AbhBIIkN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 03:40:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612859919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AUSyGSU1zo934GUzUhAxq4NJf+/0gNgu/jsdZIqNiQ0=;
        b=ayOpUGA0WPVFMYMUKjPLmR2n1vWgU1xu2Mhd3HzImmqj8J7SzuRzqxp5oIS1ylvU3pvUM6
        OZR2PlSd9Zzqy52YmcPCShONpYz4g2Mdjs2QqMH89dRl+Cnnf1WzqTtwrcWLp24d9AY+dz
        7iaQJaq7l2Igw0kA5aNHw1L7z0XtHNg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-6EI8R_w2N3iKHjU1jw6row-1; Tue, 09 Feb 2021 03:38:38 -0500
X-MC-Unique: 6EI8R_w2N3iKHjU1jw6row-1
Received: by mail-ed1-f69.google.com with SMTP id l23so14373922edt.23
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 00:38:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AUSyGSU1zo934GUzUhAxq4NJf+/0gNgu/jsdZIqNiQ0=;
        b=tq6gcllwLZyGJKLVcijn/Pgv8TYSQ5MvGHmZHBp7gguuYbxQbEDSiwsNVR2L+Opgfw
         eBSFDZEOeubBgBFr5zgGaFKT0BxY4rhzYRmieAvpxxwy/Aks4iD6sGvUZCV6qGMQpUMA
         Ub7unCyZSgNIStD7Gy1qIMXR+5mO9CSbJPPn7a7ANh7CF/pB4l1wgMJpVH4ws+w7V8yA
         ONcGYz7c/Gv/dcUAMPE0scNrjf44jv/9xKYZQ++NwkcULGwdzywuUxwnxWeQjQIhnenJ
         P+TbNWN3Ynv4WLE3fOD8ADVJEN6k3DUcq+BOBhkvR3stT0IKBT9cNTwzKOWnl2Pt6PDm
         7VSA==
X-Gm-Message-State: AOAM533iUxLeCtMNmybaqELf2V7jU9FNwZmArKfVPaI260V5Zuaw1oe3
        FlEh9sidrx7V0Jzy/lRvowdpxXKdjqhepNkl8P1HcD5DDkM5QHTr9CrjgHdidyA8m+Mt/16Vx0u
        Tqv7AMG/vQ4JK
X-Received: by 2002:a17:906:71d5:: with SMTP id i21mr10728217ejk.232.1612859917031;
        Tue, 09 Feb 2021 00:38:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwiG8hU2TU0F6vnQrnlrYiw+FEFd8tcjeZIFBf1okRS9eJXjngGuVJu5yC0GL6uNHSvX7P8Vw==
X-Received: by 2002:a17:906:71d5:: with SMTP id i21mr10728205ejk.232.1612859916877;
        Tue, 09 Feb 2021 00:38:36 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bd27sm10494911edb.37.2021.02.09.00.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 00:38:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 10/15] KVM: x86: hyper-v: Always use to_hv_vcpu()
 accessor to get to 'struct kvm_vcpu_hv'
In-Reply-To: <53c5fc3d29ed35ca3252cd5f6547dcb113ab21b9.camel@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
 <20210126134816.1880136-11-vkuznets@redhat.com>
 <53c5fc3d29ed35ca3252cd5f6547dcb113ab21b9.camel@redhat.com>
Date:   Tue, 09 Feb 2021 09:38:35 +0100
Message-ID: <874kiloctw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Tue, 2021-01-26 at 14:48 +0100, Vitaly Kuznetsov wrote:
>
>
> ...
>> _vcpu_mask(
>>  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, u64 ingpa, u16 rep_cnt, bool ex)
>>  {
>>  	struct kvm *kvm = vcpu->kvm;
>> -	struct kvm_vcpu_hv *hv_vcpu = &vcpu->arch.hyperv;
>> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(current_vcpu);
> You probably mean vcpu here instead of current_vcpu. Today I smoke tested the kvm/nested-svm branch,
> and had this fail on me while testing windows guests.
>

Yes!!!

We were using 'current_vcpu' instead of 'vcpu' here before but Sean
warned me about the danger of shadowing global 'current_vcpu' so I added
'KVM: x86: hyper-v: Stop shadowing global 'current_vcpu' variable' to
the series. Aparently, I missed this 'current_vcpu' while
rebasing. AFAIU, normally vcpu == current_vcpu when entering this
function so nothing blew up in my testing.

Thanks for the report! I'll be sending a patch to fix this shortly.

>
> Other than that HyperV seems to work and even survive nested migration (I had one
> windows reboot but I suspect windows update did it.)
> I'll leave my test overnight (now with updates disabled) to see if it
> is stable.

That's good to hear! Are you testing on Intel or AMD? With AMD there's a
stale bug somewhere which prevents Gen2 (UEFI) L2 guests from booting,
the firmare just hangs somewhere not making any progress. Both Hyper-V
2016 and 2019 seem to be affected. Gen1 guests (including Windows in
root partition) work fine. I tried approaching it a couple times but
with no luck so far. Not sure if this is CPU specific or something...

-- 
Vitaly

