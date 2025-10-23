Return-Path: <kvm+bounces-60898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 44BA9C02B15
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 19:16:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DEA7F560DE8
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 17:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0E73446BF;
	Thu, 23 Oct 2025 17:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ioLBWxy3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C134402E
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761239407; cv=none; b=c9IKIXepllvH3WJwvvaxZ3aMEh/GIlC0uXsnQPVIaU/h6NVm49q5R3ym4W/ifl9Y8UHkeY4s2s+R4tnvWxQ6KcDy+O0pCFfZtKsaaZl/JDWGsmGhRuYP0sivqU9h1v3oJJaf31TCldF6g5GKqM8jdYfrOMK7GwDCX/HfFnyAu/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761239407; c=relaxed/simple;
	bh=+Tzm05G8OP9Ub45Ed00gm//RkZgsf1afggpDogpUKf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BvCvQKqH297QDCMlKRNCd5HLn2BpFwXDqJx8d7N3ClW9WzBnawnnRBzGmM/hkyUGpwUoy0pWxaCsaZsvh+jd2cYxWAO2N9rJ/XDtRSegPWr/ukzT7V8oMAnh45x0vzuXN28B4bnLUy4EjKX93zUCc2HpGfkxiYr9TFLbDoHZMBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ioLBWxy3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761239405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sIho/DDzaUGECoEpXxSYe8QzakIm7oukB+I/Bz1nx2A=;
	b=ioLBWxy3PdV+XV51+1tWgQdZsPC24gDy5I4n9HLjEaIODmhNM5bcXWJj9MImkRoIqao0J9
	QKBsroeB/SiSh3IekpExLNdCVGzIxVHGPsUdRLsBWlRTlUfsJti1jo7BvJxF2IkXssCE2+
	LIInIzma3IznX8Kr8SOK5hbHqjl9nxk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-5O3d_5b0PXOqLQvjdx7wTA-1; Thu, 23 Oct 2025 13:10:03 -0400
X-MC-Unique: 5O3d_5b0PXOqLQvjdx7wTA-1
X-Mimecast-MFC-AGG-ID: 5O3d_5b0PXOqLQvjdx7wTA_1761239402
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso737589f8f.0
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 10:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761239402; x=1761844202;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sIho/DDzaUGECoEpXxSYe8QzakIm7oukB+I/Bz1nx2A=;
        b=DO67bZ5/igSoH935vkkboQdd71tR0pABcExzfHb8TvWL0Wh5VMuSW1lvMJk1j6XgJT
         8Sb1y/S3+OaESSXJ88klkvk6FS+insDA8M26YDDhnBfa+wZGFESmClCLioljNuw2hotD
         N0ckMEr8BpXJ21S0jfvKMV3VBx8IdjRsqUQvNbTsJCMVp3+RTdFCYBjJ+jdKSSltweYh
         OEuPWIqyJCy6h7t2wm4fAV/bMxgTl+7CgRVteNFABcD6IwW1FpTxkr1Ls+aqaetQO4SZ
         WDwmy9jeOn3RSIgJn/gzPug699d6Fg76i8osUIqDIDUjdQHvmZc4w4qw047hC65cUQTR
         m3CA==
X-Forwarded-Encrypted: i=1; AJvYcCVoOQ6En+5lgCyndQFLFZVW6g+MechZZU3QXEgbLnGL5tenw0t3zjOtScstyf5+2JC5eXw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjsRhh1Z+bql4AqBU1rYV5v0YpVZJ43zr2ZrMK2IHNC/3KASRr
	ULwIhN7z2LageknDMp6iUqs3QQgB8GF3VgbxQbwb4jTrrH6vxTBCOBPUru7M+zYHH+vjaz8EaAJ
	1RhPrCvopwUqdBvmgKfo6tKDAv7I4Fj+U+qq5hP5E9AuwFi8QEIVbjQ==
X-Gm-Gg: ASbGncu8GrlMdVfuKUt4PAoYrofDdeLeqkXhGnItFPlvG/IBQSXWU+k0Op7ZmYQLq9k
	+cFPpfCiOMoCVGUwbUOAlgNHVru14uygHoCJXr/zBAFm9ekvEBWBULlikGSh0DGohc4ScXsBOy3
	mO4e/X9LomPEvAfYH7gak5Y/Dm1bF/3lSwA5589gimle+gqE72d+EMaTmIoFAeVjS81CZKS87X6
	XEXhTWNhXvVTMBrjsqPSYIGYHmN1G8JSC77HKUUfF4iVRjn8wWiB93eQpVz/GvciDlERlRjAd6A
	uwEFc3tetBrW/w1Grf9HvkMwwnOH1eGTDLEB3pVk98upsgWlnyHbwQVS6gc7MPBc5y24MwXjXTt
	mnZaJsvm67uD5PJ/5Vy+QXpSpsLEnVmQqiFCPlOzsbsRnqRyd/WJchyBPOc+g4KbnFuj/ndtxZ1
	IIFw==
X-Received: by 2002:a05:6000:2dc3:b0:426:d54d:224d with SMTP id ffacd0b85a97d-42704d7ebbamr21063047f8f.27.1761239401988;
        Thu, 23 Oct 2025 10:10:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeBhshgveus83Fujm4tgQ2AjCJ8NaeUFWeh9Yb6sABVsAFvyZkwYO71LXFd/b8AbLwDNMtzw==
X-Received: by 2002:a05:6000:2dc3:b0:426:d54d:224d with SMTP id ffacd0b85a97d-42704d7ebbamr21063025f8f.27.1761239401614;
        Thu, 23 Oct 2025 10:10:01 -0700 (PDT)
Received: from [192.168.10.48] ([151.61.22.175])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429897e763csm4959502f8f.6.2025.10.23.10.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 10:10:01 -0700 (PDT)
Message-ID: <8901c04b-6fb8-4964-a8dc-5a871d026a70@redhat.com>
Date: Thu, 23 Oct 2025 19:09:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: KVM Planes with SVSM on Linux v6.17
To: Christoph Hellwig <hch@infradead.org>, =?UTF-8?B?SsO2cmcgUsO2ZGVs?=
 <joro@8bytes.org>
Cc: coconut-svsm@lists.linux.dev, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Sean Christopherson <seanjc@google.com>, Thomas.Lendacky@amd.com,
 huibo.wang@amd.com, pankaj.gupta@amd.com
References: <wmymrx6xyc55p6dpa7yhfbxgcslqgucdjmyr7ep3mfesx4ssgq@qz5kskcrnnsg>
 <aPpE8emZ9n4N7S-T@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aPpE8emZ9n4N7S-T@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/23/25 17:08, Christoph Hellwig wrote:
> On Wed, Oct 22, 2025 at 10:35:28AM +0200, Jörg Rödel wrote:
>> Hi all,
>>
>> This morning I pushed out my current Linux and QEMU branches which support
>> running COCONUT-SVSM on AMD SEV-SNP based on kernel v6.17 and the original KVM
>> Planes patch-set from Paolo.
> 
> Can you explain what this alphabet-soup even means?

With pleasure :)

- SEV-SNP: virtualization feature to encrypt VM memory (SEV) and also 
protect from attacks from the hypervisor (SNP), by matching the 
hypervisor's page tables against a reverse page mapping (from host 
physical to guest physical address) maintained by processor firmware in 
collaboration with the guest

- VMPL (bonus): SNP feature to create privilege levels within a single 
VM, for example to manage persistent secrets.  The firmware at VMPL0 can 
hold secrets that even the guest OS at VMPL1+ cannot access.

- KVM planes: KVM feature to  create privilege levels within a single 
VM, including VMPLs

- SVSM (Secure VM Service Module): privileged firmware running at VMPL0

- COCONUT-SVSM: one implementation of SVSM

Paolo


