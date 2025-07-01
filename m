Return-Path: <kvm+bounces-51162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DB1BAEEF03
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 08:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 426663B2408
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 06:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8326925B1E0;
	Tue,  1 Jul 2025 06:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Is02P+Lg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9151DF268
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 06:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751352138; cv=none; b=cwneR17XZ4kXrMn577kSf0A+q22zDOGM8qdLMQ4CQE+Mkim9bWdS7n80W5PiBWfVYof6OX0Tcv/7jiOcY+YkqAtAjZo6v3lH7PfIRwbFbCAePlkq4vfRV4XD2b3Zfo7f6P+96AmCFpAYRlC+BVMWOi9M6XePjnQl7BMf1+LRC/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751352138; c=relaxed/simple;
	bh=K3Al7D1G7wePfIr0haOB5cZ0BREvvGzr3BvThBzFKuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lHFErhRopPe1aOwbuzj4c/Z7v1syRE4KPrTW8ERGFnUZoE+p05LEfKQTOgCn+3gj/YEzqB+npvFTc+Si92dvJ2W2NEZhrUrxgMs3LL+6O03oIXFvNhO8q65O1jzkCmofIjGX8RIHoabpKyfA3iZhFICV5vycRdgOunJyibz7A0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Is02P+Lg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751352136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nh2uVd7pRoUTCK6irPkfWlzRluxl2PTNeAPLCnx0f8I=;
	b=Is02P+LgaAixPv2TF+Lc1hrJIHV1uiOGmEtSBWx72sLgEZe1n7rkHDPUhJF3eqLDq2uy3O
	QMrxPleZgIzvC5qtuM/rOVfQH18PHayt6VTp96UBH4NsxJgPFp2VE8tmzXOuR9HrlVX1q8
	SRaR+ocAKXCfH1NfL9sZpVup+CcsIZA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-XCj_ADFrNamoBVsigvyT8g-1; Tue, 01 Jul 2025 02:42:15 -0400
X-MC-Unique: XCj_ADFrNamoBVsigvyT8g-1
X-Mimecast-MFC-AGG-ID: XCj_ADFrNamoBVsigvyT8g_1751352134
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-234906c5e29so36555185ad.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 23:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751352134; x=1751956934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nh2uVd7pRoUTCK6irPkfWlzRluxl2PTNeAPLCnx0f8I=;
        b=qb6w+8YCWr3eh7nRzpSLnQl5bTqfXfV1RSN/0j9O36bst2IF0RSTHKAy5NoNZ2Dos1
         eUajsC44DvyZ5GeKpWBMjSxGx7aX0MpYiYANyRwSBU4EGo4SAfIrGrYa9E3Pt51VAZBn
         g4RgiQ7Asg4BMWPq8bt3zUkmEV7sQ0lp+AWnBWGP+USLr0dJMNePSjLwLm2uHg83mf1T
         2jEQKDUk6CjELazo1T+mTJIcOiqRBZy+oyxKpFANHAPh2EShYOG9jxh1CBEi2bXHzzyf
         LzsitPQvmOJLJVEI5demDcTySPWmCVUMVmXi0ozjM2iDhDRnandJhVLlRGUH9Qv2O/8R
         aj5A==
X-Forwarded-Encrypted: i=1; AJvYcCUVH0joHjwNI/f0c0hA8ZS0CffgyRY9uWc++kbVkoaeCxXmgwbOkEEubU9kraUibM+yb64=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRgL4eNYcVTPDz2UXl6xBjj3pJj7afuAzyxKJKDkKn5kAfWB6H
	fWidNGK+4CQ9GgDWp1ACnkmyXJKxFTn0aeis5p/Eo6IYpwJRrv3RreUOmzMFh8ZhzQ1VKTuiIBG
	MNAmUm6p1AuLmyNHJBZUqKaTT2z4GXF8cQwpSnxMX4HZ08diQ7wXaEQ==
X-Gm-Gg: ASbGncsDwxaafdxAk9ddv1V+OrHUqy51awsoDhq1QF5xlYJiSwnRb9ntql1QORgLisX
	R7GQ9kEnIEjbS+rnKGrFV856BWx3Dxz3ECCfk+dVrACz/ELw3qDwxEfoX9VzJM9kTTYJWE3gITF
	U/sk9IiHoA/rP1kyIvDG/FNExiakaw2/msFFX+0sf9784cK4sA2CqzUXrY9TxEReR3pGD4dhRSt
	iqnhJqoYX6vX6zvPYVD6ua+lr2qK02yFC6SY18K6t85JhhkN4a4A+0yXwBQ73Z+BnantqqoEzsb
	EpRccCIfB39MNfktlGO2vO6g921gl/PtkuOQwdJRX+xpZoTq/c46MI9+myR2kA==
X-Received: by 2002:a17:903:1aab:b0:235:eefe:68f4 with SMTP id d9443c01a7336-23ac46066bcmr278419765ad.29.1751352134041;
        Mon, 30 Jun 2025 23:42:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHl2aE+m8eiWUtPLXKvS7q68VAQ4UGGYsv/Yl574znsMqgsWf8nwxSoY/4U5XcisW0xX3aQWQ==
X-Received: by 2002:a17:903:1aab:b0:235:eefe:68f4 with SMTP id d9443c01a7336-23ac46066bcmr278419475ad.29.1751352133719;
        Mon, 30 Jun 2025 23:42:13 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c689bsm97301335ad.224.2025.06.30.23.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 23:42:10 -0700 (PDT)
Message-ID: <5d520f90-f49d-4926-bc04-80979531aa11@redhat.com>
Date: Tue, 1 Jul 2025 16:42:01 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/43] KVM: arm64: Support timers in realm RECs
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
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-15-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-15-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> The RMM keeps track of the timer while the realm REC is running, but on
> exit to the normal world KVM is responsible for handling the timers.
> 
> The RMM doesn't provide a mechanism to set the counter offset, so don't
> expose KVM_CAP_COUNTER_OFFSET for a realm VM.
> 
> A later patch adds the support for propagating the timer values from the
> exit data structure and calling kvm_realm_timers_update().
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Hide KVM_CAP_COUNTER_OFFSET for realm guests.
> ---
>   arch/arm64/kvm/arch_timer.c  | 48 +++++++++++++++++++++++++++++++++---
>   arch/arm64/kvm/arm.c         |  2 +-
>   include/kvm/arm_arch_timer.h |  2 ++
>   3 files changed, 47 insertions(+), 5 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


