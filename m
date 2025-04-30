Return-Path: <kvm+bounces-44850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB94AA4291
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 07:42:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80E5598104F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 05:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77B741E285A;
	Wed, 30 Apr 2025 05:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hi1MSgKM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FE12E401
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 05:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745991744; cv=none; b=S2K6mIezGZmfShM+hOQZf8ePdx4v4FxbLVNoMZGUWWyd/lgUgRYFq6fPkEDkpNYQQ9tfMBn/2LW+iPugefW8IRzfDHQF3k4yFiCxFxXQ4FE8NTYmXXigY1tqDnE+yxccWzak0ZZTVCUMYvrZeda+h33p8VUPQKYmc+Ax70wThQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745991744; c=relaxed/simple;
	bh=kQ/EbrrxqEhr5fwZayWRqCdok/5KGxi81DpciRkA6xY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+wQgwCh3e6yqInYl3AITP/a4Ix+HHh3aJsHMr703cSsP8bp6qctRitdbkrCpPzSZKsgmjtUPo603NsumbP7KnBg7spLX9bVjKTrhqSgPFf6QNNJWnGGh5kmeD/N18Fz3O72PEdc1cNo7+dYIKtDKGcSiwhPoyD/Sq0mWAqNolU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hi1MSgKM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745991741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7I5yDc+vjNEcqE9R+YmZ5CGoORcg69x/77QunGRnchU=;
	b=Hi1MSgKMkfIlmqMi2e2LLQvyNC8uVgTOuO3Og28N7MW5KqfSa9PWBMtNPrsCQTmEXcT0sw
	JBmRPhFPoRleKF85vIk0H/K6slAtjJjBb8ZZFcO6oWIQuH7Dmz/yHXXu0TCNiKO6zlGkI4
	ykOJbbcQMXTtw3CYdPViPokd0DhYOWQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-K8Xy9S-ON9SnKsFmolQEFw-1; Wed, 30 Apr 2025 01:42:19 -0400
X-MC-Unique: K8Xy9S-ON9SnKsFmolQEFw-1
X-Mimecast-MFC-AGG-ID: K8Xy9S-ON9SnKsFmolQEFw_1745991739
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3011bee1751so5976170a91.1
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 22:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745991739; x=1746596539;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7I5yDc+vjNEcqE9R+YmZ5CGoORcg69x/77QunGRnchU=;
        b=u0TXofifKeALy6DjiJ17QF1wv0LfxT43z/XKe/g0im5iuzH4hOnOaaFKFZStEuwcig
         GdsRkISPRwuECFlaZJMDWNN2UdVUDXeeoCl9chxqvf4y8ZtiNX03NQGhsokobaM2I9KY
         0FMs6GrhTdfpokKfx0e84LkS5DgccnuIArvcuPcJjLyUHYBYtkHhODIfsK9tyCqB8uSY
         7ygPsjCbDDCZGTu4uG5Opeml9fwWWlj7WSaDcKNn7Ym/Wqc9OuHm5bdxnVqWedM2nhYn
         LTTyM1yXDwbKvoZosmDQcjSgXCJ2ySdA1jGmFWgHNKDk12jdUjakxyno20JMX3ovI4ZY
         BXSA==
X-Forwarded-Encrypted: i=1; AJvYcCXdtNynx4f7a4F3XtxT6oWKnHuUj1cI7LEGc+4FOZGeAEion4yt4tSqnUC0FZJ/7oRMkj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCLnRkmMEoKmmPZEnpywXv9vL+7zJzkE7ZJyKIfH4xNaWOEnoV
	W0/Vo9c9T4N43ENbkAZC0yr9apgsz/Z7UHgxLv3ESP3wvUZEz8R5M+GjwcXqWfRwHQpjzzrcmY6
	lu3ZZxX3+Xo+TQXn5hNvIqV3ljVWXvh4MmkiDHNS5A9Sv1ioMDg==
X-Gm-Gg: ASbGncv54mle35H/OuL/Bfg36wy8Xj2hGW7O9aThtKyF2qrOmgNlf3ZEcSaIeMqtKnG
	+f+ihkVog6UFOelYK6tPUZBfuYIPesNrzLJyH+gVYyzJXLY4InHCnP5mULOfmUApv+30FdenCsL
	aEjQ51vh3NifQJ02zcmJ9Ghvs7mAL+Cv8kquUIkSQSTg09+xls2ougE/xg+fbyQBPLH+v40KMPO
	SNWrGYVIN1x8XO5UNW2VkjXATfDV8fV6epv/jiO0fRG+TwTrc8GtVoYCbs+t8A8+p07A/St3vTt
	DZD8EMqRKifd
X-Received: by 2002:a17:90b:3d84:b0:309:f5c6:4c5c with SMTP id 98e67ed59e1d1-30a34450c14mr2039781a91.25.1745991739021;
        Tue, 29 Apr 2025 22:42:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/2rRziMqV7exhtrwhKlwQtmufkCV9nFsAwejZ6czk2oG8bIJh878e13vez0tndZIUCamZFg==
X-Received: by 2002:a17:90b:3d84:b0:309:f5c6:4c5c with SMTP id 98e67ed59e1d1-30a34450c14mr2039752a91.25.1745991738750;
        Tue, 29 Apr 2025 22:42:18 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34a60882sm624669a91.45.2025.04.29.22.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 22:42:18 -0700 (PDT)
Message-ID: <a045f5a3-d637-45b0-b109-394e8ad0f409@redhat.com>
Date: Wed, 30 Apr 2025 15:42:09 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/43] kvm: arm64: Don't expose debug capabilities for
 realm guests
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-9-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-9-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> RMM v1.0 provides no mechanism for the host to perform debug operations
> on the guest. So don't expose KVM_CAP_SET_GUEST_DEBUG and report 0
> breakpoints and 0 watch points.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Remove the helper functions and inline the kvm_is_realm() check with
>     a ternary operator.
>   * Rewrite the commit message to explain this patch.
> ---
>   arch/arm64/kvm/arm.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


