Return-Path: <kvm+bounces-58348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62083B8E9CF
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 02:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50051189A8F2
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 00:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1B517BA1;
	Mon, 22 Sep 2025 00:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fvP74Jpx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B264C83
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 00:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758499426; cv=none; b=sslu92iiAjMvhh3Op5r4YdB62JD738H6AoqUQbhKgGp7JV/FquJZUaOd0bNHhWG+8QsuX38o39djSvOrQ3GTN8q5I2eniG7WOdxXv6ZZFS46mVJHfhih7qt+DNtNin1fl09ZIoGZiN+rdxStbYrpSuDK39158910+JwTQiACN8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758499426; c=relaxed/simple;
	bh=Vc+qe4oStpGOoYeSI9upVtp+ku6eEr6v6jB1FhStksw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cKj9sH6QyqPB7RqROM9ue3gVeQyt64WqKOYY+I7gfwVETRjaqnjJVNmMDhcliWoQMwrTofuvmBmksmbJVagXsGRifdIL3yglxV+DC/XdbmWivcrP7wrmnmP1lcE4YUKV425pKiBNNJSKr0Cb/dc4aLVXcqrkc4RKeTj3dtRsQBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fvP74Jpx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758499424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqKU8AOkK2sYZLUnyHJFIE8wA4u3vUpzgORbVfbSXxw=;
	b=fvP74JpxbQmNo1FWFWCMdszGDxrQqjXZf9hGtyR3JdCWJ7C4aGAQMJi+fqRlk57bJCknjy
	zHxcQH8OH3FCohUXycdn/+l2L7gxlGpk1oZWNcsrPf1puPgHJ6emb7u7491VgmWXXXv0WK
	EPH+912XEk04qryV9HeA4y8bh8JTJjo=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-h92pnat8Ovmx2TBOdOpSbg-1; Sun, 21 Sep 2025 20:03:42 -0400
X-MC-Unique: h92pnat8Ovmx2TBOdOpSbg-1
X-Mimecast-MFC-AGG-ID: h92pnat8Ovmx2TBOdOpSbg_1758499422
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-77df695490dso2546083b3a.2
        for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 17:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758499422; x=1759104222;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BqKU8AOkK2sYZLUnyHJFIE8wA4u3vUpzgORbVfbSXxw=;
        b=A1VCk3q+9B9ejj/zndb/P7KoUi+z4v7OgEgtFvqetxLT4BziF9GMPgnl5iC8eSoIyT
         Rv91XCG/B6zM4Ochm77o2S8V45jUVNK21pPiCCSCQxeK9At3nNMZbNsLXKWs0C+tYHYn
         aEnIx4PBmzv2OcaqhBVHEll2tsX2BiA9t3T3yc9wxOrBAQHETSsughfG9KsOOgSJgyZw
         Vt9lXIvexKY5BM7HnwmkCoFMokHwDMqpq+gj6vQSkqvtUkX65vTSBOYLf2kBBIxSbuzm
         wla9HRS6phflDv5Ltu+C+dy21wCwDmAqB0C6mgfPwht9cHaHMXOXuF1aVeFtnSi1yY6Y
         lO8A==
X-Forwarded-Encrypted: i=1; AJvYcCVk/TZ1CmZF5vIIsJB99EiDf/8XgSY63hZYWXFU4ayFqL9QZLnssXs4jWYsI5GTmOQmaTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRvgPg/t2JDJ2a46MkJF+SJiL01OMoRFBxzJpjlcpj+QpaohRr
	+Ucq0ckcX5tpv27JzgzWrfDRxlcCoQ/Ma5Ghbkt9FXHBWgnAVDGXJZRQGNmB1ev4RtPLJ1XDKy2
	Xk6sz+qgs9mz0vhHDMClY4DpINDQEN31wwHpNUblm+xul+1+INP8KMQ==
X-Gm-Gg: ASbGncuIysWTieEoXXjK25exVFomBoVzVtqUT5IjR2lwU1TX/83mqzvR/acHqakgCb2
	4vbPJiH/Hwt4iEcsRTZZmjA1kDZPGN+08ILI99MMMSNSogoYF8ML2KCQCKnJU7SF7iF6az2BGam
	Zem9DNreALU30J/sTJxgV/lE222xmQJOueFlfeoQiBLjG2QgsC/xnUpCeks9YcSuItRy49hjS7v
	+k0iWqX7IS59M4IqwGuCoW05kjJWILCGGl/xDTWiGx2UMNSrWe2GKXy2LnNgmV8lo3nl6g+6ALc
	OEYmnq+Vy8qybJqsuYXSYfsevZweBAqtwClnDDUNSi6SZCwIW3BVj7bCU6UBA3B9ZNE1kuAawq2
	0mJ/K
X-Received: by 2002:a05:6a00:10c5:b0:77f:2efb:11d5 with SMTP id d2e1a72fcca58-77f2efb19b5mr3965866b3a.1.1758499421849;
        Sun, 21 Sep 2025 17:03:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEV+P3PLtWMFz48LpuCCUOGv1CdGlTH41uj5nbM1D8BAHioMb2Zl8ZXd6r9GdYmEpNm+I3zQw==
X-Received: by 2002:a05:6a00:10c5:b0:77f:2efb:11d5 with SMTP id d2e1a72fcca58-77f2efb19b5mr3965847b3a.1.1758499421542;
        Sun, 21 Sep 2025 17:03:41 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f30749642sm2123356b3a.100.2025.09.21.17.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Sep 2025 17:03:41 -0700 (PDT)
Message-ID: <59d78787-1871-41ba-9a2e-30d1596c021f@redhat.com>
Date: Mon, 22 Sep 2025 10:03:32 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 32/43] arm64: RME: Enable PMU support with a realm
 guest
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-33-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250820145606.180644-33-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/25 12:55 AM, Steven Price wrote:
> Use the PMU registers from the RmiRecExit structure to identify when an
> overflow interrupt is due and inject it into the guest. Also hook up the
> configuration option for enabling the PMU within the guest.
> 
> When entering a realm guest with a PMU interrupt pending, it is
> necessary to disable the physical interrupt. Otherwise when the RMM
> restores the PMU state the physical interrupt will trigger causing an
> immediate exit back to the host. The guest is expected to acknowledge
> the interrupt causing a host exit (to update the GIC state) which gives
> the opportunity to re-enable the physical interrupt before the next PMU
> event.
> 
> Number of PMU counters is configured by the VMM by writing to PMCR.N.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>   * Add a macro kvm_pmu_get_irq_level() to avoid compile issues when PMU
>     support is disabled.
> ---
>   arch/arm64/kvm/arm.c      | 11 +++++++++++
>   arch/arm64/kvm/guest.c    |  7 +++++++
>   arch/arm64/kvm/pmu-emul.c |  3 +++
>   arch/arm64/kvm/rme.c      |  8 ++++++++
>   arch/arm64/kvm/sys_regs.c |  5 +++--
>   include/kvm/arm_pmu.h     |  4 ++++
>   6 files changed, 36 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


