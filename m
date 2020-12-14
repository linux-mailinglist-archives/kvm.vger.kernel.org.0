Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37AE2DA39C
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 23:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441214AbgLNWo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 17:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441217AbgLNWoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 17:44:39 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D143C061793
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 14:43:59 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id f9so13159957pfc.11
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 14:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:mime-version:subject:from:in-reply-to:cc
         :date:message-id:references:to;
        bh=d1RpYyJlLKZ1G7PiLxEKJrkYECxvaeYUzXG4j/stqFQ=;
        b=vkQF46i4pBr/22TElfK3oU3WZtmYA344Kt6QcRF4U5wvApHLN910+V5HeQydHVtDxk
         crj3iaiy/4HTDDKR3PCessAM+F1NBasKB5HRwRypZlTHTzYcCQYgFR1HYMdiv9SCOz9O
         FswlJP63/zm7GWnpYu48cDG69NMrQSI6jYPuOac4jZKrSKzzpxd0Mdm0eeT8ytkHngH/
         MXC1G164JVhlfPBx2KNDUo2oK5FRM73eJKcehPpvkgE2QIPbfksRSQMx0LK6reldMqlB
         2/H4kZpPd7FDoYI1hbvJMt1kU2jcEvQSVzOKhV6V128ZbWx85guvLPzU6XZ2qai3VBYl
         hGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:mime-version:subject
         :from:in-reply-to:cc:date:message-id:references:to;
        bh=d1RpYyJlLKZ1G7PiLxEKJrkYECxvaeYUzXG4j/stqFQ=;
        b=EMwa2su/GsmwYQdc2lEzigZZ/sosKueNnzD2o8R1iPXgd5lMzXYL1SzStyouuajbWv
         hfnhi6GGaou9zTKDOwQm/0sSgJqWmGqtoAnI5viC/+Yuk8Wu4wbPiUbEoBmtaO1WQM6k
         zFdvHlA4Z8bU21PAGMHtbxXQjHUSnO4nJnFXyZgSEF93/aawiOV3hKewpGr1Q/9zSWf+
         1ctd+adj6u8hXm1mOKETlEjRq/qJmIYrbFrKPdQKq+DwlyYjfFtZQFzt5mEItPzFWv8P
         /i+rhXRjyJy5mkNih0NvI692eStTxexT6bQFt59q3mYWGclR0mxM15CqFy0aZcKFiAWr
         sHjQ==
X-Gm-Message-State: AOAM532bT7nPuszzUqAaOV9ZT82xpoo452+I9ktF1+bzEX7+tTgOdQGO
        PiiF9zUyKXJuEIQO4qncZ8qNtg==
X-Google-Smtp-Source: ABdhPJxj963by90RFaoNCtlLJHMnbw7gJis5f7Cm1kDhLiYHFQBUkOSAniZ1BAdaJaS+hbHxsAPyDw==
X-Received: by 2002:a63:5114:: with SMTP id f20mr24115206pgb.5.1607985838832;
        Mon, 14 Dec 2020 14:43:58 -0800 (PST)
Received: from ?IPv6:2600:1010:b003:ccf3:e5ce:e2e9:721a:7c07? ([2600:1010:b003:ccf3:e5ce:e2e9:721a:7c07])
        by smtp.gmail.com with ESMTPSA id i184sm2431706pfe.126.2020.12.14.14.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 14:43:58 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring additional host state
From:   Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20201214220213.np7ytcxmm6xcyllm@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Date:   Mon, 14 Dec 2020 14:29:46 -0800
Message-Id: <98F09A9A-A768-4B01-A1FA-5EE681146BC5@amacapital.net>
References: <20201214220213.np7ytcxmm6xcyllm@amd.com>
To:     Michael Roth <michael.roth@amd.com>
X-Mailer: iPhone Mail (18B121)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Dec 14, 2020, at 2:02 PM, Michael Roth <michael.roth@amd.com> wrote:
>=20
> =EF=BB=BFOn Mon, Dec 14, 2020 at 11:38:23AM -0800, Sean Christopherson wro=
te:
>> +Andy, who provided a lot of feedback on v1.
>> On Mon, Dec 14, 2020, Michael Roth wrote:
>> Cc: Andy Lutomirski <luto@kernel.org>
>>> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> ---
>>> v2:
>>> * rebase on latest kvm/next
>>> * move VMLOAD to just after vmexit so we can use it to handle all FS/GS
>>> host state restoration and rather than relying on loadsegment() and
>>> explicit write to MSR_GS_BASE (Andy)
>>> * drop 'host' field from struct vcpu_svm since it is no longer needed
>>> for storing FS/GS/LDT state (Andy)
>>> ---
>>> arch/x86/kvm/svm/svm.c | 44 ++++++++++++++++--------------------------
>>> arch/x86/kvm/svm/svm.h | 14 +++-----------
>>> 2 files changed, 20 insertions(+), 38 deletions(-)
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index 0e52fac4f5ae..fb15b7bd461f 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -1367,15 +1367,19 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu,=
 int cpu)
>>>       vmcb_mark_all_dirty(svm->vmcb);
>>>   }
>>> -#ifdef CONFIG_X86_64
>>> -    rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
>>> -#endif
>>> -    savesegment(fs, svm->host.fs);
>>> -    savesegment(gs, svm->host.gs);
>>> -    svm->host.ldt =3D kvm_read_ldt();
>>> -
>>> -    for (i =3D 0; i < NR_HOST_SAVE_USER_MSRS; i++)
>>> +    for (i =3D 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
>>>       rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
>>> +    }
>=20
> Hi Sean,
>=20
> Hopefully I've got my email situation sorted out now...
>=20
>> Unnecessary change that violates preferred coding style.  Checkpatch expl=
icitly
>> complains about this.
>> WARNING: braces {} are not necessary for single statement blocks
>> #132: FILE: arch/x86/kvm/svm/svm.c:1370:
>> +    for (i =3D 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
>>       rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
>> +
>=20
> Sorry, that was an artifact from an earlier version of the patch that I
> failed to notice. I'll make sure to run everything through checkpatch
> going forward.
>=20
>>> +
>>> +    asm volatile(__ex("vmsave")
>>> +             : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT)
>> I'm pretty sure this can be page_to_phys().
>>> +             : "memory");
>> I think we can defer this until we're actually planning on running the gu=
est,
>> i.e. put this in svm_prepare_guest_switch().
>=20
> One downside to that is that we'd need to do the VMSAVE on every
> iteration of vcpu_run(), as opposed to just once when we enter from
> userspace via KVM_RUN. It ends up being a similar situation to Andy's
> earlier suggestion of moving VMLOAD just after vmexit, but in that case
> we were able to remove an MSR write to MSR_GS_BASE, which cancelled out
> the overhead, but in this case I think it could only cost us extra.

If you want to micro-optimize, there is a trick you could play: use WRGSBASE=
 if available.  If X86_FEATURE_GSBASE is available, you could use WRGSBASE t=
o restore GSBASE and defer VMLOAD to vcpu_put().  This would need benchmarki=
ng on Zen 3 to see if it=E2=80=99s worthwhile.


