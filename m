Return-Path: <kvm+bounces-10981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7F287204B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 53170B27675
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9938D86626;
	Tue,  5 Mar 2024 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HqXfUKGC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5944785C52
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709645678; cv=none; b=tdZpfZMbbhFBfBSOx6u8QgHR2zNcRmhXprPoPpY0GtBL8sZNn5ReUUOajz1896hPXIGfy1PIMr65MdaoQGphrlNVyRyobLFfC/HXf4hjbr+/y3cBKfURhulSEy3kxz2+BY3yQlTuBSIEfVHnuW9CKJe+zfgzE428lDqmV/eEqWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709645678; c=relaxed/simple;
	bh=SOkpQmUlX6bJE0MCdVCGdLOMO7UfDnzeTRQD48ZaR4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LWhooYUcRJBeqkUSWYL4Vcpum02vCinSKWimd0F9xJ4M1dFWNpHFw1KN3tr7hUS+7KuvtQGN4qEXu43qFXXWftQaEkv8+OmWlCkOz2+D9yhi1j2wGgUquyyyumpEt1kAypXNsMXuZ6jY954G+pystn+PDEInts+n/G8rb8ZGcVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HqXfUKGC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709645676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pIkZSMkkRKM2ftXQepv9UGxsAg+f7oq49/YynUa9VTw=;
	b=HqXfUKGCc81U54yqPZzkdOIDJDknkkEASh1mZlzwgnw5QctDKn6uuGxxlZetTQFAJ8ouvS
	HV3yQLEDubu9JrQeifLjhKMD9lF74aHCzbZMaeSQcxYERo/hXLAQST2eunlgWOleDX3NJJ
	bFFBAsbgd+5S9lSCZykbUiM25Zfq59A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-Gi47JdNjPz2dDIZlYwN4LQ-1; Tue, 05 Mar 2024 08:34:33 -0500
X-MC-Unique: Gi47JdNjPz2dDIZlYwN4LQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a45acc7f191so33497266b.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:34:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709645672; x=1710250472;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pIkZSMkkRKM2ftXQepv9UGxsAg+f7oq49/YynUa9VTw=;
        b=JFe7fDXDrulWAkMP448Ur1SLp0UXaqVzTiT3MWFdp9cTuACQhQUKncAF+4t7LdhUo3
         UNEjS1wiynewAUSw+X8HuR545KxDp35/LTwbYUROz1PfAwc6CILXiZAIcLhFLn1PVSYb
         N8ybA/uCrFJRBp6ZfdEfEIinwKmDpn7Y0z/6ZTC32LRvhpTENbOyB26EtzKzc4pikcF5
         9J0Tbwj7Qief0BELzkQZ9HGOWPeioxgYAJ/Y0YwArmhsCEL7RWbnmc6Zr5z7pPO7DZ/v
         t98y19yd8uqFJHJD0rnQCT6uuFgRZb0c4DTIzURn6Fjd4dgrxKXJZcsiY8+Qm5dCsXu4
         M4bQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxjYSpTOD/njDjTfOR18MDoLrAXM3XlW4y5PHhCeTHdM6lIVw2BJRcW9wJHytjzxKL5TxfIKEYiVrnFAaa0FV+HKQU
X-Gm-Message-State: AOJu0YyUW2F0bhqFrV2FyAjKpBv+gIHC2Z+GEO4Ckc57SASsANtbZ1fN
	qQEFwr50gL1a6VLm3cTPe64p7KtKjjtnbSe122RU5Mi6YswqX+LTJAHmXplnChOLyHkL+Gg1LQB
	Rci9m1G8+28zh3qYli7N6Hjl0bFB73TgX5vsVPFwLPedfwr5nHw==
X-Received: by 2002:a17:906:16ca:b0:a45:62bc:6b0a with SMTP id t10-20020a17090616ca00b00a4562bc6b0amr3425498ejd.65.1709645672546;
        Tue, 05 Mar 2024 05:34:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWiNcP7d6u1wJZDSG5O7H6b9mUti/yX/XuNrT/XDEKFvKo0tnnRASlTgz3BRM3ja5+FHmJ4g==
X-Received: by 2002:a17:906:16ca:b0:a45:62bc:6b0a with SMTP id t10-20020a17090616ca00b00a4562bc6b0amr3425481ejd.65.1709645672248;
        Tue, 05 Mar 2024 05:34:32 -0800 (PST)
Received: from [192.168.10.118] ([151.49.77.21])
        by smtp.googlemail.com with ESMTPSA id lh21-20020a170906f8d500b00a4421cb0fb3sm6026709ejb.215.2024.03.05.05.34.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 05:34:31 -0800 (PST)
Message-ID: <5dc760b7-b77e-4824-bab2-213d5e822c4a@redhat.com>
Date: Tue, 5 Mar 2024 14:34:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/15] KVM: SEV: define VM types for SEV and SEV-ES
Content-Language: en-US
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 michael.roth@amd.com, aik@amd.com
References: <20240226190344.787149-1-pbonzini@redhat.com>
 <20240226190344.787149-14-pbonzini@redhat.com>
 <ZeXpqf/0YoBmctw2@yilunxu-OptiPlex-7050>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZeXpqf/0YoBmctw2@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/24 16:32, Xu Yilun wrote:
>> @@ -247,6 +247,9 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   	if (kvm->created_vcpus)
>>   		return -EINVAL;
>>   
>> +	if (kvm->arch.vm_type != KVM_X86_DEFAULT_VM)
>                                   ^
> 
> IIUC it should be KVM_X86_SEV_VM?

No, this is the legacy ioctl that only works with default-type VMs.

Paolo


