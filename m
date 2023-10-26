Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8017D7EF8
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 10:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344726AbjJZIyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 04:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbjJZIxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 04:53:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD65110E
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 01:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698310381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=45TxdHDZTwF/Hbp8gcI3F8klG4em/5fkqHd6XDxkSWo=;
        b=T4Hy6ZKKPDddG3sH9rZsxzDEvZakRe12eMqSWg3kbod4v1a+P0M4LzFoTpeW9zxslH2A0d
        xMaqSCSeXehTlnPB8qKcqkRBMzYvOpV2gyibOW78FNTzJxGcX/oqkMwSnBTEbTALVlvGCK
        wx94F2ImXf+bLG7cKBAfEwoonu2hxGE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588--awv4sSQNFSDMynGsexQyg-1; Thu, 26 Oct 2023 04:52:49 -0400
X-MC-Unique: -awv4sSQNFSDMynGsexQyg-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-538128e18e9so437137a12.2
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 01:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698310368; x=1698915168;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:to:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=45TxdHDZTwF/Hbp8gcI3F8klG4em/5fkqHd6XDxkSWo=;
        b=QV/m7Hi3jv/uGMdmdo6xsuZw8TVKg3G0VPNkG52UIhBT0t4yP2+xuvXamlhjG/JS9B
         XcUi57MCSCG1dSfd52Zwh7lQS6JNcjFN0dySMWCXJ8CY/ClFZEW4dgbHs1zFmi9L8Wwi
         SmoVaF8Mpw0kWiYwGWWwbyuBASLVW/uAxaIFGlGavRC1AKHQPM9j6eQRARE7Tj8vHg5k
         MwXGm60t7yc25TM01yEVHmaU9nA8bflirStECfuHWFf4f1330emINpXJOcAYkj+RPswc
         Hc9809e9quoZbWJN6vWUgi0LCtGt2GC85xJ2d6ld0Nlekhjd7ImAONS2tGrFjXBXMkpM
         my5g==
X-Gm-Message-State: AOJu0YxYDjecCe5z+p0jF8DcEHYOdmGHGYwd06Ksb2sG8OhvUNx4L8xd
        qJwEK3r41nDBH7YtUMY4IDbziBh2+LZxFFohlsslTBPELqd8Sk1osKxplzP6jMLpBkdfmOnZD6F
        YljBinqVFVbAb
X-Received: by 2002:a05:6402:11d4:b0:540:b524:5228 with SMTP id j20-20020a05640211d400b00540b5245228mr5796730edw.33.1698310368648;
        Thu, 26 Oct 2023 01:52:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEorT4r2hvRuqos6wUBZrCus/2dNwm0cb2OYKhW0NJ+bBXu0fpPRuH7Sc8r3/sU49UmxkR6KA==
X-Received: by 2002:a05:6402:11d4:b0:540:b524:5228 with SMTP id j20-20020a05640211d400b00540b5245228mr5796723edw.33.1698310368336;
        Thu, 26 Oct 2023 01:52:48 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0053635409213sm11252517edb.34.2023.10.26.01.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 01:52:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before
 kvm_put_nested_state()
In-Reply-To: <78ddc3c3-6cfa-b48c-5d73-903adec6ac4a@linaro.org>
References: <20231026054201.87845-1-eiichi.tsukata@nutanix.com>
 <D761458A-9296-492B-85B9-F196C7D11CDA@nutanix.com>
 <78ddc3c3-6cfa-b48c-5d73-903adec6ac4a@linaro.org>
Date:   Thu, 26 Oct 2023 10:52:46 +0200
Message-ID: <87wmv93gv5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc'ing Max :-) At first glance the condition in vmx_set_nested_state()
is correct so I guess we either have a stale
KVM_STATE_NESTED_RUN_PENDING when in SMM or stale smm.flags when outside
of it...

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Cc'ing Vitaly.
>
> On 26/10/23 07:49, Eiichi Tsukata wrote:
>> Hi all,
>>=20
>> Here is additional details on the issue.
>>=20
>> We've found this issue when testing Windows Virtual Secure Mode (VSM) VM=
s.
>> We sometimes saw live migration failures of VSM-enabled VMs. It turned
>> out that the issue happens during live migration when VMs change boot re=
lated
>> EFI variables (ex: BootOrder, Boot0001).
>> After some debugging, I've found the race I mentioned in the commit mess=
age.
>>=20
>> Symptom
>> =3D=3D=3D=3D=3D=3D=3D
>>=20
>> When it happnes with the latest Qemu which has commit https://github.com=
/qemu/qemu/commit/7191f24c7fcfbc1216d09
>> Qemu shows the following error message on destination.
>>=20
>>    qemu-system-x86_64: Failed to put registers after init: Invalid argum=
ent
>>=20
>> If it happens with older Qemu which doesn't have the commit, then we see=
  CPU dump something like this:
>>=20
>>    KVM internal error. Suberror: 3
>>    extra data[0]: 0x0000000080000b0e
>>    extra data[1]: 0x0000000000000031
>>    extra data[2]: 0x0000000000000683
>>    extra data[3]: 0x000000007f809000
>>    extra data[4]: 0x0000000000000026
>>    RAX=3D0000000000000000 RBX=3D0000000000000000 RCX=3D0000000000000000 =
RDX=3D0000000000000f61
>>    RSI=3D0000000000000000 RDI=3D0000000000000000 RBP=3D0000000000000000 =
RSP=3D0000000000000000
>>    R8 =3D0000000000000000 R9 =3D0000000000000000 R10=3D0000000000000000 =
R11=3D0000000000000000
>>    R12=3D0000000000000000 R13=3D0000000000000000 R14=3D0000000000000000 =
R15=3D0000000000000000
>>    RIP=3D000000000000fff0 RFL=3D00010002 [-------] CPL=3D0 II=3D0 A20=3D=
1 SMM=3D0 HLT=3D0
>>    ES =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
>>    CS =3D0038 0000000000000000 ffffffff 00a09b00 DPL=3D0 CS64 [-RA]
>>    SS =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
>>    DS =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
>>    FS =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
>>    GS =3D0020 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
>>    LDT=3D0000 0000000000000000 ffffffff 00c00000
>>    TR =3D0040 000000007f7df050 00068fff 00808b00 DPL=3D0 TSS64-busy
>>    GDT=3D     000000007f7df000 0000004f
>>    IDT=3D     000000007f836000 000001ff
>>    CR0=3D80010033 CR2=3D000000000000fff0 CR3=3D000000007f809000 CR4=3D00=
000668
>>    DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000 =
DR3=3D0000000000000000    DR6=3D00000000ffff0ff0 DR7=3D0000000000000400
>>    EFER=3D0000000000000d00
>>    Code=3D?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? <?=
?> ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? =
?? ?? ?? ?? ??
>>=20
>> In the above dump, CR3 is pointing to SMRAM region though SMM=3D0.
>>=20
>> Repro
>> =3D=3D=3D=3D=3D
>>=20
>> Repro step is pretty simple.
>>=20
>> * Run SMM enabled Linux guest with secure boot enabled OVMF.
>> * Run the following script in the guest.
>>=20
>>    /usr/libexec/qemu-kvm &
>>    while true
>>    do
>>      efibootmgr -n 1
>>    done
>>=20
>> * Do live migration
>>=20
>> On my environment, live migration fails in 20%.
>>=20
>> VMX specific
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> This issue is VMX sepcific and SVM is not affected as the validation
>> in svm_set_nested_state() is a bit different from VMX one.
>>=20
>> VMX:
>>=20
>>    static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>>                                    struct kvm_nested_state __user *user_=
kvm_nested_state,
>>                                    struct kvm_nested_state *kvm_state)
>>    {
>>    ..           /*             * SMM temporarily disables VMX, so we can=
not be in guest mode,
>>           * nor can VMLAUNCH/VMRESUME be pending.  Outside SMM, SMM flags
>>           * must be zero.
>>           */           if (is_smm(vcpu) ?
>>                  (kvm_state->flags &
>>                   (KVM_STATE_NESTED_GUEST_MODE | KVM_STATE_NESTED_RUN_PE=
NDING))
>>                  : kvm_state->hdr.vmx.smm.flags)
>>                  return -EINVAL;
>>    ..
>>=20
>> SVM:
>>=20
>>    static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>>                                    struct kvm_nested_state __user *user_=
kvm_nested_state,
>>                                    struct kvm_nested_state *kvm_state)
>>    {
>>    ..           /* SMM temporarily disables SVM, so we cannot be in gues=
t mode.  */           if (is_smm(vcpu) && (kvm_state->flags & KVM_STATE_NES=
TED_GUEST_MODE))
>>                  return -EINVAL;
>>    ..
>>=20
>> Thanks,
>>=20
>> Eiichi
>>=20
>>> On Oct 26, 2023, at 14:42, Eiichi Tsukata <eiichi.tsukata@nutanix.com> =
wrote:
>>>
>>> kvm_put_vcpu_events() needs to be called before kvm_put_nested_state()
>>> because vCPU's hflag is referred in KVM vmx_get_nested_state()
>>> validation. Otherwise kvm_put_nested_state() can fail with -EINVAL when
>>> a vCPU is in VMX operation and enters SMM mode. This leads to live
>>> migration failure.
>>>
>>> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
>>> ---
>>> target/i386/kvm/kvm.c | 13 +++++++++----
>>> 1 file changed, 9 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>> index e7c054cc16..cd635c9142 100644
>>> --- a/target/i386/kvm/kvm.c
>>> +++ b/target/i386/kvm/kvm.c
>>> @@ -4741,6 +4741,15 @@ int kvm_arch_put_registers(CPUState *cpu, int le=
vel)
>>>          return ret;
>>>      }
>>>
>>> +    /*
>>> +     * must be before kvm_put_nested_state so that HF_SMM_MASK is set =
during
>>> +     * SMM.
>>> +     */
>>> +    ret =3D kvm_put_vcpu_events(x86_cpu, level);
>>> +    if (ret < 0) {
>>> +        return ret;
>>> +    }
>>> +
>>>      if (level >=3D KVM_PUT_RESET_STATE) {
>>>          ret =3D kvm_put_nested_state(x86_cpu);
>>>          if (ret < 0) {
>>> @@ -4787,10 +4796,6 @@ int kvm_arch_put_registers(CPUState *cpu, int le=
vel)
>>>      if (ret < 0) {
>>>          return ret;
>>>      }
>>> -    ret =3D kvm_put_vcpu_events(x86_cpu, level);
>>> -    if (ret < 0) {
>>> -        return ret;
>>> -    }
>>>      if (level >=3D KVM_PUT_RESET_STATE) {
>>>          ret =3D kvm_put_mp_state(x86_cpu);
>>>          if (ret < 0) {
>>> --=20
>>> 2.41.0
>>>
>>=20
>>=20
>

--=20
Vitaly

