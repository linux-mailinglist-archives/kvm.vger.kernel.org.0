Return-Path: <kvm+bounces-57338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0ACB5395B
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 01515B657B4
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B490335A2BF;
	Thu, 11 Sep 2025 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q2xi9i6J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFD435337E
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 16:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608153; cv=none; b=OY9cA+P5tyWBRA3eghnviwWLIWYhnP3QffOmAT35519bNV5rRoiKGjnPOndjH200GQ94n3rmDWngz0wVBMjzTB5k8yfyznc8cLB9+5AYHuxZeBFaRraH3GD1ourMRcjqMvzpAa6Iw71LtufyuYFFo8FzWfuDE8xLoBqV3Bcrmig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608153; c=relaxed/simple;
	bh=jWqECjnzNNEBJVb6hoiDTVqP5vpjQCwqoIckY4xgjR8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kjjpaTH0m5cptO3Enz/ysj4ZKwohNIE++Uj49Hm6X/jjb5RxLSwDqKiCW1B2J89jTI4zxgf7P0tfoP2X/QI2muuyxPfEgTeUUUyp8NqZRxVndN/o8W4prOR7aM+VdgDZxGCCPrxVC78yaCB7EF1Us81Ak5+RwPn3jHm22Nz6fVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q2xi9i6J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757608150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6IfJq0PeXXpJnmQfIgkF/V+uc6bP+zPZYW7h5in2crk=;
	b=Q2xi9i6JdJXnP4/P2W7XOnlydwQom+rxaiqinDFZmKaerFNqdui5v5s0ne8pv/PS06FlSY
	fHfCnpB6Q0nNUtAS0VRwA7MtoZ5iiuQ+K0EtG1bc1tnED2T3Tlf8b/HKrHmm8l6YbjNOiC
	kiD9gpN1xTyYzMVjHcWizlwi60SyP7k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-jic37rKePb-wXZCNU-UN5A-1; Thu, 11 Sep 2025 12:29:09 -0400
X-MC-Unique: jic37rKePb-wXZCNU-UN5A-1
X-Mimecast-MFC-AGG-ID: jic37rKePb-wXZCNU-UN5A_1757608149
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45df9e11fc6so5995065e9.3
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 09:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757608148; x=1758212948;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6IfJq0PeXXpJnmQfIgkF/V+uc6bP+zPZYW7h5in2crk=;
        b=HunG9T0YTPsDN1Rit2+wICNLg8hKbtNoFlbRJdeXurXBGYATFe4nzhEsDNvR+L2/NS
         MVeSNqGMbSYfU+YLnICoZRDQIfiSYHVO0d1i23EJyZnwxyIxeoS724PfE8FbDWPi7Gv0
         o01Ea+kviTZKKVe5fDqu2NNaaEb91XyTIkJrw3zffrAPb2KRUDf4Ys9GGp7Cmm25zGF3
         6DA6w9nlvO8bVoX38a/oDIo9BPpZaAuENDz6KhIZa1okLl8+JbQW2EY6LYPCmWz1kJHC
         aXjPNqF2ZFeGEKhkjbTm52htP9O5gBLwhrQGk/SVkeLeCKISGYsDZ0ks3hfRbQTEjxwT
         eqeA==
X-Forwarded-Encrypted: i=1; AJvYcCWNGox/D9VmR+/jOYEYh8hZPPpuhL2zsyGF4H23QOVcQvUD6Ug+wYV56T1N3TO9T+t6nak=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0qtaaLcO+WYLF5XozUE3k362ODUTrLmL0LRiLCOhRY+hpU5+5
	jX5/Wz+dBO4CkEZ77pzUIZU0cLLZfKwHhxa3cfS/NysTDJuM80Cb5/IYgiR5Lz+wP64yPTww2kH
	XS+c1Ic8ZxAnf59Uy2MKLb55ppb+dAuRU8iZamygYsuzPn/Kl7DDJJwKivSsKGg==
X-Gm-Gg: ASbGncvqHR2/jSLkurcaIEIVgArguirXs488blZa2kzKYINTq2wbObMw3mah1WD77T3
	FOGe7XK8GO8z364tavNJ2Dl/dFa2z/jBkr8halovvhZenwSkhYs+vq/AE3Gg1y6hDUB618ioYBo
	Yi+YWSgVDc0SuNA6wpVqm6qDFd1w0QBAInBGJvogj+0UnrkUMCIT/V+N2PpHAt8fNmnmbbDR0Z8
	aKaFsAfqzGoNPH5qp02xjgywDHCsw5zLwOtsUaKIOz/HzYxBFXBzfegl9IWpbglJmZWZGy7lndu
	TJU9USI8HNm/6q1wOAeQ+8lFU6asd6xbBcTSnhg5qywbmAc6nopPFmWfn8hOEA5PEOhak7cGJ1A
	ZuBlLYsvUZ7EsEA==
X-Received: by 2002:a05:600c:5248:b0:45d:d9ab:b85a with SMTP id 5b1f17b1804b1-45f211e520bmr865635e9.7.1757608148304;
        Thu, 11 Sep 2025 09:29:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGY6150HoCh3FfRYfRTEKIcW5EuOXujbRibT3SZGb6KEdyz/nOArM0wpiCpufKuF5ucxLYIpw==
X-Received: by 2002:a05:600c:5248:b0:45d:d9ab:b85a with SMTP id 5b1f17b1804b1-45f211e520bmr865075e9.7.1757608147817;
        Thu, 11 Sep 2025 09:29:07 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037b9ebbsm31717955e9.11.2025.09.11.09.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 09:29:07 -0700 (PDT)
Date: Thu, 11 Sep 2025 18:29:06 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
In-Reply-To: <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
Message-ID: <3176813f-77c0-4c39-b363-11af3b181217@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com> <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com> <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 11 Sep 2025, Peter Maydell wrote:
> On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>>>>
>>>> This series adds a vcpu knob to request a specific PSCI version
>>>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>>>>
>>>> Note: in order to support PSCI v0.1 we need to drop vcpu
>>>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>> Alternatively we could limit support to versions >=0.2 .
>>>>
>>>> Sebastian Ott (2):
>>>>   target/arm/kvm: add constants for new PSCI versions
>>>>   target/arm/kvm: add kvm-psci-version vcpu property
>>>
>>> Could we have some rationale, please? What's the use case
>>> where you might need to specify a particular PSCI version?
>>
>> The use case is migrating between different host kernel versions.
>> Per default the kernel reports the latest PSCI version in the
>> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
>> when that differs between source and target a migration will fail.
>>
>> This property allows to request a PSCI version that is supported by
>> both sides. Specifically I want to support migration between host
>> kernels with and without the following Linux commit:
>>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3
>
> So if the destination kernel is post that commit and the
> source kernel pre-dates it, do we fail migration?

This case works with current qemu without any changes, since on
target qemu would write the register value it has stored from
the source side (QEMU_PSCI_VERSION_1_1) and thus requests kvm
on target to emulate that version.

> Or is
> this only a migration failure when the destination doesn't
> support the PSCI version we defaulted to at the source end?

Yes, this doesn't work with current qemu. On target qemu would
write QEMU_PSCI_VERSION_1_3 to the KVM_REG_ARM_PSCI_VERSION
register but that kernel doesn't know this version and the
migration will fail.

With this series you could request QEMU_PSCI_VERSION_1_1 on
the source kernel to allow a migration.

(For RHEL we have distro specific machine types that will
use this property to handle that via compats.)

Sebastian


