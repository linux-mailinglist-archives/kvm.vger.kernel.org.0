Return-Path: <kvm+bounces-39966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D2BDA4D30E
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66D77172D06
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714E51F1911;
	Tue,  4 Mar 2025 05:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UzXmIxpV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D725A8837
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 05:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741066728; cv=none; b=B4BTAuf0xJgwRXceTG5659Igw0V476gaWmCSe1olwUDWv5vOnVhKjZZrhaOgEpXD37EmzZSLEw1wH4r+csntNRnpGbjtO89/PpFBJqti0gFm3kqrS0SwBOyc7WuFPbVvoGl0LwtPtDFmMq6o2TRqxBPIDHRfQ2PTgojHteSBmAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741066728; c=relaxed/simple;
	bh=bq1rEvMgUCO+z9mqMh3toWqnhddFvqq5Jt040KPfC+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2qWAbV6jjbVuGGex8CRYlnu9Bya3YlLc8LDhyi30CWPtsD66OJRvE0iCn6LE9/KYQkZMjX8kiej/PWNZykPpEz5A6L7LYfGgYDMFV1NGqKTUSSmVrGmyDC+js8dLUWjldCdBZVl7Wu9TN2Ul+TVr5mPOJ6rLqnprW9QLv0YzZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UzXmIxpV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741066724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rhnvguDUl9b0lKjHpwaAt3YEx23OG5Tvc8nGcNEISp4=;
	b=UzXmIxpVU19/fPzKctp3md4ln8CXZtM8f/wiG545gUxdUe33GRh/AT9KW1XToJsSGbT2nw
	T7+uAthCpWA/fQKWgG5myMRNx2rPp31Cgp56zrJNeSsh0w1UKZl+IVh46trsDIOTRlxtUo
	BzODrfZxQBngx+FmWwdjOQBbcRsu6nU=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-03gA40hNPiC20rYJJWhEJw-1; Tue, 04 Mar 2025 00:38:37 -0500
X-MC-Unique: 03gA40hNPiC20rYJJWhEJw-1
X-Mimecast-MFC-AGG-ID: 03gA40hNPiC20rYJJWhEJw_1741066717
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2fe98fad333so10461752a91.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 21:38:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741066717; x=1741671517;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rhnvguDUl9b0lKjHpwaAt3YEx23OG5Tvc8nGcNEISp4=;
        b=GmIRCOpMFi4Jk4e++tN2pkiK3EKbS+7WJnhG/ITXAphYj3LwGVRs6ZykReOZoiQ4cL
         LfLJ05JIWKi+yvugO2II9jp7oQ2J5UOcbpU0TsTx2GugFhp8OHfp+t7IR4TuZms3FwXq
         FVAVHVMminSGozrmeTh71rSaQLks48o18WOHyvQlcVcOn9b+N3clA0tion8H1b8kdtJH
         90ZhUFkDBigmWzmcKOnNxV39Eov9RhxPiCPLD7+WQoxEToDfYzbzQH8hrfKCTAPZ3tOR
         0K4Q2M7wV3I0eEV6DwW5/UreJOY6gfnTP10f4DH7hcBIANQqlCrOHwJ3QHgERiuDn+mt
         oKNg==
X-Forwarded-Encrypted: i=1; AJvYcCUUztTnbhyyDp40+DS+YDdrHFNKs0eNDUViLdCBHE3r8PZkCY8XnG1P0kqhzK4Cpp9sLiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPzvvBfdZblKylNe90WJlnNP50NFq/dN1UMwAOGpEWndTlyZLh
	Qsad7vjo/b2B0h9dUIWljUykN2aO2Lhg+OYfm+vmiWCNj5/txOMekCajVj/1w4Jj9YQ37YzPUU9
	eBkFc1zpfnUD4F7ONvtQ5BTnRmCUZuCtpWGl5LNvXm6zFOeeWWg==
X-Gm-Gg: ASbGncuYqjyyV0V/Ie6cNcwJPk8QDJeT3i9GPgnfctgsLXVr+k0x5uKZlFL2rO+YqqZ
	WBQ78BSPhNFhpIjtB0dGWtabjoDwvxNHUhPUGVuN7XkvXk9pFx9L+7HvZP5rEimxIQKbCz//QlY
	akl+2ocQTx9xLKph3tOPTVs4e4n+MCz1NL1AzCvHUE+8U9rY8SlDZ3qb0bt1V8jsSV7qbFQXpyJ
	cv5HY1HVxpmFg+X0qGrC3VSaUW9dujO5nAVSUf2mquzRgRccn/uvEByDPeh0wFc5qqsUWiSkGXa
	Ng9alVum4EqgaTKEZQ==
X-Received: by 2002:a17:90b:2f8d:b0:2fa:228d:5af2 with SMTP id 98e67ed59e1d1-2febab6c68emr25331684a91.15.1741066716880;
        Mon, 03 Mar 2025 21:38:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF612ZxdojGbx89Aqh0mhvbM65hIZPcepIXHF98wxNJcpuaTGS26LwyEfOvsNmDG1/FgXRbOg==
X-Received: by 2002:a17:90b:2f8d:b0:2fa:228d:5af2 with SMTP id 98e67ed59e1d1-2febab6c68emr25331658a91.15.1741066716552;
        Mon, 03 Mar 2025 21:38:36 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2235050d7c1sm87354825ad.198.2025.03.03.21.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 21:38:35 -0800 (PST)
Message-ID: <5008db08-c153-48c0-90b3-39fa0297ba1e@redhat.com>
Date: Tue, 4 Mar 2025 15:38:27 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 24/45] KVM: arm64: Handle Realm PSCI requests
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-25-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-25-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> The RMM needs to be informed of the target REC when a PSCI call is made
> with an MPIDR argument. Expose an ioctl to the userspace in case the PSCI
> is handled by it.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Use vcpu_is_rec() rather than kvm_is_realm(vcpu->kvm).
>   * Minor renaming/formatting fixes.
> ---
>   arch/arm64/include/asm/kvm_rme.h |  3 +++
>   arch/arm64/kvm/arm.c             | 25 +++++++++++++++++++++++++
>   arch/arm64/kvm/psci.c            | 30 ++++++++++++++++++++++++++++++
>   arch/arm64/kvm/rme.c             | 14 ++++++++++++++
>   4 files changed, 72 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


