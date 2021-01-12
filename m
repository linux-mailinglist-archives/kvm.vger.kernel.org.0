Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2112F29AE
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 09:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404424AbhALIHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 03:07:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23506 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730314AbhALIHj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 03:07:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610438772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e98jFtAnO+UtW7Rwri+cMU4/wIA3Ib5qoGAOd0HCxb8=;
        b=Txbu8y7BPf1HL0vfozcTxckFkAv2Xu2VFjHEgXZgJwDWdQiZL9d7TueZQlNZdndWiEcL9e
        LHyzIKigGz05gVrzMXEGfE1RQpGZvMcHL8OzTN1iS+x/m8TEGcxIoPEbL6fsMyw7YEQsOD
        ID7zGxHhBge/CrcWfUVrY7/o65icbnQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-Yo-1i2fFPrqGw1mGmV-Mtw-1; Tue, 12 Jan 2021 03:06:11 -0500
X-MC-Unique: Yo-1i2fFPrqGw1mGmV-Mtw-1
Received: by mail-ej1-f71.google.com with SMTP id gu19so688269ejb.13
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 00:06:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e98jFtAnO+UtW7Rwri+cMU4/wIA3Ib5qoGAOd0HCxb8=;
        b=aKM7/pULcTjti/6WPrNAXYg8BSXRVYEh1WeqbT3PmM+RNFNG+T5PIOGF7tfjTId1O6
         f76W2nTMUgILGLLSKwseZYT+1nsZ1CgSJ9WYp7IzrnatxoZ9duKbDg15TkreY7GOQDx9
         eeuno0+GZeguAz2kseV4nCvqW5y7NV6GJk+2pceT6j9YBHqJWgTxMDnTwlob1ywp1RbH
         D651eGGAkvKYjuN33/aSkxTk10lMzBV7vWmb+C98+0eOcMql6hPKTLVKVxlA886mRIgB
         KSGHY7sdkr1NPUWmofT5YvN4cUhXL68BcfK/+ATjl3ihz1ygXM4m4m2WnjoEMkgEDNbN
         shvw==
X-Gm-Message-State: AOAM533q0Vfzp+r/WWXyMF5bgNPiaW6jpXMIVtq8YHGSmz0qypxvhbLU
        RfjwEugduppqJ6Ifob5ujkdTWcyOezS9iJY5S3YBEXo9uSKoU6OBZf1KpoOSiOe1lUiUut6ASip
        bMXbzVwWkbQg7
X-Received: by 2002:a17:906:c10e:: with SMTP id do14mr2483307ejc.166.1610438769919;
        Tue, 12 Jan 2021 00:06:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxC9sIchIaPbpCd6LbN/mEZzRXK+530541sS7ArG8ztI+ctpVEyq5i7XV2NYKlXWG8KFV1ouA==
X-Received: by 2002:a17:906:c10e:: with SMTP id do14mr2483289ejc.166.1610438769757;
        Tue, 12 Jan 2021 00:06:09 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id zn5sm844167ejb.111.2021.01.12.00.06.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 00:06:09 -0800 (PST)
Subject: Re: UBSAN: shift-out-of-bounds in kvm_vcpu_after_set_cpuid
To:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     syzbot <syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        the arch/x86 maintainers <x86@kernel.org>
References: <000000000000d5173d05b7097755@google.com>
 <CALMp9eSKrn0zcmSuOE6GFi400PMgK+yeypS7+prtwBckgdW0vQ@mail.gmail.com>
 <X/zYsnfXpd6DT34D@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1aa1f3c-1dac-2357-ee1c-ab505513382f@redhat.com>
Date:   Tue, 12 Jan 2021 09:06:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X/zYsnfXpd6DT34D@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/21 00:01, Sean Christopherson wrote:
>> Perhaps cpuid_query_maxphyaddr() should just look at the low 5 bits of
>> CPUID.80000008H:EAX?

The low 6 bits I guess---yes, that would make sense and it would have 
also fixed the bug.

(Nevertheless it's a good idea to make rsvd_bits more robust as well, as 
in the commit that Sean referenced.

Paolo

