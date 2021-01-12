Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F4F2F3418
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 16:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389838AbhALPXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 10:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389672AbhALPXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 10:23:24 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AADAC061794
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 07:22:44 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id d2so1574436pfq.5
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 07:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=0jK5A6F+T51L5qUblxvPVXaFTSynCeaRzZytQ+RLfJU=;
        b=TwJ1YtR78f9dTpRK3wp7oaaMOWdfAS52Ul9Xhehr01de0AYulZoEXgDdluDg8r+IGi
         3Idb/HDlK0OoOHB03rOG0qqXkDzNXChnT4q342hbybSTMXIa6lGp9SuU6yRRoqPYE9w8
         Yx5hNQkmmyFh5KLExpNl9yJqk+RHQi4EBLHra06x1oy/Jkw/xraJdob8sSbOUXtdtBaw
         JRUFBrnIGM8VY/Bn3tWN2VRpPlmBbenaPsGxCc7DY1ZGLS18PrcewsdUaj75lTgehX9s
         lK71atJO8fKg/s8R8+pogewhqrjGT/u2/d6UpfANgzEYWF9pbZtqNcug7WnX+/TXOTxH
         /MDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=0jK5A6F+T51L5qUblxvPVXaFTSynCeaRzZytQ+RLfJU=;
        b=BtzZkCLpi6OHtlYXvDHtqblFHR6c3kNuNGBpg1eoTS/2QbjU3Omz3zLuwNHN3Vxsd+
         ygCtH308GwvWCD7NHvh1jUoqRPjS/zANDFxhfJTOZ27p5ReEZfNZAuPCIl5eT3owJIcp
         r/ZGBpoHTGNFKxOQpopOWjXSKHQZoFSTOsr/MuGDdJN61cEdCUBrQ9mmt5qNqaqw+hlZ
         8z413aGLhxZJsikbkx4aZ3Rj41oyVInyDMDw9Z3NfPB7gmx3E+PVYM/gpRM78jesuSWX
         LLbSphXChUQJ6D8zdK7smQnaEso7DuTg1ebdA3xqXKGLePW9DvJwwhTBSyTCJVa0G/bu
         2BPw==
X-Gm-Message-State: AOAM532EgxREaF+rmGUr7lGVv2uaae8LnWpEt4EigFdG1ID+hafRpLMb
        i7Tc6uVueIXwlH9tmzpY+ZA3SA==
X-Google-Smtp-Source: ABdhPJxWnDdcd5MiDLXBF2olQYG8ZJKKYDudYhAjIDGRJeDO9B8HhEK/w3cjSB7xNM2hKr9Gz/r2Bw==
X-Received: by 2002:a65:6409:: with SMTP id a9mr5224927pgv.171.1610464963623;
        Tue, 12 Jan 2021 07:22:43 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:1d60:88a3:44d6:6b86? ([2601:646:c200:1ef2:1d60:88a3:44d6:6b86])
        by smtp.gmail.com with ESMTPSA id c5sm3109142pjo.4.2021.01.12.07.22.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 07:22:42 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by VM instructions
Date:   Tue, 12 Jan 2021 07:22:41 -0800
Message-Id: <C121813D-BD61-4C78-9169-8F8FCC1356D7@amacapital.net>
References: <9f3b8e3dca453c13867c5c6b61645b9b58d68f61.camel@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, bsd@redhat.com,
        dgilbert@redhat.com
In-Reply-To: <9f3b8e3dca453c13867c5c6b61645b9b58d68f61.camel@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
X-Mailer: iPhone Mail (18C66)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jan 12, 2021, at 7:17 AM, Maxim Levitsky <mlevitsk@redhat.com> wrote:
>=20
> =EF=BB=BFOn Tue, 2021-01-12 at 07:11 -0800, Andy Lutomirski wrote:
>>>> On Jan 12, 2021, at 4:15 AM, Vitaly Kuznetsov <vkuznets@redhat.com> wro=
te:
>>>=20
>>> =EF=BB=BFWei Huang <wei.huang2@amd.com> writes:
>>>=20
>>>> From: Bandan Das <bsd@redhat.com>
>>>>=20
>>>> While running VM related instructions (VMRUN/VMSAVE/VMLOAD), some AMD
>>>> CPUs check EAX against reserved memory regions (e.g. SMM memory on host=
)
>>>> before checking VMCB's instruction intercept. If EAX falls into such
>>>> memory areas, #GP is triggered before VMEXIT. This causes problem under=

>>>> nested virtualization. To solve this problem, KVM needs to trap #GP and=

>>>> check the instructions triggering #GP. For VM execution instructions,
>>>> KVM emulates these instructions; otherwise it re-injects #GP back to
>>>> guest VMs.
>>>>=20
>>>> Signed-off-by: Bandan Das <bsd@redhat.com>
>>>> Co-developed-by: Wei Huang <wei.huang2@amd.com>
>>>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>>>> ---
>>>> arch/x86/include/asm/kvm_host.h |   8 +-
>>>> arch/x86/kvm/mmu.h              |   1 +
>>>> arch/x86/kvm/mmu/mmu.c          |   7 ++
>>>> arch/x86/kvm/svm/svm.c          | 157 +++++++++++++++++++-------------
>>>> arch/x86/kvm/svm/svm.h          |   8 ++
>>>> arch/x86/kvm/vmx/vmx.c          |   2 +-
>>>> arch/x86/kvm/x86.c              |  37 +++++++-
>>>> 7 files changed, 146 insertions(+), 74 deletions(-)
>>>>=20
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
>>>> index 3d6616f6f6ef..0ddc309f5a14 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -1450,10 +1450,12 @@ extern u64 kvm_mce_cap_supported;
>>>> *                 due to an intercepted #UD (see EMULTYPE_TRAP_UD).
>>>> *                 Used to test the full emulator from userspace.
>>>> *
>>>> - * EMULTYPE_VMWARE_GP - Set when emulating an intercepted #GP for VMwa=
re
>>>> + * EMULTYPE_PARAVIRT_GP - Set when emulating an intercepted #GP for VM=
ware
>>>> *            backdoor emulation, which is opt in via module param.
>>>> *            VMware backoor emulation handles select instructions
>>>> - *            and reinjects the #GP for all other cases.
>>>> + *            and reinjects #GP for all other cases. This also
>>>> + *            handles other cases where #GP condition needs to be
>>>> + *            handled and emulated appropriately
>>>> *
>>>> * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, i=
n which
>>>> *         case the CR2/GPA value pass on the stack is valid.
>>>> @@ -1463,7 +1465,7 @@ extern u64 kvm_mce_cap_supported;
>>>> #define EMULTYPE_SKIP            (1 << 2)
>>>> #define EMULTYPE_ALLOW_RETRY_PF        (1 << 3)
>>>> #define EMULTYPE_TRAP_UD_FORCED        (1 << 4)
>>>> -#define EMULTYPE_VMWARE_GP        (1 << 5)
>>>> +#define EMULTYPE_PARAVIRT_GP        (1 << 5)
>>>> #define EMULTYPE_PF            (1 << 6)
>>>>=20
>>>> int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);=

>>>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>>>> index 581925e476d6..1a2fff4e7140 100644
>>>> --- a/arch/x86/kvm/mmu.h
>>>> +++ b/arch/x86/kvm/mmu.h
>>>> @@ -219,5 +219,6 @@ int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)=
;
>>>>=20
>>>> int kvm_mmu_post_init_vm(struct kvm *kvm);
>>>> void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
>>>> +bool kvm_is_host_reserved_region(u64 gpa);
>>>=20
>>> Just a suggestion: "kvm_gpa_in_host_reserved()" maybe?=20
>>>=20
>>>> #endif
>>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>>> index 6d16481aa29d..c5c4aaf01a1a 100644
>>>> --- a/arch/x86/kvm/mmu/mmu.c
>>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>>> @@ -50,6 +50,7 @@
>>>> #include <asm/io.h>
>>>> #include <asm/vmx.h>
>>>> #include <asm/kvm_page_track.h>
>>>> +#include <asm/e820/api.h>
>>>> #include "trace.h"
>>>>=20
>>>> extern bool itlb_multihit_kvm_mitigation;
>>>> @@ -5675,6 +5676,12 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
>>>> }
>>>> EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
>>>>=20
>>>> +bool kvm_is_host_reserved_region(u64 gpa)
>>>> +{
>>>> +    return e820__mbapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED);
>>>> +}
>>>=20
>>> While _e820__mapped_any()'s doc says '..  checks if any part of the
>>> range <start,end> is mapped ..' it seems to me that the real check is
>>> [start, end) so we should use 'gpa' instead of 'gpa-1', no?
>>=20
>> Why do you need to check GPA at all?
>>=20
> To reduce the scope of the workaround.
>=20
> The errata only happens when you use one of SVM instructions
> in the guest with EAX that happens to be inside one
> of the host reserved memory regions (for example SMM).

This code reduces the scope of the workaround at the cost of increasing the c=
omplexity of the workaround and adding a nonsensical coupling between KVM an=
d host details and adding an export that really doesn=E2=80=99t deserve to b=
e exported.

Is there an actual concrete benefit to this check?

