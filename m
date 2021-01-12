Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226652F34A9
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 16:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392073AbhALPwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 10:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392062AbhALPwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 10:52:03 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B404C061794
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 07:51:23 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id b3so1285969pft.3
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 07:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=meDQXX3XD75fr/Eh+OZMYbgkflSWbsrFgrToIxKFeB8=;
        b=RZrg0tk6bQj6DM1AY7MNXKv0DnzfmYK79bq8YdEH9FgAWrXF1PWqAgRIuyDTG2x1Ue
         Kq7t8LhYNncsed4/aJtjfDjt5Q+/IDfcIfj4z8vImrp9Unrey24ogvuDw6mWPO57GOiY
         mUeWmw3DU9OI1VrqFTdtR5xqdIGczh/qwfRsIAWMjWXwc9A7IcVBfOCWjcsHORg96squ
         rfls/Pd0lBtrHN8nyBh9tFE0xy38qWk5fl+z7ZDxucHiM+mFW/NyPqb2DBv3b7YeGoM0
         Va7/xZNPnjH9fPd5Avq8igc18BEEpC2bEm/kD4ijfDtA17nBo+jSxSDp1xC0AtPa/5vW
         eAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=meDQXX3XD75fr/Eh+OZMYbgkflSWbsrFgrToIxKFeB8=;
        b=aDIVBbySu+m4WevofbyX4/YvKmjkDB3XkAVTAQ6wBAEfy9LRpMvRDW4GG0hCoJs/KW
         1BCuKYv92HBwOeINChSiLUzlAuoBGWPKk85ABOixif1OJtbOWb4DIsrD9SBUDe04b3Gt
         KiN8q1aMKQGh4Z103MlFC9zSLsYdL+8SKtwMb1R6Mtts5A+Xcs5XQ98ynmeJVCzLi1nZ
         LaPyaeH2aYgu3DMX8gpwKy0vr7Tjse+WmZ4u1xnf8KDHoEzDD7YNBRdvk+tzSvX4S01n
         f+8N9UHW2+19UYEQg9tH0beH/T/TP/Jf3cUd6/JAUo8seqbpxBvtuQVBNrzDiD1ElBzr
         e2jA==
X-Gm-Message-State: AOAM533dzi12UlS1g03+slvYuJ0UT4ZaoBPjDQr8eVIydBQeUhMRjBH7
        cf1ADJ94ssdeGvvnteTdw397zw==
X-Google-Smtp-Source: ABdhPJwa0jFvja1e809QMhaIsVsedI0V1Nmc2CmTBYN6vm75qgQa7r6ag6ohSpXAYbQeMQ/UZSWv9A==
X-Received: by 2002:a63:2347:: with SMTP id u7mr5279301pgm.189.1610466682707;
        Tue, 12 Jan 2021 07:51:22 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:1d60:88a3:44d6:6b86? ([2601:646:c200:1ef2:1d60:88a3:44d6:6b86])
        by smtp.gmail.com with ESMTPSA id k15sm3625781pfp.115.2021.01.12.07.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 07:51:21 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by VM instructions
Date:   Tue, 12 Jan 2021 07:51:19 -0800
Message-Id: <8FAC639B-5EC6-42EE-B886-33AEF3CD5E26@amacapital.net>
References: <jpgturmgnu6.fsf@linux.bootlegged.copy>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, dgilbert@redhat.com
In-Reply-To: <jpgturmgnu6.fsf@linux.bootlegged.copy>
To:     Bandan Das <bsd@redhat.com>
X-Mailer: iPhone Mail (18C66)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Jan 12, 2021, at 7:46 AM, Bandan Das <bsd@redhat.com> wrote:
>=20
> =EF=BB=BFAndy Lutomirski <luto@amacapital.net> writes:
> ...
>>>>>> #endif diff --git a/arch/x86/kvm/mmu/mmu.c
>>>>>> b/arch/x86/kvm/mmu/mmu.c index 6d16481aa29d..c5c4aaf01a1a 100644
>>>>>> --- a/arch/x86/kvm/mmu/mmu.c +++ b/arch/x86/kvm/mmu/mmu.c @@
>>>>>> -50,6 +50,7 @@ #include <asm/io.h> #include <asm/vmx.h> #include
>>>>>> <asm/kvm_page_track.h> +#include <asm/e820/api.h> #include
>>>>>> "trace.h"
>>>>>>=20
>>>>>> extern bool itlb_multihit_kvm_mitigation; @@ -5675,6 +5676,12 @@
>>>>>> void kvm_mmu_slot_set_dirty(struct kvm *kvm, }
>>>>>> EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
>>>>>>=20
>>>>>> +bool kvm_is_host_reserved_region(u64 gpa) +{ + return
>>>>>> e820__mbapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED); +}
>>>>> While _e820__mapped_any()'s doc says '..  checks if any part of
>>>>> the range <start,end> is mapped ..' it seems to me that the real
>>>>> check is [start, end) so we should use 'gpa' instead of 'gpa-1',
>>>>> no?
>>>> Why do you need to check GPA at all?
>>>>=20
>>> To reduce the scope of the workaround.
>>>=20
>>> The errata only happens when you use one of SVM instructions in the
>>> guest with EAX that happens to be inside one of the host reserved
>>> memory regions (for example SMM).
>>=20
>> This code reduces the scope of the workaround at the cost of
>> increasing the complexity of the workaround and adding a nonsensical
>> coupling between KVM and host details and adding an export that really
>> doesn=E2=80=99t deserve to be exported.
>>=20
>> Is there an actual concrete benefit to this check?
>=20
> Besides reducing the scope, my intention for the check was that we should
> know if such exceptions occur for any other undiscovered reasons with othe=
r
> memory types rather than hiding them under this workaround.

Ask AMD?

I would also believe that someone somewhere has a firmware that simply omits=
 the problematic region instead of listing it as reserved.

>=20
> Bandan
>=20
>=20
>=20
