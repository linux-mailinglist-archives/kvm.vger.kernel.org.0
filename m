Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9BF217ABA
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 23:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgGGVwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 17:52:05 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20026 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728845AbgGGVwE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 17:52:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594158722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2er0aNLBQV2gIBNyC9uXErvIZxgp1FWSJ0RFq0zI9K0=;
        b=A4LDYvuLtuSDEKZuK68Sd7ijKVzD8COfHO6UZ4fM8Auq6qbGHS8pBrJWgVmDAu+46+3Old
        PZTMgndMsTHnqIKxoFWqYw8t8RrdQfikYD3A/ZpqxUU5lZjFUYNX6g7qK3NDfcGiVB/U2Y
        uZpY7qkjyM5CxIwgy8nHeb5Rayt7uRA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321--BB8MYI9OsuWll9clt_puw-1; Tue, 07 Jul 2020 17:52:01 -0400
X-MC-Unique: -BB8MYI9OsuWll9clt_puw-1
Received: by mail-wm1-f70.google.com with SMTP id q20so797900wme.3
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 14:52:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2er0aNLBQV2gIBNyC9uXErvIZxgp1FWSJ0RFq0zI9K0=;
        b=XqHpCJQoIV7Dy6yUxlyOXWRyNuM/tbtNbjUPosLy0rRLTTQ5+PQi2nzoLFRoQkS2ze
         6xuUGq7vkqqfgSwQYSE8cQqn/1T+TD6Yu+onOZPChXo44NTowviY3LGWhxwD682sM9JG
         B/G1BseiAaieoeV84Y66auLsbw/e+DBFIyzsXHz7HFDlsGOmKekN6f2i6zqRqTOh0wWI
         SQz7b09kIwGT8DeZq1E0uL56aoxuXE/IC65A3rIj7zYMbzdKOW+6sSA2RgGjmfmI8Mq3
         ePaGsWKg7cbCfP7U/yY6UMFw3wnZ7khfOvPwWTtMwsJbPjs4ZuODpUWgt+6VUSODUGUR
         dBqg==
X-Gm-Message-State: AOAM531XfJ+4Vj0FUQYqvIeQjbcTtrg7k6OlUVCrRESp+iGfzvPKnAG6
        Q5It5zrVJUvM8vffLJVDsmqCxtNLptn9rSjTovs8lZC8udelhC8zBA2fXLrE19SynKvREXjze3z
        xjr8ArIGSZXoR
X-Received: by 2002:a05:600c:241:: with SMTP id 1mr6023739wmj.119.1594158719932;
        Tue, 07 Jul 2020 14:51:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIpmpXuw2PJCwb7uqNw0kg7Wrr1nz+wOneSDUnHkzV5klsewRb97ktM0f//9gTqHyZmBrCjg==
X-Received: by 2002:a05:600c:241:: with SMTP id 1mr6023711wmj.119.1594158719656;
        Tue, 07 Jul 2020 14:51:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7c9b:2885:1733:3575? ([2001:b07:6468:f312:7c9b:2885:1733:3575])
        by smtp.gmail.com with ESMTPSA id k11sm2922650wrd.23.2020.07.07.14.51.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 14:51:59 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: x86: Introduce paravirt feature CR0/CR4 pinning
To:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Andersen, John" <john.s.andersen@intel.com>, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, shuah@kernel.org, liran.alon@oracle.com,
        drjones@redhat.com, rick.p.edgecombe@intel.com,
        kristen@linux.intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        mchehab+huawei@kernel.org, gregkh@linuxfoundation.org,
        paulmck@kernel.org, pawan.kumar.gupta@linux.intel.com,
        jgross@suse.com, mike.kravetz@oracle.com, oneukum@suse.com,
        luto@kernel.org, peterz@infradead.org, fenghua.yu@intel.com,
        reinette.chatre@intel.com, vineela.tummalapalli@intel.com,
        dave.hansen@linux.intel.com, arjan@linux.intel.com,
        caoj.fnst@cn.fujitsu.com, bhe@redhat.com, nivedita@alum.mit.edu,
        keescook@chromium.org, dan.j.williams@intel.com,
        eric.auger@redhat.com, aaronlewis@google.com, peterx@redhat.com,
        makarandsonare@google.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        kernel-hardening@lists.openwall.com
References: <20200617190757.27081-1-john.s.andersen@intel.com>
 <20200617190757.27081-3-john.s.andersen@intel.com>
 <0fa9682e-59d4-75f7-366f-103d6b8e71b8@intel.com>
 <20200618144314.GB23@258ff54ff3c0>
 <124a59a3-a603-701b-e3bb-61e83d70b20d@intel.com>
 <20200707211244.GN20096@linux.intel.com>
 <19b97891-bbb0-1061-5971-549a386f7cfb@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <31eb5b00-9e2a-aa10-0f20-4abc3cd35112@redhat.com>
Date:   Tue, 7 Jul 2020 23:51:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <19b97891-bbb0-1061-5971-549a386f7cfb@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/20 23:48, Dave Hansen wrote:
> On 7/7/20 2:12 PM, Sean Christopherson wrote:
>>>>> Let's say Intel loses its marbles and adds a CR4 bit that lets userspace
>>>>> write to kernel memory.  Linux won't set it, but an attacker would go
>>>>> after it, first thing.
>> That's an orthogonal to pinning.  KVM never lets the guest set CR4 bits that
>> are unknown to KVM.  Supporting CR4.NO_MARBLES would require an explicit KVM
>> change to allow it to be set by the guest, and would also require a userspace
>> VMM to expose NO_MARBLES to the guest.
>>
>> That being said, this series should supporting pinning as much as possible,
>> i.e. if the bit can be exposed to the guest and doesn't require special
>> handling in KVM, allow it to be pinned.  E.g. TS is a special case because
>> pinning would require additional emulator support and IMO isn't interesting
>> enough to justify the extra complexity.  At a glance, I don't see anything
>> that would prevent pinning FSGSBASE.
> 
> Thanks for filling in the KVM picture.
> 
> If we're supporting as much pinning as possible, can we also add
> something to make it inconvenient for someone to both make a CR4 bit
> known to KVM *and* ignore the pinning aspects?
> 
> We should really make folks think about it.  Something like:
> 
> #define KVM_CR4_KNOWN 0xff
> #define KVM_CR4_PIN_ALLOWED 0xf0
> #define KVM_CR4_PIN_NOT_ALLOWED 0x0f
> 
> BUILD_BUG_ON(KVM_CR4_KNOWN !=
>              (KVM_CR4_PIN_ALLOWED|KVM_CR4_PIN_NOT_ALLOWED));
> 
> So someone *MUST* make an active declaration about new bits being pinned
> or not?

I would just make all unknown bits pinnable (or perhaps all CR4 bits in
general).

Paolo

