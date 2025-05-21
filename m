Return-Path: <kvm+bounces-47222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C88FABEBD5
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 08:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E75013A5F58
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 06:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB3C230D0A;
	Wed, 21 May 2025 06:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TeK0SRyl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09DA21CA04
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 06:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747808192; cv=none; b=qmKW3sv787oaGibkhEdMUwF5UXSwEy1I0TXGWqIa8Oidm1GyTSZH6svT//uUBC60tdt/voCKthZo6GUx8AJrwbGWEtInamTz4IXN2ddoabFzGAdbgEm7vn7tvV4NkcpPGNIHScs6fSXHof1iK99Y8riyGX8U9OTLvDyi4/qmvbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747808192; c=relaxed/simple;
	bh=/PmoCyZ6dzOc/MlhabM3w+kAofXoLQ2s+DiWceK6Kz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8wms92qeGLVyIRp6HsIKXJ2NYqLNh5cWjEZktVy2j0+DV2w89hs9cgO7GNfiDj581TtIuM35GmAs5HeIIqStocs3ipgFOGCiKmrHkbPRDxzOvQAmFLIq0aOGGeMwNMUT8pvGA2BIoor9uJOT2ShF/LWDcatvYXY0Qb3pLWaJgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TeK0SRyl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747808189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iw5uJHJc2V+sRbe4e4Tg6n7ubVHazSs+sdmDhxZTg8c=;
	b=TeK0SRylKw6bqqRQR/W2tLODo9FlqzcXeLoplIikBeadKsSB+4+yQ4mRcztllaBxXi/UnZ
	IBvv/TOQH2rTKoRHf8UTeQKgt9Q9oTR+efKb+jGiCCtzuv1PgPii0ZD7sSv6X7mGm/y6Rz
	Bidqo+NBLAA8j4VQE4szs2m/PArwsJ4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668--EHBvxnrPB6JjYYcNUHDrA-1; Wed, 21 May 2025 02:16:28 -0400
X-MC-Unique: -EHBvxnrPB6JjYYcNUHDrA-1
X-Mimecast-MFC-AGG-ID: -EHBvxnrPB6JjYYcNUHDrA_1747808187
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2320ffaa4a9so61599865ad.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 23:16:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747808187; x=1748412987;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iw5uJHJc2V+sRbe4e4Tg6n7ubVHazSs+sdmDhxZTg8c=;
        b=MqjYYIyk9ftUP1zV+bek4Niznecxb8+ImYUJxJlQk/pxI2/xhJ0F5Pc0IvvBf9BUVl
         O+E1oiVxHHXiAdOVidFya5RC6BhUw4698fZ+OsFm1ISbU1wn8eIA1gyJ7QsffS4sNzYh
         zuuPHle+MTjgVQJBTn0qiHh+l50g9ViBVhyhUfdD2XfLawlOheHJXmeGnx8WoTo19pbu
         veULubposvyfy5plpesKq0Od71KjnTPom0YZ6j3noT9FVcI7VumB8A1bEMuoUhET1eLW
         DluJ1ScN3W/voaIrca/LuqvYWeRv2trJMBvvy3BWb3s60amfacic2tZvo0DIlFyZz0xl
         iEpw==
X-Gm-Message-State: AOJu0YzqNKSX4DXad24lRdhZquUjUb1OXRUM54lL19ErvtDHmrnn2kkX
	jCW2VkX88kqXHiXLFv9ov3d+CQ0uDRH7+i5nNCNb1DYSStlM8dNkHsfW4AsggJzwBUi75e/ktJY
	42EeUisiUkUwciVBa/ycIchxRK/tdVSG2CLvGlzjbUf95TgwHXXnnzw==
X-Gm-Gg: ASbGncsDtL1ooWuAcwL9S+edt+yVGX+9sPl1ORqtL2yz6u/bqtbOB95VQuqzv/nNfc2
	h/V2NVEMA26GU4afd13srasJa49DiSLY5Q9mF7T7y1gBD2eT8cKi849yYHaIV03leYQYT/bZ3bS
	F8J1bkSB+3D2jdAr/6/kWxIgWYrxMq8OY12SGG9UOiqYpEQiVV/kIswwApB2F6dHgWRpGD7Sag0
	uTUdYPK07zCtEzezdVqWdZ1CcQG9qhRa4LzI64qH9+JwO6Xas8Wha6l+JsdNvev8TqH2UIyRA+U
	Xo/iabgDMV5fbzs=
X-Received: by 2002:a17:902:fc46:b0:231:bf74:e1df with SMTP id d9443c01a7336-231de3515demr258862295ad.7.1747808187204;
        Tue, 20 May 2025 23:16:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMaGJi9XZe04iIaqoT0LCToE4EYldNnY+Yj53uJr8Djqjif4zPPKYkEdeIkY17gXv01FY1iA==
X-Received: by 2002:a17:902:fc46:b0:231:bf74:e1df with SMTP id d9443c01a7336-231de3515demr258862005ad.7.1747808186859;
        Tue, 20 May 2025 23:16:26 -0700 (PDT)
Received: from [10.72.116.61] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ed5460sm85707015ad.241.2025.05.20.23.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 23:16:26 -0700 (PDT)
Message-ID: <b5d2d946-7f46-4908-b44a-6ce80b67c46c@redhat.com>
Date: Wed, 21 May 2025 14:16:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 14/16] scripts/mkstandalone: Export
 $TARGET
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
 <20250507151256.167769-15-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-15-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> $TARGET is needed for the test runner to decide if it should use qemu or
> kvmtool, so export it.
> 
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

> ---
>   scripts/mkstandalone.sh | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 4f666cefe076..3b2caf198b00 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -47,6 +47,7 @@ generate_test ()
>   	config_export ARCH_NAME
>   	config_export TARGET_CPU
>   	config_export DEFAULT_QEMU_CPU
> +	config_export TARGET
>   
>   	echo "echo BUILD_HEAD=$(cat build-head)"
>   

-- 
Shaoqin


