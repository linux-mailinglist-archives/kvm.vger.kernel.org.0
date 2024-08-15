Return-Path: <kvm+bounces-24229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C03A95295B
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 08:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FCEA1C21F90
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 06:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB829177991;
	Thu, 15 Aug 2024 06:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="u9101bKX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FEA18D647;
	Thu, 15 Aug 2024 06:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723703267; cv=none; b=Cf2p62JjZ++g2TNCEcgS5BZZctXG1cqnC+sKmy8RmwZ8IRwujT5bCg2MENINjUiaagyLrhaF/Lk3esyFOCQ9oqmLP9K99gaQLo9WVom5Sf3gqJJljyPH929ObIHytdsgiECkEHELZImNA4EVomjRad/GfJei3bmreDAlSwV84y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723703267; c=relaxed/simple;
	bh=J5Y8QVbb/bZLjN9qlvYdrrwNQKTd27fQfMkdishZUsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=akHCPKWKrKgKvoAvQCIpGgJEyvSuObswM9+aPva/yK6nqL8mFVcIPj3DPIMqXeyllbwLxNHR2y1V7hvqhthHMkwyp8gqVxr5CWSrWXR1Qwq/g33zlzAImxVPxuxA+WsmFRZ9q4TC2SJH+FsorK/5TUZPrOu37Tkq7UO20TzQ+IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=u9101bKX; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1723703265; x=1755239265;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ocJwE3jhUgEqiS7mFCudZRyh5bdi+nGlbsKkOR13sH4=;
  b=u9101bKXlQIu3Vkf/7BOC0sYMq24nbV5hJfT+cojuE+buQlFaLHl/IYY
   UYEo83Pe8xnP7+99tZMaA9iccvieBbnPaE++gAS1howcGI09O7AZlz11U
   a6XJ6y7/Jtrw/cf29frzvJcsyOW+Hy0RWzSDnbgUxgzDnfTnhupX3Apfa
   8=;
X-IronPort-AV: E=Sophos;i="6.10,148,1719878400"; 
   d="scan'208";a="225465767"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 06:27:24 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:59062]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.24:2525] with esmtp (Farcaster)
 id 39f06e66-0d12-4327-aa61-4415e30a17e7; Thu, 15 Aug 2024 06:27:22 +0000 (UTC)
X-Farcaster-Flow-ID: 39f06e66-0d12-4327-aa61-4415e30a17e7
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.174) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 15 Aug 2024 06:27:18 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Thu, 15 Aug 2024 06:27:07 +0000
Message-ID: <910085c1-c29c-4828-853c-70760b458086@amazon.co.uk>
Date: Thu, 15 Aug 2024 07:27:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 09/10] KVM: arm64: arm64 has private memory support
 when config is enabled
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>, <mic@digikod.net>,
	<vbabka@suse.cz>, <vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <shuah@kernel.org>,
	<hch@infradead.org>, <jgg@nvidia.com>, <rientjes@google.com>,
	<jhubbard@nvidia.com>, <fvdl@google.com>, <hughd@google.com>
References: <20240801090117.3841080-1-tabba@google.com>
 <20240801090117.3841080-10-tabba@google.com>
From: Patrick Roy <roypat@amazon.co.uk>
Content-Language: en-US
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <20240801090117.3841080-10-tabba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Fuad,

On Thu, 2024-08-01 at 10:01 +0100, Fuad Tabba wrote:
> Implement kvm_arch_has_private_mem() in arm64, making it
> dependent on the configuration option.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 36b8e97bf49e..8f7d78ee9557 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1414,4 +1414,7 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
>                 (pa + pi + pa3) == 1;                                   \
>         })
> 
> +#define kvm_arch_has_private_mem(kvm)                                  \
> +       (IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) && is_protected_kvm_enabled())
> +

Would it make sense to have some ARM equivalent of
KVM_X86_SW_PROTECTED_VM here? Both for easier testing of guest_memfd on
ARM, as well as for future non-coco usecases.

>  #endif /* __ARM64_KVM_HOST_H__ */
> --
> 2.46.0.rc1.232.g9752f9e123-goog
> 

Best,
Patrick

