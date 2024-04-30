Return-Path: <kvm+bounces-16223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 402428B6CCE
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 10:28:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 015C028485F
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 08:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC59A7F47A;
	Tue, 30 Apr 2024 08:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xi2waDr7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CF874E11
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 08:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714465725; cv=none; b=oC8QutZNTbeoPUsZJXrh9rOHv/ZUVBmly5kupJjtfEE4iWIxNSZRPXdE8b1kJaAqjCSNzNATDpYKZJh8MBtAadMJCcCQO3UK+SaxbRYC9Gk1uYidwwJJWdsdocHU4qvst4DYFD1XCSJ9UQaifuACN7D3FLFc2fTyE1tqwJp7ktw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714465725; c=relaxed/simple;
	bh=FIVt1DIdEsgu+/mPafE+rcE2Hrwd/lbKA9MXwTYySQY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=HPbVbJyJn0RKrr0ZV3ZkMPVS7uqmFDpNYzXnGukoJ3oY1AAyDT9PPOHiL8hHRofV/pm/KQX56WhgZtInUWAoNcwY92ZB9ZP9OAmzeiQZSh9tjCeuZrhGNPE20vorwMLMD5jeYSaJpmAZEYyhVw5l2K8HRvmREO5nOW8us9Z25JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xi2waDr7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714465723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qWhc0CpWpoN7BapWLkydzM5oRjm4NkYTj+vkRyutCqw=;
	b=Xi2waDr7nQbYdvRX8Ti9+CYXApiRUJraUOHuF/Jzqwp9/utOvjlPsTdull7LnGz/2WuxZI
	uB7J6yXyM83uW5n8+GRrpfhBZZfCCcxvDwqE3LtbSU9nE/AKP07k22DwyONn+CmRZcev/j
	IQrD7+TU/LIIsWsdo70PChJJA8ih6Dg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-6YqPiZokMT20U1fo0xkLiw-1; Tue, 30 Apr 2024 04:28:39 -0400
X-MC-Unique: 6YqPiZokMT20U1fo0xkLiw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a4455ae71fcso295394766b.3
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 01:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714465718; x=1715070518;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qWhc0CpWpoN7BapWLkydzM5oRjm4NkYTj+vkRyutCqw=;
        b=Lz/KDvcMupu8CUSUIG51+tcH3VBnhqywJoiT/5f7aKBwXZC3G9XNhnii4672VC+/5o
         w85V31PxIyMKcqbgRRlXXofdfO3vnu3rPxTwEaCp8P3pVGRR5Ga7cRKknzd/db4mJO99
         6gwcWGLBInzMXnu9/gl19poNBnCPo4CJYOAPfx+s4kY9swUoVvDORucVSbyjqYsMosh/
         ES9GDjL42fv9Cw47sLi1FV01xAwQQRiYA0GO5taE6wucj3M8UvU+iBdH1a/eanFxX0dP
         FsS5brzio2N6De5tss2zfW+xzDGoBMGFhY3b6FzWecWitQnipY9KrC/JlUxCpeyHnrTX
         pgoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSXxmT0LWAjYYE1HHXOaEOf2/CWRQCZWL0VDndY/ViLJICpKY4WUDJ5UXaPBiUcvAvRWBntrU2sTx9srG8JqDwg3bS
X-Gm-Message-State: AOJu0YzbTd1LiBm+l0SC+wAC1oqTtYrC4C+DigrLt7WA29Zpd3VO7ZvU
	K1j5fJuAwC2eDjtmXBkBOzOD9pvujzuF/nQ4gBqrP8bRsKh6iRy2GLFlW6jYnsJXmHBlIS5ska8
	GrGrM0jlnKDaSQmeZZQonMnEyxtn02FJFcJr3tkjd84c8X9b4AQ==
X-Received: by 2002:a17:906:c0c9:b0:a58:e10b:6d72 with SMTP id bn9-20020a170906c0c900b00a58e10b6d72mr7297420ejb.75.1714465718047;
        Tue, 30 Apr 2024 01:28:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDZu4JzAKoo43Qd/YU/l0mPuHSFU/feEUQjApeE3UP63GHF3sHOztakznkFanzYyaZuQkDEg==
X-Received: by 2002:a17:906:c0c9:b0:a58:e10b:6d72 with SMTP id bn9-20020a170906c0c900b00a58e10b6d72mr7297398ejb.75.1714465717664;
        Tue, 30 Apr 2024 01:28:37 -0700 (PDT)
Received: from [127.0.0.1] (93-36-28-107.ip58.fastwebnet.it. [93.36.28.107])
        by smtp.gmail.com with ESMTPSA id n21-20020a170906725500b00a58f498ed33sm3062077ejk.134.2024.04.30.01.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 01:28:37 -0700 (PDT)
Date: Tue, 30 Apr 2024 10:28:32 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Dmitry Vyukov <dvyukov@google.com>, James Morse <james.morse@arm.com>,
 Alexander Potapenko <glider@google.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.9, part #2
User-Agent: K-9 Mail for Android
In-Reply-To: <ZjCo1Qj4k-mbNXtD@linux.dev>
References: <ZilgAmeusaMd_UeZ@linux.dev> <ZjCo1Qj4k-mbNXtD@linux.dev>
Message-ID: <D49302F0-B184-416D-AB26-49C5F14A1D94@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

I was on vacation, and unfortunately I saw it pretty much the day I left h=
ome=2E I will get it to Linus this afternoon=2E

Paolo

Il 30 aprile 2024 10:16:21 CEST, Oliver Upton <oliver=2Eupton@linux=2Edev>=
 ha scritto:
>On Wed, Apr 24, 2024 at 12:39:46PM -0700, Oliver Upton wrote:
>> Hi Paolo,
>>=20
>> Single fix this time around for a rather straightforward NULL
>> dereference in one of the vgic ioctls, along with a reproducer I've
>> added as a testcase in selftests=2E
>>=20
>> Please pull=2E
>
>Nudging this, Paolo do you plan to pick this up or shall I make other
>arrangements for getting this in?
>
>> --=20
>> Thanks,
>> Oliver
>>=20
>> The following changes since commit fec50db7033ea478773b159e0e2efb135270=
e3b7:
>>=20
>>   Linux 6=2E9-rc3 (2024-04-07 13:22:46 -0700)
>>=20
>> are available in the Git repository at:
>>=20
>>   git://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/kvmarm/kvmarm=2Egit=
 tags/kvmarm-fixes-6=2E9-2
>>=20
>> for you to fetch changes up to 160933e330f4c5a13931d725a4d952a4b9aefa71=
:
>>=20
>>   KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF =
(2024-04-24 19:09:36 +0000)
>>=20
>> ----------------------------------------------------------------
>> KVM/arm64 fixes for 6=2E9, part #2
>>=20
>> - Fix + test for a NULL dereference resulting from unsanitised user
>>   input in the vgic-v2 device attribute accessors
>>=20
>> ----------------------------------------------------------------
>> Oliver Upton (2):
>>       KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_att=
r()
>>       KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CP=
UIF
>>=20
>>  arch/arm64/kvm/vgic/vgic-kvm-device=2Ec           |  8 ++--
>>  tools/testing/selftests/kvm/aarch64/vgic_init=2Ec | 49 +++++++++++++++=
++++++++++
>>  2 files changed, 53 insertions(+), 4 deletions(-)
>>=20
>

Paolo


