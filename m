Return-Path: <kvm+bounces-40657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34B11A598BE
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4241E3A9547
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 14:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02AE238D35;
	Mon, 10 Mar 2025 14:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bhMMKMBp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2862B238D42
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741618404; cv=none; b=boMH+Ell9u97w2zArtUUTeAcKJBb58IJ7iqlM+pebCjEt6ryix5b+0SaMP4y1AgwP1Y0btRY1wlDmxpRz+q5CedLwXZ6qKIhtU282tGUlKbbDBWzxpgVtGIX4F1E65R5RpIiLv3AYv+VEKgwvfJf4gsf5OvRL1gN781EHj3iHpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741618404; c=relaxed/simple;
	bh=gxz/OaJuhC6GhUGumNx/uHsZxcbpDpKiH1dHsNDzeX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDZrAOHC1tv9OmTv/cmkn5QRsy7EOEwvIR++zKLe3+pQFZtgmoQb6r2Bg/16FVPliffi+LQsycaG6KMrFRSb1gmoBIaNTAXNQVMaUWfnjpLZhkM0P+5nNvsEiBTsBvwojaaY4U5MymzOcQexGmDZoBg1vPxEx3OkI0kfDf1sS/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bhMMKMBp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741618401;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gxz/OaJuhC6GhUGumNx/uHsZxcbpDpKiH1dHsNDzeX0=;
	b=bhMMKMBpOPYvIHNZzrcm1oNeDu1cym0eCRqaNfFRCyd9A4yCD7zvb6NEQ+xeoJBzC+glaw
	HolOWxDLrq/Uu9uVMIg0+HXyhhbK9vOpBKMyIocBiuPc3GG6wET6+AjFJXfKufKvDRoLC9
	dhqvxIvWhtDaNlojA6la+23KYcuzE/A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-fyycbxlUNlqs9H9BO1King-1; Mon, 10 Mar 2025 10:53:19 -0400
X-MC-Unique: fyycbxlUNlqs9H9BO1King-1
X-Mimecast-MFC-AGG-ID: fyycbxlUNlqs9H9BO1King_1741618398
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43947979ce8so17932795e9.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 07:53:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741618398; x=1742223198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gxz/OaJuhC6GhUGumNx/uHsZxcbpDpKiH1dHsNDzeX0=;
        b=sJU0n6gjmQC7lSHdOY6W64zfLu6S9X/keG6g1JU1vMavBrhuIW+87WsKl8sjb20CCu
         eaje9UxyRix3yX8sIlTkHGKajNPsiebcvOZoZQJxMOD3MdfLcNREL4SE/rhPioeB/k/8
         79gl5T5ygb0sDbonTPtFVTGDsZierFEeRaAUElIV2hY1sY6/VxVNNel2Z3K+jnMdxmrU
         AK1GluB0tR84w/KUrsWzgi8AtTOtIBcbMe+X/8dNY34vNaBDPgRfq+R0qmMDYhW+Xxza
         yYCXKcBbvL22RsaKoJNLqTyYb3Vyw/oB4C1WjFRI/Cj2NWy5lNhAbAnqtfjSKR1n39d8
         axOA==
X-Forwarded-Encrypted: i=1; AJvYcCVIv17WZFYYOXYpgxEwiUfLsZXf5wLLzbB2b+ZqCQHkQ8nJURyO3aGJXKi0crIiqH04zIQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy29db76j5Wu8AdsJYgw8aHrSicJ5hVIiamhguEIoBJKlGHY5gg
	urADqJnWPqdJa03i/otIVz8BaXTFy1eMLr/NilPEi7wRnAqk0blkUxQL8tNzFRlfsHmmaqfWLvv
	Q2wrzVym8vqvMWTGbVge4V675F29yeEvvHgIYbhmVgblwnOempA==
X-Gm-Gg: ASbGncv2xTBju5Tg3Y8KA5Ia66tbDyaPKoOX6T4t48xmvMnCkYOEeK+vaIQBMgCQ2fd
	pSkbi4r1LpkvACI9vx4xWbpg3lNAPWg27baxi90eZ+YTiErOaGLS5TMB8wZRAkfO/BvE2z7/5sX
	fS9i4YPH35dAAXuib25Iv4yGThN2SHQnxIfhowkxbuRAWiyR2U6EpljkSk1kIXKYmzLPtYLj9Am
	M+qTmXwyHRjqaheSc1AvVwV+CQRUwJ+2HQbA2HeZs6i3jizmtfKPu8InftVmAv/qJdI4yBWANUD
	zWyxSUY4v9K0A08GXXtNLM1tDN43zQdGm7pCLW/NMhQp12SzoMEwnX8TK2WzAv4=
X-Received: by 2002:a05:600c:4fc8:b0:43c:e9f7:d6a3 with SMTP id 5b1f17b1804b1-43ce9f7da7emr61674095e9.13.1741618398438;
        Mon, 10 Mar 2025 07:53:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKJv0iWINUjecdWh5HxYRHgHCN410pWn9r9n4RosRzrFlf5wSLtClZ898kvNWrTYk8Bi42sA==
X-Received: by 2002:a05:600c:4fc8:b0:43c:e9f7:d6a3 with SMTP id 5b1f17b1804b1-43ce9f7da7emr61673825e9.13.1741618398095;
        Mon, 10 Mar 2025 07:53:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43cfad9b823sm27522235e9.5.2025.03.10.07.53.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 07:53:16 -0700 (PDT)
Message-ID: <e90443d8-11e9-400e-9421-7cde30ebaf47@redhat.com>
Date: Mon, 10 Mar 2025 15:53:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 09/21] hw/vfio/pci: Convert CONFIG_KVM check to runtime
 one
Content-Language: en-US
To: BALATON Zoltan <balaton@eik.bme.hu>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-10-philmd@linaro.org>
 <28c102c1-d157-4d22-a351-9fcc8f4260fd@redhat.com>
 <2d44848e-01c1-25c5-dfcb-99f5112fcbd7@eik.bme.hu>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <2d44848e-01c1-25c5-dfcb-99f5112fcbd7@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,


On 3/10/25 1:54 PM, BALATON Zoltan wrote:
> On Mon, 10 Mar 2025, Eric Auger wrote:
>> Hi Philippe,
>>
>> On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
>>> Use the runtime kvm_enabled() helper to check whether
>>> KVM is available or not.
>>
>> Miss the "why" of this patch.
>>
>> By the way I fail to remember/see where kvm_allowed is set.
>
> It's in include/system/kvm.h

There you can only find the kvm_enabled() macro definition.

I was eventually able to locate it:
accel/accel-system.c:    *(acc->allowed) = true;
in accel_init_machine()


>
>> I am also confused because we still have some code, like in
>> vfio/common.c which does both checks:
>> #ifdef CONFIG_KVM
>>         if (kvm_enabled()) {
>>             max_memslots = kvm_get_max_memslots();
>>         }
>> #endif
>
> I think this is because if KVM is not available the if cannot be true
> so it can be left out altogether. This may make sense on platforms
> like Windows and macOS where QEMU is compiled without KVM so basically
> everywhere except Linux.
But in practice we have a stub for kvm_get_max_memslots in
accel/stubs/kvm-stub.c.

Eric
>
> Regards,
> BALATON Zoltan


