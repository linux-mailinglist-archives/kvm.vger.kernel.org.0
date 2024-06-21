Return-Path: <kvm+bounces-20274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97CA1912612
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE4691C25891
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DA3152166;
	Fri, 21 Jun 2024 12:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BC6p6A8u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8F915C3
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718974542; cv=none; b=BDIYxmdsaNfi9zo3HiaqvQKA/DtEUjj7CeXtrC2WeVFp1BEThLTsFcYIaBVwYtrp5g/qhEL3h0GsmGR9w8FknQTtQ2DUKHyo5/oEoQnwk8v6/aEblmBccZGP88+LZ7ZMRC/vI0MtwOMg0r8iFL/EOoKZUFUREWxbp19sDM9ak4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718974542; c=relaxed/simple;
	bh=WO5X9rdCDOaQUclCdQ5IwzctuaRt5w4su9JfUjNIAtU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=A5tV5Dj1BMyNMv9Wv+zAS5hwhrxd5GrzJzdRFS6+5w5T3/Ab+e6q+QSXC1RrIJzAwFil3CE8UH96G0XF8HjsxXNg9cYQmy0VoZr3IUiY9bkEQa7LdYIcULelF2+8eWfR054rO7SbSUv/+/kxFOLDxGsEqEtlb1rnfw/u3OnmySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BC6p6A8u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718974539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qvyso1coD/Ch+E1k1+dQ8v7aJZZwA2hNY2CehO6gBTc=;
	b=BC6p6A8uktsISqHYwByY5qFI4gZtv5UDxpxEog6W8O9qEqaPbXL332Fud/4ANCVEiJO7ml
	z935thkQ6CwZXKMD+08xSeltNQUcOHtvO7WEbHf+15XpCuvtKHwgzeHGojLtdju3ht7GhO
	XQWPFrEH91n9a1b0SYCXTKnZEMC/O5Y=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102--DTwZ09GO8OfUwARYcJ53A-1; Fri, 21 Jun 2024 08:55:36 -0400
X-MC-Unique: -DTwZ09GO8OfUwARYcJ53A-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6b057a9690bso22456706d6.2
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 05:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718974536; x=1719579336;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvyso1coD/Ch+E1k1+dQ8v7aJZZwA2hNY2CehO6gBTc=;
        b=Mj2GgwuPOF1mwcBDB6oaT1K0DaGvXuSGuNAC4jLtyozkI30XsDTvV3rdgNIWmlxXV+
         pKPU1U4vjCNk5781wXe8lY7idKa+SbGgqSHbPSqy96hRbvgl1AyGIjX33n4zHIxvh1p9
         ECqmmZVx7/tp3cHMvwdrtmPRz1Tc7FqWTpPVeV/LdFwZE0lHfUlm4EAu0AB9iRlEyN0Y
         zakBZdGlnzPvOwUHyLMjjD0v9Thyoev/1T+4T9fZlTXZOXXV+gsbRmhHF0bhj+FrP3i7
         zXK364TP5uaqGIhSd9Vodtt06h7aBZ0Ofmg73C8e/fF3qQqdn3tztA+ILrQXMFAPfy+S
         /eHg==
X-Forwarded-Encrypted: i=1; AJvYcCVQZBFTzDFL6kQZQ+SBWZaKtekSSBaT4XLJ/TsrGOG6OZfYPlfcMgm4B1whkn+MMV3kbflrCjWZUT4WkUzmaxjP6v93
X-Gm-Message-State: AOJu0Yx4Acn94qF5ByDYtd+Qn4N1lPPQDH768hA3Y/Taa/MJ8vIgm0FT
	lQq79L0HKoNqh+p6VC7qozXKIYoaYirWgw5IFoMNx4cGkZ8YcM72T9HIU2nSO5bTe6dkLs8feXa
	FhA8S+t30slWl5hKX8Zoa/1Aqjz0F48egA8G9NzMY7Llq7zuu4Q==
X-Received: by 2002:a05:6214:caa:b0:6b4:dd2a:aa44 with SMTP id 6a1803df08f44-6b501e3ca5dmr137927256d6.37.1718974535766;
        Fri, 21 Jun 2024 05:55:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQKfszEYeuIrPEQCSgtqiyccBoeK+6p0epedPO7UJVfwJ8/ib5x4aYN83RsU7kGBTVQbJc4g==
X-Received: by 2002:a05:6214:caa:b0:6b4:dd2a:aa44 with SMTP id 6a1803df08f44-6b501e3ca5dmr137927086d6.37.1718974535390;
        Fri, 21 Jun 2024 05:55:35 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b51ef30d30sm8608716d6.93.2024.06.21.05.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 05:55:35 -0700 (PDT)
Date: Fri, 21 Jun 2024 14:55:31 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Suzuki K Poulose <suzuki.poulose@arm.com>, 
    James Morse <james.morse@arm.com>, Eric Auger <eric.auger@redhat.com>, 
    kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>, 
    Shaoqin Huang <shahuang@redhat.com>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 00/10] KVM: arm64: Allow userspace to modify CTR_EL0
In-Reply-To: <171890515830.1223590.8660930452290685977.b4-ty@linux.dev>
Message-ID: <ef9b7e06-a609-c961-2a19-f6c40f7e9bfe@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <171890515830.1223590.8660930452290685977.b4-ty@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 20 Jun 2024, Oliver Upton wrote:
> On Wed, 19 Jun 2024 17:40:26 +0000, Oliver Upton wrote:
>> As I'd mentioned on the list, here is my rework of Sebastian's CTR_EL0
>> series. Changes this time around:
>>
>>  - Drop the cross-validation of the guest's CTR_EL0 with CLIDR_EL1 and
>>    the CCSIDR_EL1 hierarchy, instead independently checking these
>>    registers against the system's CTR_EL0 value.
>>
>> [...]
>
> Applied to kvmarm/next, thanks!

Great, thanks a lot!

Sebastian


