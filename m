Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E692F3491
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 16:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404987AbhALPsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 10:48:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405525AbhALPsB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 10:48:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610466395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4jiwV7AuQsPxZcRY14JFnrQvYVeLgEnELmlaS2CrL8E=;
        b=dfjezba+UybJ3R6oxVTWw4MebYES/iVLJ/8eLhCtcEbc8Wm9NjWUnoOjDamEDM/+9JumP9
        UlUVS3gxcxF6oNVtKVOjIpWXyRkxmdIJtFDuuDDL+HSqfJlNU1bkCfD9q7hOvOEAB8K86J
        1gBB9qh1uNLYPb8AL1cqGvRPuIptiV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-vobvzLUAPUyzqf0r_KCbag-1; Tue, 12 Jan 2021 10:46:31 -0500
X-MC-Unique: vobvzLUAPUyzqf0r_KCbag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95388100C66E;
        Tue, 12 Jan 2021 15:46:27 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DBC8077BF5;
        Tue, 12 Jan 2021 15:46:25 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, joro@8bytes.org, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        jmattson@google.com, wanpengli@tencent.com, dgilbert@redhat.com
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by VM instructions
References: <9f3b8e3dca453c13867c5c6b61645b9b58d68f61.camel@redhat.com>
        <C121813D-BD61-4C78-9169-8F8FCC1356D7@amacapital.net>
Date:   Tue, 12 Jan 2021 10:46:25 -0500
In-Reply-To: <C121813D-BD61-4C78-9169-8F8FCC1356D7@amacapital.net> (Andy
        Lutomirski's message of "Tue, 12 Jan 2021 07:22:41 -0800")
Message-ID: <jpgturmgnu6.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:
...
>>>>> #endif diff --git a/arch/x86/kvm/mmu/mmu.c
>>>>> b/arch/x86/kvm/mmu/mmu.c index 6d16481aa29d..c5c4aaf01a1a 100644
>>>>> --- a/arch/x86/kvm/mmu/mmu.c +++ b/arch/x86/kvm/mmu/mmu.c @@
>>>>> -50,6 +50,7 @@ #include <asm/io.h> #include <asm/vmx.h> #include
>>>>> <asm/kvm_page_track.h> +#include <asm/e820/api.h> #include
>>>>> "trace.h"
>>>>>=20
>>>>> extern bool itlb_multihit_kvm_mitigation; @@ -5675,6 +5676,12 @@
>>>>> void kvm_mmu_slot_set_dirty(struct kvm *kvm, }
>>>>> EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
>>>>>=20
>>>>> +bool kvm_is_host_reserved_region(u64 gpa) +{ + return
>>>>> e820__mbapped_raw_any(gpa-1, gpa+1, E820_TYPE_RESERVED); +}
>>>>  While _e820__mapped_any()'s doc says '..  checks if any part of
>>>> the range <start,end> is mapped ..' it seems to me that the real
>>>> check is [start, end) so we should use 'gpa' instead of 'gpa-1',
>>>> no?
>>>  Why do you need to check GPA at all?
>>>=20
>> To reduce the scope of the workaround.
>>=20
>> The errata only happens when you use one of SVM instructions in the
>> guest with EAX that happens to be inside one of the host reserved
>> memory regions (for example SMM).
>
> This code reduces the scope of the workaround at the cost of
> increasing the complexity of the workaround and adding a nonsensical
> coupling between KVM and host details and adding an export that really
> doesn=E2=80=99t deserve to be exported.
>
> Is there an actual concrete benefit to this check?

Besides reducing the scope, my intention for the check was that we should
know if such exceptions occur for any other undiscovered reasons with other
memory types rather than hiding them under this workaround.

Bandan



