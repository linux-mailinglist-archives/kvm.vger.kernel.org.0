Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B80414D4B
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 17:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbhIVPq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 11:46:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232571AbhIVPq4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 11:46:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632325526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s47uJvMz2TQnGUC16+QzZF+8Fos67Scg5vuqp2IND9Y=;
        b=Zpx5R+kFQY4tQAHJpM/k9l6sBhUxeVVxjkngCfUv8odETZpen1gQDi0oKkuCautVxJ9EsW
        NWkJTLZycQ7LHcDNizYknBp+Hmy5Lyl4+EZsqrNutp243Us/IB1sb2CG0Zszrvklua4atW
        fKzFJ1nkltTdV8urerXCQi4SdThsUeI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-udPYi2pgOEOwx9mLSiG4AA-1; Wed, 22 Sep 2021 11:45:24 -0400
X-MC-Unique: udPYi2pgOEOwx9mLSiG4AA-1
Received: by mail-ed1-f72.google.com with SMTP id r7-20020aa7c147000000b003d1f18329dcso3531641edp.13
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 08:45:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s47uJvMz2TQnGUC16+QzZF+8Fos67Scg5vuqp2IND9Y=;
        b=JNm7KQTyDiVvg3J4e0TyXL9mGeOwJ7Yd5owOQ+yQZxmS6znByOek77LhOC6xE8NU1l
         yjjwnV7u0V4al+kY87RRbfj2bTl+i594zlU2GhVCoNNCdVbU7zgErjjWZ1VYqIkSSz5D
         PFeMcGYJKJW0BZQ8SCt/HYfG6PktAW55SsuOtB0q7nxx2ZgZ4zPOjn7Viy7V1cR1Z39D
         P7gT+DtW+waUrW17kvCj14NlL/BzJQwcYnYUVHuGXLGlE2FdFanaU7MouUbYWZbGGDik
         g2N0YG3RHs+MU8/V1B0vB0qFVmDQpgBgaR6Fgw8e4S0oS66zX5jguw1GWQ8T4JMcaQeH
         9Erw==
X-Gm-Message-State: AOAM5310Ag6DofQJRm1YRPwf9wPfQ5qXPTiexz92qsJ7Bly56t+Fp9gf
        +91BY6NfF1g2wY0cgR31NsGNS255VfMOT5+NZLPAVxr0Y4rIQGmkwWTaz1WQJbCDkNBHiZ2izwb
        8j3JvQFfeXkUA
X-Received: by 2002:a05:6402:1011:: with SMTP id c17mr335078edu.144.1632325523535;
        Wed, 22 Sep 2021 08:45:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9E7YPbKPpg2K5k5md15deOC/+gq8likqMYfogKDvxQnXwcsGrCD3ObAK82K9RPmuuvaCDIQ==
X-Received: by 2002:a05:6402:1011:: with SMTP id c17mr335057edu.144.1632325523328;
        Wed, 22 Sep 2021 08:45:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c17sm1407211edu.11.2021.09.22.08.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 08:45:22 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
 <22916f0c-2e3a-1fd6-905e-5d647c15c45b@redhat.com>
 <YUtBqsiur6uFWh3o@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/7] KVM: few more SMM fixes
Message-ID: <427038b4-a856-826c-e9f4-01678d33ab83@redhat.com>
Date:   Wed, 22 Sep 2021 17:45:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YUtBqsiur6uFWh3o@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/21 16:46, Sean Christopherson wrote:
> On Wed, Sep 22, 2021, Paolo Bonzini wrote:
>> On 13/09/21 16:09, Maxim Levitsky wrote:
>>>     KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
> 
> ...
>   
>> Queued, thanks.  However, I'm keeping patch 1 for 5.16 only.
> 
> I'm pretty sure the above patch is wrong, emulation_required can simply be
> cleared on emulated VM-Exit.

Are you sure?  I think you can at least set the host segment fields to a 
data segment that requires emulation.  For example the DPL of the host 
DS is hardcoded to zero, but the RPL comes from the selector field and 
the DS selector is not validated.  Therefore a subsequent vmentry could 
fail the access rights tests of 26.3.1.2 Checks on Guest Segment Registers:

DS, ES, FS, GS. The DPL cannot be less than the RPL in the selector 
field if (1) the “unrestricted guest” VM-execution control is 0; (2) the 
register is usable; and (3) the Type in the access-rights field is in 
the range 0 – 11 (data segment or non-conforming code segment).

Paolo

