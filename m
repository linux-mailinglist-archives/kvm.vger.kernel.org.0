Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1500621B95A
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 17:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGJPXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 11:23:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21070 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726962AbgGJPXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 11:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594394586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hVCnQ8dSz5bzqPfVKUA5yGVKNr0A/IBOxZrAZfXjfV4=;
        b=NAeMY/d+jJ5JqEy0p6riS+7XhmmTJcxWSUxdWP4rwrzLJbi3NJ4PdU61Xmh2mLtp/fjGMY
        PA6vQbiT9gOV/7uBfC575Ntt7oTiXuvFh8J6gKCUDlVf/Xxb1lNSWcaIne8JS1bMqQJTh7
        6rzi9GJXB2Z7RhFQSs8CiyG4/Pl3KWs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-q_s_lyW7M7ug0wqEdPhRpw-1; Fri, 10 Jul 2020 11:23:04 -0400
X-MC-Unique: q_s_lyW7M7ug0wqEdPhRpw-1
Received: by mail-wm1-f69.google.com with SMTP id c124so7039527wme.0
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 08:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hVCnQ8dSz5bzqPfVKUA5yGVKNr0A/IBOxZrAZfXjfV4=;
        b=hxnMid2YX1CwSWpn7MZBESG4sOvE2BwyCvAhusieJ7CMgC+NSXPXGpDZgs7LKqoke4
         F72pNZRHrNTBRK8OCjc3g63GGLtE8VqHbydYMTqPQCyzTzS+Pk6y5UwJdC8l+LbOVO8y
         Uh0l6GiqucpzwVDNmVIxMkwjwgOTB5SmJYSrW4GGN79eYcJ2xtvcpviVVCZmLt8bw/S/
         7Bg+l89QGcn+wGsaeZLMMOR7BdHjiqW9vqomJAbgF5vrheppZKEvahTAQue6+DoJGR5T
         LDBw6+yQmy+wTYoviH7eGGxlyv+vvpk4OBtckg8v73LDiBnLxkFjjlkpVS9xUaW3NHrQ
         QoFQ==
X-Gm-Message-State: AOAM5322lu2lvPCkNf/dME7fWvX1iWUmASN/dYBoE3jpzx7i4dnIBrJv
        KUYVdM7aBB07J3vijkWZ/pXS2Xtb5kmaIINfVR4Xq2rYBZTlISUnwyZjyPDPsdHZhEkKkUUAET9
        majNGPIn3kqrq
X-Received: by 2002:a5d:538e:: with SMTP id d14mr68529932wrv.21.1594394583423;
        Fri, 10 Jul 2020 08:23:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9ptpqdTBcz0hnt0FWLyQCyrYqXHcZfxjoO54Ukv+e5iAty/J9EaAh2L7CGpLawRB/P9R/Hw==
X-Received: by 2002:a5d:538e:: with SMTP id d14mr68529912wrv.21.1594394583169;
        Fri, 10 Jul 2020 08:23:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 69sm10490303wma.16.2020.07.10.08.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 08:23:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: SVM: emulate MSR_IA32_PERF_CAPABILITIES
In-Reply-To: <8e3b2eef-b4f1-01cc-e033-c1ece70bd7db@redhat.com>
References: <20200618111328.429931-1-vkuznets@redhat.com> <adc8b307-4ec4-575f-ff94-c9b820189fb1@redhat.com> <87ftash6ui.fsf@vitty.brq.redhat.com> <8e3b2eef-b4f1-01cc-e033-c1ece70bd7db@redhat.com>
Date:   Fri, 10 Jul 2020 17:23:01 +0200
Message-ID: <875zavv1gq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 18/06/20 14:54, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>>> On 18/06/20 13:13, Vitaly Kuznetsov wrote:
>>>> state_test/smm_test selftests are failing on AMD with:
>>>> "Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"
>>>>
>>>> MSR_IA32_PERF_CAPABILITIES is an emulated MSR on Intel but it is not
>>>> known to AMD code, emulate it there too (by returning 0 and allowing
>>>> userspace to write 0). This way the code is better prepared to the
>>>> eventual appearance of the feature in AMD hardware.
>>>>
>>>> Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting")
>>>> Suggested-by: Jim Mattson <jmattson@google.com>
>>>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>>> ---
>>>>  arch/x86/kvm/svm/pmu.c | 29 ++++++++++++++++++++++++++++-
>>>>  1 file changed, 28 insertions(+), 1 deletion(-)
>>> This is okay and I'll apply it, but it would be even better to move the
>>> whole handling of the MSR to common x86 code.
>> I thought about that but intel_pmu_set_msr() looks at
>> vmx_get_perf_capabilities(), we'll need to abstract this somehow.
>
> Indeed, you could use kvm_get_msr_feature for that.
>

Turns out I completely forgot about this patch and just stumbled about
the same issue again. The suggestion to move this to common x86 code
makes perfect sense, I'll be sending v3 shortly.

Thanks!

-- 
Vitaly

