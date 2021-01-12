Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0438C2F33FE
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 16:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405265AbhALPOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 10:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403921AbhALPMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 10:12:42 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E53C061786
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 07:12:02 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id w2so1536015pfc.13
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 07:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=sAziKj+5ysaj74BB1CkG8U/gdK/uJTsMNB61H4Eyj7w=;
        b=MQjkwK1u6oqM7Q3sQKgkIq4j+9T2O71hkVaw1M2FjrZlsNPm85iZVmhu0/GMyH7/BZ
         snhPAJuW+Nk9XM4GS5Vy6bop8y1nSHIKC+JWN3346fEoGpU5+2uLThDDRH852x1hdpoL
         P9BYoukzrUVON+JLQd6Uy3iFRUThPo+IcTB9GPkYQonRwC5qfataf+hGY6VCx6nAl88M
         Dnrcwf8I+GbcYrJkrPcG3MQwYd3j5iTAXEfz1dvV8EJtQfQmgvSuWTMu1jkodNLMAh5E
         xBtU8BngV6T6IM7cKirynUg78gsfpv8H7U4Tx0u5nxRNp1AqMX0fnkw3KuDe1qtNs0Am
         zxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=sAziKj+5ysaj74BB1CkG8U/gdK/uJTsMNB61H4Eyj7w=;
        b=lr1tvR5lJQqESGDaXdWmptiHSY1yO0h5vOivxlt+93spkOFu1lgrxgg/IPSne4YS2Z
         1qSksM1BN1bWEKrk+bSFsCuTa3XoSv7Jzimoqrxt1gAEHnQDZS1s0Kp62rtHEOQvLnHi
         DRmPztRHm5ydslGUvGhQJmVfPYdz+JgM9tmf/Fqdc210nKBokW3doUzDezAgU1NCHw/h
         FGqbsMFhWOE8lDMEebAQZE02pxMIMYZ58GnAtkICbJYQw23z0Ot697YteBDF0Hqk9yHz
         RJQudNz0JK+SAR+I+GdMOwaE5231urD0NUKD1WEJZSLQudhGOhABz7kqouKVUJFYUyXA
         ibbQ==
X-Gm-Message-State: AOAM533n4SFjSlkCOKdaYfa6H4p1W7cRVEWUfGlkP7HC4UgjPaF8k/0O
        deV4AUAJMeycmQ/9gRDP5YAuzA==
X-Google-Smtp-Source: ABdhPJwff2hDVGEkE5llrvsrNlGG/ta2p4TOocpSMo8dbEvwuZ872E4G7GUjDu8VkMUn4NC5oJxKTQ==
X-Received: by 2002:a63:1214:: with SMTP id h20mr5098893pgl.379.1610464321766;
        Tue, 12 Jan 2021 07:12:01 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:1d60:88a3:44d6:6b86? ([2601:646:c200:1ef2:1d60:88a3:44d6:6b86])
        by smtp.gmail.com with ESMTPSA id t22sm4337465pgm.18.2021.01.12.07.11.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 07:12:00 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by VM instructions
Date:   Tue, 12 Jan 2021 07:11:58 -0800
Message-Id: <130DAF1C-06FC-4335-97AD-691B39A2C847@amacapital.net>
References: <87eeiq8i7k.fsf@vitty.brq.redhat.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com, wei.huang2@amd.com, mlevitsk@redhat.com
In-Reply-To: <87eeiq8i7k.fsf@vitty.brq.redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: iPhone Mail (18C66)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Jan 12, 2021, at 4:15 AM, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:=

>=20
> =EF=BB=BFWei Huang <wei.huang2@amd.com> writes:
>=20
>> From: Bandan Das <bsd@redhat.com>
>>=20
>> While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
>> CPUs check EAX against reserved memory regions (e.g. SMM memory on host)
>> before checking VMCB's instruction intercept. If EAX falls into such
>> memory areas, #GP is triggered before VMEXIT. This causes problem under
>> nested virtualization. To solve this problem, KVM needs to trap #GP and
>> check the instructions triggering #GP. For VM execution instructions,
>> KVM emulates these instructions; otherwise it re-injects #GP back to
>> guest VMs.
>>=20
>> Signed-off-by: Bandan Das <bsd@redhat.com>
>> Co-developed-by: Wei Huang <wei.huang2@amd.com>
>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>> ---
>> arch/x86/include/asm/kvm_host.h |   8 +-
>> arch/x86/kvm/mmu.h              |   1 +
>> arch/x86/kvm/mmu/mmu.c          |   7 ++
>> arch/x86/kvm/svm/svm.c          | 157 +++++++++++++++++++-------------
>> arch/x86/kvm/svm/svm.h          |   8 ++
>> arch/x86/kvm/vmx/vmx.c          |   2 +-
>> arch/x86/kvm/x86.c              |  37 +++++++-
>> 7 files changed, 146 insertions(+), 74 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
>> index 3d6616f6f6ef..0ddc309f5a14 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1450,10 +1450,12 @@ extern u64 kvm_mce_cap_supported;
>>  *                 due to an intercepted #UD (see EMULTYPE_TRAP_UD).
>>  *                 Used to test the full emulator from userspace.
>>  *
>> - * EMULTYPE_VMWARE_GP - Set when emulating an intercepted #GP for VMware=

>> + * EMULTYPE_PARAVIRT_GP - Set when emulating an intercepted #GP for VMwa=
re
>>  *            backdoor emulation, which is opt in via module param.
>>  *            VMware backoor emulation handles select instructions
>> - *            and reinjects the #GP for all other cases.
>> + *            and reinjects #GP for all other cases. This also
>> + *            handles other cases where #GP condition needs to be
>> + *            handled and emulated appropriately
>>  *
>>  * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, in=
 which
>>  *         case the CR2/GPA value pass on the stack is valid.
>> @@ -1463,7 +1465,7 @@ extern u64 kvm_mce_cap_supported;
>> #define EMULTYPE_SKIP            (1 << 2)
>> #define EMULTYPE_ALLOW_RETRY_PF        (1 << 3)
>> #define EMULTYPE_TRAP_UD_FORCED        (1 << 4)
>> -#define EMULTYPE_VMWARE_GP        (1 << 5)
>> +#define EMULTYPE_PARAVIRT_GP        (1 << 5)
>> #define EMULTYPE_PF            (1 << 6)
>>=20
>> int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 581925e476d6..1a2fff4e7140 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -219,5 +219,6 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
>>=20
>> int kvm_mmu_post_init_vm(struct kvm *kvm);
>> void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
>> +bool kvm_is_host_reserved_region(u64 gpa);
>=20
> Just a suggestion: "kvm_gpa_in_host_reserved()" maybe?=20
>=20
>>=20
>> #endif
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 6d16481aa29d..c5c4aaf01a1a 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -50,6 +50,7 @@
>> #include <asm/io.h>
>> #include <asm/vmx.h>
>> #include <asm/kvm_page_track.h>
>> +#include <asm/e820/api.h>
>> #include "trace.h"
>>=20
>> extern bool itlb_multihit_kvm_mitigation;
>> @@ -5675,6 +5676,12 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
>> }
>> EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
>>=20
>> +bool kvm_is_host_reserved_region(u64 gpa)
>> +{
>> +    return e820__mbapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED);
>> +}
>=20
> While _e820__mapped_any()'s doc says '..  checks if any part of the
> range <start,end> is mapped ..' it seems to me that the real check is
> [start, end) so we should use 'gpa' instead of 'gpa-1', no?

Why do you need to check GPA at all?


