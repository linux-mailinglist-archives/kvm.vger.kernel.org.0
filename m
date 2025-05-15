Return-Path: <kvm+bounces-46742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6BA6AB92E0
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 01:43:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 018764E798E
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 23:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CFB28E5F1;
	Thu, 15 May 2025 23:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JKtnNuS4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B361C1E5B97
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 23:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747352579; cv=none; b=Cs4bsKbebF0mPZBB1xV5bzFoH8dCom+5C0vn7awZeInwdo9WiV0uAHytJnc7kEwKUZLfv9vgGjzcV9hxE9PF8lwVmEiAPrxBUyj8vd4aGKtAwnwXol0v68VL7FbGkyG8EVgzgKxfrAiBG0EdljGmLoxYb4wlsmMouSYuvrndeRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747352579; c=relaxed/simple;
	bh=uJ0aT88Wt5fc3RAOz7XQ9F4rbUALOUsnM+yBgPuBdRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RtnGsthMGhlC1exz1vZSn/dH8vC72YkV/g6tnQgpFP7rvD9lFwQdvDA5Snqzjzd7qKUzBXJFNjmHn2vHcYAI3A6adeDhTQfVxNFIpQ8My2mJw6+X0Q6skbdblkYwEPYSjqoX9vdM8fp34W8KgQl/Q700q3sybHnHe3q4NPuzhfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JKtnNuS4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747352576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D543q3muZl4ZTiDO4u6l3P+84dJKDCsQhD2gkZu4SUY=;
	b=JKtnNuS4x0cOCaOJVskJiDNikNzKCvEtkI+rhTQQWCkJv3wvvmhc5b7MXMBdveYfio9N2X
	h8tgqnzfE/KU0wJDsoGTPQp2WTL4v+N0CJ8BSS5qTW0Ey4JoUsyP8Lf6GBQxLhWINmA6Qj
	KUw9tvGkTGf2b8JGQPHGbhzUchEAPBc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-byuR1INbOKusuXZzZ3gihg-1; Thu, 15 May 2025 19:42:55 -0400
X-MC-Unique: byuR1INbOKusuXZzZ3gihg-1
X-Mimecast-MFC-AGG-ID: byuR1INbOKusuXZzZ3gihg_1747352574
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-30c14d46b55so2388908a91.3
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 16:42:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747352574; x=1747957374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D543q3muZl4ZTiDO4u6l3P+84dJKDCsQhD2gkZu4SUY=;
        b=sUtG7SFYoqge03TACZQQxjKWnbhgyL60oouxDOuoR29GEU9OFSgE1XSodrhaNUZLbF
         K2OzWtqv5StrxRuGqeggVpWz8R0jmWzVXcg6wFWNTird5UfC2PJNjJHcu/TsM9CyK+tQ
         z3xuRBKjgAHcgL1LR8N4obm5Gbet9xo3wGhEpxe8QpaBJU8Cwda2L6irCfDM+NO45BUc
         JgSbZcot+kkymB+Mr93E6rM1XRzYDWHtqUYFoAd3UDf+sQke2RUIDlovpkB8+R5FQrJS
         5uM54bLM431/PNBiPu/bWnZF1Anyz+7Oq1yLQYQLZZb33vUuiaROmDoYOSxN2CcDelX5
         HY7g==
X-Forwarded-Encrypted: i=1; AJvYcCX0s0ZZ1MdpoVhBGBST4GRTeYSO7r7vuf8ldj09r4cCptgQkKMMqolHjp5QyU5JlRs2xGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCXgkVdHqruU2e1839G9EICcGh4AzjlA4ounxggf7kcnExv3E/
	sR7ZBQGKHlG+DLUDYSzTiA1HAIdhcl6z0wIPkjACOApzRKnf02lM0uBPnOyUl4ErMHLXc4PUREa
	8s3h2i5+1sDkSwHPdsf7eJvQS1T3ywdxTlrQCQxyWcmpq9C5bveUV4w==
X-Gm-Gg: ASbGncsISzpY27rzJYuADlBJmPl++s50bq4CEdZnimmxfGiwFub0ifljfIVYxQTsccw
	si9O/srUjVcxcEC6pS1TcPQoZfBYRGmGjLTseEh/2grdsqs6g1o3jc05D2rItoD5SCugdTfAXDF
	6IJ7AuFhKuNMmFLbJrz1mnr3w4flTtyjBa/JvjXbmXm3nEzB5CX2xfPSvdCSK3VG25Uzikh9QY6
	cim+nn/w9HR/yhVFjrr8SKZsHUSxG6OaKI+c4Vj/pEj7fTZVzC97eONZ8iDNl5b9UQ2vlMNYpXw
	gIHX8qXZndiD
X-Received: by 2002:a17:90b:3e8e:b0:2ff:58e1:2bb1 with SMTP id 98e67ed59e1d1-30e7d5bb1e9mr1333526a91.32.1747352574472;
        Thu, 15 May 2025 16:42:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRL/1O/Rrnq8ioMs+d0i5/D3GPpfrLPajlUsLeikruv+Yje3p8yvM4Ix2Eud3DGPaH1u34zA==
X-Received: by 2002:a17:90b:3e8e:b0:2ff:58e1:2bb1 with SMTP id 98e67ed59e1d1-30e7d5bb1e9mr1333477a91.32.1747352574064;
        Thu, 15 May 2025 16:42:54 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e334016e7sm4069046a91.9.2025.05.15.16.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 16:42:53 -0700 (PDT)
Message-ID: <9a2431e0-252d-41c9-a91d-9e02a8779e8c@redhat.com>
Date: Fri, 16 May 2025 09:42:31 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-8-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250513163438.3942405-8-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 5/14/25 2:34 AM, Fuad Tabba wrote:
> This patch enables support for shared memory in guest_memfd, including
> mapping that memory at the host userspace. This support is gated by the
> configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
> flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> guest_memfd instance.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 10 ++++
>   include/linux/kvm_host.h        | 13 +++++
>   include/uapi/linux/kvm.h        |  1 +
>   virt/kvm/Kconfig                |  5 ++
>   virt/kvm/guest_memfd.c          | 88 +++++++++++++++++++++++++++++++++
>   5 files changed, 117 insertions(+)
> 

[...]

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..9857022a0f0c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
>   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>   
>   #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1UL << 0)
>   

This would be (1ULL << 0) to be consistent with '__u64 struct kvm_create_guest_memfd::flags'

Thanks,
Gavin


