Return-Path: <kvm+bounces-36466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE76FA1AFE1
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 06:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 402C47A3F34
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 05:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5145A13A879;
	Fri, 24 Jan 2025 05:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PAsNv9K1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C8F17FE
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 05:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737696746; cv=none; b=pj8JBEQlD8/I2tLmsqoTmQq1tVXTEldNi1GtivnEJ/nvtjuKq5CsY+EyGd2qYH8VBosUZ6DV/cRFIql/u6C2PVXi0mGNqJDfXgiz7ZkjE4AJSa9Vx+f/ghu0k5Ug1WGuaQUvMt9ufCwDelO4SgOACFqxFPL1l2U4aGkZdk2LS+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737696746; c=relaxed/simple;
	bh=/nAMaLIJE3OA+tTLrtrMtWBBmmKw6odEO1dmDd9Kt1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ud4VRNrYxMiw/W8X4Ju1a9UTsKxCrlbac4d4EGKtmvx18skksFkmOc3pClQ6JEzySkbjfyb6+ABDmMDCE9ej9vNw4hvTbl2Cc8GCI+0LpIwq+potMlI02Gbw0MGEO6eLWa8aEpAXGy13CHHGwt/IOTQmHx/XDxlTJu/llJ3a5bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PAsNv9K1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737696743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V43monYRek4i4a9qcZNzucxU9HOMr2YAU2s1SvTctS4=;
	b=PAsNv9K1uBjWJ7NnHYcCBNd75JS0zmtFhPjrDbLn59Djp8x3KailazMkNW+LLCbjDFj8kC
	nSxWcKDrxJ7WaCE4mSNITxElzO4T+Nb+H8m6ST5ulsKMiFNbLCuafAXH53s6kjuGbNdXJM
	k8XbKcT65squvhu7U3f3QNGUKgIjMmU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-WTYeOK5LPi-BUPIpZmdfhQ-1; Fri, 24 Jan 2025 00:32:19 -0500
X-MC-Unique: WTYeOK5LPi-BUPIpZmdfhQ-1
X-Mimecast-MFC-AGG-ID: WTYeOK5LPi-BUPIpZmdfhQ
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2165433e229so34543795ad.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 21:32:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737696738; x=1738301538;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V43monYRek4i4a9qcZNzucxU9HOMr2YAU2s1SvTctS4=;
        b=exGl97xIxAFgXfI+1fAf0fHjhZf35qWccFQl37xw6NT6XlwkSb6cryOqJgbO45mub5
         9Fa7azG1jrEdtAUebY3SaEDuAXzUUMMfaxPj4hy+C00ArKwrbNOHfH5QN5kzbbwx3GZm
         aDMgKad6JZLgEfiAF+6IACMrRVnC0+N/5ePlV+b6ltp44gKAG/09bE7T226Fj8ExxjQT
         a4Pgcdp1mbbpuoisPR3fNTdqiMWkoSOqxhPSS2q/r9uUac/YhDBETGgKPSNkRVHE1syk
         s7sNMMqi0nU494eeLJSAPrkTesRZ/9rCugpLh4hiHqJfhzS+HBXQNLQK3gsp+2O3JmEK
         c6RQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3mSI4nO2ZxdOuncy5fl9+pfHD7V5nlJJ+ZWR4r5rixG6VoBn8iFdnNsYERQvn7YmtVqE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrTl3VHxUdWEKoLaIgZz1bknWwdJ3VG/v+bFPWkTwLxA/7VDHs
	i5md9tjs7v9kugocugt0UKe2/G19cIFPJVgcou2mqjXCpyvquO8jcCIDm3as1QYSl1Jty9b6won
	YXv/qA1FAx9RyjyZCdrNdgh0iolCD2Avvv9r+lgjsJvUZL3qMxQ==
X-Gm-Gg: ASbGncsDafJnmMfxttg0dgAoVYkdZuhZxXh8PvDUqw9QphT0r/JCYOmSRhqLhnLBVEr
	mmY6bd03kqSehgPSDsouYC2/nL0dhN4IA0JnL2ZsJ/qlb32DUYG35EJSW1zGcPvl0QPVwfQuNU/
	jEiX6LNWKEw9f0KJFhlHNmzcujZ9iSdPWFHdw6EiU6iHttgFixVg1oivBwB0q+1l363lzLJ7FF5
	r+v8wBmxTCSLaPT87lip8y3+NerZ/Vs+HuZdg0CvLk3Jd4hDnH6ISmIyX3CJhUmdZSxKCA=
X-Received: by 2002:a05:6a20:244d:b0:1db:e464:7b69 with SMTP id adf61e73a8af0-1eb214e82damr43379305637.20.1737696738453;
        Thu, 23 Jan 2025 21:32:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHqtpZFSrhtF7huOze/hKmkOEqq4y/TfOMaysezICpsnQmSYkT3LOCtGnO0n3WPfw/BdJZyHQ==
X-Received: by 2002:a05:6a20:244d:b0:1db:e464:7b69 with SMTP id adf61e73a8af0-1eb214e82damr43379243637.20.1737696737997;
        Thu, 23 Jan 2025 21:32:17 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a77c4ecsm909347b3a.121.2025.01.23.21.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 21:32:17 -0800 (PST)
Message-ID: <3e1780db-6e39-4508-8ce5-4d28771400e8@redhat.com>
Date: Fri, 24 Jan 2025 15:31:56 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 04/15] KVM: guest_memfd: Track mappability within a
 struct kvm_gmem_private
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
References: <20250117163001.2326672-1-tabba@google.com>
 <20250117163001.2326672-5-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250117163001.2326672-5-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 1/18/25 2:29 AM, Fuad Tabba wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Track whether guest_memfd memory can be mapped within the inode,
> since it is property of the guest_memfd's memory contents.
> 
> The guest_memfd PRIVATE memory attribute is not used for two
> reasons. First because it reflects the userspace expectation for
> that memory location, and therefore can be toggled by userspace.
> The second is, although each guest_memfd file has a 1:1 binding
> with a KVM instance, the plan is to allow multiple files per
> inode, e.g. to allow intra-host migration to a new KVM instance,
> without destroying guest_memfd.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   virt/kvm/guest_memfd.c | 56 ++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 51 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6453658d2650..0a7b6cf8bd8f 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -18,6 +18,17 @@ struct kvm_gmem {
>   	struct list_head entry;
>   };
>   
> +struct kvm_gmem_inode_private {
> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> +	struct xarray mappable_offsets;
> +#endif
> +};
> +
> +static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
> +{
> +	return inode->i_mapping->i_private_data;
> +}
> +
>   /**
>    * folio_file_pfn - like folio_file_page, but return a pfn.
>    * @folio: The folio which contains this index.
> @@ -312,8 +323,28 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +static void kvm_gmem_evict_inode(struct inode *inode)
> +{
> +	struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
> +
> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> +	/*
> +	 * .evict_inode can be called before private data is set up if there are
> +	 * issues during inode creation.
> +	 */
> +	if (private)
> +		xa_destroy(&private->mappable_offsets);
> +#endif
> +
> +	truncate_inode_pages_final(inode->i_mapping);
> +
> +	kfree(private);
> +	clear_inode(inode);
> +}
> +
>   static const struct super_operations kvm_gmem_super_operations = {
> -	.statfs		= simple_statfs,
> +	.statfs         = simple_statfs,
> +	.evict_inode	= kvm_gmem_evict_inode,
>   };
>   

As I understood, ->destroy_inode() may be more suitable place where the xarray is
released. ->evict_inode() usually detach the inode from the existing struct, to make
it offline. ->destroy_inode() is actually the place where the associated resource
(memory) is relased.

Another benefit with ->destroy_inode() is we're not concerned to truncate_inode_pages_final()
and clear_inode().


>   static int kvm_gmem_init_fs_context(struct fs_context *fc)
> @@ -440,6 +471,7 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>   						      loff_t size, u64 flags)
>   {
>   	const struct qstr qname = QSTR_INIT(name, strlen(name));
> +	struct kvm_gmem_inode_private *private;
>   	struct inode *inode;
>   	int err;
>   
> @@ -448,10 +480,19 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>   		return inode;
>   
>   	err = security_inode_init_security_anon(inode, &qname, NULL);
> -	if (err) {
> -		iput(inode);
> -		return ERR_PTR(err);
> -	}
> +	if (err)
> +		goto out;
> +
> +	err = -ENOMEM;
> +	private = kzalloc(sizeof(*private), GFP_KERNEL);
> +	if (!private)
> +		goto out;
> +
> +#ifdef CONFIG_KVM_GMEM_MAPPABLE
> +	xa_init(&private->mappable_offsets);
> +#endif
> +
> +	inode->i_mapping->i_private_data = private;
>   

The whole block of code needs to be guarded by CONFIG_KVM_GMEM_MAPPABLE because
kzalloc(sizeof(...)) is translated to kzalloc(0) when CONFIG_KVM_GMEM_MAPPABLE
is disabled, and kzalloc() will always fail. It will lead to unusable guest-memfd
if CONFIG_KVM_GMEM_MAPPABLE is disabled.

>   	inode->i_private = (void *)(unsigned long)flags;
>   	inode->i_op = &kvm_gmem_iops;
> @@ -464,6 +505,11 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>   	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>   
>   	return inode;
> +
> +out:
> +	iput(inode);
> +
> +	return ERR_PTR(err);
>   }
>   
>   static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,

Thanks,
Gavin


