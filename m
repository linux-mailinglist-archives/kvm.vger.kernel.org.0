Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6864A5E54
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 15:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiBAObt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 09:31:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234833AbiBAObr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 09:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643725907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uMK8/jcOZdjpD/nh6+MuQsZsF0YOGLGqcOfutTCzX3o=;
        b=K+WqCEtZKg/9L0Fh6FJ5M1WPgNdXxQqhTSqQuRNeKAkz9jPRgAxQ1+EjqJDVdVcsbrWTtP
        znbtq2XnZGqG9FyfBUKHLkq978LacZ3bkFUHPHoixTbm3dOhoIniLcfEloqOzbGB3IpQGy
        7eUg7+oyUnTMfYOJz5wXx87QhlcNF5Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-XLAi6bVLNKqVOZxXBGZqfw-1; Tue, 01 Feb 2022 09:31:45 -0500
X-MC-Unique: XLAi6bVLNKqVOZxXBGZqfw-1
Received: by mail-ed1-f71.google.com with SMTP id j1-20020aa7c341000000b0040417b84efeso8761473edr.21
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 06:31:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uMK8/jcOZdjpD/nh6+MuQsZsF0YOGLGqcOfutTCzX3o=;
        b=ujcYbtm2CJpmrqtumrTd3azganDMaRIrFXIA64nlfpBKy1Ero9xWx3vJY9tEWU/VPD
         pLXUmUdl6y1lNSwW4l47lwN5vEQc4QKLpPU4XLWyNHNdg+FXBhrS6Fy3hw5fQYsKE5DZ
         WwMdgG0G3OS3cB8y2qExUJ47PgqVm8Egq3UG94PXvryMfNNmY40RkqXOpLytkpZHFzxv
         dGOzWb2orn97FyZWhv54VT/d2BxgXsqHDwhd6xaX11BqS88HJjw1Fnd/LAFeZHWbGj5o
         eod02Nkh6ttYl5cGv6uMAostwbHamDsbtTF3dGYK1zLtnrIDPfyRuCK1bEGMnOq29l7z
         A9ug==
X-Gm-Message-State: AOAM531YE7H/s/7GCVQpnOtEZVSc95a3nYT7VG+Mych4FgPaol1FqwW3
        ht7QIHwVSKf+CKhY6U+IWEFX8Ok8K5k9KSm0m0a6YPWm4sLBkJ8efF7a+GAaDsXNMB4twoJwGD2
        naEfUDP8+WIzr
X-Received: by 2002:a17:907:7b8d:: with SMTP id ne13mr6469269ejc.136.1643725904322;
        Tue, 01 Feb 2022 06:31:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxaMlxQDg5uPVclG2SA1eg5ZnllWOcMasdnd7IS7AQ5IUKTYNl5m4fiRpbpgX/p7pKN5sDPOA==
X-Received: by 2002:a17:907:7b8d:: with SMTP id ne13mr6469254ejc.136.1643725904126;
        Tue, 01 Feb 2022 06:31:44 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id gh14sm14554716ejb.38.2022.02.01.06.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 06:31:43 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: SVM: nSVM: Implement Enlightened MSR-Bitmap
 for Hyper-V-on-KVM and fix it for KVM-on-Hyper-V
In-Reply-To: <35f06589-d300-c356-dc17-2c021ac97281@redhat.com>
References: <20211220152139.418372-1-vkuznets@redhat.com>
 <35f06589-d300-c356-dc17-2c021ac97281@redhat.com>
Date:   Tue, 01 Feb 2022 15:31:42 +0100
Message-ID: <87sft2bqup.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 12/20/21 16:21, Vitaly Kuznetsov wrote:
>> Enlightened MSR-Bitmap feature implements a PV protocol for L0 and L1
>> hypervisors to collaborate and skip unneeded updates to MSR-Bitmap.
>> KVM implements the feature for KVM-on-Hyper-V but it seems there was
>> a flaw in the implementation and the feature may not be fully functional.
>> PATCHes 1-2 fix the problem. The rest of the series implements the same
>> feature for Hyper-V-on-KVM.
>> 
>> Vitaly Kuznetsov (5):
>>    KVM: SVM: Drop stale comment from
>>      svm_hv_vmcb_dirty_nested_enlightenments()
>>    KVM: SVM: hyper-v: Enable Enlightened MSR-Bitmap support for real
>>    KVM: nSVM: Track whether changes in L0 require MSR bitmap for L2 to be
>>      rebuilt
>>    KVM: x86: Make kvm_hv_hypercall_enabled() static inline
>>    KVM: nSVM: Implement Enlightened MSR-Bitmap feature
>> 
>>   arch/x86/kvm/hyperv.c           | 12 +--------
>>   arch/x86/kvm/hyperv.h           |  6 ++++-
>>   arch/x86/kvm/svm/nested.c       | 47 ++++++++++++++++++++++++++++-----
>>   arch/x86/kvm/svm/svm.c          |  3 ++-
>>   arch/x86/kvm/svm/svm.h          | 16 +++++++----
>>   arch/x86/kvm/svm/svm_onhyperv.h | 12 +++------
>>   6 files changed, 63 insertions(+), 33 deletions(-)
>> 
>
> Queued 3-5 now, but it would be nice to have some testcases.
>

Thanks, indeed, I'll try to draft something up, both for nVMX and nSVM.

-- 
Vitaly

