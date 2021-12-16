Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97224477679
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 17:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbhLPQAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 11:00:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238614AbhLPQAL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Dec 2021 11:00:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639670411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K73gtROK9yHGDt0feRVcgm7GFOvu+wT3KMY2fXkTD0E=;
        b=UGAQHQ3jHp6P8OxUw4iktr8IpvRR7jvHrZlbLsZ3jrdNe61CJ9usktAsspsCB0mNKgphKg
        njLzgie0xLRLxjwt0YV61gyX4Bj+hl0j4aAZaurzsT1BDnpqpxEv+E9hzzpTnBOeriqhid
        kp85x0+PQjIANUkLRgS/ZAIkKEUEu3A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-PqEoB1SkO8mqnaijIEHKmA-1; Thu, 16 Dec 2021 11:00:10 -0500
X-MC-Unique: PqEoB1SkO8mqnaijIEHKmA-1
Received: by mail-wr1-f69.google.com with SMTP id h12-20020adfa4cc000000b001a22dceda69so1780107wrb.16
        for <kvm@vger.kernel.org>; Thu, 16 Dec 2021 08:00:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=K73gtROK9yHGDt0feRVcgm7GFOvu+wT3KMY2fXkTD0E=;
        b=VQYoamH5d0XAQYHAhR0NXfWmf8kknkuk+aYUBTD+/czLU6OBB/maRGGbi5F+YXLC/7
         wQ5mqX6dFrACTjiJEkhvWQGqxOjaRNcE8KsL12jb8dmBFJbrdEL5WC1rhz+NbMigxgmq
         SoEJs0aEDFJ6cPcZkZwX98sn5WK+ZMUMkQ+UxivrB9nw+bLFQ2dFcnM/tP/dVseXkMWL
         2On9LihBx33eT167srW943toaL95x2TKxx5YQZjgOoyhLsZbVTpvCIgXmPuaLUcQ7ViX
         GYUXkJbPHGbQVhk6LeVmT85pExJiuE2nzOxFkUBXJBvGj0J06UCfcZkL0LziJkcmuyBA
         CJag==
X-Gm-Message-State: AOAM533xgNO9Y5xlWwefrU9Y/5UFh1DcCZz1MwyoN+AKMx318zbaulde
        yPbM8K+p/VqUVhHrFCBJIUvFxex7U1Bv1wgrB/ChcJKKchV43Ae7Pw2IQD+6AU4J61m3F9MPUAl
        DontvvZZ+Wsa5
X-Received: by 2002:a1c:4e17:: with SMTP id g23mr5783997wmh.158.1639670408693;
        Thu, 16 Dec 2021 08:00:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxy4f4e6ERjn00UIt+ootLIYaVF9OYCiHWhiuIzpCHZV9hE+Ni/ZN0Aqyu8u4aiuli3XaLyxA==
X-Received: by 2002:a1c:4e17:: with SMTP id g23mr5783970wmh.158.1639670408380;
        Thu, 16 Dec 2021 08:00:08 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n9sm6117415wmq.37.2021.12.16.08.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:00:07 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, oliver.sang@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Avoid KVM_SET_CPUID2 after KVM_RUN in
 vmx_pmu_msrs_test
In-Reply-To: <Ybtfzo6Fx6KLfK3V@google.com>
References: <20211215161617.246563-1-vkuznets@redhat.com>
 <YbotG5neKyzhv22Z@google.com> <87a6h0vs36.fsf@redhat.com>
 <Ybtfzo6Fx6KLfK3V@google.com>
Date:   Thu, 16 Dec 2021 17:00:06 +0100
Message-ID: <87tuf8tu9l.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Dec 16, 2021, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index 85127b3e3690..65e297875405 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -3424,7 +3424,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> >
>> >                 if (!msr_info->host_initiated)
>> >                         return 1;
>> > -               if (guest_cpuid_has(vcpu, X86_FEATURE_PDCM) && kvm_get_msr_feature(&msr_ent))
>> > +               if (kvm_get_msr_feature(&msr_ent))
>> >                         return 1;
>> >                 if (data & ~msr_ent.data)
>> >                         return 1;
>> 
>> This looks OK.
>> 
>> > @@ -3779,14 +3779,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> >                 msr_info->data = vcpu->arch.microcode_version;
>> >                 break;
>> >         case MSR_IA32_ARCH_CAPABILITIES:
>> > -               if (!msr_info->host_initiated &&
>> > -                   !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_CAPABILITIES))
>> > +               if (!msr_info->host_initiated)
>> >                         return 1;
>> >                 msr_info->data = vcpu->arch.arch_capabilities;
>> >                 break;
>> >         case MSR_IA32_PERF_CAPABILITIES:
>> > -               if (!msr_info->host_initiated &&
>> > -                   !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
>> > +               if (!msr_info->host_initiated)
>> >                         return 1;
>> >                 msr_info->data = vcpu->arch.perf_capabilities;
>> >                 break;
>> >
>> 
>> Hm, this change will unconditionally forbid reading
>> MSR_IA32_ARCH_CAPABILITIES/MSR_IA32_PERF_CAPABILITIES from the guest. Is
>> this what we want?
>
> No, I completely misread the code.  The kvm_set_msr_common() goof seems to be
> the only bug, and that would also explain the selftest's bad testcase.
>

Ok then, v2 is coming.

-- 
Vitaly

