Return-Path: <kvm+bounces-45016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A54EDAA59CF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 04:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C94E9C16B4
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 02:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E293230BC3;
	Thu,  1 May 2025 02:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zz4Ax2Dd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEC622D7BF
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068259; cv=none; b=F4UHLy837Hx7Z7LpPC89glLSfit2XO1ir89n2S+UbVzCbJrGPYK+HLUA3c9/az80ahEHLqEJ0gKmPq49sCECJTmNdEJHDY8pV+Gbe9bmqaeEarXOiofJVT+aOEVieWX/dFk4N9R8JfKKFlHTrEfBcGjEVfstuGAByO9ilAzX6TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068259; c=relaxed/simple;
	bh=pxth/1xDNWc+yIhoqkRG3JLP0W+Nj7wVL5JFRfk8L2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NlhpUvxybDDIqlt0B7xNQsqTHTuiDCT4OuEE9FAZ8O53gh/b36Yvytk4Ulxe3BNvVZva5XaQR5PhzznQhmpX3a1+JfLbJh3qpgPuGXdgADcMfjg+fjIXObVMQ/bbsqT9FKnZ2tqBEjnbf2ajPlye4RTSMeD2EvUDG/vJWNAyk08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zz4Ax2Dd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=adT5sphxyEt5TU22Dqx/wn9ELnNmdh1UTMCrVtoQyks=;
	b=Zz4Ax2Dd/tvbzthz5uYGO1teyuKhvTvpfspDa2ZcX8kCrvbDc5IvCDJm+k/jwljwX3P6zH
	FhXX1xfvxaewhh17QcHGfVaxWWVQk9HqC8tY2mGF0jbc3GUPrI2hBI4UFhAooWuWGF0ogZ
	yufwCtp4qaF5mcnW2cwrCMQSifpUXpw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-CLTqRW4yOMCfhoHPw7zN_Q-1; Wed, 30 Apr 2025 22:57:35 -0400
X-MC-Unique: CLTqRW4yOMCfhoHPw7zN_Q-1
X-Mimecast-MFC-AGG-ID: CLTqRW4yOMCfhoHPw7zN_Q_1746068254
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b0ae9e87fe2so1241874a12.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 19:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068253; x=1746673053;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=adT5sphxyEt5TU22Dqx/wn9ELnNmdh1UTMCrVtoQyks=;
        b=I5HoKeO8Bu1akAdM4E7RpSHfMkSIuaGestft7/3IPdI83FOtH8V3S/XJgqXhsvbya6
         M6gkjda8ZVjw4YStorjTwo6HGbppiEDd6olyLqev/GCygx4JTOLPgWQbBduubzCPjpog
         DKlLvkp2PuJ0dwu/oqVXr42266npS3Tx6SlsVvnPibiqNN6kTqjx3jHKNyNwEIk0X/TH
         R0x0Mf3aHS/9EVlV6eBqGOu/HcjXRI+IC8WZ1F9ygs7m+XjaONGQrjMPQG+Hzmx4TuFQ
         3EPFNh4gYsdBWCxnxg5b6C2ruja/88iMdSAfWnyPmFUHbMRB/+TacCWMTBE/8Sfe+KYH
         ZZ7w==
X-Forwarded-Encrypted: i=1; AJvYcCXintyxvTbN5pTHhiEbteFi4BARTHYjs/qvnBHRhNX11zfcl7Ix1xB5ODY745tzuGQCDiM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtURx8KqcjlvGO4ZGOB5Aer1L8HiJGYjwriN6bMv8qKMAY1835
	zOOfV1qdRW8adF9mzCrqXjMi0hFWS0sY1Xxdd4q4pUHOYatIW+ggrkdWzExOOm6xR5dYmf7khai
	q2t8YvZ1YZo2g3/yrG2zefAyJjVqrQQXBzkNqdH5PwfHTB1HoXverput9Bw==
X-Gm-Gg: ASbGnctK87DYC28xgFGekiwSlkwR7zHGgsAlSGFqeD+UjtzDZVKCFoKMWFOz5xvQ5Bf
	25LvOsutqKbmOGioMNdXdtq56/URlNFTwE5Kx5gHbkmq3sJwq898omtagpq4ek8ly2q1uM11IKg
	Rb040BS8N/GsIgXkptJL72bxzUCjQDeJrwS8c8DTEZ1pl02cL5DVocyHZtWuz3KYnhuRE0aCI5x
	C0UtLEgz8LGZ2pcrfmlqLNlmizpRIFCIlPxx9Wt7h7VOTrmjkSaKWCVvyaJTzjENWSdHfPxNc1r
	FhLoqF9F5E+n
X-Received: by 2002:a05:6a21:9982:b0:1fe:8f7c:c8e with SMTP id adf61e73a8af0-20bdcd9a950mr1117786637.15.1746068253304;
        Wed, 30 Apr 2025 19:57:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbH4/Gw3xjrMySuSbtOSRK/2O61f3IZwIB6ICzlmAJxo3vX/hkeDxt9OR3pskpgqpIhEiucg==
X-Received: by 2002:a05:6a21:9982:b0:1fe:8f7c:c8e with SMTP id adf61e73a8af0-20bdcd9a950mr1117766637.15.1746068253021;
        Wed, 30 Apr 2025 19:57:33 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740398f9786sm2578662b3a.15.2025.04.30.19.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 19:57:32 -0700 (PDT)
Message-ID: <afe9167c-8867-4e5f-8c0b-eb8d6b2813e1@redhat.com>
Date: Thu, 1 May 2025 12:57:24 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 27/43] arm64: RME: support RSI_HOST_CALL
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-28-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-28-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Joey Gouly <joey.gouly@arm.com>
> 
> Forward RSI_HOST_CALLS to KVM's HVC handler.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Avoid turning a negative return from kvm_smccc_call_handler() into a
>     error response to the guest. Instead propogate the error back to user
>     space.
> Changes since v4:
>   * Setting GPRS is now done by kvm_rec_enter() rather than
>     rec_exit_host_call() (see previous patch - arm64: RME: Handle realm
>     enter/exit). This fixes a bug where the registers set by user space
>     were being ignored.
> ---
>   arch/arm64/kvm/rme-exit.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


