Return-Path: <kvm+bounces-39972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC6DA4D33A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 936653ACA40
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146441F4E2F;
	Tue,  4 Mar 2025 06:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dg1QdK/+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C421F4288
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 06:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068199; cv=none; b=jHz1seaxg+t9YktcquDwEjRI1oUhXqkUeItkqO4yf7YLyq08XsofPY2u8gTA0HdZQUK7xmUJB5TPcYqt4FcTNtNQgndNhC8MNXWbLUkcQRbArzdmXM6/HduepLAxtc4PFZjRr+5tdxGJTnuDITmlqJPBE7JJw22qZ+ufuK0ZYCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068199; c=relaxed/simple;
	bh=yzDD33Es1OjfbExLpccU0Xk3cqZvakHg4nxFLrMGGCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DD8ob4t+PtkmKz+UHvhabeSMG9zFxGc0Q8LwASHKmV+EtiV4oJC4Kwm8aWPrDK5jCpTgIqoX4uYrReHvZ/mLjw0QA0FNrdwhaptPvTk2jK42pwq35e4f3ulzyTmNF9XHMfaniAuyLJXWuwBEbxZIYzcUMyfLWmZEVPhHYWQPFjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dg1QdK/+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741068196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYQ+hp2BxThyEpl72nHuJbwMjHhQjin3JtMynxdNsGU=;
	b=Dg1QdK/+3d+GieAnPr5xcSqZOxbnysApE4LDYBss2BN/u4rdE+KNhjS3dwyXb2McaruzdW
	qd/r6MKjeFD0SAjlwYl0IRELROEewAPKmYl8+Mv/YED9B620RowAzMGHCuxDWz0MGovtJP
	JuteqgaPE8svVy0ew5cGE/QTGtb36jI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-piFMtslBNW64KxNDm5aDTA-1; Tue, 04 Mar 2025 01:02:55 -0500
X-MC-Unique: piFMtslBNW64KxNDm5aDTA-1
X-Mimecast-MFC-AGG-ID: piFMtslBNW64KxNDm5aDTA_1741068174
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2234c09241fso155727855ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 22:02:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741068174; x=1741672974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYQ+hp2BxThyEpl72nHuJbwMjHhQjin3JtMynxdNsGU=;
        b=hBMaM+fJEyJGocGDLPGlq1eJ3GpUra1rkfoRW+TsmWwy+XYG9UOgY2KAm3BgM6vAGh
         hMYQs4qgkKsiqC5udFxYT4U5f2zR0Vrx2Pgl/WS05/hfyLcxF8w3weVg0HXv9oCGMHB/
         prqLSpE90DAGfQ1IvRM6yyY3IEtUPV7LktVQtFdu8wLWf3s5iONsAg7AT+RcLDfWOEIY
         04qCV0+YEx2K/0Qp3t6lhpxRkNIiykEuS+rLJdU6eTuJR/dpCB5ECivf0T+Zv51WnibP
         faQSjPzBKLzf2BdlDLPbpVxE61Jn4LSvH6hEh+MmGgUroRMvri3WKLaa0XwvMNL39HlF
         Wa0g==
X-Forwarded-Encrypted: i=1; AJvYcCXpxSUxOXeIHnQ4/5VHJHv10131YLAeYozMKn7dZCmHyRRIH0rUZ9MqyppPuPlccRarZfw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRzQ44L8acGz60cqThSzZneMk0hmVWSX51dicK1fY3x4XnCV6o
	XVl1jK1mb+nerK8C50vrON+NjXiG93azN0ip0ltmikse2RdxXH8PRxC4rq8n5qUtSLAC03bmYUP
	BojsmhN5orGKy79dMuqHpKuyspt8J0aEUMNDH4/+1iqJExI+WlA==
X-Gm-Gg: ASbGncvCERDsMZPHLcyyT1LPgT4HSDgMPTuOKd3rz6FWl/tpBKPI0D7CMLwCsgdDGF8
	Cbh8lSKaTl1JAzDuYsD/ufMyIzkfwHsInh/S4Uz40DKB/zmFl0bNq2S+dBJvXZm9fl4L793V0s6
	H9MMFMMW+/O/mL9e3pEXr99BhrgQoOCElgkkxNV21F2oXPSG/9tZYG9lDhwaz/lMbAwOaA/qrOt
	wtt39IfByI5aTgkas/w7B9Q/L5D0EVwC61rx8+RjjWMwKCHr2Hxj0T0Xr89YYGRDoaOEW7VqvvC
	Ba4pupk9HdkvdB6DTg==
X-Received: by 2002:a17:902:e84a:b0:220:c143:90a0 with SMTP id d9443c01a7336-223690e0257mr268865335ad.24.1741068174598;
        Mon, 03 Mar 2025 22:02:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF17jp+SvVB8oKouybsWd/JrJXK2VcB5np1hjZzRt0dKWL0IvRPywYjYwGiuuPFEXE57B3yZw==
X-Received: by 2002:a17:902:e84a:b0:220:c143:90a0 with SMTP id d9443c01a7336-223690e0257mr268864905ad.24.1741068174278;
        Mon, 03 Mar 2025 22:02:54 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2234fdb5b02sm87962675ad.0.2025.03.03.22.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 22:02:53 -0800 (PST)
Message-ID: <5587ca83-bb19-42ae-8297-676588502e5e@redhat.com>
Date: Tue, 4 Mar 2025 16:02:45 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 29/45] arm64: rme: Allow checking SVE on VM instance
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-30-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-30-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Given we have different types of VMs supported, check the
> support for SVE for the given instance of the VM to accurately
> report the status.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h | 2 ++
>   arch/arm64/kvm/arm.c             | 5 ++++-
>   arch/arm64/kvm/rme.c             | 5 +++++
>   3 files changed, 11 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


