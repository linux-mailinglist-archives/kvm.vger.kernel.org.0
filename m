Return-Path: <kvm+bounces-44851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 917A7AA4298
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 07:47:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ADA91BA7FC0
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 05:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199811E3DF2;
	Wed, 30 Apr 2025 05:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jx6aVOCI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC35E1DE3BE
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 05:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745992068; cv=none; b=khmhgdhAoJem70vsiAbxnD6SHu3hi8u+ae9c/S5PKqof4iruqEqa27cFm5wsTLElh9bIieSG2gUo/JNDTd2NS+Nk+aBKiHS9POCajv8NPZ7znpQ4W3Yp7Z9KIf3dRfltaacLNouBw1XHsAZ7/ZIp7hQWEZK70od2lqyAy/MQqV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745992068; c=relaxed/simple;
	bh=0Gj8CKa062ZMAoAEd5s2NoFzkcBqpVYig5/ML9jfLCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z7NJBb9rXvnJW4rzYsYRNuXUm/K/ma/ZMAJz1pbLHpkIc+G3Cv7IrX+GXkxnQ3hLdrbah9aEfhuHeGEREer3NN0+X8P8PVwYYzbwPo5t7QPZ0KQLyqEaxHv8e2rMLzjp5AVBiftEuHTFQrlVy9hAolLr7q+i/SYahDOUeQ1am/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jx6aVOCI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745992065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=979akrJcal7eXFEBBeKgkEGR2Z+cXNr2mNqqWnT1LPM=;
	b=Jx6aVOCIXa0B01cJDxU4ZLcQTdhCZXkoYdm+ohunwj3YZeKU3kq0d6SCZRGEdZgPdcO3dz
	2rSXbZivZVPCI7sI0saXmgE8C47E874hxxxiV94h8eiPCjGBbbR9nSNhrTFQrgxEnXI8KK
	TyivIbvlbqTDgTdN+zzBAdGdrPdAIy4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-3wfdTJLIO36X3QZGSaGjsA-1; Wed, 30 Apr 2025 01:47:43 -0400
X-MC-Unique: 3wfdTJLIO36X3QZGSaGjsA-1
X-Mimecast-MFC-AGG-ID: 3wfdTJLIO36X3QZGSaGjsA_1745992063
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b1442e039eeso3891789a12.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 22:47:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745992062; x=1746596862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=979akrJcal7eXFEBBeKgkEGR2Z+cXNr2mNqqWnT1LPM=;
        b=ZfS0rEJ2ea+WcYZLe643ULUWMJwa32QlODWfUO3WqMpvCp3k92lIvO9MimpoD6QUi3
         ovnOa7wZHfmkAkNeu3z+DbowRr8Ds8kpZwfWxVvbr2GS7gNptTsvrsuuOazOY7M6GqXz
         4DcyX2SJIFkvxUs/agbDP19PehKi6qcRUw5yEzfZYJitv36eTUpE8yBy7kWKq55likVM
         eHR5lx96NwZ8Mcl5oW5R0H9UwIMYXeaJm761Jf7bmne75TXo2S9EauZMLVVSH7rn6sgG
         WHp/WzwZRHSZhJhV/ZVQ4r9Xk6cWmW+QqUlMZYhcFZeJyRMvat/4l54d+XjhNh5EYTh9
         ZvMw==
X-Forwarded-Encrypted: i=1; AJvYcCUIdCx/zpOiJMTzSLsDVU2cOh91yVqIkyqE/8dNrad1Juma3g806cdja6V/CaHiHzuK1rA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqq2J9hXxzgtRk5yn/kYD/FfRp3AjwZDwhWXRxLjNJ0CD5PwVB
	7jod8tk+Tb7Gm+2lgKCYNwmrnPFaptQGzVaD148QNcumgF4e2vIDtHr6NWZ3uJF6Qh4ntSvJIne
	TZdUtFxpd6tKd2rYJ9i29zdj0r1nQrG8frJT07LQTOV8RS0TCUQ==
X-Gm-Gg: ASbGncvgVzebmMMXc22sUMUzFpKJXKp3QsyqwcgvVRLcHxa8CnNNA7ltEWWwXnjYGpk
	kVRY6qRlYQA6IQisWrfQUDaC4wlwUNlDpUds8pufIX+//RhL8/NQBJFyfYxdIiMjD2rD1fhZ0HS
	72WuydzoD2BBOYat2hTLXx/WQumf9g6YW88cjuwhzi34qamX35h8Dqa0cYFTqnw67+hlTwdYwRi
	Nw87Kjuuqbd0WtxmPEUqAjXvbsvsKh9XCnqM76OZBvyUdnFW97wWFkRU62RFgFw16S1ND1wV4hk
	tYPCn31br7Bc
X-Received: by 2002:a05:6a20:6f0a:b0:203:de5e:798c with SMTP id adf61e73a8af0-20a87758d04mr2491505637.18.1745992062583;
        Tue, 29 Apr 2025 22:47:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2yvTT56xhp4nevnnTnhdd5Vxurc2bkepUSfMbuUK1rX9UIiG+hWa401GgVAzKuOXYEii5qQ==
X-Received: by 2002:a05:6a20:6f0a:b0:203:de5e:798c with SMTP id adf61e73a8af0-20a87758d04mr2491475637.18.1745992062247;
        Tue, 29 Apr 2025 22:47:42 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a3100dsm787733b3a.90.2025.04.29.22.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 22:47:41 -0700 (PDT)
Message-ID: <9c998d71-0368-4f93-ab37-7933bec9b419@redhat.com>
Date: Wed, 30 Apr 2025 15:47:33 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/43] KVM: arm64: Allow passing machine type in KVM
 creation
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-10-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-10-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> Previously machine type was used purely for specifying the physical
> address size of the guest. Reserve the higher bits to specify an ARM
> specific machine type and declare a new type 'KVM_VM_TYPE_ARM_REALM'
> used to create a realm guest.
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Add some documentation explaining the new machine type.
> Changes since v6:
>   * Make the check for kvm_rme_is_available more visible and report an
>     error code of -EPERM (instead of -EINVAL) to make it explicit that
>     the kernel supports RME, but the platform doesn't.
> ---
>   Documentation/virt/kvm/api.rst | 16 ++++++++++++++--
>   arch/arm64/kvm/arm.c           | 15 +++++++++++++++
>   arch/arm64/kvm/mmu.c           |  3 ---
>   include/uapi/linux/kvm.h       | 19 +++++++++++++++----
>   4 files changed, 44 insertions(+), 9 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


