Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54C4496AEE
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 09:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiAVIRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 03:17:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbiAVIRu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 Jan 2022 03:17:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642839469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TG6QEhuY9ZIy4SOy4T7GfVmZPT2ViIWcL0SkcfVaGHU=;
        b=h1yMqd7YeeWfnYMXQ14qXVI3bWByLPl24NssaJy6h4G2amSNpoeJ4Nixt+y0Xkku8qrmiW
        6HoqavPQKZ5BAr4d0dDxFoZc+9MJoezgkfpP9anvIjCDVHw7lUdP71jk8hiG26bLa6pdBn
        e3JCX4A8uZx/zjdWes6cgaqXQSF/4Aw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-X7TAVMxVPZ-Ya48l4-ijow-1; Sat, 22 Jan 2022 03:17:46 -0500
X-MC-Unique: X7TAVMxVPZ-Ya48l4-ijow-1
Received: by mail-wr1-f69.google.com with SMTP id x4-20020adfbb44000000b001d83e815683so816925wrg.8
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 00:17:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TG6QEhuY9ZIy4SOy4T7GfVmZPT2ViIWcL0SkcfVaGHU=;
        b=cnpQHnl3GcwhEK/i7Dxyoy1Tx0orJKjur/KUEWgN1vPcATcUdXwZ+FF5mF8FZT727k
         ImR6A7bEK+/azMChVO7gBfATJ1kTyaDfFoT32Z3jknvOn8dldCcrYdr6/9+5SLVXF7vm
         9TswMBdjxk2ulEawcrdzv6iKCcsuSdFCTQ0WmSmhLhWyb/R3m5NpUXEzvnQ3UHPtKePb
         SCl4Hz+s/cOrCJ972mM1PQ+0LNS9wWhFcj/o7JCHCVX+3UY+YSGb1Rm9UryVmr+ggtMo
         yOYI19+pjU9jAEWaVYv0qIdcBCR3HAUhux4CwAus4mfLTjiTIsDzx8xNYteuM3UMxiOn
         6saw==
X-Gm-Message-State: AOAM530pGkDnv+1hr2XtdXyjrSiSgtyXx/6mTFsGCs2MmwUYBAnVEOnw
        1K+GHmWOJqqGL5b0WfWtkEM3RbDRna6UNCGlgdypLmjj3Vvvv1QCmm9g7rXBBB02rpYFoDSph50
        GQte2N/xu2Snk
X-Received: by 2002:a1c:f303:: with SMTP id q3mr3663998wmq.63.1642839465069;
        Sat, 22 Jan 2022 00:17:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZ30FILZYqtip38gkOzWjiKW119eyvaVofLJH217trFBRst6CBNJFQefEUV3LkVzG++CZv7Q==
X-Received: by 2002:a1c:f303:: with SMTP id q3mr3663986wmq.63.1642839464882;
        Sat, 22 Jan 2022 00:17:44 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o2sm8263931wms.9.2022.01.22.00.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 00:17:44 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/5] KVM: x86: Move CPUID.(EAX=0x12,ECX=1) mangling
 to __kvm_update_cpuid_runtime()
In-Reply-To: <2ba86d3f-5ab2-af2f-1f7d-ba2d6b7e78d2@redhat.com>
References: <20220121132852.2482355-1-vkuznets@redhat.com>
 <20220121132852.2482355-3-vkuznets@redhat.com>
 <2ba86d3f-5ab2-af2f-1f7d-ba2d6b7e78d2@redhat.com>
Date:   Sat, 22 Jan 2022 09:17:43 +0100
Message-ID: <878rv8jiag.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 1/21/22 14:28, Vitaly Kuznetsov wrote:
>> To support comparing CPUID data update with what's already set for a vCPU
>> all mangling needs to happen in __kvm_update_cpuid_runtime(), before
>> 'vcpu->arch.cpuid_entries' is updated. CPUID.(EAX=0x12,ECX=1) is currently
>> being mangled in kvm_vcpu_after_set_cpuid(), move it to
>> __kvm_update_cpuid_runtime(). Split off cpuid_get_supported_xcr0() helper
>> as 'vcpu->arch.guest_supported_xcr0' update needs (logically) to stay in
>> kvm_vcpu_after_set_cpuid().
>> 
>> No functional change intended.
>
> Since v3 is already on its way to Linus, I'll merge this patch next week.
>

Thanks,

there is also a change in "[PATCH v4 3/5] KVM: x86: Partially allow
KVM_SET_CPUID{,2} after KVM_RUN" where I switch to memcmp (as suggested
by Sean). I can send an incremental patch if needed.

-- 
Vitaly

