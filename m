Return-Path: <kvm+bounces-48381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D998DACDA71
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 11:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A39CD176688
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 09:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3320828C001;
	Wed,  4 Jun 2025 09:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QC3n0Khp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D4618C03F
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 09:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749027646; cv=none; b=gAnYe0oPH7gFkUWqJwhvcdW8LeEzNaijiNIr96+6tC+jHYO/yrbXPyqw2X0lv4oEwT62Byu6VsV5KInNMNyniZ72sFGguM82nBQoAs8hsZ/jVcNCefpkQkoMULzK44GBowZom+AWQJmSdd9t9LA4RAPAw/kJIpei59AGsWwFZhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749027646; c=relaxed/simple;
	bh=sFDPx9PnIyChyotF3uSxA9GPbPhQSr+kEJuQAkIqOL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tyFnIap8KrHKxKh1vst2NGQ79qf3KIsxAv4tMyyzmFzkQHErf3wicf7+bGODTMskxWkAnX7OK0NTLqXNC39x3EZHgnxcptWJ3kv97LRVCQ7uw8UlUczdVHnh4o6oZB2pFEm2SX7z+pEQKACFEX/37knxIqZnl91IABoYlAk5oGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QC3n0Khp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749027643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I1MGX4dUL85emYMb1ED5ErxsocvR1puK9Nem0HjGHKw=;
	b=QC3n0Khp1OAHeIzBdLl3hlsALPgyXz/mWbdha8e8nUwjY7gZplo2jjZQpweHnfWp8gCdnQ
	rEaKVCKd9p67gErHpErDQ3OPfH4hc6c/7upr8ekj/tKLB9IWCMDFgf/QsnuuhOMt7hxtST
	dgYaosxv2GMauh0KlRWK/fkzz9q0uV8=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-LM8nxwlOMVaGhPLKYX9Ahw-1; Wed, 04 Jun 2025 05:00:41 -0400
X-MC-Unique: LM8nxwlOMVaGhPLKYX9Ahw-1
X-Mimecast-MFC-AGG-ID: LM8nxwlOMVaGhPLKYX9Ahw_1749027641
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b26e0fee459so558767a12.1
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 02:00:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749027641; x=1749632441;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I1MGX4dUL85emYMb1ED5ErxsocvR1puK9Nem0HjGHKw=;
        b=Kad1ia6j9IgABxpZ6MhWhJXWdU44gFGo/EHOSAjp/jIgFRdDTUzG89G+3yl6iwXg48
         LxCYbIb5rWJoqEmTem0dCLXrqQe9+YKz9BQhkHqq3aGi9sCY33q6KfLpnBFU3IPGU3A+
         7UhPo3jpe0oSLNOZmfYptvQWi9E4aUWGhKYVy0VsSjQqtABAjD29kYxWIT1wD6gKEyT3
         +L3mxF4+zDlpfNMCK4v86t8GKHwFec6rGsGFdH+78Ghi3iMJcgvsrRWFIVlz/DrEvBHS
         XGLrFdcpRf36svi6+7fPaHCPPAKwQ8H5N/4wuuheH4BueOGReDHtHYcJKp3dorjdoN9o
         RGKA==
X-Forwarded-Encrypted: i=1; AJvYcCXmMecDwGUgz/pXLlIU0llMH1m4+dulTmGCznDRRrbwlhJEte/rZDO4Qzc/JUADh5Ffe0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbF7RL4U+4tb8fP0IVCG7HJPR5tJbJLGB1UFhNnLINAQJtB77L
	+X+YVV0neUF9MgbocEG+Q3roWdngRkuVetdrp0afsffmZsAsI/pv2mj9j/2qWSGbH/DK7Y4viAT
	J3PKlyKHDn7gTg/6IK4U/n+Trv3/okv5xfiAum/GpysdKXwVSGae6uw==
X-Gm-Gg: ASbGnctuZLHRMGT5jN3q83kp+H5ajZ7YsKO6JUwcDNewJeJ89SRLWGktPKExKWojdHK
	f4XHLLQMoxoNsob+v6+arTACldI40obsV7GVFP0O7MjFgBui4h8OeLC8UWUg+vIS0c5xy3mr8D8
	bthPAmQXJG9Btd8fzTV8ds/Z03jaD0wEclXJ3o+piuXn1iuwjXK9Ra4jHKG3ppbn9ryuFmC7YXZ
	7nKjhTybSnGRbhmWzHAXuYYvZSUWAxbxj2CiX2rF/5659FbGjuAfuX6RzPPBXBerkxl6llzIpGF
	NevzHa31JXX95F+UqkV8Upf2Qo7JCu1OpeGpB3i84PcEZERAT9Y=
X-Received: by 2002:a05:6a21:a4c9:b0:1f3:26ae:7792 with SMTP id adf61e73a8af0-21d2275affamr3281370637.18.1749027640787;
        Wed, 04 Jun 2025 02:00:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtTWWeA9jam1fT8PmW5xs6BajYthggeHnemnm+gzA3QybPaPwl9UDtfWtk6pB2dDDU19J7fA==
X-Received: by 2002:a05:6a21:a4c9:b0:1f3:26ae:7792 with SMTP id adf61e73a8af0-21d2275affamr3281298637.18.1749027640329;
        Wed, 04 Jun 2025 02:00:40 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-747afe9670bsm10688114b3a.30.2025.06.04.02.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 02:00:39 -0700 (PDT)
Message-ID: <56a7b265-a863-43cb-b119-372673bb0e26@redhat.com>
Date: Wed, 4 Jun 2025 19:00:18 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/16] KVM: Fix comment that refers to kvm uapi header
 path
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
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-8-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250527180245.1413463-8-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/25 4:02 AM, Fuad Tabba wrote:
> The comment that refers to the path where the user-visible memslot flags
> are refers to an outdated path and has a typo. Make it refer to the
> correct path.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/kvm_host.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


