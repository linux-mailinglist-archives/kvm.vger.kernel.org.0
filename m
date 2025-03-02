Return-Path: <kvm+bounces-39832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 512DEA4B584
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 00:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26CEA18905C8
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 23:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728AA1DF968;
	Sun,  2 Mar 2025 23:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FERXq5lW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADC01D7E4C
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 23:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740958798; cv=none; b=CQGKeS3vaAwSG1Gn4dGmbPz73IFcYGr4SxKrzEYYTY4emfRsAJPG4E4Si0dnKqWSb4cVCWiUPpc4LHd9vb6At3oXlPclK6RhNKe0c2YIGnaZSuLIZWU891XG0uUaeGpciIkTNQffPr2jhlZh34gog7kKS6draiav/pHAYj41/d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740958798; c=relaxed/simple;
	bh=D9aHcBSNUOKIFyFQgdytxMHadQ9miqe4zl49cgpQmPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e2cS5ntuqKKx5aDNA4ySVnhgK4SrlkDcrh+zn9n4QnfukjIeMRi8PevtN9BR3gGfLWO9gx+sUXWQk7eIIMayCQwyF3KhmzRncrYxWjszQuy+JPwhrC5v/2gea8EnEabaRy5nBbm76iw3AtjQPjJ1wzCHue3z0yYdpUBLFF1dWwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FERXq5lW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740958796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GBo5+OYmEobg6wfjqU2wwAFpXo5iLmkJqiW1kfdikek=;
	b=FERXq5lWPnd9wUjq2dLt3e0PRwFf5I3CuxT1QZoEcVp4I/3IFRnHcgSBIB/ne105bIXuxM
	clvimRJ0DoKoyKSR/op/5N7VlDHzHJkvXaat9G3HfIqcIKVtJV2DcdZnYiGX/BmQogZPUa
	tNLM/RUCPmSvOeH4nlj8Ok9MDdtraGk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-93CrR9lSN9eyFlMknRDDgA-1; Sun, 02 Mar 2025 18:39:52 -0500
X-MC-Unique: 93CrR9lSN9eyFlMknRDDgA-1
X-Mimecast-MFC-AGG-ID: 93CrR9lSN9eyFlMknRDDgA_1740958792
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-22368fafed1so69572865ad.3
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 15:39:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740958792; x=1741563592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBo5+OYmEobg6wfjqU2wwAFpXo5iLmkJqiW1kfdikek=;
        b=g4ZeV3aQykN+GWhHVw44iEqwyW0jWaHmCSQhsqYYnxgFeohaKvc1+9DbQ5PLfnpjMk
         80DnMP+zpYANXHiSmbWrkgwbJbqbU42FxHYcJeL4rChjdwIM7kU/lnKKDlLUNZRH1vdV
         0TxJV9cZlUvXFIIj+pbCDzfkXFrxf8EyKrWImcHGt5qKtPgXmrhl/4+evFDbyKnmiyl8
         blGgLVJitKlk3dA+6pd8VLgCk7leMVUKBtTTRPvAFtN5RHphIWugo2dX/QSzsumWalCP
         mKFme3d4nZKIOJBv3O5eVoJ9j5t1luRQrjIMzN5jmRUauBU5qdTFHbsbn8wnsfEgyLSk
         nJHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYgy3306O/jaW40uXkXx5oELHzkGAMu1QEWN0H7tOqwUV//pfQJLEANrwzHdrb2NWs8EA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7OFLOIvjcMdD6Cly/73fgtqxU1HjN8bin/lclVIjlQG8I2H6t
	ubwqOuTYGGw9po66SC22YwlKNNwCk0uusfpuncPvOurxP6TpXLrV7YOZhvaW8a5GOFLMmZK2Tfv
	UGzxXYw0+3N5XY0ztk2yFMt0aqRAD8hc5s8gmm16kmjKOZajOwQ==
X-Gm-Gg: ASbGnctjTpAYf+7tOjXdAYXBdmsZgbN9409cPfy5mE7EWlwUeI+uvjd2sdAIxu4XQ1F
	NHsN5NedE4Xsed/hKZMEbZ6hSiqEN/rG/qirPA8M0/qWBIGu9qM6Fcd44kh/RutzsX0ZAQc1OHL
	V9C15vriukwV9oN6cyvCt7hlqkT1ONiWpfeeZxClAinYFAEav3etUiQ8quZPWvghEkIDtYiTSPw
	nRgQv7yAFrjIrwcp6OelxXtV0JwAjIG6j5eliFVC/U2E5cHrdLavrwU2u8pNjF8u4mfP31yYwgO
	gONNX55jLRcSK+rXoQ==
X-Received: by 2002:a17:903:32c8:b0:220:be86:a421 with SMTP id d9443c01a7336-22369258505mr198701955ad.38.1740958791839;
        Sun, 02 Mar 2025 15:39:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtWQhLEYN86O3XnJuZetDZhwrb65+Q6vvyxqpw4uBVTdAA/3YJ21/tM+WdLRJLHGH6Np0Auw==
X-Received: by 2002:a17:903:32c8:b0:220:be86:a421 with SMTP id d9443c01a7336-22369258505mr198701625ad.38.1740958791506;
        Sun, 02 Mar 2025 15:39:51 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d26acsm66078035ad.9.2025.03.02.15.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Mar 2025 15:39:50 -0800 (PST)
Message-ID: <a7077902-4286-4b3d-913a-20083ff260f4@redhat.com>
Date: Mon, 3 Mar 2025 09:39:43 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/45] kvm: arm64: Include kvm_emulate.h in
 kvm/arm_psci.h
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
 <20250213161426.102987-3-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-3-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/14/25 2:13 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Fix a potential build error (like below, when asm/kvm_emulate.h gets
> included after the kvm/arm_psci.h) by including the missing header file
> in kvm/arm_psci.h:
> 
> ./include/kvm/arm_psci.h: In function ‘kvm_psci_version’:
> ./include/kvm/arm_psci.h:29:13: error: implicit declaration of function
>     ‘vcpu_has_feature’; did you mean ‘cpu_have_feature’? [-Werror=implicit-function-declaration]
>     29 |         if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2)) {
> 	         |             ^~~~~~~~~~~~~~~~
> 			       |             cpu_have_feature
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   include/kvm/arm_psci.h | 2 ++
>   1 file changed, 2 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


