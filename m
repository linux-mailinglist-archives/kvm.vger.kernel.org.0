Return-Path: <kvm+bounces-58347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7747CB8E9C9
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 02:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75302189A33B
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 00:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A18C148;
	Mon, 22 Sep 2025 00:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LsdmvbXW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEBC9460
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 00:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758499404; cv=none; b=expybSGS1NiJIVhvQLH80QDToOu2wzDstza0rebl7VhqmBx1RCMHOkTGVRzxST7rqsIPpRwuWmmbeQZgrsEKkWZFH5EUzlaxAujc3wfjSag8rJraq70cXBNxjKopNFGWud8JpFpIBNFm57DD5zNHHM/TO2WD/vu4Ds595+N+c6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758499404; c=relaxed/simple;
	bh=5S1RAPbr3qVsBqfhEwUmh/5GNlslYTzXJY2zUUc9kcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NcfzwEA3BD4zK7R3eXvKjtfdtihtGqMBFzQ9e9oT/i2NfyoPjyRPmbu3SOpIbypaPbqW4YlFi21IgcM5BdVvILmaae9tFugGLRber0aGX0UOVECLiYIsADl/Jij6ZLvXX2QF2gxm8nGxGx+YRIe4LlpyjOB2cWJo8kzJk/1gBgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LsdmvbXW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758499401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDXuqYgBTFSeTj9HmL3kCs/tVEJAWswdP19jlLEVGcM=;
	b=LsdmvbXWofc6PRa7bwSzMMOOyB/NYk2S1hiedUqC2QcEOfK8P4tcutlO5AkyNtxCr2WhtW
	sHu2LERZXDpQMpQWYy7PBNe1RlXA+1vEhUZlF5WwKvXRSSxCYwd9kExk8e5FSECmkJ1UmZ
	+noeM2MXkrVIK3wiaE5pfFzN9D9JKuA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-mRQrEUvNMMaU52eTnCrQgA-1; Sun, 21 Sep 2025 20:03:19 -0400
X-MC-Unique: mRQrEUvNMMaU52eTnCrQgA-1
X-Mimecast-MFC-AGG-ID: mRQrEUvNMMaU52eTnCrQgA_1758499399
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b5527f0d39bso2651406a12.2
        for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 17:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758499399; x=1759104199;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PDXuqYgBTFSeTj9HmL3kCs/tVEJAWswdP19jlLEVGcM=;
        b=Ra56rr6TYJXOrmoycur13IBmZ3uECQ08pUfURBIkRBSZ4NkPS1Q/w/f+CI0IXZysEQ
         Sbc14v+fScXopN9ezx2SLD7cXTCTz3O+FKtd3jA7qv2EKgWMYFbpONKbkq7OtE3mjZx9
         XJc9oY2Wo8Nc0ozzwVrVFqL7jAZdymJOVbUacrO/oyWK7+Sq7NobYkYCNLRkZ0q+xbDT
         g8ngc8D6fHRuBO1M0otVFFeKePgPEbIB5dzEYXMcpHEKEsyLBkypXQGrTnXk8aSC9S2+
         WgY5MhM6AbnWzf+XgwOf67TN/eBuwHYjcbncFcXL7Reo4fwL/VXv2bCa0lSn7HhNrSTK
         jNYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgkNjlZLWgJlzeBWUcFTw53aVdNPWyIsCbkdC2jUvjM6yEpknYqfhALYf1SO42hYldNqA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9Sy2cbN2B+2EJTy3/yg2JYwdW8OFIGIKbARLQjjCQEYmgY1Gp
	sjbWlYW2o/Cy0MmLDfrKsbc6Io30Ne4U1UlHiJlxyOzJfqpZTSeTQdoZso81CyD9y0cQrXwymUm
	8UNo+pphRubkaq6pKoc9bvxjOiOxJDhy7+2wfS83C92SU1GpR/PChiw==
X-Gm-Gg: ASbGncsLvhIaXIUCV6UuOAfABZ8CZXv5zWSoHU+O7cXKiqvg/EHY6+3m4VIxtOvzlej
	CPV+6e9SMu1bbAkgDPM3svkdmvrgNmjyrAAlfK4f5Vw0XrLmWihdKI2Xckd4uJtymWTiR+C+KbM
	JohkOpniduO6vn92pwiuvtkKgNpalgaOcshqnYu9oPnwiX5tqnhStkDrxLbLvPd2svecah5/X9+
	mACRILLIEcey6cq6453wSa8epuRUjpzb8Cyez4m5Y2FGGvZR0Hrs7l3BKLpMb6uNl+K8i98bZ2U
	uN4z2uo9oiODhBSoHOM86U0dlUD9No5ugHIDfhUj9QH4ja0V8IjO8uTAe0XYOGVZd0RvGgXrNpx
	sD0uT
X-Received: by 2002:a17:903:2f83:b0:265:bb0:cbc with SMTP id d9443c01a7336-269ba559260mr154624405ad.47.1758499398763;
        Sun, 21 Sep 2025 17:03:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0MfGExlYWTmOjV1WzK5kji6eVj+QSqlsV+EO7ogGlqCirbQxRS/TDHG9aRgu0NS0ideP2VQ==
X-Received: by 2002:a17:903:2f83:b0:265:bb0:cbc with SMTP id d9443c01a7336-269ba559260mr154623995ad.47.1758499398419;
        Sun, 21 Sep 2025 17:03:18 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269803601e3sm114894975ad.144.2025.09.21.17.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Sep 2025 17:03:17 -0700 (PDT)
Message-ID: <a836c085-9bd2-4160-9bf8-81c186f7535c@redhat.com>
Date: Mon, 22 Sep 2025 10:03:07 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 31/43] arm_pmu: Provide a mechanism for disabling the
 physical IRQ
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
 <20250820145606.180644-32-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250820145606.180644-32-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/21/25 12:55 AM, Steven Price wrote:
> Arm CCA assigns the physical PMU device to the guest running in realm
> world, however the IRQs are routed via the host. To enter a realm guest
> while a PMU IRQ is pending it is necessary to block the physical IRQ to
> prevent an immediate exit. Provide a mechanism in the PMU driver for KVM
> to control the physical IRQ.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v3: Add a dummy function for the !CONFIG_ARM_PMU case.
> ---
>   drivers/perf/arm_pmu.c       | 15 +++++++++++++++
>   include/linux/perf/arm_pmu.h |  5 +++++
>   2 files changed, 20 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


