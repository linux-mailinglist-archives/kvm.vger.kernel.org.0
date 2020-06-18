Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAAA1FF276
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 14:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbgFRMyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 08:54:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30913 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728215AbgFRMyw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Jun 2020 08:54:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592484891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GFWBe5zShZuKjAbK8diRva50YzmRg/DMEjWSnvAfB8Y=;
        b=KWo2k/KGFwuvHo9k8ao6KfvENQUAnkhlJ6TkmfQHrqjehelQ9nWH5VITxmO/llqb8W/ZAL
        jXcwZxFzrql8rcUjn+Th0zrIMJBT09hOD+phN5jNzlGZwlchsbqqAftHT5CgSQvWXQuBDK
        p9aogIuekxMsp5tnMJPjwHU45p1NZCU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-tmyxXAhJNMK6wMrgJUaLQA-1; Thu, 18 Jun 2020 08:54:49 -0400
X-MC-Unique: tmyxXAhJNMK6wMrgJUaLQA-1
Received: by mail-ed1-f70.google.com with SMTP id w23so2207669edt.18
        for <kvm@vger.kernel.org>; Thu, 18 Jun 2020 05:54:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GFWBe5zShZuKjAbK8diRva50YzmRg/DMEjWSnvAfB8Y=;
        b=Nrtc/POlAyFsFMocz8hczFYL9YkY4oBugqUkmK0KI6+IHOdNUXI9mmYHyy5QgfI2ZW
         /l3WkyibPmrxyyEeDECdEq8KfY5cvYFwW1oB2ZiJBykY3pdhZEtjFqxqFbAAR3e57mPX
         d2kJFSL4xWeevGw0xzDy9/ZhokqgKbHj+irs2ht23XdoFv+fOXT5Yd9AVzqrzXV10+Bd
         dIGtfAfcKkVdZecqKQmv3Sw5NWtRTKPtK2k3IK4uLdgRMNvyD7ArOWI8Nh1CT0lFFvaT
         IHuvF+ZY5Qz6R7EFCfm0ZGlR/9GJK/s62b80gHSEkZDJJjtHOECWG66sxB6u36RMOLDx
         djbg==
X-Gm-Message-State: AOAM531IRfoqxAlg2CyrV7qxwHzcMoW5c/wtxmCDmqy6n3+WyQp6VJVH
        uRRrEsG+x2eAtkQwMS50fSlwLoRirmvG/Lt8P90f1wvD9+tk2H+NgaAnZzq430XKUKoOLK1iEXV
        NyYCV4VIT7Jvx
X-Received: by 2002:a17:906:c317:: with SMTP id s23mr3617467ejz.311.1592484887485;
        Thu, 18 Jun 2020 05:54:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRngFvcNIFMCnpL9zk3fKov7ZL02XwX7tWjBgDoozUFRVE2MF9vR2PEm8PRvEU9vHi3nYP+Q==
X-Received: by 2002:a17:906:c317:: with SMTP id s23mr3617452ejz.311.1592484887278;
        Thu, 18 Jun 2020 05:54:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id me8sm2255441ejb.28.2020.06.18.05.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 05:54:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: SVM: emulate MSR_IA32_PERF_CAPABILITIES
In-Reply-To: <adc8b307-4ec4-575f-ff94-c9b820189fb1@redhat.com>
References: <20200618111328.429931-1-vkuznets@redhat.com> <adc8b307-4ec4-575f-ff94-c9b820189fb1@redhat.com>
Date:   Thu, 18 Jun 2020 14:54:45 +0200
Message-ID: <87ftash6ui.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 18/06/20 13:13, Vitaly Kuznetsov wrote:
>> state_test/smm_test selftests are failing on AMD with:
>> "Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"
>> 
>> MSR_IA32_PERF_CAPABILITIES is an emulated MSR on Intel but it is not
>> known to AMD code, emulate it there too (by returning 0 and allowing
>> userspace to write 0). This way the code is better prepared to the
>> eventual appearance of the feature in AMD hardware.
>> 
>> Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting")
>> Suggested-by: Jim Mattson <jmattson@google.com>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/svm/pmu.c | 29 ++++++++++++++++++++++++++++-
>>  1 file changed, 28 insertions(+), 1 deletion(-)
>
> This is okay and I'll apply it, but it would be even better to move the
> whole handling of the MSR to common x86 code.

I thought about that but intel_pmu_set_msr() looks at
vmx_get_perf_capabilities(), we'll need to abstract this somehow.

-- 
Vitaly

