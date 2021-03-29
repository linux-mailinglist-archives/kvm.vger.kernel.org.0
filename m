Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33D334CC03
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 11:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhC2IzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 04:55:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236177AbhC2Iw5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 04:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617007976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ow3OA1zz0sZgFQjgYK1itMYGQWEYDycsctQNZitiGSo=;
        b=Go+AeN+SgywL8g8xaKHZ4gB5mM5Po1482n/dM70mL2gIikvaVOW4hA56fT5+80wSWyhB8P
        yJxwZ+LS3ivFLEoDuVU14ZgYLTqS0bdudigvJnEuZ/gDp7SGSKtaYgaILLAnCoeFIlkcbx
        UnxgLmpzDRTD4eLrT2Olqv/BCdHIFY0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-_uefPF8WNvOx4cEMeZQ5kQ-1; Mon, 29 Mar 2021 04:52:54 -0400
X-MC-Unique: _uefPF8WNvOx4cEMeZQ5kQ-1
Received: by mail-wm1-f70.google.com with SMTP id k132so1355666wma.1
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 01:52:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Ow3OA1zz0sZgFQjgYK1itMYGQWEYDycsctQNZitiGSo=;
        b=iFNb74u70MvoK8uHR+9sRgWAI/7s92Dd1egpbOS7YZLddV7Hphf6fyo0TzehUL6sTq
         Lf4bk23dfXgHWJpw72fn94bj6PECE7/7jA99VCje90e7Jk9y25ILXQ1YF09JAlvEkuK+
         JtsiNFtQYk2SBg9UgpuO2ODSevb8bSMnYUvlG7XMQieAo4iPNPOjoxUVR8DeW6BbD5sT
         II5ChVehy1nOJa6HOgTcbWA/YgxPhB2vzrjWq+vyTDSV70zg7zazuzsyNuhU2S8Te2LV
         VIE2v5XslOEAI3EQRbP9xQm0KsZ2ocIIvOP7FQvCnpBMDiDW5wMlVZUHbXE6mqdjzC9n
         amOA==
X-Gm-Message-State: AOAM531gaLKozdt5aDiSnt4oMlVA/YLQGTCrZrRUjVslKOhOZi6IchQx
        LwSxk28dsGi+wC7VRxWNTzASenKpJgaBtuldIo9ZAPYGgsKeTZReLH/ukE/NLdNZKKg5hP/0e9B
        Af/a7eR5n2Jh6
X-Received: by 2002:adf:ee4f:: with SMTP id w15mr27575553wro.199.1617007973440;
        Mon, 29 Mar 2021 01:52:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy14ggZeyOKD8MLg/euq/YSevg+wh8nYXfPT6TAJxwjaDv2zhx7W6453bwTkfCmynppamOy1g==
X-Received: by 2002:adf:ee4f:: with SMTP id w15mr27575538wro.199.1617007973184;
        Mon, 29 Mar 2021 01:52:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s9sm26301602wmh.31.2021.03.29.01.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 01:52:52 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Wei Huang <wei.huang2@amd.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/vPMU: Forbid writing to MSR_F15H_PERF MSRs
 when guest doesn't have X86_FEATURE_PERFCTR_CORE
In-Reply-To: <a40090f1-23a1-fca0-3105-b5e48ee5c86e@redhat.com>
References: <20210323084515.1346540-1-vkuznets@redhat.com>
 <a40090f1-23a1-fca0-3105-b5e48ee5c86e@redhat.com>
Date:   Mon, 29 Mar 2021 10:52:51 +0200
Message-ID: <874kgubau4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 23/03/21 09:45, Vitaly Kuznetsov wrote:
>> MSR_F15H_PERF_CTL0-5, MSR_F15H_PERF_CTR0-5 MSRs are only available when
>> X86_FEATURE_PERFCTR_CORE CPUID bit was exposed to the guest. KVM, however,
>> allows these MSRs unconditionally because kvm_pmu_is_valid_msr() ->
>> amd_msr_idx_to_pmc() check always passes and because kvm_pmu_set_msr() ->
>> amd_pmu_set_msr() doesn't fail.
>> 
>> In case of a counter (CTRn), no big harm is done as we only increase
>> internal PMC's value but in case of an eventsel (CTLn), we go deep into
>> perf internals with a non-existing counter.
>> 
>> Note, kvm_get_msr_common() just returns '0' when these MSRs don't exist
>> and this also seems to contradict architectural behavior which is #GP
>> (I did check one old Opteron host) but changing this status quo is a bit
>> scarier.
>
> Hmm, since these do have a cpuid bit it may not be that scary.

Well, if you're not scared I can send a patch)

-- 
Vitaly

