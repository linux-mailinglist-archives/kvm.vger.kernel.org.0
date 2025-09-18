Return-Path: <kvm+bounces-58011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52100B853EA
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD190580AC8
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BC72FFFB2;
	Thu, 18 Sep 2025 14:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JFvvwdTS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155AA221F26
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 14:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758205511; cv=none; b=g4kLicK0GPyQcBeRqezrcsmZdzvecLAtFJsbwM4LU0ztapTxF3jxS4U231Ed8dx2Aae3DPlnnY+Qreg+aDrRkTPlxPumk6b+l/vTKDLVSO056blYweWVfG1fvGwYp96SJXDu3qqYNOxsSuMuqH9nfXQKgYATqDsRRnJMPQzg6d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758205511; c=relaxed/simple;
	bh=k2G7vCS/dq3lMHpDvsFlhCHpysVPfG96RFQkuvStkzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S7IPDihjUOZzWVddBgEMbFOLoGDrjeuATeAhtNX1sfud0/5Oh9+Y1x6ZMF6xzuaMmzjqyBkZpSFlJsDVAw6eKdjwFFlxZepyK0OE5Iiv23UznrkHFWv412wAKHDbDwcWHMsE2SlCK+uwwMqn5zQTHw7x+Ohli98SuO0pxbE0n4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JFvvwdTS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758205508;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2G7vCS/dq3lMHpDvsFlhCHpysVPfG96RFQkuvStkzk=;
	b=JFvvwdTS5lnF+WPQv5trUkpk6fzfR3SoDr/XwtTx9fj8veWMF7/jbCuJX070zJGgUyk1Xl
	kCbH4I19KYiOWxDt9S4OpBjGIQcfXZss6o/jD0kg0cNmPcG4dprtKf0NEZkETXGuya9lMx
	tqfUCs0rRbhBkddBS5vVX1+ATJFfjwU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-fQAuo5d_Oty6c0rYgJq80A-1; Thu, 18 Sep 2025 10:25:05 -0400
X-MC-Unique: fQAuo5d_Oty6c0rYgJq80A-1
X-Mimecast-MFC-AGG-ID: fQAuo5d_Oty6c0rYgJq80A_1758205504
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f29c99f99so6236745e9.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 07:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758205504; x=1758810304;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k2G7vCS/dq3lMHpDvsFlhCHpysVPfG96RFQkuvStkzk=;
        b=JcFJcAqfD3dTGNZuZsXJxNOITaHc8Lbk7aqeU+oAgIoN8TrSbLwe/PsOgeGWGrguwm
         Pn5eJh1Nu/oRPSAtLeNVkyUbcR4dAUgRAI5gHUStWGs8jNFc9nn426q6JfLshJaX6Y6D
         S2kAo0iyT+x0VONl4dEpdNRzV3d8xGXPEp6UH6APg8xeeHFg4tOMiC6aZnSrQucmQPTq
         pGLF5IcpciEog/dOncMPRVxylWeTUCo4aZrKhi7ZsXqVxTp0DKiOfc4IbiggI5wsJUFp
         VgWtTPayEjZB68QxYyBouxQjx1PokP7J988qoTesaTDJyprWAedz7GWMAl0AujRpe9Ro
         j7Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXEyIiQlAN6Sx+yBACXRGHqToe9vfoqIgJhgJsMP+MiVALIPjaOJGUTobAOiOt8ngBRWEc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQSj7dnV0Paohwt2p1EKpc7Owyq7EzgiVAKRBoVJOZH/RthvzM
	H8x+Ial9AKjUww3im+nJvNM0S/zc5+1oi4L36RKImbDTvwXbnTpYbsesdVE4jjOH9tEf0oqG3sI
	/X9bi4Ov+4dXOmkOpvQiL4OkdxMPYrJgaJijwXSjljBJPUgH1/O7gUA==
X-Gm-Gg: ASbGnctxp21k1RM7vAEAFgHW3lFB+lSzOn6Fn7loChL4lTejlnb5HshczJeYAX8LqWR
	iq58fh2lunsMJo3o1OEsmWFdbjkJm+czvltQK9tktIPeUPc60ZYwk2DElay/r0l2z7ZrlJMAKtZ
	WamdHn/E23kdbb9VD98ZpMDB3CAC6UBWd4/wZglAJL0qyjDw/DZSycOivuz8Gd9sJeSwBn+07B4
	13WRtvi6o8PmjL+CWn2tlCJDHQdcKmniadVnLnd75CHIwHeMFK+tQPTiLsjZOWUYjRAcFXNwLvc
	VQj0bav87HjEIGMZ6JTUoa2+rGndSf3thvZuX4ctPDN1JIXoMoaln4ih+NAH+rBfE9KYVYS7Yb6
	CAbFXei6vWGo=
X-Received: by 2002:a05:600c:4eca:b0:45b:79fd:cb3d with SMTP id 5b1f17b1804b1-4634c528acamr46109935e9.36.1758205504148;
        Thu, 18 Sep 2025 07:25:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMq4Lq58qPJkEx6oekmJdG1VjWks1gpE5xrvTqloRglPEvekf9jxRLASR2o5eHIbj094/fAw==
X-Received: by 2002:a05:600c:4eca:b0:45b:79fd:cb3d with SMTP id 5b1f17b1804b1-4634c528acamr46109655e9.36.1758205503707;
        Thu, 18 Sep 2025 07:25:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f64ad359sm52761595e9.22.2025.09.18.07.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 07:25:03 -0700 (PDT)
Message-ID: <60b78889-79b6-4efd-aacf-48e7b9456db2@redhat.com>
Date: Thu, 18 Sep 2025 16:25:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Cornelia Huck <cohuck@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com>
 <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
 <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com>
 <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
 <3176813f-77c0-4c39-b363-11af3b181217@redhat.com>
 <CAFEAcA_ui7iyKx36fuhmOqizRWnNppb9B1iPc4nAxU2VnovMOQ@mail.gmail.com>
 <6f1eb1b8-29d4-cdcb-f379-9869d806a116@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <6f1eb1b8-29d4-cdcb-f379-9869d806a116@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Peter,

On 9/11/25 6:46 PM, Sebastian Ott wrote:
> On Thu, 11 Sep 2025, Peter Maydell wrote:
>> On Thu, 11 Sept 2025 at 17:29, Sebastian Ott <sebott@redhat.com> wrote:
>>>
>>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>>> On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com>
>>>> wrote:
>>>>>
>>>>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>>>>> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com>
>>>>>> wrote:
>>>>>>>
>>>>>>> This series adds a vcpu knob to request a specific PSCI version
>>>>>>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>>>>>>>
>>>>>>> Note: in order to support PSCI v0.1 we need to drop vcpu
>>>>>>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>>>>> Alternatively we could limit support to versions >=0.2 .
>>>>>>>
>>>>>>> Sebastian Ott (2):
>>>>>>>   target/arm/kvm: add constants for new PSCI versions
>>>>>>>   target/arm/kvm: add kvm-psci-version vcpu property
>>>>>>
>>>>>> Could we have some rationale, please? What's the use case
>>>>>> where you might need to specify a particular PSCI version?
>>>>>
>>>>> The use case is migrating between different host kernel versions.
>>>>> Per default the kernel reports the latest PSCI version in the
>>>>> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
>>>>> when that differs between source and target a migration will fail.
>>>>>
>>>>> This property allows to request a PSCI version that is supported by
>>>>> both sides. Specifically I want to support migration between host
>>>>> kernels with and without the following Linux commit:
>>>>>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3
>>>>
>>>> So if the destination kernel is post that commit and the
>>>> source kernel pre-dates it, do we fail migration?
>>>
>>> This case works with current qemu without any changes, since on
>>> target qemu would write the register value it has stored from
>>> the source side (QEMU_PSCI_VERSION_1_1) and thus requests kvm
>>> on target to emulate that version.
>>>
>>>> Or is
>>>> this only a migration failure when the destination doesn't
>>>> support the PSCI version we defaulted to at the source end?
>>>
>>> Yes, this doesn't work with current qemu. On target qemu would
>>> write QEMU_PSCI_VERSION_1_3 to the KVM_REG_ARM_PSCI_VERSION
>>> register but that kernel doesn't know this version and the
>>> migration will fail.
>>
>> I was under the impression that trying to migrate backwards
>> from a newer kernel to an older one was likely to fail
>> for various reasons (notably "new kernel reports a new
>> system register the old one doesn't") ?  Perhaps we should
>> think about the problem in a wider scope than just the
>> PSCI version...
>
> Yes we already are ;-) See this series from Cornelia:
> https://lore.kernel.org/qemu-devel/20250414163849.321857-1-cohuck@redhat.com/
>
>
> And this from Eric:
> https://lore.kernel.org/qemu-devel/20250911134324.3702720-1-eric.auger@redhat.com/
>
the above series especially handles a class of migration errors where
the source host kernel exposes more KVM regs to userspace than
destination host kernel. In that case, currently, the vcpu state cannot
be migrated. I should have called that: mitigation of* "failed to load
cpu:cpreg_vmstate_array_len" migration errors. Sebastian tries to handle
a change in the default value of a pseudo FW register. We would like to
have a compat to keep the old value for old machine types. Thanks Eric *
>
> Both will help mitigate register differences for a backwards/downgrade
> migration.
>
> Sebastian
>


