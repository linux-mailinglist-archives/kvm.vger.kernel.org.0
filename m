Return-Path: <kvm+bounces-48632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99745ACFD9A
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 09:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB06A3AECF8
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 07:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4044B283FF9;
	Fri,  6 Jun 2025 07:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YhbryYie"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8631D90DF
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 07:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749195587; cv=none; b=ZcxqvTHF87+ayfu7gBl9Z7O22mU1Evt0xJERmhWUDIRgxcYMejA1FHr8D2jYMJGZYBmFD/RpL10jPb85+Dy3+LaMTPOB5nYLwtXDJsVwq51nGwCZIEooN6bRgzbleMvniAbfI8NhP2bG/skfUCuo8O7VNyglsTVytZlt0xT4MVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749195587; c=relaxed/simple;
	bh=QoZNOQS/nuMoFaz3Fo6sQP6Ftu/HZXyLmxX8M70vHg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nq7KKXXFf7IemGSvf/XpwRUMf1W8UsLurcPaP92BlwyoEEEnLInBqC4NbjFtpuMvchNm162V7dn1JeVBPsFfybfynyCmCaIzmtE4vWb35/BgUBvFpPLk0B6Iq9mvEmozhYqC5Pc3EP0ZMD6Y+yty2+4QnHKgQnXJ1w2nxnkpd1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YhbryYie; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749195584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BhoJzWHa5XwXWl7HUhWJWFpdgqG5BG+tce/0LfTOW0Q=;
	b=YhbryYiei8tGDxDXqjhlUe6heDQlxoHH5tuoan9RdgAsX/8qccplxM2JraZ0xOP1IFlYI0
	40crGZqdDB0cK6pVwWdBs7IHNpf99dnrNQUS3TVC2EEHYodaVAq0RKYYnvVJAQZrgTxvfT
	ywNLkkFPDSYo/IDMJ4eR6o1+wJo0LVw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-Fr-FitTDPBuWSmuBC_bwUQ-1; Fri, 06 Jun 2025 03:39:42 -0400
X-MC-Unique: Fr-FitTDPBuWSmuBC_bwUQ-1
X-Mimecast-MFC-AGG-ID: Fr-FitTDPBuWSmuBC_bwUQ_1749195581
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f6ba526eso1131514f8f.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 00:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749195581; x=1749800381;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BhoJzWHa5XwXWl7HUhWJWFpdgqG5BG+tce/0LfTOW0Q=;
        b=DBhMJN1lE24+YZax+nLH1mrTeMY/t+9ZAU24QEQO6CaocPXjSQiRUlGU/+cMDPHm0/
         Ryo1VkqI/cz0fgQ25gvMhz4vX642GDhQkaqWLegKzCGGJX16Lt1hYw+6r31VyHYzsPO3
         pYhAoyy2dEWxoxsT+u3JpZffiVX9+/PRPDCw0gm8Aaz/lqwLLkhDuuP72qyR1k2L0ivd
         wShf0KE5RuTns1pf35lfagaHQCm+9EGE2fbJR/bqS+AuD4lbJ2d+dQIpSpXAMUGO62xn
         rO5osU47fDL+sfPVJmeTabBoKO88+fzam+1KdNn02k8niaH0QsdQT/HkX9NfuPitMq40
         Di+w==
X-Gm-Message-State: AOJu0YwcJyyA5ZOGiGnjk960kqM+45mZM68OU0WpNZm3QL6xYvlcnMal
	NXzl6KXzUSZ3okEWpY1C5J5zAtwXsxXZq7Zu25IqYWQbH3wrBDqH++man3d0sKPk/7bbfoGr6La
	qwLvt9zrHbizAdD5Z1spgWlcSP6g8w/+cC2B0hw6JmGRHggSIsWOq1g==
X-Gm-Gg: ASbGncsDDwrMDS1KxhTjGr8RhF3U7zvtSa5VQXuA3f5+oK4ZsW5pYbNzzT7MaPDTds/
	kTyWXmWcSVu66msHZRT19rQCv/xfjQV/3onxsQaof3n8cK8OP0O1oq0V3JhSVw+D2oFrKkWMYrG
	6vkc/956+V8k9F8kTTV1WGxibUCKw0ZMqWEJxwaKajcGzddUUUuLLtjAiUr6VTx36m9rR+IbU1o
	RWFv5hXPhqgd8zrmkSX2uJ8QxuVLOZ5GYMOoavdB+/8A8WZbk+YRi0NYP1kzDaAmwjBHUBJngIo
	fsa21X6dm7RV2V4iVLBcc8N4LLpeVNjjqPttuQ+t/p+gGYnaQ+q0fw==
X-Received: by 2002:a05:6000:250e:b0:3a3:6e85:a529 with SMTP id ffacd0b85a97d-3a531cb0cf0mr1786810f8f.51.1749195581384;
        Fri, 06 Jun 2025 00:39:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQs3qBLN6k4wLm64IaAd8R7wbKaspOFAjP47G4ujPD9jlSn5dBnR4N+GY2+13VYJrGQffTqg==
X-Received: by 2002:a05:6000:250e:b0:3a3:6e85:a529 with SMTP id ffacd0b85a97d-3a531cb0cf0mr1786778f8f.51.1749195580929;
        Fri, 06 Jun 2025 00:39:40 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a6a5.dip0.t-ipconnect.de. [87.161.166.165])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a53229da18sm1116872f8f.19.2025.06.06.00.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 00:39:40 -0700 (PDT)
Message-ID: <b247be59-c76e-4eb8-8a6a-f0129e330b11@redhat.com>
Date: Fri, 6 Jun 2025 09:39:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Fuad Tabba <tabba@google.com>, James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, peterx@redhat.com,
 pankaj.gupta@amd.com, ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-15-tabba@google.com>
 <CADrL8HVtsJugNRgzgyiOwpOtSAi4iz3LNcjt8kDinUp99jWyYw@mail.gmail.com>
 <CA+EHjTx-RKrn5Bwi9daTx-VAHLLxPpjo+wYMhi9MysWtvsM97w@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTx-RKrn5Bwi9daTx-VAHLLxPpjo+wYMhi9MysWtvsM97w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>> +       write_fault = kvm_is_write_fault(vcpu);
>>> +       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
>>> +
>>> +       if (write_fault && exec_fault) {
>>> +               kvm_err("Simultaneous write and execution fault\n");
>>> +               return -EFAULT;
>>> +       }
>>> +
>>> +       if (is_perm && !write_fault && !exec_fault) {
>>> +               kvm_err("Unexpected L2 read permission error\n");
>>> +               return -EFAULT;
>>> +       }
>>
>> I think, ideally, these above checks should be put into a separate
>> function and shared with user_mem_abort(). (The VM_BUG_ON(write_fault
>> && exec_fault) that user_mem_abort() does seems fine to me, I don't see a
>> real need to change it to -EFAULT.)
> 
> I would like to do that, however, I didn't want to change
> user_mem_abort(), and regarding the VM_BUG_ON, see David's feedback to
> V10:
> 
> https://lore.kernel.org/all/ed1928ce-fc6f-4aaa-9f54-126a8af12240@redhat.com/

Worth reading Linus' reply in [1], that contains a bit more history on 
BUG_ON() and how it should not be used. (VM_BUG_ON we'll now likely get 
rid of completely)

[1] https://lkml.kernel.org/r/20250604140544.688711-1-david@redhat.com

-- 
Cheers,

David / dhildenb


