Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B620DBED9B
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 10:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfIZIms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 04:42:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27777 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729582AbfIZImr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 04:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569487366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=1z+xvVMawTHS8E7IV5HtLpWm+mC44JoWwY3oLMaHguc=;
        b=U1hzB8toqKS3xQrWXjoQv0Fh1m4XMcuB6MnPtQs88BX+mfZdPJ+1acX3eTkDAh9FTJy4E7
        0sD8SD3B+geJcXs3qkJYY1nkFagZUAxa993IVehFeolBdVt07mliO3MiWH3tdUKro0+RQH
        sCoGzgudd5FMvMeAYxPVHI5bJ+Ve44w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-F3zZsapnMoCEvDZKldH5Rw-1; Thu, 26 Sep 2019 04:42:41 -0400
Received: by mail-wm1-f72.google.com with SMTP id o8so828740wmc.2
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 01:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o+SEWE7G4AdORNcTi1tw9YQZ4tXXB3xOkXrkeIS3AkM=;
        b=NuThdRPPz2VxGeYc3deADYqfIKcAJzRHCLgSsoGdgi+p7IyY6f5Pgx7iZ2HaNuArMZ
         IdO6MVh4qXtGrkCpfl6AYoNF+CkQNO9pNuTPRkj20/iNFMM+HzO6kNH+rHP6+8cDJqU3
         P7fFK3mDfYgPbibO2jhDaCwjGrgIYGF4wQo52QbIRa77DqI8uuRc8DeafFwE29NQXCUI
         juapvSMZMXv0p4DYg2BrtVFwQJ9OGJVar/+sSFp4qpilPGrNzNbgi+2XAvVf5oHykC0W
         fk8H2T3EEVO/dffKlH88WvJYDWetBusAdlrCQ9K2MTTph+MHZUaw9toQMSDH3trNbQau
         9IyA==
X-Gm-Message-State: APjAAAVQqdm1sCB2phucd4EOex+L8KTCOLtQDnIu3SlFF7p5zmI/CCJV
        nAbY1/yzDUaSnyMb9OO5PowdxJp0jytb3gMixu+OkM3Vm3rMnIpR2M99CH8QNi3kqgQELzbR7Il
        RvX632Ery06NA
X-Received: by 2002:a5d:49c3:: with SMTP id t3mr1846736wrs.151.1569487360022;
        Thu, 26 Sep 2019 01:42:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwBct3zOdHtdxrLlHsSLaUksk4VXWTnA45yCTfyFmUAYZ2XJdu6WLhVoVo+g2mejNtS0AOt3w==
X-Received: by 2002:a5d:49c3:: with SMTP id t3mr1846722wrs.151.1569487359724;
        Thu, 26 Sep 2019 01:42:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id l10sm2461090wrh.20.2019.09.26.01.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:42:39 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: cleanup and fix host 64-bit mode checks
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <1569429286-35157-1-git-send-email-pbonzini@redhat.com>
 <CALMp9eTBPTnsRDipdGDgmugWgfFEjQ2wd_9-JY0ZeM9YG2fBjg@mail.gmail.com>
 <3460bd57-6fdd-f73c-9ce0-c97d4cc85f63@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <1543003a-9a2f-2a52-444a-d55bde6b8e2f@redhat.com>
Date:   Thu, 26 Sep 2019 10:42:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3460bd57-6fdd-f73c-9ce0-c97d4cc85f63@oracle.com>
Content-Language: en-US
X-MC-Unique: F3zZsapnMoCEvDZKldH5Rw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/09/19 01:55, Krish Sadhukhan wrote:
>=20
>=20
> On 09/25/2019 09:47 AM, Jim Mattson wrote:
>> On Wed, Sep 25, 2019 at 9:34 AM Paolo Bonzini <pbonzini@redhat.com>
>> wrote:
>>> KVM was incorrectly checking vmcs12->host_ia32_efer even if the "load
>>> IA32_EFER" exit control was reset.=C2=A0 Also, some checks were not usi=
ng
>>> the new CC macro for tracing.
>>>
>>> Cleanup everything so that the vCPU's 64-bit mode is determined
>>> directly from EFER_LMA and the VMCS checks are based on that, which
>>> matches section 26.2.4 of the SDM.
>>>
>>> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Cc: Jim Mattson <jmattson@google.com>
>>> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>>> Fixes: 5845038c111db27902bc220a4f70070fe945871c
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>> =C2=A0 arch/x86/kvm/vmx/nested.c | 53
>>> ++++++++++++++++++++---------------------------
>>> =C2=A0 1 file changed, 22 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index 70d59d9304f2..e108847f6cf8 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -2664,8 +2664,26 @@ static int nested_vmx_check_host_state(struct
>>> kvm_vcpu *vcpu,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 CC(!kvm_pat_valid(vmcs12->host_ia32_pat)))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ia32e =3D (vmcs12->vm_exit_contro=
ls &
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 VM_EXIT_HOST_ADDR_SPACE_SIZE) !=3D 0;
>>> +#ifdef CONFIG_X86_64
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ia32e =3D !!(vcpu->arch.efer & EF=
ER_LMA);
>>> +#else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (CC(vmcs12->vm_entry_controls =
& VM_ENTRY_IA32E_MODE))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return -EINVAL;
>> This check is redundant, since it is checked in the else block below.
>=20
> Should we be re-using is_long_mode() instead of duplicating the code ?

Of course!  I have already pushed the patch, but I will send a follow up.

Paolo

