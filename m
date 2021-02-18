Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146F131EE73
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhBRSgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:36:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231529AbhBRSFj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 13:05:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613671450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F/NjJm1o0S+ptTSdUddueRD/FVZWiax6r93BjVuqS/A=;
        b=HwLs7QOrW+Mvg7w3aYE73vW/NXDbrSWp76+RoJnByQ2d9NJOsc0Qqr51SfAMfdBgfjAesC
        Qq/qeCC57qseSnEW7+HjuwReG/IY4y+zAqBGfDvwDyFXuKMh2ENxeXw5b8UYU2bHZblL0g
        njdUpIW4vauPIUDeoL1QWx3WF++oDHA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-co9QC32EOVeKv9Mu9FHY5g-1; Thu, 18 Feb 2021 13:04:07 -0500
X-MC-Unique: co9QC32EOVeKv9Mu9FHY5g-1
Received: by mail-wm1-f71.google.com with SMTP id p8so1505433wmq.7
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 10:04:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F/NjJm1o0S+ptTSdUddueRD/FVZWiax6r93BjVuqS/A=;
        b=EpYE2FDbV1ltSEoWfAw5Ff5lv3oTgdT51augNJiP1lk19PtomBaMcz8WOFRJpaXnt9
         dTM+5uCTaP8/lB7O7sZKx1djMst1tQ7EhkMXwGAhTtnzRlb/MQG2pLbtKwdFuib8D1JT
         PurDwoloDev8wRFok8Ihh+tKgQjs3RMAhR7YN74A1UE++SKtLxMF1SLIpzZY962n6A4I
         0x/4b4f1gfjE8LSsz2hdM4qDzyPK1kcbS3/u7iC6GhkiTXw/QKqgOoLdUwnMODChNCGs
         sml3n66xnYKexqyCfKEUxV+NFXOF+rE76Tkhi5bXLsG+Tu6FSuxzJM4+QRC9nDEgHWaD
         D3xw==
X-Gm-Message-State: AOAM530b5I0hNUd4//EsqboeENt3YysD5TNgmPzrOkPaOudaMdZjfS0e
        WkTDYqWOiPGWmX7452THm4wzfZCxw+ydg+7JpB6gnYXhsmCXxBn+QSlC8gdaiLrwMj1jcWhAUmo
        CA3XUIE6G7m+Y
X-Received: by 2002:a05:600c:41d6:: with SMTP id t22mr4722944wmh.74.1613671446398;
        Thu, 18 Feb 2021 10:04:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzToIuOaBYg4YsXjWIPNzTToi29MrO1jvQGdbhSJ1/zUpu0V8O/tNhmqRFtToS3jfljw7kFzQ==
X-Received: by 2002:a05:600c:41d6:: with SMTP id t22mr4722910wmh.74.1613671446175;
        Thu, 18 Feb 2021 10:04:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b2sm10537937wrn.2.2021.02.18.10.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 10:04:05 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is
 valid
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     David Edmondson <dme@dme.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
References: <20210218100450.2157308-1-david.edmondson@oracle.com>
 <708f2956-fa0f-b008-d3d2-93067f95783c@redhat.com> <cuntuq9ilg4.fsf@dme.org>
 <8f9d4ef7-ddad-160b-2d94-69f4370e8702@redhat.com>
 <YC6XVrWPRQJ7V6Nd@google.com>
 <CALMp9eTX4Na2VTY2aU=-SUrGhst5aExdCB3f=4krKj1mFPgcqQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <13461f99-09a3-6e9a-d015-2658a46b628a@redhat.com>
Date:   Thu, 18 Feb 2021 19:04:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTX4Na2VTY2aU=-SUrGhst5aExdCB3f=4krKj1mFPgcqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/21 18:55, Jim Mattson wrote:
>>> Got it now.  It would sort of help, because while dumping the MSR load/store
>>> area you could get hold of the real EFER, and use it to decide whether to
>>> dump the PDPTRs.
>> EFER isn't guaranteed to be in the load list, either, e.g. if guest and host
>> have the same desired value.
>>
>> The proper way to retrieve the effective EFER is to reuse the logic in
>> nested_vmx_calc_efer(), i.e. look at VM_ENTRY_IA32E_MODE if EFER isn't being
>> loaded via VMCS.
>
> Shouldn't dump_vmcs() simply dump the contents of the VMCS, in its
> entirety? What does it matter what the value of EFER is?

Currently it has some conditionals, but it wouldn't be a problem indeed 
to remove them.

The MSR load list is missing state that dump_vmcs should print though.

Paolo

