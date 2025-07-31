Return-Path: <kvm+bounces-53783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B57A6B16D87
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8027318C63CD
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF7629CB52;
	Thu, 31 Jul 2025 08:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Edi1L5nW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A027241670
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753950583; cv=none; b=K7XAKkjVW7cZRT7JjVnz3TK7O468+3ziwzrAkr+Cnea5lCdOp4/kEM50+S+2Nk93XN+JuD1lXqoyFl3hi5jnfbqXELfg8xOxynrFE+KJDwIDrqTOUbYRS9YajsDcpTpxM5T288e479b+WJISdgB2klGrupeDML9ZtobBUomUiuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753950583; c=relaxed/simple;
	bh=AMsJabH4uTEQwdU7p1aCd3u4s3N0oQl/CFz7UNeKcEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWpL5Gkff8A90IgjEbAVHO1qoZyQp9r/C9BHxqV5AAL6AkOyaZADEk8+pVnC6B9XMfq6oKvC4Tw8igVGVzfhfkHizc7RDIui7M7o10+fMwrNO5EX5DN/wpEFFEmZIytyY3Ys12aD/tyrOrPwfIlya7BI83kLNsB/Lii/YM3UB/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Edi1L5nW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753950581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UOsdViaGVxWnczW9b3BcwanE5/c/ybe0wyeENLeFccE=;
	b=Edi1L5nWKGBGarRnOxdBeBs3GVBF2LynlKQmMiWTlbgPPBqQIZ9at06BGe0g3tyiCBWMa0
	Ry4MaEDedwHQFaRsQE4YnVFxYHuWj0FvSuDBhqVh6ibwXIuMF+UJT3JKLmB11G9kDdSyFh
	OQD5HC68JZEhR1EJKwsgVpLDfiHf0mo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-1wcgokINPfqECNUPq_2M8w-1; Thu, 31 Jul 2025 04:29:38 -0400
X-MC-Unique: 1wcgokINPfqECNUPq_2M8w-1
X-Mimecast-MFC-AGG-ID: 1wcgokINPfqECNUPq_2M8w_1753950577
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7889c8d2bso55182f8f.3
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:29:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753950577; x=1754555377;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UOsdViaGVxWnczW9b3BcwanE5/c/ybe0wyeENLeFccE=;
        b=PN1BB1xKy4v4PZ4lrWxLfhSYqbVGyOggOG1m/DQJW2m30ZKrMeYWVLgILsxO+eEhEC
         HG1NzbhgSioqo6+QbgOHjgKex05VQ1JZI1upy+hBHD4bfFzo3by3FEOHcnMp204VG1f6
         WbAMGbLE6CyiLNxhlJ+Fe6Qxt+xXaWK+nPDh/wPI3KUrrZ2DCdkSR3D5OFQEHcjqkpB7
         usX17j2gZiqX8hhdH++zHNjn+ZKiDzkmx+syXuzQ1WxDq78nuJFoWGJyoNim24XiHfMY
         rv9oZZZhCmxHNVi0n0HXHMJSr/y91xm8UD8QUh2TrtBolot+/xRDDuMxzrEGVI965Vq+
         Om6A==
X-Forwarded-Encrypted: i=1; AJvYcCVMdoiWt8WCFmaTtnSjFo5BNJg11NklKeQvOL5PHLqRK5bOpZdtn+eoxdAOk+WvqxmLcM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCwQGnFA8Lt3zIzIpp0YP4x1IbdKZOhhdXUuE+op0xZGpOZgNp
	tqMhDKob0z2iUAjsVD93qt5F4ckO0u0CK01ySweB7SnYmTKRePQjYC/n8M5FeIe96qTftiAB4f9
	fr9sTi1FlvIdfUXC3Pqbd89282yKEw3vdBfU4dwQERlAo2tY6IBVknw==
X-Gm-Gg: ASbGncuJ1f9Bmg1Gp9xxT49oix9mJGcQXZsknfH430M/n+cUuh4vE2nzMF8jxsG7sCi
	2hVKaqN7tuG+/bk/7Ux1UmuTgEu1UBzRwbORgqrjRSez6aI2+FZVJPkYG1JJbdw6Z05inKSuznJ
	8o1FfzuNX6knmjUFrS0lVnfP+gzyrX1bC5u/FPlfsU+iPQpSrIuv6NghGIxHsTgigQ9vKlFVo6b
	srLkQXNv07PULhQry2SbUL3vuVGs58sZD83ntCC++G+WYT7TD+OMd+zJX9N3C/rWxM4qIW+F6G7
	A9MTKW6nxVdEpEyMR039H+ueWw9FFWaXvWkSh6lFCMHTsKgLYzV6fZP/WVrzqQeBLk58qBsVKN7
	QhYvrEkK9sFTRtxpgeqb+2otkSHtSE6JBUFptc+cp4GfEFtJHLIpR59HPbMVoZZmaIuw=
X-Received: by 2002:a05:6000:24c9:b0:3b7:9c88:daac with SMTP id ffacd0b85a97d-3b79c88dbc7mr1204232f8f.53.1753950576907;
        Thu, 31 Jul 2025 01:29:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHD9vjWTXx6+eu57zSZvMsNC7w4A10Bd7geesiciB9rOpCXqiI0Bh3Cw4/xj0sZFbPQ7RH2cA==
X-Received: by 2002:a05:6000:24c9:b0:3b7:9c88:daac with SMTP id ffacd0b85a97d-3b79c88dbc7mr1204197f8f.53.1753950576339;
        Thu, 31 Jul 2025 01:29:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm1588913f8f.18.2025.07.31.01.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:29:35 -0700 (PDT)
Message-ID: <c320b7a3-bf75-4f9e-bd72-4290fd9fe9d9@redhat.com>
Date: Thu, 31 Jul 2025 10:29:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 12/24] KVM: x86/mmu: Rename
 .private_max_mapping_level() to .gmem_max_mapping_level()
To: Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>,
 James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-13-seanjc@google.com>
 <CA+EHjTwuXT_wcDAOwwKP+yBetE9N46QMb+hUKAOsxBVkkOgCTw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CA+EHjTwuXT_wcDAOwwKP+yBetE9N46QMb+hUKAOsxBVkkOgCTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31.07.25 10:15, Fuad Tabba wrote:
> On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>>
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Rename kvm_x86_ops.private_max_mapping_level() to .gmem_max_mapping_level()
>> in anticipation of extending guest_memfd support to non-private memory.
>>
>> No functional change intended.
>>
>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> Co-developed-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
> 
> nit: remove my "Signed-off-by", since I'm not a co-developer, and instead:

The patch went "through your hands", right? In that case, a SOB is the 
right thing to do.

"The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path."

-- 
Cheers,

David / dhildenb


