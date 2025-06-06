Return-Path: <kvm+bounces-48643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A99CACFEF2
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 11:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B454418960F6
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 09:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3824F286425;
	Fri,  6 Jun 2025 09:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEm/Pa1a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8351DF739
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 09:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749201210; cv=none; b=dVMg3gsBLYuOzQmhHoYzYaFJYC0NClobV31tuZY6JIeq/clFus5kPGtNq9wu1tfGmNDGQY6RO7kW2a+AGPFcGwpFlZnQ9rtiMzxNpa7CeyR353unG7wFHGg2qCg1w37B7gmHJm3p1vNPqafIJH+XdT0yUsopcfLaegqXLRxcHJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749201210; c=relaxed/simple;
	bh=oLLKGGQ4tSqAoMigQ2L2VPl6XDUOE1/uPnz3KHo++6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D6jcSJ+VEzqoCdJoJm11ao7TEK8COnNwmRoojZgoHCmB2o2OoFc24Bc0C+ROeZXY5vAktb4AftnuI9gXtdqCxhCDca/51fA/MNtUBZE+WO014V692nAyZ7r8VARPuQ/car4BHLcV5q7d4LEldJjimgvqvFUrsz5AzwzUsolZmrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dEm/Pa1a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749201207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=trpRd5B08HnWP31E+E0BTqGeSxWoY25QYhH3JmM3Ps0=;
	b=dEm/Pa1a02qbcmJVbPOZolUF3f4hGWTYtrH+sIKHl0Fmn7MDeM3D3QTOe51KgNyJ5q+ku+
	rLnsig5quVyDLqfIUJ3SqgMlLly8GX3fcfOR5T+DhYoSIlFBB9msfU5Lx4WgXBJ3NIQbdl
	qLdMTlqCGwUpOfrs4s3viQC2tMRgzJQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-__Y477TZOvyZwZZghgQ9TQ-1; Fri, 06 Jun 2025 05:13:25 -0400
X-MC-Unique: __Y477TZOvyZwZZghgQ9TQ-1
X-Mimecast-MFC-AGG-ID: __Y477TZOvyZwZZghgQ9TQ_1749201204
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450d290d542so12228955e9.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 02:13:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749201204; x=1749806004;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=trpRd5B08HnWP31E+E0BTqGeSxWoY25QYhH3JmM3Ps0=;
        b=PvywsiLJ4ynyxcQKjT052NFmq0kLDBXwxBmF17C6KfH5rhzGlY3kEj3mRTmIIcXAFg
         9e7LsuJYZpudg4L2w18iFaJI6RMTFasMYzpue8jOE7qGAOghF5JDdT3sUOGWriTn27Vp
         56QXc8Ks19/M1vEi/WouqD1rPaQ/n3CCgjlopUE6TGzRDnZvi+876YWBe2/07z/hvTOe
         K2FhtXlEW9oFZ8MjsrqTqPi66bZwA+rsEJdclPs5hYOOsYleMjoGGB5VuoQpfSy4KTDk
         Um0fRMvTeoZ14gIf//mI8ZNP4Bly4JnI84gOY20FJtDBJc0C+gQWqIE6M3y4W9yhoirS
         1Yvw==
X-Forwarded-Encrypted: i=1; AJvYcCVkWJztE43oEAHMjgVC3ACBauKaQK73q18wP9Yx/jKu35TlmL3TDicnfCcHBG6jo46GAhY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXrLnhwBPjdlXae2zCa+gRX0XPYwweoLxNivyylUK5yFeeAMjg
	neQkmPKx6feHoYUX+wh3fK9XgCBc74bV6vcOR0jcxWTYx4KWSP2qpUkI/wwtlt9wX3E3AWQdMJi
	98Dg/Vsz6VFXyo/nz4GgEEAKooIos41lYRE7WjcWabAIpJBUlttrHzQ==
X-Gm-Gg: ASbGncsKyfqg042ac91+1NAdVghnRSpkq8rRmf/H1nV4dZViufcDKTGFJKEeAFSv4OG
	ZH0dD9tFp51tp+RXEcN4VJA3M31oxF7OKTxctZ0WgilP3mUfpHeVPhmcGUW4ipXiMrR2Uvhot56
	iCz4crMxvfXl3ZJGceKd9Gb1v8Q1ntZzvga7G6DVJl3tBsG/bN2nJMZWiIbRo+6ExPsWs7CqGmL
	TQfSQNILybq1amnTSRduwrU2TnCWYAGySul65kRdTdw7iHkHgOslniSeE6mNZSxL62zJjKfvgT0
	Y4gSCiynCZBMo/be/y6hJE5HcAwHYOA86rifuEJJOh8JArcu6gGqxgAC6KTjquIY8+3Y8ZtVOui
	MBSgJh5O/7xDKcL7X5QnE6lSbiHJ18FHN5KV5EKLjlw==
X-Received: by 2002:a7b:c5d1:0:b0:450:d3b9:a5fc with SMTP id 5b1f17b1804b1-4520151ecb2mr17607595e9.27.1749201204357;
        Fri, 06 Jun 2025 02:13:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCx3ozeCH5PMCl4QVRqB5j1omu5YUwl+bfLbCrxZ+hhVe5uqkolI7tiCY9D5C7MuGSpT97bQ==
X-Received: by 2002:a7b:c5d1:0:b0:450:d3b9:a5fc with SMTP id 5b1f17b1804b1-4520151ecb2mr17607275e9.27.1749201203912;
        Fri, 06 Jun 2025 02:13:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:9c00:568:7df7:e1:293d? (p200300d82f199c0005687df700e1293d.dip0.t-ipconnect.de. [2003:d8:2f19:9c00:568:7df7:e1:293d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-452730d1636sm14094965e9.38.2025.06.06.02.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 02:13:23 -0700 (PDT)
Message-ID: <79dcd7b3-f0f3-453d-9c9f-746ebbe81ad2@redhat.com>
Date: Fri, 6 Jun 2025 11:13:20 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 09/18] KVM: guest_memfd: Track shared memory support
 in memslot
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-10-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250605153800.557144-10-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.06.25 17:37, Fuad Tabba wrote:
> Add a new internal flag in the top half of memslot->flags to track when
> a guest_memfd-backed slot supports shared memory, which is reserved for
> internal use in KVM.
> 
> This avoids repeatedly checking the underlying guest_memfd file for
> shared memory support, which requires taking a reference on the file.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


